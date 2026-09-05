/**
 * The shell around the wasm game.
 *
 * Its whole job is the five things a browser will not delegate: a canvas, a
 * keyboard, Web Audio, somewhere to save, and the clipboard. Every decision
 * about what is *true* — which street is open, whether an answer counts, what
 * a combo pays — is made in `crates/goset-core`.
 *
 * One frame:
 *
 *   1. measure the window and tell the core how wide the world is;
 *   2. step the rules by the frame's time and drain what they asked for;
 *   3. rebuild the view only if the core says something changed;
 *   4. draw it, and let the shell's own animation carry the rest.
 */
import init, { Core } from "./wasm/goset_core.js";

import { Chip } from "./audio/chip";
import { Assets } from "./engine/assets";
import { Input, loveKey, typedText } from "./engine/input";
import { Layout } from "./engine/layout";
import { remeasure } from "./engine/text";
import { inRect, Rect } from "./engine/ui";
import { renderDisk } from "./game/disk";
import { Hits, Renderer } from "./game/render";
import { Strings } from "./game/strings";
import { copyText, download, store } from "./game/store";
import type { CoreEvent, View } from "./game/view";

/** A frame longer than this is a tab that was in the background, not a lag spike. */
const MAX_STEP = 0.05;

/** Is this a device where typing means a soft keyboard? */
function isTouch(): boolean {
  if (window.matchMedia?.("(any-pointer: coarse)").matches) return true;
  return (navigator.maxTouchPoints ?? 0) > 0;
}

/** Something went wrong before there was a game to show it in. */
function fail(view: HTMLCanvasElement, message: string): void {
  const g = view.getContext("2d");
  if (!g) return;
  view.width = 640;
  view.height = 360;
  g.fillStyle = "#141c48";
  g.fillRect(0, 0, view.width, view.height);
  g.textAlign = "center";
  g.fillStyle = "#f878a8";
  g.font = "20px ui-monospace, monospace";
  g.fillText("CAUSEWAYBAY GO", view.width / 2, view.height / 2 - 14);
  g.fillStyle = "#50d8f8";
  g.font = "13px ui-monospace, monospace";
  g.fillText(message, view.width / 2, view.height / 2 + 14);
  document.documentElement.dataset.state = "error";
}

