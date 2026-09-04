# CAUSEWAYBAY GO (Love2D)

English · 한국어 · 粵語 · 简体中文 · 日本語 · Español · Čeština (F3 or the top-right
button; remembered between runs).

A Wonder Boy-style 16-bit Go and Rust trainer. Alex, a Go coder in Causeway
Bay, walks to **Lucky Mac** for a morning set (muffin, hash brown, coffee).
Every kiosk on the way is stuck on a Go bug. Type the missing token. In the
afternoon Mei takes over: Lucky Mac's Times Square branch runs on **Rust**,
and the same four tiers repeat with Rust blanks.

```bash
cd love2d
make help
make start    # run in the background
make stop
make test     # unit tests + the title -> map -> play -> win state machine
make lint     # the Rust street files, without LÖVE (luajit)
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

- **Tracks**: two languages, **GO** and **RUST**, chosen freely. **TAB** on the
  title or the map switches, and the map carries two big buttons (the morning
  set stands by GO, Ferris the crab by RUST) with each track's CLEARED count.
  The map's haze turns from night blue to rust orange with the track. Progress
  is per street, so both tracks can be half done at once.
- **Quests**: four per track. **Q1 BASIC** is the walk (packages through
  structs). **Q2 ADVANCED** is the kitchen (defer through context). **Q3 DELIVERY**
  is the app (strings through the newest standard library). **Q4 CODE RUSH** is
  the interview game show (recursion, trees, graphs, lists, sorting, hashing,
  worker pools). The Rust track mirrors them as **R1 BASIC** (fn main through
  struct and enum), **R2 ADVANCED** (Result through Arc<Mutex>), **R3 DELIVERY**
  (String, errors, iterators, serde, async, cargo, modern Rust) and **R4 CODE
  RUSH** (the evening Rust round). **Q** on the title or the map cycles the
  quests of the open track. Each quest has seven Super Mario World-style map
  dots, and every dot is a topic.
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

Three LuaJIT scripts under `tools/` check and extend the content without
starting LÖVE, which is what `make lint` runs and what CI runs first:

- `lint_data.lua` — the shape of a Rust street file: seven maps, 4-8 stages,
  every text field in English, Korean and Cantonese, code at most seven lines
  with the blank present in each language, answers that survive the loose
  matcher and do not collide inside a street, and no answer given away by the
  comment on its own line.
- `hint_leaks.lua` — a first-tier hint that spells out its own answer in any
  language. HINT is meant to nudge first and answer second; a translation that
  writes the answer into the nudge defeats that.
- `missing_strings.lua` / `merge_lang.lua` — list what a `src/lang/<code>.lua`
  file does not translate yet as a patch skeleton, then merge the filled-in
  patch back, refusing any translation that drops a `___`, `%s` or `%d`.

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

## Keys

- **TAB** (title, map) / the GO and RUST buttons — switch the language track
- **Q** (title, map) — next quest of the open track
- **F3** / language button — English → 한국어 → 粵語 → 简体中文 → 日本語 → Español → Čeština
- **F4** — sound on/off (remembered). Every effect is synthesized at load:
  square, triangle, saw and noise voices rendered to 8-bit PCM at 22 kHz. No
  audio files. Keys click, the map hero steps, Alex's footsteps tick after
  CLEAR, right answers arpeggiate, wrong ones slide down, streets and stamps
  get a fanfare.
- **F2** / **MAP** — street map · **F11** — window / fullscreen · **F1** —
  landscape 1280×720 / portrait 720×1280.

## Persist (`~/.causewaybaygo`)

Override with `GOSET_HOME`. Two JSONL files, append-only, last readable line
of each kind wins:

- `setup.jsonl` — `setup` / `display` records: orientation, fullscreen,
  language, sound.
- `progress.jsonl` — `progress` records: quest (1-4 Go, 5-8 Rust), track,
  street, blank, and the list of CLEARED street ids across all quests of both
  tracks.

```jsonl
{"event":"progress","quest":5,"track":"rust","step":2,"stage":3,"solved":false,"cleared":["flat","rs_main"],"at":"2026-09-03T15:02:11Z"}
```

Scene art was generated with Grok. No third-party game characters or brand
logos appear. Lucky Mac is a fictional breakfast shop.

## License

MIT for the code. Fonts under `love2d/assets/fonts` are SIL Open Font License 1.1.
