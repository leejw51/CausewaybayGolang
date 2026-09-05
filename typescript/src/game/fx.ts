/**
 * The three tiers of "you did it", drawn over the scene. From `love2d/src/fx.lua`.
 *
 *   small   a blank answered   a ring, a handful of sparkle stars, and a short
 *                              word that pops and drifts (0.7 s)
 *   big     a street CLEAR     confetti rain, three shockwaves, and a ribbon
 *                              banner whose letters land one by one, with a
 *                              medal when it was PERFECT (2.8 s)
 *   quest   the quest's stamp  fireworks that keep going, heavy confetti, gold
 *                              rays, the trophy and the banner (5 s)
 *
 * Plus the plain burst of sparks the rest of the game asks for on a right
 * answer, a track switch or a menu opening — `Game:burst` in the Lua.
 *
 * Everything is data until `draw`: `update` never touches a canvas, which is
 * what lets the whole layer be stepped in a unit test.
 */
import { clamp, expOut } from "../engine/ease";
import { Font } from "../engine/text";
import { css, RGBA, Theme } from "../engine/theme";
import { Assets } from "../engine/assets";
import { Ctx, roundRect } from "../engine/ui";
import { print, width } from "../engine/text";

export const LIFE = { small: 0.7, big: 2.8, quest: 5.0 };

const PALETTE: RGBA[] = [
  Theme.coin,
  Theme.cream,
  Theme.cyan,
  Theme.pink,
  Theme.admit,
  Theme.red,
];

export interface Rect {
  x: number;
  y: number;
  w: number;
  h: number;
}

interface Bit {
  star: boolean;
  x: number;
  y: number;
  vx: number;
  vy: number;
  rot: number;
  vr: number;
  g: number;
  drag?: number;
  flutter?: number;
  phase?: number;
  life: number;
  max: number;
  s: number;
  tint: RGBA;
}

interface Ring {
  x: number;
  y: number;
  t: number;
  max: number;
  r1: number;
  col: RGBA;
}

interface Banner {
  quest: boolean;
  letters: string[];
  t: number;
  max: number;
  x: number;
  y: number;
  icon: string | null;
  w: number;
}

interface Word {
  text: string;
  x: number;
  y: number;
  t: number;
  max: number;
  col: RGBA;
}

interface Fuse {
  at: number;
  x: number;
  y: number;
  n: number;
}

/** The plain spark shower the game throws around outside the three tiers. */
interface Spark {
  x: number;
  y: number;
  vx: number;
  vy: number;
  life: number;
  max: number;
  r: number;
  col: RGBA;
  star: boolean;
}

function rnd(a?: number, b?: number): number {
  const r = Math.random();
  return a === undefined || b === undefined ? r : a + (b - a) * r;
}

function pick<T>(list: T[]): T {
  return list[Math.floor(Math.random() * list.length)];
}

export class FX {
  private t = 0;
  private bits: Bit[] = [];
  private rings: Ring[] = [];
  private banners: Banner[] = [];
  private words: Word[] = [];
  private fuses: Fuse[] = [];
  private rays: { x: number; y: number; t: number; max: number } | null = null;
  /** The confetti of `Game:burst`, which outlives a `clear()` of the tiers. */
  private sparks: Spark[] = [];

  bannerCount(): number {
    return this.banners.length;
  }

  // ------------------------------------------------------------------ spawn

  star(x: number, y: number, speed: number, life: number): void {
    const ang = rnd() * Math.PI * 2;
    const sp = speed * (0.5 + rnd());
    this.bits.push({
      star: true,
      x,
      y,
      vx: Math.cos(ang) * sp,
      vy: Math.sin(ang) * sp - speed * 0.25,
      rot: rnd() * Math.PI,
      vr: rnd(-6, 6),
      g: 260,
      life,
      max: life,
      s: 0.5 + rnd() * 0.7,
      tint: rnd() < 0.7 ? Theme.coin : Theme.cream,
    });
  }

  confetti(x: number, y: number, vx: number, vy: number, life: number): void {
    this.bits.push({
      star: false,
      x,
      y,
      vx,
      vy,
      rot: rnd() * Math.PI,
      vr: rnd(-9, 9),
      g: 120,
      drag: 1.6,
      flutter: rnd(2, 5),
      phase: rnd() * Math.PI * 2,
      life,
      max: life,
      s: 0.6 + rnd() * 0.8,
      tint: pick(PALETTE),
    });
  }

