/**
 * Everything on screen, from the drawing half of `love2d/src/game.lua`.
 *
 * The core decides what is true; this decides what it looks like. The split is
 * strict in one direction — nothing here changes the game — and loose in the
 * other: the animation that carries no meaning lives here rather than crossing
 * the wasm boundary sixty times a second. Alex walking between two dots on the
 * overworld, the screen shake after a wrong answer, the CLEAR stamp settling,
 * the confetti: the core asked for all of it once, in an event, and then
 * forgot about it.
 *
 * Layout is measured, never assumed. `syncMetrics` re-derives the top bar, the
 * scene band and the button sizes from the fonts every frame, because the
 * fonts change with the window and a Korean label is not the width of its
 * English original.
 */
import { clamp, expOut, lerp, smooth } from "../engine/ease";
import { Assets } from "../engine/assets";
import { Layout } from "../engine/layout";
import { ensureFonts, Font, font, printf, print, width, wrap } from "../engine/text";
import { css, RGBA, Theme, TRACK_COL, TRACK_HAZE, withAlpha } from "../engine/theme";
import {
  bar,
  btnBox,
  BTN_FRAME,
  clipped,
  Ctx,
  fill,
  inRect,
  neonPrint,
  panel,
  pixBtn,
  Rect,
  roundRect,
  shadowText,
  star,
  well,
} from "../engine/ui";
import { FX } from "./fx";
import { drawCharacter, drawItem, drawMascot, hop as hopArc } from "./sprites";
import { Strings } from "./strings";
import { drawViz } from "./viz";
import type { Anim, PopKind, View } from "./view";
import { drawBackground } from "./world";

/** A floating COMBO / +XP / PERFECT / LEVEL UP / BADGE line. */
interface Pop {
  text: string;
  kind: PopKind;
  t: number;
}

/** The big pops hang around long enough to be read twice. */
const BIG_POP: Record<string, boolean> = { perfect: true, level: true, badge: true };

function popLife(p: Pop): number {
  return BIG_POP[p.kind] ? 2.4 : 1.3;
}

/** Which sheet a street's portrait names. */
const FACE: Record<string, string> = {
  portrait_friends: "mei",
  portrait_clerk: "clerk",
  portrait_hero: "hero",
  portrait_officer: "cook",
};

/** The named boxes a click can land on. Rebuilt as the frame is drawn. */
export interface Hits {
  hudLang: Rect;
  hudMap: Rect;
  hudFull: Rect;
  hudOri: Rect;
  hudSound: Rect;
  /** Street pips along the top of a street. */
  stations: Rect[];
  /** Level dots on the overworld. */
  mapDots: Rect[];
  questTabs: Array<[Rect, number]>;
  trackBtns: Array<[Rect, string]>;
  sheetBtns: Array<[Rect, string]>;
  sheetRect: Rect | null;
  hint: Rect | null;
  ok: Rect | null;
  /** The ENTER mark at the end of the prompt: a tap there submits too. */
  enter: Rect | null;
  auto: Rect | null;
  prevStage: Rect | null;
  nextStage: Rect | null;
  share: Rect | null;
  mapBtn: Rect | null;
}

function emptyHits(): Hits {
  const z: Rect = [0, 0, 0, 0];
  return {
    hudLang: z,
    hudMap: z,
    hudFull: z,
    hudOri: z,
    hudSound: z,
    stations: [],
    mapDots: [],
    questTabs: [],
    trackBtns: [],
    sheetBtns: [],
    sheetRect: null,
    hint: null,
    ok: null,
    enter: null,
    auto: null,
    prevStage: null,
    nextStage: null,
    share: null,
    mapBtn: null,
  };
}

const COL = {
  gold: Theme.coin,
  neon: Theme.pink,
  cyan: Theme.cyan,
  cream: Theme.cream,
  admit: Theme.admit,
  paper: Theme.paper,
};

const SHEET_COPY: Array<[string, string]> = [
  ["q", "copy_q"],
  ["hint", "copy_hint"],
  ["answer", "copy_answer"],
  ["all", "copy_all"],
];
const SHEET_EXPORTS: Array<[string, string]> = [
  ["md", "exp_md"],
  ["csv", "exp_csv"],
  ["jsonl", "exp_jsonl"],
  ["txt", "exp_txt"],
  ["png", "exp_png"],
  ["allfmt", "exp_all"],
];

export class Renderer {
  readonly fx = new FX();
  hits = emptyHits();

  /** Seconds since boot, and the wipe-in that follows a state change. */
  t = 0;
  private intro = 0;
  private fade = 1;
  private shake = 0;
  private flash = 0;
  private flashGood = false;

  /** Seconds the current street has been open: what the scenes rise on. */
  private mapT = 0;
  private enterK = 0;
  private stamp = 0;
  private hop = 0;
  private hintK = 0;
  private sheetK = 0;
  private trackK = 1;

  /** The overworld: how far the panel has slid in, and where Alex is. */
  private mapK = 0;
  private mapHeroAt = 0;
  private mapHeroX: number | null = null;
  private mapHeroY = 0;
  private mapHeroFacing = 1;
  private mapWalking = false;

  private pops: Pop[] = [];
  private toast: string | null = null;
  private toastT = 0;

  /** What the last frame saw, so a change of street can reset its animations. */
  private lastStreet = "";
  private lastState = "";
  private lastTrack = "";

  /** Where the pointer is, in virtual pixels, for the hover lighting. */
  mouse: [number, number] | null = null;
  fullscreen = false;
  /**
   * Whether the page can go fullscreen at all. An iPhone cannot, and a FULL
   * button that does nothing is worse than none — so main.ts turns this off
   * and the HUD leaves the button out.
   */
  canFullscreen = true;
  sound = true;

  // Measured every frame in `syncMetrics`.
  private W = 1280;
  private H = 720;
  private PORT = false;
  private TOP = 70;
  /** The HUD button row: its top and height, for anything laid out beside it. */
  private HUD_Y = 0;
  private HUD_H = 36;
  private SCENE_H = 260;
  private TERM_Y = 330;

  constructor(
    private readonly layout: Layout,
    private readonly art: Assets,
  ) {}

  /** Bumped by main.ts when the core reports a screen shake or a flash. */
  addShake(n: number): void {
    this.shake = Math.max(this.shake, n);
  }

  addFlash(good: boolean, amount: number): void {
    this.flashGood = good;
    this.flash = Math.max(this.flash, amount);
  }

  addPop(text: string, kind: PopKind): void {
    this.pops.push({ text, kind, t: 0 });
  }

  clearPops(): void {
    this.pops = [];
  }

  setToast(text: string): void {
    this.toast = text;
    this.toastT = 3.5;
  }

  /** A right answer makes the hero jump. */
  bounce(): void {
    this.hop = 0.55;
  }

  /** The scene band, for turning an event's fractions into pixels. */
  sceneRect(): { x: number; y: number; w: number; h: number } {
    return { x: 0, y: this.TOP, w: this.W, h: this.SCENE_H };
  }

  screenRect(): { x: number; y: number; w: number; h: number } {
    return { x: 0, y: 0, w: this.W, h: this.H };
  }

  update(dt: number, v: View): void {
    this.t += dt;
    this.intro = Math.min(1, this.intro + dt * 0.55);
    this.shake = smooth(this.shake, 0, dt, 8);
    this.flash = Math.max(0, this.flash - dt * 3);
    this.fade = smooth(this.fade, 0, dt, 3.2);
    this.hop = Math.max(0, this.hop - dt);
    this.trackK = Math.min(1, this.trackK + dt * 2.4);
    this.sheetK = v.sheet ? Math.min(1, this.sheetK + dt * 3.5) : 0;
    this.hintK = smooth(this.hintK, v.hintLevel > 0 ? 1 : 0, dt, 10);
    this.toastT = Math.max(0, this.toastT - dt);
    this.fx.update(dt);

    // A change of street, state or track restarts the animations that belong
    // to it, the way entering one does in the Lua.
    const street = `${v.questTag}/${v.step}`;
    if (street !== this.lastStreet) {
      this.lastStreet = street;
      this.mapT = 0;
      this.enterK = 0;
      this.stamp = 0;
    }
    if (v.state !== this.lastState) {
      this.lastState = v.state;
      this.fade = v.state === "map" ? Math.min(this.fade, 0.35) : 1;
      if (v.state === "map") {
        this.mapK = 0;
        this.mapHeroAt = v.mapCursor;
        this.mapHeroX = null;
      }
    }
    if (v.track !== this.lastTrack) {
      this.lastTrack = v.track;
      this.trackK = 0;
    }

    this.mapT += dt;
    this.enterK = Math.min(1, this.mapT * 2.4);
    this.stamp = v.solved ? Math.min(1, this.stamp + dt * 1.4) : 0;

    this.pops = this.pops.filter((p) => (p.t += dt) <= popLife(p));

    if (v.state === "title" && Math.random() < dt * 10) {
      this.fx.titleSpark(this.W, this.H);
    }
    if (v.state === "map") this.updateMapHero(dt, v);
  }

