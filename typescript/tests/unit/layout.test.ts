import { describe, expect, it } from "vitest";

import { Layout } from "../../src/engine/layout";
import { Theme } from "../../src/engine/theme";

/** A canvas that claims to be a given size on screen. */
function canvasOf(w: number, h: number): HTMLCanvasElement {
  const c = document.createElement("canvas");
  Object.defineProperty(c, "clientWidth", { value: w, configurable: true });
  Object.defineProperty(c, "clientHeight", { value: h, configurable: true });
  return c;
}

function at(w: number, h: number, dpr = 1, mode?: "landscape" | "portrait"): Layout {
  Object.defineProperty(window, "devicePixelRatio", { value: dpr, configurable: true });
  Object.defineProperty(window, "innerWidth", { value: w, configurable: true });
  Object.defineProperty(window, "innerHeight", { value: h, configurable: true });
  const l = new Layout(canvasOf(w, h));
  // Left to itself the layout follows the window; a test that is about the fit
  // rather than that choice pins the one it means.
  if (mode) l.pin(mode);
  l.measure();
  return l;
}

/** A canvas that changes shape under a layout that has already measured it. */
function resize(l: Layout, canvas: HTMLCanvasElement, w: number, h: number): void {
  Object.defineProperty(canvas, "clientWidth", { value: w, configurable: true });
  Object.defineProperty(canvas, "clientHeight", { value: h, configurable: true });
  l.measure();
}

describe("the virtual canvas", () => {
  it("is the design size at exactly the design size", () => {
    const l = at(1280, 720);
    expect([l.vw, l.vh]).toEqual([Theme.landW, Theme.landH]);
    expect(l.scale).toBe(1);
    expect([l.ox, l.oy]).toEqual([0, 0]);
  });

  it("scales by a whole number once the window is twice the design size", () => {
    const l = at(2560, 1440);
    expect(l.scale).toBe(2);
    expect([l.vw, l.vh]).toEqual([1280, 720]);
  });

  it("grows along the longer axis rather than letterboxing", () => {
    // A landscape layout in a window that is taller than 16:9 should get a
    // taller playfield, not black bars.
    const l = at(1280, 1000);
    expect(l.scale).toBe(1);
    expect(l.vw).toBe(1280);
    expect(l.vh).toBe(1000);
    expect(l.oy).toBe(0);
  });

  it("stops growing at half again the design size", () => {
    const l = at(1280, 4000, 1, "landscape");
    expect(l.vh).toBe(Math.floor(Theme.landH * 1.5));
    // Past that it does letterbox, and the bars are centred.
    expect(l.oy).toBeGreaterThan(0);
  });

  it("starts in portrait on a portrait display", () => {
    const l = at(720, 1280);
    expect(l.isPortrait()).toBe(true);
    expect([l.vw, l.vh]).toEqual([Theme.portW, Theme.portH]);
  });

  it("follows a window that changes shape", () => {
    // A phone turned on its side, or a browser window dragged tall. The
    // desktop build never has to deal with this; a page does.
    const canvas = canvasOf(1280, 720);
    Object.defineProperty(window, "devicePixelRatio", { value: 1, configurable: true });
    Object.defineProperty(window, "innerWidth", { value: 1280, configurable: true });
    Object.defineProperty(window, "innerHeight", { value: 720, configurable: true });
    const l = new Layout(canvas);
    l.measure();
    expect(l.isPortrait()).toBe(false);
    resize(l, canvas, 480, 900);
    expect(l.isPortrait()).toBe(true);
    expect(l.vw).toBe(Theme.portW);
  });

  it("stops following once the player has chosen", () => {
    const canvas = canvasOf(1280, 720);
    const l = new Layout(canvas);
    l.measure();
    l.toggleOrientation();
    expect(l.isPortrait()).toBe(true);
    resize(l, canvas, 1600, 700);
    expect(l.isPortrait()).toBe(true);
  });

  it("turns on its side without leaving the window", () => {
    const l = at(1280, 720);
    expect(l.isPortrait()).toBe(false);
    l.toggleOrientation();
    expect(l.isPortrait()).toBe(true);
    expect(l.vw * l.scale).toBeLessThanOrEqual(l.dw);
    expect(l.vh * l.scale).toBeLessThanOrEqual(l.dh);
  });

  it("caps the pixel ratio, so a phone does not render nine times the pixels", () => {
    const l = at(400, 800, 3);
    expect(l.dw).toBe(800);
    expect(l.dh).toBe(1600);
  });
});

describe("uiScale", () => {
  it("is 1 at the design size and grows with the canvas", () => {
    expect(at(1280, 720).uiScale()).toBe(1);
    expect(at(1600, 900).uiScale()).toBeCloseTo(1.25, 2);
  });

  it("never drops below 1, so type does not fall apart in a small window", () => {
    expect(at(640, 360).uiScale()).toBe(1);
  });
});

describe("pointer positions", () => {
  it("come back in virtual pixels", () => {
    const l = at(2560, 1440);
    // getBoundingClientRect on a detached canvas is all zeros, which is the
    // origin — so a client point maps straight through the scale.
    expect(l.toVirtual(0, 0)).toEqual([0, 0]);
    // The window is twice the design size, so a client pixel is half a
    // virtual one.
    expect(l.toVirtual(640, 360)).toEqual([320, 180]);
  });

  it("are null on the letterbox rather than on the game", () => {
    const l = at(1280, 4000, 1, "landscape");
    expect(l.toVirtual(0, 0)).toBeNull();
  });
});
