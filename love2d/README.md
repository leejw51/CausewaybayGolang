# CAUSEWAYBAY GO (Love2D)

English · 한국어 · 粵語 · 简体中文 · 日本語 · Español · Čeština (F3 or the top-right
button; remembered between runs).

A Wonder Boy-style 16-bit Go, Rust and Python trainer. Alex, a Go coder in
Causeway Bay, walks to **Lucky Mac** for a morning set (muffin, hash brown,
coffee). Every kiosk on the way is stuck on a Go bug. Type the missing token.
In the afternoon Mei takes over: Lucky Mac's Times Square branch runs on
**Rust**, and the same tiers repeat with Rust blanks. At night Chef Bo's
kitchen robot runs on **Python**, and the night shift repeats them once more.
Every track closes with **BIG O**.

```bash
cd love2d
make help
make start    # run in the background
make stop
make test     # unit tests + the title -> map -> play -> win state machine
make lint     # the Rust, Python, BIG O and CALLBACK street files, without LÖVE (luajit)
make drive SCRIPT=tests/drive/all.lua
make format   # stylua
```

## Flow

```
title  --ENTER-->  map  --ENTER / click / 1-7-->  play  --CLEAR, ENTER-->  next street ... --> win
  ^                 ^                              |
  |                 +---- ESC / F2 / MAP ----------+
  +---- ESC on the map
```

- **Tracks**: three languages, **GO**, **RUST** and **PYTHON**, chosen freely.
  **TAB** on the title or the map cycles them, and the map carries three big
  buttons with each track's CLEARED count and its mascot peeking over the
  corner: a coffee-drinking gopher for Go, Ferris the crab for Rust, Monty the
  python for Python (all three from Grok, see `tools/grok_image.sh`; Ferris and
  Monty fall back to primitives when a sheet is missing). The map's haze turns
  from night blue to rust orange to midnight with the track. Progress is per
  street, so all three tracks can be half done at once.
- **Quests**: six for Go and Rust, five for Python. **Q1 BASIC** is the walk
  (packages through structs). **Q2 ADVANCED** is the kitchen (defer through
  context). **Q3 DELIVERY** is the app (strings through the newest standard
  library). **Q4 CODE RUSH** is the interview game show (recursion, trees,
  graphs, lists, sorting, hashing, worker pools). **Q5 BIG O** is the
  whiteboard: O(1), O(n), O(log n), n log n, O(n^2), O(2^n) and space, each
  street a loop to read, a cost to name and a faster version to write.
  **Q6 CALLBACK** is the second interview at the whiteboard: the seven
  classics CODE RUSH left out (a stack and valid parentheses, DP with stairs
  and coin change, sliding windows and Kadane, a heap and the k-th largest,
  merging intervals, an LRU cache, DFS over a grid of islands). The Rust
  track mirrors them as **R1**–**R6**; the Python track is **P1 BASIC** (print
  through class), **P2 ADVANCED** (except, yield, decorators, with, asyncio,
  typing, threads), **P3 CODE RUSH** (the midnight Python round), **P4 BIG O**
  and **P5 CALLBACK**. New quests are appended to the flat list in
  `src/quests.lua` (9–17), so an old `progress.jsonl` keeps its meaning. **Q** on the title or
  the map cycles the quests of the open track. Each quest has seven Super Mario
  World-style map dots, and every dot is a topic.
- **XP and badges** (`src/stats.lua`): a right answer pays 10 XP, each step of
  a streak a little more, an answer within 8 seconds a FAST bonus, a CLEAR 25,
  a PERFECT 50, a stamp 200. Levels are triangular (100, 300, 600 ...); the
  level and bar sit on the title, the map's panel and the win screen. Fourteen
  badges pop in the scene as they are earned: FIRST CLEAR, COMBO x5 / x10,
  PERFECT STREET, FIVE PERFECTS, SPEED TYPER, 100 RIGHT, FIRST STAMP, THREE
  LANGUAGES (a street in each track), POLYGLOT (the same round in all three),
  BIG O MASTER, SHARED IT, NIGHT OWL, EARLY BIRD.