  /** Alex walks the dotted path one node at a time toward the cursor. */
  private updateMapHero(dt: number, v: View): boolean {
    this.mapK = Math.min(1, this.mapK + dt * 3.2);
    const nodes = this.mapNodes(v);
    if (nodes.length === 0) return false;
    this.mapHeroAt = clamp(this.mapHeroAt, 0, nodes.length - 1);
    const at = nodes[this.mapHeroAt];
    if (this.mapHeroX === null) {
      this.mapHeroX = at[0];
      this.mapHeroY = at[1];
    }
    if (this.mapHeroAt === v.mapCursor) {
      this.mapHeroX = at[0];
      this.mapHeroY = at[1];
      this.mapWalking = false;
      return false;
    }
    const next = this.mapHeroAt + (v.mapCursor > this.mapHeroAt ? 1 : -1);
    const [tx, ty] = nodes[next];
    const dx = tx - this.mapHeroX;
    const dy = ty - this.mapHeroY;
    const dist = Math.sqrt(dx * dx + dy * dy);
    const step = (this.PORT ? 460 : 420) * dt;
    this.mapWalking = true;
    if (Math.abs(dx) > 1) this.mapHeroFacing = dx > 0 ? 1 : -1;
    if (dist <= step) {
      this.mapHeroX = tx;
      this.mapHeroY = ty;
      this.mapHeroAt = next;
      return true; // a footstep for the caller to play
    }
    this.mapHeroX += (dx / dist) * step;
    this.mapHeroY += (dy / dist) * step;
    return false;
  }

  // -------------------------------------------------------------- metrics

  private syncMetrics(v: View, S: Strings): void {
    this.W = this.layout.vw;
    this.H = this.layout.vh;
    this.PORT = this.layout.isPortrait();
    ensureFonts(this.layout.uiScale());
    const touchH = this.layout.minTouchH();

    // A phone turns in the hand, so PORT/LAND is not a choice to offer it;
    // and where there is no fullscreen API the FULL button has nothing to do.
    // Leaving them out is also what makes the row fit a 720-wide portrait
    // canvas once the type has been boosted for a small screen.
    const showOri = !this.layout.touch;
    const showFull = this.canFullscreen;
    const labels = [S.t("hud_map"), S.t("hud_back"), v.langName, "MUTE"];
    if (showFull) labels.push(S.t("hud_full"), S.t("hud_wind"));
    if (showOri) labels.push(S.t("hud_port"), S.t("hud_land"));
    const [btnW, btnH] = btnBox(
      font("button"),
      labels,
      this.layout.touch ? 0 : 112,
      this.layout.touch ? 24 : 32,
      Math.max(36, touchH),
    );
    this.TOP = Math.max(this.PORT ? 80 : 70, font("station").height + 52, btnH + 20);

    // On a touch screen the buttons are taller and the type is bigger, and a
    // phone's browser has already taken a strip off the top; the scene gives
    // way so the story, the code and the line with the blank in it all stay
    // on screen.
    const touch = this.layout.touch;
    const termShare = this.PORT ? (touch ? 0.6 : 0.52) : touch ? 0.62 : 0.55;
    let sceneH = Math.floor(this.H * (1 - termShare)) - this.TOP;
    const lo = Math.floor(this.H * (this.PORT ? (touch ? 0.26 : 0.32) : touch ? 0.2 : 0.38));
    const hi = Math.floor(this.H * (this.PORT ? 0.46 : 0.52));
    this.SCENE_H = Math.max(lo, Math.min(hi, sceneH));
    this.TERM_Y = this.TOP + this.SCENE_H;

    const y = Math.floor((this.TOP - btnH) * 0.5);
    this.HUD_Y = y;
    this.HUD_H = btnH;
    // Laid out from the right edge; a button that is left out takes no room
    // and gets an empty box, which nothing can hit.
    const none: Rect = [0, 0, 0, 0];
    let x = this.W - 10;
    const place = (show: boolean): Rect => {
      if (!show) return none;
      x -= btnW;
      const r: Rect = [x, y, btnW, btnH];
      x -= 10;
      return r;
    };
    this.hits.hudOri = place(showOri);
    this.hits.hudFull = place(showFull);
    this.hits.hudMap = place(true);
    this.hits.hudLang = place(true);
    this.hits.hudSound = place(true);
  }

  // ----------------------------------------------------------------- draw

  draw(g: Ctx, v: View, anim: Anim, S: Strings): void {
    // Every hit box is rebuilt as the frame is drawn; syncMetrics does the
    // HUD row first, because the station strip has to stop short of it.
    this.hits = emptyHits();
    this.syncMetrics(v, S);
    this.layout.begin(g);

    // The letterbox around the virtual canvas, and its gold edge.
    g.save();
    g.setTransform(1, 0, 0, 1, 0, 0);
    fill(g, Theme.void, 0, 0, this.layout.dw, this.layout.dh);
    g.restore();
    fill(g, Theme.sky, 0, 0, this.W, this.H);

    const sx = (Math.random() - 0.5) * this.shake;
    const sy = (Math.random() - 0.5) * this.shake * 0.4;
    g.save();
    g.translate(sx, sy);

    if (v.state === "title") this.drawTitle(g, v, S);
    else if (v.state === "map") this.drawMap(g, v, S);
    else if (v.state === "play") this.drawPlay(g, v, anim, S);
    else this.drawWin(g, v, S);

    this.fx.drawSparks(g, this.t);
    this.fx.draw(g, this.art, font("title"), font("ui"));
    g.restore();

    this.drawHud(g, v, S);
    if (v.state === "play" && v.sheet) this.drawSheet(g, v, S);

    if (this.flash > 0) {
      g.fillStyle = this.flashGood
        ? `rgba(38,140,71,${this.flash * 0.28})`
        : `rgba(191,31,51,${this.flash * 0.28})`;
      g.fillRect(0, 0, this.W, this.H);
    }
    if (this.fade > 0.01) {
      g.fillStyle = `rgba(0,0,0,${this.fade})`;
      g.fillRect(0, 0, this.W, this.H);
    }
    g.strokeStyle = css(Theme.coin, 0.55);
    g.lineWidth = 1;
    g.strokeRect(0.5, 0.5, this.W - 1, this.H - 1);
  }

  private hover(r: Rect | null): boolean {
    return !!this.mouse && inRect(this.mouse[0], this.mouse[1], r);
  }

  private btn(g: Ctx, r: Rect, label: string, lit = false, dim = false): void {
    if (r[2] <= 0 || r[3] <= 0) return;
    pixBtn(g, font("button"), r[0], r[1], r[2], r[3], label, {
      lit,
      dim,
      hover: !dim && this.hover(r),
    });
  }

  private drawHud(g: Ctx, v: View, S: Strings): void {
    const full = this.fullscreen ? S.t("hud_full") : S.t("hud_wind");
    const ori = this.PORT ? S.t("hud_port") : S.t("hud_land");
    const mapLabel = v.state === "map" ? S.t("hud_back") : S.t("hud_map");
    this.btn(g, this.hits.hudSound, this.sound ? "SND" : "MUTE", this.sound);
    this.btn(g, this.hits.hudLang, v.langName);
    this.btn(g, this.hits.hudMap, mapLabel, v.state === "map");
    this.btn(g, this.hits.hudFull, full);
    this.btn(g, this.hits.hudOri, ori);
  }

  // ---------------------------------------------------------------- title

