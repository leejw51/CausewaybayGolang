-- Q7 THREADS (Go) and P6 PARALLEL (Python): the two concurrency quests.
-- Their syllabus, their data shape, a full play-through to each stamp, and
-- the seven languages, checked here so a later edit to either data file
-- cannot quietly drop a street, a blank or a translation.

local Store = require "src.store"
local Game = require "src.game"
local Quests = require "src.quests"
local Share = require "src.share"
local I18n = require "src.i18n"

local GO_QUEST, PY_QUEST = 18, 19

return function(t)
  t.describe("threads and parallel")

  local scratch = (os.getenv("TMPDIR") or "/tmp"):gsub("/+$", "") .. "/goset-conc-test"

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

  local function stations(q)
    local out = {}
    for _, m in ipairs(Quests[q].maps) do
      out[#out + 1] = m.station
    end
    return table.concat(out, " ")
  end

  local function answers(q)
    local out = {}
    for _, m in ipairs(Quests[q].maps) do
      for _, st in ipairs(m.stages) do
        out[Game.norm(st.answer)] = m.station
      end
    end
    return out
  end

  local function blanks(code)
    local _, n = code:gsub("___", "")
    return n
  end

  t.it("the two concurrency quests are appended last, one per track, with their own stamps", function()
    t.ok(#Quests >= 19, "nineteen quests or more")
    local go, py = Quests[GO_QUEST], Quests[PY_QUEST]

    t.eq(go.id, "conc")
    t.eq(go.track, "go")
    t.eq(go.tag, "Q7")
    t.eq(go.station, "THREADS")
    t.eq(go.win.stamp, "SYNCED")
    t.eq(go.win.title, "twin_title")
    t.eq(Quests.indexInTrack(GO_QUEST), 7, "the seventh Go quest")

    t.eq(py.id, "py_mp")
    t.eq(py.track, "python")
    t.eq(py.tag, "P6")
    t.eq(py.station, "PARALLEL")
    t.eq(py.win.stamp, "SCALED")
    t.eq(py.win.title, "mpwin_title")
    t.eq(Quests.indexInTrack(PY_QUEST), 6, "the sixth Python quest")

    -- appending, never inserting: every older index still means what it did
    t.eq(Quests[1].id, "basic")
    t.eq(Quests[9].id, "py_basic")
    t.eq(Quests[17].id, "py_callback")
    t.ok(#Quests.ofTrack("go") >= 7)
    t.eq(#Quests.ofTrack("rust"), 6, "the Rust track is untouched")
    t.eq(#Quests.ofTrack("python"), 6)
  end)

  t.it("Q7 walks the Go concurrency syllabus: mutex, atomics, sharing, pools, channels, context, async", function()
    t.eq(#Quests[GO_QUEST].maps, 7, "seven streets")
    t.eq(stations(GO_QUEST), "MUTEX ATOMIC SHARE POOL PIPE CONTEXT ASYNC")
    local n = 0
    for _, m in ipairs(Quests[GO_QUEST].maps) do
      t.ok(m.id:sub(1, 3) ~= "rs_" and m.id:sub(1, 3) ~= "py_", m.id .. " is a Go street")
      t.eq(m.viz, "chips", m.id .. " draws the chips scene")
      t.ok(type(m.chips) == "table" and #m.chips >= 2 and #m.chips <= 4, m.id .. " has 2-4 chips")
      t.ok(type(m.note) == "string" and #m.note > 0 and #m.note <= 48, m.id .. " has a note")
      t.eq(#m.stages, 6, m.id .. " has six blanks")
      n = n + #m.stages
    end
    t.eq(n, 42, "42 blanks in the quest")

    local a = answers(GO_QUEST)
    for _, want in ipairs({
      "sync.Mutex", -- the lock itself
      "RWMutex",
      "TryLock",
      "CompareAndSwap", -- atomics
      "OnceValue",
      "communicating", -- shared state
      "race",
      "heap",
      "GOMAXPROCS", -- goroutines onto OS threads
      "NumCPU",
      "<-chan", -- channels
      "cap",
      "nil",
      "WithCancel", -- context
      "DeadlineExceeded",
      "go", -- async
      "<-res",
      "errgroup",
      "NumGoroutine",
    }) do
      t.ok(a[Game.norm(want)], "Q7 teaches " .. want)
    end
  end)

  t.it(
    "P6 walks the Python multiprocessing syllabus: GIL, Process, Pool, Queue, locks, shared memory, futures",
    function()
      t.eq(#Quests[PY_QUEST].maps, 7, "seven streets")
      t.eq(stations(PY_QUEST), "GIL PROCESS POOL QUEUE LOCK SHARED FUTURES")
      local n = 0
      for _, m in ipairs(Quests[PY_QUEST].maps) do
        t.eq(m.id:sub(1, 3), "py_", m.id .. " is a Python street")
        t.eq(m.viz, "python", m.id .. " draws the Python scene")
        t.ok(type(m.chips) == "table" and #m.chips >= 2 and #m.chips <= 4, m.id .. " has 2-4 chips")
        t.ok(type(m.note) == "string" and #m.note > 0 and #m.note <= 48, m.id .. " has a note")
        t.eq(#m.stages, 6, m.id .. " has six blanks")
        n = n + #m.stages
      end
      t.eq(n, 42, "42 blanks in the quest")

      local a = answers(PY_QUEST)
      for _, want in ipairs({
        "GIL", -- why threads do not scale
        "multiprocessing",
        "cpu_count",
        "Process", -- processes
        "__name__",
        "spawn",
        "exitcode",
        "Pool", -- pools
        "starmap",
        "chunksize",
        "Queue", -- talking between processes
        "Pipe",
        "picklable",
        "task_done",
        "Lock", -- sharing safely
        "get_lock",
        "Manager",
        "SharedMemory", -- shared memory
        "unlink",
        "ProcessPoolExecutor", -- futures
        "as_completed",
        "run_in_executor",
      }) do
        t.ok(a[Game.norm(want)], "P6 teaches " .. want)
      end
    end
  )

  t.it("every blank of both quests is answerable, unique in its street and never spelled in the code", function()
    for _, q in ipairs({ GO_QUEST, PY_QUEST }) do
      for _, m in ipairs(Quests[q].maps) do
        local seen = {}
        for si, st in ipairs(m.stages) do
          local where = Quests[q].tag .. "/" .. m.id .. "/" .. si
          local norm = Game.norm(st.answer)
          t.ok(norm ~= "", where .. " survives the loose matcher")
          t.ok(not seen[norm], where .. " repeats an answer of the same street: " .. st.answer)
          seen[norm] = true
          t.ok(Game.accepts(st.answer, st.accept), where .. " accepts its own answer")
          for _, alt in ipairs(st.accept) do
            t.ok(Game.accepts(alt, st.accept), where .. " accepts the listed variant " .. alt)
          end
          t.ok(not Game.accepts("definitely not it", st.accept), where .. " rejects a wrong answer")

          local en = I18n.pick(st.code, "en")
          local want = blanks(en)
          t.ok(want >= 1, where .. " has a blank")
          for _, lang in ipairs({ "ko", "yue" }) do
            t.eq(blanks(I18n.pick(st.code, lang)), want, where .. " keeps its blanks in " .. lang)
          end
          -- the code must not hand a real word of an answer over (a one or
          -- two character answer like i or <- lives in the code by nature)
          if #st.answer >= 3 then
            local stripped = en:gsub("___", "\1")
            t.ok(not stripped:find(st.answer, 1, true), where .. " does not spell " .. st.answer .. " in the code")
          end
          local lines = 0
          for _ in (en:gsub("\n+$", "") .. "\n"):gmatch("(.-)\n") do
            lines = lines + 1
          end
          t.ok(lines <= 7, where .. " code fits in seven lines (" .. lines .. ")")
        end
      end
    end
  end)

  t.it("clearing all seven THREADS streets stamps SYNCED and leaves the other Go quests open", function()
    local g = fresh()
    g:setQuest(GO_QUEST)
    t.eq(g:track(), "go")
    t.eq(g:questIndex(), 7, "QUEST 7 of the Go track")
    press(g, "1")
    t.eq(g.state, "play")
    t.eq(g:map().id, "mutex", "the quest starts at the till")

    for i = 1, 7 do
      t.eq(g.step, i)
      local m = g:map()
      for _, st in ipairs(m.stages) do
        type_(g, st.answer)
        press(g, "return")
      end
      t.eq(g.solved, true, m.id .. " clear")
      t.eq(g.perfect, true, m.id .. " solved clean")
      press(g, "return")
    end

    t.eq(g.state, "win")
    t.eq(g:questDef().win.stamp, "SYNCED")
    t.eq(g:clearedCount(GO_QUEST), 7)
    t.eq(g:clearedCount(1), 0, "Q1 is still open")
    t.eq(g.cleared["mutex"], true)
    t.eq(g.cleared["async"], true)
    local n, total = g:trackCleared("go")
    t.eq(n, 7, "seven Go streets clear")
    t.eq(total, #Quests.ofTrack("go") * 7, "every Go quest has seven streets")
    t.eq(select(1, g:trackCleared("python")), 0, "the Python track is untouched")
  end)

  t.it("clearing all seven PARALLEL streets stamps SCALED and survives a save", function()
    local g = fresh()
    press(g, "tab")
    press(g, "tab")
    t.eq(g:track(), "python", "two TABs reach the Python track")
    g:setQuest(PY_QUEST)
    press(g, "1")
    t.eq(g:map().id, "py_gil", "the night batch starts on the GIL")

    for i = 1, 7 do
      t.eq(g.step, i)
      local m = g:map()
      for _, st in ipairs(m.stages) do
        type_(g, st.answer)
        press(g, "return")
      end
      press(g, "return")
    end
    t.eq(g.state, "win")
    t.eq(g:questDef().win.stamp, "SCALED")
    local n, total = g:trackCleared("python")
    t.eq(n, 7)
    t.eq(total, 42, "six Python quests of seven streets")

    local g2 = Game.new()
    g2:ingestProgress(require("src.persist").loadProgress())
    g2:enterTitle()
    t.eq(g2:track(), "python")
    t.eq(g2.quest, PY_QUEST, "the save remembers the parallel quest")
    t.eq(g2.cleared["py_exec"], true, "CLEARED streets came along")
    t.eq(g2:clearedCount(PY_QUEST), 7)
  end)

  t.it("a wrong answer breaks the combo on a THREADS street and the right one still clears it", function()
    local g = fresh()
    g:setQuest(GO_QUEST)
    press(g, "5") -- PIPE
    t.eq(g:map().id, "pipe")
    local stages = g:map().stages
    type_(g, stages[1].answer)
    press(g, "return")
    t.eq(g.streak, 1)
    type_(g, "chan")
    press(g, "return")
    t.eq(g.streak, 0, "a miss resets the streak")
    t.eq(g.misses, 1)
    for _ = 1, 4 do
      press(g, "backspace")
    end
    for i = 2, #stages do
      type_(g, stages[i].answer)
      press(g, "return")
    end
    t.eq(g.solved, true)
    t.eq(g.perfect, false, "no PERFECT after a miss")
    t.eq(g.cleared["pipe"], true)
  end)

  t.it("SHARE exports a THREADS street as Go and a PARALLEL street as Python", function()
    local g = fresh()
    g:setQuest(GO_QUEST)
    press(g, "7") -- ASYNC
    local rows = Share.rows(g, "street")
    t.eq(#rows, 6, "one row per blank")
    t.eq(rows[1].station, "ASYNC")
    t.eq(rows[1].track, "go")
    local md = Share.markdown(rows, Share.title(g, "street"))
    t.has(md, "```go", "Go code is fenced as go")
    t.has(md, "___", "the blank travels with the code")
    t.has(md, "errgroup", "the quest's own answers are in the export")

    press(g, "escape") -- back to the map before switching quest
    g:setQuest(PY_QUEST)
    press(g, "6") -- SHARED
    local prows = Share.rows(g, "street")
    t.eq(prows[1].station, "SHARED")
    t.eq(prows[1].track, "python")
    local pmd = Share.markdown(prows, Share.title(g, "street"))
    t.has(pmd, "```python", "Python code is fenced as python")
    t.has(pmd, "SharedMemory")

    local track = Share.rows(g, "track")
    local all = 0
    for _, q in ipairs(Quests.ofTrack("python")) do
      for _, m in ipairs(Quests[q].maps) do
        all = all + #m.stages
      end
    end
    t.eq(#track, all, "the track export now covers PARALLEL too")
  end)

  t.it("both quests read in all seven languages, and zh / ja / es / cs are translated, not English", function()
    local translated = { "zh", "ja", "es", "cs" }
    for _, q in ipairs({ GO_QUEST, PY_QUEST }) do
      local quest = Quests[q]
      for _, lang in ipairs(I18n.LANGS) do
        t.ok(#I18n.pick(quest.name, lang) > 0, quest.id .. " name in " .. lang)
        t.ok(#I18n.pick(quest.goal, lang) > 0, quest.id .. " goal in " .. lang)
      end
      for _, lang in ipairs(translated) do
        t.ok(I18n.pick(quest.goal, lang) ~= quest.goal.en, quest.id .. " goal is really translated in " .. lang)
      end
    end

    for _, key in ipairs({ "twin_title", "twin_head", "mpwin_title", "mpwin_head" }) do
      local en = I18n.pick(I18n.STRINGS[key], "en")
      t.ok(#en > 0, key .. " exists")
      for _, lang in ipairs(translated) do
        t.ok(I18n.pick(I18n.STRINGS[key], lang) ~= en, key .. " is translated in " .. lang)
      end
    end
    t.has(I18n.pick(I18n.STRINGS.twin_head, "en"), "SYNCED")
    t.has(I18n.pick(I18n.STRINGS.mpwin_head, "en"), "SCALED")
  end)

  t.it("every string of both data files is translated in zh, ja, es and cs", function()
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
    walk(require "src.data_conc")
    walk(require "src.data_py_mp")
    t.ok(#strings > 400, "found the strings (" .. #strings .. ")")

    for _, lang in ipairs({ "zh", "ja", "es", "cs" }) do
      local tr = I18n.TR[lang]
      t.ok(tr ~= nil, lang .. " has a src/lang file")
      local missing, bad = {}, {}
      for _, v in ipairs(strings) do
        local s = tr and tr[v.en]
        if not s then
          if #missing < 3 then
            missing[#missing + 1] = v.en:sub(1, 48)
          end
        else
          local _, a = v.en:gsub("___", "")
          local _, b = s:gsub("___", "")
          if a ~= b and #bad < 3 then
            bad[#bad + 1] = v.en:sub(1, 48)
          end
        end
      end
      t.eq(#missing, 0, lang .. " missing: " .. table.concat(missing, " | "))
      t.eq(#bad, 0, lang .. " loses a blank in: " .. table.concat(bad, " | "))
    end
  end)

  t.it("AUTO plays a PARALLEL street on its own", function()
    local g = fresh()
    g:setQuest(PY_QUEST)
    press(g, "2") -- PROCESS
    t.eq(g:map().id, "py_proc")
    press(g, "f5")
    t.eq(g.auto, true)
    for _ = 1, 4000 do
      g:update(0.1)
      g.frame = g.frame + 1
      if g.solved then
        break
      end
    end
    t.eq(g.solved, true, "AUTO answered every blank of py_proc")
    t.eq(g.cleared["py_proc"], true)
  end)
end
