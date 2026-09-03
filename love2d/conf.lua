function love.conf(t)
  local testing = os.getenv("GOSET_TEST") == "1"
  t.identity = "goset-causewaybay"
  t.version = "11.4"
  t.console = false
  t.window.title = "GO SET — Causeway Bay"
  t.window.width = testing and 320 or 1280
  t.window.height = testing and 180 or 720
  t.window.minwidth = testing and 160 or 960
  t.window.minheight = testing and 90 or 540
  t.window.resizable = true
  t.window.fullscreen = false
  t.window.fullscreentype = os.getenv("GOSET_FULLSCREEN") == "exclusive" and "exclusive" or "desktop"
  t.window.vsync = 1
  t.window.msaa = 0
  t.window.highdpi = true
  t.modules.joystick = false
  t.modules.physics = false
  t.modules.video = false
end