  ring(x: number, y: number, r1: number, col: RGBA = Theme.coin, life = 0.5): void {
    this.rings.push({ x, y, t: 0, max: life, r1, col });
  }

  /** One firework: a ring and a shell of stars. */
  firework(x: number, y: number, n: number): void {
    this.ring(x, y, 90, pick(PALETTE), 0.6);
    for (let i = 0; i < n; i++) this.star(x, y, 240, 0.9 + rnd() * 0.7);
  }

  /** `Game:burst`: a handful of gold and neon sparks at a point. */
  burst(x: number, y: number, n = 24): void {
    const pal = [Theme.coin, Theme.pink, Theme.cyan, Theme.cream, Theme.admit];
    for (let i = 0; i < n; i++) {
      const ang = rnd() * Math.PI * 2;
      const sp = 60 + rnd() * 220;
      this.sparks.push({
        x,
        y,
        vx: Math.cos(ang) * sp,
        vy: Math.sin(ang) * sp - 80,
        life: 0.7 + rnd() * 0.8,
        max: 1.4,
        r: 2 + rnd() * 4,
        col: pick(pal),
        star: rnd() < 0.4,
      });
    }
  }

  /** A slow rise of gold and cream, for the title screen. */
  titleSpark(w: number, h: number): void {
    this.sparks.push({
      x: rnd(40, w - 40),
      y: h + 10,
      vx: (rnd() - 0.5) * 24,
      vy: -50 - rnd() * 70,
      life: 2.6,
      max: 2.6,
      r: 1.5 + rnd() * 2,
      col: rnd() < 0.5 ? Theme.coin : Theme.cream,
      star: rnd() < 0.35,
    });
  }

  // ------------------------------------------------------------------ tiers

  small(x: number, y: number, text: string): void {
    this.ring(x, y, 70, Theme.coin, 0.45);
    for (let i = 0; i < 10; i++) this.star(x, y, 170, 0.45 + rnd() * 0.3);
    if (text) {
      this.words.push({ text, x, y: y - 24, t: 0, max: LIFE.small, col: Theme.cream });
    }
  }

  big(rect: Rect, text: string, perfect: boolean): void {
    const cx = rect.x + rect.w * 0.5;
    const cy = rect.y + rect.h * 0.42;
    const cols = [Theme.coin, Theme.cream, Theme.cyan];
    for (let i = 0; i < 3; i++) {
      // A negative `t` is a shockwave that has not started yet.
      this.rings.push({ x: cx, y: cy, t: -i * 0.12, max: 0.7, r1: rect.w * 0.45, col: cols[i] });
    }
    for (let i = 0; i < 28; i++) this.star(cx, cy, 260, 0.8 + rnd() * 0.6);
    for (let i = 0; i < 70; i++) {
      this.confetti(
        rect.x + rnd() * rect.w,
        rect.y - rnd() * 60,
        rnd(-40, 40),
        rnd(20, 90),
        2.2 + rnd(),
      );
    }
    this.banners.push({
      quest: false,
      letters: [...text],
      t: 0,
      max: LIFE.big,
      x: cx,
      y: rect.y + rect.h * 0.56,
      icon: perfect ? "fx_medal" : null,
      w: rect.w,
    });
  }

  quest(rect: Rect, text: string): void {
    const cx = rect.x + rect.w * 0.5;
    this.rays = { x: cx, y: rect.y + rect.h * 0.42, t: 0, max: LIFE.quest };
    for (let i = 0; i < 140; i++) {
      this.confetti(
        rect.x + rnd() * rect.w,
        rect.y - rnd() * 200,
        rnd(-30, 30),
        rnd(30, 110),
        3 + rnd() * 1.5,
      );
    }
    this.firework(cx, rect.y + rect.h * 0.3, 40);
    for (let i = 1; i <= 9; i++) {
      this.fuses.push({
        at: 0.25 * i + rnd() * 0.15,
        x: rect.x + rect.w * (0.15 + rnd() * 0.7),
        y: rect.y + rect.h * (0.12 + rnd() * 0.4),
        n: 22 + Math.floor(rnd() * 16),
      });
    }
    this.banners.push({
      quest: true,
      letters: [...text],
      t: 0,
      max: LIFE.quest,
      x: cx,
      y: rect.y + rect.h * 0.42,
      icon: "fx_trophy",
      w: rect.w,
    });
  }

