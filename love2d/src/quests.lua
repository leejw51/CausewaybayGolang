-- Three language tracks. One flat list, so a quest index in progress.jsonl
-- stays stable and a street id is unique across the whole game. New quests
-- are appended, never inserted: an old save's quest number keeps meaning
-- what it meant. A track's tab order is the flat order of its quests.
--
--   GO      1 basic     GO SET     packages through interfaces, the walk to Lucky Mac
--           2 advanced  ADVANCED   goroutines through context, the morning set
--           3 delivery  DELIVERY   strings, errors, JSON, HTTP, the go tool, Go 1.21+
--           4 rush      RUSH       CODE RUSH: the coding-interview game show
--   RUST    5 rs_basic  BASIC      let through struct, the walk to Lucky Mac Express
--           6 rs_adv    ADVANCED   Result through Arc<Mutex>, the afternoon kitchen
--           7 rs_pro    DELIVERY   strings, errors, serde, async, cargo, modern Rust
--           8 rs_rush   RUSH       CODE RUSH: the evening Rust round
--   PYTHON  9 py_basic  BASIC      print through class, the night shift
--          10 py_adv    ADVANCED   except, yield, decorators, with, async, typing, threads
--          11 py_rush   RUSH       CODE RUSH: the midnight Python round
--   GO     12 bigo      BIG O      how fast is it: O(1) to O(2^n), in Go
--   RUST   13 rs_bigo   BIG O      the same seven streets, in Rust
--   PYTHON 14 py_bigo   BIG O      the same seven streets, in Python
--   GO     15 callback  CALLBACK   the second interview: stack, DP, window, heap, intervals, LRU, grid
--   RUST   16 rs_callback          the same seven, in Rust
--   PYTHON 17 py_callback          the same seven, in Python
--   GO     18 conc      THREADS    the lunch rush: mutex, atomics, pools, channels, context, async
--   PYTHON 19 py_mp     PARALLEL   the night batch: the GIL, Process, Pool, Queue, shared memory

local function L(en, ko, yue)
  return { en = en, ko = ko, yue = yue }
end

