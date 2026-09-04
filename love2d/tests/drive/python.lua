-- The Python track and the SHARE sheet: title, the three-button track bar,
-- a Python street, the sheet, the BIG O quest, portrait.
local maps = require "src.data_py"
local S = {}
local t = 0
local function at(dt, step)
  t = t + dt
  step.at = t
  S[#S + 1] = step
end
local function shot(name)
  at(0.8, { shot = name })
end
local function trackBtn(i)
  return function(game)
    local h = game.trackHits[i]
    return { h[1][1] + h[1][3] * 0.5, h[1][2] + h[1][4] * 0.5 }
  end
end

at(0.1, { orient = "landscape" })
at(1.6, { shot = "p01_title_go.png" })
at(0.2, { key = "tab" })
at(0.2, { key = "tab" }) -- Python track
shot("p02_title_python.png")
at(0.2, { key = "return" })
shot("p03_map_python.png")
at(0.2, { key = "1" }) -- PRINT
shot("p04_print.png")
at(0.2, { text = maps[1].stages[1].answer })
at(0.2, { key = "return" })
shot("p05_print_right.png")
at(0.2, { key = "f6" })
shot("p06_sheet.png")
at(0.2, { key = "0" }) -- PNG disk
shot("p07_sheet_saved.png")
at(0.2, { key = "escape" })
at(0.2, { key = "escape" })
at(0.2, { key = "q" })
at(0.2, { key = "q" })
at(0.2, { key = "q" }) -- P4 BIG O
shot("p08_map_bigo.png")
at(0.2, { key = "3" })
at(0.2, { key = "tab" })
shot("p09_bigo_log_hint.png")
at(0.2, { key = "escape" })
at(0.2, { click = trackBtn(1) }) -- GO
at(0.2, { key = "q" })
at(0.2, { key = "q" })
at(0.2, { key = "q" })
at(0.2, { key = "q" }) -- Q5
shot("p10_map_go_bigo.png")
at(0.2, { key = "f1" })
at(1.0, { shot = "p11_portrait_map.png" })
at(0.2, { key = "f1" })
at(0.4, { quit = true })

return S
