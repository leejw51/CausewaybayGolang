-- XP, levels and badges: the part of the game that makes a right answer feel
-- like more than a green line. Everything here is derived from play and
-- kept in ~/.causewaybaygo/stats.jsonl (last line wins), with every single
-- attempt appended to answers.jsonl so a session can be replayed later.
--
--   Stats.load()                    at boot
--   Stats.onAnswer(game, ok, secs)  -> { xp, fast, badges, level }
--   Stats.onClear(game, perfect)    -> same shape
--   Stats.onStamp(game)             -> same shape
--   Stats.onShare(kind)             -> same shape (kind: "copy" / "export")
--
-- The returned `level` is set only when the answer crossed a level.

local Persist = require "src.persist"
local Quests = require "src.quests"

local Stats = {}

-- XP per event
Stats.XP = {
  right = 10, -- a right answer
  combo = 3, -- extra per step of streak beyond the first
  comboCap = 30,
  fast = 5, -- answered within FAST seconds of seeing the blank
  clear = 25, -- a street CLEAR
  perfect = 50, -- a street cleared with no miss and no revealed answer
  stamp = 200, -- a quest's stamp
  badge = 40, -- every badge
}
Stats.FAST = 8 -- seconds

-- Badges, in the order they are listed. `name` is an i18n key.
Stats.BADGES = {
  { id = "first_clear", name = "badge_first_clear" },
  { id = "combo5", name = "badge_combo5" },
  { id = "combo10", name = "badge_combo10" },
  { id = "perfect", name = "badge_perfect" },
  { id = "perfect5", name = "badge_perfect5" },
  { id = "fast10", name = "badge_fast10" },
  { id = "right100", name = "badge_right100" },
  { id = "stamp", name = "badge_stamp" },
  { id = "trio", name = "badge_trio" },
  { id = "polyglot", name = "badge_polyglot" },
  { id = "bigo", name = "badge_bigo" },
  { id = "share", name = "badge_share" },
  { id = "night", name = "badge_night" },
  { id = "early", name = "badge_early" },
}

local function fresh()
  return {
    xp = 0,
    level = 1,
    right = 0,
    wrong = 0,
    fast = 0,
    perfects = 0,
    clears = 0,
    stamps = 0,
    copies = 0,
    exports = 0,
    bestStreak = 0,
    badges = {}, -- ordered list of ids
  }
end

Stats.s = fresh()

local function hasBadge(id)
  for _, b in ipairs(Stats.s.badges) do
    if b == id then
      return true
    end
  end
  return false
end
Stats.has = hasBadge

function Stats.badgeDef(id)
  for _, b in ipairs(Stats.BADGES) do
    if b.id == id then
      return b
    end
  end
  return nil
end

-- Total XP needed to stand on level n (level 1 is 0). Level 2 at 100,
-- 3 at 300, 4 at 600: the triangular numbers times 100.
function Stats.xpFor(level)
  level = math.max(1, level)
  return 50 * (level - 1) * level
end

function Stats.levelFor(xp)
  local lv = 1
  while Stats.xpFor(lv + 1) <= xp do
    lv = lv + 1
  end
  return lv
end

-- XP into the current level and the size of the level, for a bar.
function Stats.progress()
  local s = Stats.s
  local lo, hi = Stats.xpFor(s.level), Stats.xpFor(s.level + 1)
  return s.xp - lo, hi - lo
end

function Stats.reset()
  Stats.s = fresh()
end