local Quests = {
  {
    id = "basic",
    track = "go",
    tag = "Q1",
    station = "BASIC",
    name = L("GO SET  -  the walk", "GO SET  -  걸어가기", "GO SET  -  行路"),
    goal = L(
      "Walk from the flat to Lucky Mac. Fix every Go bug on the way.",
      "집에서 럭키 맥까지 걷기. 가는 길의 Go 버그를 모두 고치기.",
      "由屋企行去幸運麥。沿路嘅 Go bug 全部修好。"
    ),
    maps = require "src.data",
    win = { stamp = "SERVED", bg = "bg_queue", title = "win_title", head = "win_head" },
  },
  {
    id = "advanced",
    track = "go",
    tag = "Q2",
    station = "ADVANCED",
    name = L("ADVANCED  -  the kitchen", "ADVANCED  -  주방", "ADVANCED  -  廚房"),
    goal = L(
      "Inside Lucky Mac the kitchen runs on goroutines. Earn the morning set.",
      "럭키 맥 주방은 고루틴으로 돌아간다. 모닝세트를 타라.",
      "幸運麥廚房用 goroutine 運作。攞到早餐套餐。"
    ),
    maps = require "src.data_adv",
    win = { stamp = "SERVED", bg = "bg_set", title = "win2_title", head = "win2_head" },
  },
  {
    id = "delivery",
    track = "go",
    tag = "Q3",
    station = "DELIVERY",
    name = L("DELIVERY  -  the app", "DELIVERY  -  앱", "DELIVERY  -  App"),
    goal = L(
      "After breakfast, Lucky Mac wants a delivery app by the lunch rush. Ship it in Go.",
      "아침 후, 럭키 맥은 점심 전까지 배달 앱을 원한다. Go로 배포하라.",
      "食完早餐，幸運麥想午市前有個外賣 App。用 Go 出貨。"
    ),
    maps = require "src.data_pro",
    win = { stamp = "ONLINE", bg = "bg_street", title = "win3_title", head = "win3_head" },
  },
  {
    id = "rush",
    track = "go",
    tag = "Q4",
    station = "RUSH",
    name = L("CODE RUSH  -  the interview", "CODE RUSH  -  면접", "CODE RUSH  -  面試"),
    goal = L(
      "Times Square's live coding show. Seven rounds of classic interview problems. Get HIRED.",
      "타임스퀘어의 라이브 코딩 쇼. 고전 면접 문제 일곱 라운드. 합격하라.",
      "時代廣場嘅直播 coding show。七回合經典面試題。攞到份工。"
    ),
    maps = require "src.data_quiz",
    win = { stamp = "HIRED", bg = "bg_mall", title = "win4_title", head = "win4_head" },
  },
  {
    id = "rs_basic",
    track = "rust",
    tag = "R1",
    station = "BASIC",
    name = L("RUST SET  -  the walk", "RUST SET  -  걸어가기", "RUST SET  -  行路"),
    goal = L(
      "Walk with Mei to Lucky Mac Express. Fix every Rust kiosk on the way.",
      "메이와 럭키 맥 익스프레스까지 걷기. 가는 길의 Rust 키오스크를 모두 고치기.",
      "同阿美行去幸運麥 Express。沿路嘅 Rust 部機全部修好。"
    ),
    maps = require "src.data_rs",
    win = { stamp = "SERVED", bg = "bg_times", title = "rwin1_title", head = "rwin1_head" },
  },
  {
    id = "rs_adv",
    track = "rust",
    tag = "R2",
    station = "ADVANCED",
    name = L("ADVANCED  -  the kitchen", "ADVANCED  -  주방", "ADVANCED  -  廚房"),
    goal = L(
      "Inside Lucky Mac Express the kitchen runs on Rust threads. Earn the tea set.",
      "럭키 맥 익스프레스 주방은 Rust 스레드로 돌아간다. 티세트를 타라.",
      "幸運麥 Express 廚房用 Rust thread 運作。攞到下午茶餐。"
    ),
    maps = require "src.data_rs_adv",
    win = { stamp = "SERVED", bg = "bg_set", title = "rwin2_title", head = "rwin2_head" },
  },
  {
    id = "rs_pro",
    track = "rust",
    tag = "R3",
    station = "DELIVERY",
    name = L("DELIVERY  -  the app", "DELIVERY  -  앱", "DELIVERY  -  App"),
    goal = L(
      "Before the dinner rush, rewrite the delivery backend in Rust. Ship it.",
      "저녁 러시 전에 배달 백엔드를 Rust로 다시 쓰기. 배포하라.",
      "晚市前用 Rust 重寫外賣後台。出貨。"
    ),
    maps = require "src.data_rs_pro",
    win = { stamp = "SHIPPED", bg = "bg_street", title = "rwin3_title", head = "rwin3_head" },
  },
  {
    id = "rs_rush",
    track = "rust",
    tag = "R4",
    station = "RUSH",
    name = L("CODE RUSH  -  the interview", "CODE RUSH  -  면접", "CODE RUSH  -  面試"),
    goal = L(
      "The evening CODE RUSH is the Rust round. Seven classic problems. Get HIRED.",
      "저녁 코드 러시는 Rust 라운드. 고전 문제 일곱 개. 합격하라.",
      "夜晚嘅 CODE RUSH 係 Rust 回合。七條經典題。攞到份工。"
    ),
    maps = require "src.data_rs_quiz",
    win = { stamp = "HIRED", bg = "bg_mall", title = "rwin4_title", head = "rwin4_head" },
  },
  {
    id = "py_basic",
    track = "python",
    tag = "P1",
    station = "BASIC",
    name = L("NIGHT SHIFT  -  the kitchen", "NIGHT SHIFT  -  주방", "NIGHT SHIFT  -  廚房"),
    goal = L(
      "The night shift at Lucky Mac runs on Chef Bo's Python scripts. Fix every station before closing.",
      "럭키 맥의 야간 근무는 보 셰프의 Python 스크립트로 돌아간다. 마감 전에 모든 스테이션을 고쳐라.",
      "幸運麥夜班靠寶廚嘅 Python script 運作。收工前修好每個崗位。"
    ),
    maps = require "src.data_py",
    win = { stamp = "CLOSED", bg = "bg_night", title = "pwin1_title", head = "pwin1_head" },
  },
  {
    id = "py_adv",
    track = "python",
    tag = "P2",
    station = "ADVANCED",
    name = L("ADVANCED  -  the back office", "ADVANCED  -  사무실", "ADVANCED  -  後勤房"),
    goal = L(
      "The back office robot runs on generators, decorators and asyncio. Earn the midnight bowl.",
      "사무실 로봇은 제너레이터, 데코레이터, asyncio로 돌아간다. 심야 국수를 타라.",
      "後勤房部機械人靠 generator、decorator 同 asyncio 運作。攞到宵夜嗰碗麵。"
    ),
    maps = require "src.data_py_adv",
    win = { stamp = "SERVED", bg = "bg_lab", title = "pwin2_title", head = "pwin2_head" },
  },
  {
    id = "py_rush",
    track = "python",
    tag = "P3",
    station = "RUSH",
    name = L("CODE RUSH  -  the interview", "CODE RUSH  -  면접", "CODE RUSH  -  面試"),
    goal = L(
      "The midnight CODE RUSH is the Python round. Seven classic problems. Get HIRED.",
      "심야 코드 러시는 Python 라운드. 고전 문제 일곱 개. 합격하라.",
      "午夜嘅 CODE RUSH 係 Python 回合。七條經典題。攞到份工。"
    ),
    maps = require "src.data_py_quiz",
    win = { stamp = "HIRED", bg = "bg_market", title = "pwin3_title", head = "pwin3_head" },
  },
  {
    id = "bigo",
    track = "go",
    tag = "Q5",
    station = "BIG O",
    name = L("BIG O  -  how fast is it", "BIG O  -  얼마나 빠른가", "BIG O  -  有幾快"),
    goal = L(
      "Seven streets of Big O. Read a loop, name its cost, then write the faster one, in Go.",
      "빅오 일곱 거리. 루프를 읽고 비용을 말하고, 더 빠른 코드를 Go로 쓰기.",
      "七條 Big O 街。睇 loop、講成本，再用 Go 寫個快啲嘅。"
    ),
    maps = require "src.data_bigo",
    win = { stamp = "O(1)", bg = "bg_lab", title = "bwin_title", head = "bwin_head" },
  },
  {
    id = "rs_bigo",
    track = "rust",
    tag = "R5",
    station = "BIG O",
    name = L("BIG O  -  how fast is it", "BIG O  -  얼마나 빠른가", "BIG O  -  有幾快"),
    goal = L(
      "Seven streets of Big O. Read a loop, name its cost, then write the faster one, in Rust.",
      "빅오 일곱 거리. 루프를 읽고 비용을 말하고, 더 빠른 코드를 Rust로 쓰기.",
      "七條 Big O 街。睇 loop、講成本，再用 Rust 寫個快啲嘅。"
    ),
    maps = require "src.data_rs_bigo",
    win = { stamp = "O(1)", bg = "bg_lab", title = "rbwin_title", head = "rbwin_head" },
  },
  {
    id = "py_bigo",
    track = "python",
    tag = "P4",
    station = "BIG O",
    name = L("BIG O  -  how fast is it", "BIG O  -  얼마나 빠른가", "BIG O  -  有幾快"),
    goal = L(
      "Seven streets of Big O. Read a loop, name its cost, then write the faster one, in Python.",
      "빅오 일곱 거리. 루프를 읽고 비용을 말하고, 더 빠른 코드를 Python으로 쓰기.",
      "七條 Big O 街。睇 loop、講成本，再用 Python 寫個快啲嘅。"
    ),
    maps = require "src.data_py_bigo",
    win = { stamp = "O(1)", bg = "bg_lab", title = "pwin4_title", head = "pwin4_head" },
  },
  {
    id = "callback",
    track = "go",
    tag = "Q6",
    station = "CALLBACK",
    name = L("CALLBACK  -  the whiteboard", "CALLBACK  -  화이트보드", "CALLBACK  -  白板"),
    goal = L(
      "The startup calls back. Seven whiteboard classics: stack, DP, window, heap, intervals, LRU, grid. Get the OFFER.",
      "스타트업의 콜백. 화이트보드 고전 일곱: 스택, DP, 윈도우, 힙, 구간, LRU, 그리드. 오퍼를 받아라.",
      "初創公司回電。七條白板經典題：stack、DP、window、heap、區間、LRU、grid。攞到 OFFER。"
    ),
    maps = require "src.data_callback",
    win = { stamp = "OFFER", bg = "bg_lab", title = "cwin_title", head = "cwin_head" },
  },
  {
    id = "rs_callback",
    track = "rust",
    tag = "R6",
    station = "CALLBACK",
    name = L("CALLBACK  -  the whiteboard", "CALLBACK  -  화이트보드", "CALLBACK  -  白板"),
    goal = L(
      "The evening callback is the Rust round. Seven whiteboard classics. Get the OFFER.",
      "저녁 콜백은 Rust 라운드. 화이트보드 고전 일곱. 오퍼를 받아라.",
      "夜晚嘅回電係 Rust 回合。七條白板經典題。攞到 OFFER。"
    ),
    maps = require "src.data_rs_callback",
    win = { stamp = "OFFER", bg = "bg_lab", title = "rcwin_title", head = "rcwin_head" },
  },
  {
    id = "py_callback",
    track = "python",
    tag = "P5",
    station = "CALLBACK",
    name = L("CALLBACK  -  the whiteboard", "CALLBACK  -  화이트보드", "CALLBACK  -  白板"),
    goal = L(
      "The 1 a.m. callback is the Python round. Seven whiteboard classics. Get the OFFER.",
      "새벽 1시의 콜백은 Python 라운드. 화이트보드 고전 일곱. 오퍼를 받아라.",
      "凌晨一點嘅回電係 Python 回合。七條白板經典題。攞到 OFFER。"
    ),
    maps = require "src.data_py_callback",
    win = { stamp = "OFFER", bg = "bg_lab", title = "pcwin_title", head = "pcwin_head" },
  },
  {
    id = "conc",
    track = "go",
    tag = "Q7",
    station = "THREADS",
    name = L("THREADS  -  the lunch rush", "THREADS  -  점심 러시", "THREADS  -  午市"),
    goal = L(
      "Two tills, six woks and forty riders touch the same numbers. Lock it, share it, cancel it. And find Go's await.",
      "계산대 둘, 웍 여섯, 라이더 마흔이 같은 숫자를 만진다. 잠그고, 공유하고, 취소하라. 그리고 Go의 await를 찾아라.",
      "兩部收銀、六隻鑊、四十個外賣員掂住同一啲數。上鎖、共享、取消。再搵出 Go 嘅 await。"
    ),
    maps = require "src.data_conc",
    win = { stamp = "SYNCED", bg = "bg_kitchen", title = "twin_title", head = "twin_head" },
  },
  {
    id = "py_mp",
    track = "python",
    tag = "P6",
    station = "PARALLEL",
    name = L("PARALLEL  -  the night batch", "PARALLEL  -  야간 배치", "PARALLEL  -  夜更批次"),
    goal = L(
      "Forty thousand photos before the morning van, and threads made it no faster. Fill every core with processes.",
      "아침 배송차 전에 사진 사만 장. 스레드로는 빨라지지 않았다. 프로세스로 모든 코어를 채워라.",
      "朝早架車嚟之前要搞掂四萬張相，用 thread 又冇快過。用 process 填滿每個核。"
    ),
    maps = require "src.data_py_mp",
    win = { stamp = "SCALED", bg = "bg_night", title = "mpwin_title", head = "mpwin_head" },
  },
}

