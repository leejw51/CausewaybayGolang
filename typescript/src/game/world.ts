/**
 * The street-level camera, from `love2d/src/world.lua`.
 *
 * The backgrounds are paintings of whole buildings against a sky. The game is
 * played on the pavement, so each one is zoomed until the strip named by
 * `VIEW` fills the band, and the row named by `GROUND` is pinned to the line
 * the characters stand on. Without that, people float in front of shop doors
 * instead of standing in them.
 */
import { Assets } from "../engine/assets";
import { css, Theme } from "../engine/theme";
import { Ctx } from "../engine/ui";

/** How much of the source height one band shows. */
const VIEW: Record<string, number> = {
  title_bg: 0.46,
  title_bg_p: 0.36,
  bg_flat: 0.5,
  bg_street: 0.48,
  bg_mtr: 0.5,
  bg_times: 0.5,
  bg_mall: 0.5,
  bg_queue: 0.52,
  bg_till: 0.5,
  bg_kitchen: 0.5,
  bg_set: 0.5,
  bg_night: 0.5,
  bg_lab: 0.52,
  bg_market: 0.5,
};

/** Which row of the source is the pavement. */
const GROUND: Record<string, number> = {
  title_bg: 0.84,
  title_bg_p: 0.88,
  bg_flat: 0.86,
  bg_street: 0.86,
  bg_mtr: 0.86,
  bg_times: 0.86,
  bg_mall: 0.86,
  bg_queue: 0.88,
  bg_till: 0.88,
  bg_kitchen: 0.86,
  bg_set: 0.88,
  bg_night: 0.86,
  bg_lab: 0.9,
  bg_market: 0.88,
};

export interface Cam {
  /** The line characters' feet sit on, in the band's own coordinates. */
  groundY: number;
  /** How tall a person is drawn in this band. */
  charH: number;
  scale: number;
}

export type Kind = "play" | "title" | "win";

export function drawBackground(
  g: Ctx,
  art: Assets,
  name: string,
  dx: number,
  dy: number,
  dw: number,
  dh: number,
  portrait: boolean,
  kind: Kind = "play",
): Cam {
  const img = art.picture(name, portrait);
  const key = portrait && art.has(`${name}_p`) ? `${name}_p` : name;

  let charFrac = 0.42;
  if (kind === "title") charFrac = portrait ? 0.28 : 0.34;
  else if (kind === "win") charFrac = portrait ? 0.26 : 0.32;
  const destGround = dy + dh * (kind === "title" ? 0.9 : 0.88);

  if (!img) {
    // Still loading, or missing. A flat sky is better than a held frame.
    g.fillStyle = css(Theme.sky);
    g.fillRect(dx, dy, dw, dh);
    return { groundY: destGround, charH: Math.floor(dh * charFrac), scale: 1 };
  }

  const iw = img.width;
  const ih = img.height;
  const view = VIEW[key] ?? VIEW[name] ?? (portrait ? 0.38 : 0.5);
  const gsrc = GROUND[key] ?? GROUND[name] ?? 0.86;
  let s = dh / (ih * view);
  if (iw * s < dw) s = dw / iw;
  const x = dx + (dw - iw * s) * 0.5;
  const y = destGround - ih * gsrc * s;

  g.save();
  g.beginPath();
  g.rect(dx, dy, dw, dh);
  g.clip();
  g.imageSmoothingEnabled = true;
  g.drawImage(img, x, y, iw * s, ih * s);
  g.restore();

  return { groundY: destGround, charH: Math.floor(dh * charFrac), scale: s };
}
