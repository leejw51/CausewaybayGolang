-- The title -> map -> play -> win state machine, driven through the same
-- keypressed / textinput entry points main.lua uses. No drawing.

local Store = require "src.store"
local Game = require "src.game"
local Quests = require "src.quests"
local maps = require "src.data"

return function(t)
  t.describe("game flow")

  local scratch = (os.getenv("TMPDIR") or "/tmp"):gsub("/+$", "") .. "/goset-flow-test"

  local function fresh()
    os.execute(string.format('rm -rf "%s"', scratch))
    Store.use(scratch)
    local g = Game.new()
    g:ingestProgress(nil)
    g:enterTitle()
    return g
  end

  -- keypressed + the textinput LOVE sends in the same event batch
  local function press(g, key)
    g:keypressed(key)
    if #key == 1 then
      g:textinput(key)
    elseif key == "space" then
      g:textinput(" ")
    end
    g.frame = g.frame + 1
  end

  local function type_(g, s)
    for ch in s:gmatch(".") do
      g:textinput(ch)
    end
    g.frame = g.frame + 1
  end

  -- answer every stage of the current street
  local function solveStreet(g)
    local m = maps[g.step]
    for _, st in ipairs(m.stages) do
      type_(g, st.answer)
      press(g, "return")
    end
  end

  t.it("every stage of every quest has a question, a blank, an answer and a hint in every language", function()
    local I18n = require "src.i18n"
    local all = {}
    local seen = {}
    for _, quest in ipairs(Quests) do
      t.eq(#quest.maps, 7, quest.id .. " has seven streets")
      for _, m in ipairs(quest.maps) do
        t.ok(not seen[m.id], "street id " .. m.id .. " is unique across quests")
        seen[m.id] = true
        all[#all + 1] = m
      end
    end
    for _, lang in ipairs(I18n.LANGS) do
      for _, m in ipairs(all) do
        t.ok(#I18n.pick(m.lesson, lang) > 0, lang .. " " .. m.id .. " lesson")
        t.ok(#I18n.pick(m.story, lang) > 0, lang .. " " .. m.id .. " story")
        for si, st in ipairs(m.stages) do
          local where = lang .. " " .. m.id .. "/" .. si
          local code = I18n.pick(st.code, lang)
          t.ok(#I18n.pick(st.q, lang) > 0, where .. " q")
          t.ok(code:find("___", 1, true), where .. " blank")
          t.ok(st.answer and #st.answer > 0, where .. " answer")
          t.ok(#I18n.pick(st.hint, lang) > 0, where .. " hint")
          t.ok(#I18n.pick(st.ok, lang) > 0, where .. " ok")
          t.ok(Game.accepts(st.answer, st.accept), where .. " answer is accepted")
          local n = 0
          for _ in (code:gsub("\n+$", "") .. "\n"):gmatch("(.-)\n") do
            n = n + 1
          end
          t.ok(n <= 7, where .. " code fits (" .. n .. " lines)")
          -- the answer must not be given away in the code itself
          local lower = code:lower()
          for line in lower:gmatch("[^\n]+") do
            if line:find("___", 1, true) then
              local rest = line:gsub("___", "")
              t.ok(
                not rest:match("#%s*" .. Game.norm(st.answer):gsub("%p", "%%%0") .. "%s*$")
                  and not rest:match("//%s*" .. Game.norm(st.answer):gsub("%p", "%%%0") .. "%s*$"),
                where .. " leaks the answer in a comment"
              )
            end
          end
        end
      end
    end
  end)

  t.it("every sound effect renders", function()
    local SFX = require "src.sfx"
    t.ok(#SFX.names >= 12, "sound table")
    for _, n in ipairs(SFX.names) do
      SFX.play(n)
    end
    t.eq(SFX.ok, true, "no synth or audio errors")
    SFX.set(false)
    SFX.play("ok")
    SFX.set(true)
  end)

  t.it("language cycles and falls back to English", function()
    local I18n = require "src.i18n"
    I18n.set("en")
    t.eq(I18n.t("hint"), "HINT")
    I18n.cycle()
    t.eq(I18n.lang, "ko")
    t.eq(I18n.t("hint"), "힌트")
    t.eq(I18n.pick({ en = "a" }), "a", "missing translation falls back")
    I18n.cycle()
    t.eq(I18n.lang, "yue")
    for _, want in ipairs({ "zh", "ja", "es", "cs" }) do
      I18n.cycle()
      t.eq(I18n.lang, want)
      t.ok(I18n.t("hint") ~= "HINT", want .. " translates the HUD")
      t.eq(I18n.pick({ en = "a" }, want), "a", want .. " falls back to English")
    end
    I18n.cycle()
    t.eq(I18n.lang, "en")
    t.eq(I18n.pick("plain"), "plain")
    I18n.set("en")
  end)

  -- The languages in src/lang/ are looked up by English text, so a string
  -- rewritten in a data file silently drops back to English everywhere. This
  -- walks every L() table in the data and the HUD and asks each table for it.
  t.it("every string is translated in every src/lang language", function()
    local I18n = require "src.i18n"
    local strings = {}
    local function walk(v, seen)
      if type(v) ~= "table" or seen[v] then
        return
      end
      seen[v] = true
      if type(v.en) == "string" then
        strings[#strings + 1] = v
        return
      end
      for _, child in pairs(v) do
        walk(child, seen)
      end
    end
    for _, m in ipairs({ "src.data", "src.data_adv", "src.data_pro", "src.data_quiz" }) do
      walk(require(m), {})
    end
    walk(I18n.STRINGS, {})
    t.ok(#strings > 700, "found the strings (" .. #strings .. ")")
    for _, lang in ipairs({ "zh", "ja", "es", "cs" }) do
      local tr = I18n.TR[lang]
      t.ok(tr ~= nil, lang .. " has src/lang/" .. lang .. ".lua")
      local missing, bad = 0, {}
      for _, v in ipairs(strings) do
        local s = tr and tr[v.en]
        if not s then
          missing = missing + 1
        else
          for _, tok in ipairs({ "___", "%%s", "%%d" }) do
            local _, a = v.en:gsub(tok, "")
            local _, b = s:gsub(tok, "")
            if a ~= b then
              bad[#bad + 1] = v.en:sub(1, 40)
            end
          end
        end
      end
      t.eq(missing, 0, lang .. " missing translations")
      t.eq(#bad, 0, lang .. " keeps blanks and %s/%d: " .. table.concat(bad, " | "))
    end
  end)

  -- Every glyph any language draws has to exist in the pixel fonts or the CJK
  -- fallback, or LÖVE draws a box.
  t.it("the fonts cover every language", function()
    local I18n = require "src.i18n"
    local Assets = require "src.assets"
    local utf8 = require "utf8"
    Assets.ensureFonts(1)
    for _, lang in ipairs(I18n.LANGS) do
      local text = {}
      for _, v in pairs(I18n.STRINGS) do
        text[#text + 1] = I18n.pick(v, lang)
      end
      local tr = I18n.TR[lang]
      if tr then
        for _, s in pairs(tr) do
          text[#text + 1] = s
        end
      end
      local all = table.concat(text, ""):gsub("[\n\t]", "")
      for _, name in ipairs({ "ui", "small", "code", "subtitle" }) do
        local f = Assets.font[name]
        local missing = {}
        for _, c in utf8.codes(all) do
          local ch = utf8.char(c)
          if not f:hasGlyphs(ch) then
            missing[ch] = true
          end
        end
        local list = {}
        for ch in pairs(missing) do
          list[#list + 1] = ch
        end
        t.eq(#list, 0, lang .. " " .. name .. " font lacks: " .. table.concat(list, ""))
      end
    end
  end)

  t.it("answers compare loosely", function()
    t.eq(Game.accepts("SHA-256", { "sha256" }), true)
    t.eq(Game.accepts(" hiding ", { "hiding" }), true)
    t.eq(Game.accepts('"ADMIT"', { "admit" }), true)
    t.eq(Game.accepts("-1", { "-1" }), true)
    t.eq(Game.accepts("1", { "-1" }), false)
    t.eq(Game.accepts("", { "18" }), false)
    t.eq(Game.accepts("19", { "18" }), false)
    t.eq(Game.accepts(">=", { ">=" }), true)
    t.eq(Game.accepts("> =", { ">=" }), true)
    t.eq(Game.accepts("_", { "_" }), true, "Go blank identifier")
    t.eq(Game.accepts("chan string", { "chan string" }), true)
  end)

  t.it("title -> ENTER -> map -> ENTER -> play on street 1", function()
    local g = fresh()
    t.eq(g.state, "title")
    press(g, "return")
    t.eq(g.state, "map")
    t.eq(g.mapCursor, 1)
    press(g, "return")
    t.eq(g.state, "play")
    t.eq(g.step, 1)
    t.eq(g.input, "", "ENTER must not be typed into the blank")
  end)

  t.it("map cursor moves and wraps; digits jump", function()
    local g = fresh()
    press(g, "return")
    press(g, "down")
    press(g, "down")
    t.eq(g.mapCursor, 3)
    press(g, "up")
    t.eq(g.mapCursor, 2)
    press(g, "up")
    press(g, "up")
    t.eq(g.mapCursor, #maps, "wraps to the last street")
    press(g, "5")
    t.eq(g.state, "play")
    t.eq(g.step, 5)
    t.eq(g.input, "", "the digit that picked the street is not typed")
  end)

  t.it("title digits jump straight into a street", function()
    local g = fresh()
    press(g, "3")
    t.eq(g.state, "play")
    t.eq(g.step, 3)
    t.eq(g.input, "")
  end)

  t.it("hint is two-tier: nudge, then answer, then hidden", function()
    local g = fresh()
    press(g, "3")
    t.eq(g.hintLevel, 0)
    press(g, "tab")
    t.eq(g.hintLevel, 1, "first TAB: nudge")
    press(g, "tab")
    t.eq(g.hintLevel, 2, "second TAB: answer")
    press(g, "tab")
    t.eq(g.hintLevel, 0, "third TAB: hidden")
    t.eq(g.hintOn, false)
  end)

  t.it("wrong answer opens the nudge, right answers advance stages, last one clears", function()
    local g = fresh()
    press(g, "3") -- office
    local stages = maps[3].stages
    type_(g, "x")
    press(g, "return")
    t.eq(g.solved, false)
    t.eq(g.msgKind, "bad")
    t.eq(g.stage, 1)
    t.eq(g.hintLevel, 1, "a wrong attempt shows the nudge")
    t.ok(g.input ~= "", "the wrong text stays for editing")
    press(g, "backspace")
    t.eq(g.input, "")
    for i = 1, #stages - 1 do
      type_(g, stages[i].answer)
      press(g, "return")
      t.eq(g.stage, i + 1, "stage " .. i .. " -> " .. (i + 1))
      t.eq(g.solved, false)
      t.eq(g.hintLevel, 0, "hint closes on a new stage")
      t.eq(g.input, "")
    end
    type_(g, stages[#stages].answer:upper())
    press(g, "return")
    t.eq(g.solved, true)
    t.eq(g:isCleared(3), true)
    type_(g, "zzz")
    t.eq(g.input, "", "no typing after CLEAR")
    press(g, "return")
    t.eq(g.state, "play")
    t.eq(g.step, 4, "ENTER after CLEAR moves to the next street")
    t.eq(g.stage, 1)
  end)

  t.it("ESC from play opens the map, ESC again returns without resetting", function()
    local g = fresh()
    press(g, "4")
    type_(g, maps[4].stages[1].answer)
    press(g, "return")
    t.eq(g.stage, 2)
    press(g, "escape")
    t.eq(g.state, "map")
    t.eq(g.mapCursor, 4)
    press(g, "escape")
    t.eq(g.state, "play")
    t.eq(g.step, 4)
    t.eq(g.stage, 2, "progress inside the street survives the map")
    press(g, "escape")
    press(g, "return") -- pick the same street again
    t.eq(g.state, "play")
    t.eq(g.stage, 2, "re-picking the current street resumes it")
    press(g, "escape")
    press(g, "2")
    t.eq(g.step, 2)
    t.eq(g.stage, 1, "picking another street starts it fresh")
  end)

  t.it("clearing the last street alone goes to the map, not the stamp", function()
    local g = fresh()
    press(g, tostring(#maps))
    solveStreet(g)
    t.eq(g.solved, true)
    press(g, "return")
    t.eq(g.state, "map", "other streets still open")
    t.eq(g:isCleared(#maps), true)
  end)

  t.it("win only when all streets are clear; ENTER -> map, ESC -> title", function()
    local g = fresh()
    press(g, "1")
    for i = 1, #maps do
      t.eq(g.state, "play")
      t.eq(g.step, i)
      solveStreet(g)
      t.eq(g.solved, true, "street " .. i .. " clear")
      press(g, "return")
    end
    t.eq(g.state, "win")
    press(g, "return")
    t.eq(g.state, "map")
    press(g, "escape")
    t.eq(g.state, "title")
  end)

  t.it("Q cycles the quests on the title and the map; digits jump inside it", function()
    local g = fresh()
    t.eq(#Quests, 4, "four quests")
    t.eq(g.quest, 1)
    press(g, "q")
    t.eq(g.quest, 2)
    t.eq(g:map().id, "till", "the street list follows the quest")
    press(g, "return")
    t.eq(g.state, "map")
    press(g, "q")
    t.eq(g.quest, 3)
    t.eq(g:map().id, "runes", "quest 3 starts on the strings street")
    press(g, "q")
    t.eq(g.quest, 4)
    t.eq(g:map().id, "recurse", "quest 4 starts on recursion")
    press(g, "q")
    t.eq(g.quest, 1, "Q wraps around")
    press(g, "q")
    t.eq(g.quest, 2)
    press(g, "3")
    t.eq(g.state, "play")
    t.eq(g.step, 3)
    t.eq(g:map().id, "pass")
    t.eq(g.input, "")
  end)

  t.it("every stage answer is a single token the loose matcher keeps", function()
    -- norm() drops quotes, spaces, _ - . so an answer made only of those
    -- would be unreachable; and no two answers of one street may collide
    for _, quest in ipairs(Quests) do
      for _, m in ipairs(quest.maps) do
        local seen = {}
        for si, st in ipairs(m.stages) do
          local n = Game.norm(st.answer)
          t.ok(n ~= "", quest.id .. "/" .. m.id .. "/" .. si .. " answer survives norm()")
          t.ok(not seen[n], quest.id .. "/" .. m.id .. " repeats answer " .. st.answer)
          seen[n] = true
          t.ok(#m.station <= 8, m.id .. " station label fits the bar: " .. m.station)
        end
      end
    end
  end)

  t.it("combo counts right answers in a row; a miss or a revealed answer breaks it; PERFECT needs no miss", function()
    local g = fresh()
    press(g, "1")
    local stages = maps[1].stages
    type_(g, stages[1].answer)
    press(g, "return")
    t.eq(g.streak, 1)
    type_(g, stages[2].answer)
    press(g, "return")
    t.eq(g.streak, 2, "two in a row")
    t.ok(#g.pops >= 1 and g.pops[#g.pops].kind == "combo", "COMBO pops")
    type_(g, "nope")
    press(g, "return")
    t.eq(g.streak, 0, "a miss resets the streak")
    t.eq(g.misses, 1)
    for _ = 1, 4 do
      press(g, "backspace") -- a wrong answer stays in the prompt for editing
    end
    for i = 3, #stages do
      type_(g, stages[i].answer)
      press(g, "return")
    end
    t.eq(g.solved, true)
    t.eq(g.perfect, false, "no PERFECT after a miss")
    -- a clean street is PERFECT; revealing the answer is not clean
    press(g, "return") -- street 2
    press(g, "tab")
    press(g, "tab") -- ANSWER shown
    t.eq(g.misses, 1, "revealing the answer counts as a miss")
    press(g, "escape")
    press(g, "3")
    for _, st in ipairs(maps[3].stages) do
      type_(g, st.answer)
      press(g, "return")
    end
    t.eq(g.perfect, true, "street 3 solved clean is PERFECT")
    t.eq(g.pops[#g.pops].kind, "perfect")
  end)

  t.it("each quest has its own stamp; clearing one leaves the other untouched", function()
    local g = fresh()
    press(g, "q")
    press(g, "1")
    for i = 1, 7 do
      t.eq(g.step, i)
      local m = g:map()
      for _, st in ipairs(m.stages) do
        type_(g, st.answer)
        press(g, "return")
      end
      t.eq(g.solved, true, m.id .. " clear")
      press(g, "return")
    end
    t.eq(g.state, "win")
    t.eq(g:questDef().win.stamp, "SERVED")
    t.eq(g:clearedCount(2), 7)
    t.eq(g:clearedCount(1), 0, "quest 1 is still open")
    press(g, "return")
    t.eq(g.state, "map")
    press(g, "q")
    t.eq(g:allCleared(), false, "quest 1 has no stamp yet")
  end)

  t.it("progress remembers the quest, and CLEAR streets of both quests survive a save", function()
    local g = fresh()
    press(g, "1")
    solveStreet(g) -- quest 1, street 1
    press(g, "escape")
    press(g, "q")
    press(g, "2") -- quest 2, street 2
    type_(g, g:map().stages[1].answer)
    press(g, "return")
    t.eq(g.stage, 2)
    local g2 = Game.new()
    g2:ingestProgress(require("src.persist").loadProgress())
    g2:enterTitle()
    t.eq(g2.quest, 2)
    t.eq(g2.saved.quest, 2)
    t.eq(g2:isCleared(1), false, "street 1 of quest 2 is open")
    t.eq(g2.cleared["flat"], true, "quest 1's CLEAR came along")
    press(g2, "c")
    t.eq(g2.state, "play")
    t.eq(g2.quest, 2)
    t.eq(g2.step, 2)
    t.eq(g2.stage, 2)
    t.eq(g2:map().id, "kitchen")
  end)

  t.it("switching quest from a street's map drops the resume, so the other quest starts fresh", function()
    local g = fresh()
    press(g, "4")
    type_(g, maps[4].stages[1].answer)
    press(g, "return")
    t.eq(g.stage, 2)
    press(g, "escape")
    press(g, "q")
    t.eq(g.quest, 2)
    press(g, "4")
    t.eq(g.quest, 2)
    t.eq(g:map().id, "bell")
    t.eq(g.stage, 1, "not quest 1's half-done street")
  end)

  -- run the clock until pred() holds or the budget is spent
  local function runUntil(g, pred, budget)
    for _ = 1, budget do
      g:update(0.1)
      g.frame = g.frame + 1
      if pred() then
        return true
      end
    end
    return false
  end

  t.it("AUTO reads, hints, types, submits and walks to the next street; a key of the reader's stops it", function()
    local g = fresh()
    press(g, "3")
    press(g, "f5")
    t.eq(g.auto, true)
    t.ok(
      runUntil(g, function()
        return g.hintLevel == 1
      end, 40),
      "AUTO opens the nudge first"
    )
    t.ok(
      runUntil(g, function()
        return g.input ~= ""
      end, 40),
      "then types"
    )
    t.ok(
      runUntil(g, function()
        return g.stage == 2
      end, 200),
      "then submits and moves to the next blank"
    )
    t.eq(g.hintLevel, 0, "the nudge closes with the blank")
    t.ok(
      runUntil(g, function()
        return g.solved
      end, 1500),
      "AUTO clears the street"
    )
    t.eq(g.auto, true, "still running after CLEAR")
    t.ok(
      runUntil(g, function()
        return g.step == 4
      end, 60),
      "walks to the next street by itself"
    )
    t.eq(g.stage, 1)
    press(g, "escape")
    t.eq(g.auto, false, "ESC stops AUTO")
    t.eq(g.state, "map")
  end)

  t.it("AUTO from street 1 plays the whole quest to the stamp", function()
    local g = fresh()
    press(g, "1")
    g:startAuto()
    t.ok(
      runUntil(g, function()
        return g.state == "win"
      end, 6000),
      "reaches the stamp"
    )
    t.eq(g:allCleared(), true)
    t.eq(g.auto, false, "AUTO stops on the stamp")
  end)

  t.it("AUTO skips streets already CLEAR and typing stops it", function()
    local g = fresh()
    press(g, "2")
    solveStreet(g)
    press(g, "escape")
    press(g, "1")
    g:startAuto()
    t.ok(
      runUntil(g, function()
        return g.step ~= 1
      end, 1500),
      "leaves street 1"
    )
    t.eq(g.step, 3, "street 2 is CLEAR, so 3 comes next")
    type_(g, "x")
    t.eq(g.auto, false, "typing stops AUTO")
  end)

  t.it("PREV / NEXT page through the blanks of one street and stop at both ends", function()
    local g = fresh()
    local function tap(which)
      g[which](g)
      g.frame = g.frame + 1
    end
    press(g, "3") -- office, several blanks
    local n = #maps[3].stages
    t.ok(n >= 3, "street 3 has enough blanks for the test")
    tap("prevStage")
    t.eq(g.stage, 1, "PREV on the first blank stays put")
    tap("nextStage")
    t.eq(g.stage, 2)
    t.eq(g.step, 3, "NEXT never leaves the street")
    type_(g, "abc")
    press(g, "tab")
    tap("prevStage")
    t.eq(g.stage, 1)
    t.eq(g.input, "", "moving drops the typed text")
    t.eq(g.hintLevel, 0, "moving closes the hint")
    for _ = 1, n + 2 do
      tap("nextStage")
    end
    t.eq(g.stage, n, "NEXT on the last blank stays put")
    t.eq(g.solved, false, "browsing answers nothing")
  end)

  t.it("a blank skipped with NEXT is still asked before CLEAR", function()
    local g = fresh()
    press(g, "3")
    local stages = maps[3].stages
    -- jump to the last blank and answer it first
    for _ = 1, #stages - 1 do
      g:nextStage()
      g.frame = g.frame + 1
    end
    t.eq(g.stage, #stages)
    type_(g, stages[#stages].answer)
    press(g, "return")
    t.eq(g.solved, false, "one answer does not clear the street")
    t.eq(g.stage, 1, "the cursor returns to the first open blank")
    for i = 1, #stages - 1 do
      type_(g, stages[i].answer)
      press(g, "return")
    end
    t.eq(g.solved, true, "every blank answered -> CLEAR")
    t.eq(g:isCleared(3), true)
  end)

  t.it("PGUP / PGDN page through the blanks from the keyboard", function()
    local g = fresh()
    press(g, "3")
    press(g, "pagedown")
    t.eq(g.stage, 2)
    t.eq(g.input, "", "the page key is not typed into the blank")
    press(g, "pageup")
    t.eq(g.stage, 1)
  end)

  t.it("progress saves the first open blank, not the one being browsed", function()
    local g = fresh()
    press(g, "2")
    type_(g, maps[2].stages[1].answer)
    press(g, "return")
    t.eq(g.stage, 2)
    g:nextStage() -- peek at blank 3
    t.eq(g.stage, 3)
    local g2 = Game.new()
    g2:ingestProgress(require("src.persist").loadProgress())
    g2:enterTitle()
    t.eq(g2.saved.stage, 2, "resume lands on the open blank")
    press(g2, "c")
    t.eq(g2.stage, 2)
    t.eq(g2.done[1], true, "the answered blank stays answered")
    t.eq(g2.done[2], nil)
  end)

  t.it("progress persists: C on the title continues", function()
    local g = fresh()
    press(g, "2")
    type_(g, maps[2].stages[1].answer)
    press(g, "return")
    t.eq(g.stage, 2)
    -- new process
    local g2 = Game.new()
    g2:ingestProgress(require("src.persist").loadProgress())
    g2:enterTitle()
    t.ok(g2.saved, "saved record")
    t.eq(g2.saved.step, 2)
    t.eq(g2.saved.stage, 2)
    press(g2, "c")
    t.eq(g2.state, "play")
    t.eq(g2.step, 2)
    t.eq(g2.stage, 2)
    t.eq(g2.input, "", "the C key is not typed")
  end)

  t.it("continue after a CLEAR goes to the next street; map cursor follows", function()
    local g = fresh()
    press(g, "1")
    solveStreet(g)
    t.eq(g.solved, true)
    local g2 = Game.new()
    g2:ingestProgress(require("src.persist").loadProgress())
    g2:enterTitle()
    t.eq(g2:isCleared(1), true)
    t.eq(g2:continueTarget(), 2)
    press(g2, "return")
    t.eq(g2.state, "map")
    t.eq(g2.mapCursor, 2, "cursor sits on the next street to do")
    press(g2, "escape")
    press(g2, "c")
    t.eq(g2.state, "play")
    t.eq(g2.step, 2)
  end)
end