  /** Everything the three tiers put on screen, gone. Sparks are left alone. */
  clear(): void {
    this.bits = [];
    this.rings = [];
    this.banners = [];
    this.words = [];
    this.fuses = [];
    this.rays = null;
  }

  active(): boolean {
    return (
      this.bits.length > 0 ||
      this.rings.length > 0 ||
      this.banners.length > 0 ||
      this.words.length > 0 ||
      this.fuses.length > 0 ||
      this.rays !== null ||
      this.sparks.length > 0
    );
  }

  // ----------------------------------------------------------------- update

  update(dt: number): void {
    this.t += dt;
    this.bits = this.bits.filter((b) => {
      b.life -= dt;
      if (b.life <= 0) return false;
      b.vy += b.g * dt;
      if (b.drag !== undefined) {
        const k = 1 - Math.min(1, b.drag * dt);
        b.vx *= k;
        b.vy *= k;
        b.x += Math.sin(this.t * (b.flutter ?? 0) + (b.phase ?? 0)) * 40 * dt;
      }
      b.x += b.vx * dt;
      b.y += b.vy * dt;
      b.rot += b.vr * dt;
      return true;
    });
    this.rings = this.rings.filter((r) => (r.t += dt) < r.max);
    this.words = this.words.filter((w) => {
      w.t += dt;
      w.y -= 40 * dt;
      return w.t < w.max;
    });
    this.banners = this.banners.filter((b) => (b.t += dt) < b.max);
    const due = this.fuses.filter((f) => (f.at -= dt) <= 0);
    this.fuses = this.fuses.filter((f) => f.at > 0);
    for (const f of due) this.firework(f.x, f.y, f.n);
    if (this.rays && (this.rays.t += dt) >= this.rays.max) this.rays = null;
    this.sparks = this.sparks.filter((p) => {
      p.life -= dt;
      if (p.life <= 0) return false;
      p.vy += 420 * dt;
      p.x += p.vx * dt;
      p.y += p.vy * dt;
      return true;
    });
  }

  // ------------------------------------------------------------------- draw

  /** The sparks, which sit under the three tiers and over the scene. */
  drawSparks(g: Ctx, t: number): void {
    for (let i = 0; i < this.sparks.length; i++) {
      const p = this.sparks[i];
      const a = expOut(clamp(p.life / p.max, 0, 1));
      g.fillStyle = css(p.col, a);
      if (p.star) {
        const r = p.r * (0.6 + 0.4 * a);
        g.save();
        g.translate(p.x, p.y);
        g.rotate(t * 2 + i);
        spike(g, r, 0.25);
        g.fill();
        g.restore();
      } else {
        g.beginPath();
        g.arc(p.x, p.y, p.r, 0, Math.PI * 2);
        g.fill();
      }
    }
  }

  draw(g: Ctx, art: Assets, titleFont: Font, uiFont: Font): void {
    if (this.rays) drawRays(g, this.rays);
    for (const r of this.rings) drawRing(g, r);
    for (const b of this.bits) {
      const a = expOut(clamp(b.life / b.max, 0, 1));
      if (b.star) drawStar(g, art, b, a);
      else drawConfetti(g, art, b, a);
    }
    for (const b of this.banners) drawBanner(g, art, titleFont, b);
    for (const w of this.words) drawWord(g, uiFont, w);
  }
}

/** The eight-point sparkle both the sparks and the fallback star are drawn as. */
function spike(g: Ctx, r: number, waist: number): void {
  const w = r * waist;
  g.beginPath();
  g.moveTo(0, -r);
  g.lineTo(w, -w);
  g.lineTo(r, 0);
  g.lineTo(w, w);
  g.lineTo(0, r);
  g.lineTo(-w, w);
  g.lineTo(-r, 0);
  g.lineTo(-w, -w);
  g.closePath();
}

