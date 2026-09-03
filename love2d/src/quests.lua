-- Three quests, three kinds of Go.
--
--   1  basic     GO SET     packages through interfaces, the walk to Lucky Mac
--   2  advanced  ADVANCED   goroutines through context, the morning set
--   3  delivery  DELIVERY   strings, errors, JSON, HTTP, the go tool, Go 1.21+
--   4  rush      RUSH       CODE RUSH: the coding-interview game show

local function L(en, ko, yue)
  return { en = en, ko = ko, yue = yue }
end

local Quests = {
  {
    id = "basic",
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
}

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
