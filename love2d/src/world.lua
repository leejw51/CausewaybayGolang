-- Street-level camera for Wonder Boy-scale scenes.
-- Paintings show whole buildings + sky; we zoom to the sidewalk and
-- pin a source ground line to the playfield so people match shop doors.

local assets = require "src.assets"
local Theme = require "src.theme"

local World = {}

local VIEW = {
  title_bg = 0.46,
  title_bg_p = 0.36,
  bg_flat = 0.50,
  bg_street = 0.48,
  bg_mtr = 0.50,
  bg_times = 0.50,
  bg_mall = 0.50,
  bg_queue = 0.52,
  bg_till = 0.50,
  bg_kitchen = 0.50,
  bg_set = 0.50,
  bg_night = 0.50,
  bg_lab = 0.52,
  bg_market = 0.50,
}

local GROUND = {
  title_bg = 0.84,
  title_bg_p = 0.88,
  bg_flat = 0.86,
  bg_street = 0.86,
  bg_mtr = 0.86,
  bg_times = 0.86,
  bg_mall = 0.86,
  bg_queue = 0.88,
  bg_till = 0.88,
  bg_kitchen = 0.86,
  bg_set = 0.88,
  bg_night = 0.86,
  bg_lab = 0.90,
  bg_market = 0.88,
}

local function clip(dx, dy, dw, dh)
  local x1, y1 = love.graphics.transformPoint(dx, dy)
  local x2, y2 = love.graphics.transformPoint(dx + dw, dy + dh)
  local x = math.min(x1, x2)
  local y = math.min(y1, y2)
  local w = math.abs(x2 - x1)
  local h = math.abs(y2 - y1)
  local sx, sy, sw, sh = love.graphics.getScissor()
  if love.graphics.intersectScissor then
    love.graphics.intersectScissor(x, y, math.max(1, w), math.max(1, h))
  else
    love.graphics.setScissor(x, y, math.max(1, w), math.max(1, h))
  end
  return sx, sy, sw, sh
end

local function unclip(sx, sy, sw, sh)
  if sx then
    love.graphics.setScissor(sx, sy, sw, sh)
  else
    love.graphics.setScissor()
  end
end

function World.draw(name, dx, dy, dw, dh, portrait, kind)
  kind = kind or "play"
  local key = name
  if portrait and assets.img[name .. "_p"] then
    key = name .. "_p"
  end
  local img = assets.picture(name, portrait)
  local charFrac = 0.42
  if kind == "title" then
    charFrac = portrait and 0.28 or 0.34
  elseif kind == "win" then
    charFrac = portrait and 0.26 or 0.32
  end
  local destGround = dy + dh * (kind == "title" and 0.90 or 0.88)

  if not img then
    love.graphics.setColor(Theme.sky)
    love.graphics.rectangle("fill", dx, dy, dw, dh)
    return {
      groundY = destGround,
      charH = math.floor(dh * charFrac),
      scale = 1,
    }
  end

  img:setFilter("nearest", "nearest")
  local iw, ih = img:getWidth(), img:getHeight()
  local view = VIEW[key] or VIEW[name] or (portrait and 0.38 or 0.50)
  local gsrc = GROUND[key] or GROUND[name] or 0.86
  local s = dh / (ih * view)
  if iw * s < dw then
    s = dw / iw
  end
  local x = dx + (dw - iw * s) * 0.5
  local y = destGround - ih * gsrc * s

  local sx, sy, sw, sh = clip(dx, dy, dw, dh)
  love.graphics.setColor(1, 1, 1, 1)
  love.graphics.draw(img, x, y, 0, s, s)
  unclip(sx, sy, sw, sh)

  return {
    groundY = destGround,
    charH = math.floor(dh * charFrac),
    scale = s,
  }
end

return World
