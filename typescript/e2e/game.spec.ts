import { expect, test, type Page } from "@playwright/test";

/**
 * The game, played in a real browser.
 *
 * The unit tests check the pieces and `cargo test` checks the rules; this is
 * the only suite that can catch the seam between them — a wasm module that
 * does not instantiate, a `game.json` that never arrives, an event the shell
 * does not handle, art served from the wrong path.
 *
 * Which screen the game is on is published on `<html data-state>` by
 * `main.ts`, so none of this has to read pixels back off the canvas.
 */

const state = (page: Page) => page.locator("html");

async function boot(page: Page): Promise<void> {
  await page.goto("/");
  await expect(state(page)).toHaveAttribute("data-state", "title", { timeout: 60_000 });
}

/** Type into the game the way a person does: one keystroke at a time. */
async function type(page: Page, text: string): Promise<void> {
  for (const ch of text) await page.keyboard.press(ch);
}

/** Whatever the game is showing, as the core sees it. */
async function view(page: Page): Promise<Record<string, unknown>> {
  return page.evaluate(() => JSON.parse((window as never as { __view: () => string }).__view()));
}

test.beforeEach(async ({ page }) => {
  const errors: string[] = [];
  page.on("console", (m) => {
    if (m.type() === "error") errors.push(m.text());
  });
  page.on("pageerror", (e) => errors.push(String(e)));
  // Hung on the test object so each test can assert the page stayed quiet.
  (test.info() as unknown as { _errors: string[] })._errors = errors;
});

test("ships its security headers, and plays inside them", async ({ page }) => {
  // public/_headers is only a file until something serves it, and a policy
  // that is too tight breaks the game in ways only a browser notices. So this
  // asserts both halves: the header arrives, and nothing violates it while the
  // game boots, loads its wasm and art, plays a blank and takes an export.
  const violations: string[] = [];
  await page.addInitScript(() => {
    (window as unknown as { __csp: string[] }).__csp = [];
    document.addEventListener("securitypolicyviolation", (e) => {
      (window as unknown as { __csp: string[] }).__csp.push(
        `${e.violatedDirective} blocked ${e.blockedURI}`,
      );
    });
  });

  const response = await page.goto("/");
  const csp = response?.headers()["content-security-policy"];
  // Vite's dev server does not serve _headers; Cloudflare does, and
  // `make e2e-dist` is the run that goes through it.
  test.skip(!csp, "no CSP here — this is the dev server, not the bundle");

  expect(csp).toContain("default-src 'self'");
  expect(csp).toContain("object-src 'none'");
  expect(csp).toContain("frame-ancestors 'none'");
  // Compiling a wasm module counts as eval, and the rules of the game are one.
  expect(csp).toContain("'wasm-unsafe-eval'");
  expect(response?.headers()["x-frame-options"]).toBe("DENY");
  expect(response?.headers()["x-content-type-options"]).toBe("nosniff");

  await expect(state(page)).toHaveAttribute("data-state", "title", { timeout: 60_000 });
  await page.keyboard.press("Digit1");
  const answer = String(((await view(page)).stageData as { answer: string }).answer);
  await type(page, answer);
  await page.keyboard.press("Enter");
  await page.keyboard.press("F6");
  const download = page.waitForEvent("download");
  await page.keyboard.press("Digit5");
  await download;

  violations.push(
    ...(await page.evaluate(() => (window as unknown as { __csp: string[] }).__csp)),
  );
  expect(violations).toEqual([]);
  expect((test.info() as unknown as { _errors: string[] })._errors).toEqual([]);
});

test("boots to the title card with the questions loaded", async ({ page }) => {
  await boot(page);
  await expect(page.locator("#boot")).toBeHidden();
  const v = await view(page);
  expect(v.state).toBe("title");
  expect(v.track).toBe("go");
  expect((v.stations as unknown[]).length).toBe(7);
  expect((test.info() as unknown as { _errors: string[] })._errors).toEqual([]);
});

