-- Korean and Cantonese: office street, hint, map, title, portrait.
local S = {}
local t = 0
local function at(dt, step)
  t = t + dt
  step.at = t
  S[#S + 1] = step
end
at(0.1, { orient = "landscape" })
at(0.4, { key = "3" }) -- office
at(0.2, { key = "return" }) -- empty ENTER -> feedback line
at(0.8, { shot = "k00_en_office.png" })
at(0.1, { key = "f3" }) -- ko
at(0.8, { shot = "k01_ko_office.png" })
at(0.1, { text = "r" })
at(0.1, { key = "return" })
at(0.1, { key = "tab" })
at(0.1, { key = "tab" })
at(0.8, { shot = "k02_ko_stage2_answer.png" })
at(0.1, { key = "escape" })
at(0.8, { shot = "k03_ko_map.png" })
at(0.1, { key = "escape" })
at(0.1, { key = "f3" }) -- yue
at(0.8, { shot = "k04_yue_office.png" })
at(0.1, { key = "tab" })
at(0.8, { shot = "k05_yue_hint.png" })
at(0.1, { key = "escape" })
at(0.8, { shot = "k06_yue_map.png" })
at(0.1, { key = "escape" }) -- back to the office
at(0.1, { key = "escape" }) -- map
at(0.1, { key = "5" }) -- sigma stage 1 in yue
at(0.8, { shot = "k07_yue_sigma.png" })
at(0.1, { key = "f1" })
at(1.2, { shot = "k08_yue_portrait.png" })
at(0.1, { key = "f1" })
at(0.1, { key = "escape" })
at(0.1, { key = "escape" })
at(1.0, { shot = "k09_yue_title.png" })
at(0.1, { key = "f3" }) -- back to en for the next run
at(0.5, { quit = true })
return S