  private drawTitle(g: Ctx, v: View, S: Strings): void {
    const k = expOut(this.intro);
    const cam = drawBackground(g, this.art, "title_bg", 0, 0, this.W, this.H, this.PORT, "title");
    const gy = cam.groundY;
    const ch = cam.charH;
    const gap = ch * 0.78;
    // The title at the size it was drawn for, unless the canvas is too narrow
    // for it in one piece — a phone with boosted type — when the stamp size
    // is the next one down that still looks like a sign.
    const title = "CAUSEWAYBAY GO";
    let titleF = font("title");
    if (width(titleF, title) > this.W - 24) titleF = font("stamp");
    const subF = font("subtitle");
    const uiF = font("ui");
    const smF = font("small");
    const tagline =
      v.track === "rust" ? "tagline_rust" : v.track === "python" ? "tagline_py" : "tagline";
    const tagLines = wrap(smF, S.t(tagline), this.W - 24).length;

    const ty = this.TOP + lerp(this.PORT ? 4 : 0, this.PORT ? 16 : 8, k);
    // A dark band, so the title reads over the neon signs behind it.
    g.fillStyle = `rgba(5,5,26,${0.62 * k})`;
    g.fillRect(0, ty - 14, this.W, titleF.height + subF.height + smF.height * tagLines + 40);
    neonPrint(g, titleF, title, ty, this.W, COL.neon, this.t);
    g.fillStyle = css(COL.gold, k);
    printf(g, subF, S.t("subtitle"), 0, ty + titleF.height + 6, this.W, "center");
    g.fillStyle = css(COL.cream, k * 0.95);
    printf(g, smF, S.t(tagline), 12, ty + titleF.height + subF.height + 12, this.W - 24, "center");

    const hx = lerp(-ch, this.W * 0.18, k);
    const walking = this.intro < 1;
    drawMascot(g, this.art, v.track, hx - gap * 0.55, gy, ch * 0.42, { t: this.t, walk: walking });
    drawCharacter(g, this.art, "hero", hx, gy, { t: this.t, walk: walking, h: ch });
    drawCharacter(g, this.art, "mei", hx + gap, gy, { t: this.t + 0.4, walk: walking, h: ch });
    drawCharacter(g, this.art, "cook", hx + gap * 1.9, gy, {
      t: this.t + 0.9,
      walk: walking,
      h: ch,
    });
    drawCharacter(g, this.art, "clerk", this.W * 0.78, gy, { t: this.t, facing: -1, h: ch });
    drawItem(g, this.art, "item_set", this.W * 0.88, gy - ch * 0.28, ch * 0.38, Math.sin(this.t) * 0.1);

    // The panel along the bottom: five lines, each of which may wrap on a
    // narrow canvas, so the panel is as tall as they turn out to be.
    const blink = 0.55 + 0.45 * (0.5 + 0.5 * Math.cos(this.t * 3.2));
    const line2 = v.continueAt
      ? `${v.continueAt.questTag}  ${S.tf("title_continue", v.continueAt.station, v.continueAt.cleared, v.continueAt.total)}`
      : S.t("title_fresh");
    const line3 = `${S.tf("track_line", v.trackLabel)}   ${S.tf("quest_tab", v.questNumber)}   ${v.questName}`;
    const lines: Array<[Font, string, RGBA, number]> = [
      [uiF, S.t("title_enter"), Theme.ink, blink * k],
      [smF, line2, Theme.brick, 0.95 * k],
      [smF, line3, v.track === "rust" ? Theme.brick : Theme.navy, 0.95 * k],
      [smF, S.tf("xp_short", v.stats.level, v.stats.xp, v.stats.badges), Theme.ink, 0.9 * k],
      [smF, S.t("title_help"), Theme.ink, 0.8 * k],
    ];
    const lineW = this.W - 24 - 24;
    const heights = lines.map(([f, text]) => wrap(f, text, lineW).length * f.height);
    const barH = 22 + heights.reduce((a, b) => a + b + 6, 0) + 8;
    panel(g, 12, this.H - barH - 8, this.W - 24, barH, Theme.panel);
    let ly = this.H - barH + 10;
    lines.forEach(([f, text, col, alpha], i) => {
      g.fillStyle = css(col, alpha);
      printf(g, f, text, 24, ly, lineW, "center");
      ly += heights[i] + 6;
    });
  }

  // ------------------------------------------------------------- overworld

  private mapHelpText(v: View, S: Strings): string {
    return S.tf("map_help", v.canResume ? S.t("esc_back") : S.t("esc_title"));
  }

  /** How tall the level-name box is. The key help may wrap, so it is measured. */
  private mapPanelH(v: View, S: Strings): number {
    const pad = this.PORT ? 10 : 24;
    const smF = font("small");
    const lines = wrap(smF, this.mapHelpText(v, S), this.W - pad * 2 - 36);
    return font("ui").height + smF.height * (2 + Math.max(1, lines.length)) + 44;
  }

  private trackBarH(): number {
    return Math.max(
      this.PORT ? 68 : 60,
      font("button").height + font("stationSm").height + BTN_FRAME + 18,
      this.layout.minTouchH() + 10,
    );
  }

  /** Level dots, in virtual coordinates: a zig-zag left to right, or bottom up. */
  private mapNodes(v: View): Array<[number, number]> {
    const n = v.stations.length;
    if (n === 0) return [];
    const panelH = this.mapPanelHCache ?? 200;
    const barH = this.trackBarH();
    const out: Array<[number, number]> = [];
    if (this.PORT) {
      const xs = [0.26, 0.7, 0.3, 0.72, 0.28, 0.7, 0.42];
      const y0 = this.TOP + 90 + barH;
      const y1 = this.H - panelH - 70;
      for (let i = 0; i < n; i++) {
        const f = i / Math.max(1, n - 1);
        out.push([this.W * (xs[i] ?? 0.5), lerp(y1, y0, f)]);
      }
    } else {
      const ys = [0.76, 0.4, 0.68, 0.3, 0.64, 0.36, 0.62];
      const y0 = this.TOP + 50 + barH;
      const y1 = this.H - panelH - 56;
      for (let i = 0; i < n; i++) {
        const f = i / Math.max(1, n - 1);
        out.push([lerp(this.W * 0.09, this.W * 0.91, f), lerp(y0, y1, ys[i] ?? 0.5)]);
      }
    }
    return out;
  }

  /** `mapNodes` is asked for during update, before the panel is measured. */
  private mapPanelHCache: number | null = null;

