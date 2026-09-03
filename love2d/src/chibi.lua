-- Vector chibi sprites. Walk-bob uses a cosine; squash uses exponential settle.
local ease = require "src.ease"
local Chibi = {}

local PAL = {
  hero = {
    skin = { 0.94, 0.78, 0.66 },
    hair = { 0.10, 0.08, 0.12 },
    cloth = { 0.12, 0.18, 0.48 },
    accent = { 0.79, 0.64, 0.36 },
    shoes = { 0.14, 0.10, 0.08 },
    glasses = true,
  },
  mei = {
    skin = { 0.95, 0.80, 0.70 },
    hair = { 0.18, 0.08, 0.14 },
    cloth = { 0.96, 0.82, 0.22 },
    accent = { 0.90, 0.20, 0.45 },
    shoes = { 0.20, 0.12, 0.10 },
  },
  ken = {
    skin = { 0.90, 0.72, 0.58 },
    hair = { 0.08, 0.08, 0.10 },
    cloth = { 0.95, 0.38, 0.58 },
    accent = { 0.20, 0.85, 0.95 },
    shoes = { 0.15, 0.15, 0.18 },
  },
  clerk = {
    skin = { 0.91, 0.72, 0.58 },
    hair = { 0.35, 0.32, 0.30 },
    cloth = { 0.18, 0.46, 0.34 },
    accent = { 0.91, 0.36, 0.05 },
    shoes = { 0.12, 0.12, 0.12 },
    vest = true,
  },
  officer = {
    skin = { 0.93, 0.76, 0.64 },
    hair = { 0.12, 0.10, 0.14 },
    cloth = { 0.12, 0.16, 0.32 },
    accent = { 0.79, 0.64, 0.36 },
    shoes = { 0.08, 0.08, 0.10 },
    bun = true,
  },
  cook = {
    skin = { 0.94, 0.78, 0.64 },
    hair = { 0.18, 0.12, 0.10 },
    cloth = { 0.96, 0.96, 0.94 },
    accent = { 0.79, 0.64, 0.36 },
    shoes = { 0.12, 0.10, 0.10 },
    vest = true,
  },
}

local function set(c, a)
  love.graphics.setColor(c[1], c[2], c[3], a or 1)
end

local function oval(x, y, w, h)
  love.graphics.ellipse("fill", x, y, w, h)
end

function Chibi.draw(kind, x, y, opts)
  opts = opts or {}
  local pal = PAL[kind] or PAL.hero
  local scale = opts.scale
  if not scale then
    scale = opts.h and (opts.h / 42) or 3.2
  end
  local t = opts.t or 0
  local facing = opts.facing or 1
  local walking = opts.walk
  local bounce = opts.bounce or 0 -- extra hop in pixels
  local squash = opts.squash or 1
  local flash = opts.flash

  local bob
  if walking then
    bob = math.abs(math.sin(t * 11)) * 3.2
  else
    bob = math.sin(t * 2.4) * 1.4
  end
  local leg = walking and math.sin(t * 11) or 0

  love.graphics.push()
  love.graphics.translate(x, y - bob - bounce)
  love.graphics.scale(facing * scale, scale * squash)

  -- shadow
  love.graphics.setColor(0, 0, 0, 0.28)
  oval(0, 2, 9, 2.4)

  -- legs
  set(pal.shoes)
  love.graphics.rectangle("fill", -6, -4, 4, 8 + leg * 3, 1, 1)
  love.graphics.rectangle("fill", 2, -4, 4, 8 - leg * 3, 1, 1)

  -- body
  set(pal.cloth)
  love.graphics.rectangle("fill", -8, -22, 16, 18, 3, 3)
  if pal.vest then
    set(pal.accent)
    love.graphics.rectangle("fill", -8, -22, 16, 8, 3, 3)
    love.graphics.rectangle("fill", -8, -16, 3, 12)
    love.graphics.rectangle("fill", 5, -16, 3, 12)
  end
  -- pocket / stripe
  set(pal.accent)
  love.graphics.rectangle("fill", -3, -12, 6, 5, 1, 1)

  -- head
  set(pal.skin)
  oval(0, -30, 8.5, 8.5)

  -- hair
  set(pal.hair)
  if pal.bun then
    oval(0, -37, 8, 5)
    oval(0, -42, 3.5, 3.5)
  else
    oval(0, -36, 9, 6)
    love.graphics.rectangle("fill", -9, -36, 4, 10, 1, 1)
    love.graphics.rectangle("fill", 5, -36, 4, 8, 1, 1)
  end
  if kind == "mei" then
    set(pal.accent)
    love.graphics.rectangle("fill", 5, -34, 3, 12, 1, 1)
  end

  -- ears
  set(pal.skin)
  oval(-8.2, -30, 1.8, 2.2)
  oval(8.2, -30, 1.8, 2.2)

  -- eyes
  love.graphics.setColor(0.08, 0.07, 0.1, 1)
  oval(-3.2, -30, 1.4, 1.8)
  oval(3.2, -30, 1.4, 1.8)
  love.graphics.setColor(1, 1, 1, 0.85)
  oval(-2.7, -30.6, 0.5, 0.5)
  oval(3.7, -30.6, 0.5, 0.5)

  if pal.glasses then
    love.graphics.setColor(0.79, 0.64, 0.36, 1)
    love.graphics.setLineWidth(0.7)
    love.graphics.circle("line", -3.2, -30, 3.1)
    love.graphics.circle("line", 3.2, -30, 3.1)
    love.graphics.line(-0.2, -30, 0.2, -30)
    love.graphics.setLineWidth(1)
  end

  -- smile
  love.graphics.setColor(0.45, 0.22, 0.22, 1)
  love.graphics.setLineWidth(0.6)
  love.graphics.arc("line", "open", 0, -27.2, 2.2, 0.2, math.pi - 0.2)
  love.graphics.setLineWidth(1)

  if flash then
    love.graphics.setColor(1, 1, 1, flash)
    oval(0, -20, 12, 20)
  end

  love.graphics.pop()
  love.graphics.setColor(1, 1, 1, 1)
end

function Chibi.hop(clock, strength)
  -- cosine hop 0..1 of a short jump
  local t = ease.clamp(clock, 0, 1)
  return math.sin(t * math.pi) * (strength or 18)
end

return Chibi
