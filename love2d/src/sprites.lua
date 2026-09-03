-- Draw Wonder Boy / Mario sprites. Ken reuses the hero sheet (generation blocked).
local assets = require "src.assets"
local chibi = require "src.chibi"

local Sprites = {}

local ALIAS = { ken = "cook", officer = "cook" }

function Sprites.draw(kind, x, y, opts)
  opts = opts or {}
  local key = "sprite_" .. (ALIAS[kind] or kind)
  local img = assets.picture(key)
  if not img then
    chibi.draw(kind, x, y, opts)
    return
  end
  local t = opts.t or 0
  local facing = opts.facing or 1
  local walking = opts.walk
  local bounce = opts.bounce or 0
  local bob = walking and math.abs(math.sin(t * 12)) * 2 or math.sin(t * 3) * 0.8
  local ih = img:getHeight()
  local iw = img:getWidth()
  local box = assets.box[key]
  local ox = box and box.cx or (iw * 0.5)
  local oy = box and box.feet or ih
  local target = opts.h or ih
  if ih < 1 then
    ih = 1
  end
  -- Packed sheets are the same logical size, so one scale fits all.
  local s = target / ih
  bob = bob * math.max(0.6, target / 96)
  bounce = bounce * math.max(0.6, target / 96)
  if kind == "ken" then
    love.graphics.setColor(1, 0.72, 0.86, 1)
  else
    love.graphics.setColor(1, 1, 1, 1)
  end
  love.graphics.draw(img, x, y - bob - bounce, 0, facing * s, s, ox, oy)
  love.graphics.setColor(1, 1, 1, 1)
end

function Sprites.item(name, x, y, s, rot)
  local img = assets.picture(name)
  if not img then
    return
  end
  s = s or 1
  rot = rot or 0
  -- s >= 8 means destination height in pixels (Wonder Boy prop scale).
  if s >= 8 then
    s = s / img:getHeight()
  end
  love.graphics.setColor(1, 1, 1, 1)
  love.graphics.draw(img, x, y, rot, s, s, img:getWidth() * 0.5, img:getHeight() * 0.5)
end

function Sprites.hop(clock, strength)
  local t = math.max(0, math.min(1, clock))
  return math.sin(t * math.pi) * (strength or 12)
end

return Sprites
