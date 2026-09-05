/**
 * What a right answer throws into the air, as numbers.
 *
 * The GPU side of the effects (`particles.ts`) only knows how to move a
 * particle from a start, along a reach, under gravity, with an ease-out on
 * the way and a trail behind it. Everything about *which* particles — how
 * many, which way, what colour, how big, for how long — is decided here, in
 * plain arithmetic that a unit test can look at without a WebGL context.
 */
import { RGBA, Theme } from "./theme";

/**
 * 0 a soft glowing disc, 1 a four-point star, 2 a tumbling scrap of paper,
 * 3 a spinning gold coin.
 */
export type Shape = 0 | 1 | 2 | 3;

export interface Particle {
  /** Where it starts, in virtual pixels. */
  x: number;
  y: number;
  /** How far it is thrown over its life, in virtual pixels, easing out. */
  dx: number;
  dy: number;
  /**
   * A second leg, easing in and out exponentially, that lands it somewhere
   * exact: a coin's way to the counter. Zero for anything thrown and left.
   */
  tox: number;
  toy: number;
  /** A bulge along the way, as sin(pi t): the arc a coin flies in. */
  liftx: number;
  lifty: number;
  /** Seconds it lives, and seconds after the burst before it starts. */
  life: number;
  delay: number;
  /** Diameter in virtual pixels, at full size. */
  size: number;
  color: RGBA;
  shape: Shape;
  /** Whether it leaves a trail of ghosts behind it. */
  trail: boolean;
  /** Gravity, in virtual pixels per second squared. */
  gravity: number;
  /** Anything per-particle the shader wants to vary on: spin, flutter, phase. */
  seed: number;
}

export interface Ring {
  x: number;
  y: number;
  /** Radius at the end of the expansion, in virtual pixels. */
  radius: number;
  life: number;
  delay: number;
  color: RGBA;
  /** A soft disc of light rather than a line. */
  glow: boolean;
}

export interface Plan {
  particles: Particle[];
  rings: Ring[];
}

const SPARK: RGBA[] = [Theme.coin, Theme.pink, Theme.cyan, Theme.cream, Theme.admit];
const PAPER: RGBA[] = [Theme.coin, Theme.pink, Theme.cyan, Theme.cream, Theme.admit, Theme.brick];
const GOLD: RGBA[] = [Theme.coin, Theme.cream, [1, 0.95, 0.7, 1]];

type Rng = () => number;

function between(rng: Rng, a: number, b: number): number {
  return a + (b - a) * rng();
}

function pick<T>(rng: Rng, list: T[]): T {
  return list[Math.floor(rng() * list.length) % list.length];
}

/** Something thrown from a point: no second leg, no arc. */
function thrown(
  x: number,
  y: number,
  dx: number,
  dy: number,
  rest: Omit<Particle, "x" | "y" | "dx" | "dy" | "tox" | "toy" | "liftx" | "lifty">,
): Particle {
  return { x, y, dx, dy, tox: 0, toy: 0, liftx: 0, lifty: 0, ...rest };
}

/**
 * The burst a right answer gets. `n` is what the core asks for — it climbs
 * with the streak — and everything scales from it: more sparks, further,
 * with a little longer to fall.
 */
export function burstPlan(x: number, y: number, n: number, rng: Rng = Math.random): Plan {
  const k = Math.max(0.6, Math.min(2.2, n / 36));
  const particles: Particle[] = [];
  const rings: Ring[] = [];

  // The sparks: a shell of glowing points thrown in every direction, each
  // with a trail, easing out to a stop and then dropping.
  for (let i = 0; i < n; i++) {
    const ang = rng() * Math.PI * 2;
    const reach = between(rng, 70, 230) * Math.sqrt(k);
    particles.push(
      thrown(x, y, Math.cos(ang) * reach, Math.sin(ang) * reach - 40 * k, {
        life: between(rng, 0.7, 1.3),
        delay: rng() * 0.05,
        size: between(rng, 5, 12),
        color: pick(rng, SPARK),
        shape: 0,
        trail: true,
        gravity: 180,
        seed: rng(),
      }),
    );
  }

  // The stars: fewer, bigger, gold, and they go further.
  const stars = Math.round(n / 3);
  for (let i = 0; i < stars; i++) {
    const ang = rng() * Math.PI * 2;
    const reach = between(rng, 120, 300) * Math.sqrt(k);
    particles.push(
      thrown(x, y, Math.cos(ang) * reach, Math.sin(ang) * reach - 60 * k, {
        life: between(rng, 0.9, 1.5),
        delay: rng() * 0.08,
        size: between(rng, 14, 26),
        color: pick(rng, GOLD),
        shape: 1,
        trail: true,
        gravity: 120,
        seed: rng(),
      }),
    );
  }

  // The paper: thrown mostly upward, tumbling, and it takes its time to fall.
  const paper = Math.round(n / 2);
  for (let i = 0; i < paper; i++) {
    const ang = -Math.PI / 2 + (rng() - 0.5) * Math.PI * 1.3;
    const reach = between(rng, 90, 320) * Math.sqrt(k);
    particles.push(
      thrown(x, y, Math.cos(ang) * reach, Math.sin(ang) * reach, {
        life: between(rng, 1.3, 2.1),
        delay: rng() * 0.1,
        size: between(rng, 9, 16),
        color: pick(rng, PAPER),
        shape: 2,
        trail: false,
        gravity: 300,
        seed: rng(),
      }),
    );
  }

  // A flash of light where it happened, and a shockwave out of it.
  rings.push({ x, y, radius: 90 * Math.sqrt(k), life: 0.35, delay: 0, color: Theme.cream, glow: true });
  rings.push({ x, y, radius: 150 * Math.sqrt(k), life: 0.55, delay: 0, color: Theme.coin, glow: false });
  if (k > 1.4) {
    rings.push({ x, y, radius: 210 * Math.sqrt(k), life: 0.7, delay: 0.1, color: Theme.pink, glow: false });
  }

  return { particles, rings };
}

