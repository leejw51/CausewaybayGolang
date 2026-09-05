import { beforeEach, describe, expect, it } from "vitest";

import { ensureFonts, font, remeasure, width, wrap } from "../../src/engine/text";

// happy-dom measures text as a fixed width per character, which is enough to
// check the *shape* of the wrapping — where breaks are allowed — without
// depending on a real font being installed.
beforeEach(() => {
  remeasure();
  ensureFonts(1);
});

describe("the twelve fonts", () => {
  it("come out at the sizes the desktop build uses", () => {
    // Press Start 2P only looks right on multiples of eight, so the pixel
    // fonts are snapped and the body ones are not.
    expect(font("title").size).toBe(40);
    expect(font("ui").size).toBe(16);
    expect(font("stationSm").size).toBe(8);
    expect(font("small").size).toBe(30);
  });

  it("grow with the virtual canvas", () => {
    const at1 = font("ui").size;
    ensureFonts(2);
    expect(font("ui").size).toBe(at1 * 2);
  });

  it("never shrink below the design size", () => {
    ensureFonts(0.5);
    expect(font("ui").size).toBe(16);
  });
});

describe("wrapping", () => {
  it("breaks Latin text on spaces", () => {
    const f = font("small");
    const one = width(f, "alpha beta gamma");
    const lines = wrap(f, "alpha beta gamma", one / 2);
    expect(lines.length).toBeGreaterThan(1);
    for (const line of lines) expect(line).not.toMatch(/^\s|\s$/);
  });

  it("keeps an explicit newline", () => {
    expect(wrap(font("code"), "a\nb", 10_000)).toEqual(["a", "b"]);
  });

  it("keeps a blank line, so a code block's spacing survives", () => {
    expect(wrap(font("code"), "a\n\nb", 10_000)).toEqual(["a", "", "b"]);
  });

  it("breaks CJK anywhere, because it has no spaces to break on", () => {
    const f = font("small");
    // Six ideographs and not a space between them: a wrapper that only broke
    // on whitespace would return this as one very wide line.
    const text = "銅鑼灣早餐店";
    const lines = wrap(f, text, width(f, "銅鑼") + 1);
    expect(lines.length).toBeGreaterThan(1);
    expect(lines.join("")).toBe(text);
  });

  it("breaks Hangul the same way", () => {
    const f = font("small");
    const text = "코즈웨이베이";
    const lines = wrap(f, text, width(f, "코즈") + 1);
    expect(lines.length).toBeGreaterThan(1);
    expect(lines.join("")).toBe(text);
  });

  it("never drops a word, however narrow the box", () => {
    const f = font("small");
    const text = "supercalifragilistic expialidocious";
    const lines = wrap(f, text, 1);
    expect(lines.join(" ")).toBe(text);
  });
});

describe("measuring", () => {
  it("caches, and the cache survives being asked twice", () => {
    const f = font("ui");
    expect(width(f, "PACKAGE")).toBe(width(f, "PACKAGE"));
  });

  it("is dropped when the fonts are rebuilt", () => {
    const before = width(font("ui"), "PACKAGE");
    ensureFonts(3);
    const after = width(font("ui"), "PACKAGE");
    expect(after).toBeGreaterThan(before);
  });
});
