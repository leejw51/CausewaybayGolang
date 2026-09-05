import { defineConfig, devices } from "@playwright/test";

// A separate port from `make start`, so an end-to-end run and a dev server can
// coexist without one killing the other.
//
// `E2E_BASE_URL` points the same suite at a server somebody else started —
// `make e2e-dist` uses it to run against the production bundle served by
// Cloudflare's own runtime, which is the artifact that actually ships. Without
// it, Vite's dev server is started here and torn down afterwards.
const external = process.env.E2E_BASE_URL;
const PORT = 5311;

export default defineConfig({
  testDir: "./e2e",
  timeout: 90_000,
  expect: { timeout: 20_000 },
  fullyParallel: false,
  retries: 0,
  workers: 1,
  reporter: [["list"]],
  use: {
    baseURL: external ?? `http://127.0.0.1:${PORT}`,
    trace: "on-first-retry",
  },
  webServer: external
    ? undefined
    : {
        command: `npx vite --host 127.0.0.1 --port ${PORT}`,
        url: `http://127.0.0.1:${PORT}`,
        reuseExistingServer: false,
        timeout: 180_000,
      },
  projects: [{ name: "chromium", use: { ...devices["Desktop Chrome"] } }],
});
