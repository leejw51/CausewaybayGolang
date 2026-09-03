-- Fullscreen, both orientations, all three languages.
-- Cycle: EN -> KO -> YUE -> EN with F3.
local S = {}
local t = 0
local function at(dt, step)
  t = t + dt
  step.at = t
  S[#S + 1] = step
end
local function threeLangs(prefix, dt)
  for _, l in ipairs({ "en", "ko", "yue" }) do
    at(dt or 0.7, { shot = prefix .. "_" .. l .. ".png" })
    at(0.1, { key = "f3" })
  end
end
at(0.1, { orient = "landscape" })
at(0.2, { key = "f11" })
threeLangs("f01_land_title", 1.5)
at(0.2, { key = "return" }) -- map
threeLangs("f02_land_map")
at(0.2, { key = "3" }) -- office
at(0.3, { key = "tab" })
at(0.1, { key = "tab" }) -- answer panel
threeLangs("f03_land_play_answer")
at(0.2, { key = "f1" }) -- portrait fullscreen
threeLangs("f04_port_play_answer", 1.2)
at(0.2, { key = "f2" }) -- map
threeLangs("f05_port_map")
at(0.2, { key = "f11" }) -- back to window
at(0.2, { key = "f1" }) -- back to landscape
at(0.6, { quit = true })
return S
