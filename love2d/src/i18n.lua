-- English / Korean / Cantonese (Hong Kong written Chinese) for the UI.

local I18n = { lang = "en" }

I18n.LANGS = { "en", "ko", "yue" }
I18n.NAMES = { en = "EN", ko = "한국어", yue = "粵語" }

local S = {
  subtitle = { en = "Causeway Bay", ko = "코즈웨이베이", yue = "銅鑼灣" },
  tagline = {
    en = "Fix the Go bugs. Get the morning set.",
    ko = "Go 버그를 고치세요. 모닝세트를 받으세요.",
    yue = "修好 Go 嘅 bug，先至有早餐套餐。",
  },
  title_enter = { en = "ENTER  pick a street", ko = "ENTER  거리 고르기", yue = "ENTER  揀條街" },
  title_continue = {
    en = "C  continue at %s   (%d/%d streets clear)",
    ko = "C  %s에서 이어하기   (%d/%d 거리 클리어)",
    yue = "C  喺 %s 繼續   (%d/%d 條街完成)",
  },
  title_fresh = {
    en = "7 streets. One language. Type the answers.",
    ko = "7개의 거리, 하나의 언어. 답을 입력하세요.",
    yue = "7條街，一個語言。打答案。",
  },
  title_help = {
    en = "1-7 jump straight in.   Q quest.   F3 language.   F4 sound.   ESC quit.",
    ko = "1-7 바로 이동.   Q 퀘스트.   F3 언어.   F4 소리.   ESC 종료.",
    yue = "1-7 直接跳去。  Q 任務。  F3 語言。  F4 聲音。  ESC 離開。",
  },
  clear = { en = "CLEAR", ko = "클리어", yue = "完成" },
  here = { en = "HERE", ko = "여기", yue = "而家喺度" },
  map_help = {
    en = "ARROWS walk    ENTER go    1-7 jump    Q quest    %s",
    ko = "방향키 이동    ENTER 입장    1-7 점프    Q 퀘스트    %s",
    yue = "方向鍵行    ENTER 入去    1-7 跳    Q 任務    %s",
  },
  clear_count = { en = "%d / %d clear", ko = "%d / %d 클리어", yue = "%d / %d 完成" },
  esc_back = { en = "ESC back", ko = "ESC 돌아가기", yue = "ESC 返去" },
  esc_title = { en = "ESC title", ko = "ESC 타이틀", yue = "ESC 標題" },
  map_label = { en = "%s  MAP %d/%d  %s", ko = "%s  맵 %d/%d  %s", yue = "%s  地圖 %d/%d  %s" },
  clear_stamp = {
    en = "CLEAR   ENTER for the stamp",
    ko = "클리어   ENTER 도장 받기",
    yue = "完成   ENTER 攞印",
  },
  clear_map = {
    en = "CLEAR   ENTER back to the map",
    ko = "클리어   ENTER 맵으로",
    yue = "完成   ENTER 返地圖",
  },
  clear_next = {
    en = "CLEAR   ENTER next street",
    ko = "클리어   ENTER 다음 거리",
    yue = "完成   ENTER 下一條街",
  },
  q_prefix = { en = "Q: ", ko = "Q: ", yue = "Q: " },
  hint = { en = "HINT", ko = "힌트", yue = "提示" },
  answer = { en = "ANSWER", ko = "정답", yue = "答案" },
  hide = { en = "HIDE", ko = "닫기", yue = "收埋" },
  ok = { en = "OK", ko = "확인", yue = "確定" },
  auto = { en = "AUTO", ko = "자동", yue = "自動" },
  auto_on = { en = "STOP", ko = "멈춤", yue = "停" },
  next = { en = "NEXT", ko = "다음", yue = "下一個" },
  step_prev = { en = "< PREV", ko = "< 이전", yue = "< 上一個" },
  step_next = { en = "NEXT >", ko = "다음 >", yue = "下一個 >" },
  type_answer = { en = "type the answer", ko = "답을 입력하세요", yue = "打答案" },
  clear_prompt = { en = "CLEAR   ENTER  next", ko = "클리어   ENTER  다음", yue = "完成   ENTER  下一個" },
  help_play = {
    en = "TAB hint   F5 auto   ESC map",
    ko = "TAB 힌트   F5 자동   ESC 맵",
    yue = "TAB 提示   F5 自動   ESC 地圖",
  },
  help_walk = { en = "arrows walk   ESC map", ko = "방향키 걷기   ESC 맵", yue = "方向鍵行   ESC 地圖" },
  help_answer = {
    en = "TAB again: answer   ESC map",
    ko = "TAB 한 번 더: 정답   ESC 맵",
    yue = "再撳TAB：答案   ESC 地圖",
  },
  msg_empty = {
    en = "Type the answer, then ENTER.",
    ko = "답을 입력하고 ENTER.",
    yue = "打答案，然後撳ENTER。",
  },
  msg_wrong = {
    en = "Not quite. Read the hint and try again. HINT again shows the answer.",
    ko = "아쉽네요. 힌트를 읽고 다시 해보세요. 힌트를 한 번 더 누르면 정답이 보입니다.",
    yue = "唔啱。睇下提示再試。再撳提示會顯示答案。",
  },
  win_title = {
    en = "Lucky Mac  ·  Causeway Bay",
    ko = "럭키 맥  ·  코즈웨이베이",
    yue = "幸運麥  ·  銅鑼灣",
  },
  win_head = {
    en = "WHAT ALEX LEARNED: Go basics.   PRIZE: the morning set.",
    ko = "알렉스가 배운 것: Go 기초.   상품: 모닝세트.",
    yue = "阿力學識咗：Go 基礎。   獎品：早餐套餐。",
  },
  win_help = {
    en = "ENTER  street map      ESC  title",
    ko = "ENTER  거리 맵      ESC  타이틀",
    yue = "ENTER  街道地圖      ESC  標題",
  },
  quest_tab = { en = "QUEST %d", ko = "퀘스트 %d", yue = "任務 %d" },
  quest_help = { en = "Q other quest", ko = "Q 다른 퀘스트", yue = "Q 另一個任務" },
  quest_locked_hint = {
    en = "Four quests: BASIC, ADVANCED, DELIVERY, CODE RUSH. Q switches.",
    ko = "퀘스트 넷: 기초, 고급, 배달, 코드 러시. Q로 전환.",
    yue = "四個任務：基礎、進階、外賣、CODE RUSH。撳 Q 轉。",
  },
  win2_title = {
    en = "Lucky Mac  ·  the morning set",
    ko = "럭키 맥  ·  모닝세트",
    yue = "幸運麥  ·  早餐套餐",
  },
  win2_head = {
    en = "WHAT ALEX LEARNED: goroutines, channels, sync.   PRIZE: the morning set.",
    ko = "알렉스가 배운 것: 고루틴, 채널, 주방.   상품: 머핀, 해시브라운, 커피.",
    yue = "阿力學識咗：goroutine、channel、廚房。   獎品：鬆餅、薯餅、咖啡。",
  },
  win3_title = {
    en = "Lucky Mac  ·  delivery app",
    ko = "럭키 맥  ·  배달 앱",
    yue = "幸運麥  ·  外賣 App",
  },
  win3_head = {
    en = "WHAT ALEX LEARNED: strings, errors, JSON, HTTP.   PRIZE: the app is live.",
    ko = "알렉스가 배운 것: 문자열, 에러, JSON, HTTP, go 도구.   상품: 앱 오픈.",
    yue = "阿力學識咗：string、error、JSON、HTTP、go tool。   獎品：App 上線。",
  },
  win4_title = {
    en = "CODE RUSH  ·  Times Square",
    ko = "코드 러시  ·  타임스퀘어",
    yue = "CODE RUSH  ·  時代廣場",
  },
  win4_head = {
    en = "WHAT ALEX LEARNED: recursion, trees, graphs, lists, sorting, hashing, workers.   PRIZE: HIRED.",
    ko = "알렉스가 배운 것: 재귀, 트리, 그래프, 리스트, 정렬, 해시, 워커.   상품: 합격.",
    yue = "阿力學識咗：遞歸、樹、graph、list、排序、hash、worker。   獎品：受聘。",
  },
  combo = { en = "COMBO x%d", ko = "콤보 x%d", yue = "連擊 x%d" },
  streak = { en = "STREAK x%d", ko = "연속 x%d", yue = "連續 x%d" },
  perfect = { en = "PERFECT!", ko = "퍼펙트!", yue = "完美！" },
  clear_prize = {
    en = "CLEAR   ENTER for the set",
    ko = "클리어   ENTER 세트 받기",
    yue = "完成   ENTER 攞套餐",
  },
  hud_map = { en = "MAP", ko = "맵", yue = "地圖" },
  hud_back = { en = "BACK", ko = "뒤로", yue = "返去" },
  hud_full = { en = "FULL", ko = "전체", yue = "全屏" },
  hud_wind = { en = "WIND", ko = "창", yue = "視窗" },
  hud_port = { en = "PORT", ko = "세로", yue = "直向" },
  hud_land = { en = "LAND", ko = "가로", yue = "橫向" },
}

function I18n.set(lang)
  if I18n.NAMES[lang] then
    I18n.lang = lang
  end
  return I18n.lang
end

function I18n.cycle()
  for i, l in ipairs(I18n.LANGS) do
    if l == I18n.lang then
      return I18n.set(I18n.LANGS[i % #I18n.LANGS + 1])
    end
  end
  return I18n.set("en")
end

function I18n.pick(v, lang)
  if type(v) == "table" then
    return v[lang or I18n.lang] or v.en or ""
  end
  return v == nil and "" or tostring(v)
end

function I18n.t(key, ...)
  local v = S[key]
  local s = v and (v[I18n.lang] or v.en) or key
  if select("#", ...) > 0 then
    return string.format(s, ...)
  end
  return s
end

return I18n
