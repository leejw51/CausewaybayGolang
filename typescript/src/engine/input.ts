/**
 * Keys, clicks and taps, in the names the core already knows.
 *
 * The core's `key()` takes the names LÖVE gives keys — "return", "escape",
 * "pageup", "kpenter" — so the two ports read the same and a shortcut fixed in
 * one is fixed in both. This translates a browser `KeyboardEvent` into that
 * vocabulary and nothing else.
 *
 * Typing is separate from keys, as it is in LÖVE: `textinput` carries the
 * character a keystroke produced, which is the only thing that works for an
 * answer typed on a Korean or a Japanese keyboard.
 */

const NAMED: Record<string, string> = {
  Enter: "return",
  NumpadEnter: "kpenter",
  Escape: "escape",
  Backspace: "backspace",
  Tab: "tab",
  " ": "space",
  ArrowLeft: "left",
  ArrowRight: "right",
  ArrowUp: "up",
  ArrowDown: "down",
  PageUp: "pageup",
  PageDown: "pagedown",
  Home: "home",
  End: "end",
  Delete: "delete",
};

/** The browser name for a key, as LÖVE would have called it. */
export function loveKey(ev: KeyboardEvent): string | null {
  if (ev.code === "NumpadEnter") return "kpenter";
  const named = NAMED[ev.key];
  if (named) return named;
  if (/^F([1-9]|1[0-2])$/.test(ev.key)) return ev.key.toLowerCase();
  if (ev.key.length === 1) {
    const c = ev.key.toLowerCase();
    if (/[a-z0-9]/.test(c)) return c;
  }
  return null;
}

/** Does this keystroke produce a character the prompt should take? */
export function typedText(ev: KeyboardEvent): string | null {
  if (ev.ctrlKey || ev.metaKey || ev.altKey) return null;
  if (ev.key.length !== 1) return null;
  if (ev.key === "\t" || ev.key === "\n" || ev.key === "\r") return null;
  return ev.key;
}

export class Input {
  /** Arrows held down, for the walk after a street is CLEAR. */
  left = false;
  right = false;

  private readonly down = new Set<string>();

  track(name: string, isDown: boolean): void {
    if (isDown) this.down.add(name);
    else this.down.delete(name);
    this.left = this.down.has("left") || this.down.has("a");
    this.right = this.down.has("right") || this.down.has("d");
  }

  /** The window lost focus with a key held: it will never see the keyup. */
  releaseAll(): void {
    this.down.clear();
    this.left = false;
    this.right = false;
  }
}
