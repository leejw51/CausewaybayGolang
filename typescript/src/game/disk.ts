/**
 * The PNG "disk": one square image that holds every question, hint and answer
 * of whatever SHARE's scope covers. A lesson you can carry in a photo album.
 *
 * Ported from `Share.fit` / `Share.png` in `love2d/src/share.lua`. The core
 * builds the rows — it is the side that knows the language and the scope — and
 * hands them over as JSON, because drawing is the shell's half of the job and
 * a canvas is the one thing wasm does not have.
 *
 * The page is laid out twice: once to measure at the standard body size, and
 * again to draw once a square it fits in has been found. Past the largest
 * square the type shrinks instead, down to a floor, so a whole track exports
 * as one dense poster rather than silently losing its last streets.
 */
import { Assets } from "../engine/assets";
import { css, RGBA, Theme } from "../engine/theme";
import { Ctx } from "../engine/ui";
import { print, printf, wrap } from "../engine/text";
import type { Font } from "../engine/text";

/** The squares to try, smallest first. */
const SIZES = [512, 640, 768, 1024, 1280, 1536, 2048];
const BODY_PT = 22;
const MIN_PT = 9;

const CJK =
  '"Noto Sans CJK KR","Noto Sans CJK SC","Noto Sans KR","Noto Sans SC","Hiragino Sans",' +
  '"Yu Gothic","Microsoft YaHei","Malgun Gothic",sans-serif';

export interface DiskRow {
  quest: string;
  step: number;
  station: string;
  street: string;
  stage: number;
  topic: string;
  question: string;
  code: string;
  hint: string;
  answer: string;
  why: string;
}

export interface DiskPayload {
  title: string;
  rows: DiskRow[];
}

interface Fonts {
  body: Font;
  head: Font;
  big: Font;
  m: number;
  w: number;
  lh: number;
}

/**
 * A font at an arbitrary size. The page is laid out in absolute pixels rather
 * than at the UI scale, so it does not use the game's twelve.
 */
function fontAt(size: number, kind: "body" | "pixel", g: Ctx): Font {
  const px = Math.max(6, Math.round(size));
  const family = kind === "pixel" ? `"PressStart2P",monospace,${CJK}` : `"VT323",monospace,${CJK}`;
  const cssFont = `${px}px ${family}`;
  g.font = cssFont;
  const m = g.measureText("Hg");
  const asc = m.fontBoundingBoxAscent ?? px;
  const desc = m.fontBoundingBoxDescent ?? px * 0.2;
  return { css: cssFont, size: px, height: Math.max(px, Math.round(asc + desc)) };
}

function lineCount(f: Font, text: string, w: number): number {
  return Math.max(1, wrap(f, text, Math.max(8, w)).length);
}

/** How tall the page needs to be at square `S` with body type `pt`. */
function measure(g: Ctx, rows: DiskRow[], S: number, pt: number): [number, Fonts] {
  const F: Fonts = {
    body: fontAt(pt, "body", g),
    head: fontAt(Math.max(8, Math.floor(pt * 0.55)), "pixel", g),
    big: fontAt(Math.max(8, Math.floor(pt * 0.75)), "pixel", g),
    m: Math.floor(S * 0.04),
    w: 0,
    lh: 0,
  };
  F.w = S - F.m * 2;
  F.lh = F.body.height;
  const { m, w, lh } = F;

  let y = m + F.big.height + F.head.height + Math.floor(lh * 1.2);
  let lastStreet: string | null = null;
  for (const r of rows) {
    const key = `${r.quest}${r.step}`;
    if (key !== lastStreet) {
      lastStreet = key;
      y += F.head.height + Math.floor(lh * 0.6);
    }
    y += F.head.height + 4;
    y += lineCount(F.body, r.question, w) * lh;
    y += r.code.split("\n").length * lh;
    y += lineCount(F.body, r.hint, w - lh * 3) * lh;
    y += lh;
    y += lineCount(F.body, r.why, w - lh * 3) * lh;
    y += Math.floor(lh * 0.8);
  }
  return [y + F.head.height + m, F];
}

/** The smallest square that holds the page; past the largest, shrink the type. */
function fit(g: Ctx, rows: DiskRow[]): [number, number] {
  for (const S of SIZES) {
    if (measure(g, rows, S, BODY_PT)[0] <= S) return [S, BODY_PT];
  }
  const S = SIZES[SIZES.length - 1];
  for (let pt = BODY_PT - 1; pt > MIN_PT; pt--) {
    if (measure(g, rows, S, pt)[0] <= S) return [S, pt];
  }
  return [S, MIN_PT];
}

const INK: RGBA = [0.1, 0.08, 0.16, 1];
const PAPER: RGBA = [0.99, 0.96, 0.88, 1];
const CODE: RGBA = [0.14, 0.12, 0.28, 1];
const BLANK: RGBA = [0.86, 0.32, 0.04, 1];
const GREEN: RGBA = [0.05, 0.5, 0.22, 1];
const DIM: RGBA = [0.4, 0.36, 0.34, 1];

