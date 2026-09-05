/**
 * The little animated scene behind each street, from the `Game.viz` table in
 * `love2d/src/game.lua`.
 *
 * The Go track's twenty-eight streets each get a hand-drawn one — a lift
 * counting floors, a channel passing a token, a BFS wave rolling through MTR
 * stations, bars settling into sorted order. The Rust, Python and BIG O tracks
 * describe theirs in the data instead, as a column of `chips` and a `note`,
 * and share the generic scene at the bottom of this file.
 *
 * Everything is drawn in world coordinates inside the scene band: the caller
 * has already translated by the camera, so x is a position along the street
 * and y is measured down from the top of the band.
 */
import { clamp, cosine, expOut, lerp } from "../engine/ease";
import { Assets } from "../engine/assets";
import { font, width as textWidth } from "../engine/text";
import { css, RGBA, Theme } from "../engine/theme";
import { Ctx, printf, roundRect } from "../engine/ui";
import { drawItem, drawMascot } from "./sprites";
import type { MapView } from "./view";

const GOLDBG: RGBA = [0.2, 0.16, 0.06, 0.95];
const PINKBG: RGBA = [0.2, 0.06, 0.12, 0.95];
const GREENBG: RGBA = [0.05, 0.22, 0.1, 0.95];
const REDBG: RGBA = [0.3, 0.05, 0.05, 0.95];
const DARKBG: RGBA = [0.08, 0.1, 0.22, 0.95];
const FADED: RGBA = [1, 1, 1, 0.35];

/** What a scene is handed: the clock, the street, and how far into it we are. */
export interface Scene {
  g: Ctx;
  art: Assets;
  /** Seconds since boot. */
  t: number;
  /** Seconds this street has been open, for the things that rise on entry. */
  mapT: number;
  stage: number;
  solved: boolean;
  /** 0..1 as the CLEAR stamp lands. */
  stamp: number;
  track: string;
  map: MapView;
}

/** A rounded label: ink edge, a fill and centred text. */
function chip(
  s: Scene,
  x: number,
  y: number,
  w: number,
  h: number,
  text: string,
  fill: RGBA = Theme.paper,
  col: RGBA = Theme.cream,
  fontName: "ui" | "small" | "stamp" | "codeSm" = "ui",
): void {
  const { g } = s;
  const f = font(fontName);
  g.fillStyle = css(Theme.ink, 0.9);
  roundRect(g, x, y, w, h, 6);
  g.fill();
  g.fillStyle = css(fill);
  roundRect(g, x + 2, y + 2, w - 4, h - 4, 5);
  g.fill();
  g.fillStyle = css(col);
  printf(g, f, text, x, y + Math.floor((h - f.height) * 0.5), w, "center");
}

/** Curls of steam rising off something hot. */
function steam(s: Scene, x: number, y: number, n: number): void {
  const { g, t } = s;
  for (let i = 1; i <= n; i++) {
    const a = 0.15 + 0.25 * (0.5 + 0.5 * Math.sin(t * (1.6 + i * 0.4) + i));
    const ox = Math.sin(t * 1.3 + i) * 10;
    const oy = -((t * 18 + i * 17) % 50);
    g.fillStyle = `rgba(255,255,255,${a})`;
    g.beginPath();
    g.ellipse(x + ox + i * 8, y + oy, 10 + i, 6, 0, 0, Math.PI * 2);
    g.fill();
  }
}

function rect(s: Scene, col: RGBA, a: number, x: number, y: number, w: number, h: number, r = 0) {
  s.g.fillStyle = css(col, a);
  if (r > 0) {
    roundRect(s.g, x, y, w, h, r);
    s.g.fill();
  } else {
    s.g.fillRect(x, y, w, h);
  }
}

function note(s: Scene, text: string, x: number, y: number, col: RGBA = Theme.coin, a = 0.9) {
  s.g.fillStyle = css(col, a);
  printf(s.g, font("small"), text, x, y, 900, "left");
}