test("ENTER opens the overworld and ENTER again opens a street", async ({ page }) => {
  await boot(page);
  await page.keyboard.press("Enter");
  await expect(state(page)).toHaveAttribute("data-state", "map");
  await page.keyboard.press("Enter");
  await expect(state(page)).toHaveAttribute("data-state", "play");
  const v = await view(page);
  expect(v.step).toBe(0);
  expect(v.stageCount).toBeGreaterThan(0);
});

test("a right answer moves to the next blank, a wrong one opens the nudge", async ({ page }) => {
  await boot(page);
  await page.keyboard.press("Digit1");
  await expect(state(page)).toHaveAttribute("data-state", "play");

  await type(page, "nonsense");
  await page.keyboard.press("Enter");
  let v = await view(page);
  expect(v.stage).toBe(0);
  expect(v.hintLevel).toBe(1);
  expect(v.msgKind).toBe("bad");

  // Clear the wrong guess, then answer the blank the game itself would.
  for (let i = 0; i < 8; i++) await page.keyboard.press("Backspace");
  const answer = String((v.stageData as { answer: string }).answer);
  await type(page, answer);
  await page.keyboard.press("Enter");

  v = await view(page);
  expect(v.stage).toBe(1);
  expect(v.msgKind).toBe("ok");
  expect(v.streak).toBe(1);
  expect((v.stats as { xp: number }).xp).toBeGreaterThan(0);
});

test("AUTO clears a street on its own, and the save survives a reload", async ({ page }) => {
  await boot(page);
  await page.keyboard.press("Digit1");
  await page.keyboard.press("F5");

  // AUTO reads, hints, types and submits, then walks on to the next street a
  // couple of seconds later — so the thing to wait for is the street going
  // CLEAR, which stays true, and not `solved`, which does not.
  await expect
    .poll(
      async () => (((await view(page)).stations as Array<{ cleared: boolean }>)[0].cleared),
      { timeout: 120_000, intervals: [1000] },
    )
    .toBe(true);

  const saved = await page.evaluate(() => window.localStorage.getItem("causewaybaygo.progress"));
  expect(saved).toBeTruthy();
  expect(JSON.parse(saved as string).cleared.length).toBeGreaterThan(0);

  await page.reload();
  await expect(state(page)).toHaveAttribute("data-state", "title", { timeout: 60_000 });
  const v = await view(page);
  expect((v.stations as Array<{ cleared: boolean }>)[0].cleared).toBe(true);
  expect(v.continueAt).not.toBeNull();
});

test("TAB walks the three language tracks", async ({ page }) => {
  await boot(page);
  expect((await view(page)).track).toBe("go");
  await page.keyboard.press("Tab");
  expect((await view(page)).track).toBe("rust");
  await page.keyboard.press("Tab");
  expect((await view(page)).track).toBe("python");
  await page.keyboard.press("Tab");
  expect((await view(page)).track).toBe("go");
});

test("F3 cycles the seven languages and the questions follow", async ({ page }) => {
  await boot(page);
  await page.keyboard.press("Digit1");
  const english = (await view(page)).stageData as { question: string };

  await page.keyboard.press("F3");
  let v = await view(page);
  expect(v.lang).toBe("ko");
  expect((v.stageData as { question: string }).question).not.toBe(english.question);

  // All the way round, back to English.
  for (let i = 0; i < 6; i++) await page.keyboard.press("F3");
  v = await view(page);
  expect(v.lang).toBe("en");
  expect((v.stageData as { question: string }).question).toBe(english.question);
});