function drawPage(
  g: Ctx,
  payload: DiskPayload,
  S: number,
  F: Fonts,
  art: Assets,
  track: string,
  foot: string,
): void {
  const { rows, title } = payload;
  const { m, w, lh } = F;
  const today = new Date().toISOString().slice(0, 10);
  const sub = `${today}  ·  ${rows.length} Q  ·  ${foot}`;

  g.fillStyle = css(PAPER);
  g.fillRect(0, 0, S, S);

  const bandH = m + F.big.height + F.head.height + Math.floor(lh * 0.6);
  g.fillStyle = css(Theme.navy);
  g.fillRect(0, 0, S, bandH);
  g.fillStyle = css(Theme.coin);
  g.fillRect(0, bandH - 4, S, 4);
  g.fillStyle = css(Theme.coin);
  printf(g, F.big, title, m, m * 0.6, w, "left");
  g.fillStyle = css(Theme.cream);
  printf(g, F.head, sub, m, m * 0.6 + F.big.height + 4, w, "left");

  // The track's mascot in the corner of the band.
  const sheet =
    track === "rust" ? "sprite_ferris" : track === "python" ? "sprite_monty" : "sprite_gogo";
  const img = art.picture(sheet);
  const box = art.box.get(sheet);
  if (img) {
    const h = bandH * 0.7;
    const sc = h / Math.max(1, box?.h ?? img.height);
    g.save();
    g.translate(S - m - bandH * 0.35, bandH - 8);
    g.scale(sc, sc);
    g.imageSmoothingEnabled = false;
    g.drawImage(img, -(box?.cx ?? img.width * 0.5), -(box?.feet ?? img.height));
    g.restore();
  }

  let y = bandH + Math.floor(lh * 0.6);
  let lastStreet: string | null = null;
  for (const r of rows) {
    const key = `${r.quest}${r.step}`;
    if (key !== lastStreet) {
      lastStreet = key;
      g.fillStyle = css(Theme.brick);
      printf(g, F.head, `${r.quest} ${r.step}  ${r.station}  —  ${r.street}`, m, y, w, "left");
      y += F.head.height + Math.floor(lh * 0.6);
    }
    g.fillStyle = css(INK);
    printf(g, F.head, `${r.stage}. ${r.topic}`, m, y, w, "left");
    y += F.head.height + 4;
    g.fillStyle = css(INK);
    printf(g, F.body, r.question, m, y, w, "left");
    y += lineCount(F.body, r.question, w) * lh;

    for (const line of r.code.split("\n")) {
      if (line.includes("___")) g.fillStyle = css(BLANK);
      else if (/^\s*(#|\/\/)/.test(line)) g.fillStyle = css(DIM);
      else g.fillStyle = css(CODE);
      print(g, F.body, line, m + lh, y);
      y += lh;
    }

    g.fillStyle = css(DIM);
    print(g, F.body, "?", m, y);
    g.fillStyle = css(INK);
    printf(g, F.body, r.hint, m + lh * 1.5, y, w - lh * 3, "left");
    y += lineCount(F.body, r.hint, w - lh * 3) * lh;

    g.fillStyle = css(GREEN);
    print(g, F.body, `= ${r.answer}`, m, y);
    y += lh;

    g.fillStyle = css(DIM);
    print(g, F.body, "!", m, y);
    g.fillStyle = css(INK);
    printf(g, F.body, r.why, m + lh * 1.5, y, w - lh * 3, "left");
    y += lineCount(F.body, r.why, w - lh * 3) * lh;
    y += Math.floor(lh * 0.8);
  }

  g.fillStyle = css(DIM);
  printf(g, F.head, `causewaybaygo  ·  ${foot}`, m, S - m - F.head.height, w, "right");
}

/** Render the disk. Resolves to null when the browser refuses the canvas. */
export async function renderDisk(
  json: string,
  art: Assets,
  track: string,
  foot: string,
): Promise<Blob | null> {
  let payload: DiskPayload;
  try {
    payload = JSON.parse(json) as DiskPayload;
  } catch {
    return null;
  }
  if (payload.rows.length === 0) return null;

  const canvas = document.createElement("canvas");
  const g = canvas.getContext("2d");
  if (!g) return null;

  // Measured on a scratch context first: `fit` lays the page out several times
  // and there is no point sizing the real canvas until it has an answer.
  const [S, pt] = fit(g, payload.rows);
  canvas.width = S;
  canvas.height = S;
  const [, F] = measure(g, payload.rows, S, pt);
  drawPage(g, payload, S, F, art, track, foot);

  return new Promise((resolve) => canvas.toBlob((b) => resolve(b), "image/png"));
}
