-- The three tiers of CLEAR effects (src/fx.lua): a blank answered is small,
-- a street CLEAR is big, a quest's stamp is the biggest. Data only here: the
-- suite never draws, so this is what update() does and what the game fires.

local Store = require "src.store"
local Game = require "src.game"
local FX = require "src.fx"
local I18n = require "src.i18n"

return function(t)
  t.describe("clear effects")

  local scratch = (os.getenv("TMPDIR") or "/tmp"):gsub("/+$", "") .. "/goset-fx-test"
  local SCENE = { x = 0, y = 18, w = 1280, h = 180 }
  local SCREEN = { x = 0, y = 0, w = 1280, h = 720 }

  local function fresh()
    os.execute(string.format('rm -rf "%s"', scratch))
    Store.use(scratch)
    local g = Game.new()
    g:ingestProgress(nil)
    g:enterTitle()
    return g
  end

  local function press(g, key)
    g:keypressed(key)
    if #key == 1 then
      g:textinput(key)
    end
    g.frame = g.frame + 1
  end

  local function type_(g, s)
    for ch in s:gmatch(".") do
      g:textinput(ch)
    end
  end

  -- run an effect until it goes quiet, in 60 Hz steps; returns the seconds
  local function settle(fx, limit)
    local n = 0
    while fx:active() and n < (limit or 1200) do
      fx:update(1 / 60)
      n = n + 1
    end
    return n / 60
  end

  local function count(fx, kind)
    local n = 0
    for _, b in ipairs(fx.bits) do
      if b.kind == kind then
        n = n + 1
      end
    end
    return n
  end

  t.it("a fresh FX is quiet and update on nothing is harmless", function()
    local fx = FX.new()
    t.eq(fx:active(), false)
    fx:update(0.5)
    t.eq(fx:active(), false)
    t.ok(FX.LIFE.small < FX.LIFE.big and FX.LIFE.big < FX.LIFE.quest, "the tiers get longer")
  end)

  t.it("small: a ring, a few stars and the word, gone in under a second", function()
    local fx = FX.new()
    fx:small(640, 100, "NICE!")
    t.eq(#fx.rings, 1, "one ring")
    t.eq(count(fx, "star"), 10, "ten stars")
    t.eq(count(fx, "confetti"), 0, "no confetti on a single blank")
    t.eq(#fx.banners, 0, "no banner on a single blank")
    t.eq(#fx.words, 1)
    t.eq(fx.words[1].text, "NICE!")
    local secs = settle(fx)
    t.ok(secs < 1.0, "quiet in under a second (" .. secs .. ")")
    t.eq(fx:active(), false)
  end)

  t.it("small without a word is only particles", function()
    local fx = FX.new()
    fx:small(10, 10)
    t.eq(#fx.words, 0)
    t.ok(fx:active())
  end)

  t.it("big: confetti rain, three shockwaves, a banner with one letter per glyph, a medal only for PERFECT", function()
    local fx = FX.new()
    fx:big(SCENE, "STREET CLEAR!", true)
    t.eq(#fx.rings, 3, "three shockwaves")
    t.ok(count(fx, "confetti") >= 60, "confetti rain")
    t.ok(count(fx, "star") >= 20, "a shell of stars")
    t.eq(#fx.banners, 1)
    local b = fx.banners[1]
    t.eq(b.kind, "big")
    t.eq(#b.letters, 13, "one entry per letter of STREET CLEAR!")
    t.eq(b.icon, "fx_medal", "PERFECT hangs the medal")
    t.ok(b.y > SCENE.y and b.y < SCENE.y + SCENE.h, "the banner sits inside the scene")
    for _, bit in ipairs(fx.bits) do
      if bit.kind == "confetti" then
        t.ok(bit.y <= SCENE.y, "confetti starts at or above the top edge")
      end
    end

    local plain = FX.new()
    plain:big(SCENE, "STREET CLEAR!", false)
    t.eq(plain.banners[1].icon, nil, "no medal after a miss")

    local secs = settle(fx)
    t.ok(secs > 2 and secs < 4, "the big tier lasts a few seconds (" .. secs .. ")")
  end)

  t.it("big handles multi-byte letters one glyph at a time", function()
    local fx = FX.new()
    fx:big(SCENE, "거리 클리어!", false)
    t.eq(#fx.banners[1].letters, 7, "Korean syllables are single letters")
    fx:big(SCENE, "任務完成！", false)
    t.eq(#fx.banners[2].letters, 5)
  end)

  t.it("quest: fireworks keep going off for seconds, rays, heavy confetti and the trophy", function()
    local fx = FX.new()
    fx:quest(SCREEN, "QUEST CLEAR!")
    t.ok(fx.rays ~= nil, "gold rays")
    t.eq(#fx.fuses, 9, "nine fireworks still to go")
    t.ok(count(fx, "confetti") >= 120, "heavy confetti")
    t.eq(fx.banners[1].icon, "fx_trophy")
    t.eq(fx.banners[1].kind, "quest")
    local before = count(fx, "star")
    fx:update(0.3)
    fx:update(0.3)
    t.ok(count(fx, "star") > before, "later fireworks add stars after the first")
    t.ok(#fx.fuses < 9, "some fuses have gone off")
    local n = 0
    while #fx.fuses > 0 and n < 600 do
      fx:update(1 / 60)
      n = n + 1
    end
    t.eq(#fx.fuses, 0, "every fuse goes off")
    local secs = 0.6 + n / 60 + settle(fx) -- the two update(0.3) calls, the fuses, the rest
    t.ok(secs >= 4 and secs < 7, "the quest tier is the longest (" .. secs .. ")")
    t.eq(fx.rays, nil, "the rays are gone")
  end)

  t.it("clear() silences everything at once", function()
    local fx = FX.new()
    fx:quest(SCREEN, "QUEST CLEAR!")
    fx:small(1, 1, "x")
    fx:clear()
    t.eq(fx:active(), false)
    t.eq(#fx.bits + #fx.rings + #fx.banners + #fx.words + #fx.fuses, 0)
  end)

  t.it("bits fall under gravity and die; confetti flutters", function()
    local fx = FX.new()
    fx:small(100, 100)
    local star = fx.bits[1]
    local y0, vy0 = star.y, star.vy
    fx:update(0.1)
    t.ok(star.vy > vy0, "gravity pulls the star down")
    t.ok(star.y ~= y0, "it moved")
    fx:big(SCENE, "X", false)
    local paper
    for _, b in ipairs(fx.bits) do
      if b.kind == "confetti" then
        paper = b
        break
      end
    end
    t.ok(paper and paper.flutter and paper.drag, "confetti has drag and flutter")
  end)

  t.it("a right blank fires the small tier; the street CLEAR fires the big one, medal for PERFECT", function()
    local g = fresh()
    press(g, "1")
    t.eq(g.fx:active(), false, "nothing on entering a street")
    local st = g:map().stages
    type_(g, st[1].answer)
    press(g, "return")
    t.eq(#g.fx.words, 1, "the small word popped")
    t.eq(g.fx.words[1].text, I18n.t("fx_step"))
    t.eq(#g.fx.banners, 0, "no banner for one blank")
    for i = 2, #st do
      type_(g, st[i].answer)
      press(g, "return")
    end
    t.eq(g.solved, true)
    t.eq(#g.fx.banners, 1, "the street banner")
    t.eq(g.fx.banners[1].text, I18n.t("fx_street"))
    t.eq(g.fx.banners[1].icon, "fx_medal", "a clean street hangs the medal")
    local b = g.fx.banners[1]
    t.ok(b.y > 18 and b.y < 18 + 400, "the banner plays inside the scene, above the terminal")
  end)

  t.it("a street with a miss gets the banner without the medal", function()
    local g = fresh()
    press(g, "2")
    local st = g:map().stages
    type_(g, "wrong")
    press(g, "return")
    for _ = 1, 5 do
      press(g, "backspace")
    end
    for i = 1, #st do
      type_(g, st[i].answer)
      press(g, "return")
    end
    t.eq(g.solved, true)
    t.eq(g.perfect, false)
    t.eq(#g.fx.banners, 1)
    t.eq(g.fx.banners[1].icon, nil)
  end)

  t.it("the stamp fires the quest tier over the whole screen, and the next street starts quiet", function()
    local g = fresh()
    press(g, "1")
    for i = 1, 7 do
      for _, st in ipairs(g:map().stages) do
        type_(g, st.answer)
        press(g, "return")
      end
      if i < 7 then
        t.ok(g.fx:active(), "the big tier is playing after street " .. i)
        press(g, "return")
        t.eq(g.fx:active(), false, "walking on to street " .. (i + 1) .. " clears it")
      end
    end
    press(g, "return")
    t.eq(g.state, "win")
    t.eq(#g.fx.banners, 1)
    t.eq(g.fx.banners[1].kind, "quest")
    t.eq(g.fx.banners[1].text, I18n.t("fx_quest"))
    t.eq(g.fx.banners[1].icon, "fx_trophy")
    t.ok(g.fx.rays ~= nil, "rays over the win screen")
    t.eq(#g.fx.fuses, 9, "fireworks queued")
    for _ = 1, 70 do
      g:update(0.05) -- Game:update clamps dt to 1/20: 3.5 s of stamp
    end
    t.eq(#g.fx.fuses, 0, "the fireworks all went off while the stamp sat there")
  end)

  t.it("the effect words exist in every language", function()
    for _, key in ipairs({ "fx_step", "fx_street", "fx_quest" }) do
      local en = I18n.pick(I18n.STRINGS[key], "en")
      t.ok(#en > 0, key)
      for _, lang in ipairs(I18n.LANGS) do
        t.ok(#I18n.pick(I18n.STRINGS[key], lang) > 0, key .. " in " .. lang)
      end
      for _, lang in ipairs({ "ko", "yue", "zh", "ja", "es", "cs" }) do
        t.ok(I18n.pick(I18n.STRINGS[key], lang) ~= en, key .. " is translated in " .. lang)
      end
    end
  end)
end
