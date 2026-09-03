-- Clear two BASIC streets, then look at the map's CLEAR marks and quest tabs.
local maps = require "src.data"
local S = {}
local t = 0
local function at(dt, step)
  t = t + dt
  step.at = t
  S[#S + 1] = step
end
at(0.1, { orient = "landscape" })
at(1.2, { key = "1" })
for i = 1, 2 do
  for _, st in ipairs(maps[i].stages) do
    at(0.15, { text = st.answer })
    at(0.15, { key = "return" })
  end
  at(0.5, { key = "return" }) -- next street
end
at(0.3, { key = "escape" }) -- map
at(0.9, { shot = "m01_map_two_clear.png" })
at(0.2, { key = "q" })
at(0.6, { shot = "m02_map_advanced.png" })
at(0.2, { key = "f1" })
at(1.0, { shot = "m03_map_portrait.png" })
at(0.2, { key = "f1" })
at(0.3, { quit = true })
return S
