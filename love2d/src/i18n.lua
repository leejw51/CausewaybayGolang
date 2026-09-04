-- UI strings and the language switch.
--
-- English, Korean and Cantonese (Hong Kong written Chinese) are written inline
-- here and in src/data*.lua as { en = , ko = , yue = } tables. The languages
-- added later live in src/lang/<code>.lua as { ["English text"] = "..." } and
-- are looked up by the English string, so the data files stay as they are.
-- Anything missing in any language falls back to English.

local I18n = { lang = "en" }

I18n.LANGS = { "en", "ko", "yue", "zh", "ja", "es", "cs" }
I18n.NAMES = {
  en = "EN",
  ko = "한국어",
  yue = "粵語",
  zh = "简体中文",
  ja = "日本語",
  es = "Español",
  cs = "Čeština",
}

-- The by-English tables, loaded once. A language with no file is inline-only.
local TR = {}
for _, code in ipairs(I18n.LANGS) do
  local ok, t = pcall(require, "src.lang." .. code)
  if ok and type(t) == "table" then
    TR[code] = t
  end
end
I18n.TR = TR

local function lookup(v, lang)
  local s = v[lang]
  if s == nil then
    local tr = TR[lang]
    s = tr and tr[v.en]
  end
  return s or v.en
end

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
    en = "1-7 jump straight in.   Q quest.   TAB Go/Rust/Python.   F3 language.   F4 sound.   ESC quit.",
    ko = "1-7 바로 이동.   Q 퀘스트.   TAB Go/Rust/Python.   F3 언어.   F4 소리.   ESC 종료.",
    yue = "1-7 直接跳去。  Q 任務。  TAB Go/Rust/Python。  F3 語言。  F4 聲音。  ESC 離開。",
  },
  tagline_rust = {
    en = "Fix the Rust bugs. Get the afternoon tea set.",
    ko = "Rust 버그를 고치세요. 애프터눈 티세트를 받으세요.",
    yue = "修好 Rust 嘅 bug，先至有下午茶餐。",
  },
  track_line = { en = "%s TRACK", ko = "%s 트랙", yue = "%s 路線" },
  clear = { en = "CLEAR", ko = "클리어", yue = "完成" },
  cleared = { en = "CLEARED", ko = "클리어 완료", yue = "已完成" },
  here = { en = "HERE", ko = "여기", yue = "而家喺度" },
  map_help = {
    en = "ARROWS walk    ENTER go    1-7 jump    Q quest    TAB language    %s",
    ko = "방향키 이동    ENTER 입장    1-7 점프    Q 퀘스트    TAB 언어    %s",
    yue = "方向鍵行    ENTER 入去    1-7 跳    Q 任務    TAB 語言    %s",
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
    en = "TAB hint   F5 auto   F6 share   ESC map",
    ko = "TAB 힌트   F5 자동   F6 공유   ESC 맵",
    yue = "TAB 提示   F5 自動   F6 分享   ESC 地圖",
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
  rwin1_title = {
    en = "Lucky Mac Express  ·  Times Square",
    ko = "럭키 맥 익스프레스  ·  타임스퀘어",
    yue = "幸運麥 Express  ·  時代廣場",
  },
  rwin1_head = {
    en = "WHAT ALEX LEARNED: Rust basics, ownership.   PRIZE: the afternoon tea set.",
    ko = "알렉스가 배운 것: Rust 기초, 소유권.   상품: 애프터눈 티세트.",
    yue = "阿力學識咗：Rust 基礎、ownership。   獎品：下午茶餐。",
  },
  rwin2_title = {
    en = "Lucky Mac Express  ·  the tea set",
    ko = "럭키 맥 익스프레스  ·  티세트",
    yue = "幸運麥 Express  ·  下午茶餐",
  },
  rwin2_head = {
    en = "WHAT ALEX LEARNED: Result, traits, lifetimes, threads, Arc<Mutex>.   PRIZE: milk tea and a pineapple bun.",
    ko = "알렉스가 배운 것: Result, 트레이트, 라이프타임, 스레드, Arc<Mutex>.   상품: 밀크티와 파인애플번.",
    yue = "阿力學識咗：Result、trait、lifetime、thread、Arc<Mutex>。   獎品：奶茶同菠蘿包。",
  },
  rwin3_title = {
    en = "Lucky Mac Express  ·  Rust backend",
    ko = "럭키 맥 익스프레스  ·  Rust 백엔드",
    yue = "幸運麥 Express  ·  Rust 後台",
  },
  rwin3_head = {
    en = "WHAT ALEX LEARNED: String, errors, iterators, serde, async, cargo.   PRIZE: the service shipped.",
    ko = "알렉스가 배운 것: String, 에러, 이터레이터, serde, async, cargo.   상품: 서비스 배포 완료.",
    yue = "阿力學識咗：String、error、iterator、serde、async、cargo。   獎品：服務出貨。",
  },
  rwin4_title = {
    en = "CODE RUSH  ·  the Rust round",
    ko = "코드 러시  ·  Rust 라운드",
    yue = "CODE RUSH  ·  Rust 回合",
  },
  rwin4_head = {
    en = "WHAT MEI SHOWED: recursion, trees, graphs, lists, sorting, hashing, workers, in Rust.   PRIZE: HIRED.",
    ko = "메이가 보여준 것: 재귀, 트리, 그래프, 리스트, 정렬, 해시, 워커, Rust로.   상품: 합격.",
    yue = "阿美示範咗：遞歸、樹、graph、list、排序、hash、worker，全部用 Rust。   獎品：受聘。",
  },
  combo = { en = "COMBO x%d", ko = "콤보 x%d", yue = "連擊 x%d" },
  streak = { en = "STREAK x%d", ko = "연속 x%d", yue = "連續 x%d" },
  perfect = { en = "PERFECT!", ko = "퍼펙트!", yue = "完美！" },
  -- the three CLEAR effects (src/fx.lua): a blank, a street, a quest
  fx_step = { en = "NICE!", ko = "좋아!", yue = "好嘢！" },
  fx_street = { en = "STREET CLEAR!", ko = "거리 클리어!", yue = "呢條街過咗！" },
  fx_quest = { en = "QUEST CLEAR!", ko = "퀘스트 클리어!", yue = "任務完成！" },
  clear_prize = {
    en = "CLEAR   ENTER for the set",
    ko = "클리어   ENTER 세트 받기",
    yue = "完成   ENTER 攞套餐",
  },
  tagline_py = {
    en = "Fix the Python scripts. Close the night shift.",
    ko = "Python 스크립트를 고치세요. 야간 근무를 마감하세요.",
    yue = "修好 Python script，先至收得工。",
  },
  -- Python track win screens
  pwin1_title = {
    en = "Lucky Mac  ·  the night shift",
    ko = "럭키 맥  ·  야간 근무",
    yue = "幸運麥  ·  夜班",
  },
  pwin1_head = {
    en = "WHAT ALEX LEARNED: Python basics, lists, dicts, classes.   PRIZE: the shutter comes down.",
    ko = "알렉스가 배운 것: Python 기초, 리스트, 딕셔너리, 클래스.   상품: 셔터를 내린다.",
    yue = "阿力學識咗：Python 基礎、list、dict、class。   獎品：落閘收工。",
  },
  pwin2_title = {
    en = "Lucky Mac  ·  the back office",
    ko = "럭키 맥  ·  사무실",
    yue = "幸運麥  ·  後勤房",
  },
  pwin2_head = {
    en = "WHAT ALEX LEARNED: exceptions, generators, decorators, with, asyncio, typing.   PRIZE: the midnight bowl.",
    ko = "알렉스가 배운 것: 예외, 제너레이터, 데코레이터, with, asyncio, 타이핑.   상품: 심야 국수.",
    yue = "阿力學識咗：exception、generator、decorator、with、asyncio、typing。   獎品：宵夜嗰碗麵。",
  },
  pwin3_title = {
    en = "CODE RUSH  ·  the Python round",
    ko = "코드 러시  ·  Python 라운드",
    yue = "CODE RUSH  ·  Python 回合",
  },
  pwin3_head = {
    en = "WHAT CHEF BO SHOWED: recursion, trees, graphs, lists, sorting, hashing, workers, in Python.   PRIZE: HIRED.",
    ko = "보 셰프가 보여준 것: 재귀, 트리, 그래프, 리스트, 정렬, 해시, 워커, Python으로.   상품: 합격.",
    yue = "寶廚示範咗：遞歸、樹、graph、list、排序、hash、worker，全部用 Python。   獎品：受聘。",
  },
  pwin4_title = {
    en = "BIG O  ·  the Python round",
    ko = "빅오  ·  Python 라운드",
    yue = "BIG O  ·  Python 回合",
  },
  pwin4_head = {
    en = "WHAT ALEX LEARNED: O(1) to O(2^n), and how to read a loop.   PRIZE: the O(1) stamp.",
    ko = "알렉스가 배운 것: O(1)부터 O(2^n)까지, 그리고 루프를 읽는 법.   상품: O(1) 도장.",
    yue = "阿力學識咗：由 O(1) 到 O(2^n)，同埋點樣讀一個 loop。   獎品：O(1) 印。",
  },
  bwin_title = {
    en = "BIG O  ·  the Go round",
    ko = "빅오  ·  Go 라운드",
    yue = "BIG O  ·  Go 回合",
  },
  bwin_head = {
    en = "WHAT ALEX LEARNED: O(1) to O(2^n), maps beat loops, sort then search.   PRIZE: the O(1) stamp.",
    ko = "알렉스가 배운 것: O(1)부터 O(2^n)까지, 맵이 루프를 이기고, 정렬 후 탐색.   상품: O(1) 도장.",
    yue = "阿力學識咗：由 O(1) 到 O(2^n)，map 快過 loop，先排序再搜尋。   獎品：O(1) 印。",
  },
  rbwin_title = {
    en = "BIG O  ·  the Rust round",
    ko = "빅오  ·  Rust 라운드",
    yue = "BIG O  ·  Rust 回合",
  },
  rbwin_head = {
    en = "WHAT MEI SHOWED: O(1) to O(2^n), HashMap beats Vec::contains, sort then binary_search.   PRIZE: the O(1) stamp.",
    ko = "메이가 보여준 것: O(1)부터 O(2^n)까지, HashMap이 Vec::contains를 이기고, 정렬 후 binary_search.   상품: O(1) 도장.",
    yue = "阿美示範咗：由 O(1) 到 O(2^n)，HashMap 快過 Vec::contains，先排序再 binary_search。   獎品：O(1) 印。",
  },
  cwin_title = {
    en = "CALLBACK  ·  the Go round",
    ko = "콜백  ·  Go 라운드",
    yue = "CALLBACK  ·  Go 回合",
  },
  cwin_head = {
    en = "WHAT ALEX LEARNED: stacks, DP, sliding windows, heaps, intervals, LRU, grid DFS.   PRIZE: the OFFER.",
    ko = "알렉스가 배운 것: 스택, DP, 슬라이딩 윈도우, 힙, 구간, LRU, 그리드 DFS.   상품: 오퍼.",
    yue = "阿力學識咗：stack、DP、sliding window、heap、區間、LRU、grid DFS。   獎品：OFFER。",
  },
  rcwin_title = {
    en = "CALLBACK  ·  the Rust round",
    ko = "콜백  ·  Rust 라운드",
    yue = "CALLBACK  ·  Rust 回合",
  },
  rcwin_head = {
    en = "WHAT MEI SHOWED: Vec as a stack, DP tables, windows, BinaryHeap, intervals, an LRU, grid DFS.   PRIZE: the OFFER.",
    ko = "메이가 보여준 것: 스택으로 쓰는 Vec, DP 표, 윈도우, BinaryHeap, 구간, LRU, 그리드 DFS.   상품: 오퍼.",
    yue = "阿美示範咗：用 Vec 做 stack、DP 表、window、BinaryHeap、區間、LRU、grid DFS。   獎品：OFFER。",
  },
  pcwin_title = {
    en = "CALLBACK  ·  the Python round",
    ko = "콜백  ·  Python 라운드",
    yue = "CALLBACK  ·  Python 回合",
  },
  pcwin_head = {
    en = "WHAT CHEF BO SHOWED: list stacks, DP, windows, heapq, intervals, OrderedDict LRU, grid DFS.   PRIZE: the OFFER.",
    ko = "보 셰프가 보여준 것: 리스트 스택, DP, 윈도우, heapq, 구간, OrderedDict LRU, 그리드 DFS.   상품: 오퍼.",
    yue = "寶廚示範咗：list stack、DP、window、heapq、區間、OrderedDict LRU、grid DFS。   獎品：OFFER。",
  },
  twin_title = {
    en = "THREADS  ·  the lunch rush",
    ko = "THREADS  ·  점심 러시",
    yue = "THREADS  ·  午市",
  },
  twin_head = {
    en = "WHAT ALEX LEARNED: Mutex and atomics, shared references, worker pools, pipelines, context, and that go plus a channel is await.   PRIZE: the SYNCED stamp.",
    ko = "알렉스가 배운 것: 뮤텍스와 원자 연산, 공유 참조, 워커 풀, 파이프라인, context, 그리고 go에 채널을 더하면 그것이 await라는 것.   상품: SYNCED 도장.",
    yue = "阿力學識咗：Mutex 同 atomic、共享 reference、worker pool、pipeline、context，仲有 go 加一條 channel 就係 await。   獎品：SYNCED 印。",
  },
  mpwin_title = {
    en = "PARALLEL  ·  the night batch",
    ko = "PARALLEL  ·  야간 배치",
    yue = "PARALLEL  ·  夜更批次",
  },
  mpwin_head = {
    en = "WHAT CHEF BO LEARNED: the GIL, Process and the main guard, Pool and chunksize, Queue and Pipe, locks and Value, shared_memory, ProcessPoolExecutor.   PRIZE: the SCALED stamp.",
    ko = "보 셰프가 배운 것: GIL, Process와 main 가드, Pool과 chunksize, Queue와 Pipe, 락과 Value, shared_memory, ProcessPoolExecutor.   상품: SCALED 도장.",
    yue = "寶廚學識咗：GIL、Process 同 main guard、Pool 同 chunksize、Queue 同 Pipe、鎖同 Value、shared_memory、ProcessPoolExecutor。   獎品：SCALED 印。",
  },
  mwin_title = {
    en = "MODULES  ·  the repo",
    ko = "MODULES  ·  저장소",
    yue = "MODULES  ·  個 repo",
  },
  mwin_head = {
    en = "WHAT ALEX LEARNED: the module path is the import path, a folder is a package, go get and go.sum, internal and cmd, replace and go.work, semver tags and /v2, the proxy and GOPRIVATE.   PRIZE: the v1.0.0 tag.",
    ko = "알렉스가 배운 것: 모듈 경로가 곧 import 경로, 폴더가 곧 패키지, go get과 go.sum, internal과 cmd, replace와 go.work, semver 태그와 /v2, 프록시와 GOPRIVATE.   상품: v1.0.0 태그.",
    yue = "阿力學識咗：module path 就係 import path、一個資料夾就係一個 package、go get 同 go.sum、internal 同 cmd、replace 同 go.work、semver tag 同 /v2、proxy 同 GOPRIVATE。   獎品：v1.0.0 tag。",
  },
  -- SHARE: copy and export
  share = { en = "SHARE", ko = "공유", yue = "分享" },
  share_title = { en = "SHARE THIS QUIZ", ko = "이 퀴즈 공유하기", yue = "分享呢個 quiz" },
  share_copy_head = {
    en = "COPY  (ask your AI why)",
    ko = "복사  (AI에게 이유 묻기)",
    yue = "複製  (問你嘅 AI 點解)",
  },
  share_export_head = {
    en = "EXPORT  to ~/Downloads",
    ko = "내보내기  ~/Downloads",
    yue = "匯出  去 ~/Downloads",
  },
  copy_q = { en = "1  QUESTION", ko = "1  문제", yue = "1  問題" },
  copy_hint = { en = "2  HINT", ko = "2  힌트", yue = "2  提示" },
  copy_answer = { en = "3  ANSWER", ko = "3  정답", yue = "3  答案" },
  copy_all = { en = "4  ALL", ko = "4  전부", yue = "4  全部" },
  scope_street = { en = "S  THIS STREET", ko = "S  이 거리", yue = "S  呢條街" },
  scope_quest = { en = "S  WHOLE QUEST", ko = "S  퀘스트 전체", yue = "S  整個任務" },
  scope_track = { en = "S  WHOLE TRACK", ko = "S  트랙 전체", yue = "S  整條路線" },
  exp_md = { en = "5  MARKDOWN", ko = "5  마크다운", yue = "5  MARKDOWN" },
  exp_csv = { en = "6  CSV", ko = "6  CSV", yue = "6  CSV" },
  exp_jsonl = { en = "7  JSONL", ko = "7  JSONL", yue = "7  JSONL" },
  exp_txt = { en = "8  TXT", ko = "8  TXT", yue = "8  TXT" },
  exp_sqlite = { en = "9  SQLITE", ko = "9  SQLITE", yue = "9  SQLITE" },
  exp_png = { en = "0  PNG DISK", ko = "0  PNG 디스크", yue = "0  PNG 碟" },
  exp_all = { en = "A  ALL FORMATS", ko = "A  모든 형식", yue = "A  全部格式" },
  share_help = {
    en = "1-4 copy    5-0 export    A all    S scope    ESC close",
    ko = "1-4 복사    5-0 내보내기    A 전부    S 범위    ESC 닫기",
    yue = "1-4 複製    5-0 匯出    A 全部    S 範圍    ESC 閂",
  },
  toast_copied = { en = "COPIED  %s", ko = "복사됨  %s", yue = "已複製  %s" },
  toast_saved = { en = "SAVED  %s", ko = "저장됨  %s", yue = "已儲存  %s" },
  toast_saved_n = {
    en = "SAVED %d FILES  in %s",
    ko = "%d개 파일 저장됨  %s",
    yue = "已儲存 %d 個檔  喺 %s",
  },
  toast_fail = { en = "FAILED  %s", ko = "실패  %s", yue = "失敗  %s" },
  share_ask = {
    en = "Ask your AI: why is `%s` the answer here, and what breaks with anything else?",
    ko = "AI에게 물어보세요: 여기서 왜 `%s`가 정답이고, 다른 걸 넣으면 무엇이 깨지나요?",
    yue = "問你嘅 AI：點解呢度答案係 `%s`，填其他嘢會壞咩？",
  },
  share_png_foot = {
    en = "a lesson you can carry in a photo album",
    ko = "사진 앨범에 넣어 다니는 수업",
    yue = "放喺相簿隨時攞出嚟學嘅一課",
  },
  -- XP, levels, badges
  xp_line = { en = "LV %d   XP %d / %d", ko = "LV %d   XP %d / %d", yue = "LV %d   XP %d / %d" },
  xp_short = {
    en = "LV %d  ·  %d XP  ·  %d badges",
    ko = "LV %d  ·  %d XP  ·  배지 %d개",
    yue = "LV %d  ·  %d XP  ·  %d 個徽章",
  },
  xp_gain = { en = "+%d XP", ko = "+%d XP", yue = "+%d XP" },
  level_up = { en = "LEVEL UP!  LV %d", ko = "레벨 업!  LV %d", yue = "升級！  LV %d" },
  fast = { en = "FAST!", ko = "빠름!", yue = "快！" },
  badge_pop = { en = "BADGE  %s", ko = "배지  %s", yue = "徽章  %s" },
  badges_head = { en = "BADGES", ko = "배지", yue = "徽章" },
  badge_first_clear = { en = "FIRST CLEAR", ko = "첫 클리어", yue = "第一次完成" },
  badge_combo5 = { en = "COMBO x5", ko = "콤보 x5", yue = "連擊 x5" },
  badge_combo10 = { en = "COMBO x10", ko = "콤보 x10", yue = "連擊 x10" },
  badge_perfect = { en = "PERFECT STREET", ko = "퍼펙트 거리", yue = "完美一條街" },
  badge_perfect5 = { en = "FIVE PERFECTS", ko = "퍼펙트 다섯 번", yue = "五次完美" },
  badge_fast10 = { en = "SPEED TYPER", ko = "스피드 타이퍼", yue = "快手" },
  badge_right100 = { en = "100 RIGHT", ko = "정답 100개", yue = "答對 100 題" },
  badge_stamp = { en = "FIRST STAMP", ko = "첫 도장", yue = "第一個印" },
  badge_trio = { en = "THREE LANGUAGES", ko = "세 언어", yue = "三種語言" },
  badge_polyglot = { en = "POLYGLOT", ko = "폴리글랏", yue = "通曉多語" },
  badge_bigo = { en = "BIG O MASTER", ko = "빅오 마스터", yue = "BIG O 大師" },
  badge_share = { en = "SHARED IT", ko = "공유했음", yue = "分享過" },
  badge_night = { en = "NIGHT OWL", ko = "올빼미", yue = "夜貓" },
  badge_early = { en = "EARLY BIRD", ko = "얼리버드", yue = "早起鳥" },
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
    return lookup(v, lang or I18n.lang) or ""
  end
  return v == nil and "" or tostring(v)
end

function I18n.t(key, ...)
  local v = S[key]
  local s = v and lookup(v, I18n.lang) or key
  if select("#", ...) > 0 then
    return string.format(s, ...)
  end
  return s
end

I18n.STRINGS = S

return I18n
