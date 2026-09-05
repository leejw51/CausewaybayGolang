/**
 * The virtual canvas, ported from `love2d/src/layout.lua`.
 *
 * The game is authored against 1280x720, or 720x1280 turned on its side, and
 * every coordinate in the renderer is in those units. This module works out
 * how many of them fit in the window and what to multiply them by.
 *
 * The one rule worth keeping in mind: below a 2x fit the virtual canvas is
 * *grown* along the longer axis rather than letterboxed, up to half again the
 * design size. A landscape layout in a tall browser window gets a taller
 * playfield, not black bars — which is why `SCENE_H` and the panel heights in
 * the renderer are all computed from `vw`/`vh` rather than being constants.
 */
import { Theme } from "./theme";

/** How far past the design size the canvas may grow before it letterboxes. */
const MAX_STRETCH = 1.5;

/**
 * On a touch screen, how many CSS pixels a virtual pixel should be worth
 * before the type is scaled up to compensate. A phone fits the 720-wide
 * portrait design into 390 CSS pixels — every virtual pixel is half a real
 * one — and 16px Press Start 2P at that size is eight pixels tall.
 */
const TOUCH_READABLE = 0.8;
/** The most the type is boosted by; past this the panels stop fitting. */
const TOUCH_BOOST_MAX = 1.5;
/** The smallest thing a finger can be expected to hit, in CSS pixels. */
const TOUCH_TARGET = 40;

export type Orientation = "landscape" | "portrait";

export class Layout {
  mode: Orientation = "landscape";
  /** Virtual pixels across and down: what the renderer draws in. */
  vw = Theme.landW;
  vh = Theme.landH;
  /** Device pixels per virtual pixel. */
  scale = 1;
  /** CSS pixels per virtual pixel: how big things are to a finger or an eye. */
  cssScale = 1;
  /** Where the virtual canvas sits inside the window, in device pixels. */
  ox = 0;
  oy = 0;
  /** Device pixels across and down. */
  dw = Theme.landW;
  dh = Theme.landH;

  /**
   * Whether the player has chosen an orientation themselves.
   *
   * The desktop build picks one from the display at startup and then leaves it
   * alone, because a window does not spin round while you are looking at it. A
   * phone does. So until somebody presses F1 the layout follows the window,
   * and after that it is theirs.
   */
  private pinned = false;

  /**
   * @param touch whether this is a screen that is tapped rather than clicked.
   * A phone is held closer and hit with a finger, so type is boosted and
   * buttons get a floor under their height; a small desktop window gets
   * neither, because it can always be made bigger.
   */
  constructor(
    private readonly canvas: HTMLCanvasElement,
    readonly touch = false,
  ) {
    if (window.innerHeight > window.innerWidth) this.mode = "portrait";
  }

  /** Restore a saved orientation, which counts as the player having chosen. */
  pin(mode: Orientation): void {
    this.mode = mode;
    this.pinned = true;
  }

  private base(): [number, number] {
    return this.mode === "portrait"
      ? [Theme.portW, Theme.portH]
      : [Theme.landW, Theme.landH];
  }

  isPortrait(): boolean {
    return this.mode === "portrait";
  }

  toggleOrientation(): void {
    this.mode = this.mode === "landscape" ? "portrait" : "landscape";
    this.pinned = true;
    this.measure();
  }

  /**
   * Fonts are authored for the design size. When the virtual canvas grows,
   * type grows with it, so a 1600-wide window is not a 1280 layout with a lot
   * of empty space in the panels.
   */
  uiScale(): number {
    const [bw, bh] = this.base();
    return Math.max(1, Math.min(this.vw / bw, this.vh / bh)) * this.touchBoost();
  }

  /**
   * How much bigger than designed the type is on a touch screen, so that it
   * stays readable when the canvas is squeezed into a phone. 1 on anything
   * that is not touched, and on a tablet, where the fit is already close.
   */
  touchBoost(): number {
    if (!this.touch) return 1;
    return Math.min(TOUCH_BOOST_MAX, Math.max(1, TOUCH_READABLE / this.cssScale));
  }

