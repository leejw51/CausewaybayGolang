-- Lint one street data file without LÖVE:
--
--   luajit tools/lint_data.lua src/data_rs.lua [src/data_rs_adv.lua ...]
--
-- Checks the same rules tests/test_flow.lua enforces, plus the shape of the
-- Rust-track extras (viz = "rust", chips, note). Exit 1 on any error.

package.path = "./?.lua;" .. package.path

local BG = {
  bg_flat = true,
  bg_street = true,
  bg_mtr = true,
  bg_times = true,
  bg_mall = true,
  bg_queue = true,
  bg_till = true,
  bg_kitchen = true,
  bg_set = true,
}
local PORTRAIT = {
  portrait_hero = true,
  portrait_friends = true,
  portrait_clerk = true,
  portrait_officer = true,
}
local NPC = { hero = true, mei = true, clerk = true, cook = true }
local STYLE = { cyan = true, gold = true, pink = true, green = true }
local LANGS = { "en", "ko", "yue" }

-- same as Game.norm
local function norm(s)
  s = tostring(s or ""):lower()
  s = s:gsub("[\"'`]", "")
  s = s:gsub("%s+", "")
  local blank = s:match("^_+$")
  s = s:gsub("[_%.]", "")
  local neg = s:sub(1, 1) == "-"
  s = s:gsub("%-", "")
  if neg then
    s = "-" .. s
  end
  if s == "" and blank then
    return "_"
  end
  return s
end

local function accepts(answer, list)
  local a = norm(answer)
  if a == "" then
    return false
  end
  for i = 1, #list do
    if a == norm(list[i]) then
      return true
    end
  end
  return false
end

