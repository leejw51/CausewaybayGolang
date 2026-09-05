/**
 * Where the save lives.
 *
 * The desktop build appends JSONL to `~/.causewaybaygo` and reads the last
 * line back. A browser tab has `localStorage`, which is one string per key and
 * nothing else, so the log is gone and only the record that would have been
 * the last line is kept — which is all either build ever reads.
 *
 * Everything here is wrapped: `localStorage` throws outright in a browser set
 * to block site data, and a game that will not start because it could not save
 * is a worse game than one that forgets.
 */

const KEY = {
  progress: "causewaybaygo.progress",
  stats: "causewaybaygo.stats",
  display: "causewaybaygo.display",
} as const;

/** What the shell keeps for itself: the window and the sound, not the game. */
export interface Display {
  mode: "landscape" | "portrait";
  sound: boolean;
}

function read(key: string): string | null {
  try {
    return window.localStorage.getItem(key);
  } catch {
    return null;
  }
}

function write(key: string, value: string): void {
  try {
    window.localStorage.setItem(key, value);
  } catch {
    // A private window, or site data turned off. The session still plays.
  }
}

export const store = {
  loadProgress: (): string | null => read(KEY.progress),
  saveProgress: (json: string): void => write(KEY.progress, json),

  loadStats: (): string | null => read(KEY.stats),
  saveStats: (json: string): void => write(KEY.stats, json),

  loadDisplay(): Display | null {
    const raw = read(KEY.display);
    if (!raw) return null;
    try {
      const d = JSON.parse(raw) as Partial<Display>;
      const mode = d.mode === "portrait" || d.mode === "landscape" ? d.mode : null;
      if (!mode) return null;
      return { mode, sound: d.sound !== false };
    } catch {
      return null;
    }
  },

  saveDisplay(d: Display): void {
    write(KEY.display, JSON.stringify(d));
  },
};

/**
 * Hand the player a file. The desktop build writes to `~/Downloads`; a page
 * can only offer, so this is an anchor click on a blob the browser then puts
 * wherever the person keeps their downloads.
 */
export function download(name: string, mime: string, body: BlobPart): void {
  const blob = new Blob([body], { type: `${mime};charset=utf-8` });
  const url = URL.createObjectURL(blob);
  const a = document.createElement("a");
  a.href = url;
  a.download = name;
  a.rel = "noopener";
  document.body.appendChild(a);
  a.click();
  a.remove();
  // Revoked on the next turn of the loop: doing it synchronously races the
  // download in some browsers.
  setTimeout(() => URL.revokeObjectURL(url), 10_000);
}

/**
 * Put text on the clipboard. `navigator.clipboard` needs a secure context and
 * a recent gesture; the textarea trick is the fallback for everything else,
 * including a page opened over plain http on a local network.
 */
export async function copyText(text: string): Promise<boolean> {
  try {
    if (navigator.clipboard?.writeText) {
      await navigator.clipboard.writeText(text);
      return true;
    }
  } catch {
    // Fall through to the old way.
  }
  try {
    const ta = document.createElement("textarea");
    ta.value = text;
    ta.setAttribute("readonly", "");
    ta.style.position = "fixed";
    ta.style.opacity = "0";
    document.body.appendChild(ta);
    ta.select();
    const ok = document.execCommand("copy");
    ta.remove();
    return ok;
  } catch {
    return false;
  }
}
