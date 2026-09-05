/**
 * The 8-bit sound effects, synthesized rather than downloaded.
 *
 * A straight port of `love2d/src/sfx.lua`: the same square, triangle, saw and
 * noise voices, the same envelope, the same note tables, rendered once into
 * Web Audio buffers at 22050 Hz and quantised to eight bits — the crunch is
 * the point, and a clean 48 kHz render sounds wrong beside the desktop build.
 *
 * The one browser-shaped difference: an `AudioContext` may not make a sound
 * until the page has been touched, so the context is created on the first
 * gesture and every effect asked for before that is silently dropped.
 */

const RATE = 22050;

interface Step {
  /** Hz. */
  f?: number;
  /** Seconds. */
  d: number;
  w?: "square" | "tri" | "saw" | "noise";
  v?: number;
  /** Slide to this frequency across the step. */
  to?: number;
  duty?: number;
  rest?: boolean;
}

const N: Record<string, number> = {
  C4: 261.63,
  D4: 293.66,
  E4: 329.63,
  F4: 349.23,
  G4: 392.0,
  Gs4: 415.3,
  A4: 440.0,
  As4: 466.16,
  B4: 493.88,
  C5: 523.25,
  D5: 587.33,
  E5: 659.25,
  F5: 698.46,
  G5: 783.99,
  Gs5: 830.61,
  A5: 880.0,
  As5: 932.33,
  B5: 987.77,
  C6: 1046.5,
  D6: 1174.66,
  E6: 1318.51,
  G6: 1567.98,
};

const SOUNDS: Record<string, Step[]> = {
  type: [{ f: 1400, d: 0.025, v: 0.35, duty: 0.25 }],
  move: [{ f: N.E5, d: 0.035, to: N.A5, v: 0.5 }],
  step: [{ f: N.A4, d: 0.03, v: 0.4, duty: 0.25 }],
  walk: [
    { f: 140, d: 0.02, to: 90, w: "tri", v: 0.5 },
    { f: 60, d: 0.012, w: "noise", v: 0.18 },
  ],
  select: [
    { f: N.C5, d: 0.05 },
    { f: N.G5, d: 0.09 },
  ],
  back: [
    { f: N.G5, d: 0.05 },
    { f: N.C5, d: 0.09 },
  ],
  open: [
    { f: N.G4, d: 0.05, w: "tri" },
    { f: N.C5, d: 0.05, w: "tri" },
    { f: N.E5, d: 0.09, w: "tri" },
  ],
  hint: [
    { f: N.A5, d: 0.07, w: "tri" },
    { f: N.D6, d: 0.13, w: "tri" },
  ],
  lang: [
    { f: N.B5, d: 0.04 },
    { f: N.E6, d: 0.05 },
  ],
  toggle: [{ f: N.E5, d: 0.05, duty: 0.25 }],
  ok: [
    { f: N.C5, d: 0.06 },
    { f: N.E5, d: 0.06 },
    { f: N.G5, d: 0.06 },
    { f: N.C6, d: 0.16 },
  ],
  bad: [
    { f: N.A4, d: 0.08, to: N.F4, duty: 0.25 },
    { f: N.F4, d: 0.18, to: 110, duty: 0.25 },
    { f: 200, d: 0.06, w: "noise", v: 0.3 },
  ],
  combo: [
    { f: N.E5, d: 0.04 },
    { f: N.G5, d: 0.04 },
    { f: N.C6, d: 0.05 },
    { f: N.E6, d: 0.1 },
  ],
  perfect: [
    { f: N.G5, d: 0.06 },
    { f: N.G5, d: 0.02, rest: true },
    { f: N.G5, d: 0.06 },
    { f: N.G5, d: 0.02, rest: true },
    { f: N.G5, d: 0.06 },
    { f: N.C6, d: 0.1 },
    { f: N.E6, d: 0.1 },
    { f: N.G6, d: 0.1 },
    { f: N.E6, d: 0.06, rest: true },
    { f: N.G6, d: 0.05 },
    { f: N.C6, d: 0.05, w: "tri" },
    { f: N.G6, d: 0.4 },
  ],
  clear: [
    { f: N.C5, d: 0.07 },
    { f: N.E5, d: 0.07 },
    { f: N.G5, d: 0.07 },
    { f: N.C6, d: 0.07 },
    { f: N.E6, d: 0.07 },
    { f: N.G6, d: 0.07 },
    { f: N.C6, d: 0.05, rest: true },
    { f: N.C6, d: 0.3 },
  ],
  deny: [
    { f: N.E4, d: 0.12, duty: 0.25 },
    { f: N.E4, d: 0.04, rest: true },
    { f: N.C4, d: 0.3, to: 90, duty: 0.25 },
  ],
  next: [{ f: 300, d: 0.18, to: 1400, w: "tri", v: 0.6 }],
  win: [
    { f: N.C5, d: 0.11 },
    { f: N.C5, d: 0.03, rest: true },
    { f: N.C5, d: 0.11 },
    { f: N.C5, d: 0.03, rest: true },
    { f: N.C5, d: 0.11 },
    { f: N.C5, d: 0.03, rest: true },
    { f: N.C5, d: 0.3 },
    { f: N.Gs4, d: 0.3 },
    { f: N.As4, d: 0.3 },
    { f: N.C5, d: 0.11 },
    { f: N.C5, d: 0.1, rest: true },
    { f: N.As4, d: 0.11 },
    { f: N.C5, d: 0.6 },
  ],
};

