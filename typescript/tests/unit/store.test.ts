import { beforeEach, describe, expect, it, vi } from "vitest";

import { store } from "../../src/game/store";
import { Input, loveKey, typedText } from "../../src/engine/input";

beforeEach(() => {
  window.localStorage.clear();
});

describe("the save", () => {
  it("comes back the way it went in", () => {
    store.saveProgress('{"quest":3,"step":2}');
    expect(store.loadProgress()).toBe('{"quest":3,"step":2}');
  });

  it("is null on a first visit", () => {
    expect(store.loadProgress()).toBeNull();
    expect(store.loadStats()).toBeNull();
    expect(store.loadDisplay()).toBeNull();
  });

  it("keeps the window and the sound, and rejects a record it cannot use", () => {
    store.saveDisplay({ mode: "portrait", sound: false });
    expect(store.loadDisplay()).toEqual({ mode: "portrait", sound: false });

    window.localStorage.setItem("causewaybaygo.display", '{"mode":"sideways"}');
    expect(store.loadDisplay()).toBeNull();
    window.localStorage.setItem("causewaybaygo.display", "not json at all");
    expect(store.loadDisplay()).toBeNull();
  });

  it("does not take the game down when storage throws", () => {
    // A browser set to block site data throws on the accessor itself, which is
    // a reason to forget the save, not a reason to refuse to play.
    const blocked = () => {
      throw new Error("blocked");
    };
    const setItem = vi.spyOn(window.localStorage, "setItem").mockImplementation(blocked);
    const getItem = vi.spyOn(window.localStorage, "getItem").mockImplementation(blocked);
    expect(() => store.saveProgress("{}")).not.toThrow();
    expect(store.loadProgress()).toBeNull();
    setItem.mockRestore();
    getItem.mockRestore();
  });
});

describe("keys, in the names the core knows", () => {
  const ev = (init: KeyboardEventInit) => new KeyboardEvent("keydown", init);

  it("translates the named ones the way LÖVE spells them", () => {
    expect(loveKey(ev({ key: "Enter" }))).toBe("return");
    expect(loveKey(ev({ key: "Enter", code: "NumpadEnter" }))).toBe("kpenter");
    expect(loveKey(ev({ key: "Escape" }))).toBe("escape");
    expect(loveKey(ev({ key: " " }))).toBe("space");
    expect(loveKey(ev({ key: "ArrowLeft" }))).toBe("left");
    expect(loveKey(ev({ key: "PageDown" }))).toBe("pagedown");
    expect(loveKey(ev({ key: "F6" }))).toBe("f6");
  });

  it("lowercases a letter, so shift-Q is still the quest key", () => {
    expect(loveKey(ev({ key: "Q" }))).toBe("q");
    expect(loveKey(ev({ key: "3" }))).toBe("3");
  });

  it("has no name for a dead key or a modifier", () => {
    expect(loveKey(ev({ key: "Shift" }))).toBeNull();
    expect(loveKey(ev({ key: "Unidentified" }))).toBeNull();
  });

  it("passes a typed character through, but not a shortcut", () => {
    expect(typedText(ev({ key: "m" }))).toBe("m");
    expect(typedText(ev({ key: "가" }))).toBe("가");
    expect(typedText(ev({ key: "a", metaKey: true }))).toBeNull();
    expect(typedText(ev({ key: "Enter" }))).toBeNull();
  });
});

describe("held arrows", () => {
  it("track both the arrows and the WASD they alias", () => {
    const input = new Input();
    input.track("left", true);
    expect(input.left).toBe(true);
    input.track("left", false);
    expect(input.left).toBe(false);
    input.track("d", true);
    expect(input.right).toBe(true);
  });

  it("are all released when the window loses focus", () => {
    // Otherwise Alex walks off on his own while the tab is in the background:
    // the keyup lands somewhere else.
    const input = new Input();
    input.track("right", true);
    input.releaseAll();
    expect(input.right).toBe(false);
  });
});
