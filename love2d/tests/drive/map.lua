-- The overworld: landscape, walking, portrait.
local S = {}
local t = 0
local function at(dt, step)
  t = t + dt
  step.at = t
  S[#S + 1] = step
end
at(0.1, { orient = "landscape" })
at(0.4, { key = "return" }) -- title -> map
at(1.0, { shot = "w01_map.png" })
at(0.1, { key = "right" })
at(0.1, { key = "right" })
at(0.25, { shot = "w02_walking.png" })
at(1.2, { shot = "w03_at_3.png" })
at(0.1, { key = "return" }) -- play street 3
at(0.6, { text = "for" })
at(0.1, { key = "return" })
at(0.1, { text = "range" })
at(0.1, { key = "return" })
at(0.1, { text = "switch" })
at(0.1, { key = "return" }) -- street 3 clear
at(0.3, { key = "escape" }) -- map with HERE + CLEAR
at(1.0, { shot = "w04_map_cleared.png" })
at(0.1, { key = "7" })
at(0.6, { key = "escape" })
at(1.0, { shot = "w05_map_here7.png" })
at(0.1, { key = "f1" })
at(1.2, { shot = "w06_portrait_map.png" })
at(0.1, { key = "left" })
at(0.1, { key = "left" })
at(0.3, { shot = "w07_portrait_walk.png" })
at(0.1, { key = "f1" })
at(0.6, { quit = true })
return S
