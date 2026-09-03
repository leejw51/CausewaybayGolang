local Theme = require "src.theme"
local Persist = require "src.persist"
local I18n = require "src.i18n"
local SFX = require "src.sfx"

local Layout = {
  mode = "landscape",
  fullscreen = false,
  pendingWindow = false,
  vw = Theme.landW,
  vh = Theme.landH,
  scale = 1,
  ox = 0,
  oy = 0,
  canvas = nil,
}

local FULLSCREEN_TYPES = { desktop = true, exclusive = true }
Layout.fullscreenPref = nil

-- Extra virtual pixels allowed past the design size so fullscreen does not
-- sit in a tiny letterbox.
local MAX_STRETCH = 1.5

function Layout.fullscreenType()
  local want = Layout.fullscreenPref or os.getenv("GOSET_FULLSCREEN") or ""
  want = tostring(want):lower()
  if FULLSCREEN_TYPES[want] then
    return want
  end
  return "desktop"
end

local function highdpi()
  return true
end

local function windowedFlags()
  return {
    fullscreen = false,
    fullscreentype = "desktop",
    resizable = true,
    vsync = 1,
    msaa = 0,
    minwidth = 960,
    minheight = 540,
    centered = true,
    highdpi = highdpi(),
  }
end

local function fitWindow(wantW, wantH)
  local dw, dh = love.window.getDesktopDimensions()
  local maxW = math.max(640, dw - 80)
  local maxH = math.max(480, dh - 100)
  local w, h = wantW, wantH
  local s = math.min(1, maxW / w, maxH / h)
  w = math.max(640, math.floor(w * s))
  h = math.max(480, math.floor(h * s))
  return w, h
end

function Layout.applyWindow()
  if love.graphics.getCanvas() then
    love.graphics.setCanvas()
  end
  local ftype = Layout.fullscreenType()
  if Layout.fullscreen then
    local dw, dh = love.window.getDesktopDimensions()
    local _, _, cur = love.window.getMode()
    if not (cur.fullscreen and cur.fullscreentype == ftype) then
      love.window.setMode(dw, dh, {
        fullscreen = true,
        fullscreentype = ftype,
        vsync = 1,
        msaa = 0,
        highdpi = highdpi(),
        resizable = false,
      })
    end
  else
    local w, h
    if Layout.mode == "portrait" then
      w, h = fitWindow(Theme.portW, Theme.portH)
    else
      w, h = fitWindow(Theme.landW, Theme.landH)
    end
    local cw, ch, cur = love.window.getMode()
    if cur.fullscreen or math.abs(cw - w) > 8 or math.abs(ch - h) > 8 then
      love.window.setMode(w, h, windowedFlags())
    end
  end
  Layout.updateViewport()
end

function Layout.flush()
  if not Layout.pendingWindow then
    return
  end
  Layout.pendingWindow = false
  Layout.applyWindow()
end

function Layout.save()
  return Persist.saveDisplay(Layout)
end

function Layout.load()
  local rec = Persist.loadDisplay()
  if not rec then
    return false
  end
  local applied = false
  if rec.mode == "portrait" or rec.mode == "landscape" then
    Layout.mode = rec.mode
    applied = true
  end
  if type(rec.fullscreen) == "boolean" then
    Layout.fullscreen = rec.fullscreen
    applied = true
  end
  if type(rec.lang) == "string" then
    I18n.set(rec.lang)
  end
  if type(rec.sound) == "boolean" then
    SFX.set(rec.sound)
  end
  return applied
end

function Layout.toggleFullscreen()
  SFX.play("toggle")
  Layout.fullscreen = not Layout.fullscreen
  Layout.pendingWindow = true
  Layout.save()
end

function Layout.cycleLanguage()
  I18n.cycle()
  SFX.play("lang")
  Layout.save()
end

function Layout.toggleSound()
  SFX.toggle()
  Layout.save()
end

function Layout.toggleOrientation()
  SFX.play("toggle")
  Layout.mode = Layout.mode == "landscape" and "portrait" or "landscape"
  Layout.pendingWindow = true
  Layout.save()
end