local errors, warns = {}, {}
local function err(where, msg)
  errors[#errors + 1] = where .. ": " .. msg
end
local function warn(where, msg)
  warns[#warns + 1] = where .. ": " .. msg
end

local function isL(v)
  return type(v) == "table" and type(v.en) == "string"
end

local function checkL(where, v, opts)
  opts = opts or {}
  if not isL(v) then
    err(where, "must be an L(en, ko, yue) table")
    return
  end
  for _, lang in ipairs(LANGS) do
    if type(v[lang]) ~= "string" or v[lang] == "" then
      err(where, "missing " .. lang)
    end
  end
  if not opts.code and not opts.name then
    for _, lang in ipairs({ "ko", "yue" }) do
      if v[lang] == v.en then
        warn(where, lang .. " is identical to en")
      end
    end
    if v.ko and v.yue and v.ko == v.yue then
      warn(where, "ko and yue are identical")
    end
  end
end

local function lines(code)
  local out = {}
  for line in (code:gsub("\n+$", "") .. "\n"):gmatch("(.-)\n") do
    out[#out + 1] = line
  end
  return out
end

local function countBlanks(code)
  local _, n = code:gsub("___", "")
  return n
end

local function lintFile(path, seenIds)
  local chunk, loadErr = loadfile(path)
  if not chunk then
    err(path, "does not load: " .. tostring(loadErr))
    return 0
  end
  local ok, maps = pcall(chunk)
  if not ok then
    err(path, "errors when run: " .. tostring(maps))
    return 0
  end
  if type(maps) ~= "table" then
    err(path, "must return a list of maps")
    return 0
  end
  if #maps ~= 7 then
    err(path, "must have exactly 7 maps, has " .. #maps)
  end
  local blanks = 0
  for mi, m in ipairs(maps) do
    local where = string.format("%s map %d (%s)", path, mi, tostring(m.id))
    if type(m.id) ~= "string" or not m.id:match("^rs_[%l_]+$") then
      err(where, "id must be a lowercase rs_ string")
    elseif seenIds[m.id] then
      err(where, "id " .. m.id .. " is used twice")
    else
      seenIds[m.id] = true
    end
    if type(m.station) ~= "string" or #m.station > 8 or m.station ~= m.station:upper() then
      err(where, "station must be UPPERCASE and at most 8 chars: " .. tostring(m.station))
    end
    checkL(where .. " name", m.name, { name = true })
    checkL(where .. " title", m.title)
    checkL(where .. " lesson", m.lesson)
    checkL(where .. " story", m.story)
    checkL(where .. " speaker", m.speaker, { name = true })
    if not BG[m.bg] then
      err(where, "bg must be one of the existing scenes: " .. tostring(m.bg))
    end
    if not PORTRAIT[m.portrait] then
      err(where, "portrait must be portrait_hero / portrait_friends / portrait_clerk / portrait_officer")
    end
    if type(m.ground) ~= "number" or type(m.spawn) ~= "number" or type(m.width) ~= "number" then
      err(where, "ground, spawn, width must be numbers")
    end
    if type(m.npcs) ~= "table" or #m.npcs < 1 then
      err(where, "needs at least one npc")
    else
      for ni, n in ipairs(m.npcs) do
        if not NPC[n.kind] then
          err(where .. " npc " .. ni, "kind must be hero / mei / clerk / cook")
        end
        if type(n.x) ~= "number" or (n.facing ~= 1 and n.facing ~= -1) then
          err(where .. " npc " .. ni, "needs x and facing (1 or -1)")
        end
        checkL(where .. " npc " .. ni .. " line", n.line)
      end
    end
    if m.viz ~= "rust" then
      err(where, 'viz must be "rust"')
    end
    if type(m.chips) ~= "table" or #m.chips < 2 or #m.chips > 4 then
      err(where, "chips must list 2 to 4 { text, style } pairs")
    else
      for ci, c in ipairs(m.chips) do
        if type(c[1]) ~= "string" or #c[1] < 1 or #c[1] > 24 then
          err(where .. " chip " .. ci, "text must be 1 to 24 chars")
        end
        if not STYLE[c[2]] then
          err(where .. " chip " .. ci, "style must be cyan / gold / pink / green")
        end
      end
    end
    if type(m.note) ~= "string" or #m.note < 1 or #m.note > 48 then
      err(where, "note must be a code string of 1 to 48 chars")
    end
    if type(m.stages) ~= "table" or #m.stages < 4 or #m.stages > 8 then
      err(where, "needs 4 to 8 stages, has " .. tostring(type(m.stages) == "table" and #m.stages or m.stages))
    else
      local seen = {}
      for si, st in ipairs(m.stages) do
        blanks = blanks + 1
        local w = where .. " stage " .. si
        if type(st.topic) ~= "string" or #st.topic > 10 or st.topic ~= st.topic:upper() then
          err(w, "topic must be UPPERCASE and at most 10 chars: " .. tostring(st.topic))
        end
        checkL(w .. " q", st.q)
        checkL(w .. " hint", st.hint)
        checkL(w .. " ok", st.ok)
        checkL(w .. " code", st.code, { code = true })
        if type(st.answer) ~= "string" or st.answer == "" then
          err(w, "answer must be a non-empty string")
        elseif #st.answer > 40 then
          err(w, "answer longer than 40 chars")
        end
        if type(st.accept) ~= "table" or #st.accept < 1 then
          err(w, "accept must list at least one string")
        end
        if type(st.answer) == "string" and type(st.accept) == "table" then
          local n = norm(st.answer)
          if n == "" then
            err(w, "answer vanishes under the loose matcher: " .. st.answer)
          elseif seen[n] then
            err(w, "answer repeats another blank of this street: " .. st.answer)
          else
            seen[n] = true
          end
          if not accepts(st.answer, st.accept) then
            err(w, "answer is not in its own accept list")
          end
        end
        if isL(st.code) then
          local enBlanks = countBlanks(st.code.en)
          if enBlanks < 1 then
            err(w, "en code has no ___")
          end
          for _, lang in ipairs(LANGS) do
            local code = st.code[lang] or ""
            if countBlanks(code) ~= enBlanks then
              err(w, lang .. " code has a different number of ___ than en")
            end
            local ls = lines(code)
            if #ls > 7 then
              err(w, lang .. " code is " .. #ls .. " lines (max 7)")
            end
            for _, line in ipairs(ls) do
              if #line > 60 then
                warn(w, lang .. " code line over 60 chars: " .. line)
              end
            end
            if type(st.answer) == "string" then
              local lower = code:lower()
              local pat = norm(st.answer):gsub("%p", "%%%0")
              for line in lower:gmatch("[^\n]+") do
                if line:find("___", 1, true) then
                  local rest = line:gsub("___", "")
                  if rest:match("#%s*" .. pat .. "%s*$") or rest:match("//%s*" .. pat .. "%s*$") then
                    err(w, lang .. " leaks the answer in the comment on the blank line")
                  end
                end
              end
              -- a giveaway: the exact answer written elsewhere in the block
              if lang == "en" and #st.answer >= 3 then
                local stripped = code:gsub("___", "\1")
                if stripped:find(st.answer, 1, true) then
                  warn(w, "the answer '" .. st.answer .. "' is written elsewhere in the code")
                end
              end
            end
          end
        end
      end
    end
  end
  return blanks
end

local files = { ... }
if #files == 0 then
  print("usage: luajit tools/lint_data.lua src/data_rs.lua [more files]")
  os.exit(2)
end
local seenIds = {}
local total = 0
for _, f in ipairs(files) do
  total = total + lintFile(f, seenIds)
end
for _, w in ipairs(warns) do
  print("warn  " .. w)
end
for _, e in ipairs(errors) do
  print("ERROR " .. e)
end
print(string.format("%d file(s), %d blanks, %d warning(s), %d error(s)", #files, total, #warns, #errors))
os.exit(#errors == 0 and 0 or 1)