function Stats.load()
  local rec = Persist.loadStats()
  Stats.s = fresh()
  if type(rec) ~= "table" then
    return Stats.s
  end
  local s = Stats.s
  for k, v in pairs(s) do
    if type(v) == "number" and type(rec[k]) == "number" then
      s[k] = rec[k]
    end
  end
  if type(rec.badges) == "table" then
    for _, id in ipairs(rec.badges) do
      if Stats.badgeDef(id) and not hasBadge(id) then
        s.badges[#s.badges + 1] = id
      end
    end
  end
  s.level = Stats.levelFor(s.xp)
  return s
end

function Stats.save()
  local s = Stats.s
  local rec = {}
  for k, v in pairs(s) do
    rec[k] = v
  end
  rec.badges = {}
  for i, id in ipairs(s.badges) do
    rec.badges[i] = id
  end
  return Persist.saveStats(rec)
end

-- Add XP; returns the new level when one was crossed.
local function gain(n, out)
  local s = Stats.s
  s.xp = s.xp + n
  out.xp = (out.xp or 0) + n
  local lv = Stats.levelFor(s.xp)
  if lv > s.level then
    s.level = lv
    out.level = lv
  end
end

local function award(id, out)
  if hasBadge(id) or not Stats.badgeDef(id) then
    return false
  end
  Stats.s.badges[#Stats.s.badges + 1] = id
  out.badges[#out.badges + 1] = id
  gain(Stats.XP.badge, out)
  return true
end
Stats.award = function(id)
  local out = { badges = {} }
  local ok = award(id, out)
  if ok then
    Stats.save()
  end
  return ok, out
end

-- Streets cleared per station label across tracks: RECURSE in Go, Rust and
-- Python is the same round three times. `cleared` is the game's id set.
local function stationsByTrack(cleared)
  local byStation = {}
  local tracks = {}
  for _, e in ipairs(Quests.allMaps()) do
    if cleared[e.map.id] then
      local track = Quests[e.quest].track
      tracks[track] = true
      byStation[e.map.station] = byStation[e.map.station] or {}
      byStation[e.map.station][track] = true
    end
  end
  return byStation, tracks
end

local function count(t)
  local n = 0
  for _ in pairs(t) do
    n = n + 1
  end
  return n
end

local function clockBadges(out)
  local hour = tonumber(os.date("%H")) or 12
  if hour >= 23 or hour < 5 then
    award("night", out)
  elseif hour >= 5 and hour < 7 then
    award("early", out)
  end
end

-- One attempt at a blank. `secs` is the time since the blank was shown.
function Stats.onAnswer(game, ok, secs)
  local s = Stats.s
  local out = { xp = 0, badges = {}, fast = false }
  local st = game.currentStage and game:currentStage() or nil
  local m = game.map and game:map() or nil
  Persist.log(Persist.ANSWERS, {
    event = "answer",
    ok = ok and true or false,
    quest = game.quest,
    track = type(game.track) == "function" and game:track() or nil,
    street = m and m.id or nil,
    stage = game.stage,
    topic = st and st.topic or nil,
    answer = st and st.answer or nil,
    input = game.input,
    secs = secs and math.floor(secs * 100 + 0.5) / 100 or nil,
    streak = game.streak,
  })
  if not ok then
    s.wrong = s.wrong + 1
    Stats.save()
    return out
  end
  s.right = s.right + 1
  gain(Stats.XP.right, out)
  local streak = game.streak or 0
  if streak > s.bestStreak then
    s.bestStreak = streak
  end
  if streak >= 2 then
    gain(math.min(Stats.XP.comboCap, Stats.XP.combo * (streak - 1)), out)
  end
  if secs and secs <= Stats.FAST then
    s.fast = s.fast + 1
    out.fast = true
    gain(Stats.XP.fast, out)
  end
  if streak >= 5 then
    award("combo5", out)
  end
  if streak >= 10 then
    award("combo10", out)
  end
  if s.fast >= 10 then
    award("fast10", out)
  end
  if s.right >= 100 then
    award("right100", out)
  end
  clockBadges(out)
  Stats.save()
  return out
end

-- A street CLEAR. The game has already marked it in game.cleared.
function Stats.onClear(game, perfect)
  local s = Stats.s
  local out = { xp = 0, badges = {} }
  s.clears = s.clears + 1
  gain(Stats.XP.clear, out)
  award("first_clear", out)
  if perfect then
    s.perfects = s.perfects + 1
    gain(Stats.XP.perfect, out)
    award("perfect", out)
    if s.perfects >= 5 then
      award("perfect5", out)
    end
  end
  local byStation, tracks = stationsByTrack(game.cleared or {})
  if count(tracks) >= 3 then
    award("trio", out)
  end
  for _, tr in pairs(byStation) do
    if count(tr) >= 3 then
      award("polyglot", out)
      break
    end
  end
  Stats.save()
  return out
end

-- A quest's stamp.
function Stats.onStamp(game)
  local s = Stats.s
  local out = { xp = 0, badges = {} }
  s.stamps = s.stamps + 1
  gain(Stats.XP.stamp, out)
  award("stamp", out)
  local quest = Quests[game.quest]
  if quest and quest.station == "BIG O" then
    award("bigo", out)
  end
  Stats.save()
  return out
end

-- A copy or an export.
function Stats.onShare(kind)
  local s = Stats.s
  local out = { xp = 0, badges = {} }
  if kind == "copy" then
    s.copies = s.copies + 1
  else
    s.exports = s.exports + 1
  end
  award("share", out)
  Stats.save()
  return out
end

return Stats
