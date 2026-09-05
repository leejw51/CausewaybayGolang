import { describe, expect, it } from "vitest";

import { burstPlan, clearPlan, coinPlan, COIN_FLIGHT } from "../../src/engine/burst";

/** A deterministic stand-in for Math.random. */
function seeded(seed = 1): () => number {
  let s = seed;
  return () => {
    s = (s * 1664525 + 1013904223) % 4294967296;
    return s / 4294967296;
  };
}

describe("a burst", () => {
  it("throws sparks, stars and paper from the point, and rings a shockwave", () => {
    const plan = burstPlan(100, 200, 36, seeded());
    const shapes = new Set(plan.particles.map((p) => p.shape));
    expect(shapes).toEqual(new Set([0, 1, 2]));
    for (const p of plan.particles) {
      expect([p.x, p.y]).toEqual([100, 200]);
      expect(p.life).toBeGreaterThan(0);
      expect(p.size).toBeGreaterThan(0);
      expect(p.delay).toBeGreaterThanOrEqual(0);
      expect(p.color).toHaveLength(4);
    }
    expect(plan.rings.length).toBeGreaterThanOrEqual(2);
    expect(plan.rings.some((r) => r.glow)).toBe(true);
    expect(plan.rings.some((r) => !r.glow)).toBe(true);
  });

  it("grows with the streak: more of everything, thrown further", () => {
    const small = burstPlan(0, 0, 36, seeded(3));
    const big = burstPlan(0, 0, 132, seeded(3));
    expect(big.particles.length).toBeGreaterThan(small.particles.length * 2);
    const reach = (plan: ReturnType<typeof burstPlan>) =>
      plan.particles.reduce((m, p) => Math.max(m, Math.hypot(p.dx, p.dy)), 0);
    expect(reach(big)).toBeGreaterThan(reach(small));
    expect(big.rings.length).toBeGreaterThan(small.rings.length);
  });

  it("trails the glowing things and not the paper", () => {
    const plan = burstPlan(0, 0, 60, seeded(7));
    for (const p of plan.particles) expect(p.trail).toBe(p.shape !== 2);
  });

  it("throws things and leaves them: no second leg, no arc", () => {
    const plan = burstPlan(0, 0, 60, seeded(8));
    for (const p of plan.particles) expect([p.tox, p.toy, p.liftx, p.lifty]).toEqual([0, 0, 0, 0]);
  });
});

describe("coins to the counter", () => {
  it("every one of them lands exactly on the counter, one after another", () => {
    const { plan, firstLanding, lastLanding } = coinPlan(100, 300, 900, 60, 10, seeded(5));
    const coins = plan.particles;
    expect(coins).toHaveLength(10);
    for (const c of coins) {
      expect(c.shape).toBe(3);
      expect(c.trail).toBe(true);
      expect(c.gravity).toBe(0);
      // The throw and the second leg add up to the counter.
      expect(c.x + c.dx + c.tox).toBeCloseTo(900, 6);
      expect(c.y + c.dy + c.toy).toBeCloseTo(60, 6);
      // Some arc, so they do not fly in a straight line.
      expect(Math.hypot(c.liftx, c.lifty)).toBeGreaterThan(20);
    }
    const delays = coins.map((c) => c.delay);
    expect(Math.max(...delays)).toBeGreaterThan(Math.min(...delays));
    expect(firstLanding).toBeLessThan(COIN_FLIGHT);
    expect(lastLanding).toBeGreaterThan(firstLanding);
    // A wink at the counter when the first lands, and the last.
    expect(plan.rings.map((r) => [r.x, r.y])).toEqual([
      [900, 60],
      [900, 60],
    ]);
  });

  it("throws paper mostly upward, so it has somewhere to fall from", () => {
    const plan = burstPlan(0, 0, 200, seeded(9));
    const paper = plan.particles.filter((p) => p.shape === 2);
    const up = paper.filter((p) => p.dy < 0).length;
    expect(up / paper.length).toBeGreaterThan(0.75);
  });
});

describe("a street going CLEAR", () => {
  const scene = { x: 0, y: 80, w: 1280, h: 300 };

  it("is several fireworks, staggered, and a rain of paper", () => {
    const plan = clearPlan(scene, false, seeded(2));
    const starts = new Set(plan.rings.map((r) => r.delay));
    expect(starts.size).toBeGreaterThanOrEqual(3);
    const rain = plan.particles.filter((p) => p.y < scene.y);
    expect(rain.length).toBeGreaterThan(30);
    for (const p of rain) {
      expect(p.dy).toBeGreaterThan(0);
      expect(p.shape).toBe(2);
    }
  });

  it("adds a fourth, gold shell for a perfect street", () => {
    const plain = clearPlan(scene, false, seeded(4));
    const perfect = clearPlan(scene, true, seeded(4));
    expect(perfect.rings.length).toBeGreaterThan(plain.rings.length);
    expect(perfect.particles.length).toBeGreaterThan(plain.particles.length);
  });
});