  private drawMap(g: Ctx, v: View, S: Strings): void {
    this.mapPanelHCache = this.mapPanelH(v, S);
    const k = expOut(Math.min(1, this.mapK));

    const img = this.art.picture("map_bg", this.PORT);
    if (img) {
      const sc = Math.max(this.W / img.width, this.H / img.height);
      g.imageSmoothingEnabled = true;
      g.drawImage(
        img,
        (this.W - img.width * sc) * 0.5,
        (this.H - img.height * sc) * 0.5,
        img.width * sc,
        img.height * sc,
      );
      // Haze, so the dots and labels pop: a blue night for Go, a rust sunset
      // for Rust, deep midnight for Python.
      fill(g, TRACK_HAZE[v.track] ?? TRACK_HAZE.go, 0, 0, this.W, this.H);
    } else {
      this.drawOverworldFallback(g);
    }

    // Clouds drifting behind everything.
    for (let i = 1; i <= 4; i++) {
      const cx = ((this.t * (14 + i * 5) + i * 337) % (this.W + 240)) - 120;
      const cy = this.TOP + 30 + ((i * 53) % 120);
      g.fillStyle = "rgba(255,255,255,0.85)";
      ellipse(g, cx, cy, 46, 16);
      ellipse(g, cx - 22, cy + 6, 26, 12);
      ellipse(g, cx + 26, cy + 6, 30, 13);
    }

    const nodes = this.mapNodes(v);
    const n = v.stations.length;
    const labelF = this.PORT ? font("stationSm") : font("station");

    // Quest tabs of the open track, with a star on a quest that is all CLEAR.
    const tabF = font("button");
    let tabW = 0;
    for (const q of v.questTabs) tabW = Math.max(tabW, width(tabF, q.station) + 24);
    const tabGap = 6;
    const tabRoom = this.hits.hudSound[0] - 12 - 16;
    const byName = v.questTabs.length * (tabW + tabGap) <= tabRoom;
    if (!byName) tabW = Math.max(56, width(tabF, "Q3") + 24);
    v.questTabs.forEach((q, i) => {
      const r: Rect = [12 + i * (tabW + tabGap), this.HUD_Y, tabW, this.HUD_H];
      this.hits.questTabs.push([r, q.index]);
      this.btn(g, r, byName ? q.station : q.tag, q.lit);
      if (q.cleared === q.total) {
        star(g, r[0] + r[2] - 6, r[1] + 4, 7 + Math.sin(this.t * 4 + i) * 1.5, Theme.coin);
      }
    });

    this.drawTrackBar(g, v, S);

    // The dotted path; the stretch after a cleared street lights up gold.
    for (let i = 0; i < n - 1; i++) {
      const a = nodes[i];
      const b = nodes[i + 1];
      const dx = b[0] - a[0];
      const dy = b[1] - a[1];
      const len = Math.sqrt(dx * dx + dy * dy);
      const steps = Math.max(2, Math.floor(len / 16));
      const lit = v.stations[i].cleared;
      for (let j = 1; j < steps; j++) {
        const f = j / steps;
        const px = a[0] + dx * f;
        const py = a[1] + dy * f;
        dot(g, px, py, 5, Theme.ink, 1);
        dot(g, px, py, 3.5, lit ? Theme.coin : Theme.panel, lit ? 1 : 0.85);
      }
    }

    // The level dots themselves.
    v.stations.forEach((st, i) => {
      const nd = nodes[i];
      const cleared = st.cleared;
      const here = v.canResume && i === v.step;

      // Landmarks beside a few of them.
      if (st.id === "set" || st.id === "queue") {
        drawItem(g, this.art, "item_set", nd[0] - 40, nd[1] - 34, 44, -0.15);
      } else if (st.id === "kitchen" || st.id === "times" || st.id === "flat") {
        drawItem(g, this.art, "item_hashbrown", nd[0] - 42, nd[1] - 36, 48, 0.1);
      } else if (st.id.startsWith("rs_") && (i === 0 || i === n - 1)) {
        drawMascot(g, this.art, "rust", nd[0] - 44, nd[1] - 20, 28, { t: this.t + i });
      } else if (st.id.startsWith("py_") && (i === 0 || i === n - 1)) {
        drawMascot(g, this.art, "python", nd[0] - 44, nd[1] - 20, 30, { t: this.t + i });
      }

      dot(g, nd[0], nd[1], 17, Theme.ink, 1);
      dot(g, nd[0], nd[1], 13, cleared ? Theme.admit : Theme.red, 1);
      dot(g, nd[0] - 4, nd[1] - 5, 4, [1, 1, 1, 1], 0.55);

      if (cleared) {
        // A check on the dot, a tilted green stamp above it, a gold star and
        // a ring of twinkles.
        g.strokeStyle = css(Theme.cream);
        g.lineWidth = 3;
        g.beginPath();
        g.moveTo(nd[0] - 6, nd[1]);
        g.lineTo(nd[0] - 2, nd[1] + 5);
        g.lineTo(nd[0] + 7, nd[1] - 6);
        g.stroke();
        g.lineWidth = 1;
        for (let s = 1; s <= 3; s++) {
          const a = this.t * 1.6 + s * ((Math.PI * 2) / 3) + i;
          const tw = 0.5 + 0.5 * Math.sin(this.t * 5 + s * 2 + i);
          dot(
            g,
            nd[0] + Math.cos(a) * 24,
            nd[1] + Math.sin(a) * 24,
            1.5 + 2 * tw,
            Theme.coin,
            0.35 + 0.65 * tw,
          );
        }
        const rw = width(labelF, S.t("cleared")) + 16;
        const rh = labelF.height + 4;
        // Clear of Alex's head when he is standing on this dot.
        const lift =
          this.mapHeroAt === i || v.mapCursor === i ? (this.PORT ? 74 : 66) : 26;
        const rx = nd[0] - rw * 0.5;
        const ry = nd[1] - lift - rh;
        g.save();
        g.translate(nd[0], ry + rh * 0.5);
        g.rotate(-0.1);
        g.translate(-nd[0], -(ry + rh * 0.5));
        g.fillStyle = css(Theme.ink);
        roundRect(g, rx - 2, ry - 2, rw + 4, rh + 4, 3);
        g.fill();
        g.fillStyle = css(Theme.admit);
        roundRect(g, rx, ry, rw, rh, 3);
        g.fill();
        g.strokeStyle = css(Theme.cream, 0.5);
        roundRect(g, rx + 2, ry + 2, rw - 4, rh - 4, 2);
        g.stroke();
        g.fillStyle = css(Theme.cream);
        printf(g, labelF, S.t("cleared"), rx, ry + 2, rw, "center");
        g.restore();
        star(g, rx - 6, ry + rh * 0.5, 9, Theme.coin);
      }

      if (here && !cleared) {
        g.strokeStyle = `rgba(255,255,255,${0.6 + 0.4 * Math.sin(this.t * 5)})`;
        g.beginPath();
        g.arc(nd[0], nd[1], 20, 0, Math.PI * 2);
        g.stroke();
      }

      const lw = 140;
      shadowText(
        g,
        labelF,
        `${i + 1} ${st.station}`,
        nd[0] - lw * 0.5,
        nd[1] + 22,
        lw,
        "center",
        i === v.mapCursor ? Theme.coin : cleared ? Theme.admit : Theme.cream,
      );
      this.hits.mapDots.push([nd[0] - 36, nd[1] - 40, 72, 84]);
    });

    // Alex on the path, with a bouncing arrow over the street he is on.
    if (this.mapHeroX !== null) {
      const hh = this.PORT ? 64 : 56;
      drawCharacter(g, this.art, "hero", this.mapHeroX, this.mapHeroY + 6, {
        t: this.t,
        facing: this.mapHeroFacing,
        walk: this.mapWalking,
        h: hh,
      });
      if (!this.mapWalking) {
        const ay = this.mapHeroY - hh - 22 + Math.sin(this.t * 6) * 5;
        tri(g, Theme.ink, this.mapHeroX - 12, ay - 14, this.mapHeroX + 12, ay - 14, this.mapHeroX, ay);
        tri(
          g,
          Theme.coin,
          this.mapHeroX - 8,
          ay - 12,
          this.mapHeroX + 8,
          ay - 12,
          this.mapHeroX,
          ay - 3,
        );
      }
    }

    // The level-name box along the bottom.
    const uiF = font("ui");
    const smF = font("small");
    const pad = this.PORT ? 10 : 24;
    const panelH = this.mapPanelHCache;
    const py = this.H - panelH - 8 + (1 - k) * 40;
    panel(g, pad, py, this.W - pad * 2, panelH, Theme.panel);
    const cur = v.stations[Math.min(v.mapCursor, n - 1)];
    g.fillStyle = css(Theme.ink);
    print(
      g,
      uiF,
      `${v.trackLabel}  ${v.questStation}  ${v.mapCursor + 1}  ${cur.station}`,
      pad + 18,
      py + 14,
    );
    let right = S.tf("clear_count", v.clearedCount, n);
    const tag = cur.cleared
      ? S.t("cleared")
      : v.canResume && v.mapCursor === v.step
        ? S.t("here")
        : "";
    if (tag) right = `${tag}    ${right}`;
    g.fillStyle = css(cur.cleared ? Theme.admit : Theme.brick);
    printf(g, uiF, right, pad, py + 14, this.W - pad * 2 - 18, "right");

    g.fillStyle = css(Theme.navy);
    print(g, smF, `${cur.name}  -  ${cur.title}`, pad + 18, py + 14 + uiF.height + 6);

    const xpText = `${S.tf("xp_line", v.stats.level, v.stats.into, v.stats.size)}   ${S.t("badges_head")} ${v.stats.badges}`;
    const xy = py + 14 + uiF.height + 6 + smF.height + 4;
    g.fillStyle = css(Theme.brick);
    print(g, smF, xpText, pad + 18, xy);
    const barX = pad + 18 + width(smF, xpText) + 16;
    const barW = Math.max(40, this.W - pad - 18 - barX);
    fill(g, Theme.ink, barX, xy + Math.floor(smF.height * 0.5) - 4, barW, 8, 0.5);
    fill(
      g,
      Theme.coin,
      barX + 1,
      xy + Math.floor(smF.height * 0.5) - 3,
      Math.floor((barW - 2) * Math.min(1, v.stats.into / Math.max(1, v.stats.size))),
      6,
    );
    g.fillStyle = css(Theme.ink, 0.85);
    printf(g, smF, this.mapHelpText(v, S), pad + 18, xy + smF.height + 4, this.W - pad * 2 - 36, "center");
  }

  /** The hand-drawn overworld, for a checkout with no `map_bg` in it. */
  private drawOverworldFallback(g: Ctx): void {
    fill(g, Theme.sky, 0, 0, this.W, this.H);
    for (let i = 0; i <= 6; i++) {
      const hx = (i * this.W) / 5 - this.W * 0.1 + Math.sin(i * 3.1) * 40;
      g.fillStyle = "rgb(41,158,77)";
      ellipse(g, hx, this.H * 0.55, this.W * 0.22, this.H * 0.2);
    }
    fill(g, Theme.grass, 0, this.H * 0.52, this.W, this.H * 0.48);
    g.fillStyle = "rgb(26,140,56)";
    for (let i = 0; i <= 8; i++) {
      ellipse(g, (i * this.W) / 7 + 40, this.H * 0.55 + (i % 3) * 30, 70, 26);
    }
    g.fillStyle = "rgb(46,92,219)";
    g.fillRect(0, this.H * 0.92, this.W, this.H * 0.08);
  }

