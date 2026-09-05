/**
 * The UI strings, in the language on screen.
 *
 * The core hands over the whole table resolved (`Core.strings()`), and this
 * fills in the `%s` and `%d` that Lua's `string.format` left in them. Doing the
 * formatting here rather than in wasm keeps the boundary to one call per
 * language change instead of one per label per frame.
 */

export class Strings {
  private table: Record<string, string> = {};

  load(json: string): void {
    try {
      this.table = JSON.parse(json) as Record<string, string>;
    } catch {
      this.table = {};
    }
  }

  /** A string by key. An unknown key comes back as itself, which is what LÖVE
   *  does and makes a missing string obvious on screen rather than blank. */
  t(key: string): string {
    return this.table[key] ?? key;
  }

  /**
   * A string with its arguments filled in. Only `%s` and `%d` appear in the
   * table; `%%` is a literal percent, and a specifier with no argument left is
   * printed as it stands — a translation with one `%s` too many should look
   * wrong rather than silently drop the text after it.
   */
  tf(key: string, ...args: Array<string | number>): string {
    const spec = this.t(key);
    let next = 0;
    return spec.replace(/%[%sd]/g, (m) => {
      if (m === "%%") return "%";
      if (next >= args.length) return m;
      return String(args[next++]);
    });
  }
}
