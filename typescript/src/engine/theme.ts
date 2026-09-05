/**
 * Super Mario World sky and Wonder Boy candy, not neon cyberpunk.
 * The palette of `love2d/src/theme.lua`, as numbers a canvas can use.
 */
export type RGBA = readonly [number, number, number, number];

const c = (r: number, g: number, b: number, a = 1): RGBA => [r / 255, g / 255, b / 255, a];

export const Theme = {
  void: c(20, 28, 72),
  sky: c(92, 148, 252),
  navy: c(28, 36, 92),
  panel: c(248, 208, 136),
  wood: c(176, 104, 40),
  coin: c(248, 208, 48),
  brick: c(200, 76, 12),
  grass: c(0, 168, 0),
  red: c(216, 40, 0),
  cyan: c(80, 216, 248),
  pink: c(248, 120, 168),
  cream: c(252, 236, 200),
  ink: c(40, 24, 16),
  admit: c(0, 168, 68),
  dim: c(120, 104, 88),
  paper: [0.12, 0.1, 0.28, 0.94] as RGBA,

  landW: 1280,
  landH: 720,
  portW: 720,
  portH: 1280,
};

/** Each track's colour on the map buttons, and the haze over the overworld. */
export const TRACK_COL: Record<string, RGBA> = {
  go: Theme.cyan,
  rust: [0.95, 0.47, 0.16, 1],
  python: [0.36, 0.62, 0.92, 1],
};

export const TRACK_HAZE: Record<string, RGBA> = {
  go: [0.02, 0.02, 0.1, 0.22],
  rust: [0.32, 0.08, 0.02, 0.26],
  python: [0.02, 0.1, 0.22, 0.28],
};

/** A colour a canvas will take, with an optional alpha override. */
export function css(col: RGBA, alpha?: number): string {
  const a = alpha ?? col[3] ?? 1;
  const r = Math.round(col[0] * 255);
  const g = Math.round(col[1] * 255);
  const b = Math.round(col[2] * 255);
  return `rgba(${r},${g},${b},${a})`;
}

export function withAlpha(col: RGBA, a: number): RGBA {
  return [col[0], col[1], col[2], a];
}
