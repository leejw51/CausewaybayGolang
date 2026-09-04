-- The CALLBACK quest on all three tracks: the sixth Go quest, the sixth Rust
-- quest, the fifth Python one. Checks the six-tab quest bar and the three
-- whiteboard rounds.
local maps = require "src.data_callback"
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
at(1.6, { shot = "c01_title.png" })
at(0.2, { key = "return" })
-- Go: Q1 -> Q6 CALLBACK
for _ = 1, 5 do
  at(0.2, { key = "q" })
end
shot("c02_map_go_callback.png")
at(0.2, { key = "1" }) -- STACK
shot("c03_go_stack.png")
at(0.2, { text = maps[1].stages[1].answer })
at(0.2, { key = "return" })
shot("c04_go_stack_right.png")
at(0.2, { key = "escape" })
at(0.2, { key = "4" }) -- HEAP
at(0.2, { key = "tab" }) -- hint
shot("c05_go_heap_hint.png")
at(0.2, { key = "escape" })
-- Rust: the same quest, one track over
at(0.2, { key = "tab" })
for _ = 1, 5 do
  at(0.2, { key = "q" })
end
shot("c06_map_rust_callback.png")
at(0.2, { key = "6" }) -- LRU
shot("c07_rust_lru.png")
at(0.2, { key = "escape" })
-- Python: P5 is the fifth of its track
at(0.2, { key = "tab" })
for _ = 1, 4 do
  at(0.2, { key = "q" })
end
shot("c08_map_python_callback.png")
at(0.2, { key = "7" }) -- GRID
shot("c09_python_grid.png")
at(0.2, { key = "f1" })
at(1.0, { shot = "c10_portrait_grid.png" })
at(0.2, { key = "f1" })
at(0.4, { quit = true })

return S
