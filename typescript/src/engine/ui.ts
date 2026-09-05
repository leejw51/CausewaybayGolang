/**
 * Wonder Boy / SNES chrome: a thick gold rim, wood, and a cream or navy fill.
 * `love2d/src/ui.lua`, plus the small drawing helpers `game.lua` keeps to
 * itself — the pixel button, the star and the outlined caption.
 */
import { css, RGBA, Theme } from "./theme";
import { Font, print, printf, width } from "./text";

export type Ctx = CanvasRenderingContext2D;
export type Rect = readonly [number, number, number, number];

export function fill(g: Ctx, col: RGBA, x: number, y: number, w: number, h: number, a?: number) {
  g.fillStyle = css(col, a);
  g.fillRect(x, y, w, h);
}

export function roundRect(
  g: Ctx,
  x: number,
  y: number,
  w: number,
  h: number,
  r = 8,
): void {
  const rr = Math.max(0, Math.min(r, w * 0.5, h * 0.5));
  g.beginPath();
  g.moveTo(x + rr, y);
  g.arcTo(x + w, y, x + w, y + h, rr);
  g.arcTo(x + w, y + h, x, y + h, rr);
  g.arcTo(x, y + h, x, y, rr);
  g.arcTo(x, y, x + w, y, rr);
  g.closePath();
}

/** The raised panel: ink edge, gold rim, wood frame, a shadow line, the face. */
export function panel(
  g: Ctx,
  x: number,
  y: number,
  w: number,
  h: number,
  face: RGBA = Theme.panel,
): void {
  fill(g, Theme.ink, x, y, w, h);
  fill(g, Theme.coin, x + 2, y + 2, w - 4, h - 4);
  fill(g, Theme.wood, x + 4, y + 4, w - 8, h - 8);
  fill(g, Theme.ink, x + 6, y + 6, w - 12, 2);
  fill(g, face, x + 6, y + 8, w - 12, h - 14);
}

/** The sunken well the code and the prompt sit in. */
export function well(
  g: Ctx,
  x: number,
  y: number,
  w: number,
  h: number,
  face: RGBA = [0.1, 0.08, 0.2, 0.98],
): void {
  fill(g, Theme.ink, x, y, w, h);
  fill(g, Theme.wood, x + 2, y + 2, w - 4, h - 4);
  fill(g, face, x + 4, y + 4, w - 8, h - 8);
}

/** The status bar across the top of a street. */
export function bar(g: Ctx, x: number, y: number, w: number, h: number): void {
  fill(g, Theme.navy, x, y, w, h);
  fill(g, Theme.coin, x, y + h - 3, w, 3);
  fill(g, Theme.ink, x, y + h - 1, w, 1);
}

/** `UI.panel`'s frame: eight pixels of it above the face, six below. */
export const BTN_FRAME = 14;
const BTN_AIR = 6;

/**
 * A button box that fits every one of `labels`. The desktop build measures
 * where a label's ink really lands, because Press Start 2P fills its em from
 * the top while its CJK fallback hangs below the baseline and a button sized
 * from the Latin metrics clips Korean. The browser gives us the same answer
 * from the font's own line box, which `text.ts` already uses as the height.
 */
export function btnBox(
  font: Font,
  labels: string[],
  minW = 0,
  padW = 0,
  minH = 0,
): [number, number] {
  let w = 0;
  for (const label of labels) w = Math.max(w, width(font, label));
  return [Math.max(minW, w + padW), Math.max(minH, font.height + BTN_FRAME + BTN_AIR)];
}

/** One chunky button. `dim` is shown but out of reach. */
export function pixBtn(
  g: Ctx,
  font: Font,
  x: number,
  y: number,
  w: number,
  h: number,
  label: string,
  opts: { lit?: boolean; hover?: boolean; dim?: boolean } = {},
): void {
  const face = opts.dim
    ? Theme.dim
    : opts.lit || opts.hover
      ? Theme.coin
      : Theme.panel;
  panel(g, x, y, w, h, face);
  g.fillStyle = css(Theme.ink, opts.dim ? 0.5 : 1);
  // Centre the ink inside the panel's inner face, not the whole box.
  const ty = y + 8 + Math.floor((h - BTN_FRAME - font.height) * 0.5);
  printf(g, font, label, x, ty, w, "center");
}

/** A five-pointed star with an ink outline: the "every street CLEAR" mark. */
export function star(g: Ctx, x: number, y: number, r: number, col: RGBA): void {
  g.beginPath();
  for (let i = 0; i <= 9; i++) {
    const a = -Math.PI / 2 + (i * Math.PI) / 5;
    const rr = i % 2 === 0 ? r : r * 0.45;
    const px = x + Math.cos(a) * rr;
    const py = y + Math.sin(a) * rr;
    if (i === 0) g.moveTo(px, py);
    else g.lineTo(px, py);
  }
  g.closePath();
  g.strokeStyle = css(Theme.ink);
  g.lineWidth = 3;
  g.stroke();
  g.fillStyle = css(col);
  g.fill();
  g.lineWidth = 1;
}

const SHADOW: Array<[number, number]> = [
  [2, 2],
  [-2, 2],
  [2, -2],
  [-2, -2],
  [0, 2],
  [2, 0],
];

/** Outlined pixel text, readable on any backdrop. */
export function shadowText(
  g: Ctx,
  font: Font,
  text: string,
  x: number,
  y: number,
  w: number,
  align: "left" | "center" | "right",
  col: RGBA,
): void {
  g.fillStyle = css(Theme.ink);
  for (const [dx, dy] of SHADOW) printf(g, font, text, x + dx, y + dy, w, align);
  g.fillStyle = css(col);
  printf(g, font, text, x, y, w, align);
}

/** The pulsing neon title, drawn as five widening ghosts and a white core. */
export function neonPrint(
  g: Ctx,
  font: Font,
  text: string,
  y: number,
  w: number,
  col: RGBA,
  t: number,
): void {
  const pulse = 0.7 + 0.3 * (0.5 + 0.5 * Math.cos(t * 2.2));
  for (let i = 5; i >= 1; i--) {
    g.fillStyle = css(col, 0.07 * i * pulse);
    printf(g, font, text, -i, y, w, "center");
    printf(g, font, text, i, y, w, "center");
  }
  g.fillStyle = `rgba(255,255,255,${pulse})`;
  printf(g, font, text, 0, y, w, "center");
}

export function inRect(x: number, y: number, r: Rect | null | undefined): boolean {
  return !!r && x >= r[0] && y >= r[1] && x < r[0] + r[2] && y < r[1] + r[3];
}

/** Clip to a box, run `body`, and put the old clip back. */
export function clipped(g: Ctx, x: number, y: number, w: number, h: number, body: () => void) {
  g.save();
  g.beginPath();
  g.rect(x, y, Math.max(1, w), Math.max(1, h));
  g.clip();
  body();
  g.restore();
}

export { print, printf };
