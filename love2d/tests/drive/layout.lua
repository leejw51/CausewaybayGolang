-- UI layout at other window sizes: minimum window, a large window,
-- fullscreen in both orientations.
local S = {}
local t = 0
local function at(dt, step)
  t = t + dt
  step.at = t
  S[#S + 1] = step
end
at(0.1, { orient = "landscape" })
at(0.5, { key = "3" }) -- office
at(0.3, { key = "tab" })
at(0.3, { key = "tab" }) -- answer panel open
at(0.2, { resize = { 960, 540 } })
at(1.0, { shot = "l01_min_window_play.png" })
at(0.2, { key = "f2" })
at(0.8, { shot = "l02_min_window_map.png" })
at(0.2, { key = "escape" })
at(0.2, { resize = { 1600, 900 } })
at(1.0, { shot = "l03_big_window_play.png" })
at(0.2, { key = "f11" })
at(1.5, { shot = "l04_fullscreen_play.png" })
at(0.2, { key = "f2" })
at(0.8, { shot = "l05_fullscreen_map.png" })
at(0.2, { key = "escape" })
at(0.2, { key = "f1" })
at(1.5, { shot = "l06_fullscreen_portrait_play.png" })
at(0.2, { text = "r" })
at(0.2, { key = "return" }) -- feedback line in the story panel
at(0.8, { shot = "l07_fullscreen_portrait_stage2.png" })
at(0.2, { key = "f11" })
at(0.2, { key = "f1" }) -- back to windowed landscape
at(0.8, { quit = true })
return S
