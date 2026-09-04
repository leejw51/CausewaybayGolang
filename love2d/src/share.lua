-- COPY and EXPORT: get a quiz out of the game.
--
--   Share.copy(game, part)          clipboard: "q", "hint", "answer" or "all"
--                                   of the blank on screen, so the player can
--                                   paste it to their AI and ask why
--   Share.export(game, fmt, scope)  ~/Downloads/causewaybaygo-....<ext>
--                                   fmt: md csv jsonl txt sqlite png
--                                   scope: "street" (the blanks of this
--                                   street), "quest" (its seven streets) or
--                                   "track" (every quest of the language)
--   Share.exportAll(game, scope)    every format at once
--
-- The PNG is the "disk": one square image, 512 px up to 2048 px, that holds
-- every question, hint and answer of the scope; when 2048 px is not enough
-- the type gets smaller until it fits. Carried in a photo album, it is a
-- lesson that opens anywhere.
--
-- Everything that leaves is logged to ~/.causewaybaygo/exports.jsonl.

local I18n = require "src.i18n"
local Quests = require "src.quests"
local Persist = require "src.persist"
local Json = require "src.json"
local Theme = require "src.theme"
local P = I18n.pick
local T = I18n.t

local Share = {}

Share.PARTS = { "q", "hint", "answer", "all" }
Share.SCOPES = { "street", "quest", "track" }
Share.FORMATS = { "md", "csv", "jsonl", "txt", "sqlite", "png" }
Share.EXT = { md = "md", csv = "csv", jsonl = "jsonl", txt = "txt", sqlite = "sqlite", png = "png" }

-- ~/Downloads, or GOSET_DOWNLOADS, or whatever Share.use() set (the tests
-- point it at a scratch dir).
Share.dir = nil
function Share.use(dir)
  Share.dir = dir and (dir:gsub("/+$", "")) or nil
  return Share.dir
end

function Share.downloads()
  local d = Share.dir or os.getenv("GOSET_DOWNLOADS")
  if not d or d == "" then
    local home = os.getenv("HOME") or os.getenv("USERPROFILE") or "."
    d = home .. "/Downloads"
  end
  d = d:gsub("/+$", "")
  os.execute(string.format('mkdir -p "%s" 2>/dev/null', d))
  return d
end