function line(s: Scene, col: RGBA, a: number, w: number, pts: number[][]): void {
  const { g } = s;
  g.strokeStyle = css(col, a);
  g.lineWidth = w;
  g.beginPath();
  g.moveTo(pts[0][0], pts[0][1]);
  for (let i = 1; i < pts.length; i++) g.lineTo(pts[i][0], pts[i][1]);
  g.stroke();
  g.lineWidth = 1;
}

function circle(s: Scene, col: RGBA, a: number, x: number, y: number, r: number): void {
  s.g.fillStyle = css(col, a);
  s.g.beginPath();
  s.g.arc(x, y, r, 0, Math.PI * 2);
  s.g.fill();
}

// ------------------------------------------------------- Quest 1: the walk

const SCENES: Record<string, (s: Scene) => void> = {
  street(s) {
    for (let i = 1; i <= 6; i++) {
      const x = 240 + i * 180;
      const a = 0.35 + 0.65 * (0.5 + 0.5 * Math.cos(s.t * (2 + i * 0.37) + i));
      rect(s, [1, 0.2, 0.55, 1], a * 0.45, x, 70, 70, 18, 3);
      rect(s, [0, 0.9, 1, 1], a * 0.35, x + 8, 96, 50, 12, 3);
    }
  },

  flat(s) {
    steam(s, 980, 90, 4);
    const k = expOut(Math.min(1, s.mapT * 0.8));
    chip(s, 360, 70, 220, 36, "package main", Theme.paper, Theme.cyan);
    chip(s, 360, 116, 220, 36, 'import "fmt"', GOLDBG, Theme.coin);
    rect(s, Theme.coin, 0.35 + 0.45 * k, 620, 88, Math.floor(180 * k), 6);
  },

  lift(s) {
    const floor = 1 + Math.floor((s.t * 0.7) % 8);
    chip(s, 420, 70, 140, 90, String(floor), DARKBG, Theme.coin, "stamp");
    note(s, ":=  const  0", 580, 100, Theme.cream, 0.85);
    steam(s, 900, 80, 3);
  },

  mtr(s) {
    const x = lerp(300, 980, cosine((s.t * 0.35) % 1));
    rect(s, Theme.coin, 0.9, x, 110, 90, 36, 6);
    s.g.fillStyle = css(Theme.ink);
    printf(s.g, font("ui"), "tap", x, 118, 90, "center");
    chip(s, 300, 170, 160, 32, "ok, err", Theme.paper, Theme.cyan);
    chip(s, 900, 170, 160, 32, "_ , err", PINKBG, Theme.pink);
  },

  times(s) {
    const n = s.solved || s.stage >= 3 ? 5 : 1 + Math.min(3, s.stage);
    for (let i = 1; i <= 5; i++) {
      const x = 280 + (i - 1) * 130;
      const on = i <= n;
      const rise = expOut(clamp((s.mapT - i * 0.1) / 0.4, 0, 1));
      const h = 36 + 70 * rise;
      rect(s, on ? [0.79, 0.64, 0.36, 1] : [0.15, 0.2, 0.35, 1], on ? 0.9 : 0.8, x, 196 - h, 44, h, 4);
      s.g.fillStyle = "rgba(255,255,255,0.9)";
      printf(s.g, font("ui"), on ? "[]" : "", x, 204, 44, "center");
    }
    drawItem(s.g, s.art, "item_hashbrown", 1100, 120 + Math.sin(s.t * 2) * 8, 48, s.t * 0.2);
  },

  sogo(s) {
    const keys = ["muffin", "hash", "coffee"];
    keys.forEach((name, i) => {
      const y = 60 + i * 48;
      chip(s, 320, y, 200, 36, name, Theme.paper, Theme.cream);
      chip(s, 540, y, 90, 36, String(8 + (i + 1) * 4), GOLDBG, Theme.coin);
      const pulse = 0.4 + 0.6 * (0.5 + 0.5 * Math.cos(s.t * 3 + i + 1));
      rect(s, Theme.cyan, 0.35 * pulse, 320, y, 310, 36);
    });
  },

  queue(s) {
    steam(s, 1000, 70, 5);
    chip(s, 300, 60, 220, 36, "type Order struct", Theme.paper, Theme.cyan);
    chip(s, 300, 108, 220, 36, "*Order", PINKBG, Theme.pink);
    chip(s, 300, 156, 220, 36, "interface", GOLDBG, Theme.coin);
    drawItem(s.g, s.art, "item_set", 980, 140 + Math.sin(s.t * 2) * 6, 56, Math.sin(s.t) * 0.08);
  },

  till(s) {
    chip(s, 320, 70, 200, 40, "err != nil", REDBG, Theme.red);
    chip(s, 560, 70, 200, 40, "defer Close", GREENBG, Theme.admit);
    if (s.solved) {
      const k = expOut(s.stamp);
      s.g.fillStyle = `rgba(56,158,97,${0.4 + 0.6 * k})`;
      printf(s.g, font("stamp"), "OK", 820, 80, 200, "center");
    }
    steam(s, 900, 120, 3);
  },

  // ------------------------------------------------ Quest 2: the kitchen

  kitchen(s) {
    for (let i = 1; i <= 3; i++) {
      const x = 320 + (i - 1) * 220;
      const bob = Math.sin(s.t * 6 + i) * 10;
      chip(s, x, 80 + bob, 160, 36, "go fry()", PINKBG, Theme.pink);
      steam(s, x + 40, 70 + bob, 2);
    }
    note(s, "three goroutines, one kitchen", 320, 180);
  },

  pass(s) {
    const x1 = 300;
    const x2 = 980;
    const x = lerp(x1, x2, cosine((s.t * 0.5) % 1));
    rect(s, Theme.cyan, 0.9, x1, 128, x2 - x1, 6);
    circle(s, Theme.cyan, 0.9, x, 131, 18);
    s.g.fillStyle = css(Theme.ink);
    printf(s.g, font("ui"), "<-", x - 20, 118, 40, "center");
    chip(s, 280, 170, 140, 32, "send", Theme.paper, Theme.cyan);
    chip(s, 920, 170, 140, 32, "recv", GOLDBG, Theme.coin);
  },

  bell(s) {
    const labels = ["muffin", "hash", "default"];
    const cols = [Theme.cyan, Theme.coin, Theme.pink];
    const lit = Math.floor(s.t * 1.4) % 3;
    for (let i = 0; i < 3; i++) {
      chip(s, 300 + i * 240, 80, 200, 50, labels[i], i === lit ? GOLDBG : Theme.paper, cols[i]);
    }
    note(s, "select  {  case  /  default  }", 300, 160);
  },

  tray(s) {
    const lock = 0.5 + 0.5 * Math.cos(s.t * 4);
    chip(s, 320, 70, 200, 40, "Mutex", [0.2, 0.16, 0.06, 0.95 * (0.6 + 0.4 * lock)], Theme.coin);
    const n = 1 + Math.floor((s.t * 0.8) % 3);
    chip(s, 560, 70, 240, 40, `WaitGroup ${n}`, Theme.paper, Theme.cyan);
    for (let i = 1; i <= 2; i++) {
      const x = 320 + (i - 1) * 280;
      drawItem(s.g, s.art, "item_hashbrown", x + 80, 150 + Math.sin(s.t * 3 + i) * 6, 40, 0);
    }
  },

  table(s) {
    chip(s, 300, 60, 220, 36, "[T any]", Theme.paper, Theme.cyan);
    chip(s, 300, 108, 220, 36, "Kitchen { Grill }", GOLDBG, Theme.coin);
    chip(s, 300, 156, 220, 36, "closure", PINKBG, Theme.pink);
    drawItem(s.g, s.art, "item_set", 980, 130 + Math.sin(s.t * 2) * 8, 64, Math.sin(s.t) * 0.1);
  },

  set(s) {
    steam(s, 860, 60, 6);
    const k = s.solved ? expOut(s.stamp) : 0.25;
    drawItem(
      s.g,
      s.art,
      "item_set",
      640,
      120 - k * 16 + Math.sin(s.t * 2) * 6,
      48 + 40 * k,
      Math.sin(s.t) * 0.05,
    );
    if (s.solved) {
      const kk = expOut(s.stamp);
      s.g.save();
      s.g.translate(640, 70);
      s.g.rotate(-0.12);
      s.g.scale(0.5 + 0.5 * kk, 0.5 + 0.5 * kk);
      s.g.strokeStyle = `rgba(56,158,97,${kk})`;
      s.g.lineWidth = 2;
      roundRect(s.g, -110, -28, 220, 56, 6);
      s.g.stroke();
      s.g.fillStyle = `rgba(56,158,97,${kk})`;
      printf(s.g, font("stamp"), "SERVED", -110, -22, 220, "center");
      s.g.restore();
    }
    chip(s, 280, 170, 220, 32, "Background()", Theme.paper, Theme.cyan);
    chip(s, 520, 170, 220, 32, "TestOrder", GREENBG, Theme.admit);
  },

  // ------------------------------------------- Quest 3: the delivery app

  runes(s) {
    const glyphs = [...new Intl.Segmenter().segment("銅鑼灣")].map((x) => x.segment);
    const lit = Math.floor((s.t * 1.2) % 3);
    glyphs.forEach((ch, i) => {
      const x = 320 + i * 150;
      const on = i === lit;
      chip(s, x, 70, 120, 48, ch, on ? GOLDBG : Theme.paper, on ? Theme.coin : Theme.cream);
      chip(s, x, 126, 120, 30, "3 bytes", PINKBG, Theme.pink, "small");
    });
    note(s, `len = ${glyphs.length * 3}   runes = ${glyphs.length}`, 320, 170);
    steam(s, 980, 80, 3);
  },

  errs(s) {
    const k = expOut(Math.min(1, s.mapT * 0.6));
    const labels = ["ErrCold", "%w", "Is / As"];
    for (let i = 0; i < 3; i++) {
      const x = 300 + i * 230;
      const rise = clamp(k * 3 - i, 0, 1);
      chip(
        s,
        x,
        80 + (1 - rise) * 20,
        200,
        40,
        labels[i],
        i === 0 ? REDBG : Theme.paper,
        i === 0 ? Theme.red : Theme.cyan,
      );
      if (i < 2) rect(s, Theme.coin, 0.8 * rise, x + 204, 98, 22, 4);
    }
    note(s, "errors.New  ->  fmt.Errorf(%w)  ->  errors.Is", 300, 150);
  },

  types(s) {
    const rows: Array<[string, RGBA]> = [
      ["any", Theme.cyan],
      [".(string)", Theme.coin],
      ["switch .(type)", Theme.pink],
    ];
    const lit = Math.floor(s.t * 1.1) % 3;
    rows.forEach(([text, col], i) => {
      chip(s, 320, 60 + i * 46, 260, 36, text, i === lit ? GOLDBG : Theme.paper, col);
    });
    chip(s, 620, 60, 200, 36, "int  18", Theme.paper, Theme.cream);
    chip(s, 620, 106, 200, 36, "string  set", Theme.paper, Theme.cream);
    chip(s, 620, 152, 200, 36, "bool  true", Theme.paper, Theme.cream);
  },

  json(s) {
    const x = lerp(300, 900, cosine((s.t * 0.6) % 1));
    chip(s, 280, 70, 230, 40, '{"dish":"set"}', PINKBG, Theme.pink, "small");
    chip(s, 880, 70, 230, 40, "Order{Item: set}", Theme.paper, Theme.cyan, "small");
    rect(s, Theme.coin, 0.9, 510, 88, 370, 4);
    circle(s, Theme.coin, 0.9, x, 90, 10);
    note(s, "Unmarshal  ->", 560, 120);
    note(s, "<-  Marshal", 720, 120);
    chip(s, 520, 150, 260, 30, 'Item string `json:"dish"`', GOLDBG, Theme.coin, "small");
  },

  http(s) {
    const lit = Math.floor(s.t * 1.6) % 3;
    const labels = ["GET /order", "serve(w, r)", "200 served"];
    for (let i = 0; i < 3; i++) {
      const x = 300 + i * 250;
      chip(
        s,
        x,
        80,
        220,
        44,
        labels[i],
        i === lit ? GOLDBG : Theme.paper,
        i === lit ? Theme.coin : Theme.cyan,
      );
      if (i < 2) rect(s, Theme.coin, i < lit ? 0.9 : 0.3, x + 224, 100, 22, 4);
    }
    note(s, 'http.HandleFunc  ·  ListenAndServe(":8080")', 300, 150);
  },

  tools(s) {
    const cmds = ["go mod tidy", "go vet ./...", "go build -o delivery ."];
    const done = Math.floor((s.t * 0.7) % 4);
    cmds.forEach((c, i) => {
      const ok = i + 1 <= done;
      chip(
        s,
        320,
        60 + i * 44,
        330,
        34,
        `$ ${c}`,
        ok ? GREENBG : Theme.paper,
        ok ? Theme.admit : Theme.cream,
        "small",
      );
    });
    drawItem(s.g, s.art, "item_set", 980, 120 + Math.sin(s.t * 2) * 6, 56, Math.sin(s.t) * 0.08);
  },

  modern(s) {
    steam(s, 900, 60, 5);
    const labels = ["slices.Sort", "maps.Keys", "min / max", "iter.Seq"];
    labels.forEach((l, i) => {
      const x = 300 + (i % 2) * 240;
      const y = 60 + Math.floor(i / 2) * 50;
      const pulse = 0.5 + 0.5 * Math.cos(s.t * 2 + i + 1);
      chip(s, x, y, 220, 38, l, Theme.paper, [
        Theme.coin[0],
        Theme.coin[1],
        Theme.coin[2],
        0.6 + 0.4 * pulse,
      ]);
    });
    note(s, "Go 1.21 - 1.23", 300, 166);
  },

  // ------------------------------------------------- Quest 4: CODE RUSH

  recurse(s) {
    // A call stack of fact(n) pushing up and popping back down.
    const depth = 5;
    const phase = (s.t * 0.9) % (depth * 2);
    const live = phase < depth ? Math.floor(phase) + 1 : depth - Math.floor(phase - depth);
    for (let i = 1; i <= depth; i++) {
      const on = i <= live;
      chip(
        s,
        340,
        190 - (i - 1) * 30,
        170,
        26,
        `fact(${depth - i + 1})`,
        on ? GOLDBG : Theme.paper,
        on ? Theme.coin : FADED,
        "small",
      );
    }
    chip(s, 560, 70, 200, 30, "memo[n]  ->  hit", PINKBG, Theme.pink, "small");
    note(s, "push . . . base case . . . pop", 560, 120);
    steam(s, 980, 80, 3);
  },

  tree(s) {
    // Nodes appear top-down, in insert order.
    const nodes = [
      [640, 60, 25],
      [520, 110, 18],
      [760, 110, 40],
      [460, 160, 12],
      [580, 160, 21],
      [820, 160, 55],
    ];
    const edges = [
      [0, 1],
      [0, 2],
      [1, 3],
      [1, 4],
      [2, 5],
    ];
    const shown = Math.floor((s.t * 1.1) % (nodes.length + 1));
    for (const [a, b] of edges) {
      if (b < shown) {
        line(s, Theme.coin, 0.8, 3, [
          [nodes[a][0], nodes[a][1]],
          [nodes[b][0], nodes[b][1]],
        ]);
      }
    }
    nodes.forEach((nd, i) => {
      if (i >= shown) return;
      circle(s, Theme.ink, 1, nd[0], nd[1], 17);
      circle(s, i === shown - 1 ? Theme.pink : Theme.coin, 1, nd[0], nd[1], 13);
      s.g.fillStyle = css(Theme.ink);
      printf(s.g, font("small"), String(nd[2]), nd[0] - 20, nd[1] - 7, 40, "center");
    });
    note(s, "left < node <= right", 300, 190);
  },

  graph(s) {
    // A BFS wave rolling through MTR stations.
    const st = [
      [320, 100],
      [460, 70],
      [460, 150],
      [600, 100],
      [740, 70],
      [740, 150],
      [880, 110],
    ];
    const edges = [
      [0, 1],
      [0, 2],
      [1, 3],
      [2, 3],
      [3, 4],
      [3, 5],
      [4, 6],
      [5, 6],
    ];
    const level = [0, 1, 1, 2, 3, 3, 4];
    const wave = (s.t * 1.3) % 6;
    for (const [a, b] of edges) {
      line(s, Theme.cream, 0.5, 3, [
        [st[a][0], st[a][1]],
        [st[b][0], st[b][1]],
      ]);
    }
    st.forEach((p, i) => {
      const lit = level[i] <= wave;
      const now = Math.abs(level[i] - wave) < 0.5;
      circle(s, Theme.ink, 1, p[0], p[1], 15);
      circle(s, now ? Theme.pink : lit ? Theme.admit : Theme.paper, 1, p[0], p[1], 11);
    });
    note(s, `BFS: level ${Math.floor(wave)}    queue = queue[1:]`, 320, 180);
  },

  list(s) {
    // Arrows flip one by one: the list reverses in place.
    const n = 5;
    const flipped = Math.floor((s.t * 1.2) % (n + 1));
    for (let i = 1; i <= n; i++) {
      const x = 320 + (i - 1) * 130;
      const on = i <= flipped;
      chip(s, x, 100, 70, 34, String(i * 7), on ? GOLDBG : Theme.paper, on ? Theme.coin : Theme.cyan);
      if (i < n) {
        let ax1 = x + 76;
        let ax2 = x + 124;
        if (on) [ax1, ax2] = [ax2, ax1];
        const d = ax2 > ax1 ? 1 : -1;
        const col = on ? Theme.coin : Theme.cream;
        line(s, col, 0.9, 3, [
          [ax1, 117],
          [ax2, 117],
        ]);
        line(s, col, 0.9, 3, [
          [ax2 - d * 8, 111],
          [ax2, 117],
          [ax2 - d * 8, 123],
        ]);
      }
    }
    note(s, "prev  <-  cur  ->  next        slow x1   fast x2", 320, 160);
  },

  sort(s) {
    // Bars settle into order, then a binary search homes in.
    const vals = [5, 2, 8, 1, 9, 3, 7, 4, 6];
    const sorted = [1, 2, 3, 4, 5, 6, 7, 8, 9];
    const cycle = s.t % 6;
    const k = cosine(Math.min(1, cycle / 2.5));
    for (let i = 0; i < vals.length; i++) {
      const h = lerp(vals[i], sorted[i], k) * 12;
      const x = 320 + i * 48;
      const hot = k >= 1 && i === (Math.floor((cycle - 2.5) * 2) % 9 + 9) % 9;
      rect(s, hot ? Theme.pink : Theme.coin, 0.9, x, 190 - h, 36, h, 3);
    }
    note(s, k < 1 ? "merge sort  O(n log n)" : "binary search  O(log n)", 780, 100);
  },

  hash(s) {
    const pairs: Array<[string, string]> = [
      ["2", "7"],
      ["11", "15"],
      ["9", "9"],
    ];
    const lit = Math.floor(s.t % 3);
    pairs.forEach(([a, b], i) => {
      const y = 60 + i * 46;
      const on = i === lit;
      chip(s, 320, y, 90, 34, a, on ? GOLDBG : Theme.paper, on ? Theme.coin : Theme.cream);
      chip(s, 420, y, 90, 34, b, on ? GOLDBG : Theme.paper, on ? Theme.coin : Theme.cream);
      chip(s, 520, y, 130, 34, "= 18 ?", on ? PINKBG : Theme.paper, on ? Theme.pink : [1, 1, 1, 0.4]);
    });
    chip(s, 700, 60, 260, 34, "seen[target-x]", Theme.paper, Theme.cyan, "small");
    chip(s, 700, 106, 260, 34, "r[i] == r[j]", Theme.paper, Theme.cyan, "small");
    chip(s, 700, 152, 260, 34, "count[c-'a']++", Theme.paper, Theme.cyan, "small");
  },

  workers(s) {
    // Three cooks pulling from one jobs rail.
    for (let i = 1; i <= 3; i++) {
      const x = 320 + (i - 1) * 200;
      const bob = Math.sin(s.t * 5 + i * 2) * 6;
      chip(s, x, 110 + bob, 150, 34, `worker ${i}`, PINKBG, Theme.pink);
      steam(s, x + 40, 100 + bob, 2);
    }
    const jobs = 9;
    const sent = Math.floor((s.t * 2) % (jobs + 3));
    for (let j = 1; j <= jobs; j++) {
      rect(s, Theme.coin, j > sent ? 1 : 0.2, 320 + (j - 1) * 60, 62, 40, 26, 4);
    }
    note(
      s,
      sent >= jobs ? "close(jobs)   wg.Wait()   close(results)" : `jobs <- ${Math.min(jobs, sent + 1)}`,
      320,
      170,
    );
  },
};

