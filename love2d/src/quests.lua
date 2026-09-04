-- Two language tracks, four quests each. One flat list, so a quest index in
-- progress.jsonl stays stable (1-4 Go, 5-8 Rust) and a street id is unique
-- across the whole game.
--
--   GO    1 basic     GO SET     packages through interfaces, the walk to Lucky Mac
--         2 advanced  ADVANCED   goroutines through context, the morning set
--         3 delivery  DELIVERY   strings, errors, JSON, HTTP, the go tool, Go 1.21+
--         4 rush      RUSH       CODE RUSH: the coding-interview game show
--   RUST  5 rs_basic  BASIC      let through struct, the walk to Lucky Mac Express
--         6 rs_adv    ADVANCED   Result through Arc<Mutex>, the afternoon kitchen
--         7 rs_pro    DELIVERY   strings, errors, serde, async, cargo, modern Rust
--         8 rs_rush   RUSH       CODE RUSH: the evening Rust round

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
}

-- The tracks, in the order TAB cycles them. `label` is the button text in
-- every language; `item` the landmark drawn next to it on the map.
Quests.TRACKS = {
  { id = "go", label = "GO", item = "item_set" },
  { id = "rust", label = "RUST", item = "ferris" },
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

return Quests
