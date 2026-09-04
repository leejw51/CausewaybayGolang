-- Monty, the Python track's mascot: a friendly python drawn from primitives,
-- the way Ferris is for Rust. (x, y) is the middle of the coil on the
-- ground, h the height to the top of the head; t animates the sway, the
-- tongue and the slither.

local assets = require "src.assets"

local Monty = {}

local BLUE = { 0.19, 0.41, 0.60, 1 }
local BLUE_DK = { 0.12, 0.27, 0.42, 1 }
local YELLOW = { 1.0, 0.83, 0.23, 1 }
local BELLY = { 0.98, 0.93, 0.70, 1 }
local INK = { 40 / 255, 24 / 255, 16 / 255, 1 }
local TONGUE = { 0.92, 0.25, 0.35, 1 }

local function c(col, a)
  love.graphics.setColor(col[1], col[2], col[3], a or col[4] or 1)
end

-- body segments, coil first, neck last; authored for a 40 px snake
local SEGMENTS = {
  { 10, -6, 9.5 },
  { -4, -7, 9 },
  { -13, -12, 8 },
  { -8, -19, 7.5 },
  { 3, -22, 7 },
  { 11, -27, 6.5 },
  { 9, -34, 6 },
}

function Monty.draw(x, y, h, t, opts)
  opts = opts or {}
  t = t or 0
  h = h or 40
  -- the Grok sheet when it is there (assets/sprite_monty.png, on a magenta
  -- screen that assets.lua knocks out); the primitives below otherwise
  if not opts.vector and assets.mascot("sprite_monty", x, y, h, t, opts) then
    return
  end
  local s = h / 40
  local facing = opts.facing or 1
  local alpha = opts.alpha or 1
  local sway = opts.still and 0 or math.sin(t * 2.2) * 0.06
  local slither = opts.walk and math.sin(t * 9) * 1.6 or 0

  love.graphics.push()
  love.graphics.translate(x, y)
  love.graphics.scale(facing * s, s)

  -- tail tip peeking out of the coil
  c(INK, alpha)
  love.graphics.setLineWidth(5)
  love.graphics.line(18, -4, 26, -2 + slither)
  c(BLUE, alpha)
  love.graphics.setLineWidth(3)
  love.graphics.line(18, -4, 26, -2 + slither)
  love.graphics.setLineWidth(1)

  -- the coil and the neck, back to front, each ring with a yellow band
  for i, seg in ipairs(SEGMENTS) do
    local sx = seg[1] + (i > 3 and math.sin(t * 2.2 + i) * 1.2 or 0) + (i > 4 and slither * 0.4 or 0)
    local sy = seg[2]
    local r = seg[3]
    c(INK, alpha)
    love.graphics.circle("fill", sx, sy, r + 1.5)
    c(i % 2 == 0 and YELLOW or BLUE, alpha)
    love.graphics.circle("fill", sx, sy, r)
    c(i % 2 == 0 and BLUE_DK or BLUE_DK, 0.35 * alpha)
    love.graphics.arc("fill", sx, sy, r, 0.4, 2.2)
    if i % 2 == 1 then
      c(BELLY, 0.8 * alpha)
      love.graphics.ellipse("fill", sx, sy + r * 0.35, r * 0.55, r * 0.3)
    end
  end

  -- head, tilted with the sway
  local hx, hy = 14 + slither * 0.5, -40
  love.graphics.push()
  love.graphics.translate(hx, hy)
  love.graphics.rotate(sway)
  c(INK, alpha)
  love.graphics.ellipse("fill", 0, 0, 11.5, 8.5)
  c(BLUE, alpha)
  love.graphics.ellipse("fill", 0, 0, 10, 7)
  c(YELLOW, alpha)
  love.graphics.ellipse("fill", 2, 2.5, 7, 3)
  -- eyes
  for side = -1, 1, 2 do
    local ex = 3 + side * 3
    love.graphics.setColor(1, 1, 1, alpha)
    love.graphics.circle("fill", ex, -2.5, 3)
    c(INK, alpha)
    love.graphics.circle("fill", ex + (opts.look or 0) * 1.2 + 0.6, -2.5, 1.5)
  end
  -- a smile
  c(INK, 0.85 * alpha)
  love.graphics.setLineWidth(1.5)
  love.graphics.arc("line", "open", 5, 1.5, 3.5, 0.2, math.pi - 0.6)
  -- the tongue, flicking
  local flick = (t * 1.7) % 1
  if flick < 0.18 or opts.tongue then
    c(TONGUE, alpha)
    love.graphics.setLineWidth(1.5)
    love.graphics.line(10, 2, 15, 3)
    love.graphics.line(15, 3, 17, 1)
    love.graphics.line(15, 3, 17, 5)
  end
  love.graphics.setLineWidth(1)
  love.graphics.pop()

  love.graphics.pop()
  love.graphics.setColor(1, 1, 1, 1)
end

return Monty
