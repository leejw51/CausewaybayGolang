-- Every street, every stage, generated from src/data.lua, plus every input
-- path. Landscape 1280x720 virtual coordinates:
--   HUD MAP (970,35)  HINT (65,698)  OK/NEXT (185,698)
--   level dot i: game:mapNodes()[i]  station i (58+132*(i-1), 25)
--   scene MAP label (100, 95)
local maps = require "src.data"

-- overworld level dot i (positions depend on the layout, so ask the game)
local function row(i)
  return function(game)
    local nd = game:mapNodes()[i]
    return { nd.x, nd.y }
  end
end
local function station(i)
  return { 58 + 132 * (i - 1), 25 }
end

local S = {}
local t = 0
local function at(dt, step)
  t = t + dt
  step.at = t
  S[#S + 1] = step
end
local function shot(name)
  at(0.7, { shot = name })
end

at(0.1, { orient = "landscape" })
at(1.8, { shot = "a01_title.png" })
at(0.2, { click = { 640, 300 } }) -- title click -> map
shot("a02_map.png")
at(0.2, { click = row(1) }) -- click a row -> street 1

for i, m in ipairs(maps) do
  local tag = string.format("s%d_%s", i, m.id)
  at(0.8, { shot = string.format("b%02d_%s_stage1.png", i, tag) })
  for si, st in ipairs(m.stages) do
    if i == 1 and si == 1 then
      -- wrong answer opens the nudge; second HINT press shows the answer
      at(0.2, { text = "x" })
      at(0.2, { key = "return" })
      shot("c01_wrong_nudge.png")
      at(0.2, { click = { 65, 698 } }) -- HINT button -> answer
      shot("c02_answer.png")
      at(0.2, { click = { 65, 698 } }) -- HINT button -> hide
      at(0.2, { key = "backspace" })
    end
    at(0.2, { text = st.answer })
    if si % 2 == 0 then
      at(0.2, { click = { 185, 698 } }) -- OK button
    else
      at(0.2, { key = "return" })
    end
    if si < #m.stages then
      at(0.7, { shot = string.format("b%02d_%s_stage%d.png", i, tag, si + 1) })
    end
  end
  shot(string.format("b%02d_%s_clear.png", i, tag))
  if i == 6 then
    -- HUD MAP button, then pick the last street from the map
    at(0.2, { click = { 970, 35 } })
    shot("c03_map_from_play.png")
    at(0.2, { click = row(7) })
  elseif i % 3 == 0 then
    at(0.2, { click = { 185, 698 } }) -- NEXT button
  elseif i % 3 == 1 then
    at(0.2, { key = "return" })
  else
    at(0.2, { key = "space" })
  end
end

at(1.5, { shot = "d01_win.png" })
at(0.2, { key = "escape" }) -- win -> title
at(1.2, { shot = "d02_title_all_clear.png" })
at(0.2, { key = "c" }) -- continue with everything clear -> street 1
at(1.0, { shot = "d03_continue.png" })
at(0.2, { click = station(6) }) -- station bar jump
at(1.0, { shot = "d04_station_jump.png" })
at(0.2, { click = { 100, 95 } }) -- scene MAP label
shot("d05_map_here6.png")
at(0.2, { key = "escape" }) -- back to street 6
at(0.2, { key = "f1" }) -- portrait
at(1.2, { shot = "d06_portrait_play.png" })
at(0.2, { key = "tab" })
at(0.2, { key = "tab" })
shot("d07_portrait_answer.png")
at(0.2, { key = "f2" })
shot("d08_portrait_map.png")
at(0.2, { key = "f1" }) -- back to landscape for the next run
at(0.6, { quit = true })

return S
