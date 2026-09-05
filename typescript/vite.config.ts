import { defineConfig } from "vite";

// `base: "./"` so the built bundle works from whatever path a Cloudflare
// project is served under, including a preview deployment on its own hostname.
export default defineConfig({
  base: "./",
  server: { host: true, port: 5310 },
  build: {
    outDir: "dist",
    assetsDir: "assets",
    sourcemap: false,
    // The wasm module arrives as its own file rather than being inlined: it is
    // far too big for a data URL and caches better on its own.
    assetsInlineLimit: 4096,
  },
});