local function shortHome(path)
  local home = os.getenv("HOME")
  if home and path:sub(1, #home) == home then
    return "~" .. path:sub(#home + 1)
  end
  return path
end
Share.shortHome = shortHome

-- ---------------------------------------------------------------- rows

-- One row per blank, everything the exports need, in the current language.
local function row(game, q, step, m, si, st)
  local quest = Quests[q]
  return {
    track = quest.track,
    quest = quest.tag,
    questName = P(quest.name),
    step = step,
    station = m.station,
    street = P(m.title),
    place = P(m.name),
    stage = si,
    topic = st.topic or "",
    question = P(st.q),
    code = P(st.code):gsub("\n+$", ""),
    hint = P(st.hint),
    answer = st.answer or st.accept[1],
    accept = st.accept,
    why = P(st.ok),
    lesson = P(m.lesson),
    cleared = game.cleared[m.id] == true,
    id = m.id,
  }
end

function Share.rows(game, scope)
  scope = scope or "street"
  local out = {}
  local quests
  if scope == "track" then
    quests = Quests.ofTrack(game:track())
  else
    quests = { game.quest }
  end
  for _, q in ipairs(quests) do
    local maps = Quests[q].maps
    for step, m in ipairs(maps) do
      if scope ~= "street" or (q == game.quest and step == game.step) then
        for si, st in ipairs(m.stages) do
          out[#out + 1] = row(game, q, step, m, si, st)
        end
      end
    end
  end
  return out
end

-- The title line of an export: which language, quest and street it holds.
function Share.title(game, scope)
  local quest = game:questDef()
  local label = game:trackDef().label
  if scope == "track" then
    return string.format("CAUSEWAYBAY GO  ·  %s TRACK", label)
  elseif scope == "quest" then
    return string.format("CAUSEWAYBAY GO  ·  %s %s  %s", label, quest.tag, P(quest.name))
  end
  local m = game:map()
  return string.format("CAUSEWAYBAY GO  ·  %s %s  %d %s  ·  %s", label, quest.tag, game.step, m.station, P(m.title))
end

-- ---------------------------------------------------------------- copy

-- The text for one part of the blank on screen. "all" ends with a question
-- the player can paste straight to their AI.
function Share.text(game, part)
  local st = game:currentStage()
  local m = game:map()
  local quest = game:questDef()
  local head = string.format(
    "[%s %s  %d/%d %s  ·  %s %d/%d]",
    game:trackDef().label,
    quest.tag,
    game.step,
    #quest.maps,
    m.station,
    st.topic or "CODE",
    game.stage,
    #m.stages
  )
  local code = P(st.code):gsub("\n+$", "")
  local answer = st.answer or st.accept[1]
  local lines = {}
  local function add(s)
    lines[#lines + 1] = s
  end
  if part == "q" then
    add(head)
    add("Q: " .. P(st.q))
    add("")
    add(code)
  elseif part == "hint" then
    add(head)
    add("Q: " .. P(st.q))
    add("HINT: " .. P(st.hint))
  elseif part == "answer" then
    add(head)
    add("Q: " .. P(st.q))
    add("ANSWER: " .. answer)
    add("WHY: " .. P(st.ok))
  else
    add(head)
    add(P(m.story))
    add("")
    add("Q: " .. P(st.q))
    add("")
    add(code)
    add("")
    add("HINT: " .. P(st.hint))
    add("ANSWER: " .. answer)
    add("WHY: " .. P(st.ok))
    add("")
    add(T("share_ask", answer))
  end
  return table.concat(lines, "\n")
end

function Share.copy(game, part)
  part = part or "all"
  local text = Share.text(game, part)
  local ok = pcall(function()
    love.system.setClipboardText(text)
  end)
  Persist.log(Persist.EXPORTS, {
    event = "copy",
    part = part,
    quest = game.quest,
    street = game:map().id,
    stage = game.stage,
    chars = #text,
    ok = ok,
  })
  return ok, text
end

-- ---------------------------------------------------------------- writers

local function csvField(s)
  s = tostring(s == nil and "" or s)
  if s:find('[",\n\r]') then
    return '"' .. s:gsub('"', '""') .. '"'
  end
  return s
end

local COLUMNS = {
  "track",
  "quest",
  "step",
  "station",
  "street",
  "stage",
  "topic",
  "question",
  "code",
  "hint",
  "answer",
  "why",
  "lesson",
  "cleared",
}

function Share.csv(rows)
  local out = { table.concat(COLUMNS, ",") }
  for _, r in ipairs(rows) do
    local cells = {}
    for i, c in ipairs(COLUMNS) do
      local v = r[c]
      if type(v) == "boolean" then
        v = v and "true" or "false"
      end
      cells[i] = csvField(v)
    end
    out[#out + 1] = table.concat(cells, ",")
  end
  return table.concat(out, "\n") .. "\n"
end

function Share.jsonl(rows, title)
  local out = {}
  for _, r in ipairs(rows) do
    local rec = { title = title }
    for _, c in ipairs(COLUMNS) do
      rec[c] = r[c]
    end
    rec.accept = r.accept
    out[#out + 1] = Json.encode(rec)
  end
  return table.concat(out, "\n") .. "\n"
end

function Share.markdown(rows, title)
  local out = { "# " .. title, "" }
  local lastStreet = nil
  for _, r in ipairs(rows) do
    local key = r.quest .. r.step
    if key ~= lastStreet then
      lastStreet = key
      out[#out + 1] = string.format("## %s %d  %s  —  %s", r.quest, r.step, r.station, r.street)
      out[#out + 1] = ""
      out[#out + 1] = "_" .. r.lesson .. "_"
      out[#out + 1] = ""
    end
    out[#out + 1] = string.format("### %d. %s", r.stage, r.topic)
    out[#out + 1] = ""
    out[#out + 1] = "**Q:** " .. r.question
    out[#out + 1] = ""
    out[#out + 1] = "```" .. (Quests.trackDef(r.track).lang or "")
    out[#out + 1] = r.code
    out[#out + 1] = "```"
    out[#out + 1] = ""
    out[#out + 1] = "- **Hint:** " .. r.hint
    out[#out + 1] = "- **Answer:** `" .. r.answer .. "`"
    out[#out + 1] = "- **Why:** " .. r.why
    out[#out + 1] = ""
  end
  return table.concat(out, "\n")
end

function Share.txt(rows, title)
  local out = { title, string.rep("=", #title), "" }
  for _, r in ipairs(rows) do
    out[#out + 1] =
      string.format("[%s %s %d %s · %s %d]", r.track:upper(), r.quest, r.step, r.station, r.topic, r.stage)
    out[#out + 1] = "Q: " .. r.question
    out[#out + 1] = ""
    out[#out + 1] = r.code
    out[#out + 1] = ""
    out[#out + 1] = "HINT: " .. r.hint
    out[#out + 1] = "ANSWER: " .. r.answer
    out[#out + 1] = "WHY: " .. r.why
    out[#out + 1] = ""
    out[#out + 1] = string.rep("-", 40)
    out[#out + 1] = ""
  end
  return table.concat(out, "\n")
end

local function sqlStr(s)
  return "'" .. tostring(s == nil and "" or s):gsub("'", "''") .. "'"
end

function Share.sql(rows, title)
  local out = {
    "-- " .. title,
    "CREATE TABLE IF NOT EXISTS quiz (",
    "  id INTEGER PRIMARY KEY,",
    "  track TEXT, quest TEXT, step INTEGER, station TEXT, street TEXT,",
    "  stage INTEGER, topic TEXT, question TEXT, code TEXT, hint TEXT,",
    "  answer TEXT, accept TEXT, why TEXT, lesson TEXT, cleared INTEGER",
    ");",
    "BEGIN;",
  }
  for _, r in ipairs(rows) do
    out[#out + 1] = string.format(
      "INSERT INTO quiz (track, quest, step, station, street, stage, topic, question, code, hint, answer, accept, why, lesson, cleared) VALUES (%s, %s, %d, %s, %s, %d, %s, %s, %s, %s, %s, %s, %s, %s, %d);",
      sqlStr(r.track),
      sqlStr(r.quest),
      r.step,
      sqlStr(r.station),
      sqlStr(r.street),
      r.stage,
      sqlStr(r.topic),
      sqlStr(r.question),
      sqlStr(r.code),
      sqlStr(r.hint),
      sqlStr(r.answer),
      sqlStr(table.concat(r.accept, " | ")),
      sqlStr(r.why),
      sqlStr(r.lesson),
      r.cleared and 1 or 0
    )
  end
  out[#out + 1] = "COMMIT;"
  return table.concat(out, "\n") .. "\n"
end

-- ---------------------------------------------------------------- png

-- The page: title band, then for every blank its station, question, code,
-- hint, answer and why. Laid out at an absolute type size; the square grows
-- through SIZES to hold it and, at the largest, the type shrinks.
local SIZES = { 512, 640, 768, 1024, 1280, 1536, 2048 }
local BODY_PT = 22
local MIN_PT = 9

local function wrapCount(font, text, w)
  local _, lines = font:getWrap(text, math.max(8, w))
  return math.max(1, #lines)
end

-- Height the page needs at size S with body type pt. Returns the height and
-- the fonts, so the draw uses the same measure.
local function measure(rows, title, S, pt)
  local assets = require "src.assets"
  local body = assets.fontAt(pt, "body")
  local head = assets.fontAt(math.max(8, math.floor(pt * 0.55)), "pixel")
  local big = assets.fontAt(math.max(8, math.floor(pt * 0.75)), "pixel")
  local m = math.floor(S * 0.04)
  local w = S - m * 2
  local lh = body:getHeight()
  local y = m + big:getHeight() + head:getHeight() + math.floor(lh * 1.2)
  local lastStreet
  for _, r in ipairs(rows) do
    local key = r.quest .. r.step
    if key ~= lastStreet then
      lastStreet = key
      y = y + head:getHeight() + math.floor(lh * 0.6)
    end
    y = y + head:getHeight() + 4
    y = y + wrapCount(body, r.question, w) * lh
    for _ in (r.code .. "\n"):gmatch("(.-)\n") do
      y = y + lh
    end
    y = y + wrapCount(body, r.hint, w - lh * 3) * lh
    y = y + lh
    y = y + wrapCount(body, r.why, w - lh * 3) * lh
    y = y + math.floor(lh * 0.8)
  end
  y = y + head:getHeight() + m
  return y, { body = body, head = head, big = big, m = m, w = w, lh = lh }
end

local function drawPage(rows, title, S, F, game)
  local sub = string.format("%s  ·  %d Q  ·  %s", os.date("%Y-%m-%d"), #rows, T("share_png_foot"))
  local m, w, lh = F.m, F.w, F.lh
  local ink = { 0.10, 0.08, 0.16, 1 }
  local paper = { 0.99, 0.96, 0.88, 1 }
  local code = { 0.14, 0.12, 0.28, 1 }
  local blank = { 0.86, 0.32, 0.04, 1 }
  local green = { 0.05, 0.50, 0.22, 1 }
  local dim = { 0.40, 0.36, 0.34, 1 }
  love.graphics.clear(paper)
  -- title band
  love.graphics.setColor(Theme.navy)
  local bandH = m + F.big:getHeight() + F.head:getHeight() + math.floor(lh * 0.6)
  love.graphics.rectangle("fill", 0, 0, S, bandH)
  love.graphics.setColor(Theme.coin)
  love.graphics.rectangle("fill", 0, bandH - 4, S, 4)
  love.graphics.setFont(F.big)
  love.graphics.setColor(Theme.coin)
  love.graphics.printf(title, m, m * 0.6, w, "left")
  love.graphics.setFont(F.head)
  love.graphics.setColor(Theme.cream)
  love.graphics.printf(sub, m, m * 0.6 + F.big:getHeight() + 4, w, "left")
  -- the mascot of the track in the corner of the band
  if game then
    local assets = require "src.assets"
    local def = game:trackDef()
    local name = def.item == "ferris" and "sprite_ferris" or def.item == "monty" and "sprite_monty" or "sprite_gogo"
    assets.mascot(name, S - m - bandH * 0.35, bandH - 8, bandH * 0.7, 0, { still = true })
  end

  local y = bandH + math.floor(lh * 0.6)
  local lastStreet
  for _, r in ipairs(rows) do
    local key = r.quest .. r.step
    if key ~= lastStreet then
      lastStreet = key
      love.graphics.setFont(F.head)
      love.graphics.setColor(Theme.brick)
      love.graphics.printf(string.format("%s %d  %s  —  %s", r.quest, r.step, r.station, r.street), m, y, w, "left")
      y = y + F.head:getHeight() + math.floor(lh * 0.6)
    end
    love.graphics.setFont(F.head)
    love.graphics.setColor(ink)
    love.graphics.printf(string.format("%d. %s", r.stage, r.topic), m, y, w, "left")
    y = y + F.head:getHeight() + 4
    love.graphics.setFont(F.body)
    love.graphics.setColor(ink)
    love.graphics.printf(r.question, m, y, w, "left")
    y = y + wrapCount(F.body, r.question, w) * lh
    for line in (r.code .. "\n"):gmatch("(.-)\n") do
      if line:find("___", 1, true) then
        love.graphics.setColor(blank)
      elseif line:match("^%s*#") or line:match("^%s*//") then
        love.graphics.setColor(dim)
      else
        love.graphics.setColor(code)
      end
      love.graphics.print(line, m + lh, y)
      y = y + lh
    end
    love.graphics.setColor(dim)
    love.graphics.print("?", m, y)
    love.graphics.setColor(ink)
    love.graphics.printf(r.hint, m + lh * 1.5, y, w - lh * 3, "left")
    y = y + wrapCount(F.body, r.hint, w - lh * 3) * lh
    love.graphics.setColor(green)
    love.graphics.print("= " .. r.answer, m, y)
    y = y + lh
    love.graphics.setColor(dim)
    love.graphics.print("!", m, y)
    love.graphics.setColor(ink)
    love.graphics.printf(r.why, m + lh * 1.5, y, w - lh * 3, "left")
    y = y + wrapCount(F.body, r.why, w - lh * 3) * lh
    y = y + math.floor(lh * 0.8)
  end
  love.graphics.setFont(F.head)
  love.graphics.setColor(dim)
  love.graphics.printf("causewaybaygo  ·  " .. T("share_png_foot"), m, S - m - F.head:getHeight(), w, "right")
end

-- Pick the smallest square that holds the page at BODY_PT; at the largest,
-- shrink the type. Returns size, pt.
function Share.fit(rows, title)
  for _, S in ipairs(SIZES) do
    local need = measure(rows, title, S, BODY_PT)
    if need <= S then
      return S, BODY_PT
    end
  end
  local S = SIZES[#SIZES]
  local pt = BODY_PT
  while pt > MIN_PT do
    pt = pt - 1
    if measure(rows, title, S, pt) <= S then
      return S, pt
    end
  end
  return S, MIN_PT
end

-- Render the page to ImageData (nil, err when the GPU refuses the canvas).
function Share.png(rows, title, game)
  local S, pt = Share.fit(rows, title)
  local _, F = measure(rows, title, S, pt)
  local ok, canvas = pcall(love.graphics.newCanvas, S, S)
  if not ok or not canvas then
    return nil, "canvas " .. S
  end
  local prev = love.graphics.getCanvas()
  love.graphics.push("all")
  love.graphics.origin()
  love.graphics.setScissor()
  love.graphics.setShader()
  love.graphics.setCanvas(canvas)
  drawPage(rows, title, S, F, game)
  love.graphics.setCanvas(prev)
  love.graphics.pop()
  local data = canvas:newImageData()
  canvas:release()
  return data, S, pt
end

-- ---------------------------------------------------------------- export

function Share.filename(game, scope, ext)
  local stamp = os.date("%Y%m%d-%H%M%S")
  local tail
  if scope == "track" then
    tail = game:track() .. "-track"
  elseif scope == "quest" then
    tail = game:track() .. "-" .. game:questDef().tag:lower()
  else
    tail = game:track() .. "-" .. game:questDef().tag:lower() .. "-" .. game:map().id
  end
  return string.format("causewaybaygo-%s-%s.%s", tail, stamp, ext)
end

local function writeFile(path, body)
  local f, err = io.open(path, "wb")
  if not f then
    return false, err
  end
  f:write(body)
  f:close()
  return true
end

local function haveSqlite()
  local r = os.execute("command -v sqlite3 >/dev/null 2>&1")
  return r == 0 or r == true
end
Share.haveSqlite = haveSqlite

-- Write one format. Returns the path written, or nil and a reason.
function Share.export(game, fmt, scope)
  scope = scope or "street"
  fmt = fmt or "md"
  local rows = Share.rows(game, scope)
  local title = Share.title(game, scope)
  local dir = Share.downloads()
  local path = dir .. "/" .. Share.filename(game, scope, Share.EXT[fmt] or fmt)
  local ok, err
  if fmt == "md" then
    ok, err = writeFile(path, Share.markdown(rows, title))
  elseif fmt == "csv" then
    ok, err = writeFile(path, Share.csv(rows))
  elseif fmt == "jsonl" then
    ok, err = writeFile(path, Share.jsonl(rows, title))
  elseif fmt == "txt" then
    ok, err = writeFile(path, Share.txt(rows, title))
  elseif fmt == "sqlite" then
    -- the SQL is written first; sqlite3 (on every macOS, most Linux) turns it
    -- into the database and the script is dropped. Without the CLI the .sql
    -- stays, which any SQLite can import.
    local sqlPath = path:gsub("%.sqlite$", ".sql")
    ok, err = writeFile(sqlPath, Share.sql(rows, title))
    if ok then
      if haveSqlite() then
        os.remove(path)
        local r = os.execute(string.format('sqlite3 "%s" < "%s" 2>/dev/null', path, sqlPath))
        if r == 0 or r == true then
          os.remove(sqlPath)
        else
          path = sqlPath
        end
      else
        path = sqlPath
      end
    end
  elseif fmt == "png" then
    local data, size = Share.png(rows, title, game)
    if not data then
      ok, err = false, size
    else
      local okEnc, fd = pcall(data.encode, data, "png")
      data:release()
      if okEnc and fd then
        ok, err = writeFile(path, fd:getString())
        fd:release()
      else
        ok, err = false, tostring(fd)
      end
    end
  else
    return nil, "unknown format " .. tostring(fmt)
  end
  Persist.log(Persist.EXPORTS, {
    event = "export",
    fmt = fmt,
    scope = scope,
    rows = #rows,
    path = ok and path or nil,
    ok = ok and true or false,
    err = (not ok) and tostring(err) or nil,
    quest = game.quest,
    street = game:map().id,
  })
  if not ok then
    return nil, err
  end
  return path
end

-- Every format; returns the list of paths and the first error, if any.
function Share.exportAll(game, scope)
  local paths, firstErr = {}, nil
  for _, fmt in ipairs(Share.FORMATS) do
    local p, err = Share.export(game, fmt, scope)
    if p then
      paths[#paths + 1] = p
    else
      firstErr = firstErr or err
    end
  end
  return paths, firstErr
end

return Share
