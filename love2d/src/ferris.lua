-- Ferris, the Rust crab, drawn from primitives so the Rust track has a
-- mascot without a new sprite sheet. (x, y) is the middle of the feet,
-- h the body height in pixels; t animates the claws and the bob.

local assets = require "src.assets"

local Ferris = {}

local SHELL = { 0.93, 0.36, 0.12, 1 }
local SHELL_DK = { 0.72, 0.24, 0.06, 1 }
local BELLY = { 0.98, 0.56, 0.28, 1 }
local INK = { 40 / 255, 24 / 255, 16 / 255, 1 }

local function c(col, a)
  love.graphics.setColor(col[1], col[2], col[3], a or col[4] or 1)
end

function Ferris.draw(x, y, h, t, opts)
  opts = opts or {}
  t = t or 0
  h = h or 40
  -- the Grok sheet when it is there (assets/sprite_ferris.png); the
  -- primitives below otherwise
  if not opts.vector and assets.mascot("sprite_ferris", x, y, h, t, opts) then
    return
  end
  local s = h / 40 -- everything below is authored for a 40 px crab
  local bob = (opts.still and 0 or math.sin(t * 3) * 1.5) * s
  local wave = math.sin(t * 5) * 0.35
  local facing = opts.facing or 1
  local alpha = opts.alpha or 1

  love.graphics.push()
  love.graphics.translate(x, y - bob)
  love.graphics.scale(facing * s, s)

  -- legs: three each side, stepping when walking
  c(SHELL_DK, alpha)
  for i = 1, 3 do
    local lx = 8 + (i - 1) * 7
    local step = opts.walk and math.sin(t * 12 + i) * 3 or 0
    love.graphics.setLineWidth(3)
    love.graphics.line(-lx - 6, -12, -lx - 12, -2 + step)
    love.graphics.line(lx + 6, -12, lx + 12, -2 - step)
  end
  love.graphics.setLineWidth(1)

  -- claws: two big circles on arms, waving
  for side = -1, 1, 2 do
    local ax = side * 30
    local ay = -22 + side * wave * 6
    c(SHELL_DK, alpha)
    love.graphics.setLineWidth(4)
    love.graphics.line(side * 18, -16, ax, ay)
    love.graphics.setLineWidth(1)
    c(SHELL, alpha)
    love.graphics.circle("fill", ax, ay, 8)
    -- the pincer gap
    c(INK, 0.35 * alpha)
    love.graphics.arc("fill", ax, ay, 8, -0.5 + side * 0.4 + wave, 0.5 + side * 0.4 + wave)
  end

  -- body: a fat rounded shell
  c(INK, alpha)
  love.graphics.ellipse("fill", 0, -16, 26, 17)
  c(SHELL, alpha)
  love.graphics.ellipse("fill", 0, -16, 24, 15)
  c(BELLY, 0.9 * alpha)
  love.graphics.ellipse("fill", 0, -11, 16, 7)
  -- spikes on the shell
  c(SHELL_DK, alpha)
  for i = -2, 2 do
    love.graphics.polygon("fill", i * 9 - 3, -28, i * 9, -34, i * 9 + 3, -28)
  end

  -- eyes on stalks
  for side = -1, 1, 2 do
    local ex = side * 9
    c(INK, alpha)
    love.graphics.rectangle("fill", ex - 1.5, -34, 3, 8)
    love.graphics.setColor(1, 1, 1, alpha)
    love.graphics.circle("fill", ex, -36, 5)
    c(INK, alpha)
    local look = (opts.look or 0) * 2
    love.graphics.circle("fill", ex + look, -36, 2.5)
  end

  -- a smile
  c(INK, 0.8 * alpha)
  love.graphics.setLineWidth(2)
  love.graphics.arc("line", "open", 0, -20, 6, 0.3, math.pi - 0.3)
  love.graphics.setLineWidth(1)

  love.graphics.pop()
  love.graphics.setColor(1, 1, 1, 1)
end

return Ferris
