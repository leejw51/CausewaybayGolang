local Layout = require "src.layout"
local CRT = require "src.crt"
local Persist = require "src.persist"
local Game = require "src.game"

local game
local drive
local testing = false

local function wantsTests(args)
  if os.getenv("GOSET_TEST") == "1" then
    return true
  end
  for _, a in ipairs(args or {}) do
    if a == "--test" then
      return true
    end
  end
  return false
end

function love.load(args)
  if wantsTests(args) then
    testing = true
    local passed = require("tests.init").run()
    love.event.quit(passed and 0 or 1)
    return
  end

  love.graphics.setDefaultFilter("nearest", "nearest")
  love.graphics.setLineStyle("rough")
  love.graphics.setLineWidth(1)
  love.keyboard.setKeyRepeat(true)
  Layout.init()
  game = Game.new()
  game:load()

  local script = os.getenv("GOSET_DRIVE")
  if script and script ~= "" then
    drive = require("src.drive").load(script)
  end
end

function love.update(dt)
  if testing then
    return
  end
  dt = math.min(dt, 0.05)
  Layout.flush()
  CRT.update(dt)
  game:update(dt)
  if drive then
    drive:update(dt, game)
  end
end

function love.draw()
  if testing then
    return
  end
  Layout.begin()
  game:draw()
  CRT.draw()
  Layout.finish()
end

function love.keypressed(key)
  if testing or not game then
    return
  end
  if key == "f11" then
    Layout.toggleFullscreen()
    return
  end
  if key == "f1" then
    Layout.toggleOrientation()
    return
  end
  if key == "f3" then
    Layout.cycleLanguage()
    return
  end
  if key == "f4" then
    Layout.toggleSound()
    return
  end
  game:keypressed(key)
end

function love.textinput(text)
  if testing or not game then
    return
  end
  game:textinput(text)
end

function love.mousepressed(x, y, button)
  if testing or not game then
    return
  end
  game:mousepressed(x, y, button)
end

function love.resize()
  Layout.updateViewport()
end

function love.quit()
  if game and game.state == "play" then
    Persist.saveProgress(game)
  end
end
