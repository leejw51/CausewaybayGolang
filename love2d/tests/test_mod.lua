-- Q8 MODULES: packages, paths and importing from GitHub. The syllabus a Go
-- newcomer trips over -- module path vs import path, a folder is a package,
-- go get from a host, internal, replace, semver tags, the proxy -- checked
-- here so an edit cannot quietly drop a street, a blank or a translation.

local Store = require "src.store"
local Game = require "src.game"
local Quests = require "src.quests"
local Share = require "src.share"
local I18n = require "src.i18n"

local MOD_QUEST = 20

return function(t)
  t.describe("modules and paths")

  local scratch = (os.getenv("TMPDIR") or "/tmp"):gsub("/+$", "") .. "/goset-mod-test"

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
    g.frame = g.frame + 1
  end

  local function answers()
    local out = {}
    for _, m in ipairs(Quests[MOD_QUEST].maps) do
      for _, st in ipairs(m.stages) do
        out[Game.norm(st.answer)] = m.station
      end
    end
    return out
  end

  t.it("Q8 MODULES is the eighth Go quest and ships the v1.0.0 stamp", function()
    local q = Quests[MOD_QUEST]
    t.eq(q.id, "modules")
    t.eq(q.track, "go")
    t.eq(q.tag, "Q8")
    t.eq(q.station, "MODULES")
    t.eq(q.win.stamp, "v1.0.0")
    t.eq(Quests.indexInTrack(MOD_QUEST), 8)
    t.eq(#q.maps, 7, "seven streets")
    t.eq(#Quests.ofTrack("rust"), 6, "the Rust track is untouched")
    t.eq(#Quests.ofTrack("python"), 6, "the Python track is untouched")
  end)

  t.it("the streets walk from go.mod to the proxy", function()
    local stations, ids = {}, {}
    for _, m in ipairs(Quests[MOD_QUEST].maps) do
      stations[#stations + 1] = m.station
      ids[#ids + 1] = m.id
      t.eq(m.viz, "chips", m.id .. " draws the chips scene")
      t.ok(m.id:sub(1, 3) ~= "rs_" and m.id:sub(1, 3) ~= "py_", m.id .. " is a Go street")
      t.eq(#m.stages, 5, m.id .. " has five blanks")
    end
    t.eq(table.concat(stations, " "), "MODULE PACKAGE GO GET INTERNAL REPLACE VERSION PROXY")
    t.eq(table.concat(ids, " "), "gomod pkgdir getpkg layout gowork semver proxy")
  end)

  t.it("it teaches the module path, the GitHub import and the tooling around them", function()
    local a = answers()
    for _, want in ipairs({
      "github.com/alex/luckymac", -- the module path is the import path
      "menu", -- module path + directory
      "1.23", -- the go directive
      "GOMOD",
      "on", -- GO111MODULE since 1.16
      "Price", -- capital means exported
      "github.com/alex/luckymac/menu", -- the full import path
      "relative", -- and why ./menu is not one
      "used",
      "get", -- fetching from GitHub
      "require",
      "sum",
      "indirect",
      "mod", -- the module cache
      "internal", -- layout
      "cmd",
      "main",
      "Package",
      "_test",
      "replace", -- working on two repos at once
      "work",
      "use",
      "tidy",
      "vendor",
      "tag", -- releasing
      "latest",
      "v2",
      "retract",
      "list",
      "direct", -- the proxy and private repos
      "GOPRIVATE",
      "insteadOf",
      "modcache",
    }) do
      t.ok(a[Game.norm(want)], "Q8 teaches " .. want)
    end
  end)

  t.it("the GitHub story is consistent: one module path, one repo, one import", function()
    local maps = Quests[MOD_QUEST].maps
    local seen = { path = false, imp = false, host = false }
    for _, m in ipairs(maps) do
      for _, st in ipairs(m.stages) do
        local code = I18n.pick(st.code, "en")
        if code:find("github.com/alex/luckymac", 1, true) then
          seen.path = true
        end
        if code:find("git@github.com", 1, true) then
          seen.host = true
        end
        if st.answer == "github.com/alex/luckymac/menu" then
          seen.imp = true
        end
      end
    end
    t.ok(seen.path, "the module path appears in the code")
    t.ok(seen.host, "the git remote shows where the path comes from")
    t.ok(seen.imp, "a full GitHub import path is one of the answers")
  end)

  t.it("every blank is answerable, unique in its street and fits the screen", function()
    for _, m in ipairs(Quests[MOD_QUEST].maps) do
      local seen = {}
      for si, st in ipairs(m.stages) do
        local where = "Q8/" .. m.id .. "/" .. si
        local norm = Game.norm(st.answer)
        t.ok(norm ~= "", where .. " survives the loose matcher")
        t.ok(not seen[norm], where .. " repeats an answer of the same street")
        seen[norm] = true
        t.ok(Game.accepts(st.answer, st.accept), where .. " accepts its own answer")
        local en = I18n.pick(st.code, "en")
        local _, blanks = en:gsub("___", "")
        t.ok(blanks >= 1, where .. " has a blank")
        for _, lang in ipairs({ "ko", "yue" }) do
          local _, n = I18n.pick(st.code, lang):gsub("___", "")
          t.eq(n, blanks, where .. " keeps its blanks in " .. lang)
        end
        local lines = 0
        for _ in (en:gsub("\n+$", "") .. "\n"):gmatch("(.-)\n") do
          lines = lines + 1
        end
        t.ok(lines <= 7, where .. " code fits in seven lines (" .. lines .. ")")
      end
    end
  end)

  t.it("clearing all seven streets stamps v1.0.0", function()
    local g = fresh()
    g:setQuest(MOD_QUEST)
    t.eq(g:track(), "go")
    press(g, "1")
    t.eq(g:map().id, "gomod", "the quest starts at go.mod")
    for i = 1, 7 do
      t.eq(g.step, i)
      for _, st in ipairs(g:map().stages) do
        type_(g, st.answer)
        press(g, "return")
      end
      t.eq(g.solved, true, g:map().id .. " clear")
      press(g, "return")
    end
    t.eq(g.state, "win")
    t.eq(g:questDef().win.stamp, "v1.0.0")
    t.eq(g:clearedCount(MOD_QUEST), 7)
    t.eq(g.cleared["proxy"], true)
    t.eq(#g.fx.banners, 1, "the quest effect plays over the stamp")
    t.eq(g.fx.banners[1].kind, "quest")
  end)

  t.it("SHARE exports a MODULES street as Go", function()
    local g = fresh()
    g:setQuest(MOD_QUEST)
    press(g, "3") -- GO GET
    local rows = Share.rows(g, "street")
    t.eq(#rows, 5)
    t.eq(rows[1].station, "GO GET")
    local md = Share.markdown(rows, Share.title(g, "street"))
    t.has(md, "```go")
    t.has(md, "go.sum")
  end)

  t.it("the quest reads in every language and is really translated in zh, ja, es and cs", function()
    local quest = Quests[MOD_QUEST]
    for _, lang in ipairs(I18n.LANGS) do
      t.ok(#I18n.pick(quest.name, lang) > 0, "name in " .. lang)
      t.ok(#I18n.pick(quest.goal, lang) > 0, "goal in " .. lang)
    end
    for _, lang in ipairs({ "zh", "ja", "es", "cs" }) do
      t.ok(I18n.pick(quest.goal, lang) ~= quest.goal.en, "goal translated in " .. lang)
      t.ok(I18n.pick(I18n.STRINGS.mwin_head, lang) ~= I18n.STRINGS.mwin_head.en, "win head in " .. lang)
    end
    t.has(I18n.pick(I18n.STRINGS.mwin_head, "en"), "v1.0.0")
  end)

  t.it("every string of the data file is translated in zh, ja, es and cs", function()
    local strings, seen = {}, {}
    local function walk(v)
      if type(v) ~= "table" or seen[v] then
        return
      end
      seen[v] = true
      if type(v.en) == "string" then
        strings[#strings + 1] = v
        return
      end
      for _, child in pairs(v) do
        walk(child)
      end
    end
    walk(require "src.data_mod")
    t.ok(#strings > 150, "found the strings (" .. #strings .. ")")
    for _, lang in ipairs({ "zh", "ja", "es", "cs" }) do
      local tr = I18n.TR[lang]
      local missing = {}
      for _, v in ipairs(strings) do
        if not (tr and tr[v.en]) and #missing < 3 then
          missing[#missing + 1] = v.en:sub(1, 48)
        end
      end
      t.eq(#missing, 0, lang .. " missing: " .. table.concat(missing, " | "))
    end
  end)
end