/**
 * The generic scene. The Rust and Python tracks and the BIG O quests each
 * describe their street as a column of `chips` lit one after another and a
 * `note` underneath, with the track's mascot scuttling about at the side.
 */
const CHIP_FILL: Record<string, RGBA | undefined> = {
  cyan: undefined,
  gold: GOLDBG,
  pink: PINKBG,
  green: GREENBG,
};
const CHIP_INK: Record<string, RGBA> = {
  cyan: Theme.cyan,
  gold: Theme.coin,
  pink: Theme.pink,
  green: Theme.admit,
};

function chipsScene(s: Scene): void {
  const chips = s.map.chips;
  const n = chips.length;
  const lit = Math.floor(s.t * 1.1) % Math.max(1, n);
  const f = font("small");
  const noteF = font("codeSm");
  const noteH = s.map.note ? noteF.height + 4 : 0;
  // The column has to end above the pavement, whatever the band's height is.
  const bottom = 190;
  const step = Math.min(34, Math.floor((bottom - 40 - noteH) / Math.max(1, n)));
  const chipH = Math.max(22, step - 4);
  const y0 = 40;

  chips.forEach(([text, colour], i) => {
    const y = y0 + i * step;
    const rise = expOut(clamp((s.mapT - i * 0.12) / 0.5, 0, 1));
    const w = Math.max(150, textWidth(f, text) + 28);
    const on = i === lit;
    chip(
      s,
      300 + (1 - rise) * 40,
      y,
      w,
      chipH,
      text,
      on ? (CHIP_FILL[colour] ?? Theme.paper) : Theme.paper,
      on ? CHIP_INK[colour] : [1, 1, 1, 0.55],
      "small",
    );
  });

  if (noteH > 0) {
    s.g.fillStyle = css(Theme.coin, 0.9);
    printf(s.g, noteF, s.map.note, 300, y0 + n * step + 2, 900, "left");
  }

  const fx = 940 + Math.sin(s.t * 0.6) * 60;
  drawMascot(s.g, s.art, s.track, fx, 196, 52, {
    t: s.t,
    walk: true,
    facing: Math.cos(s.t * 0.6) >= 0 ? 1 : -1,
  });

  if (s.solved) {
    const k = expOut(s.stamp);
    s.g.fillStyle = `rgba(56,158,97,${0.4 + 0.6 * k})`;
    printf(s.g, font("stamp"), "OK", fx - 100, 96 - k * 12, 200, "center");
  }
}

/** Draw the scene a street asks for. A street with no scene draws nothing. */
export function drawViz(s: Scene): void {
  const named = SCENES[s.map.viz];
  if (named) {
    named(s);
    return;
  }
  if (s.map.viz === "rust" || s.map.viz === "python" || s.map.viz === "chips") {
    chipsScene(s);
  }
}