async function boot(): Promise<void> {
  const view = document.querySelector<HTMLCanvasElement>("#view");
  if (!view) throw new Error("missing #view");
  const keys = document.querySelector<HTMLInputElement>("#keys");
  const g = view.getContext("2d", { alpha: false });
  if (!g) return fail(view, "this browser has no 2d canvas");

  // The three downloads that have to be here before anything can be drawn:
  // the rules, the questions and the art.
  let core: Core;
  let art: Assets;
  try {
    await init();
  } catch (err) {
    return fail(view, `wasm did not load: ${String(err)}`);
  }
  try {
    const res = await fetch("data/game.json");
    if (!res.ok) throw new Error(`${res.status} ${res.statusText}`);
    core = new Core(await res.text());
  } catch (err) {
    return fail(view, `the questions did not load: ${String(err)}`);
  }
  try {
    art = await Assets.load("art");
  } catch (err) {
    return fail(view, `the art did not load: ${String(err)}`);
  }

  // Press Start 2P and VT323 are what every panel is measured against, so a
  // frame drawn before they arrive is a frame at the wrong size. The measuring
  // cache is dropped when they land rather than blocking the boot on them.
  void document.fonts?.ready.then(() => remeasure());

  const touch = isTouch();
  const layout = new Layout(view, touch);
  const render = new Renderer(layout, art);
  // An iPhone has no fullscreen API for anything but a video; an iPad and
  // every desktop browser have it for the page.
  const canFullscreen = document.fullscreenEnabled === true;
  render.canFullscreen = canFullscreen;
  const strings = new Strings();
  const input = new Input();
  const chip = new Chip();

  const display = store.loadDisplay();
  if (display) {
    layout.pin(display.mode);
    chip.enabled = display.sound;
  }
  render.sound = chip.enabled;

  const savedProgress = store.loadProgress();
  if (savedProgress) core.load_progress(savedProgress);
  const savedStats = store.loadStats();
  if (savedStats) core.load_stats(savedStats);
  core.set_hour(new Date().getHours());
  strings.load(core.strings());

  let view_: View = JSON.parse(core.view()) as View;
  let lastVersion = core.version();
  let lastLang = view_.lang;

  const saveDisplay = () =>
    store.saveDisplay({ mode: layout.mode, sound: chip.enabled });

  const refresh = (): void => {
    view_ = JSON.parse(core.view()) as View;
    if (view_.lang !== lastLang) {
      lastLang = view_.lang;
      strings.load(core.strings());
    }
    // The street after this one is usually the next background wanted, and it
    // is four hundred kilobytes: start it now rather than on the cut.
    art.prefetch(view_.map.bg, layout.isPortrait());
  };
  refresh();

  // ------------------------------------------------------------ side effects

  const handle = (events: CoreEvent[]): void => {
    for (const ev of events) {
      switch (ev.event) {
        case "sfx":
          chip.play(ev.name, ev.pitch);
          break;
        case "burst": {
          const box = ev.at === "scene" ? render.sceneRect() : render.screenRect();
          render.fx.burst(box.x + box.w * ev.fx, box.y + box.h * ev.fy, ev.n);
          break;
        }
        case "shake":
          render.addShake(ev.amount);
          break;
        case "flash":
          render.addFlash(ev.good, ev.amount);
          break;
        case "fx_small": {
          const box = render.sceneRect();
          render.fx.small(box.x + box.w * ev.fx, box.y + box.h * ev.fy, ev.text);
          render.bounce();
          break;
        }
        case "fx_big":
          render.fx.big(render.sceneRect(), ev.text, ev.perfect);
          break;
        case "fx_quest": {
          const box = render.screenRect();
          render.fx.quest({ x: 0, y: 0, w: box.w, h: box.h * 0.62 }, ev.text);
          break;
        }
        case "fx_clear":
          render.fx.clear();
          break;
        case "pop":
          render.addPop(ev.text, ev.kind);
          break;
        case "pops_clear":
          render.clearPops();
          break;
        case "save":
          store.saveProgress(core.progress());
          store.saveStats(core.stats());
          break;
        case "toast":
          render.setToast(ev.text);
          break;
        case "copy":
          void copyText(ev.text).then((ok) => {
            if (!ok) render.setToast(strings.tf("toast_fail", "clipboard"));
          });
          break;
        case "download":
          if (ev.mime === "image/png") {
            void renderDisk(ev.body, art, view_.track, strings.t("share_png_foot")).then(
              (blob) => {
                if (blob) download(ev.name, "image/png", blob);
                else render.setToast(strings.tf("toast_fail", "png"));
              },
            );
          } else {
            download(ev.name, ev.mime, ev.body);
          }
          break;
      }
    }
  };

  const drain = (): void => {
    const events = JSON.parse(core.events()) as CoreEvent[];
    if (events.length > 0) handle(events);
    if (core.version() !== lastVersion) {
      lastVersion = core.version();
      refresh();
    }
  };

  // ------------------------------------------------------------------ input

  // Audio cannot start before a gesture, and any gesture will do — though
  // Safari on a phone only counts the end of a touch, not the start.
  const wake = () => chip.ensure();
  for (const type of ["pointerdown", "pointerup", "keydown", "touchstart", "touchend"] as const) {
    window.addEventListener(type, wake, { passive: true });
  }

  const stage = view.parentElement ?? view;
  const toggleFullscreen = (): void => {
    if (!canFullscreen) return;
    if (!document.fullscreenElement) void stage.requestFullscreen?.().catch(() => {});
    else void document.exitFullscreen().catch(() => {});
  };

  /**
   * The soft keyboard and the visual viewport.
   *
   * When a phone's keyboard comes up the page does not get shorter: the
   * layout viewport stays the size of the screen and the *visual* viewport
   * shrinks to the part above the keys. Left alone, that hides the bottom of
   * the game — the prompt and the buttons, the very things being typed into.
   * So the stage is slid up by however much is covered, and the scene at the
   * top goes behind the status bar instead. Sizing the game to the visible
   * part would be worse: half a phone screen is a landscape shape, and the
   * whole layout would turn on its side every time a key was pressed.
   */
  const vv = window.visualViewport;
  const fitStage = (): void => {
    if (!vv) return;
    const hidden = Math.max(0, Math.round(window.innerHeight - vv.height));
    const shift = Math.round(vv.offsetTop) - hidden;
    stage.style.transform = shift !== 0 ? `translateY(${shift}px)` : "";
  };
  vv?.addEventListener("resize", fitStage);
  vv?.addEventListener("scroll", fitStage);
  window.addEventListener("resize", fitStage);
  document.addEventListener("fullscreenchange", () => {
    render.fullscreen = document.fullscreenElement !== null;
  });

  /**
   * The soft keyboard.
   *
   * A phone has no keys until something on the page has focus, so tapping the
   * canvas while a blank is open focuses a field nobody can see. The field is
   * kept equal to the answer as the core has it, and whenever the keyboard
   * changes it the difference is what gets typed: the characters that came
   * off the end are backspaces, the ones that went on are text.
   *
   * Mirroring, rather than emptying the field after every character, is what
   * makes a phone keyboard work at all. Backspace on an empty field is not an
   * event in iOS — there is nothing to delete, so nothing is reported — and
   * on Android it is a `keydown` with no key in it. With the answer in the
   * field, backspace is a shorter value, and that is always reported. It is
   * also what makes an IME work: a Korean or Japanese keyboard composes into
   * the field and the finished text is diffed when the composition ends.
   */
  const typing = (): boolean =>
    view_.state === "play" && !view_.solved && !view_.sheet;

  const focusKeys = (): void => {
    if (!keys || !touch) return;
    if (typing()) {
      if (document.activeElement !== keys) keys.focus({ preventScroll: true });
    } else if (document.activeElement === keys) {
      keys.blur();
    }
  };

  /** What the field held after it was last brought level with the core. */
  let mirrored = "";
  let composing = false;

  const syncKeys = (): void => {
    if (!keys || composing) return;
    mirrored = view_.input;
    if (keys.value !== mirrored) {
      keys.value = mirrored;
      try {
        keys.setSelectionRange(mirrored.length, mirrored.length);
      } catch {
        // A field that is not focused may refuse; the caret does not matter then.
      }
    }
  };

  const takeKeys = (): void => {
    if (!keys || composing) return;
    const now = keys.value;
    if (now === mirrored) return;
    const was = [...mirrored];
    const is = [...now];
    let p = 0;
    while (p < was.length && p < is.length && was[p] === is[p]) p++;
    for (let i = p; i < was.length; i++) core.key("backspace");
    for (let i = p; i < is.length; i++) {
      const ch = is[i];
      if (ch === "\n" || ch === "\r") core.key("return");
      else core.text(ch);
    }
    mirrored = now;
    drain();
    // The core may not have taken everything — a submit empties the answer —
    // so the field is brought level with it again rather than trusted.
    syncKeys();
  };

  keys?.addEventListener("input", takeKeys);
  keys?.addEventListener("compositionstart", () => {
    composing = true;
  });
  keys?.addEventListener("compositionend", () => {
    composing = false;
    takeKeys();
  });

  window.addEventListener("keydown", (ev) => {
    const key = loveKey(ev);
    if (key) input.track(key, true);

    // The window chrome is the shell's, not the game's: F11, F1, F3 and F4
    // change how the page is shown rather than what is happening in it.
    if (key === "f11") {
      ev.preventDefault();
      chip.play("toggle");
      toggleFullscreen();
      return;
    }
    if (key === "f1") {
      ev.preventDefault();
      chip.play("toggle");
      layout.toggleOrientation();
      saveDisplay();
      return;
    }
    if (key === "f3") {
      ev.preventDefault();
      core.cycle_lang();
      chip.play("lang");
      drain();
      refresh();
      return;
    }
    if (key === "f4") {
      ev.preventDefault();
      render.sound = chip.toggle();
      saveDisplay();
      return;
    }

    if (key && core.key(key)) ev.preventDefault();
    else if (document.activeElement !== keys) {
      // With the hidden field focused the `input` event above is the one that
      // carries the character; taking it from here as well would type it twice.
      const text = typedText(ev);
      if (text) {
        core.text(text);
        ev.preventDefault();
      }
    }
    drain();
    syncKeys();
    focusKeys();
  });

  window.addEventListener("keyup", (ev) => {
    const key = loveKey(ev);
    if (key) input.track(key, false);
  });
  window.addEventListener("blur", () => input.releaseAll());

  view.addEventListener("pointermove", (ev) => {
    render.mouse = layout.toVirtual(ev.clientX, ev.clientY);
  });
  view.addEventListener("pointerleave", () => {
    render.mouse = null;
  });
  view.addEventListener("contextmenu", (ev) => ev.preventDefault());
  view.addEventListener("dblclick", (ev) => {
    // Two quick taps on a phone are two taps, not a request for fullscreen.
    if (!touch) toggleFullscreen();
    ev.preventDefault();
  });

  const clickAt = (vx: number, vy: number): void => {
    const hits = render.hits;
    const v = view_;

    if (inRect(vx, vy, hits.hudSound)) {
      render.sound = chip.toggle();
      saveDisplay();
      return;
    }
    if (inRect(vx, vy, hits.hudLang)) {
      core.cycle_lang();
      chip.play("lang");
      return;
    }
    if (inRect(vx, vy, hits.hudMap)) {
      if (v.state === "map") core.leave_map();
      else core.enter_map();
      return;
    }
    if (inRect(vx, vy, hits.hudFull)) {
      chip.play("toggle");
      toggleFullscreen();
      return;
    }
    if (inRect(vx, vy, hits.hudOri)) {
      chip.play("toggle");
      layout.toggleOrientation();
      saveDisplay();
      return;
    }

    if (v.state === "map") {
      for (const [r, id] of hits.trackBtns) {
        if (inRect(vx, vy, r)) return core.set_track(id);
      }
      for (const [r, q] of hits.questTabs) {
        if (inRect(vx, vy, r)) return core.set_quest(q);
      }
      for (let i = 0; i < hits.mapDots.length; i++) {
        if (inRect(vx, vy, hits.mapDots[i])) {
          core.set_map_cursor(i);
          core.enter_play(i);
          return;
        }
      }
      return;
    }

    if (v.state === "title" || v.state === "win") {
      core.enter_map();
      return;
    }

    // Play.
    if (v.sheet) {
      for (const [r, id] of hits.sheetBtns) {
        if (inRect(vx, vy, r)) return core.sheet_action(id);
      }
      if (!inRect(vx, vy, hits.sheetRect)) core.close_sheet();
      return;
    }
    const buttons: Array<[Rect | null, string]> = [
      [hits.share, "share"],
      [hits.auto, "auto"],
      [hits.hint, "hint"],
      [hits.ok, v.solved ? "next" : "ok"],
      [hits.enter, "ok"],
      [hits.prevStage, "prev_stage"],
      [hits.nextStage, "next_stage"],
    ];
    for (const [r, id] of buttons) {
      if (inRect(vx, vy, r)) return core.action(id);
    }
    for (let i = 0; i < hits.stations.length; i++) {
      if (inRect(vx, vy, hits.stations[i])) {
        if (i !== v.step) core.enter_play(i);
        return;
      }
    }
    if (inRect(vx, vy, hits.mapBtn)) core.action("map");
  };

  view.addEventListener("pointerdown", (ev) => {
    if (ev.button !== 0 && ev.pointerType === "mouse") return;
    const at = layout.toVirtual(ev.clientX, ev.clientY);
    if (!at) return;
    render.mouse = at;
    // Also keeps a tap on the canvas from taking focus off the hidden field,
    // which would put the keyboard away between one letter and the next.
    ev.preventDefault();
    clickAt(at[0], at[1]);
    drain();
    syncKeys();
  });

  // A tap is the gesture that may raise the keyboard, and it has to happen
  // inside the handler or the browser will not treat it as user-initiated.
  // Safari on iOS counts the end of the touch and not the start, so this is
  // on pointerup, with click behind it for a browser that swallows the one.
  view.addEventListener("pointerup", (ev) => {
    focusKeys();
    // A finger is not hovering over the button it just lifted from.
    if (ev.pointerType !== "mouse") render.mouse = null;
  });
  view.addEventListener("click", focusKeys);

  // ------------------------------------------------------------- the frame

  // Deliberately public: the end-to-end suite asks the game what it thinks is
  // happening rather than reading pixels back off the canvas, and the dev
  // tools console is the other place this earns its keep.
  const debug = window as unknown as {
    __view: () => string;
    __hits: () => Hits;
    __toClient: (r: Rect) => [number, number];
  };
  debug.__view = () => core.view();
  // The hit boxes, and the middle of one in window coordinates: how a test
  // taps a button it cannot see without knowing where the renderer put it.
  debug.__hits = () => render.hits;
  debug.__toClient = (r) => layout.toClient(r[0] + r[2] * 0.5, r[1] + r[3] * 0.5);

  document.documentElement.dataset.state = view_.state;
  let lastShownState = view_.state;
  let last = performance.now();

  const frame = (now: number): void => {
    const dt = Math.min(MAX_STEP, Math.max(0, (now - last) / 1000));
    last = now;

    layout.measure();
    core.set_viewport(layout.vw);
    core.set_held(input.left, input.right);
    core.update(dt);
    drain();

    render.update(dt, view_);
    if (view_.state !== lastShownState) {
      lastShownState = view_.state;
      focusKeys();
    }
    // AUTO types on the core's side of the mirror; the field follows it.
    if (keys && !composing && keys.value !== view_.input) syncKeys();
    render.draw(g, view_, core.anim(), strings);

    // The screen the game is on, published on the document so an end-to-end
    // test can see it without reading pixels back off the canvas.
    if (document.documentElement.dataset.state !== view_.state) {
      document.documentElement.dataset.state = view_.state;
    }
    requestAnimationFrame(frame);
  };
  requestAnimationFrame(frame);
}

void boot();
