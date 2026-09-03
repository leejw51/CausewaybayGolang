-- Wonder Boy / SNES chrome: thick gold rim, wood, cream or navy fill.
local Theme = require "src.theme"

local UI = {}

local function c(col, a)
  love.graphics.setColor(col[1], col[2], col[3], a or col[4] or 1)
end

function UI.panel(x, y, w, h, fill)
  fill = fill or Theme.panel
  c(Theme.ink)
  love.graphics.rectangle("fill", x, y, w, h)
  c(Theme.coin)
  love.graphics.rectangle("fill", x + 2, y + 2, w - 4, h - 4)
  c(Theme.wood)
  love.graphics.rectangle("fill", x + 4, y + 4, w - 8, h - 8)
  c(Theme.ink)
  love.graphics.rectangle("fill", x + 6, y + 6, w - 12, 2)
  c(fill)
  love.graphics.rectangle("fill", x + 6, y + 8, w - 12, h - 14)
end

function UI.well(x, y, w, h, fill)
  fill = fill or { 0.10, 0.08, 0.20, 0.98 }
  c(Theme.ink)
  love.graphics.rectangle("fill", x, y, w, h)
  c(Theme.wood)
  love.graphics.rectangle("fill", x + 2, y + 2, w - 4, h - 4)
  c(fill)
  love.graphics.rectangle("fill", x + 4, y + 4, w - 8, h - 8)
end

function UI.bar(x, y, w, h)
  c(Theme.navy)
  love.graphics.rectangle("fill", x, y, w, h)
  c(Theme.coin)
  love.graphics.rectangle("fill", x, y + h - 3, w, 3)
  c(Theme.ink)
  love.graphics.rectangle("fill", x, y + h - 1, w, 1)
end

return UI
