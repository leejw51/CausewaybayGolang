-- List the English strings a src/lang/<code>.lua file does not translate yet,
-- as a patch skeleton for tools/merge_lang.lua:
--
--   luajit tools/missing_strings.lua zh src/data_rs.lua src/i18n.lua > patch_zh.lua
--
-- Walks every { en = , ko = , yue = } table in the given modules (a data file
-- returns its maps; src/i18n.lua is walked through I18n.STRINGS).

package.path = "./?.lua;" .. package.path

local code = ...
local mods = { select(2, ...) }
if not code or #mods == 0 then
  io.stderr:write("usage: luajit tools/missing_strings.lua <code> <module.lua> [more]\n")
  os.exit(2)
end

local okT, tr = pcall(dofile, "src/lang/" .. code .. ".lua")
if not okT or type(tr) ~= "table" then
  tr = {}
end

local strings, seenEn = {}, {}
local function walk(v, seen)
  if type(v) ~= "table" or seen[v] then
    return
  end
  seen[v] = true
  if type(v.en) == "string" then
    if not seenEn[v.en] then
      seenEn[v.en] = true
      strings[#strings + 1] = v.en
    end
    return
  end
  for _, child in pairs(v) do
    walk(child, seen)
  end
end

for _, m in ipairs(mods) do
  local t = dofile(m)
  if m:match("i18n%.lua$") then
    t = t.STRINGS
  end
  walk(t, {})
end

local function quote(s)
  s = s:gsub("\\", "\\\\"):gsub("\n", "\\n"):gsub("\r", "\\r"):gsub("\t", "\\t")
  if s:find('"', 1, true) and not s:find("'", 1, true) then
    return "'" .. s .. "'"
  end
  return '"' .. s:gsub('"', '\\"') .. '"'
end

local missing = {}
for _, en in ipairs(strings) do
  if tr[en] == nil then
    missing[#missing + 1] = en
  end
end

print("-- " .. #missing .. " of " .. #strings .. " strings still missing in " .. code)
print("return {")
print("  add = {")
for _, en in ipairs(missing) do
  print("    [" .. quote(en) .. "] = " .. quote("") .. ",")
end
print("  },")
print("}")