export const SOUND_NAMES = Object.keys(SOUNDS).sort();

/** One effect's samples, in the shape LÖVE renders them. */
function render(steps: Step[]): Float32Array<ArrayBuffer> {
  const total = steps.reduce((n, s) => n + s.d, 0);
  const n = Math.floor(total * RATE);
  const out = new Float32Array(new ArrayBuffer(n * 4));
  let i = 0;
  let phase = 0;
  // A fixed seed, so the noise is the same crunch every time it plays.
  let seed = 12345;

  steps.forEach((s, si) => {
    const len = Math.floor(s.d * RATE);
    const wave = s.w ?? "square";
    const duty = s.duty ?? 0.5;
    const vol = s.v ?? 0.8;
    const last = si === steps.length - 1;
    for (let k = 0; k < len && i < n; k++, i++) {
      if (s.rest) continue;
      const t = k / len;
      let f = s.f ?? 440;
      if (s.to !== undefined) f = f + (s.to - f) * t;
      // 2 ms attack, a decay to 45%, and a release on the last step.
      let env = Math.min(1, k / (RATE * 0.002)) * (1 - 0.55 * t);
      if (last) env *= 1 - t * t;
      phase += f / RATE;
      if (phase >= 1) phase -= 1;
      let x: number;
      if (wave === "square") x = phase < duty ? 1 : -1;
      else if (wave === "tri") x = phase < 0.5 ? phase * 4 - 1 : 3 - phase * 4;
      else if (wave === "saw") x = phase * 2 - 1;
      else {
        seed = (seed * 1103515245 + 12345) % 2147483648;
        x = (seed / 2147483648) * 2 - 1;
      }
      const amp = Math.max(-1, Math.min(1, x * env * vol));
      // Eight bits, like the SoundData the desktop build writes into.
      out[i] = Math.round(amp * 127) / 127;
    }
  });
  return out;
}

export class Chip {
  private ctx: AudioContext | null = null;
  private gain: GainNode | null = null;
  private readonly buffers = new Map<string, AudioBuffer>();
  enabled = true;

  /** Wake the audio context. Any gesture will do, and it is safe to repeat. */
  ensure(): void {
    if (!this.ctx) {
      const Ctor: typeof AudioContext | undefined =
        window.AudioContext ??
        (window as unknown as { webkitAudioContext?: typeof AudioContext }).webkitAudioContext;
      if (!Ctor) return;
      try {
        this.ctx = new Ctor({ sampleRate: RATE });
      } catch {
        // Some engines refuse an unusual sample rate; take whatever they give.
        try {
          this.ctx = new Ctor();
        } catch {
          return;
        }
      }
      this.gain = this.ctx.createGain();
      this.gain.gain.value = 0.45;
      this.gain.connect(this.ctx.destination);
      this.warm();
    }
    if (this.ctx.state === "suspended") void this.ctx.resume();
  }

  /** Render every effect up front, so nothing is synthesized mid-game. */
  private warm(): void {
    for (const name of SOUND_NAMES) this.buffer(name);
  }

  private buffer(name: string): AudioBuffer | null {
    const hit = this.buffers.get(name);
    if (hit) return hit;
    const spec = SOUNDS[name];
    if (!spec || !this.ctx) return null;
    const samples = render(spec);
    const buf = this.ctx.createBuffer(1, samples.length, RATE);
    buf.copyToChannel(samples, 0);
    this.buffers.set(name, buf);
    return buf;
  }

  play(name: string, pitch = 1): void {
    if (!this.enabled || !this.ctx || !this.gain) return;
    const buf = this.buffer(name);
    if (!buf) return;
    const src = this.ctx.createBufferSource();
    src.buffer = buf;
    src.playbackRate.value = pitch;
    src.connect(this.gain);
    src.start();
  }

  set(on: boolean): boolean {
    this.enabled = on;
    return this.enabled;
  }

  toggle(): boolean {
    this.enabled = !this.enabled;
    if (this.enabled) this.play("toggle");
    return this.enabled;
  }
}

export const renderForTest = render;
