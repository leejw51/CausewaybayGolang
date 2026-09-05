import { describe, expect, it } from "vitest";

import { Strings } from "../../src/game/strings";

function loaded(table: Record<string, string>): Strings {
  const s = new Strings();
  s.load(JSON.stringify(table));
  return s;
}

describe("the string table", () => {
  it("fills %s and %d in order", () => {
    const s = loaded({ clear_count: "%d / %d clear", map_help: "ARROWS walk    %s" });
    expect(s.tf("clear_count", 3, 7)).toBe("3 / 7 clear");
    expect(s.tf("map_help", "ESC title")).toBe("ARROWS walk    ESC title");
  });

  it("keeps a literal percent", () => {
    expect(loaded({ k: "100%% sure" }).tf("k")).toBe("100% sure");
  });

  it("leaves a specifier with no argument alone", () => {
    // A translation with one %s too many should look wrong on screen, not
    // silently swallow the rest of the line.
    expect(loaded({ k: "%s and %s" }).tf("k", "one")).toBe("one and %s");
  });

  it("gives an unknown key back as itself", () => {
    const s = loaded({});
    expect(s.t("title_enter")).toBe("title_enter");
    expect(s.tf("title_enter", 1)).toBe("title_enter");
  });

  it("survives a table that is not JSON at all", () => {
    const s = new Strings();
    s.load("<!doctype html>");
    expect(s.t("hint")).toBe("hint");
  });

  it("replaces the whole table on a language change", () => {
    const s = loaded({ hint: "HINT" });
    expect(s.t("hint")).toBe("HINT");
    s.load(JSON.stringify({ hint: "힌트" }));
    expect(s.t("hint")).toBe("힌트");
  });
});
