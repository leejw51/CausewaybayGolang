/** Cosine and exponential easing, from `love2d/src/ease.lua`. `t` is 0..1. */

export function clamp(t: number, a: number, b: number): number {
  return t < a ? a : t > b ? b : t;
}

export function cosine(t: number): number {
  return (1 - Math.cos(clamp(t, 0, 1) * Math.PI)) * 0.5;
}

export function expOut(t: number): number {
  t = clamp(t, 0, 1);
  return t >= 1 ? 1 : 1 - Math.pow(2, -10 * t);
}

export function expIn(t: number): number {
  t = clamp(t, 0, 1);
  return t === 0 ? 0 : Math.pow(2, 10 * (t - 1));
}

export function lerp(a: number, b: number, t: number): number {
  return a + (b - a) * t;
}

/**
 * Frame-rate independent exponential smoothing. The point of the `exp` is that
 * two frames of `dt` land where one frame of twice `dt` does, so the camera
 * does not drift with the refresh rate.
 */
export function smooth(current: number, target: number, dt: number, speed: number): number {
  return current + (target - current) * (1 - Math.exp(-speed * dt));
}
