-- All three quests: map, first street, the longest code block, portrait.
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

at(0.1, { orient = "landscape" })
at(1.6, { shot = "q01_title.png" })
at(0.2, { key = "return" })
shot("q02_map_q1.png")
at(0.2, { key = "q" })
shot("q03_map_q2.png")
at(0.2, { key = "q" })
shot("q04_map_q3.png")
at(0.2, { key = "1" }) -- STRINGS
shot("q05_strings_rune.png")
at(0.2, { key = "tab" })
at(0.2, { key = "tab" })
shot("q06_strings_answer.png")
at(0.2, { key = "escape" })
at(0.2, { key = "7" }) -- MODERN
at(0.2, { key = "pagedown" })
at(0.2, { key = "pagedown" })
at(0.2, { key = "pagedown" })
at(0.2, { key = "pagedown" })
at(0.2, { key = "pagedown" })
shot("q07_modern_iter.png")
at(0.2, { key = "f3" }) -- Korean
shot("q08_modern_iter_ko.png")
at(0.2, { key = "f3" }) -- Cantonese
shot("q09_modern_iter_yue.png")
at(0.2, { key = "f3" }) -- back to English
at(0.2, { key = "f1" }) -- portrait
at(1.0, { shot = "q10_portrait_modern.png" })
at(0.2, { key = "f2" })
shot("q11_portrait_map_q3.png")
at(0.2, { key = "f1" })
at(0.2, { key = "escape" }) -- map -> back to the street
at(0.2, { key = "escape" }) -- street -> map
at(0.2, { key = "q" }) -- Q1
at(0.2, { key = "5" }) -- SLICES: 8 blanks
shot("q12_slices_8_blanks.png")
at(0.2, { key = "escape" })
at(0.2, { key = "q" }) -- Q2
at(0.2, { key = "5" }) -- SYNC
at(0.2, { key = "pagedown" })
at(0.2, { key = "pagedown" })
at(0.2, { key = "pagedown" })
at(0.2, { key = "pagedown" })
at(0.2, { key = "pagedown" })
at(0.2, { key = "pagedown" })
shot("q13_sync_errgroup.png")
at(0.4, { quit = true })

return S