- **SHARE** (F6, or the button top-right of the scene): a sheet with two
  columns. **COPY** puts the question (with its code and blank), the hint, the
  answer with its why, or all of it on the clipboard, the ALL variant ending
  with "Ask your AI: why is `x` the answer here?" so it can be pasted straight
  into a chat. **EXPORT** writes the current street, the whole quest or the
  whole track (S cycles the scope) to `~/Downloads` as Markdown, CSV, JSONL,
  plain text, SQLite (through the `sqlite3` CLI; the `.sql` script is left when
  it is missing) or the **PNG disk** (0). The disk is one square PNG: it starts
  at 512 px and grows through 640, 768, 1024, 1280, 1536 to 2048 px until every
  question, hint and answer fits; at 2048 the type shrinks instead. A street is
  a 512 or 640 px card, a whole track a dense 2048 px page. `A` writes every
  format at once. `GOSET_DOWNLOADS` redirects the folder (the tests use it).
- **CLEARED**: a finished street gets a tilted green CLEARED stamp, a gold star
  and twinkles on its map dot, the path after it lights up gold, and a quest
  with all seven streets done gets a star on its tab. Cleared street ids live
  in `progress.jsonl`, so the stamps survive a restart.
- **Title**: ENTER or click opens the street map. **C** continues from
  `progress.jsonl`. 1–7 jump straight in. ESC quits.
- **Map**: a 16-bit overworld of Causeway Bay. Seven topic dots on a dotted path;
  Alex walks with the ARROW keys. ENTER or a click starts that street.
- **Play**: read the story and the question, type the answer, ENTER or **OK**.
  Wrong answers shake and open the hint. **HINT** (TAB): first a nudge, second
  the answer, third hides it. **PREV / NEXT** (PGUP / PGDN) browse the blanks of
  one street. **AUTO** (F5) plays the street for you.
- **Combo**: right answers in a row build a STREAK (bigger bursts, a rising
  jingle, COMBO pop-ups). A wrong answer or a revealed ANSWER breaks it. Clear a
  street with no miss for **PERFECT!**
- **Win**: when all seven streets of that quest are CLEAR. Shows the stamp.

Answers are matched loosely (case, spaces, quotes, `_`, `-`, `.` ignored).

## Tools

LuaJIT scripts under `tools/` check and extend the content without starting
LÖVE, which is what `make lint` runs and what CI runs first:

- `lint_data.lua` — the shape of a chips-scene street file (Rust, Python, BIG
  O): seven maps, 4-8 stages, every text field in English, Korean and
  Cantonese, code at most seven lines with the blank present in each language,
  answers that survive the loose matcher and do not collide inside a street,
  no answer given away by the comment on its own line, and the id prefix that
  matches the scene (`rs_`, `py_`, none for Go).
- `hint_leaks.lua` — a first-tier hint that spells out its own answer in any
  language. HINT is meant to nudge first and answer second; a translation that
  writes the answer into the nudge defeats that.
- `missing_strings.lua` / `merge_lang.lua` — list what a `src/lang/<code>.lua`
  file does not translate yet as a patch skeleton, then merge the filled-in
  patch back, refusing any translation that drops a `___`, `%s` or `%d`.