-- The tracks, in the order TAB cycles them. `label` is the button text in
-- every language; `item` the landmark drawn next to it on the map; `lang`
-- the fence tag a Markdown export uses for its code.
Quests.TRACKS = {
  { id = "go", label = "GO", item = "item_set", lang = "go" },
  { id = "rust", label = "RUST", item = "ferris", lang = "rust" },
  { id = "python", label = "PYTHON", item = "monty", lang = "python" },
}

function Quests.trackDef(id)
  for _, t in ipairs(Quests.TRACKS) do
    if t.id == id then
      return t
    end
  end
  return Quests.TRACKS[1]
end

-- Flat quest indices of one track, in order.
function Quests.ofTrack(track)
  local out = {}
  for q, quest in ipairs(Quests) do
    if quest.track == track then
      out[#out + 1] = q
    end
  end
  return out
end

function Quests.firstOf(track)
  return Quests.ofTrack(track)[1] or 1
end

-- 1-based position of quest q inside its own track (the "QUEST %d" number).
function Quests.indexInTrack(q)
  local quest = Quests[q]
  if not quest then
    return 1
  end
  for i, idx in ipairs(Quests.ofTrack(quest.track)) do
    if idx == q then
      return i
    end
  end
  return 1
end

function Quests.questOf(mapId)
  for q, quest in ipairs(Quests) do
    for _, m in ipairs(quest.maps) do
      if m.id == mapId then
        return q
      end
    end
  end
  return nil
end

-- Every street of every quest, flat, with its quest index: what the
-- exports and the badges walk.
function Quests.allMaps()
  local out = {}
  for q, quest in ipairs(Quests) do
    for i, m in ipairs(quest.maps) do
      out[#out + 1] = { quest = q, step = i, map = m }
    end
  end
  return out
end

return Quests