  /** The GO / RUST / PYTHON switch, with each track's mascot on its button. */
  private drawTrackBar(g: Ctx, v: View, S: Strings): void {
    const barH = this.trackBarH();
    const bw = 150;
    const bh = barH - 10;
    const gap = this.PORT ? 16 : 28;
    const y = this.TOP + 6;
    const n = v.tracks.length;
    const x0 = Math.floor(this.W * 0.5 - (n * bw + (n - 1) * gap) * 0.5);
    const f = font("button");
    const sf = font("stationSm");

    v.tracks.forEach((tr, i) => {
      const x = x0 + i * (bw + gap);
      const col = TRACK_COL[tr.id] ?? Theme.cyan;
      const pop = 1 + (tr.lit ? 0.12 * (1 - expOut(this.trackK)) : 0);
      const r: Rect = [x, y, bw, bh];
      this.hits.trackBtns.push([r, tr.id]);

      g.save();
      g.translate(x + bw * 0.5, y + bh * 0.5);
      g.scale(pop, pop);
      g.translate(-(x + bw * 0.5), -(y + bh * 0.5));
      panel(g, x, y, bw, bh, tr.lit ? col : this.hover(r) ? Theme.coin : Theme.panel);
      const ty = y + 8 + 3;
      g.fillStyle = css(Theme.ink, tr.lit ? 1 : 0.75);
      printf(g, f, tr.label, x, ty, bw, "center");
      g.fillStyle = css(Theme.ink, tr.lit ? 0.9 : 0.6);
      printf(g, sf, S.tf("clear_count", tr.cleared, tr.total), x, ty + f.height + 6, bw, "center");
      if (tr.cleared === tr.total && tr.total > 0) star(g, x + bw - 12, y + 10, 8, Theme.coin);
      g.restore();

      if (tr.lit) {
        const px = x + bw * 0.5;
        tri(g, Theme.ink, px - 10, y + bh - 2, px + 10, y + bh - 2, px, y + bh + 8);
        tri(g, col, px - 6, y + bh - 2, px + 6, y + bh - 2, px, y + bh + 4);
      }
      drawMascot(g, this.art, tr.id, x + bw - 14, y + 10, tr.lit ? 40 : 32, {
        t: this.t,
        walk: tr.lit,
        phase: i,
      });
    });
  }

  // ----------------------------------------------------------------- play

  private drawPlay(g: Ctx, v: View, anim: Anim, S: Strings): void {
    this.drawStations(g, v);

    const cam = anim[3];
    g.save();
    g.beginPath();
    g.rect(0, this.TOP, this.W, this.SCENE_H);
    g.clip();
    g.translate(0, this.TOP);
    const world = drawBackground(
      g,
      this.art,
      v.map.bg,
      0,
      0,
      this.W,
      this.SCENE_H,
      this.PORT,
      "play",
    );

    g.save();
    g.translate(-cam, 0);
    drawViz({
      g,
      art: this.art,
      t: this.t,
      mapT: this.mapT,
      stage: v.stage,
      solved: v.solved,
      stamp: this.stamp,
      track: v.track,
      map: v.map,
    });
    this.drawWorld(g, v, anim, world.groundY, world.charH, cam);
    g.restore();

    const [shareW, shareH] = btnBox(
      font("button"),
      [S.t("share")],
      84,
      24,
      Math.max(30, this.layout.minTouchH()),
    );
    this.hits.share = [this.W - shareW - 10, this.TOP + 8, shareW, shareH];

    // The street's name plate, top-left of the scene, stopping short of SHARE.
    const labelF = font("station");
    const label = S.tf("map_label", v.questTag, v.step + 1, v.stations.length, v.map.title);
    const lw = Math.min(this.W - shareW - 32, width(labelF, label) + 32);
    const lh = labelF.height + 16;
    well(g, 10, 8, lw, lh, [0.08, 0.06, 0.16, 0.92]);
    g.fillStyle = css(COL.gold);
    clipped(g, 14, 8, lw - 8, lh, () => print(g, labelF, label, 22, 16));
    this.hits.mapBtn = [10, this.TOP + 8, lw, lh];

    if (v.streak >= 2 && !v.solved) {
      const sf = font("station");
      const s = S.tf("streak", v.streak);
      const sw = width(sf, s) + 24;
      const sh = sf.height + 12;
      const bob = Math.sin(this.t * 6) * 2;
      const sx = this.W - shareW - 18 - sw;
      well(g, sx, 8 + bob, sw, sh, [0.3, 0.05, 0.05, 0.92]);
      g.fillStyle = css(COL.gold);
      print(g, sf, s, sx + 12, 14 + bob);
    }

    this.drawPops(g);

    if (v.solved) {
      const pulse = 0.5 + 0.5 * Math.cos(this.t * 4);
      const uiF = font("ui");
      const text = v.allCleared
        ? S.t(v.questNumber === 1 ? "clear_stamp" : "clear_prize")
        : v.step + 1 >= v.stations.length
          ? S.t("clear_map")
          : S.t("clear_next");
      const tw = width(uiF, text) + 32;
      const th = uiF.height + 16;
      well(g, this.W - tw - 10, this.SCENE_H - th - 8, tw, th, [0.08, 0.06, 0.16, 0.92]);
      g.fillStyle = css(COL.admit, 0.7 + 0.3 * pulse);
      print(g, uiF, text, this.W - tw + 6, this.SCENE_H - th);
    }
    g.restore();

    this.btn(g, this.hits.share, S.t("share"), v.sheet);

    if (this.toast && this.toastT > 0) {
      const tf = font("small");
      const fade = Math.min(1, this.toastT / 0.4);
      const tw = Math.min(this.W - 40, width(tf, this.toast) + 28);
      const lines = wrap(tf, this.toast, tw - 28);
      const th = tf.height * Math.max(1, lines.length) + 12;
      const tx = Math.floor((this.W - tw) * 0.5);
      const tyy = this.TOP + this.SCENE_H - th - 10;
      well(g, tx, tyy, tw, th, [0.05, 0.22, 0.1, 0.94 * fade]);
      g.fillStyle = css(Theme.cream, fade);
      printf(g, tf, this.toast, tx + 14, tyy + 6, tw - 28, "center");
    }

    this.drawTerminal(g, v, S);
  }

  /** The street pips along the top: one per street, CLEAR ones in green. */
  private drawStations(g: Ctx, v: View): void {
    bar(g, 0, 0, this.W, this.TOP);
    let f = font("station");
    const n = v.stations.length;
    let x0 = 28;
    let x1 = this.hits.hudSound[0] - 16;
    const widest = (ff: Font) =>
      v.stations.reduce((m, s) => Math.max(m, width(ff, s.station)), 0);
    let maxW = widest(f);
    let span = (x1 - x0) / Math.max(1, n - 1);
    if (span < maxW + 8) {
      f = font("stationSm");
      maxW = widest(f);
    }
    let showNames = span >= maxW + 4;
    const labelH = showNames ? f.height : 0;
    const pipY = Math.max(6, Math.floor((this.TOP - (16 + labelH)) * 0.5));
    const labelY = pipY + 16;
    const boxW = Math.max(maxW, 48);
    x0 = Math.max(x0, Math.floor(boxW * 0.5) + 12);
    x1 = Math.min(x1, this.hits.hudSound[0] - Math.floor(boxW * 0.5) - 12);
    span = (x1 - x0) / Math.max(1, n - 1);
    if (showNames && span < maxW + 4) showNames = false;
    // Without room for every name, the current street's sits at the left edge
    // and the pips start after it. A phone with boosted type may not have room
    // for even that: the name drops a size, and then drops out.
    let nameF: Font | null = null;
    if (!showNames) {
      const room = x1 - x0 - (n - 1) * 20;
      for (const f2 of [font("station"), font("stationSm")]) {
        if (width(f2, v.map.station) + 24 <= room) {
          nameF = f2;
          break;
        }
      }
      if (nameF) x0 = Math.max(x0, 16 + width(nameF, v.map.station) + 24);
    }

    for (let i = 0; i < n; i++) {
      const x = lerp(x0, x1, i / Math.max(1, n - 1));
      const cleared = v.stations[i].cleared;
      if (i < n - 1) {
        const x2 = lerp(x0, x1, (i + 1) / Math.max(1, n - 1));
        fill(
          g,
          cleared ? Theme.coin : withAlpha(Theme.cream, 0.22),
          x + 8,
          pipY + 5,
          x2 - x - 16,
          4,
        );
      }
      const on = i === v.step;
      const r = on ? 8 : 6;
      const col: RGBA = cleared ? Theme.admit : on ? Theme.red : [1, 1, 1, 0.28];
      fill(g, col, x - r, pipY, r * 2, r * 2);
      const hitX = x - boxW * 0.5;
      this.hits.stations.push([hitX, 0, boxW, this.TOP]);
      if (showNames) {
        g.fillStyle = css(COL.cream, on ? 1 : 0.7);
        printf(g, f, v.stations[i].station, hitX, labelY, boxW, "center");
      }
    }
    if (nameF) {
      g.fillStyle = css(Theme.cream);
      print(g, nameF, v.map.station, 16, Math.floor((this.TOP - nameF.height) * 0.5));
    }
  }