local function baseSize()
  if Layout.mode == "portrait" then
    return Theme.portW, Theme.portH
  end
  return Theme.landW, Theme.landH
end

function Layout.ensureCanvas()
  local w, h = math.max(1, math.floor(Layout.vw)), math.max(1, math.floor(Layout.vh))
  if Layout.canvas and Layout.canvas:getWidth() == w and Layout.canvas:getHeight() == h then
    return
  end
  if Layout.canvas then
    Layout.canvas:release()
  end
  Layout.canvas = love.graphics.newCanvas(w, h)
  Layout.canvas:setFilter("nearest", "nearest")
end

function Layout.updateViewport()
  local ww, wh = love.graphics.getDimensions()
  if ww < 1 then
    ww = Theme.landW
  end
  if wh < 1 then
    wh = Theme.landH
  end
  local bw, bh = baseSize()
  local s = math.min(ww / bw, wh / bh)
  if s >= 2 then
    Layout.scale = math.floor(s)
    Layout.vw = math.min(math.floor(ww / Layout.scale), math.floor(bw * MAX_STRETCH))
    Layout.vh = math.min(math.floor(wh / Layout.scale), math.floor(bh * MAX_STRETCH))
  else
    -- Fill the window: grow the virtual canvas along the longer axis
    -- instead of letterboxing (a landscape layout on a portrait screen,
    -- a tall window). Fonts stay at design size below 1x.
    Layout.scale = s >= 1 and 1 or math.max(0.35, s)
    Layout.vw = math.min(math.floor(ww / Layout.scale), math.floor(bw * MAX_STRETCH))
    Layout.vh = math.min(math.floor(wh / Layout.scale), math.floor(bh * MAX_STRETCH))
  end
  Layout.ox = math.floor((ww - Layout.vw * Layout.scale) / 2)
  Layout.oy = math.floor((wh - Layout.vh * Layout.scale) / 2)
  Layout.ensureCanvas()
end

-- Fonts are authored for the 1280x720 / 720x1280 design. When the virtual
-- canvas grows (windowed stretch, tall fullscreen), scale type with it.
function Layout.uiScale()
  local bw, bh = baseSize()
  local sx = Layout.vw / bw
  local sy = Layout.vh / bh
  return math.max(1, math.min(sx, sy))
end

function Layout.init()
  -- First run on a portrait display: start in portrait. A saved display
  -- record (Layout.load) overrides this afterwards.
  local dw, dh = love.window.getDesktopDimensions()
  if dh > dw then
    Layout.mode = "portrait"
  end
  Persist.ensureSetup({ mode = Layout.mode, fullscreen = Layout.fullscreen })
  Layout.load()
  Layout.updateViewport()
  Layout.applyWindow()
  Persist.boot()
end

function Layout.begin()
  Layout.updateViewport()
  love.graphics.setCanvas(Layout.canvas)
  love.graphics.clear(Theme.sky)
end

function Layout.finish()
  love.graphics.setCanvas()
  love.graphics.setColor(1, 1, 1, 1)
  love.graphics.clear(Theme.void)
  local dw = Layout.vw * Layout.scale
  local dh = Layout.vh * Layout.scale
  love.graphics.draw(Layout.canvas, Layout.ox, Layout.oy, 0, Layout.scale, Layout.scale)
  love.graphics.setColor(Theme.coin[1], Theme.coin[2], Theme.coin[3], 0.55)
  love.graphics.setLineWidth(1)
  love.graphics.rectangle("line", Layout.ox - 1, Layout.oy - 1, dw + 2, dh + 2)
end

function Layout.toVirtual(sx, sy)
  local vx = (sx - Layout.ox) / Layout.scale
  local vy = (sy - Layout.oy) / Layout.scale
  if vx < 0 or vy < 0 or vx >= Layout.vw or vy >= Layout.vh then
    return nil, nil
  end
  return vx, vy
end

function Layout.hit(x, y, w, h)
  local vx, vy = Layout.toVirtual(love.mouse.getPosition())
  if not vx then
    return false
  end
  return vx >= x and vy >= y and vx < x + w and vy < y + h
end

function Layout.isPortrait()
  return Layout.mode == "portrait"
end

return Layout