- `dump_strings.lua` / `fill_lang.lua` — the same job for a translator who
  works from a numbered TSV: dump the untranslated English strings in a stable
  order, join a numbered translation file back into a patch (`=` means "same
  as the English", for code with nothing to translate).
- `grok_image.sh` — one Grok (xAI) image generation to a PNG, the way every
  background and mascot sheet under `assets/` was made. Needs `GROK_API_KEY`.

### Q1 BASIC — the walk (42 blanks)

| Dot | Place | Blanks |
| --- | --- | --- |
| PACKAGE | The flat | `main`, `fmt`, `import`, `Println` (exported names), `init` |
| VARS | The lift | `:=`, `const`, `0` (zero value), `var`, `iota`, `float64` (conversion) |
| LOOPS | Percival Street | `for`, `range`, `switch`, `!=` (if-init), `continue`, `break` |
| FUNCS | The MTR | `func`, `error`, `_`, `return`, `...int` (variadic) |
| SLICES | Times Square | `[]int`, `append`, `len`, `[3]string`, `1:3`, `9` (aliasing), `cap`, `make` |
| MAPS | Sogo | `map[string]int`, `ok`, `delete`, `make` (nil map), `clear` |
| STRUCTS | The queue | `struct`, `*`, `interface`, `&`, `*Order` (pointer receiver), `String`, `false` (typed nil) |

### Q2 ADVANCED — the kitchen (38 blanks)

| Dot | Place | Blanks |
| --- | --- | --- |
| DEFER | The till | `nil`, `defer`, `recover`, `panic`, `1` (defer args) |
| GO | The kitchen | `go`, `goroutine`, `()` |
| CHAN | The pass | `chan string`, `<-`, `close`, `3` (buffer), `<-chan`, `range`, `deadlock`, `struct{}` |
| SELECT | The bell | `select`, `default`, `After`, `Done` |
| SYNC | The tray | `Mutex`, `WaitGroup`, `Unlock`, `RLock`, `atomic`, `Once`, `Wait` (errgroup), `-race` |
| GENERIC | The table | `any`, `Grill` (embedding), `closure`, `comparable`, `~` |
| CONTEXT | The set | `Background`, `TestOrder`, `WithTimeout`, `Errorf`, `Benchmark` |

### Q3 DELIVERY — the app (38 blanks)

| Dot | Place | Blanks |
| --- | --- | --- |
| STRINGS | The signboard | `rune`, `3` (bytes), `RuneCountInString`, `string`, `ToUpper`, `Atoi` |
| ERRORS | The refund desk | `New`, `%w`, `Is`, `As`, `Error` |
| TYPES | The menu board | `Floor` (named type), `string` (assertion), `type` (type switch), `Sprintf`, `%+v` |
| JSON | The order app | `Item` (exported), `item` (tag), `Marshal`, `Unmarshal`, `omitempty` |
| HTTP | The web counter | `HandleFunc`, `ResponseWriter`, `Request`, `Fprintf`, `ListenAndServe` |
| TOOLS | The workshop | `mod`, `module`, `tidy`, `vet`, `build`, `embed` |
| MODERN | The rooftop | `range` (over int), `min`, `Sort`, `Contains`, `Keys`, `Seq` |

### Q4 CODE RUSH — the interview (31 blanks)

| Dot | Round | Blanks |
| --- | --- | --- |
| RECURSE | the buzzer | `1` (base case), `n-1`, `ok` (memo hit), `n-2` |
| TREE | the tree | `*Node`, `nil`, `Left`, `inorder`, `Right` (height) |
| GRAPH | the map | `bool` (visited set), `1:` (dequeue), `append`, `dfs` |
| LIST | the chain | `*ListNode`, `prev` (reverse), `prev` (return), `Next` (Floyd) |
| SORT | the shuffle | `2` (mid), `mid`, `i` (merge), `m:` (split), `Slice` |
| HASH | the classics | `x` (two-sum), `rune`, `j-1` (two pointers), `++` (anagram) |
| WORKERS | the kitchen | `range`, `Add`, `close`, `Wait`, `3` (semaphore) |

### R1 BASIC — the walk, Rust (43 blanks)

| Dot | Place | Blanks |
| --- | --- | --- |
| MAIN | Lucky Mac table 4 | `main`, `//`, `!` (macro), `{}`, `use`, `run` |
| LET | Percival Street tram stop | `let`, `mut`, `const`, `i32`, `as`, `usize` |
| FLOW | MTR exit A | `if`, `loop` (break value), `while`, `..=`, `match`, `_` |
| FN | The footbridge | `fn`, `->`, `a + b` (tail expression), `return`, `Option`, `None` |
| OWNER | Times Square atrium | `move`, `clone`, `&`, `&mut`, `drop`, `&str` |
| VEC | The Express queue | `vec!`, `push`, `len`, `1..3`, `3` (array size), `sum`, `entry` |
| STRUCT | The Express counter | `struct`, `impl`, `&self`, `&mut self`, `enum`, `derive` |

### R2 ADVANCED — the kitchen, Rust (42 blanks)

| Dot | Place | Blanks |
| --- | --- | --- |
| RESULT | The till | `Result`, `Some`, `unwrap_or`, `?`, `ok_or`, `expect` |
| TRAIT | The kitchen | `trait`, `for`, `dyn`, `derive`, `Display`, `default` |
| GENERIC | The mall | `PartialOrd`, `where`, `impl`, `Option`, `::<i32>`, `Box<dyn Cook>` |
| LIFETIME | The set | `'a`, `'static`, `<'a>`, `'_`, `&str` (elision) |
| THREAD | The kitchen | `spawn`, `move`, `join`, `sleep`, `JoinHandle`, `scope` |
| CHANNEL | The queue | `channel`, `recv`, `clone`, `drop`, `try_recv`, `sync_channel` |
| SYNC | The till | `Arc`, `Mutex`, `lock`, `Arc::clone`, `read`, `fetch_add`, `Send` |

### R3 DELIVERY — the backend, Rust (44 blanks)

| Dot | Place | Blanks |
| --- | --- | --- |
| STRINGS | The signboard | `from`, `len` (bytes), `chars`, `format`, `push_str`, `parse` |
| ERRORS | The refund desk | `enum`, `Display`, `std::error::Error`, `From`, `Box`, `thiserror` |
| ITER | The kitchen | `iter`, `\|x\|`, `filter`, `collect`, `sum`, `enumerate`, `fold` |
| SERDE | The order app | `Serialize`, `to_string`, `from_str`, `rename`, `skip_serializing_if`, `Value` |
| ASYNC | The web counter | `async`, `.await`, `tokio::main`, `spawn`, `join`, `reqwest` |
| CARGO | The workshop | `new`, `dependencies`, `add`, `release`, `test`, `clippy`, `fmt` |
| MODERN | The rooftop | `else` (let-else), `matches`, `impl`, `..=`, `?` (Option), `is_some_and` |

### R4 CODE RUSH — the Rust round (40 blanks)

| Dot | Round | Blanks |
| --- | --- | --- |
| RECURSE | the buzzer | `1` (base case), `n - 1`, `get` (memo hit), `n - 2`, `insert` |
| TREE | the tree | `Box`, `None`, `left`, `as_ref`, `right` (inorder), `max` |
| GRAPH | the map | `Vec`, `or_default`, `VecDeque`, `pop_front`, `insert` (visited), `pop` |
| LIST | the chain | `Option`, `take`, `prev` (reverse), `next`, `as_deref` (runners) |
| SORT | the shuffle | `2` (mid), `split_at`, `<=` (merge), `sort_by_key`, `binary_search`, `sort_unstable` |
| HASH | the classics | `contains_key`, `rev`, `filter`, `26` (anagram), `usize`, `or_insert` |
| WORKERS | the kitchen | `channel`, `Mutex`, `spawn`, `recv`, `drop`, `join` |

### R5 BIG O — how fast is it, Rust (28 blanks)

| Dot | Place | Blanks |
| --- | --- | --- |
| O(1) | The counter | `O(1)`, `HashMap`, `last`, `same` |
| O(N) | The queue | `O(n)`, `n`, `any`, `n-1` |
| O(LOG N) | The phone book | `/`, `10`, `O(log n)`, `sorted` |
| N LOG N | The sorting hat | `O(n log n)`, `O(n)`, `sort_unstable`, `log n` |
| O(N^2) | The seating chart | `O(n^2)`, `4950`, `HashSet`, `O(n*m)` |
| O(2^N) | The combinatorics counter | `O(2^n)`, `n`, `get`, `2^n` |
| SPACE | The storeroom | `1`, `n`, `clone`, `log n` |

### P1 BASIC — the night shift, Python (42 blanks)

| Dot | Place | Blanks |
| --- | --- | --- |
| PRINT | The pass, 21:00 | `print`, `#`, `f`, `import`, `input`, `__main__` |
| VARS | The stock room | `int`, `None`, `//`, `**`, `type`, `str` |
| FLOW | The shutter queue | `elif`, `range`, `while`, `break`, `in`, `else` |
| FUNCS | The pass window | `def`, `return`, `*items`, `**opts`, `lambda`, `None` |
| LISTS | The tray rack | `append`, `len`, `1:3`, `-1`, `for`, `sorted` |
| DICTS | The menu board | `{}`, `get`, `items`, `del`, `set`, `keys` |
| CLASSES | The order robot | `class`, `__init__`, `self`, `__str__`, `super`, `dataclass` |

### P2 ADVANCED — the back office, Python (42 blanks)

| Dot | Place | Blanks |
| --- | --- | --- |
| EXCEPT | The refund desk | `try`, `except`, `finally`, `raise`, `as`, `Exception` |
| YIELD | The conveyor | `yield`, `next`, `iter`, `enumerate`, `zip`, `StopIteration` |
| DECOR | The stamp desk | `@`, `wrapper`, `wraps`, `property`, `staticmethod`, `classmethod` |
| WITH | The safe | `with`, `as`, `__enter__`, `__exit__`, `contextmanager`, `close` |
| ASYNC | The delivery radio | `async`, `await`, `run`, `gather`, `sleep`, `create_task` |
| TYPING | The label maker | `int`, `None`, `list`, `Optional`, `dict`, `mypy` |
| THREADS | The kitchen at 23:00 | `Thread`, `start`, `join`, `Lock`, `ThreadPoolExecutor`, `GIL` |

### P3 CODE RUSH — the midnight round, Python (35 blanks)

| Dot | Round | Blanks |
| --- | --- | --- |
| RECURSE | the buzzer | `1`, `n - 1`, `cache`, `memo`, `n - 2` |
| TREE | the tree | `None`, `left`, `right`, `max`, `popleft` |
| GRAPH | the map | `list`, `set`, `start`, `add`, `dfs` |
| LIST | the chain | `None`, `prev`, `nxt`, `next`, `is` |
| SORT | the shuffle | `//`, `<=`, `mid`, `len`, `bisect_left` |
| HASH | the classics | `seen`, `i`, `sorted`, `-`, `Counter` |
| WORKERS | the kitchen | `Queue`, `put`, `get`, `task_done`, `join` |

### P4 BIG O — how fast is it, Python (28 blanks)

| Dot | Place | Blanks |
| --- | --- | --- |
| O(1) | The counter | `O(1)`, `dict`, `-1`, `same` |
| O(N) | The queue | `O(n)`, `n`, `in`, `n-1` |
| O(LOG N) | The phone book | `//`, `10`, `O(log n)`, `sorted` |
| N LOG N | The sorting hat | `O(n log n)`, `O(n)`, `sorted`, `log n` |
| O(N^2) | The seating chart | `O(n^2)`, `4950`, `set`, `O(n*m)` |
| O(2^N) | The combinatorics counter | `O(2^n)`, `n`, `cache`, `2^n` |
| SPACE | The storeroom | `1`, `n`, `list`, `log n` |

### Q5 BIG O — how fast is it, Go (28 blanks)

| Dot | Place | Blanks |
| --- | --- | --- |
| O(1) | The counter | `O(1)`, `map`, `-1`, `same` |
| O(N) | The queue | `O(n)`, `n`, `range`, `n-1` |
| O(LOG N) | The phone book | `/`, `10`, `O(log n)`, `sorted` |
| N LOG N | The sorting hat | `O(n log n)`, `O(n)`, `Strings`, `log n` |
| O(N^2) | The seating chart | `O(n^2)`, `4950`, `bool`, `O(n*m)` |
| O(2^N) | The combinatorics counter | `O(2^n)`, `n`, `ok`, `2^n` |
| SPACE | The storeroom | `1`, `n`, `len`, `log n` |

### Q6 CALLBACK — the second interview, Go (35 blanks)

| Dot | Round | Blanks |
| --- | --- | --- |
| STACK | the brackets | `'('`, `append`, `pairs`, `len(st) == 0`, `min` |
| DP | the stairs | `2`, `dp[i-1] + dp[i-2]`, `amount + 1`, `a-c`, `-1` |
| WINDOW | the window | `x`, `i-k`, `r`, `p`, `r-l+1` |
| HEAP | the top k | `<`, `*IntHeap`, `n-1`, `Pop`, `0` |
| INTERVAL | the calendar | `<`, `1`, `max`, `append`, `>=` |
| LRU | the cache | `*list.Element`, `MoveToFront`, `PushFront`, `Back`, `delete` |
| GRID | the islands | `>=`, `'1'`, `'0'`, `r, c-1`, `dfs` |

### R6 CALLBACK — the second interview, Rust (35 blanks)

| Dot | Round | Blanks |
| --- | --- | --- |
| STACK | the brackets | `'{'`, `push`, `pop`, `is_empty`, `min` |
| DP | the stairs | `1`, `i - 2`, `0`, `min`, `-1` |
| WINDOW | the window | `max`, `i - k`, `remove`, `insert`, `-=` |
| HEAP | the top k | `Reverse`, `pop`, `peek`, `entry`, `collect` |
| INTERVAL | the shifts | `sort_by_key`, `last_mut`, `<=`, `max`, `push` |
| LRU | the cache | `position`, `push_back`, `pop_front`, `remove`, `insert` |
| GRID | the islands | `>=`, `b'1'`, `b'0'`, `wrapping_sub`, `sink` |

### P5 CALLBACK — the second interview, Python (37 blanks)

| Dot | Round | Blanks |
| --- | --- | --- |
| STACK | the brackets | `"{"`, `append`, `pop`, `-1`, `not st`, `min` |
| DP | the stairs | `1`, `i - 2`, `cache`, `inf`, `min`, `-1` |
| WINDOW | the window | `cur + x`, `a[0]`, `a[i - k]`, `remove`, `r - l + 1` |
| HEAP | the heap | `heappush`, `heappop`, `0`, `nlargest`, `most_common` |
| INTERVAL | the shifts | `0`, `s <= out[-1][1]`, `max`, `append`, `1:` |
| LRU | the cache | `OrderedDict`, `-1`, `move_to_end`, `popitem`, `maxsize` |
| GRID | the islands | `len(g[0])`, `"1"`, `"0"`, `c - 1`, `+=` |

## Keys

- **TAB** (title, map) / the GO, RUST and PYTHON buttons — cycle the language track
- **Q** (title, map) — next quest of the open track
- **F6** / **SHARE** (play) — the copy / export sheet: 1-4 copy, 5-9 and 0
  export one format, A every format, S the scope (street / quest / track),
  ESC close
- **F5** / **AUTO** (play) — the street plays itself
- **F3** / language button — English → 한국어 → 粵語 → 简体中文 → 日本語 → Español → Čeština
- **F4** — sound on/off (remembered). Every effect is synthesized at load:
  square, triangle, saw and noise voices rendered to 8-bit PCM at 22 kHz. No
  audio files. Keys click, the map hero steps, Alex's footsteps tick after
  CLEAR, right answers arpeggiate, wrong ones slide down, streets and stamps
  get a fanfare.
- **F2** / **MAP** — street map · **F11** — window / fullscreen · **F1** —
  landscape 1280×720 / portrait 720×1280.

## Persist (`~/.causewaybaygo`)

Override with `GOSET_HOME`. Five JSONL files, append-only:

- `setup.jsonl` — `setup` / `display` records: orientation, fullscreen,
  language, sound. Last line of each kind wins.
- `progress.jsonl` — `progress` records: quest (1-4 Go, 5-8 Rust, 9-11
  Python, 12-14 the three BIG O quests, 15-17 the three CALLBACK quests),
  track, street, blank, and the list of
  CLEARED street ids across every quest of every track. Last line wins.
- `stats.jsonl` — `stats` records: XP, level, right / wrong / fast counts,
  clears, perfects, stamps, copies, exports, best streak and the badge list.
  Last line wins.
- `answers.jsonl` — one `answer` record per attempt: street, blank, topic, the
  expected answer, what was typed, right or wrong, seconds since the blank was
  shown, the streak. Kept long (5000 lines) so a session can be replayed.
- `exports.jsonl` — one `copy` or `export` record per share: part or format,
  scope, row count, the path written.

```jsonl
{"event":"progress","quest":9,"track":"python","step":2,"stage":3,"solved":false,"cleared":["flat","rs_main","py_print"],"at":"2026-09-04T13:02:11Z"}
{"event":"answer","ok":true,"quest":9,"track":"python","street":"py_vars","stage":3,"topic":"FLOOR","answer":"//","input":"//","secs":4.2,"streak":3,"at":"2026-09-04T13:02:11Z"}
{"event":"stats","xp":340,"level":3,"right":21,"wrong":2,"fast":9,"clears":3,"perfects":1,"stamps":0,"badges":["first_clear","perfect","combo5"],"at":"2026-09-04T13:02:11Z"}
{"event":"export","fmt":"png","scope":"street","rows":6,"path":"/Users/me/Downloads/causewaybaygo-python-p1-py_vars-20260904-130211.png","ok":true,"at":"2026-09-04T13:02:11Z"}
```

Exports go to `~/Downloads` (override with `GOSET_DOWNLOADS`), named
`causewaybaygo-<track>-<quest>-<street>-<timestamp>.<ext>`.

Scene art and the three mascot sheets were generated with Grok
(`tools/grok_image.sh`). No third-party game characters or brand logos appear;
the gopher, the crab and the python are original designs. Lucky Mac is a
fictional breakfast shop.

## License

MIT for the code. Fonts under `love2d/assets/fonts` are SIL Open Font License 1.1.