test("F6 opens SHARE, and an export downloads a file", async ({ page }) => {
  await boot(page);
  await page.keyboard.press("Digit1");
  await page.keyboard.press("F6");
  expect((await view(page)).sheet).toBe(true);

  // 5 is MARKDOWN.
  const download = page.waitForEvent("download");
  await page.keyboard.press("Digit5");
  const file = await download;
  expect(file.suggestedFilename()).toMatch(/^causewaybaygo-go-q1-1-.*\.md$/);

  const stream = await file.createReadStream();
  const chunks: Buffer[] = [];
  for await (const chunk of stream) chunks.push(chunk as Buffer);
  const body = Buffer.concat(chunks).toString("utf8");
  expect(body).toContain("# CAUSEWAYBAY GO");
  expect(body).toContain("**Answer:**");
  expect(body).toContain("```go");

  await page.keyboard.press("Escape");
  expect((await view(page)).sheet).toBe(false);
});

test("the PNG disk is a real square image", async ({ page }) => {
  await boot(page);
  await page.keyboard.press("Digit1");
  await page.keyboard.press("F6");

  const download = page.waitForEvent("download");
  await page.keyboard.press("Digit0");
  const file = await download;
  expect(file.suggestedFilename()).toMatch(/\.png$/);

  const stream = await file.createReadStream();
  const chunks: Buffer[] = [];
  for await (const chunk of stream) chunks.push(chunk as Buffer);
  const png = Buffer.concat(chunks);
  // The PNG signature, then IHDR's width and height.
  expect(png.subarray(0, 8)).toEqual(Buffer.from([137, 80, 78, 71, 13, 10, 26, 10]));
  const w = png.readUInt32BE(16);
  const h = png.readUInt32BE(20);
  expect(w).toBe(h);
  expect(w).toBeGreaterThanOrEqual(512);
});

test("a click on the canvas reaches the game", async ({ page }) => {
  await boot(page);
  const canvas = page.locator("#view");
  await canvas.click({ position: { x: 400, y: 400 } });
  await expect(state(page)).toHaveAttribute("data-state", "map");
});

test("the window can be resized without anything falling over", async ({ page }) => {
  await boot(page);
  await page.keyboard.press("Digit1");
  for (const size of [
    { width: 420, height: 900 },
    { width: 1600, height: 700 },
    { width: 1280, height: 800 },
  ]) {
    await page.setViewportSize(size);
    await page.waitForTimeout(250);
    expect((await view(page)).state).toBe("play");
  }
  expect((test.info() as unknown as { _errors: string[] })._errors).toEqual([]);
});

test.describe("on a phone", () => {
  // A soft keyboard only exists once something on the page has focus, and the
  // whole game is one canvas — which cannot take any. So a tap while a blank
  // is open focuses a field nobody can see, and what the keyboard puts in it
  // is handed to the game one character at a time.
  test.use({ hasTouch: true, isMobile: true, viewport: { width: 414, height: 896 } });

  test("turns itself on its side and lets a tap raise the keyboard", async ({ page }) => {
    await boot(page);
    // A portrait window gets the portrait layout without anybody asking.
    expect(await page.evaluate(() => document.querySelector("canvas")!.height)).toBeGreaterThan(
      await page.evaluate(() => document.querySelector("canvas")!.width),
    );

    await page.keyboard.press("Digit1");
    await expect(state(page)).toHaveAttribute("data-state", "play");

    await page.locator("#view").tap({ position: { x: 200, y: 700 } });
    await expect(page.locator("#keys")).toBeFocused();

    // What a soft keyboard does: put text in the field rather than send keys.
    const answer = String(((await view(page)).stageData as { answer: string }).answer);
    await page.locator("#keys").pressSequentially(answer);
    expect((await view(page)).input).toBe(answer);

    await page.keyboard.press("Enter");
    const v = await view(page);
    expect(v.stage).toBe(1);
    expect(v.msgKind).toBe("ok");
  });

  test("takes the keyboard away again when there is nothing to type into", async ({ page }) => {
    await boot(page);
    await page.keyboard.press("Digit1");
    await page.locator("#view").tap({ position: { x: 200, y: 700 } });
    await expect(page.locator("#keys")).toBeFocused();

    // The SHARE sheet is not a place to type into.
    await page.keyboard.press("F6");
    await expect(page.locator("#keys")).not.toBeFocused();
  });
});