  /** The people on the street, and the goal post at the end of a CLEAR one. */
  private drawWorld(
    g: Ctx,
    v: View,
    anim: Anim,
    gy: number,
    ch: number,
    cam: number,
  ): void {
    v.map.npcs.forEach((npc, i) => {
      if (npc.kind === "hero") return;
      drawCharacter(g, this.art, npc.kind, npc.x, gy, {
        t: this.t + i + 1,
        facing: npc.facing,
        h: ch,
      });
      if (Math.abs(anim[0] - npc.x) < ch * 1.15 && npc.line) {
        this.bubble(g, npc.x, gy - ch - 12, npc.line, cam);
      }
    });

    const bounce = this.hop > 0 ? hopArc(1 - this.hop / 0.55, ch * 0.12) : 0;
    drawCharacter(g, this.art, "hero", anim[0], gy, {
      t: this.t,
      facing: anim[1],
      walk: anim[2] > 0.5,
      bounce,
      h: ch,
    });

    if (v.solved) {
      const gx = v.map.width - 48;
      const a = 0.4 + 0.6 * ((Math.sin(this.t * 3) + 1) * 0.5);
      fill(g, Theme.admit, gx, gy - ch * 0.9, 10, ch * 0.9, a);
      star(g, gx + 5, gy - ch - 14, 16, Theme.coin);
    }
  }

  /** A speech bubble, kept inside the camera's view of the street. */
  private bubble(g: Ctx, x: number, y: number, text: string, cam: number): void {
    const f = font("bubble");
    const padX = 20;
    const padY = 16;
    const maxW = Math.min(640, Math.floor(this.W * 0.7));
    const lines = wrap(f, text, maxW - padX * 2);
    const textW = lines.reduce((m, l) => Math.max(m, width(f, l)), 0);
    const w = Math.min(maxW, textW + padX * 2);
    const h = lines.length * f.height + padY * 2;
    const bx = Math.max(cam + 8, Math.min(cam + this.W - w - 8, x - w * 0.5));
    const by = Math.max(44, y - h);
    panel(g, bx, by, w, h, Theme.cream);
    g.fillStyle = css(Theme.ink);
    printf(g, f, text, bx + padX, by + padY - 2, w - padX * 2, "center");
  }

  /**
   * COMBO / +XP / PERFECT / LEVEL UP / BADGE: slam in, hang, drift up. The big
   * ones stack downward so a PERFECT and a badge can both be read, and they
   * move out of the middle when a CLEAR banner owns it.
   */
  private drawPops(g: Ctx): void {
    let bigAt = 0;
    let smallAt = 0;
    const banner = this.fx.bannerCount() > 0;
    for (const p of this.pops) {
      const big = BIG_POP[p.kind] === true;
      const life = popLife(p);
      const k = expOut(Math.min(1, p.t * (big ? 3 : 5)));
      const fade = clamp((life - p.t) / 0.35, 0, 1);
      const f = big ? font("title") : font("ui");
      const tw = width(f, p.text);
      const sc = big ? 1.3 - 0.3 * k : 1.5 - 0.5 * k;
      const th = f.height;
      let y: number;
      if (big) {
        y = this.SCENE_H * (banner ? 0.84 : 0.3) + bigAt * (th + 22) - p.t * 18;
        bigAt++;
      } else {
        y = this.SCENE_H * (banner ? 0.06 : 0.14) + smallAt * (th + 16) - p.t * 18;
        smallAt++;
      }
      const col =
        p.kind === "perfect" || p.kind === "level"
          ? COL.gold
          : p.kind === "badge"
            ? COL.cyan
            : p.kind === "xp"
              ? COL.admit
              : COL.neon;

      g.save();
      g.translate(this.W * 0.5, y);
      g.rotate(big ? -0.06 : 0.04);
      g.scale(sc, sc);
      g.fillStyle = `rgba(13,5,26,${0.82 * fade})`;
      roundRect(g, -tw * 0.5 - 16, -8, tw + 32, th + 16, 8);
      g.fill();
      g.strokeStyle = css(col, 0.9 * fade);
      g.stroke();
      g.fillStyle = `rgba(13,5,26,${0.85 * fade})`;
      print(g, f, p.text, -tw * 0.5 + 3, 3);
      if (p.kind === "perfect" || p.kind === "level") {
        const pulse = 0.5 + 0.5 * Math.sin(p.t * 14);
        g.fillStyle = `rgba(255,${Math.round((0.85 + 0.15 * pulse) * 255)},64,${fade})`;
      } else {
        g.fillStyle = css(col, fade);
      }
      print(g, f, p.text, -tw * 0.5, 0);
      g.restore();
    }
  }

  // ------------------------------------------------------------- terminal

