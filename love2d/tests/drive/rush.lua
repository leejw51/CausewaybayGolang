-- CODE RUSH round 1 played clean: COMBO pop-ups, PERFECT, then the map.
local maps = require "src.data_quiz"
local S = {}
local t = 0
local function at(dt, step)
  t = t + dt
  step.at = t
  S[#S + 1] = step
end
at(0.1, { orient = "landscape" })
at(1.2, { key = "q" })
at(0.2, { key = "q" })
at(0.2, { key = "q" }) -- Q4 on the title
at(0.2, { key = "return" })
at(0.9, { shot = "r01_map_rush.png" })
at(0.2, { key = "1" })
at(0.9, { shot = "r02_round1.png" })
for si, st in ipairs(maps[1].stages) do
  at(0.2, { text = st.answer })
  at(0.2, { key = "return" })
  if si == 2 then
    at(0.12, { shot = "r03_combo2.png" })
  elseif si == 3 then
    at(0.12, { shot = "r04_combo3.png" })
  end
end
at(0.25, { shot = "r05_perfect.png" })
at(0.5, { key = "return" }) -- round 2
at(0.9, { shot = "r06_tree.png" })
at(0.2, { key = "escape" })
at(0.2, { key = "3" })
at(0.9, { shot = "r07_graph.png" })
at(0.2, { key = "escape" })
at(0.2, { key = "7" })
at(0.9, { shot = "r08_workers.png" })
at(0.3, { quit = true })
return S
