/**
 * Drawing people, props and mascots, from `love2d/src/sprites.lua`.
 *
 * Every sheet is pinned by the box `mkassets` measured for it rather than by
 * its corner: `cx` is the middle of the ink and `feet` the row the subject
 * stands on, so a tall render and a short one line up on the same pavement.
 *
 * The desktop build carries hand-drawn primitive versions of Ferris, Monty and
 * the crowd for a checkout with no art in it (`src/ferris.lua`, `src/monty.lua`,
 * `src/chibi.lua`). The web build always ships its art — `make art` is part of
 * `make build` — so what is here instead is a plain coloured marker, enough to
 * make a missing file obvious without pretending to be a crab.
 */
import { Assets } from "../engine/assets";
import { css, RGBA, Theme } from "../engine/theme";
import { Ctx } from "../engine/ui";

/** Ken reuses the cook's sheet; the officer does too (generation blocked). */
const ALIAS: Record<string, string> = { ken: "cook", officer: "cook" };

export interface DrawOpts {
  t?: number;
  facing?: number;
  walk?: boolean;
  bounce?: number;
  h?: number;
  alpha?: number;
  still?: boolean;
}

/** A person, with their feet at (x, y). */
export function drawCharacter(
  g: Ctx,
  art: Assets,
  kind: string,
  x: number,
  y: number,
  opts: DrawOpts = {},
): void {
  const key = `sprite_${ALIAS[kind] ?? kind}`;
  const img = art.picture(key);
  const t = opts.t ?? 0;
  const facing = opts.facing ?? 1;
  const target = opts.h ?? 96;
  if (!img) {
    marker(g, x, y, target, Theme.dim);
    return;
  }
  const box = art.box.get(key);
  const ih = Math.max(1, img.height);
  const ox = box?.cx ?? img.width * 0.5;
  const oy = box?.feet ?? ih;
  const s = target / ih;
  const scale = Math.max(0.6, target / 96);
  const bob = (opts.walk ? Math.abs(Math.sin(t * 12)) * 2 : Math.sin(t * 3) * 0.8) * scale;
  const bounce = (opts.bounce ?? 0) * scale;

  g.save();
  g.globalAlpha = opts.alpha ?? 1;
  g.translate(x, y - bob - bounce);
  g.scale(facing * s, s);
  // Ken is the cook in a pink coat, which is the whole difference between them.
  if (kind === "ken") g.filter = "hue-rotate(300deg) saturate(1.4)";
  g.imageSmoothingEnabled = false;
  g.drawImage(img, -ox, -oy);
  g.restore();
}

/**
 * A prop. `s` under eight is a plain multiplier; eight or more is the height
 * in pixels, which is how the Wonder Boy props are sized everywhere.
 */
export function drawItem(
  g: Ctx,
  art: Assets,
  name: string,
  x: number,
  y: number,
  s = 1,
  rot = 0,
): void {
  const img = art.picture(name);
  if (!img) return;
  const scale = s >= 8 ? s / img.height : s;
  g.save();
  g.translate(x, y);
  g.rotate(rot);
  g.scale(scale, scale);
  g.imageSmoothingEnabled = false;
  g.drawImage(img, -img.width * 0.5, -img.height * 0.5);
  g.restore();
}

/** The coffee gopher, Ferris or Monty, with their feet at (x, y). */
export function drawMascot(
  g: Ctx,
  art: Assets,
  track: string,
  x: number,
  y: number,
  h: number,
  opts: DrawOpts & { phase?: number } = {},
): void {
  const name =
    track === "rust" ? "sprite_ferris" : track === "python" ? "sprite_monty" : "sprite_gogo";
  const img = art.picture(name);
  const t = (opts.t ?? 0) + (opts.phase ?? 0);
  if (!img) {
    // The gopher's fallback is the morning set itself, which is on the title
    // card anyway; the other two get a marker.
    if (track === "go") drawItem(g, art, "item_set", x, y - h * 0.5, h, Math.sin(t * 2) * 0.1);
    else marker(g, x, y, h, track === "rust" ? [0.93, 0.36, 0.12, 1] : [0.36, 0.62, 0.92, 1]);
    return;
  }
  const box = art.box.get(name);
  const ih = Math.max(1, box?.h ?? img.height);
  const sc = h / ih;
  const bob = opts.still ? 0 : Math.sin(t * 2.6) * 1.5;
  const hop = opts.walk ? Math.abs(Math.sin(t * 9)) * 2.5 : 0;

  g.save();
  g.globalAlpha = opts.alpha ?? 1;
  g.translate(x, y - bob - hop);
  g.rotate(opts.walk ? Math.sin(t * 9) * 0.04 : 0);
  g.scale((opts.facing ?? 1) * sc, sc);
  g.imageSmoothingEnabled = false;
  g.drawImage(img, -(box?.cx ?? img.width * 0.5), -(box?.feet ?? img.height));
  g.restore();
}

/** Somebody should be standing here and their sheet did not arrive. */
function marker(g: Ctx, x: number, y: number, h: number, col: RGBA): void {
  const w = h * 0.4;
  g.fillStyle = css(Theme.ink, 0.7);
  g.fillRect(x - w * 0.5 - 2, y - h - 2, w + 4, h + 4);
  g.fillStyle = css(col, 0.9);
  g.fillRect(x - w * 0.5, y - h, w, h);
}

/** A little arc of hop, for the props that bounce when a blank is answered. */
export function hop(clock: number, strength = 12): number {
  return Math.sin(Math.max(0, Math.min(1, clock)) * Math.PI) * strength;
}