  /** Story and hint on the left, code on the right, prompt and buttons below. */
  private drawTerminal(g: Ctx, v: View, S: Strings): void {
    const y = this.TERM_Y;
    const slide = (1 - expOut(this.enterK)) * 28;
    g.save();
    g.translate(0, slide);

    fill(g, Theme.wood, 0, y, this.W, this.H - y);
    fill(g, Theme.coin, 0, y, this.W, 4);

    const storyF = font("small");
    let codeF = font("code");
    const helpF = font("help");
    const nameF = font("small");
    const uiF = font("ui");
    const btnFont = font("button");

    const touchH = this.layout.minTouchH();
    let [btnW, btnH] = btnBox(
      btnFont,
      [
        S.t("hint"),
        S.t("answer"),
        S.t("hide"),
        S.t("ok"),
        S.t("next"),
        S.t("auto"),
        S.t("auto_on"),
      ],
      110,
      28,
      Math.max(36, touchH),
    );
    let [stepW] = btnBox(btnFont, [S.t("step_prev"), S.t("step_next")], btnW, 24);
    const pad = this.PORT ? 8 : 10;
    // One row holds all five buttons on a desktop. On a phone, with the type
    // boosted, it does not: HINT / OK / AUTO take a row of their own and
    // PREV / NEXT the one under it, each stretched across the width, which
    // also makes them the size a thumb wants.
    const oneRow = pad * 2 + btnW * 3 + 20 + stepW * 2 + 10 <= this.W;
    if (!oneRow) {
      btnW = Math.floor((this.W - pad * 2 - 20) / 3);
      stepW = Math.floor((this.W - pad * 2 - 10) / 2);
    }
    const helpH = oneRow ? Math.max(helpF.height + 12, btnH + 8) : btnH * 2 + 14;
    const promptH = Math.max(font("code").height + 20, touchH + 8);

    const face = FACE[v.map.portrait] ?? "hero";
    const question = S.t("q_prefix") + v.stageData.question;

    const promptY = this.H - helpH - promptH - 4;
    const qF = font("small");
    const qW = this.W - pad * 2 - 28;
    const qLines = wrap(qF, question, qW);
    const qBarH = qLines.length * qF.height + 14;
    const qY = promptY - qBarH - 4;
    const bodyY = y + 8;
    const bodyH = qY - bodyY - 6;

    const hintOn = v.hintLevel > 0;
    const hintText =
      v.hintLevel >= 2 ? `${S.t("answer")}  ${v.stageData.answer}` : S.t("hint");
    const hintWhy = v.stageData.hint;
    let hintH = 0;
    if (hintOn) {
      const guessW = this.PORT ? this.W - pad * 2 - 24 : Math.floor(this.W * 0.42) - 32;
      const hlines = wrap(nameF, hintWhy, Math.max(80, guessW));
      hintH = uiF.height + 6 + hlines.length * nameF.height + 18;
    }

    let storyX: number;
    let storyY: number;
    let storyW: number;
    let storyBoxH: number;
    let codeX: number;
    let codeY: number;
    let codeW: number;
    let codeBoxH: number;
    let faceX: number;
    let faceY: number;
    let faceH: number;
    let nameW: number;

    if (this.PORT) {
      storyX = pad;
      storyY = bodyY;
      storyW = this.W - pad * 2;
      const textWGuess = storyW - 114;
      const lines = wrap(storyF, v.map.story, textWGuess);
      const msgLines = v.msg ? wrap(storyF, v.msg, textWGuess).length : 0;
      const need = 20 + nameF.height + 8 + (lines.length + msgLines) * storyF.height + 12;
      faceH = Math.min(88, Math.floor(bodyH * 0.2));
      // The story gets what it needs, up to what the code block can spare:
      // a three-line snippet on a phone leaves most of the body for the story,
      // and a long one takes it back.
      const codeNeed =
        12 +
        uiF.height +
        v.stageData.code.reduce(
          (h, l) =>
            h + Math.max(1, wrap(codeF, l.text, storyW - 28).length) * (codeF.height + 2),
          0,
        ) +
        24;
      const storyRoom = Math.max(Math.floor(bodyH * 0.45), bodyH - hintH - codeNeed - 12);
      storyBoxH = Math.max(faceH + 16, Math.min(storyRoom, need));
      const hintY = storyY + storyBoxH + 4;
      codeX = pad;
      codeY = hintY + hintH + (hintH > 0 ? 4 : 0);
      codeW = this.W - pad * 2;
      codeBoxH = Math.max(80, promptY - codeY - 6);
      faceX = storyX + 48;
      faceY = storyY + faceH - 6;
      nameW = 96;
    } else {
      storyX = pad;
      storyY = bodyY;
      storyW = Math.floor(this.W * 0.42);
      storyBoxH = bodyH;
      codeX = storyX + storyW + 8;
      codeY = bodyY;
      codeW = this.W - codeX - pad;
      codeBoxH = bodyH;
      faceH = Math.min(120, storyBoxH - 40);
      faceX = storyX + 56;
      faceY = storyY + faceH - 4;
      nameW = 108;
    }

    panel(g, storyX, storyY, storyW, storyBoxH, Theme.panel);
    drawCharacter(g, this.art, face, faceX, faceY, { t: this.t, h: faceH });
    g.fillStyle = css(Theme.brick);
    const textX = storyX + (this.PORT ? 100 : 118);
    const textW = Math.max(40, storyX + storyW - textX - 14);
    const nameY = this.PORT ? storyY + 10 : storyY + faceH + 2;
    printf(
      g,
      nameF,
      v.map.speaker,
      this.PORT ? textX : storyX + 6,
      nameY,
      this.PORT ? textW : nameW,
      this.PORT ? "left" : "center",
    );
    const textY = this.PORT ? nameY + nameF.height + 4 : storyY + 14;
    let innerH = storyY + storyBoxH - textY - 10 - (this.PORT ? 0 : hintH);
    // Clip to whole lines, so nothing is cut in half.
    innerH = Math.max(storyF.height, Math.floor(innerH / storyF.height) * storyF.height);
    clipped(g, textX, textY, textW, Math.max(8, innerH), () => {
      // The feedback first — it is what just happened — then the street's story.
      let usedH = 0;
      if (v.msg) {
        g.fillStyle = css(
          v.msgKind === "ok" ? Theme.admit : v.msgKind === "bad" ? Theme.red : Theme.ink,
        );
        const n = printf(g, storyF, v.msg, textX, textY, textW, "left");
        usedH = n * storyF.height + 8;
      }
      g.fillStyle = css(Theme.ink, v.msg ? 0.75 : 1);
      printf(g, storyF, v.map.story, textX, textY + usedH, textW, "left");
    });

    if (hintOn) {
      const hk = expOut(this.hintK);
      const hx = this.PORT ? pad : storyX + 8;
      const hy = this.PORT ? storyY + storyBoxH + 4 : storyY + storyBoxH - hintH - 8;
      const hw = this.PORT ? this.W - pad * 2 : storyW - 16;
      g.save();
      g.translate((1 - hk) * 24, 0);
      panel(g, hx, hy, hw, hintH, Theme.coin);
      clipped(g, hx + 8, hy + 4, hw - 16, hintH - 8, () => {
        g.fillStyle = css(Theme.ink);
        print(g, uiF, hintText, hx + 14, hy + 10);
        g.fillStyle = css(Theme.ink, 0.9);
        printf(g, nameF, hintWhy, hx + 14, hy + 10 + uiF.height + 6, hw - 28, "left");
      });
      g.restore();
    }

    // The code block, with the blank pulsing gold until it is answered.
    well(g, codeX, codeY, codeW, codeBoxH);
    g.fillStyle = css(Theme.coin);
    let head = v.stageData.topic || "CODE";
    if (v.stageCount > 1) head = `${head}  ${Math.min(v.stage + 1, v.stageCount)}/${v.stageCount}`;
    print(g, uiF, head, codeX + 14, codeY + 8);

    const wrapW = codeW - 28;
    let cy = codeY + 12 + uiF.height;
    const avail = codeY + codeBoxH - cy - 8;
    const needed = (f: Font) =>
      v.stageData.code.reduce(
        (h, l) => h + Math.max(1, wrap(f, l.text, wrapW).length) * (f.height + 2),
        0,
      );
    // Translated comments can be wide: drop to the small code font rather than
    // let the block run out of the well.
    if (needed(codeF) > avail) codeF = font("codeSm");
    const lh = codeF.height + 2;
    const commentCol: RGBA = [0.5, 0.82, 0.42, 1];

    clipped(g, codeX + 8, cy, codeW - 16, Math.max(8, avail), () => {
      for (const cl of v.stageData.code) {
        let codeCol: RGBA;
        if (cl.blank) {
          if (v.solved) codeCol = Theme.admit;
          else {
            const pulse = 0.65 + 0.35 * (0.5 + 0.5 * Math.cos(this.t * 6));
            codeCol = [Theme.coin[0], Theme.coin[1], Theme.coin[2], pulse];
          }
        } else {
          codeCol = [0.92, 0.96, 0.78, 1];
        }
        const wrapped = wrap(codeF, cl.text, wrapW);
        if (/^\s*(#|\/\/)/.test(cl.text)) {
          g.fillStyle = css(commentCol);
          printf(g, codeF, cl.text, codeX + 14, cy, wrapW, "left");
        } else {
          const m = /^(.*\S)(\s+(?:#|\/\/).*)$/.exec(cl.text);
          if (m && wrapped.length === 1) {
            g.fillStyle = css(codeCol);
            print(g, codeF, m[1], codeX + 14, cy);
            g.fillStyle = css(commentCol);
            print(g, codeF, m[2], codeX + 14 + width(codeF, m[1]), cy);
          } else {
            g.fillStyle = css(codeCol);
            printf(g, codeF, cl.text, codeX + 14, cy, wrapW, "left");
          }
        }
        cy += Math.max(1, wrapped.length) * lh;
        if (cy > codeY + codeBoxH - 8) break;
      }
    });

    // The question bar, right above the prompt.
    well(g, pad, qY, this.W - pad * 2, qBarH, [0.1, 0.08, 0.2, 1]);
    g.fillStyle = css(v.solved ? Theme.admit : Theme.coin);
    printf(g, qF, question, pad + 14, qY + 7, qW, "left");

    // The prompt.
    well(g, pad, promptY, this.W - pad * 2, promptH, [0.08, 0.06, 0.14, 1]);
    const codeHgt = font("code").height;
    const py = promptY + Math.floor((promptH - codeHgt) * 0.5);
    g.fillStyle = css(Theme.coin);
    print(g, font("code"), ">", pad + 14, py);
    const caret = Math.sin(this.t * 8) > 0 ? "_" : " ";
    let typed: string;
    if (v.solved) {
      g.fillStyle = css(Theme.admit);
      typed = S.t("clear_prompt");
    } else if (v.input === "") {
      g.fillStyle = css(Theme.cream, 0.55);
      typed = S.t("type_answer") + caret;
    } else {
      g.fillStyle = css(Theme.cream);
      typed = v.input + caret;
    }
    // ENTER at the end of the prompt is a button, not a reminder: on a phone
    // the soft keyboard's return key is easy to miss, and a tap here submits.
    const enterW = width(btnFont, "ENTER") + 28;
    clipped(g, pad + 42, promptY, this.W - pad * 2 - 42 - enterW - 16, promptH, () => {
      print(g, font("code"), typed, pad + 42, py);
    });
    if (!v.solved) {
      this.hits.enter = [this.W - pad - 6 - enterW, promptY + 4, enterW, promptH - 8];
      this.btn(g, this.hits.enter, "ENTER", v.input !== "");
    }

    // The buttons.
    const btnY = this.H - helpH + (oneRow ? Math.floor((helpH - btnH) * 0.5) : 4);
    const stepY = oneRow ? btnY : btnY + btnH + 6;
    this.hits.hint = [pad, btnY, btnW, btnH];
    this.hits.ok = [pad + btnW + 10, btnY, btnW, btnH];
    this.hits.auto = [pad + (btnW + 10) * 2, btnY, btnW, btnH];
    this.hits.nextStage = [this.W - pad - stepW, stepY, stepW, btnH];
    this.hits.prevStage = [this.W - pad - stepW * 2 - 10, stepY, stepW, btnH];

    const hintLabel = [S.t("hint"), S.t("answer"), S.t("hide")][v.hintLevel] ?? S.t("hint");
    this.btn(g, this.hits.hint, hintLabel, hintOn);
    this.btn(g, this.hits.ok, v.solved ? S.t("next") : S.t("ok"), v.solved);
    this.btn(g, this.hits.auto, S.t(v.auto ? "auto_on" : "auto"), v.auto);
    this.btn(g, this.hits.prevStage, S.t("step_prev"), false, v.stage === 0);
    this.btn(g, this.hits.nextStage, S.t("step_next"), false, v.stage + 1 >= v.stageCount);

    g.fillStyle = css(Theme.cream);
    const helpX = pad + btnW * 3 + 34;
    const help = v.solved
      ? S.t("help_walk")
      : v.hintLevel === 1
        ? S.t("help_answer")
        : S.t("help_play");
    // The keyboard reminder is the first thing to go when the row is tight.
    if (oneRow && width(helpF, help) <= this.hits.prevStage[0] - 12 - helpX) {
      print(g, helpF, help, helpX, this.H - helpH + 4);
    }
    g.restore();
  }

  // ------------------------------------------------------------------ win

  private drawWin(g: Ctx, v: View, S: Strings): void {
    const k = expOut(Math.min(1, this.mapT * 0.7));
    const smF = font("small");
    const uiF = font("ui");
    const subF = font("subtitle");
    const pad = this.PORT ? 12 : 24;
    const innerW = this.W - pad * 2 - 28;

    let lines = 0;
    for (const st of v.stations) lines += Math.max(1, wrap(smF, st.lesson, innerW - 140).length);
    const recapH = uiF.height + 16 + lines * smF.height + v.stations.length * 4 + smF.height + 24;
    const recapY = this.H - recapH - 8;
    const sceneH = recapY - 4;

    const cam = drawBackground(g, this.art, v.win.bg, 0, 0, this.W, sceneH, this.PORT, "win");
    const gy = cam.groundY;
    const ch = Math.min(cam.charH, sceneH * 0.5);
    const gap = ch * 0.72;

    const subY = this.PORT ? 118 : 96;
    g.fillStyle = `rgba(5,5,26,${0.55 * k})`;
    g.fillRect(0, subY - 6, this.W, subF.height + 12);
    g.fillStyle = css(COL.cream, k);
    printf(g, subF, S.t(v.win.title), 0, subY, this.W, "center");

    const bounce = (phase: number) => Math.abs(Math.sin(this.t * 4 + phase)) * 9 * k;
    drawCharacter(g, this.art, "hero", this.W * 0.22, gy, { t: this.t, bounce: bounce(0), h: ch });
    drawCharacter(g, this.art, "mei", this.W * 0.22 + gap, gy, {
      t: this.t + 0.3,
      bounce: bounce(1),
      h: ch,
    });
    drawCharacter(g, this.art, "cook", this.W * 0.22 + gap * 1.9, gy, {
      t: this.t + 0.7,
      bounce: bounce(2),
      h: ch,
    });
    drawCharacter(g, this.art, "clerk", this.W * 0.78, gy, { t: this.t, facing: -1, h: ch });
    drawItem(g, this.art, "item_set", this.W * 0.9, gy - ch * 0.28, ch * 0.4, Math.sin(this.t * 2) * 0.08);

    // The stamp slams onto the scene last, sized to fit it.
    const ss = Math.min(2.2, (sceneH * 0.8) / 96);
    g.save();
    g.translate(this.W * 0.5, Math.floor(sceneH * 0.56));
    g.rotate(-0.08);
    g.scale(k, k);
    drawItem(g, this.art, "stamp_served", 0, 0, ss, -0.1);
    const stampF = font("stamp");
    g.fillStyle = `rgba(5,26,10,${0.8 * k})`;
    printf(g, stampF, v.win.stamp, -78, -stampF.height * 0.5 + 2, 160, "center");
    g.fillStyle = css(Theme.coin, k);
    printf(g, stampF, v.win.stamp, -80, -stampF.height * 0.5, 160, "center");
    g.restore();

    panel(g, pad, recapY, this.W - pad * 2, recapH, Theme.panel);
    g.fillStyle = css(Theme.ink, k);
    print(g, uiF, S.t(v.win.head), pad + 14, recapY + 12);
    g.fillStyle = css(Theme.brick, k);
    printf(
      g,
      smF,
      S.tf("xp_short", v.stats.level, v.stats.xp, v.stats.badges),
      pad,
      recapY + 12,
      this.W - pad * 2 - 14,
      "right",
    );

    let ly = recapY + 12 + uiF.height + 10;
    for (const st of v.stations) {
      g.fillStyle = css(Theme.brick, k);
      print(g, smF, st.station, pad + 14, ly);
      g.fillStyle = css(Theme.ink, k);
      const n = printf(g, smF, st.lesson, pad + 140, ly, innerW - 140, "left");
      ly += Math.max(1, n) * smF.height + 4;
    }
    const blink = 0.55 + 0.45 * (0.5 + 0.5 * Math.cos(this.t * 3));
    g.fillStyle = css(Theme.ink, blink * k);
    printf(g, smF, S.t("win_help"), pad, recapY + recapH - smF.height - 10, this.W - pad * 2, "center");
  }

  // ---------------------------------------------------------------- share

  /**
   * The SHARE sheet: COPY the blank on screen to the clipboard on the left,
   * EXPORT the street, the quest or the whole track on the right.
   */
  private drawSheet(g: Ctx, v: View, S: Strings): void {
    const k = expOut(this.sheetK);
    g.fillStyle = `rgba(0,0,0,${0.62 * k})`;
    g.fillRect(0, 0, this.W, this.H);

    const uiF = font("ui");
    const smF = font("small");
    const labels = [
      ...SHEET_COPY.map(([, key]) => S.t(key)),
      ...SHEET_EXPORTS.map(([, key]) => S.t(key)),
      S.t("scope_street"),
      S.t("scope_quest"),
      S.t("scope_track"),
    ];
    // Eight rows have to fit a phone on its side, so the touch floor is
    // relaxed here: these are wide buttons, and a wide target forgives a
    // short one.
    const [btnW, btnH] = btnBox(
      font("button"),
      labels,
      200,
      28,
      Math.max(36, Math.floor(this.layout.minTouchH() * 0.75)),
    );
    const gap = 6;
    const colW = btnW;
    const pad = 22;
    const pw = Math.min(this.W - 24, colW * 2 + pad * 3);
    const rows = SHEET_EXPORTS.length + 1;
    let ph =
      14 + uiF.height + 10 + smF.height + 8 + rows * (btnH + gap) + 10 + smF.height * 2 + 18;
    if (ph > this.H - 20) ph = this.H - 20;
    const px = Math.floor((this.W - pw) * 0.5);
    const py = Math.floor((this.H - ph) * 0.5) + (1 - k) * 30;
    this.hits.sheetRect = [px, py, pw, ph];

    panel(g, px, py, pw, ph, Theme.panel);
    g.fillStyle = css(Theme.ink);
    printf(g, uiF, S.t("share_title"), px, py + 14, pw, "center");

    const y0 = py + 14 + uiF.height + 10;
    const lx = px + pad;
    const rx = px + pad * 2 + colW;
    g.fillStyle = css(Theme.brick);
    printf(g, smF, S.t("share_copy_head"), lx, y0, colW, "left");
    printf(g, smF, S.t("share_export_head"), rx, y0, colW, "left");

    const y = y0 + smF.height + 8;
    SHEET_COPY.forEach(([id, key], i) => {
      const r: Rect = [lx, y + i * (btnH + gap), colW, btnH];
      this.btn(g, r, S.t(key));
      this.hits.sheetBtns.push([r, id]);
    });
    drawMascot(
      g,
      this.art,
      v.track,
      lx + colW * 0.5,
      y + SHEET_COPY.length * (btnH + gap) + 86,
      78,
      { t: this.t, walk: true },
    );

    const scopeKey = `scope_${v.shareScope}`;
    const scopeRect: Rect = [rx, y, colW, btnH];
    this.btn(g, scopeRect, S.t(scopeKey), true);
    this.hits.sheetBtns.push([scopeRect, "scope"]);
    SHEET_EXPORTS.forEach(([id, key], i) => {
      const r: Rect = [rx, y + (i + 1) * (btnH + gap), colW, btnH];
      this.btn(g, r, S.t(key));
      this.hits.sheetBtns.push([r, id]);
    });

    const hy = py + ph - 14 - smF.height * 2;
    g.fillStyle = css(Theme.ink, 0.8);
    printf(g, smF, S.t("share_help"), px + 12, hy, pw - 24, "center");
    if (this.toast && this.toastT > 0) {
      g.fillStyle = css(Theme.admit);
      printf(g, smF, this.toast, px + 12, hy + smF.height, pw - 24, "center");
    }
  }
}

function ellipse(g: Ctx, x: number, y: number, rx: number, ry: number): void {
  g.beginPath();
  g.ellipse(x, y, rx, ry, 0, 0, Math.PI * 2);
  g.fill();
}

function dot(g: Ctx, x: number, y: number, r: number, col: RGBA, a: number): void {
  g.fillStyle = css(col, a);
  g.beginPath();
  g.arc(x, y, r, 0, Math.PI * 2);
  g.fill();
}

function tri(
  g: Ctx,
  col: RGBA,
  x1: number,
  y1: number,
  x2: number,
  y2: number,
  x3: number,
  y3: number,
): void {
  g.fillStyle = css(col);
  g.beginPath();
  g.moveTo(x1, y1);
  g.lineTo(x2, y2);
  g.lineTo(x3, y3);
  g.closePath();
  g.fill();
}
