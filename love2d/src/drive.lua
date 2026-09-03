-- Scripted input for smoke tests and screenshots.
--
--   GOSET_DRIVE=path/to/script.lua GOSET_HOME=/tmp/x love .
--
-- The script returns a list of steps, each with an absolute time `at` in
-- seconds and one action:
--
--   { at = 1.0, key = "return" }        love.keypressed (+ textinput for
--                                        single printable characters)
--   { at = 1.2, text = "hiding" }       love.textinput, one char per call
--   { at = 1.5, click = { x, y } }      mouse click in virtual coordinates
--                                        (or a function(game) -> { x, y })
--   { at = 1.6, resize = { w, h } }     window size in points
--   { at = 0.1, orient = "landscape" }  force landscape / portrait first
--   { at = 2.0, shot = "title.png" }    screenshot into the LOVE save dir
--   { at = 2.1, quit = true }
--
-- Screenshots land in love.filesystem.getSaveDirectory().

local Layout = require "src.layout"

local Drive = {}
Drive.__index = Drive

function Drive.load(path)
  local chunk, err = loadfile(path)
  if not chunk then
    error("GOSET_DRIVE: " .. tostring(err))
  end
  local steps = chunk()
  assert(type(steps) == "table", "GOSET_DRIVE script must return a list of steps")
  table.sort(steps, function(a, b)
    return (a.at or 0) < (b.at or 0)
  end)
  local d = setmetatable({ steps = steps, i = 1, t = 0 }, Drive)
  print(string.format("drive: %d steps, shots -> %s", #steps, love.filesystem.getSaveDirectory()))
  return d
end

-- Go through the love.* callbacks so main.lua's routing (F1/F11) applies.
local function pressKey(_, key)
  love.keypressed(key)
  if #key == 1 and key:match("[%w%p ]") then
    love.textinput(key)
  elseif key == "space" then
    love.textinput(" ")
  end
end

function Drive:fire(step, game)
  if step.key then
    pressKey(game, step.key)
  elseif step.text then
    for ch in tostring(step.text):gmatch(".") do
      love.textinput(ch)
    end
  elseif step.click then
    local c = step.click
    if type(c) == "function" then
      c = c(game)
    end
    local vx, vy = c[1], c[2]
    local sx = vx * Layout.scale + Layout.ox
    local sy = vy * Layout.scale + Layout.oy
    love.mousepressed(sx, sy, 1)
  elseif step.orient then
    -- pin the layout a script's coordinates were written for
    if Layout.mode ~= step.orient then
      Layout.toggleOrientation()
      Layout.flush()
    end
  elseif step.resize then
    love.window.setMode(step.resize[1], step.resize[2], { resizable = true, highdpi = true })
    Layout.updateViewport()
  elseif step.shot then
    love.graphics.captureScreenshot(step.shot)
    print("drive: shot " .. step.shot .. "  state=" .. tostring(game.state))
  elseif step.quit then
    love.event.quit(0)
  end
end

function Drive:update(dt, game)
  self.t = self.t + dt
  while self.steps[self.i] and (self.steps[self.i].at or 0) <= self.t do
    local step = self.steps[self.i]
    self.i = self.i + 1
    local ok, err = pcall(self.fire, self, step, game)
    if not ok then
      print("drive: step " .. (self.i - 1) .. " failed: " .. tostring(err))
      love.event.quit(1)
      return
    end
  end
end

return Drive
