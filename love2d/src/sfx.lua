-- 8-bit sound effects, synthesized at load: square / triangle / saw / noise
-- voices rendered to 8-bit SoundData at 22050 Hz. No audio files.
--
--   SFX.play("ok")      one of the names in SOUNDS below
--   SFX.toggle()        mute / unmute (F4); saved with the display record

local SFX = { enabled = true, volume = 0.45, ok = true }

local RATE = 22050
local sources = {}

-- A step: { f = hz, d = seconds, w = wave, v = volume, to = end hz (slide),
--           duty = square duty cycle, rest = true }
local function render(steps)
  local total = 0
  for _, s in ipairs(steps) do
    total = total + s.d
  end
  local n = math.floor(total * RATE)
  local data = love.sound.newSoundData(n, RATE, 8, 1)
  local i = 0
  local phase = 0
  local seed = 12345
  for si, s in ipairs(steps) do
    local len = math.floor(s.d * RATE)
    local wave = s.w or "square"
    local duty = s.duty or 0.5
    local vol = s.v or 0.8
    local last = si == #steps
    for k = 0, len - 1 do
      if i >= n then
        break
      end
      local t = k / len
      local f = s.f or 440
      if s.to then
        f = f + (s.to - f) * t
      end
      local amp = 0
      if not s.rest then
        -- 2 ms attack, decay to 45%, release on the last step
        local env = math.min(1, k / (RATE * 0.002)) * (1 - 0.55 * t)
        if last then
          env = env * (1 - t * t)
        end
        phase = phase + f / RATE
        if phase >= 1 then
          phase = phase - 1
        end
        local x
        if wave == "square" then
          x = phase < duty and 1 or -1
        elseif wave == "tri" then
          x = phase < 0.5 and (phase * 4 - 1) or (3 - phase * 4)
        elseif wave == "saw" then
          x = phase * 2 - 1
        else -- noise
          seed = (seed * 1103515245 + 12345) % 2147483648
          x = (seed / 2147483648) * 2 - 1
        end
        amp = x * env * vol
      end
      data:setSample(i, math.max(-1, math.min(1, amp)))
      i = i + 1
    end
  end
  return data
end

local function N(name)
  local notes = {
    C4 = 261.63,
    D4 = 293.66,
    E4 = 329.63,
    F4 = 349.23,
    G4 = 392.00,
    Gs4 = 415.30,
    A4 = 440.00,
    As4 = 466.16,
    B4 = 493.88,
    C5 = 523.25,
    D5 = 587.33,
    E5 = 659.25,
    F5 = 698.46,
    G5 = 783.99,
    Gs5 = 830.61,
    A5 = 880.00,
    As5 = 932.33,
    B5 = 987.77,
    C6 = 1046.50,
    D6 = 1174.66,
    E6 = 1318.51,
    G6 = 1567.98,
  }
  return notes[name]
end

