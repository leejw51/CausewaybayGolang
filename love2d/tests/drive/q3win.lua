-- Quest 3 start to stamp: every blank of every street, then the win screen.
local maps = require "src.data_pro"
local S = {}
local t = 0
local function at(dt, step)
  t = t + dt
  step.at = t
  S[#S + 1] = step
end

at(0.1, { orient = "landscape" })
at(1.2, { key = "q" })
at(0.2, { key = "q" }) -- Q3 on the title
at(0.2, { key = "1" })
for i, m in ipairs(maps) do
  for si, st in ipairs(m.stages) do
    at(0.15, { text = st.answer })
    at(0.15, { key = "return" })
    if si == 1 then
      at(0.5, { shot = string.format("w%02d_%s_ok.png", i, m.id) })
    end
  end
  at(0.6, { shot = string.format("w%02d_%s_clear.png", i, m.id) })
  at(0.2, { key = "return" })
end
at(1.6, { shot = "w08_win_q3.png" })
at(0.2, { key = "return" })
at(0.8, { shot = "w09_map_q3_all_clear.png" })
at(0.3, { quit = true })
return S
