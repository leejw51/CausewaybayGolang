-- Join a numbered English dump (tools/dump_strings.lua) with a numbered
-- translation file into a patch for tools/merge_lang.lua:
--
--   luajit tools/fill_lang.lua /tmp/py_en.tsv /tmp/py_zh.tsv > /tmp/patch_zh.lua
--   luajit tools/merge_lang.lua zh /tmp/patch_zh.lua
--
-- Both files are TSV: number, tab, text, with \n \t \\ escapes. A
-- translation of just "=" means "same as the English" (code with no
-- comment to translate). Numbers missing from the translation file are
-- reported and left out, so the patch is always complete for what it holds.

local enPath, trPath = ...
if not enPath or not trPath then
  io.stderr:write("usage: luajit tools/fill_lang.lua <english.tsv> <translation.tsv>\n")
  os.exit(2)
end

local function unescape(s)
  return (
    s:gsub("\\(.)", function(c)
      if c == "n" then
        return "\n"
      elseif c == "t" then
        return "\t"
      end
      return c
    end)
  )
end

local function readTsv(path)
  local f = assert(io.open(path, "rb"))
  local rows = {}
  for line in f:lines() do
    local n, text = line:match("^(%d+)\t(.*)$")
    if n then
      rows[tonumber(n)] = unescape(text)
    end
  end
  f:close()
  return rows
end

local en = readTsv(enPath)
local tr = readTsv(trPath)

local function quote(s)
  s = s:gsub("\\", "\\\\"):gsub("\n", "\\n"):gsub("\r", "\\r"):gsub("\t", "\\t")
  if s:find('"', 1, true) and not s:find("'", 1, true) then
    return "'" .. s .. "'"
  end
  return '"' .. s:gsub('"', '\\"') .. '"'
end

local keys = {}
for n in pairs(en) do
  keys[#keys + 1] = n
end
table.sort(keys)

local missing, written = {}, 0
print("return {")
print("  add = {")
for _, n in ipairs(keys) do
  local t = tr[n]
  if t == nil or t == "" then
    missing[#missing + 1] = n
  else
    if t == "=" then
      t = en[n]
    end
    print("    [" .. quote(en[n]) .. "] = " .. quote(t) .. ",")
    written = written + 1
  end
end
print("  },")
print("}")
io.stderr:write(written .. " translations")
if #missing > 0 then
  io.stderr:write(", " .. #missing .. " missing: " .. table.concat(missing, " "))
end
io.stderr:write("\n")
