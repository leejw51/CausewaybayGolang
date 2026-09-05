import { describe, expect, it } from "vitest";

import { renderForTest, SOUND_NAMES } from "../../src/audio/chip";

describe("the synthesized effects", () => {
  it("carries every name the core asks for", () => {
    // These are the names `Event::Sfx` uses. One missing is silence at the
    // moment the game most wants a noise.
    for (const name of [
      "type", "move", "step", "walk", "select", "back", "open", "hint", "lang",
      "toggle", "ok", "bad", "combo", "perfect", "clear", "deny", "next", "win",
    ]) {
      expect(SOUND_NAMES).toContain(name);
    }
  });

  it("renders a buffer of the length the steps add up to", () => {
    // "ok" is four steps of 0.06, 0.06, 0.06 and 0.16 seconds at 22050 Hz.
    const samples = renderForTest([
      { f: 440, d: 0.06 },
      { f: 550, d: 0.06 },
      { f: 660, d: 0.06 },
      { f: 880, d: 0.16 },
    ]);
    expect(samples.length).toBe(Math.floor((0.06 + 0.06 + 0.06 + 0.16) * 22050));
  });

  it("stays inside the range a speaker can take", () => {
    const samples = renderForTest([{ f: 440, d: 0.2, v: 1 }]);
    for (const s of samples) expect(Math.abs(s)).toBeLessThanOrEqual(1);
  });

  it("quantises to eight bits, because the crunch is the point", () => {
    const samples = renderForTest([{ f: 440, d: 0.05, v: 0.8 }]);
    for (const s of samples) {
      // Every sample is a whole number of 1/127ths — to within the precision
      // of the Float32Array it was stored in, which is where the slack is.
      expect(Math.abs(s * 127 - Math.round(s * 127))).toBeLessThan(1e-4);
    }
  });

  it("makes no sound at all during a rest", () => {
    const samples = renderForTest([{ f: 440, d: 0.05, rest: true }]);
    expect(samples.every((s) => s === 0)).toBe(true);
  });

  it("is the same noise every time, so a wrong answer sounds like itself", () => {
    const a = renderForTest([{ f: 200, d: 0.05, w: "noise" }]);
    const b = renderForTest([{ f: 200, d: 0.05, w: "noise" }]);
    expect(Array.from(a)).toEqual(Array.from(b));
  });

  it("slides from one frequency to another rather than jumping", () => {
    // A slide should not repeat the same waveform as a fixed tone would.
    const slid = renderForTest([{ f: 300, d: 0.18, to: 1400, w: "tri" }]);
    const flat = renderForTest([{ f: 300, d: 0.18, w: "tri" }]);
    expect(Array.from(slid)).not.toEqual(Array.from(flat));
  });
});