local SOUNDS = {
  type = { { f = 1400, d = 0.025, v = 0.35, duty = 0.25 } },
  move = { { f = N("E5"), d = 0.035, to = N("A5"), v = 0.5 } },
  step = { { f = N("A4"), d = 0.03, v = 0.4, duty = 0.25 } },
  walk = { { f = 140, d = 0.02, to = 90, w = "tri", v = 0.5 }, { f = 60, d = 0.012, w = "noise", v = 0.18 } },
  select = { { f = N("C5"), d = 0.05 }, { f = N("G5"), d = 0.09 } },
  back = { { f = N("G5"), d = 0.05 }, { f = N("C5"), d = 0.09 } },
  open = {
    { f = N("G4"), d = 0.05, w = "tri" },
    { f = N("C5"), d = 0.05, w = "tri" },
    { f = N("E5"), d = 0.09, w = "tri" },
  },
  hint = { { f = N("A5"), d = 0.07, w = "tri" }, { f = N("D6"), d = 0.13, w = "tri" } },
  lang = { { f = N("B5"), d = 0.04 }, { f = N("E6"), d = 0.05 } },
  toggle = { { f = N("E5"), d = 0.05, duty = 0.25 } },
  ok = { { f = N("C5"), d = 0.06 }, { f = N("E5"), d = 0.06 }, { f = N("G5"), d = 0.06 }, { f = N("C6"), d = 0.16 } },
  bad = {
    { f = N("A4"), d = 0.08, to = N("F4"), duty = 0.25 },
    { f = N("F4"), d = 0.18, to = 110, duty = 0.25 },
    { f = 200, d = 0.06, w = "noise", v = 0.3 },
  },
  combo = { { f = N("E5"), d = 0.04 }, { f = N("G5"), d = 0.04 }, { f = N("C6"), d = 0.05 }, { f = N("E6"), d = 0.10 } },
  perfect = {
    { f = N("G5"), d = 0.06 },
    { f = N("G5"), d = 0.02, rest = true },
    { f = N("G5"), d = 0.06 },
    { f = N("G5"), d = 0.02, rest = true },
    { f = N("G5"), d = 0.06 },
    { f = N("C6"), d = 0.10 },
    { f = N("E6"), d = 0.10 },
    { f = N("G6"), d = 0.10 },
    { f = N("E6"), d = 0.06, rest = true },
    { f = N("G6"), d = 0.05 },
    { f = N("C6"), d = 0.05, w = "tri" },
    { f = N("G6"), d = 0.40 },
  },
  clear = {
    { f = N("C5"), d = 0.07 },
    { f = N("E5"), d = 0.07 },
    { f = N("G5"), d = 0.07 },
    { f = N("C6"), d = 0.07 },
    { f = N("E6"), d = 0.07 },
    { f = N("G6"), d = 0.07 },
    { f = N("C6"), d = 0.05, rest = true },
    { f = N("C6"), d = 0.30 },
  },
  deny = {
    { f = N("E4"), d = 0.12, duty = 0.25 },
    { f = N("E4"), d = 0.04, rest = true },
    { f = N("C4"), d = 0.30, to = 90, duty = 0.25 },
  },
  next = { { f = 300, d = 0.18, to = 1400, w = "tri", v = 0.6 } },
  win = {
    { f = N("C5"), d = 0.11 },
    { f = N("C5"), d = 0.03, rest = true },
    { f = N("C5"), d = 0.11 },
    { f = N("C5"), d = 0.03, rest = true },
    { f = N("C5"), d = 0.11 },
    { f = N("C5"), d = 0.03, rest = true },
    { f = N("C5"), d = 0.30 },
    { f = N("Gs4"), d = 0.30 },
    { f = N("As4"), d = 0.30 },
    { f = N("C5"), d = 0.11 },
    { f = N("C5"), d = 0.10, rest = true },
    { f = N("As4"), d = 0.11 },
    { f = N("C5"), d = 0.60 },
  },
}

local function source(name)
  local src = sources[name]
  if src == nil then
    local spec = SOUNDS[name]
    if not spec then
      return nil
    end
    local okRender, data = pcall(render, spec)
    if not okRender then
      sources[name] = false
      return nil
    end
    src = love.audio.newSource(data, "static")
    sources[name] = src
  end
  return src or nil
end

-- pitch: optional multiplier (combo streaks climb)
function SFX.play(name, pitch)
  if not SFX.enabled or not SFX.ok or not love.audio then
    return
  end
  local okPlay = pcall(function()
    local src = source(name)
    if not src then
      return
    end
    src:stop()
    src:setVolume(SFX.volume)
    src:setPitch(pitch or 1)
    src:play()
  end)
  if not okPlay then
    SFX.ok = false
  end
end

-- Render every effect up front so nothing is synthesized mid-game.
function SFX.warm()
  if not love.audio then
    return
  end
  for _, n in ipairs(SFX.names) do
    pcall(source, n)
  end
end

function SFX.set(on)
  SFX.enabled = on and true or false
  return SFX.enabled
end

function SFX.toggle()
  SFX.enabled = not SFX.enabled
  if SFX.enabled then
    SFX.play("toggle")
  end
  return SFX.enabled
end

SFX.names = {}
for k in pairs(SOUNDS) do
  SFX.names[#SFX.names + 1] = k
end
table.sort(SFX.names)

return SFX
