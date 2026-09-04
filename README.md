# CAUSEWAYBAY GO — learn Go (and Rust) on the way to a morning set

A Wonder Boy / Super Mario World 16-bit trainer, same loop as its sibling
CausewaybayZkp: title → map → type the blank → hint → answer.

**Story.** In Causeway Bay, Hong Kong, Alex the Go coder walks to Lucky Mac for
the morning set. Every kiosk on Percival Street, the MTR, Times Square and the
queue is stuck on a Go bug. Fix them. Eat. Then build the delivery app.

**The afternoon is Rust.** Lucky Mac's new branch at Times Square runs on Rust,
and Mei the Rustacean walks Alex through it, Ferris the crab in tow. Two
language tracks, **GO** and **RUST**, sit side by side on the map: TAB or the
two big buttons switch, and every track has the same four tiers, BASIC through
CODE RUSH. A street you finish is stamped **CLEARED** on the map, for good.

```bash
brew install love
cd love2d
love .
```

Two tracks, eight quests, fifty-six streets. Every map dot is a topic.

**GO** — four quests, 149 blanks:

- **Q1 BASIC** — PACKAGE · VARS · LOOPS · FUNCS · SLICES · MAPS · STRUCTS
- **Q2 ADVANCED** — DEFER · GO · CHAN · SELECT · SYNC · GENERIC · CONTEXT
- **Q3 DELIVERY** — STRINGS · ERRORS · TYPES · JSON · HTTP · TOOLS · MODERN
- **Q4 CODE RUSH** — RECURSE · TREE · GRAPH · LIST · SORT · HASH · WORKERS (the interview game show, with combos and PERFECT)

**RUST** — four quests, the afternoon:

- **R1 BASIC** — MAIN · LET · FLOW · FN · OWNER · VEC · STRUCT
- **R2 ADVANCED** — RESULT · TRAIT · GENERIC · LIFETIME · THREAD · CHANNEL · SYNC
- **R3 DELIVERY** — STRINGS · ERRORS · ITER · SERDE · ASYNC · CARGO · MODERN
- **R4 CODE RUSH** — RECURSE · TREE · GRAPH · LIST · SORT · HASH · WORKERS (the evening Rust round)

TAB switches Go/Rust, Q cycles the quests of a track, 1–7 jump into a street.
F11 fullscreen, F1 portrait/landscape, F3 language (English, 한국어, 粵語, 简体中文, 日本語, Español, Čeština), F4 sound.
Progress and settings are JSONL in `~/.causewaybaygo`.

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
