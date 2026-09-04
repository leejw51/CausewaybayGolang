-- The three tiers of "you did it", drawn over the scene:
--
--   small   a blank answered   a ring, a handful of sparkle stars, a short
--                              word that pops and drifts (0.7 s)
--   big     a street CLEAR     confetti rain, three shockwaves, a ribbon
--                              banner that drops in with its letters landing
--                              one by one, a medal for a PERFECT (2.8 s)
--   quest   the quest's stamp  fireworks that keep going, heavy confetti,
--                              gold rays, the trophy and the banner (5 s)
--
-- Sprites (assets/fx_*.png, Grok on magenta, knocked out by src/assets.lua)
-- are used when loaded and fall back to primitives when not, so the
-- effects run in the headless test suite and in a build with no art.
-- Everything is data until draw(): update() never touches love.graphics.

local ease = require "src.ease"
local Theme = require "src.theme"

local FX = {}
FX.__index = FX

FX.LIFE = { small = 0.7, big = 2.8, quest = 5.0 }

local PALETTE = { Theme.coin, Theme.cream, Theme.cyan, Theme.pink, Theme.admit, Theme.red }

local function rnd(a, b)
  local r = (love and love.math and love.math.random or math.random)()
  if a == nil then
    return r
  end
  return a + (b - a) * r
end