function drawStar(g: Ctx, art: Assets, b: Bit, a: number): void {
  const img = art.picture("fx_star");
  g.save();
  g.globalAlpha = (b.tint[3] ?? 1) * a;
  if (img) {
    const s = b.s * (0.5 + 0.5 * a);
    g.translate(b.x, b.y);
    g.rotate(b.rot);
    g.scale(s, s);
    g.imageSmoothingEnabled = false;
    g.drawImage(img, -img.width * 0.5, -img.height * 0.5);
  } else {
    g.fillStyle = css(b.tint, 1);
    g.translate(b.x, b.y);
    g.rotate(b.rot);
    spike(g, 6 * b.s * (0.5 + 0.5 * a), 0.3);
    g.fill();
  }
  g.restore();
}

function drawConfetti(g: Ctx, art: Assets, b: Bit, a: number): void {
  const img = art.picture("fx_confetti");
  // A paper flake seen edge-on is thin: the x scale fakes the tumble.
  const edge = Math.max(0.15, Math.abs(Math.cos(b.rot * 1.7)));
  g.save();
  g.globalAlpha = (b.tint[3] ?? 1) * a;
  g.translate(b.x, b.y);
  g.rotate(b.rot);
  if (img) {
    g.scale(b.s * edge, b.s);
    g.imageSmoothingEnabled = false;
    g.drawImage(img, -img.width * 0.5, -img.height * 0.5);
  } else {
    g.fillStyle = css(b.tint, 1);
    const w = 10 * b.s * edge;
    g.fillRect(-w * 0.5, -3 * b.s, w, 6 * b.s);
  }
  g.restore();
}

function drawRing(g: Ctx, r: Ring): void {
  if (r.t < 0) return;
  const k = expOut(clamp(r.t / r.max, 0, 1));
  const rad = 8 + r.r1 * k;
  g.strokeStyle = css(r.col, (1 - k) * 0.9);
  g.lineWidth = 3 + 5 * (1 - k);
  g.beginPath();
  g.arc(r.x, r.y, rad, 0, Math.PI * 2);
  g.stroke();
  g.lineWidth = 1;
}

/**
 * The letters of a banner: each lands a beat after the last, then the whole
 * word waves and shimmers between gold and cream.
 */
function drawLetters(
  g: Ctx,
  f: Font,
  letters: string[],
  t: number,
  life: number,
  big: boolean,
): void {
  const widths = letters.map((ch) => width(f, ch));
  const total = widths.reduce((a, b) => a + b, 0);
  const fade = clamp((life - t) / 0.4, 0, 1);
  let lx = -total * 0.5;
  const h = f.height;
  for (let i = 0; i < letters.length; i++) {
    const at = i * (big ? 0.05 : 0.035);
    const k = expOut(clamp((t - at) * 4, 0, 1));
    if (k > 0) {
      const wave = k >= 1 ? Math.sin(t * 7 - i * 0.55) * 3 : 0;
      const sc = 2.2 - 1.2 * k;
      const shimmer = 0.5 + 0.5 * Math.sin(t * 9 - i * 0.7);
      g.save();
      g.translate(lx + widths[i] * 0.5, wave - (1 - k) * 40);
      g.scale(sc, sc);
      g.rotate((1 - k) * 0.3);
      g.fillStyle = `rgba(26,8,13,${0.9 * k * fade})`;
      for (let ox = -2; ox <= 2; ox += 2) {
        for (let oy = -2; oy <= 2; oy += 2) {
          if (ox !== 0 || oy !== 0) {
            print(g, f, letters[i], -widths[i] * 0.5 + ox, -h * 0.5 + oy);
          }
        }
      }
      const gr = Math.round((0.8 + 0.2 * shimmer) * 255);
      const b = Math.round((0.25 + 0.55 * shimmer) * 255);
      g.fillStyle = `rgba(255,${gr},${b},${k * fade})`;
      print(g, f, letters[i], -widths[i] * 0.5, -h * 0.5);
      g.restore();
    }
    lx += widths[i];
  }
}

