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

export type Orientation = "landscape" | "portrait";

export class Layout {
  mode: Orientation = "landscape";
  /** Virtual pixels across and down: what the renderer draws in. */
  vw = Theme.landW;
  vh = Theme.landH;
  /** Device pixels per virtual pixel. */
  scale = 1;
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

  constructor(private readonly canvas: HTMLCanvasElement) {
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
    return Math.max(1, Math.min(this.vw / bw, this.vh / bh));
  }

  /**
   * Re-read the window and resize the backing store. Returns true when
   * anything moved, which is the renderer's cue to rebuild its fonts.
   */
  measure(): boolean {
    // Capped at 2: a phone at devicePixelRatio 3 would otherwise render nine
    // times the pixels for a difference nobody can see on pixel art.
    const dpr = Math.min(2, window.devicePixelRatio || 1);
    const ww = Math.max(1, Math.round(this.canvas.clientWidth * dpr));
    const wh = Math.max(1, Math.round(this.canvas.clientHeight * dpr));
    // A phone that was turned on its side, or a window dragged into a new
    // shape: follow it, unless the player has said which way they want it.
    if (!this.pinned) this.mode = wh > ww ? "portrait" : "landscape";
    const [bw, bh] = this.base();

    const fit = Math.min(ww / bw, wh / bh);
    const scale = fit >= 2 ? Math.floor(fit) : fit >= 1 ? 1 : Math.max(0.35, fit);
    const vw = Math.min(Math.floor(ww / scale), Math.floor(bw * MAX_STRETCH));
    const vh = Math.min(Math.floor(wh / scale), Math.floor(bh * MAX_STRETCH));

    const changed =
      scale !== this.scale || vw !== this.vw || vh !== this.vh || ww !== this.dw || wh !== this.dh;
    this.scale = scale;
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
