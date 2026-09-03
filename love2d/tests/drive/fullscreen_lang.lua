-- Fullscreen, both orientations, every language.
-- Cycle: EN -> KO -> YUE -> ZH -> JA -> ES -> CS -> EN with F3.
local S = {}
local t = 0
local function at(dt, step)
  t = t + dt
  step.at = t
  S[#S + 1] = step
end
local function allLangs(prefix, dt)
  for _, l in ipairs({ "en", "ko", "yue", "zh", "ja", "es", "cs" }) do
    at(dt or 0.7, { shot = prefix .. "_" .. l .. ".png" })
    at(0.1, { key = "f3" })
  end
end
at(0.1, { orient = "landscape" })
at(0.2, { key = "f11" })
allLangs("f01_land_title", 1.5)
at(0.2, { key = "return" }) -- map
allLangs("f02_land_map")
at(0.2, { key = "3" }) -- office
at(0.3, { key = "tab" })
at(0.1, { key = "tab" }) -- answer panel
allLangs("f03_land_play_answer")
at(0.2, { key = "f1" }) -- portrait fullscreen
allLangs("f04_port_play_answer", 1.2)
at(0.2, { key = "f2" }) -- map
allLangs("f05_port_map")
at(0.2, { key = "f11" }) -- back to window
at(0.2, { key = "f1" }) -- back to landscape
at(0.6, { quit = true })
return S
