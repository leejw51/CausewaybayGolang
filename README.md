# CAUSEWAYBAY GO — learn Go on the way to a morning set

A Wonder Boy / Super Mario World 16-bit trainer, same loop as its sibling
CausewaybayZkp: title → map → type the blank → hint → answer.

**Story.** In Causeway Bay, Hong Kong, Alex the Go coder walks to Lucky Mac for
the morning set. Every kiosk on Percival Street, the MTR, Times Square and the
queue is stuck on a Go bug. Fix them. Eat. Then build the delivery app.

```bash
brew install love
cd love2d
love .
```

Four quests, twenty-eight streets, 149 blanks. Every map dot is a Go topic:

- **Q1 BASIC** — PACKAGE · VARS · LOOPS · FUNCS · SLICES · MAPS · STRUCTS
- **Q2 ADVANCED** — DEFER · GO · CHAN · SELECT · SYNC · GENERIC · CONTEXT
- **Q3 DELIVERY** — STRINGS · ERRORS · TYPES · JSON · HTTP · TOOLS · MODERN
- **Q4 CODE RUSH** — RECURSE · TREE · GRAPH · LIST · SORT · HASH · WORKERS (the interview game show, with combos and PERFECT)

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
