-- Cosine and exponential easing. t is 0..1.
local E = {}

function E.clamp(t, a, b)
  if t < a then
    return a
  end
  if t > b then
    return b
  end
  return t
end

function E.cosine(t)
  t = E.clamp(t, 0, 1)
  return (1 - math.cos(t * math.pi)) * 0.5
end

function E.cosineIn(t)
  t = E.clamp(t, 0, 1)
  return 1 - math.cos(t * math.pi * 0.5)
end

function E.cosineOut(t)
  t = E.clamp(t, 0, 1)
  return math.sin(t * math.pi * 0.5)
end

function E.expIn(t)
  t = E.clamp(t, 0, 1)
  if t == 0 then
    return 0
  end
  return math.pow(2, 10 * (t - 1))
end

function E.expOut(t)
  t = E.clamp(t, 0, 1)
  if t >= 1 then
    return 1
  end
  return 1 - math.pow(2, -10 * t)
end

function E.expInOut(t)
  t = E.clamp(t, 0, 1)
  if t == 0 then
    return 0
  end
  if t == 1 then
    return 1
  end
  if t < 0.5 then
    return 0.5 * math.pow(2, 20 * t - 10)
  end
  return 1 - 0.5 * math.pow(2, -20 * t + 10)
end

function E.lerp(a, b, t)
  return a + (b - a) * t
end

-- Frame-rate independent exponential smoothing.
function E.smooth(current, target, dt, speed)
  local k = 1 - math.exp(-speed * dt)
  return current + (target - current) * k
end

return E
