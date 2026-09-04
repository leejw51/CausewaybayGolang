-- Dump every English string of one or more data files (or src/i18n.lua) in a
-- stable order, numbered, one per line, for a translator:
--
--   luajit tools/dump_strings.lua zh src/data_py.lua > /tmp/py_en.tsv
--
-- Only strings the given language file does not translate yet are listed.
-- The output is TSV: number, tab, English with \n for newlines. A translator
-- fills a second TSV with the same numbers and the translations, and
-- tools/fill_lang.lua joins the two into a patch for tools/merge_lang.lua.
--
-- Unlike tools/missing_strings.lua this walks the data in a fixed field
-- order (maps in order; name, title, lesson, story, speaker, npc lines;
-- then per stage q, code, hint, ok), so the numbers mean the same thing on
-- every run.

package.path = "./?.lua;" .. package.path

local code = ...
local mods = { select(2, ...) }
if not code or #mods == 0 then
  io.stderr:write("usage: luajit tools/dump_strings.lua <code> <module.lua> [more]\n")
  os.exit(2)
end

local okT, tr = pcall(dofile, "src/lang/" .. code .. ".lua")
if not okT or type(tr) ~= "table" then
  tr = {}
end

local out, seen = {}, {}
local function add(v)
  if type(v) == "table" and type(v.en) == "string" and not seen[v.en] then
    seen[v.en] = true
    if tr[v.en] == nil then
      out[#out + 1] = v.en
    end
  end
end

for _, m in ipairs(mods) do
  local t = dofile(m)
  if m:match("i18n%.lua$") then
    -- the HUD strings, by key order
    local keys = {}
    for k in pairs(t.STRINGS) do
      keys[#keys + 1] = k
    end
    table.sort(keys)
    for _, k in ipairs(keys) do
      add(t.STRINGS[k])
    end
  elseif m:match("quests%.lua$") then
    for _, q in ipairs(t) do
      add(q.name)
      add(q.goal)
    end
  else
    for _, map in ipairs(t) do
      add(map.name)
      add(map.title)
      add(map.lesson)
      add(map.story)
      add(map.speaker)
      for _, n in ipairs(map.npcs or {}) do
        add(n.line)
      end
      for _, st in ipairs(map.stages or {}) do
        add(st.q)
        add(st.code)
        add(st.hint)
        add(st.ok)
      end
    end
  end
end

for i, s in ipairs(out) do
  local flat = s:gsub("\\", "\\\\"):gsub("\n", "\\n"):gsub("\t", "\\t")
  io.write(i, "\t", flat, "\n")
end
io.stderr:write(#out .. " strings missing in " .. code .. "\n")
