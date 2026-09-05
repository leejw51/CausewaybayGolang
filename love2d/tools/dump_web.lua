-- Dump every quest, street, blank and UI string as one JSON file for the web
-- build (../typescript). LÖVE is never loaded: src/quests.lua, src/data*.lua
-- and src/i18n.lua are plain tables, so luajit can read them straight.
--
--   luajit tools/dump_web.lua ../typescript/public/data/game.json
--
-- The shape is the Lua shape, unchanged: a translated field stays the
-- { en =, ko =, yue = } table the game reads, and the by-English tables of
-- src/lang/*.lua ride along under "tr". The web build looks a string up the
-- same way LÖVE does, so a translation added here needs no second edit there.

package.path = "./?.lua;" .. package.path

local out = ... or "../typescript/public/data/game.json"

local Quests = require "src.quests"
local I18n = require "src.i18n"

-- Fields that are lists even when they are empty. Lua cannot tell {} apart
-- from an empty object and the Rust side is typed, so the encoder is told.
local ARRAY = {
  maps = true,
  stages = true,
  npcs = true,
  accept = true,
  quests = true,
  tracks = true,
  langs = true,
}

local ESC = {
  ['"'] = '\\"',
  ["\\"] = "\\\\",
  ["\b"] = "\\b",
  ["\f"] = "\\f",
  ["\n"] = "\\n",
  ["\r"] = "\\r",
  ["\t"] = "\\t",
}

local function esc(s)
  return (s:gsub('[%c"\\]', function(c)
    return ESC[c] or string.format("\\u%04x", c:byte())
  end))
end

local buf = {}
local function put(s)
  buf[#buf + 1] = s
end

local enc

-- Sorted keys, so two runs of the same data produce the same bytes and a
-- regenerated file shows up in a diff only when the game changed.
local function keys(t)
  local ks = {}
  for k in pairs(t) do
    if type(k) == "string" then
      ks[#ks + 1] = k
    end
  end
  table.sort(ks)
  return ks
end

local function encArray(t)
  put("[")
  for i = 1, #t do
    if i > 1 then
      put(",")
    end
    enc(t[i])
  end
  put("]")
end

local function encObject(t)
  put("{")
  local ks = keys(t)
  for i, k in ipairs(ks) do
    if i > 1 then
      put(",")
    end
    put('"' .. esc(k) .. '":')
    enc(t[k], k)
  end
  put("}")
end

enc = function(v, key)
  local ty = type(v)
  if v == nil then
    put("null")
  elseif ty == "boolean" then
    put(tostring(v))
  elseif ty == "number" then
    put(string.format("%.14g", v))
  elseif ty == "string" then
    put('"' .. esc(v) .. '"')
  elseif ty == "table" then
    if ARRAY[key] or #v > 0 then
      encArray(v)
    else
      encObject(v)
    end
  else
    put("null")
  end
end

local quests = {}
for i, q in ipairs(Quests) do
  quests[i] = {
    id = q.id,
    track = q.track,
    tag = q.tag,
    station = q.station,
    name = q.name,
    goal = q.goal,
    win = q.win,
    maps = q.maps,
  }
end

local langNames = {}
for _, code in ipairs(I18n.LANGS) do
  langNames[code] = I18n.NAMES[code]
end

local doc = {
  langs = I18n.LANGS,
  langNames = langNames,
  strings = I18n.STRINGS,
  tr = I18n.TR,
  tracks = Quests.TRACKS,
  quests = quests,
}

enc(doc)

local body = table.concat(buf)
local fh = assert(io.open(out, "wb"))
fh:write(body)
fh:close()

local streets, blanks = 0, 0
for _, q in ipairs(quests) do
  streets = streets + #q.maps
  for _, m in ipairs(q.maps) do
    blanks = blanks + #m.stages
  end
end
io.stderr:write(
  string.format("  %s  %d quests, %d streets, %d blanks, %.1f MB\n", out, #quests, streets, blanks, #body / 1048576)
)