/**
 * A street going CLEAR: fireworks across the scene, one after another, and
 * a slow rain of paper from the top. `perfect` is a fourth, bigger one in
 * the middle, all gold.
 */
export function clearPlan(
  rect: { x: number; y: number; w: number; h: number },
  perfect: boolean,
  rng: Rng = Math.random,
): Plan {
  const particles: Particle[] = [];
  const rings: Ring[] = [];
  const shells: Array<[number, number, number]> = [
    [rect.x + rect.w * 0.25, rect.y + rect.h * 0.35, 0],
    [rect.x + rect.w * 0.75, rect.y + rect.h * 0.3, 0.18],
    [rect.x + rect.w * 0.5, rect.y + rect.h * 0.22, 0.36],
  ];
  if (perfect) shells.push([rect.x + rect.w * 0.5, rect.y + rect.h * 0.45, 0.6]);

  shells.forEach(([sx, sy, at], i) => {
    const big = perfect && i === shells.length - 1;
    const shell = burstPlan(sx, sy, big ? 96 : 48, rng);
    for (const p of shell.particles) {
      p.delay += at;
      if (big) p.color = pick(rng, GOLD);
    }
    for (const r of shell.rings) r.delay += at;
    particles.push(...shell.particles);
    rings.push(...shell.rings);
  });

  // The rain: paper from above the scene, drifting down over a few seconds.
  const rain = perfect ? 90 : 60;
  for (let i = 0; i < rain; i++) {
    particles.push(
      thrown(rect.x + rng() * rect.w, rect.y - 20, (rng() - 0.5) * 80, rect.h * between(rng, 0.5, 0.9), {
        life: between(rng, 2.2, 3.4),
        delay: rng() * 1.6,
        size: between(rng, 9, 15),
        color: perfect ? pick(rng, GOLD) : pick(rng, PAPER),
        shape: 2,
        trail: false,
        gravity: 60,
        seed: rng(),
      }),
    );
  }

  return { particles, rings };
}

/** Seconds a coin is in the air, and the most a shower is spread over. */
export const COIN_FLIGHT = 0.85;
export const COIN_SPREAD = 0.35;

/**
 * Coins from where the answer landed to the counter: each is tossed a little
 * way out (easing out), hangs at the top of its arc, then whips into the
 * counter (easing in), with a tail behind it. They leave one after another,
 * so the counter takes them one after another too. Returns the plan and the
 * moment, in seconds from now, the first coin arrives.
 */
export function coinPlan(
  x: number,
  y: number,
  tx: number,
  ty: number,
  n: number,
  rng: Rng = Math.random,
): { plan: Plan; firstLanding: number; lastLanding: number } {
  const particles: Particle[] = [];
  const rings: Ring[] = [];
  const count = Math.max(1, Math.round(n));
  // The arc bulges away from the straight line, upward for preference.
  const ddx = tx - x;
  const ddy = ty - y;
  const len = Math.max(1, Math.hypot(ddx, ddy));
  const nx = -ddy / len;
  const ny = ddx / len;
  const sign = ny < 0 ? 1 : -1;

  for (let i = 0; i < count; i++) {
    const delay = (i / count) * COIN_SPREAD + rng() * 0.04;
    const ang = -Math.PI / 2 + (rng() - 0.5) * Math.PI * 1.4;
    const toss = between(rng, 24, 70);
    const dx = Math.cos(ang) * toss;
    const dy = Math.sin(ang) * toss;
    // A shallow arc: enough to read as a throw, not so much that a coin
    // bound for the top corner sails through the HUD on its way.
    const lift = between(rng, 0.05, 0.15) * len * sign;
    particles.push({
      x,
      y,
      dx,
      dy,
      tox: ddx - dx,
      toy: ddy - dy,
      liftx: nx * lift,
      lifty: ny * lift,
      life: COIN_FLIGHT * between(rng, 0.92, 1.08),
      delay,
      size: between(rng, 24, 32),
      color: Theme.coin,
      shape: 3,
      trail: true,
      gravity: 0,
      seed: rng(),
    });
  }

  const firstLanding = COIN_FLIGHT * 0.92;
  const lastLanding = COIN_SPREAD + 0.04 + COIN_FLIGHT * 1.08;
  // A wink of light at the counter as the first lands, and as the last does.
  rings.push({ x: tx, y: ty, radius: 46, life: 0.3, delay: firstLanding, color: Theme.coin, glow: true });
  rings.push({ x: tx, y: ty, radius: 70, life: 0.4, delay: lastLanding, color: Theme.cream, glow: false });
  return { plan: { particles, rings }, firstLanding, lastLanding };
}
