/**
 * The art, and when it arrives.
 *
 * `crates/mkassets` has already done everything `love2d/src/assets.lua` does
 * at launch — keying the magenta studio backdrop out, cropping each character
 * to its ink and packing it into a 32x48 cell — so there is nothing to process
 * here. What is left is a scheduling problem the desktop build does not have:
 * the sixteen backgrounds are four megabytes and only one of them is on screen
 * at a time.
 *
 * So the sprites, which are a few kilobytes all together, are loaded up front
 * and the backgrounds are fetched the first time a street asks for one. A
 * background that has not arrived yet simply is not drawn, and `world.ts`
 * falls back to a flat sky for that frame; nothing waits.
 */

interface Entry {
  name: string;
  file: string;
  w: number;
  h: number;
  box?: Box;
}

export interface Box {
  /** The middle of the ink, and the row its feet stand on. */
  cx: number;
  feet: number;
  h: number;
  /** The opaque bounds, for anything that stretches the ink rather than the
   *  transparent margin around it (the ribbon behind a CLEAR banner). */
  minx: number;
  miny: number;
  maxx: number;
  maxy: number;
}

export class Assets {
  private readonly images = new Map<string, HTMLImageElement>();
  private readonly entries = new Map<string, Entry>();
  private readonly pending = new Set<string>();
  readonly box = new Map<string, Box>();

  private constructor(private readonly base: string) {}

  /**
   * Read the manifest and load every sprite. Backgrounds are left for later;
   * `picture` starts one the first time it is asked for.
   */
  static async load(base = "art"): Promise<Assets> {
    const a = new Assets(base);
    const res = await fetch(`${base}/manifest.json`);
    if (!res.ok) throw new Error(`art manifest: ${res.status} ${res.statusText}`);
    const manifest = (await res.json()) as { art: Entry[] };
    const eager: Promise<unknown>[] = [];
    for (const e of manifest.art) {
      a.entries.set(e.name, e);
      if (e.box) a.box.set(e.name, e.box);
      // The .jpg files are the backgrounds; the .png files are the sprites.
      if (e.file.endsWith(".png")) eager.push(a.fetch(e));
    }
    await Promise.all(eager);
    return a;
  }

  private fetch(e: Entry): Promise<HTMLImageElement | null> {
    return new Promise((resolve) => {
      const img = new Image();
      img.decoding = "async";
      img.onload = () => {
        this.images.set(e.name, img);
        this.pending.delete(e.name);
        resolve(img);
      };
      // A missing file is not fatal: the renderer draws its fallback and the
      // game stays playable, which is also what makes a partial deploy visible
      // rather than a blank screen.
      img.onerror = () => {
        this.pending.delete(e.name);
        resolve(null);
      };
      img.src = `${this.base}/${e.file}`;
    });
  }

  /**
   * One image by name, or null when it is not here yet. `portrait` prefers the
   * `_p` variant of a background that has one.
   */
  picture(name: string, portrait = false): HTMLImageElement | null {
    if (portrait) {
      const p = this.picture(`${name}_p`);
      if (p) return p;
    }
    const hit = this.images.get(name);
    if (hit) return hit;
    const entry = this.entries.get(name);
    if (entry && !this.pending.has(name)) {
      this.pending.add(name);
      void this.fetch(entry);
    }
    return null;
  }

  /** Ask for a background ahead of time, so it is there when the street opens. */
  prefetch(name: string, portrait = false): void {
    this.picture(name, portrait);
  }

  has(name: string): boolean {
    return this.images.has(name);
  }
}
