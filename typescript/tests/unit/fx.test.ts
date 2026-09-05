import { describe, expect, it } from "vitest";

import { FX, LIFE } from "../../src/game/fx";

const RECT = { x: 0, y: 0, w: 1280, h: 300 };

/** Step the effects for `seconds` at sixty frames a second. */
function run(fx: FX, seconds: number): void {
  for (let i = 0; i < Math.round(seconds * 60); i++) fx.update(1 / 60);
}

describe("the three tiers", () => {
  it("start with nothing on screen", () => {
    expect(new FX().active()).toBe(false);
  });

  it("clear themselves within their own lifetime", () => {
    const small = new FX();
    small.small(100, 100, "NICE");
    expect(small.active()).toBe(true);
    run(small, LIFE.small + 2);
    expect(small.active()).toBe(false);
  });

  it("put a banner up for a street CLEAR and take it down again", () => {
    const fx = new FX();
    fx.big(RECT, "CLEAR", true);
    expect(fx.bannerCount()).toBe(1);
    run(fx, LIFE.big + 0.5);
    expect(fx.bannerCount()).toBe(0);
  });

  it("keeps the quest banner up for its full five seconds", () => {
    const fx = new FX();
    fx.quest(RECT, "QUEST CLEAR");
    run(fx, LIFE.quest - 0.5);
    expect(fx.bannerCount()).toBe(1);
    run(fx, 1);
    expect(fx.bannerCount()).toBe(0);
  });

  it("keeps letting fireworks off after the first one", () => {
    const fx = new FX();
    fx.quest(RECT, "QUEST CLEAR");
    // The fuses are spread over the first three seconds; the whole thing is
    // still going well after the initial burst has fallen.
    run(fx, 2.5);
    expect(fx.active()).toBe(true);
  });

  it("is emptied by clear(), which is what starting a street does", () => {
    const fx = new FX();
    fx.big(RECT, "CLEAR", false);
    fx.clear();
    expect(fx.active()).toBe(false);
    expect(fx.bannerCount()).toBe(0);
  });
});

describe("the plain spark burst", () => {
  it("survives a clear of the tiers, and dies on its own", () => {
    const fx = new FX();
    fx.burst(100, 100, 24);
    fx.clear();
    expect(fx.active()).toBe(true);
    run(fx, 2);
    expect(fx.active()).toBe(false);
  });

  it("does not throw when asked for nothing", () => {
    const fx = new FX();
    fx.burst(0, 0, 0);
    run(fx, 0.5);
    expect(fx.active()).toBe(false);
  });
});