function drawBanner(g: Ctx, art: Assets, f: Font, b: Banner): void {
  const drop = expOut(clamp(b.t * 3, 0, 1));
  const fade = clamp((b.max - b.t) / 0.4, 0, 1);
  const y = b.y - (1 - drop) * 120;
  const total = b.letters.reduce((a, ch) => a + width(f, ch), 0);
  const maxW = b.w * 0.72;
  const sc = Math.min(1, maxW / Math.max(1, total));
  const h = f.height;
  const rw = total * sc + 150;
  const rh = h * sc + 64;

  const ribbon = art.picture("fx_ribbon");
  const box = art.box.get("fx_ribbon");
  if (ribbon && box) {
    const bw = box.maxx - box.minx + 1;
    const bh = box.maxy - box.miny + 1;
    g.save();
    g.globalAlpha = fade;
    g.imageSmoothingEnabled = false;
    // Stretch the ink, not the transparent margin the sheet was keyed out of.
    g.translate(b.x, y);
    g.scale(rw / bw, rh / bh);
    g.drawImage(ribbon, -box.cx, -(box.miny + box.maxy) * 0.5);
    g.restore();
  } else {
    g.fillStyle = css(Theme.red, 0.92 * fade);
    roundRect(g, b.x - rw * 0.5, y - rh * 0.5, rw, rh, 6);
    g.fill();
    g.strokeStyle = css(Theme.coin, fade);
    g.lineWidth = 3;
    g.stroke();
    g.lineWidth = 1;
  }

  g.save();
  g.translate(b.x, y);
  g.scale(sc, sc);
  drawLetters(g, f, b.letters, b.t, b.max, b.quest);
  g.restore();

  if (!b.icon) return;
  const ik = expOut(clamp((b.t - 0.35) * 2.5, 0, 1));
  if (ik <= 0) return;
  const bob = Math.sin(b.t * 3) * 4;
  const size = b.quest ? 150 : 84;
  const iy = y - rh * 0.5 - size * 0.55 - (1 - ik) * 80 + bob;
  const img = art.picture(b.icon);
  if (img) {
    const s = (size / img.height) * (0.6 + 0.4 * ik);
    g.save();
    g.globalAlpha = ik * fade;
    g.translate(b.x, iy);
    g.rotate(Math.sin(b.t * 2) * 0.06);
    g.scale(s, s);
    g.imageSmoothingEnabled = false;
    g.drawImage(img, -img.width * 0.5, -img.height * 0.5);
    g.restore();
  } else {
    g.fillStyle = css(Theme.coin, ik * fade);
    g.beginPath();
    g.arc(b.x, iy, size * 0.4, 0, Math.PI * 2);
    g.fill();
  }
}

function drawRays(g: Ctx, r: { x: number; y: number; t: number; max: number }): void {
  const k = expOut(clamp(r.t * 1.5, 0, 1));
  const fade = clamp((r.max - r.t) / 0.6, 0, 1);
  g.save();
  g.translate(r.x, r.y);
  g.rotate(r.t * 0.35);
  const n = 14;
  const len = 900 * k;
  g.fillStyle = css(Theme.coin, 0.16 * fade * k);
  for (let i = 1; i <= n; i++) {
    const a0 = (i / n) * Math.PI * 2;
    const a1 = a0 + (Math.PI / n) * 0.55;
    g.beginPath();
    g.moveTo(0, 0);
    g.lineTo(Math.cos(a0) * len, Math.sin(a0) * len);
    g.lineTo(Math.cos(a1) * len, Math.sin(a1) * len);
    g.closePath();
    g.fill();
  }
  g.restore();
}

function drawWord(g: Ctx, f: Font, w: Word): void {
  const k = expOut(clamp(w.t * 6, 0, 1));
  const fade = clamp((w.max - w.t) / 0.25, 0, 1);
  const sc = 1.8 - 0.8 * k;
  const tw = width(f, w.text);
  const th = f.height;
  g.save();
  g.translate(w.x, w.y);
  g.rotate(-0.08 + 0.16 * k);
  g.scale(sc, sc);
  g.fillStyle = `rgba(26,8,13,${0.9 * fade})`;
  print(g, f, w.text, -tw * 0.5 + 2, -th * 0.5 + 2);
  g.fillStyle = css(w.col, fade);
  print(g, f, w.text, -tw * 0.5, -th * 0.5);
  g.restore();
}
