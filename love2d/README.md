# GO SET — Causeway Bay (Love2D)

English · 한국어 · 粵語 (F3 or the top-right button; remembered between runs).

A Wonder Boy-style 16-bit Go trainer. Alex, a Go coder in Causeway Bay, walks
to **Lucky Mac** for a morning set (muffin, hash brown, coffee). Every kiosk
on the way is stuck on a Go bug. Type the missing token.

```bash
cd love2d
make help
make start    # run in the background
make stop
make test     # unit tests + the title -> map -> play -> win state machine
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

- **Quests**: four of them. **Q1 BASIC** is the walk (packages through
  structs). **Q2 ADVANCED** is the kitchen (defer through context). **Q3 DELIVERY**
  is the app (strings through the newest standard library). **Q4 CODE RUSH** is
  the interview game show (recursion, trees, graphs, lists, sorting, hashing,
  worker pools). **Q** on the title or the map cycles. Each quest has seven Super Mario World-style map dots, and
  every dot is a Go topic.
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

## Keys

- **F3** / language button — English → 한국어 → 粵語
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
- `progress.jsonl` — `progress` records: quest, street, blank, and the list of
  CLEAR street ids across all quests.

Scene art was generated with Grok. No third-party game characters or brand
logos appear. Lucky Mac is a fictional breakfast shop.

## License

MIT for the code. Fonts under `love2d/assets/fonts` are SIL Open Font License 1.1.
