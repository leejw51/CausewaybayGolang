# CAUSEWAYBAY GO — learn Go, Rust and Python on the way to a morning set

A Wonder Boy / Super Mario World 16-bit trainer, same loop as its sibling
CausewaybayZkp: title → map → type the blank → hint → answer.

**Story.** In Causeway Bay, Hong Kong, Alex the Go coder walks to Lucky Mac for
the morning set. Every kiosk on Percival Street, the MTR, Times Square and the
queue is stuck on a Go bug. Fix them. Eat. Then build the delivery app.

**The afternoon is Rust.** Lucky Mac's new branch at Times Square runs on Rust,
and Mei the Rustacean walks Alex through it, Ferris the crab in tow.

**The night is Python.** After closing, the night shift's kitchen robot runs on
Chef Bo's Python scripts, and Monty the python watches from the laptop lid.
Three language tracks, **GO**, **RUST** and **PYTHON**, sit side by side on the
map with their mascots (a coffee-drinking gopher, a crab, a snake): TAB or the
three big buttons switch. Every track has BASIC, ADVANCED and CODE RUSH, every
track has **BIG O**, seven streets on how fast code is, and every track ends in
**CALLBACK**, the second interview: the seven whiteboard classics CODE RUSH
left out. A street you finish is stamped **CLEARED** on the map, for good.

**It is a game.** Right answers pay XP, combos and FAST answers pay more, streets
and stamps pay a lot, and fourteen badges (FIRST CLEAR, COMBO x10, POLYGLOT,
BIG O MASTER, NIGHT OWL ...) pop as you earn them. Your level and XP bar sit on
the title and the map.

**Take it with you.** On any street, **SHARE** (F6) copies the question, the
hint, the answer or all of it to the clipboard with a line to paste to your AI
("why is this the answer?"), and exports the street, the quest or the whole
track to `~/Downloads` as Markdown, CSV, JSONL, plain text, SQLite, or a **PNG
disk**: one square image, 512 to 2048 px, that holds every question, hint and
answer, sized to fit and shrinking the type when 2048 is not enough. A lesson
you can carry in a photo album.

```bash
brew install love
cd love2d
love .
```

Three tracks, seventeen quests, 119 streets. Every map dot is a topic.

**GO** — six quests:

- **Q1 BASIC** — PACKAGE · VARS · LOOPS · FUNCS · SLICES · MAPS · STRUCTS
- **Q2 ADVANCED** — DEFER · GO · CHAN · SELECT · SYNC · GENERIC · CONTEXT
- **Q3 DELIVERY** — STRINGS · ERRORS · TYPES · JSON · HTTP · TOOLS · MODERN
- **Q4 CODE RUSH** — RECURSE · TREE · GRAPH · LIST · SORT · HASH · WORKERS (the interview game show, with combos and PERFECT)
- **Q5 BIG O** — O(1) · O(N) · O(LOG N) · N LOG N · O(N^2) · O(2^N) · SPACE
- **Q6 CALLBACK** — STACK · DP · WINDOW · HEAP · INTERVAL · LRU · GRID (the second interview: valid parentheses, stairs and coins, Kadane, k-th largest, merge intervals, LRU cache, islands)

**RUST** — six quests, the afternoon:

- **R1 BASIC** — MAIN · LET · FLOW · FN · OWNER · VEC · STRUCT
- **R2 ADVANCED** — RESULT · TRAIT · GENERIC · LIFETIME · THREAD · CHANNEL · SYNC
- **R3 DELIVERY** — STRINGS · ERRORS · ITER · SERDE · ASYNC · CARGO · MODERN
- **R4 CODE RUSH** — RECURSE · TREE · GRAPH · LIST · SORT · HASH · WORKERS (the evening Rust round)
- **R5 BIG O** — O(1) · O(N) · O(LOG N) · N LOG N · O(N^2) · O(2^N) · SPACE
- **R6 CALLBACK** — the same seven whiteboard classics, in Rust

**PYTHON** — five quests, the night shift:

- **P1 BASIC** — PRINT · VARS · FLOW · FUNCS · LISTS · DICTS · CLASSES
- **P2 ADVANCED** — EXCEPT · YIELD · DECOR · WITH · ASYNC · TYPING · THREADS
- **P3 CODE RUSH** — RECURSE · TREE · GRAPH · LIST · SORT · HASH · WORKERS (the midnight Python round)
- **P4 BIG O** — the same seven streets, in Python
- **P5 CALLBACK** — the same seven whiteboard classics, in Python

Big O is the same quiz three times: read a loop, name its cost (O(1), O(n),
O(log n), n log n, O(n^2), O(2^n)), then write the faster version in that
language. CALLBACK is the same seven problems three times too, each in its own
language's idiom: container/heap, BinaryHeap with Reverse, heapq.

TAB cycles Go/Rust/Python, Q cycles the quests of a track, 1–7 jump into a street.
F6 opens SHARE (copy / export). F5 AUTO plays a street for you.
F11 fullscreen, F1 portrait/landscape, F3 language (English, 한국어, 粵語, 简体中文, 日本語, Español, Čeština), F4 sound.
Progress, stats, every answer and every export are JSONL in `~/.causewaybaygo`.
Exports land in `~/Downloads`.

## Release

```bash
make package          # dist/causewaybaygo-<version>.love, and on macOS dist/CausewaybayGo-macos.zip
make notarize         # staple Apple's ticket on the .app (APPLE_ID, APPLE_PASSWORD, APPLE_TEAM_ID)
make gatekeeper       # what Finder will say about it
```

`make package` builds the `.love`, downloads LÖVE 11.5, embeds the game in a
double-clickable `CausewaybayGo.app`, gives it the morning-set icon, signs it with the
machine's Developer ID (ad-hoc when there is none) and runs the test suite from
inside the bundle. The version of record is `./VERSION`.

Pushing a tag `v<VERSION>` on `main` runs the same recipe on a macOS runner,
notarises with the repository's Apple secrets, and attaches the `.app` zip,
the `.love` and `SHA256SUMS` to a GitHub release.

Details in [`love2d/README.md`](love2d/README.md).
