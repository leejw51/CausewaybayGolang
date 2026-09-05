/**
 * A canvas that can be measured against, for the suite.
 *
 * happy-dom has no 2d context at all, and the modules under test here are the
 * ones that measure and wrap type. Rather than pull in a real rasteriser for
 * what these tests actually check — *where* a line may break, not what it
 * looks like — the stub below reports a fixed advance per character.
 *
 * That is a fair model of both of the game's fonts: Press Start 2P is a
 * monospace pixel font, and VT323 is very nearly one. CJK counts double, which
 * is what makes a wrapping bug in a Cantonese sentence visible here.
 */
import { beforeAll } from "vitest";

const ADVANCE = 0.6;

function isWide(ch: string): boolean {
  const c = ch.codePointAt(0) ?? 0;
  return (c >= 0x1100 && c <= 0x11ff) || (c >= 0x2e80 && c <= 0xff60);
}

function fontSize(font: string): number {
  const m = /(\d+(?:\.\d+)?)px/.exec(font);
  return m ? Number(m[1]) : 10;
}

class StubContext {
  font = "10px monospace";
  fillStyle: string | CanvasGradient | CanvasPattern = "#000";
  strokeStyle: string | CanvasGradient | CanvasPattern = "#000";
  lineWidth = 1;
  textAlign = "left";
  textBaseline = "alphabetic";
  globalAlpha = 1;
  imageSmoothingEnabled = true;
  filter = "none";

  measureText(text: string): TextMetrics {
    const size = fontSize(this.font);
    let w = 0;
    for (const ch of text) w += size * ADVANCE * (isWide(ch) ? 2 : 1);
    return {
      width: w,
      fontBoundingBoxAscent: size,
      fontBoundingBoxDescent: size * 0.25,
    } as TextMetrics;
  }

  // Everything else a draw might call, doing nothing.
  save() {}
  restore() {}
  translate() {}
  rotate() {}
  scale() {}
  setTransform() {}
  clearRect() {}
  fillRect() {}
  strokeRect() {}
  fillText() {}
  strokeText() {}
  beginPath() {}
  closePath() {}
  moveTo() {}
  lineTo() {}
  arc() {}
  arcTo() {}
  ellipse() {}
  rect() {}
  clip() {}
  fill() {}
  stroke() {}
  drawImage() {}
}

beforeAll(() => {
  const original = HTMLCanvasElement.prototype.getContext;
  HTMLCanvasElement.prototype.getContext = function patched(
    this: HTMLCanvasElement,
    kind: string,
    ...rest: unknown[]
  ) {
    if (kind === "2d") {
      const real = (original as (...a: unknown[]) => unknown | null)?.call(
        this,
        kind,
        ...rest,
      );
      return (real ?? new StubContext()) as never;
    }
    return (original as (...a: unknown[]) => unknown)?.call(this, kind, ...rest) as never;
  } as typeof HTMLCanvasElement.prototype.getContext;
});