  /**
   * The least tall a button may be, in virtual pixels, so a finger can land
   * on it. Zero where there are no fingers.
   */
  minTouchH(): number {
    return this.touch ? Math.ceil(TOUCH_TARGET / this.cssScale) : 0;
  }

  /**
   * Re-read the window and resize the backing store. Returns true when
   * anything moved, which is the renderer's cue to rebuild its fonts.
   */
  measure(): boolean {
    // Capped at 2: a phone at devicePixelRatio 3 would otherwise render nine
    // times the pixels for a difference nobody can see on pixel art.
    const dpr = Math.min(2, window.devicePixelRatio || 1);
    const cw = Math.max(1, this.canvas.clientWidth);
    const ch = Math.max(1, this.canvas.clientHeight);
    const ww = Math.max(1, Math.round(cw * dpr));
    const wh = Math.max(1, Math.round(ch * dpr));
    // A phone that was turned on its side, or a window dragged into a new
    // shape: follow it, unless the player has said which way they want it.
    if (!this.pinned) this.mode = wh > ww ? "portrait" : "landscape";
    const [bw, bh] = this.base();

    // The fit is worked out in CSS pixels, not device pixels: a Retina
    // display has twice the pixels but is not twice as big, and a layout that
    // counted them would draw everything at half size and then letterbox it.
    // The device scale is that fit with the pixel ratio put back.
    const fit = Math.min(cw / bw, ch / bh);
    const cssScale = fit >= 2 ? Math.floor(fit) : fit >= 1 ? 1 : Math.max(0.35, fit);
    const scale = cssScale * dpr;
    const vw = Math.min(Math.floor(ww / scale), Math.floor(bw * MAX_STRETCH));
    const vh = Math.min(Math.floor(wh / scale), Math.floor(bh * MAX_STRETCH));

    // The backing store is compared too, not just the last measurement: a
    // window that happens to be exactly the design size matches the defaults
    // on the first frame, and the canvas would stay at its own 300x150.
    const changed =
      scale !== this.scale ||
      vw !== this.vw ||
      vh !== this.vh ||
      ww !== this.dw ||
      wh !== this.dh ||
      this.canvas.width !== ww ||
      this.canvas.height !== wh;
    this.scale = scale;
    this.cssScale = cssScale;
    this.vw = vw;
    this.vh = vh;
    this.dw = ww;
    this.dh = wh;
    this.ox = Math.floor((ww - vw * scale) / 2);
    this.oy = Math.floor((wh - vh * scale) / 2);

    if (changed) {
      this.canvas.width = ww;
      this.canvas.height = wh;
    }
    return changed;
  }

  /** Put the context into virtual coordinates for a frame. */
  begin(g: CanvasRenderingContext2D): void {
    g.setTransform(1, 0, 0, 1, 0, 0);
    g.clearRect(0, 0, this.dw, this.dh);
    g.setTransform(this.scale, 0, 0, this.scale, this.ox, this.oy);
  }

  /** A pointer position in window coordinates, in virtual ones, or null when
   *  it landed on the letterbox rather than on the game. */
  /** The inverse: a virtual point, in window coordinates. */
  toClient(vx: number, vy: number): [number, number] {
    const rect = this.canvas.getBoundingClientRect();
    const dpr = Math.min(2, window.devicePixelRatio || 1);
    return [(vx * this.scale + this.ox) / dpr + rect.left, (vy * this.scale + this.oy) / dpr + rect.top];
  }

  toVirtual(clientX: number, clientY: number): [number, number] | null {
    const rect = this.canvas.getBoundingClientRect();
    const dpr = Math.min(2, window.devicePixelRatio || 1);
    const px = (clientX - rect.left) * dpr;
    const py = (clientY - rect.top) * dpr;
    const vx = (px - this.ox) / this.scale;
    const vy = (py - this.oy) / this.scale;
    if (vx < 0 || vy < 0 || vx >= this.vw || vy >= this.vh) return null;
    return [vx, vy];
  }
}
