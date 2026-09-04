-- The Rust track: title, the GO / RUST switch on the map, a street, the
-- CLEARED stamp, portrait.
local maps = require "src.data_rs"
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
-- the GO / RUST buttons move with the layout, so ask the game
local function trackBtn(i)
  return function(game)
    local h = game.trackHits[i]
    return { h[1][1] + h[1][3] * 0.5, h[1][2] + h[1][4] * 0.5 }
  end
end

at(0.1, { orient = "landscape" })
at(1.6, { shot = "r01_title_go.png" })
at(0.2, { key = "tab" }) -- Rust track
shot("r02_title_rust.png")
at(0.2, { key = "return" })
shot("r03_map_rust.png")
at(0.2, { key = "1" }) -- MAIN
shot("r04_main.png")
for _, st in ipairs(maps[1].stages) do
  at(0.15, { text = st.answer })
  at(0.15, { key = "return" })
end
shot("r05_main_clear.png")
at(0.2, { key = "escape" })
shot("r06_map_cleared.png")
at(0.2, { key = "q" }) -- R2
shot("r07_map_rust_adv.png")
at(0.2, { key = "5" }) -- THREAD
at(0.2, { key = "tab" })
at(0.2, { key = "tab" })
shot("r08_thread_answer.png")
at(0.2, { key = "escape" })
at(0.2, { click = trackBtn(1) }) -- GO button
shot("r09_map_go_again.png")
at(0.2, { click = trackBtn(2) }) -- RUST button
at(0.2, { key = "f1" })
at(1.0, { shot = "r10_portrait_map_rust.png" })
at(0.2, { key = "f1" })
at(0.4, { quit = true })

return S
