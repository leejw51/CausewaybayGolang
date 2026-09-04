-- Merge translations into src/lang/<code>.lua without LÖVE:
--
--   luajit tools/merge_lang.lua <code> <patch.lua> [more patches]
--
-- A patch file returns { add = { ["English"] = "translation", ... },
-- rename = { ["old English"] = "new English", ... } }. `rename` moves an
-- existing entry to a new key when the English source text changed. The
-- file is rewritten sorted, keys escaped the way the existing files are.
--
-- Refuses a translation that drops or adds a ___ / %s / %d placeholder, and
-- warns about characters the fonts have never had to draw (see the test
-- "the fonts cover every language").

package.path = "./?.lua;" .. package.path

local code, patches = ..., { select(2, ...) }
if not code or #patches == 0 then
  print("usage: luajit tools/merge_lang.lua <code> <patch.lua> [more]")
  os.exit(2)
end

local path = "src/lang/" .. code .. ".lua"
local HEADERS = {
  zh = "Simplified Chinese",
  ja = "Japanese",
  es = "Spanish",
  cs = "Czech",
}

local function load(p)
  local chunk, err = loadfile(p)
  if not chunk then
    error(p .. ": " .. tostring(err))
  end
  return chunk()
end

local ok, existing = pcall(load, path)
if not ok then
  print("no " .. path .. " yet, creating it")
  existing = {}
end

-- every character any language already draws: new ones are worth a look
local seenChars = {}
local function noteChars(s)
  for ch in tostring(s):gmatch("[%z\1-\127\194-\244][\128-\191]*") do
    seenChars[ch] = true
  end
end
for _, c in ipairs({ "zh", "ja", "es", "cs" }) do
  local okc, t = pcall(load, "src/lang/" .. c .. ".lua")
  if okc and type(t) == "table" then
    for k, v in pairs(t) do
      noteChars(k)
      noteChars(v)
    end
  end
end
for _, m in ipairs({ "src/data.lua", "src/data_adv.lua", "src/data_pro.lua", "src/data_quiz.lua", "src/i18n.lua" }) do
  local f = io.open(m, "rb")
  if f then
    noteChars(f:read("*a"))
    f:close()
  end
end

local function count(s, tok)
  local _, n = s:gsub(tok, "")
  return n
end

local errors, newChars = 0, {}
local function put(en, tr)
  if type(en) ~= "string" or type(tr) ~= "string" then
    print("ERROR non-string entry: " .. tostring(en))
    errors = errors + 1
    return
  end
  if tr == "" then
    print("ERROR empty translation for: " .. en:sub(1, 60))
    errors = errors + 1
    return
  end
  for _, tok in ipairs({ "___", "%%s", "%%d" }) do
    if count(en, tok) ~= count(tr, tok) then
      print("ERROR placeholder " .. tok:gsub("%%%%", "%%") .. " mismatch: " .. en:sub(1, 60))
      errors = errors + 1
      return
    end
  end
  for ch in tr:gmatch("[%z\1-\127\194-\244][\128-\191]*") do
    if not seenChars[ch] then
      newChars[ch] = (newChars[ch] or 0) + 1
    end
  end
  existing[en] = tr
end

for _, p in ipairs(patches) do
  local patch = load(p)
  if type(patch) ~= "table" then
    error(p .. " must return a table")
  end
  for old, new in pairs(patch.rename or {}) do
    if existing[old] ~= nil then
      local tr = existing[old]
      existing[old] = nil
      if patch.add and patch.add[new] then
        -- the patch supplies the fresh translation; drop the stale one
      else
        put(new, tr)
      end
    end
  end
  local n = 0
  for en, tr in pairs(patch.add or {}) do
    put(en, tr)
    n = n + 1
  end
  print(string.format("%s: %d entries", p, n))
end

local function quote(s)
  s = s:gsub("\\", "\\\\"):gsub("\n", "\\n"):gsub("\r", "\\r"):gsub("\t", "\\t")
  if s:find('"', 1, true) and not s:find("'", 1, true) then
    return "'" .. s .. "'"
  end
  return '"' .. s:gsub('"', '\\"') .. '"'
end

local keys = {}
for k in pairs(existing) do
  keys[#keys + 1] = k
end
table.sort(keys)

local out = {}
out[#out + 1] = "-- " .. (HEADERS[code] or code) .. ", keyed by the English string it translates."
out[#out + 1] = "-- Generated from the data files (tools/missing_strings.lua + tools/merge_lang.lua);"
out[#out + 1] = "-- src/i18n.lua looks a string up here when a { en = , ko = , yue = } table has"
out[#out + 1] = "-- no `" .. code .. "` of its own."
out[#out + 1] = ""
out[#out + 1] = "return {"
for _, k in ipairs(keys) do
  out[#out + 1] = "  [" .. quote(k) .. "] = " .. quote(existing[k]) .. ","
end
out[#out + 1] = "}"
out[#out + 1] = ""

if errors > 0 then
  print(string.format("%d error(s); %s not written", errors, path))
  os.exit(1)
end

local f = assert(io.open(path, "wb"))
f:write(table.concat(out, "\n"))
f:close()

local list = {}
for ch, n in pairs(newChars) do
  list[#list + 1] = ch .. "(" .. n .. ")"
end
table.sort(list)
if #list > 0 then
  print("warn  characters the fonts have not drawn before: " .. table.concat(list, " "))
end
print(string.format("%s: %d strings", path, #keys))
