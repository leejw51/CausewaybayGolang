local Layout = require "src.layout"
local Theme = require "src.theme"

local CRT = { t = 0 }

function CRT.update(dt)
  CRT.t = CRT.t + dt
end

function CRT.draw()
  local w, h = Layout.vw, Layout.vh
  love.graphics.setColor(0, 0, 0, 0.10)
  for y = 0, h - 1, 2 do
    love.graphics.rectangle("fill", 0, y, w, 1)
  end
  local ry = math.floor((CRT.t * 36) % (h + 10)) - 4
  love.graphics.setColor(Theme.withAlpha(Theme.coin, 0.04))
  love.graphics.rectangle("fill", 0, ry, w, 6)
end

return CRT
