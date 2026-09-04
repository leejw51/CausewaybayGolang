-- Display + first-run setup as JSONL in ~/.causewaybaygo
--
--   setup.jsonl     event=setup (once), event=display (every toggle)
--   progress.jsonl  event=progress (every solved blank / map)
--
-- Last readable line of each kind wins on the next launch.

local Store = require "src.store"
local Json = require "src.json"

local Persist = {
  SETUP = "setup.jsonl",
  PROGRESS = "progress.jsonl",
  STATS = "stats.jsonl", -- event=stats: XP, level, counters, badges (last line wins)
  ANSWERS = "answers.jsonl", -- event=answer: every attempt, right or wrong, with its time
  EXPORTS = "exports.jsonl", -- event=copy / export: what left the game, and where to
}

local LOG_MAX, LOG_KEEP = 200, 40
-- the attempt log is the interesting one to keep: a long history, trimmed rarely
local LIMITS = {
  [Persist.ANSWERS] = { 5000, 4000 },
  [Persist.EXPORTS] = { 1000, 800 },
}

local function now()
  return os.date("!%Y-%m-%dT%H:%M:%SZ")
end

local function trim(name)
  local lines = Store.lines(name)
  local max, keepN = LOG_MAX, LOG_KEEP
  if LIMITS[name] then
    max, keepN = LIMITS[name][1], LIMITS[name][2]
  end
  if #lines <= max then
    return
  end
  local keep = {}
  for i = #lines - keepN + 1, #lines do
    keep[#keep + 1] = lines[i]
  end
  Store.write(name, table.concat(keep, "\n") .. "\n")
end

local function append(name, rec)
  rec.at = rec.at or now()
  local ok = Store.append(name, Json.encode(rec) .. "\n")
  if ok then
    trim(name)
  end
  return ok
end

local function last(name, pred)
  local lines = Store.lines(name)
  for i = #lines, 1, -1 do
    local rec = Json.decode(lines[i])
    if type(rec) == "table" and (not pred or pred(rec)) then
      return rec
    end
  end
  return nil
end

function Persist.root()
  return Store.root()
end

function Persist.ensureSetup(extra)
  local rec = last(Persist.SETUP, function(r)
    return r.event == "setup"
  end)
  if rec then
    return rec, false
  end
  extra = extra or {}
  local row = {
    event = "setup",
    app = "goset",
    version = 1,
    home = Store.root(),
    mode = extra.mode or "landscape",
    fullscreen = extra.fullscreen and true or false,
  }
  append(Persist.SETUP, row)
  return row, true
end

function Persist.saveDisplay(layout)
  return append(Persist.SETUP, {
    event = "display",
    mode = layout.mode,
    fullscreen = layout.fullscreen and true or false,
    lang = require("src.i18n").lang,
    sound = require("src.sfx").enabled,
  })
end

function Persist.loadDisplay()
  return last(Persist.SETUP, function(r)
    return r.event == "display" or r.event == "setup"
  end)
end

function Persist.saveProgress(game)
  local cleared = game.cleared
  if type(game.clearedIds) == "function" then
    cleared = game:clearedIds()
  elseif type(cleared) == "table" and not cleared[1] then
    local ids = {}
    for k, v in pairs(cleared) do
      if v then
        ids[#ids + 1] = tostring(k)
      end
    end
    table.sort(ids)
    cleared = ids
  end
  return append(Persist.PROGRESS, {
    event = "progress",
    state = game.state,
    quest = game.quest or 1,
    track = type(game.track) == "function" and game:track() or game.track,
    step = game.step,
    stage = type(game.progressStage) == "function" and game:progressStage() or game.stage,
    solved = game.solved and true or false,
    cleared = cleared or {},
  })
end

function Persist.parseCleared(rec)
  local set = {}
  if type(rec) ~= "table" then
    return set
  end
  local c = rec.cleared
  if type(c) == "table" then
    if #c > 0 then
      for i = 1, #c do
        set[tostring(c[i])] = true
      end
    else
      for k, v in pairs(c) do
        if v then
          set[tostring(k)] = true
        end
      end
    end
  end
  return set
end

function Persist.loadProgress()
  return last(Persist.PROGRESS, function(r)
    return r.event == "progress"
  end)
end

function Persist.boot()
  append(Persist.SETUP, { event = "boot", home = Store.root() })
end

-- One line into any of the logs above; `at` is filled in.
function Persist.log(name, rec)
  return append(name, rec)
end

-- Every record of a log, oldest first (the attempt history, for the stats).
function Persist.records(name, pred)
  local out = {}
  for _, line in ipairs(Store.lines(name)) do
    local rec = Json.decode(line)
    if type(rec) == "table" and (not pred or pred(rec)) then
      out[#out + 1] = rec
    end
  end
  return out
end

function Persist.saveStats(rec)
  rec.event = "stats"
  return append(Persist.STATS, rec)
end

function Persist.loadStats()
  return last(Persist.STATS, function(r)
    return r.event == "stats"
  end)
end

return Persist