local function utf8chars(s)
  local out = {}
  for ch in tostring(s):gmatch("[%z\1-\127\194-\244][\128-\191]*") do
    out[#out + 1] = ch
  end
  return out
end

function FX.new()
  return setmetatable({
    t = 0,
    bits = {}, -- stars and confetti
    rings = {}, -- expanding shockwaves
    banners = {}, -- the ribbon with per-letter text
    words = {}, -- the small tier's word
    fuses = {}, -- fireworks still to go off
    rays = nil, -- the gold sunburst behind a quest banner
  }, FX)
end

-- ---------------------------------------------------------------- spawn

function FX:star(x, y, speed, life)
  local ang = rnd() * math.pi * 2
  local sp = speed * (0.5 + rnd())
  self.bits[#self.bits + 1] = {
    kind = "star",
    x = x,
    y = y,
    vx = math.cos(ang) * sp,
    vy = math.sin(ang) * sp - speed * 0.25,
    rot = rnd() * math.pi,
    vr = rnd(-6, 6),
    g = 260,
    life = life,
    max = life,
    s = 0.5 + rnd() * 0.7,
    tint = rnd() < 0.7 and Theme.coin or Theme.cream,
  }
end

function FX:confetti(x, y, vx, vy, life)
  self.bits[#self.bits + 1] = {
    kind = "confetti",
    x = x,
    y = y,
    vx = vx,
    vy = vy,
    rot = rnd() * math.pi,
    vr = rnd(-9, 9),
    g = 120,
    drag = 1.6,
    flutter = rnd(2, 5),
    phase = rnd() * math.pi * 2,
    life = life,
    max = life,
    s = 0.6 + rnd() * 0.8,
    tint = PALETTE[math.floor(rnd(1, #PALETTE + 1))],
  }
end

function FX:ring(x, y, r1, col, life)
  self.rings[#self.rings + 1] = { x = x, y = y, t = 0, max = life or 0.5, r1 = r1, col = col or Theme.coin }
end

-- One firework: a ring and a shell of stars.
function FX:firework(x, y, n)
  self:ring(x, y, 90, PALETTE[math.floor(rnd(1, #PALETTE + 1))], 0.6)
  for _ = 1, n do
    self:star(x, y, 240, 0.9 + rnd() * 0.7)
  end
end

-- ---------------------------------------------------------------- tiers
--
-- Every tier takes the rect it plays in ({ x, y, w, h }): the scene while
-- playing, the whole screen on the stamp.

function FX:small(x, y, text)
  self:ring(x, y, 70, Theme.coin, 0.45)
  for _ = 1, 10 do
    self:star(x, y, 170, 0.45 + rnd() * 0.3)
  end
  if text and text ~= "" then
    self.words[#self.words + 1] = {
      text = text,
      x = x,
      y = y - 24,
      t = 0,
      max = FX.LIFE.small,
      col = Theme.cream,
    }
  end
end

function FX:big(rect, text, perfect)
  local cx, cy = rect.x + rect.w * 0.5, rect.y + rect.h * 0.42
  -- three shockwaves, one after the other
  for i = 0, 2 do
    self.rings[#self.rings + 1] = {
      x = cx,
      y = cy,
      t = -i * 0.12,
      max = 0.7,
      r1 = rect.w * 0.45,
      col = ({ Theme.coin, Theme.cream, Theme.cyan })[i + 1],
    }
  end
  for _ = 1, 28 do
    self:star(cx, cy, 260, 0.8 + rnd() * 0.6)
  end
  -- confetti from the top edge, the whole width
  for _ = 1, 70 do
    self:confetti(rect.x + rnd() * rect.w, rect.y - rnd() * 60, rnd(-40, 40), rnd(20, 90), 2.2 + rnd())
  end
  self.banners[#self.banners + 1] = {
    kind = "big",
    text = text,
    letters = utf8chars(text),
    t = 0,
    max = FX.LIFE.big,
    x = cx,
    y = rect.y + rect.h * 0.56,
    icon = perfect and "fx_medal" or nil,
    w = rect.w,
  }
end

function FX:quest(rect, text)
  local cx = rect.x + rect.w * 0.5
  self.rays = { x = cx, y = rect.y + rect.h * 0.42, t = 0, max = FX.LIFE.quest }
  for _ = 1, 140 do
    self:confetti(rect.x + rnd() * rect.w, rect.y - rnd() * 200, rnd(-30, 30), rnd(30, 110), 3 + rnd() * 1.5)
  end
  -- fireworks keep going off for three seconds
  self:firework(cx, rect.y + rect.h * 0.3, 40)
  for i = 1, 9 do
    self.fuses[#self.fuses + 1] = {
      at = 0.25 * i + rnd() * 0.15,
      x = rect.x + rect.w * (0.15 + rnd() * 0.7),
      y = rect.y + rect.h * (0.12 + rnd() * 0.4),
      n = 22 + math.floor(rnd() * 16),
    }
  end
  self.banners[#self.banners + 1] = {
    kind = "quest",
    text = text,
    letters = utf8chars(text),
    t = 0,
    max = FX.LIFE.quest,
    x = cx,
    y = rect.y + rect.h * 0.42,
    icon = "fx_trophy",
    w = rect.w,
  }
end

function FX:clear()
  self.bits, self.rings, self.banners, self.words, self.fuses, self.rays = {}, {}, {}, {}, {}, nil
end

function FX:active()
  return #self.bits > 0
    or #self.rings > 0
    or #self.banners > 0
    or #self.words > 0
    or #self.fuses > 0
    or self.rays ~= nil
end

-- ---------------------------------------------------------------- update

function FX:update(dt)
  self.t = self.t + dt
  for i = #self.bits, 1, -1 do
    local b = self.bits[i]
    b.life = b.life - dt
    if b.life <= 0 then
      table.remove(self.bits, i)
    else
      b.vy = b.vy + b.g * dt
      if b.drag then
        local k = 1 - math.min(1, b.drag * dt)
        b.vx, b.vy = b.vx * k, b.vy * k
        b.x = b.x + math.sin(self.t * b.flutter + b.phase) * 40 * dt
      end
      b.x = b.x + b.vx * dt
      b.y = b.y + b.vy * dt
      b.rot = b.rot + b.vr * dt
    end
  end
  for i = #self.rings, 1, -1 do
    local r = self.rings[i]
    r.t = r.t + dt
    if r.t >= r.max then
      table.remove(self.rings, i)
    end
  end
  for i = #self.words, 1, -1 do
    local w = self.words[i]
    w.t = w.t + dt
    w.y = w.y - 40 * dt
    if w.t >= w.max then
      table.remove(self.words, i)
    end
  end
  for i = #self.banners, 1, -1 do
    local b = self.banners[i]
    b.t = b.t + dt
    if b.t >= b.max then
      table.remove(self.banners, i)
    end
  end
  for i = #self.fuses, 1, -1 do
    local f = self.fuses[i]
    f.at = f.at - dt
    if f.at <= 0 then
      table.remove(self.fuses, i)
      self:firework(f.x, f.y, f.n)
    end
  end
  if self.rays then
    self.rays.t = self.rays.t + dt
    if self.rays.t >= self.rays.max then
      self.rays = nil
    end
  end
end

-- ---------------------------------------------------------------- draw

local function setC(c, a)
  love.graphics.setColor(c[1], c[2], c[3], (c[4] or 1) * (a or 1))
end

local function sprite(assets, name)
  return assets and assets.img and assets.img[name] or nil
end

local function drawStar(assets, b, a)
  local img = sprite(assets, "fx_star")
  setC(b.tint, a)
  if img then
    local s = b.s * (0.5 + 0.5 * a)
    love.graphics.draw(img, b.x, b.y, b.rot, s, s, img:getWidth() * 0.5, img:getHeight() * 0.5)
    return
  end
  local r = 6 * b.s * (0.5 + 0.5 * a)
  love.graphics.push()
  love.graphics.translate(b.x, b.y)
  love.graphics.rotate(b.rot)
  love.graphics.polygon(
    "fill",
    0,
    -r,
    r * 0.3,
    -r * 0.3,
    r,
    0,
    r * 0.3,
    r * 0.3,
    0,
    r,
    -r * 0.3,
    r * 0.3,
    -r,
    0,
    -r * 0.3,
    -r * 0.3
  )
  love.graphics.pop()
end

local function drawConfetti(assets, b, a)
  local img = sprite(assets, "fx_confetti")
  setC(b.tint, a)
  -- a paper piece seen edge-on flips thin: fake it with the x scale
  if img then
    local sx = b.s * math.max(0.15, math.abs(math.cos(b.rot * 1.7)))
    love.graphics.draw(img, b.x, b.y, b.rot, sx, b.s, img:getWidth() * 0.5, img:getHeight() * 0.5)
    return
  end
  love.graphics.push()
  love.graphics.translate(b.x, b.y)
  love.graphics.rotate(b.rot)
  local w = 10 * b.s * math.max(0.15, math.abs(math.cos(b.rot * 1.7)))
  love.graphics.rectangle("fill", -w * 0.5, -3 * b.s, w, 6 * b.s)
  love.graphics.pop()
end

local function drawRing(r)
  local k = ease.expOut(ease.clamp(r.t / r.max, 0, 1))
  if r.t < 0 then
    return
  end
  local rad = 8 + r.r1 * k
  setC(r.col, (1 - k) * 0.9)
  love.graphics.setLineWidth(3 + 5 * (1 - k))
  love.graphics.circle("line", r.x, r.y, rad)
  love.graphics.setLineWidth(1)
end

-- The letters of a banner: each one slams in a beat after the last, then
-- the whole word waves and shimmers gold / cream. Returns the text width.
local function drawLetters(font, letters, x, y, t, life, big)
  love.graphics.setFont(font)
  local widths, total = {}, 0
  for i, ch in ipairs(letters) do
    widths[i] = font:getWidth(ch)
    total = total + widths[i]
  end
  local fade = ease.clamp((life - t) / 0.4, 0, 1)
  local lx = x - total * 0.5
  local h = font:getHeight()
  for i, ch in ipairs(letters) do
    local at = (i - 1) * (big and 0.05 or 0.035)
    local k = ease.expOut(ease.clamp((t - at) * 4, 0, 1))
    if k > 0 then
      local wave = k >= 1 and math.sin(t * 7 - i * 0.55) * 3 or 0
      local sc = 2.2 - 1.2 * k
      local shimmer = 0.5 + 0.5 * math.sin(t * 9 - i * 0.7)
      love.graphics.push()
      love.graphics.translate(lx + widths[i] * 0.5, y + wave - (1 - k) * 40)
      love.graphics.scale(sc)
      love.graphics.rotate((1 - k) * 0.3)
      -- outline
      love.graphics.setColor(0.10, 0.03, 0.05, 0.9 * k * fade)
      for ox = -2, 2, 2 do
        for oy = -2, 2, 2 do
          if ox ~= 0 or oy ~= 0 then
            love.graphics.print(ch, -widths[i] * 0.5 + ox, -h * 0.5 + oy)
          end
        end
      end
      love.graphics.setColor(1, 0.80 + 0.2 * shimmer, 0.25 + 0.55 * shimmer, k * fade)
      love.graphics.print(ch, -widths[i] * 0.5, -h * 0.5)
      love.graphics.pop()
    end
    lx = lx + widths[i]
  end
  return total, h, fade
end

local function drawBanner(assets, b)
  local font = assets and assets.font and assets.font.title or love.graphics.getFont()
  local drop = ease.expOut(ease.clamp(b.t * 3, 0, 1))
  local fade = ease.clamp((b.max - b.t) / 0.4, 0, 1)
  local y = b.y - (1 - drop) * 120
  -- fit the word to the rect
  local total = 0
  for _, ch in ipairs(b.letters) do
    total = total + font:getWidth(ch)
  end
  local maxW = b.w * 0.72
  local sc = math.min(1, maxW / math.max(1, total))
  local h = font:getHeight()
  -- the ribbon behind the letters
  local ribbon = sprite(assets, "fx_ribbon")
  local box = assets and assets.box and assets.box.fx_ribbon
  local rw = total * sc + 150
  local rh = h * sc + 64
  if ribbon and box then
    local bw = box.maxx - box.minx + 1
    local bh = box.maxy - box.miny + 1
    love.graphics.setColor(1, 1, 1, fade)
    love.graphics.draw(ribbon, b.x, y, 0, rw / bw, rh / bh, box.cx, (box.miny + box.maxy) * 0.5)
  else
    setC(Theme.red, 0.92 * fade)
    love.graphics.rectangle("fill", b.x - rw * 0.5, y - rh * 0.5, rw, rh, 6, 6)
    setC(Theme.coin, fade)
    love.graphics.setLineWidth(3)
    love.graphics.rectangle("line", b.x - rw * 0.5, y - rh * 0.5, rw, rh, 6, 6)
    love.graphics.setLineWidth(1)
  end
  love.graphics.push()
  love.graphics.translate(b.x, y)
  love.graphics.scale(sc)
  drawLetters(font, b.letters, 0, 0, b.t, b.max, b.kind == "quest")
  love.graphics.pop()
  -- the medal or the trophy drops in above the ribbon
  if b.icon then
    local img = sprite(assets, b.icon)
    local ik = ease.expOut(ease.clamp((b.t - 0.35) * 2.5, 0, 1))
    if ik > 0 then
      local bob = math.sin(b.t * 3) * 4
      local size = b.kind == "quest" and 150 or 84
      local iy = y - rh * 0.5 - size * 0.55 + (1 - ik) * -80 + bob
      if img then
        love.graphics.setColor(1, 1, 1, ik * fade)
        local s = size / img:getHeight()
        love.graphics.draw(
          img,
          b.x,
          iy,
          math.sin(b.t * 2) * 0.06,
          s * (0.6 + 0.4 * ik),
          s * (0.6 + 0.4 * ik),
          img:getWidth() * 0.5,
          img:getHeight() * 0.5
        )
      else
        setC(Theme.coin, ik * fade)
        love.graphics.circle("fill", b.x, iy, size * 0.4)
      end
    end
  end
end

local function drawRays(r)
  local k = ease.expOut(ease.clamp(r.t * 1.5, 0, 1))
  local fade = ease.clamp((r.max - r.t) / 0.6, 0, 1)
  love.graphics.push()
  love.graphics.translate(r.x, r.y)
  love.graphics.rotate(r.t * 0.35)
  local n = 14
  local len = 900 * k
  for i = 1, n do
    local a0 = (i / n) * math.pi * 2
    local a1 = a0 + math.pi / n * 0.55
    setC(Theme.coin, 0.16 * fade * k)
    love.graphics.polygon("fill", 0, 0, math.cos(a0) * len, math.sin(a0) * len, math.cos(a1) * len, math.sin(a1) * len)
  end
  love.graphics.pop()
end

function FX:draw(assets)
  if not self:active() then
    return
  end
  if self.rays then
    drawRays(self.rays)
  end
  for _, r in ipairs(self.rings) do
    drawRing(r)
  end
  for _, b in ipairs(self.bits) do
    local a = ease.expOut(ease.clamp(b.life / b.max, 0, 1))
    if b.kind == "star" then
      drawStar(assets, b, a)
    else
      drawConfetti(assets, b, a)
    end
  end
  for _, b in ipairs(self.banners) do
    drawBanner(assets, b)
  end
  for _, w in ipairs(self.words) do
    local font = assets and assets.font and assets.font.ui or love.graphics.getFont()
    local k = ease.expOut(ease.clamp(w.t * 6, 0, 1))
    local fade = ease.clamp((w.max - w.t) / 0.25, 0, 1)
    local sc = 1.8 - 0.8 * k
    love.graphics.setFont(font)
    local tw, th = font:getWidth(w.text), font:getHeight()
    love.graphics.push()
    love.graphics.translate(w.x, w.y)
    love.graphics.rotate(-0.08 + 0.16 * k)
    love.graphics.scale(sc)
    love.graphics.setColor(0.10, 0.03, 0.05, 0.9 * fade)
    love.graphics.print(w.text, -tw * 0.5 + 2, -th * 0.5 + 2)
    setC(w.col, fade)
    love.graphics.print(w.text, -tw * 0.5, -th * 0.5)
    love.graphics.pop()
  end
  love.graphics.setColor(1, 1, 1, 1)
end

return FX
