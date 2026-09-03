-- Portrait fullscreen title in three languages.
local S = {}
local t = 0
local function at(dt, step)
  t = t + dt
  step.at = t
  S[#S + 1] = step
end
at(0.1, { orient = "portrait" })
at(0.2, { key = "f11" })
for _, l in ipairs({ "en", "ko", "yue" }) do
  at(1.4, { shot = "f06_port_title_" .. l .. ".png" })
  at(0.1, { key = "f3" })
end
at(0.2, { key = "f11" })
at(0.2, { key = "f1" })
at(0.6, { quit = true })
return S
