-- Quest Q6 CALLBACK: the second interview. 14:30, the same afternoon. The
-- Times Square startup that shouted HIRED at CODE RUSH calls Alex back for
-- the whiteboard round in the back office: stacks, DP, sliding windows,
-- heaps, intervals, an LRU cache and a grid flood fill. Siu Ming asks, Mei
-- coaches, Alex holds the marker. Prize: an OFFER.
-- Same shape as src/data.lua: the blank ___ is NOT written in the code.

local function L(en, ko, yue)
  return { en = en, ko = ko, yue = yue }
end

local maps = {
  {
    id = "stack",
    station = "STACK",
    name = L("CALLBACK 1  -  the brackets", "2차 면접 1  -  괄호", "二面 1  -  括號"),
    title = L("Valid parentheses, min stack", "올바른 괄호, 최소 스택", "括號配對、min stack"),
    lesson = L(
      "A slice is a stack: append pushes, st[:len(st)-1] pops. Push every opener, match every closer against the top, valid when the stack ends empty. A min stack keeps a second stack of running minimums.",
      "슬라이스가 스택: append가 push, st[:len(st)-1]이 pop. 여는 괄호는 push, 닫는 괄호는 top과 대조, 끝에 스택이 비면 올바르다. 최소 스택은 누적 최솟값의 둘째 스택을 둔다.",
      "slice 就係 stack：append 係 push，st[:len(st)-1] 係 pop。開括號就 push，閂括號就同 top 對，最後 stack 空就合法。min stack 另外keep一個累積最細值嘅 stack。"
    ),
    bg = "bg_lab",
    portrait = "portrait_clerk",
    speaker = L("Siu Ming", "시우밍", "小明"),
    ground = 348,
    spawn = 160,
    width = 1600,
    npcs = {
      {
        kind = "clerk",
        x = 540,
        facing = -1,
        line = L(
          "Welcome back, Alex. The callback is the whiteboard round. First: are these brackets balanced?",
          "다시 왔군요, 알렉스. 2차는 화이트보드 라운드. 첫 문제: 이 괄호들은 균형이 맞나요?",
          "歡迎返嚟，阿力。二面係白板回合。第一題：呢啲括號平唔平衡？"
        ),
      },
      {
        kind = "mei",
        x = 760,
        facing = -1,
        line = L(
          "Whatever opened last must close first. That sentence is a stack.",
          "마지막에 연 게 먼저 닫혀야 해. 그 문장이 곧 스택이야.",
          "最後開嘅要最先閂。呢句嘢本身就係一個 stack。"
        ),
      },
    },
    viz = "chips",
    chips = {
      { "st = append(st, c)", "cyan" },
      { "st[top] == pairs[c]", "gold" },
      { "len(st) == 0", "pink" },
      { "low[n-1]", "green" },
    },
    note = "push  match top  pop  empty  running min",
    story = L(
      "14:30. The screen at Times Square still says HIRED, but the startup wants a second round in the back office: "
        .. "a whiteboard, a marker, Siu Ming with a list. Round one is the question every callback starts with: "
        .. "does every bracket close in the right order?",
      "14:30. 타임스퀘어 전광판엔 아직 HIRED가 떠 있지만 스타트업은 사무실에서 2차를 원한다: "
        .. "화이트보드, 마커, 목록을 든 시우밍. 첫 문제는 모든 2차 면접이 시작하는 그 질문: "
        .. "모든 괄호가 올바른 순서로 닫히는가?",
      "下晝兩點半。時代廣場個 mon 仲寫住 HIRED，但間 startup 想喺後勤房再嚟一輪："
        .. "一塊白板、一支筆、拎住清單嘅小明。第一題係每次二面都會開場嘅嗰條："
        .. "每個括號係唔係按正確次序閂？"
    ),
    stages = {
      {
        topic = "PAIRS",
        q = L(
          "Each closer maps to its opener. Fill the value stored for ')'.",
          "닫는 괄호마다 여는 괄호가 짝. ')'에 저장되는 값을 채우기.",
          "每個閂括號對應一個開括號。填 ')' 存嘅值。"
        ),
        code = L(
          [[
pairs := map[rune]rune{
    ')': ___,           // closer -> opener
    ']': '[',
    '}': '{',
}
]],
          [[
pairs := map[rune]rune{
    ')': ___,           // 닫는 것 -> 여는 것
    ']': '[',
    '}': '{',
}
]],
          [[
pairs := map[rune]rune{
    ')': ___,           // 閂 -> 開
    ']': '[',
    '}': '{',
}
]]
        ),
        answer = "'('",
        accept = { "'('", "(" },
        hint = L(
          "The round opener, as a rune literal in single quotes.",
          "둥근 여는 괄호, 작은따옴표의 rune 리터럴로.",
          "圓嘅開括號，用單引號寫成 rune literal。"
        ),
        ok = L(
          "A map turns 'does this closer match?' into one lookup. Openers are the values, closers the keys.",
          "맵이 '이 닫는 괄호가 맞나?'를 조회 한 번으로 만든다. 여는 것이 값, 닫는 것이 키.",
          "一個 map 將「呢個閂括號啱唔啱？」變成一次查找。開括號係 value，閂括號係 key。"
        ),
      },
      {
        topic = "PUSH",
        q = L(
          "An opener goes onto the stack. Which builtin grows the slice?",
          "여는 괄호는 스택에 올린다. 슬라이스를 늘리는 내장 함수는?",
          "開括號放上 stack。邊個內建 function 加長個 slice？"
        ),
        code = L(
          [[
st := []rune{}
for _, c := range s {
    if _, closer := pairs[c]; !closer {
        st = ___(st, c)     // an opener waits here
        continue
    }
}
]],
          [[
st := []rune{}
for _, c := range s {
    if _, closer := pairs[c]; !closer {
        st = ___(st, c)     // 여는 괄호 대기
        continue
    }
}
]],
          [[
st := []rune{}
for _, c := range s {
    if _, closer := pairs[c]; !closer {
        st = ___(st, c)     // 開括號喺度等
        continue
    }
}
]]
        ),
        answer = "append",
        accept = { "append" },
        hint = L(
          "The builtin that adds to the end of a slice and returns the new slice.",
          "슬라이스 끝에 더하고 새 슬라이스를 반환하는 내장 함수.",
          "加喺 slice 尾、回傳新 slice 嘅內建 function。"
        ),
        ok = L(
          "A slice is Go's stack: this pushes, st[:len(st)-1] pops. Both O(1), amortized.",
          "슬라이스가 Go의 스택: 이게 push, st[:len(st)-1]이 pop. 둘 다 분할 상환 O(1).",
          "slice 就係 Go 嘅 stack：呢個係 push，st[:len(st)-1] 係 pop。兩個攤分都係 O(1)。"
        ),
      },
      {
        topic = "MATCH",
        q = L(
          "A closer must match the top of the stack. Which map gives the opener it needs?",
          "닫는 괄호는 스택의 top과 맞아야 한다. 필요한 여는 괄호를 주는 맵은?",
          "閂括號要同 stack 個 top 對得上。邊個 map 畀佢需要嘅開括號？"
        ),
        code = L(
          [[
    // a closer: the top must be its opener
    top := len(st) - 1
    if top < 0 || st[top] != ___[c] {
        return false
    }
    st = st[:top]           // pop
]],
          [[
    // 닫는 괄호: top이 그 짝이어야
    top := len(st) - 1
    if top < 0 || st[top] != ___[c] {
        return false
    }
    st = st[:top]           // pop
]],
          [[
    // 閂括號：top 一定要係佢個開括號
    top := len(st) - 1
    if top < 0 || st[top] != ___[c] {
        return false
    }
    st = st[:top]           // pop
]]
        ),
        answer = "pairs",
        accept = { "pairs" },
        hint = L(
          "The closer-to-opener map from the first blank.",
          "첫 빈칸의 닫는 것-여는 것 맵.",
          "第一個空格嗰個閂對開嘅 map。"
        ),
        ok = L(
          "An empty stack on a closer is a failure too: ')(' must not pass. Then pop by reslicing.",
          "닫는 괄호에서 스택이 비어도 실패: ')('는 통과하면 안 된다. 그다음 리슬라이스로 pop.",
          "閂括號時 stack 係空都算失敗：')(' 唔可以過。之後 reslice 嚟 pop。"
        ),
      },
      {
        topic = "EMPTY",
        q = L(
          "Every opener must have been closed. What does the function return at the end?",
          "모든 여는 괄호가 닫혔어야 한다. 함수는 마지막에 무엇을 반환?",
          "每個開括號都要閂咗。function 最後回傳咩？"
        ),
        code = L(
          [[
    }
    // leftover openers are unclosed brackets
    return ___
}
]],
          [[
    }
    // 남은 여는 괄호는 닫히지 않은 괄호
    return ___
}
]],
          [[
    }
    // 剩低嘅開括號就係未閂嘅括號
    return ___
}
]]
        ),
        answer = "len(st) == 0",
        accept = { "len(st) == 0", "len(st)==0", "0 == len(st)" },
        hint = L(
          "True only when nothing is left on the stack: compare its length with zero.",
          "스택에 아무것도 안 남았을 때만 true: 길이를 0과 비교.",
          "stack 冇嘢剩先係 true：將長度同零比較。"
        ),
        ok = L(
          "Valid means matched and closed. O(n) time, O(n) stack in the worst case: a string of openers.",
          "올바르다는 건 짝이 맞고 닫혔다는 것. O(n) 시간, 최악엔 O(n) 스택: 전부 여는 괄호일 때.",
          "合法即係對得上而且閂晒。O(n) 時間，最差 O(n) stack：成串都係開括號。"
        ),
      },
      {
        topic = "MIN",
        q = L(
          "A min stack answers the minimum in O(1): a second slice keeps the running minimum. What is pushed onto low?",
          "최소 스택은 최솟값을 O(1)에 답한다: 둘째 슬라이스가 누적 최솟값을 둔다. low에 무엇을 push?",
          "min stack 用 O(1) 答最細值：第二個 slice 記住累積最細值。push 咩落 low？"
        ),
        code = L(
          [[
func (s *MinStack) Push(x int) {
    s.st = append(s.st, x)
    m := x
    if n := len(s.low); n > 0 {
        m = ___(x, s.low[n-1])   // the smaller of the two
    }
    s.low = append(s.low, m)
]],
          [[
func (s *MinStack) Push(x int) {
    s.st = append(s.st, x)
    m := x
    if n := len(s.low); n > 0 {
        m = ___(x, s.low[n-1])   // 둘 중 작은 것
    }
    s.low = append(s.low, m)
]],
          [[
func (s *MinStack) Push(x int) {
    s.st = append(s.st, x)
    m := x
    if n := len(s.low); n > 0 {
        m = ___(x, s.low[n-1])   // 兩個之中細嗰個
    }
    s.low = append(s.low, m)
]]
        ),
        answer = "min",
        accept = { "min" },
        hint = L(
          "Go 1.21 has a builtin for the smaller of two numbers.",
          "Go 1.21엔 두 수 중 작은 것을 주는 내장 함수가 있다.",
          "Go 1.21 有個內建 function 攞兩個數之中細嗰個。"
        ),
        ok = L(
          "Push, Pop and Min all O(1): low[len(low)-1] is always the smallest thing still on the stack.",
          "Push, Pop, Min 모두 O(1): low[len(low)-1]이 항상 스택에 남은 것 중 가장 작다.",
          "Push、Pop、Min 全部 O(1)：low[len(low)-1] 永遠係 stack 上面仲喺度嘅最細值。"
        ),
      },
    },
  },
  {
    id = "dp",
    station = "DP",
    name = L("CALLBACK 2  -  the stairs", "2차 면접 2  -  계단", "二面 2  -  樓梯"),
    title = L("Dynamic programming", "동적 계획법", "動態規劃"),
    lesson = L(
      "DP: a table of answers to smaller problems, filled from the base cases up. Stairs: dp[i] = dp[i-1] + dp[i-2]. Coin change: dp[a] = min over coins of dp[a-c] + 1, with a sentinel for 'impossible'.",
      "DP: 더 작은 문제들의 답을 표에 담고 기저 조건부터 위로 채운다. 계단: dp[i] = dp[i-1] + dp[i-2]. 동전 교환: dp[a] = 동전마다 dp[a-c] + 1의 최솟값, '불가능'은 센티널로.",
      "DP：一個表記住細啲問題嘅答案，由 base case 向上填。樓梯：dp[i] = dp[i-1] + dp[i-2]。找換硬幣：dp[a] = 每個硬幣 dp[a-c] + 1 之中最細，「唔可能」用 sentinel。"
    ),
    bg = "bg_lab",
    portrait = "portrait_friends",
    speaker = L("Mei", "메이", "阿美"),
    ground = 348,
    spawn = 160,
    width = 1600,
    npcs = {
      {
        kind = "clerk",
        x = 540,
        facing = -1,
        line = L(
          "Round two. The MTR exit has n steps, you take one or two at a time. How many ways up?",
          "2라운드. MTR 출구 계단이 n칸, 한 번에 한 칸이나 두 칸. 올라가는 방법은 몇 가지?",
          "第二題。MTR 出口有 n 級樓梯，一次行一級或兩級。有幾多種行法上去？"
        ),
      },
      {
        kind = "mei",
        x = 780,
        facing = -1,
        line = L(
          "Do not recurse. Fill a table from the bottom step up.",
          "재귀하지 마. 맨 아래 칸부터 표를 채워.",
          "唔好遞歸。由最底一級開始填個表。"
        ),
      },
    },
    viz = "chips",
    chips = {
      { "dp := make([]int, n+1)", "cyan" },
      { "dp[i-1] + dp[i-2]", "gold" },
      { "sentinel: amount + 1", "pink" },
      { "min(dp[a], dp[a-c]+1)", "green" },
    },
    note = "base cases  fill up  sentinel  min  -1",
    story = L(
      "Siu Ming draws the Causeway Bay MTR exit: n steps. Then the till: coins of 1, 3 and 4, and an amount to make "
        .. "with the fewest coins. Two problems, one trick: write the answer for the small cases, "
        .. "then build every bigger one out of the ones already on the board.",
      "시우밍이 코즈웨이베이 MTR 출구를 그린다: 계단 n칸. 그다음 계산대: 1, 3, 4짜리 동전과 가장 적은 동전으로 만들 금액. "
        .. "문제 둘, 요령 하나: 작은 경우의 답을 적고, "
        .. "더 큰 경우는 이미 보드에 있는 것들로 조립한다.",
      "小明畫出銅鑼灣 MTR 出口：n 級樓梯。然後係收銀機：1、3、4 蚊嘅硬幣，同一個要用最少硬幣砌出嚟嘅金額。"
        .. "兩條題，一個竅門：先寫低細嘅情況嘅答案，"
        .. "再用板上已經有嘅答案砌出每一個大啲嘅。"
    ),
    stages = {
      {
        topic = "BASE",
        q = L(
          "Stairs, one or two steps at a time. How many ways reach step 2?",
          "계단, 한 번에 한 칸이나 두 칸. 2번 칸에 닿는 방법은 몇 가지?",
          "樓梯，一次一級或兩級。去到第 2 級有幾多種行法？"
        ),
        code = L(
          [[
func climb(n int) int {
    dp := make([]int, n+1)  // dp[i] = ways to reach step i
    dp[1] = 1
    dp[2] = ___             // 1+1, or 2
]],
          [[
func climb(n int) int {
    dp := make([]int, n+1)  // i번 칸까지의 방법 수
    dp[1] = 1
    dp[2] = ___             // 1+1, 아니면 2
]],
          [[
func climb(n int) int {
    dp := make([]int, n+1)  // 去到第 i 級嘅行法
    dp[1] = 1
    dp[2] = ___             // 1+1，或者 2
]]
        ),
        answer = "2",
        accept = { "2" },
        hint = L(
          "Two singles, or one double. Count them.",
          "한 칸씩 두 번, 아니면 두 칸 한 번. 세어보기.",
          "兩次一級，或者一次兩級。數吓。"
        ),
        ok = L(
          "A DP table starts from the cases you can answer by hand. Everything else is built on them.",
          "DP 표는 손으로 답할 수 있는 경우에서 시작한다. 나머지는 그 위에 쌓는다.",
          "DP 表由你可以用手答嘅情況開始。其餘全部砌喺佢哋上面。"
        ),
      },
      {
        topic = "STEP",
        q = L(
          "Step i is reached from one step below or two steps below. Fill dp[i].",
          "i번 칸엔 한 칸 아래나 두 칸 아래에서 닿는다. dp[i]를 채우기.",
          "第 i 級係由下一級或者下兩級上嚟。填 dp[i]。"
        ),
        code = L(
          [[
    for i := 3; i <= n; i++ {
        dp[i] = ___         // from one below, or two below
    }
    return dp[n]
}
]],
          [[
    for i := 3; i <= n; i++ {
        dp[i] = ___         // 한두 칸 아래에서
    }
    return dp[n]
}
]],
          [[
    for i := 3; i <= n; i++ {
        dp[i] = ___         // 由下一級或下兩級
    }
    return dp[n]
}
]]
        ),
        answer = "dp[i-1] + dp[i-2]",
        accept = { "dp[i-1] + dp[i-2]", "dp[i-1]+dp[i-2]", "dp[i-2] + dp[i-1]", "dp[i-2]+dp[i-1]" },
        hint = L(
          "Fibonacci in disguise: the sum of the two entries just before it.",
          "변장한 피보나치: 바로 앞 두 항의 합.",
          "扮咗嘢嘅 Fibonacci：前面兩格嘅和。"
        ),
        ok = L(
          "O(n) time, O(n) table. Keep only the last two entries and it is O(1) space.",
          "O(n) 시간, O(n) 표. 마지막 둘만 남기면 O(1) 공간.",
          "O(n) 時間，O(n) 表。只留最後兩格就係 O(1) 空間。"
        ),
      },
      {
        topic = "INF",
        q = L(
          "Coin change, fewest coins. Before the loop, mark every amount with a value no real answer can reach. Which?",
          "동전 교환, 가장 적은 동전. 루프 전에 모든 금액을 실제 답이 닿을 수 없는 값으로 표시. 어떤 값?",
          "找換硬幣，最少硬幣。loop 之前，將每個金額標成一個真答案去唔到嘅值。邊個值？"
        ),
        code = L(
          [[
// dp[a] = fewest coins that make amount a
for a := range dp {
    dp[a] = ___             // 'impossible' until proven
}
dp[0] = 0
]],
          [[
// dp[a] = 금액 a를 만드는 최소 동전 수
for a := range dp {
    dp[a] = ___             // 아직은 불가능
}
dp[0] = 0
]],
          [[
// dp[a] = 砌出金額 a 嘅最少硬幣數
for a := range dp {
    dp[a] = ___             // 暫時當唔可能
}
dp[0] = 0
]]
        ),
        answer = "amount + 1",
        accept = { "amount + 1", "amount+1" },
        hint = L(
          "One more than the amount itself: no real answer uses more coins than the amount.",
          "금액보다 하나 더: 어떤 실제 답도 금액보다 많은 동전을 쓰지 않는다.",
          "金額本身加一：冇真答案會用多過金額咁多個硬幣。"
        ),
        ok = L(
          "A sentinel infinity. math.MaxInt would overflow the moment you add 1 to it.",
          "센티널 무한대. math.MaxInt는 1을 더하는 순간 오버플로.",
          "一個 sentinel 無限大。math.MaxInt 一加 1 就 overflow。"
        ),
      },
      {
        topic = "MIN",
        q = L(
          "For each coin c that fits into a: one coin, plus the best for what is left. Fill the index.",
          "a에 들어가는 동전 c마다: 동전 하나, 더하기 남은 금액의 최선. 인덱스를 채우기.",
          "每個放得入 a 嘅硬幣 c：一個硬幣，加剩低金額嘅最佳答案。填 index。"
        ),
        code = L(
          [[
for a := 1; a <= amount; a++ {
    for _, c := range coins {
        if c <= a {
            dp[a] = min(dp[a], dp[___]+1)
        }
    }
}
]],
          [[
for a := 1; a <= amount; a++ {
    for _, c := range coins {
        if c <= a {
            dp[a] = min(dp[a], dp[___]+1)
        }
    }
}
]],
          [[
for a := 1; a <= amount; a++ {
    for _, c := range coins {
        if c <= a {
            dp[a] = min(dp[a], dp[___]+1)
        }
    }
}
]]
        ),
        answer = "a-c",
        accept = { "a-c", "a - c" },
        hint = L(
          "The amount still to make after spending this one coin.",
          "이 동전 하나를 쓰고 나서 아직 만들어야 할 금액.",
          "用咗呢一個硬幣之後仲要砌嘅金額。"
        ),
        ok = L(
          "O(amount * coins). Each cell asks: which last coin gives the fewest in total?",
          "O(금액 * 동전 수). 각 칸의 질문: 마지막 동전이 무엇일 때 총합이 가장 적은가?",
          "O(金額 * 硬幣數)。每格問：最後一個硬幣係邊個先至總數最少？"
        ),
      },
      {
        topic = "NONE",
        q = L(
          "If no combination reaches the amount, its cell still holds the sentinel. Return what?",
          "어떤 조합도 금액에 닿지 못하면 그 칸엔 아직 센티널이 있다. 무엇을 반환?",
          "如果冇組合砌得出個金額，嗰格仲係 sentinel。回傳咩？"
        ),
        code = L(
          [[
if dp[amount] > amount {
    return ___              // never reached
}
return dp[amount]
]],
          [[
if dp[amount] > amount {
    return ___              // 닿은 적 없음
}
return dp[amount]
]],
          [[
if dp[amount] > amount {
    return ___              // 從來去唔到
}
return dp[amount]
]]
        ),
        answer = "-1",
        accept = { "-1" },
        hint = L(
          "The usual 'no answer' for a count: negative one.",
          "개수에 대한 관례적인 '답 없음': 음수 하나.",
          "計數嘅慣常「冇答案」：負一。"
        ),
        ok = L(
          "Greedy fails on coins {1,3,4} for 6 (4+1+1). DP tries every last coin and finds 3+3.",
          "탐욕법은 동전 {1,3,4}로 6을 만들 때 실패(4+1+1). DP는 마지막 동전을 전부 시도해 3+3을 찾는다.",
          "貪心法用 {1,3,4} 砌 6 會衰（4+1+1）。DP 試晒每個最後硬幣，搵到 3+3。"
        ),
      },
    },
  },
  {
    id = "window",
    station = "WINDOW",
    name = L("CALLBACK 3  -  the window", "2차 면접 3  -  창", "二面 3  -  窗"),
    title = L(
      "Sliding window, two pointers",
      "슬라이딩 윈도우, 투 포인터",
      "sliding window、兩個 pointer"
    ),
    lesson = L(
      "Kadane: at each x, extend the run or restart at x, keep the best. A fixed window adds the newcomer and drops a[i-k]. Two pointers only move right: O(n) for the longest substring without repeats.",
      "카데인: 각 x에서 구간을 이어가거나 x에서 새로 시작, 최선을 기억. 고정 윈도우는 새 항목을 더하고 a[i-k]를 뺀다. 투 포인터는 오른쪽으로만 움직인다: 중복 없는 가장 긴 부분 문자열이 O(n).",
      "Kadane：每個 x，延續段落或者由 x 重新開始，記住最好嘅。固定窗加新嚟嗰個、減走 a[i-k]。兩個 pointer 只向右行：冇重複嘅最長 substring 係 O(n)。"
    ),
    bg = "bg_lab",
    portrait = "portrait_hero",
    speaker = L("Alex", "알렉스", "阿力"),
    ground = 348,
    spawn = 160,
    width = 1600,
    npcs = {
      {
        kind = "clerk",
        x = 540,
        facing = -1,
        line = L(
          "Round three. Daily sales, some negative. Which stretch of days made the most money?",
          "3라운드. 일별 매출, 일부는 마이너스. 어느 기간이 가장 많이 벌었나요?",
          "第三題。每日營業額，有啲係負數。邊一段日子賺最多？"
        ),
      },
      {
        kind = "hero",
        x = 800,
        facing = -1,
        line = L(
          "One pass. If the running total goes negative, it can only hurt: start again.",
          "한 번만 훑기. 누적합이 음수가 되면 해만 끼치니 다시 시작.",
          "行一次就得。累計去到負數只會拖累：重新開始。"
        ),
      },
    },
    viz = "chips",
    chips = {
      { "cur = max(x, cur+x)", "cyan" },
      { "sum -= a[i-k]", "gold" },
      { "last[c] = r", "pink" },
      { "best = max(best, r-l+1)", "green" },
    },
    note = "kadane  window sum  last seen  r-l+1",
    story = L(
      "Siu Ming pins a strip of numbers to the board: Lucky Mac's daily profit for a month, red on the bad days. "
        .. "Best run of days, best k days in a row, longest run of distinct dishes on the specials board. "
        .. "Three questions, one shape: a window that slides right and never looks back.",
      "시우밍이 숫자 띠를 보드에 붙인다: 럭키 맥의 한 달 일별 이익, 나쁜 날은 빨간색. "
        .. "최고의 연속 기간, 최고의 연속 k일, 스페셜 보드에서 겹치지 않는 가장 긴 요리 행렬. "
        .. "질문 셋, 형태 하나: 오른쪽으로 미끄러지며 뒤돌아보지 않는 창.",
      "小明將一條數字帶釘上板：幸運麥一個月嘅每日利潤，蝕嘅日子係紅色。"
        .. "最賺嘅一段日子、連續 k 日最賺、特餐板上最長冇重複嘅一串菜。"
        .. "三條問題，一個形狀：一個向右滑、永不回頭嘅窗。"
    ),
    stages = {
      {
        topic = "KADANE",
        q = L(
          "Max subarray sum: at each x, either extend the current run or start fresh. Fill the fresh start.",
          "최대 부분 배열 합: 각 x에서 현재 구간을 잇거나 새로 시작. 새 시작을 채우기.",
          "最大 subarray 和：每個 x，延續而家嘅段落或者重新開始。填重新開始嗰個。"
        ),
        code = L(
          [[
cur, best := a[0], a[0]
for _, x := range a[1:] {
    cur = max(___, cur+x)   // start over here, or extend
    best = max(best, cur)
}
return best
]],
          [[
cur, best := a[0], a[0]
for _, x := range a[1:] {
    cur = max(___, cur+x)   // 새로, 또는 이어서
    best = max(best, cur)
}
return best
]],
          [[
cur, best := a[0], a[0]
for _, x := range a[1:] {
    cur = max(___, cur+x)   // 重新開始或延續
    best = max(best, cur)
}
return best
]]
        ),
        answer = "x",
        accept = { "x" },
        hint = L(
          "The element on its own: a run that begins right here and has nothing before it.",
          "그 원소 하나만: 바로 여기서 시작하고 앞엔 아무것도 없는 구간.",
          "淨係嗰個元素：由呢度開始、前面乜都冇嘅段落。"
        ),
        ok = L(
          "Kadane's algorithm: O(n), one pass, two variables. A negative prefix is never worth keeping.",
          "카데인 알고리즘: O(n), 한 번 통과, 변수 둘. 음수 접두 구간은 절대 남길 가치가 없다.",
          "Kadane 算法：O(n)，一次過，兩個變數。負數嘅前段永遠唔值得留。"
        ),
      },
      {
        topic = "SLIDE",
        q = L(
          "Sum of every window of k items: add the newcomer, subtract the one that just left. Which index left?",
          "k개짜리 모든 윈도우의 합: 새 항목을 더하고 방금 나간 것을 뺀다. 나간 인덱스는?",
          "每個 k 個元素嘅窗嘅和：加新嚟嗰個，減啱啱走咗嗰個。走咗嘅係邊個 index？"
        ),
        code = L(
          [[
for i := range a {
    sum += a[i]             // enters the window
    if i >= k {
        sum -= a[___]       // leaves the window
    }
    best = max(best, sum)
}
]],
          [[
for i := range a {
    sum += a[i]             // 창에 들어옴
    if i >= k {
        sum -= a[___]       // 창에서 나감
    }
    best = max(best, sum)
}
]],
          [[
for i := range a {
    sum += a[i]             // 入窗
    if i >= k {
        sum -= a[___]       // 出窗
    }
    best = max(best, sum)
}
]]
        ),
        answer = "i-k",
        accept = { "i-k", "i - k" },
        hint = L(
          "k positions behind the newest one.",
          "가장 새 항목보다 k칸 뒤.",
          "最新嗰個後面 k 個位。"
        ),
        ok = L(
          "Sliding window: O(n) instead of O(n*k) for summing every window from scratch.",
          "슬라이딩 윈도우: 윈도우마다 처음부터 더하는 O(n*k) 대신 O(n).",
          "sliding window：O(n)，而唔係每個窗由頭加嘅 O(n*k)。"
        ),
      },
      {
        topic = "SEEN",
        q = L(
          "Longest substring without a repeat: remember where each char was last seen. What is stored under last[c]?",
          "중복 없는 가장 긴 부분 문자열: 각 문자를 마지막으로 본 위치를 기억. last[c]에 무엇을 저장?",
          "冇重複嘅最長 substring：記住每個字元最後喺邊度見過。last[c] 存咩？"
        ),
        code = L(
          [[
last := map[rune]int{}
l, best := 0, 0
for r, c := range s {
    if p, ok := last[c]; ok && p >= l {
        l = p + 1           // jump past the repeat
    }
    last[c] = ___
]],
          [[
last := map[rune]int{}
l, best := 0, 0
for r, c := range s {
    if p, ok := last[c]; ok && p >= l {
        l = p + 1           // 중복 너머로 점프
    }
    last[c] = ___
]],
          [[
last := map[rune]int{}
l, best := 0, 0
for r, c := range s {
    if p, ok := last[c]; ok && p >= l {
        l = p + 1           // 跳過個重複
    }
    last[c] = ___
]]
        ),
        answer = "r",
        accept = { "r" },
        hint = L(
          "The current index: the right edge of the window.",
          "현재 인덱스: 창의 오른쪽 끝.",
          "而家嘅 index：窗嘅右邊。"
        ),
        ok = L(
          "A map of last positions lets the left edge jump instead of creeping one step at a time.",
          "마지막 위치의 맵 덕에 왼쪽 끝이 한 칸씩 기지 않고 점프한다.",
          "一個記住最後位置嘅 map，令左邊可以跳，唔使一步步爬。"
        ),
      },
      {
        topic = "JUMP",
        q = L(
          "The repeat sits at p, inside the window. The window must restart just after it. Fill.",
          "중복은 창 안의 p에 있다. 창은 그 바로 다음에서 다시 시작해야 한다. 채우기.",
          "重複嘅喺窗入面嘅 p。個窗要喺佢之後即刻重新開始。填。"
        ),
        code = L(
          [[
    if p, ok := last[c]; ok && p >= l {
        l = ___ + 1         // right after the old copy
    }
]],
          [[
    if p, ok := last[c]; ok && p >= l {
        l = ___ + 1         // 예전 것 바로 다음
    }
]],
          [[
    if p, ok := last[c]; ok && p >= l {
        l = ___ + 1         // 舊嗰個之後一格
    }
]]
        ),
        answer = "p",
        accept = { "p" },
        hint = L(
          "The old position of this char, from the map lookup.",
          "맵 조회에서 나온 이 문자의 예전 위치.",
          "map 查到嘅呢個字元嘅舊位置。"
        ),
        ok = L(
          "The p >= l test matters: a repeat before the window's left edge is already outside and must not pull l back.",
          "p >= l 검사가 중요: 창의 왼쪽 끝보다 앞의 중복은 이미 바깥이라 l을 뒤로 당기면 안 된다.",
          "p >= l 呢個檢查好重要：喺窗左邊之前嘅重複已經喺出面，唔可以將 l 拉返轉頭。"
        ),
      },
      {
        topic = "LONGEST",
        q = L(
          "The window is s[l..r], both ends included. Fill its length.",
          "창은 양끝을 포함한 s[l..r]. 그 길이를 채우기.",
          "個窗係 s[l..r]，兩頭都包。填佢嘅長度。"
        ),
        code = L(
          [[
    last[c] = r
    best = max(best, ___)   // the window s[l..r]
}
return best
]],
          [[
    last[c] = r
    best = max(best, ___)   // 창 s[l..r]
}
return best
]],
          [[
    last[c] = r
    best = max(best, ___)   // 個窗 s[l..r]
}
return best
]]
        ),
        answer = "r-l+1",
        accept = { "r-l+1", "r - l + 1" },
        hint = L(
          "Right minus left, plus one for the inclusive end.",
          "오른쪽 빼기 왼쪽, 끝을 포함하니 더하기 1.",
          "右減左，因為包埋尾所以加一。"
        ),
        ok = L(
          "Two pointers that only move right: O(n) time, O(alphabet) space. 'abcabcbb' gives 3.",
          "오른쪽으로만 가는 포인터 둘: O(n) 시간, O(알파벳) 공간. 'abcabcbb'는 3.",
          "只向右行嘅兩個 pointer：O(n) 時間，O(字母表) 空間。'abcabcbb' 答 3。"
        ),
      },
    },
  },
  {
    id = "heap",
    station = "HEAP",
    name = L("CALLBACK 4  -  the top k", "2차 면접 4  -  상위 k", "二面 4  -  頭 k 個"),
    title = L("container/heap, kth largest", "container/heap, k번째 큰 수", "container/heap、第 k 大"),
    lesson = L(
      "container/heap wants Len, Less, Swap plus Push and Pop on a pointer. Less with < is a min-heap. Kth largest: push everything, pop whenever the heap holds more than k, the root is the answer.",
      "container/heap엔 Len, Less, Swap과 포인터의 Push, Pop이 필요. <인 Less는 최소 힙. k번째 큰 수: 전부 push, 힙이 k개를 넘을 때마다 pop, 루트가 답.",
      "container/heap 要 Len、Less、Swap，加埋 pointer 上嘅 Push 同 Pop。Less 用 < 就係 min-heap。第 k 大：全部 push，heap 多過 k 個就 pop，root 就係答案。"
    ),
    bg = "bg_lab",
    portrait = "portrait_clerk",
    speaker = L("Siu Ming", "시우밍", "小明"),
    ground = 348,
    spawn = 160,
    width = 1600,
    npcs = {
      {
        kind = "clerk",
        x = 540,
        facing = -1,
        line = L(
          "Round four. A million order totals stream past. The third largest, without sorting them all.",
          "4라운드. 주문 총액 백만 개가 흘러갑니다. 전부 정렬하지 않고 세 번째로 큰 것.",
          "第四題。一百萬張單嘅總額流過。唔排晒佢哋，搵第三大嗰個。"
        ),
      },
      {
        kind = "mei",
        x = 780,
        facing = -1,
        line = L(
          "Keep a tiny heap of the k biggest. Whatever falls out was never the answer.",
          "가장 큰 k개만 담은 작은 힙을 유지해. 떨어져 나가는 건 애초에 답이 아니었어.",
          "keep 住一個細細嘅 heap，裝住最大嗰 k 個。跌出嚟嘅從來都唔係答案。"
        ),
      },
    },
    viz = "chips",
    chips = {
      { "type IntHeap []int", "cyan" },
      { "h[i] < h[j]", "gold" },
      { "heap.Push(h, x)", "pink" },
      { "(*h)[0]", "green" },
    },
    note = "Less  Push  Pop  keep k  root",
    story = L(
      "The next sheet is a stream: order totals arriving faster than anyone could sort them. Siu Ming wants the kth largest "
        .. "at any moment. Go has no heap type, only container/heap and an interface to satisfy. "
        .. "Alex writes IntHeap on the board, five methods, and a loop that never lets the heap grow past k.",
      "다음 장은 스트림: 누구도 정렬할 수 없을 만큼 빨리 도착하는 주문 총액. 시우밍은 언제든 k번째로 큰 값을 원한다. "
        .. "Go엔 힙 타입이 없고 container/heap과 만족시킬 인터페이스뿐. "
        .. "알렉스가 보드에 IntHeap을 쓴다. 메서드 다섯, 힙이 k를 넘지 못하게 하는 루프 하나.",
      "下一張紙係一條 stream：訂單總額嚟得快到冇人排得切。小明想隨時知道第 k 大嗰個。"
        .. "Go 冇 heap type，只有 container/heap 同一個要滿足嘅 interface。"
        .. "阿力喺板上寫 IntHeap，五個 method，同一個永遠唔畀 heap 大過 k 嘅 loop。"
    ),
    stages = {
      {
        topic = "LESS",
        q = L(
          "container/heap needs Less. For a min-heap, when does i come before j?",
          "container/heap엔 Less가 필요. 최소 힙이라면 i가 j보다 앞서는 조건은?",
          "container/heap 要 Less。min-heap 嘅話，i 幾時排喺 j 前面？"
        ),
        code = L(
          [[
type IntHeap []int

func (h IntHeap) Len() int { return len(h) }
func (h IntHeap) Less(i, j int) bool {
    return h[i] ___ h[j]    // the smallest rises to the top
}
func (h IntHeap) Swap(i, j int) { h[i], h[j] = h[j], h[i] }
]],
          [[
type IntHeap []int

func (h IntHeap) Len() int { return len(h) }
func (h IntHeap) Less(i, j int) bool {
    return h[i] ___ h[j]    // 최솟값이 꼭대기로
}
func (h IntHeap) Swap(i, j int) { h[i], h[j] = h[j], h[i] }
]],
          [[
type IntHeap []int

func (h IntHeap) Len() int { return len(h) }
func (h IntHeap) Less(i, j int) bool {
    return h[i] ___ h[j]    // 最細嘅升到頂
}
func (h IntHeap) Swap(i, j int) { h[i], h[j] = h[j], h[i] }
]]
        ),
        answer = "<",
        accept = { "<" },
        hint = L(
          "Smaller wins: the smallest value floats to index 0.",
          "작은 쪽이 이긴다: 가장 작은 값이 인덱스 0으로 떠오른다.",
          "細嗰個贏：最細嘅值浮上 index 0。"
        ),
        ok = L(
          "Flip it to > for a max-heap. sort.Interface plus Push and Pop is the whole contract.",
          "최대 힙이면 >로 뒤집기. sort.Interface에 Push와 Pop을 더한 게 계약의 전부.",
          "max-heap 就反轉做 >。sort.Interface 加 Push 同 Pop 就係成份合約。"
        ),
      },
      {
        topic = "PUSH",
        q = L(
          "Push appends through the pointer, because it must change the slice itself. Fill the receiver type.",
          "Push는 슬라이스 자체를 바꿔야 해서 포인터를 통해 append. 리시버 타입을 채우기.",
          "Push 要改個 slice 本身，所以透過 pointer 嚟 append。填 receiver type。"
        ),
        code = L(
          [[
func (h ___) Push(x any) {
    *h = append(*h, x.(int))
}
]],
          [[
func (h ___) Push(x any) {
    *h = append(*h, x.(int))
}
]],
          [[
func (h ___) Push(x any) {
    *h = append(*h, x.(int))
}
]]
        ),
        answer = "*IntHeap",
        accept = { "*IntHeap", "* IntHeap" },
        hint = L(
          "A pointer receiver: a star before the type name.",
          "포인터 리시버: 타입 이름 앞에 별표.",
          "pointer receiver：type 名前面加個星。"
        ),
        ok = L(
          "Len, Less, Swap take a value; Push and Pop take a pointer because they resize the slice.",
          "Len, Less, Swap은 값을 받고, Push와 Pop은 슬라이스 크기를 바꾸므로 포인터를 받는다.",
          "Len、Less、Swap 收 value；Push 同 Pop 要改 slice 大小，所以收 pointer。"
        ),
      },
      {
        topic = "POP",
        q = L(
          "heap.Pop swaps the root to the end first, so Pop returns the last element and shrinks. Fill both blanks.",
          "heap.Pop은 먼저 루트를 끝으로 바꿔놓으니 Pop은 마지막 원소를 반환하고 줄인다. 빈칸 둘을 채우기.",
          "heap.Pop 會先將 root 換到最尾，所以 Pop 回傳最後一個並縮短。填兩個空格。"
        ),
        code = L(
          [[
func (h *IntHeap) Pop() any {
    old := *h
    n := len(old)
    x := old[___]           // heap put the root here
    *h = old[:___]          // shrink by one
    return x
}
]],
          [[
func (h *IntHeap) Pop() any {
    old := *h
    n := len(old)
    x := old[___]           // heap이 루트를 여기 둠
    *h = old[:___]          // 하나 줄이기
    return x
}
]],
          [[
func (h *IntHeap) Pop() any {
    old := *h
    n := len(old)
    x := old[___]           // heap 將 root 放咗喺度
    *h = old[:___]          // 縮短一個
    return x
}
]]
        ),
        answer = "n-1",
        accept = { "n-1", "n - 1" },
        hint = L(
          "The last index of a slice of n items.",
          "n개짜리 슬라이스의 마지막 인덱스.",
          "n 個元素嘅 slice 嘅最後一個 index。"
        ),
        ok = L(
          "The heap package does the sifting; your Pop only trims the tail. O(log n) per operation.",
          "체질은 heap 패키지가 하고, 당신의 Pop은 꼬리만 자른다. 연산당 O(log n).",
          "篩嘅工夫 heap package 做，你嘅 Pop 淨係剪走條尾。每個操作 O(log n)。"
        ),
      },
      {
        topic = "KEEP",
        q = L(
          "Kth largest: keep a min-heap of the k largest so far. When it grows past k, which heap call drops the smallest?",
          "k번째 큰 수: 지금까지의 최대 k개를 최소 힙에 유지. k를 넘으면 가장 작은 것을 버리는 heap 호출은?",
          "第 k 大：keep 住一個裝住到而家為止最大 k 個嘅 min-heap。大過 k 嘅時候，邊個 heap call 掉走最細嗰個？"
        ),
        code = L(
          [[
h := &IntHeap{}
for _, x := range nums {
    heap.Push(h, x)
    if h.Len() > k {
        heap.___(h)         // the smallest leaves
    }
}
]],
          [[
h := &IntHeap{}
for _, x := range nums {
    heap.Push(h, x)
    if h.Len() > k {
        heap.___(h)         // 가장 작은 것이 나감
    }
}
]],
          [[
h := &IntHeap{}
for _, x := range nums {
    heap.Push(h, x)
    if h.Len() > k {
        heap.___(h)         // 最細嗰個走
    }
}
]]
        ),
        answer = "Pop",
        accept = { "Pop" },
        hint = L(
          "The package function that removes the root and returns it.",
          "루트를 제거하고 반환하는 패키지 함수.",
          "移走 root 並回傳佢嘅 package function。"
        ),
        ok = L(
          "O(n log k) time, O(k) space: better than sorting all n when k is small.",
          "O(n log k) 시간, O(k) 공간: k가 작으면 n개 전부 정렬하는 것보다 낫다.",
          "O(n log k) 時間，O(k) 空間：k 細嘅話好過將 n 個全部排序。"
        ),
      },
      {
        topic = "ROOT",
        q = L(
          "After the loop, k items remain and the kth largest is the smallest of them. Which index holds it?",
          "루프 뒤엔 k개가 남고 k번째 큰 수는 그중 가장 작은 것. 어느 인덱스에 있나?",
          "loop 之後剩 k 個，第 k 大就係佢哋之中最細嗰個。喺邊個 index？"
        ),
        code = L(
          [[
    }
    // k items remain: the root is the kth largest
    return (*h)[___]
}
]],
          [[
    }
    // k개 남음: 루트가 k번째 큰 수
    return (*h)[___]
}
]],
          [[
    }
    // 剩 k 個：root 就係第 k 大
    return (*h)[___]
}
]]
        ),
        answer = "0",
        accept = { "0" },
        hint = L(
          "The root of a heap lives at the first index of the slice.",
          "힙의 루트는 슬라이스의 첫 인덱스에 산다.",
          "heap 嘅 root 住喺 slice 嘅第一個 index。"
        ),
        ok = L(
          "Min of the k largest is the kth largest. Top-k frequent is the same loop over a count map.",
          "최대 k개의 최솟값이 k번째 큰 수. 최빈 k개도 카운트 맵 위에서 같은 루프.",
          "最大 k 個之中最細嗰個就係第 k 大。最常見 k 個都係同一個 loop，行喺一個 count map 上面。"
        ),
      },
    },
  },
  {
    id = "interval",
    station = "INTERVAL",
    name = L("CALLBACK 5  -  the calendar", "2차 면접 5  -  달력", "二面 5  -  日曆"),
    title = L("Merge intervals, meeting rooms", "구간 병합, 회의실", "合併區間、會議室"),
    lesson = L(
      "Sort intervals by start; then every overlap is adjacent. Overlap when cur's start <= last's end: extend last's end with max. Otherwise append. Rooms: sort starts and ends separately, two pointers.",
      "구간을 시작으로 정렬하면 모든 겹침이 이웃이 된다. cur의 시작 <= last의 끝이면 겹침: max로 last의 끝을 늘린다. 아니면 append. 회의실: 시작과 끝을 따로 정렬, 포인터 둘.",
      "區間按開始排序；之後每個重疊都係相鄰嘅。cur 嘅開始 <= last 嘅結束就係重疊：用 max 延長 last 嘅結束。否則 append。會議室：開始同結束分開排序，兩個 pointer。"
    ),
    bg = "bg_lab",
    portrait = "portrait_friends",
    speaker = L("Mei", "메이", "阿美"),
    ground = 348,
    spawn = 160,
    width = 1600,
    npcs = {
      {
        kind = "clerk",
        x = 540,
        facing = -1,
        line = L(
          "Round five. Staff shifts as {start, end}. Merge the overlapping ones into one schedule.",
          "5라운드. 직원 교대를 {시작, 끝}으로. 겹치는 것들을 하나의 일정으로 합치세요.",
          "第五題。員工更表寫成 {開始, 結束}。將重疊嘅合併成一張時間表。"
        ),
      },
      {
        kind = "mei",
        x = 780,
        facing = -1,
        line = L(
          "Sort first. Sorted, the only interval that can overlap is the one you just kept.",
          "먼저 정렬해. 정렬되면 겹칠 수 있는 유일한 구간은 방금 남긴 그것뿐이야.",
          "先排序。排咗序之後，唯一可能重疊嘅就係你啱啱留低嗰個。"
        ),
      },
    },
    viz = "chips",
    chips = {
      { "sort.Slice(iv, less)", "cyan" },
      { "cur[0] <= last[1]", "gold" },
      { "last[1] = max(...)", "pink" },
      { "out = append(out, cur)", "green" },
    },
    note = "sort by start  overlap?  extend  append",
    story = L(
      "Siu Ming pins the week's roster to the board: thirty shifts, half of them overlapping, "
        .. "the manager wants one clean line per stretch of coverage, and then how many cooks are ever on at once. "
        .. "Mei taps the first column: sort by start and the mess becomes a walk.",
      "시우밍이 이번 주 근무표를 보드에 붙인다: 교대 서른 개, 절반이 겹친다. "
        .. "매니저는 커버되는 구간마다 깔끔한 선 하나, 그리고 동시에 몇 명의 요리사가 일하는지 알고 싶다. "
        .. "메이가 첫 열을 두드린다: 시작으로 정렬하면 엉킴이 산책이 된다.",
      "小明將今個星期嘅更表釘上板：三十個更，一半重疊，"
        .. "經理想每段有人當值嘅時間得一條乾淨嘅線，仲想知最多同時有幾多個廚師。"
        .. "阿美敲吓第一欄：按開始排序，一團糟就變成散步。"
    ),
    stages = {
      {
        topic = "SORT",
        q = L(
          "Sort the intervals by start, earliest first. Fill the comparison.",
          "구간을 시작 기준으로, 이른 것부터 정렬. 비교를 채우기.",
          "將區間按開始排序，最早行先。填比較。"
        ),
        code = L(
          [[
sort.Slice(iv, func(i, j int) bool {
    return iv[i][0] ___ iv[j][0]    // earliest start first
})
]],
          [[
sort.Slice(iv, func(i, j int) bool {
    return iv[i][0] ___ iv[j][0]    // 이른 시작 먼저
})
]],
          [[
sort.Slice(iv, func(i, j int) bool {
    return iv[i][0] ___ iv[j][0]    // 最早開始行先
})
]]
        ),
        answer = "<",
        accept = { "<" },
        hint = L(
          "Ascending: i goes before j when its start is smaller.",
          "오름차순: 시작이 더 작으면 i가 j보다 앞.",
          "升序：開始細嘅 i 排喺 j 前面。"
        ),
        ok = L(
          "O(n log n), and after it every overlap sits next to its neighbour. slices.SortFunc does the same in Go 1.21.",
          "O(n log n), 그 후엔 모든 겹침이 이웃 옆에 놓인다. Go 1.21의 slices.SortFunc도 같은 일.",
          "O(n log n)，之後每個重疊都坐喺鄰居隔籬。Go 1.21 嘅 slices.SortFunc 做同一件事。"
        ),
      },
      {
        topic = "OVERLAP",
        q = L(
          "cur overlaps the last merged interval when its start is no later than that interval's end. Fill the index of the end.",
          "cur의 시작이 마지막 병합 구간의 끝보다 늦지 않으면 겹친다. 끝의 인덱스를 채우기.",
          "cur 嘅開始唔遲過最後合併區間嘅結束，就係重疊。填結束嘅 index。"
        ),
        code = L(
          [[
out := [][]int{iv[0]}
for _, cur := range iv[1:] {
    last := out[len(out)-1]
    if cur[0] <= last[___] {    // they touch or overlap
]],
          [[
out := [][]int{iv[0]}
for _, cur := range iv[1:] {
    last := out[len(out)-1]
    if cur[0] <= last[___] {    // 닿거나 겹침
]],
          [[
out := [][]int{iv[0]}
for _, cur := range iv[1:] {
    last := out[len(out)-1]
    if cur[0] <= last[___] {    // 掂到或者重疊
]]
        ),
        answer = "1",
        accept = { "1" },
        hint = L(
          "In a {start, end} pair, the end is the second element.",
          "{시작, 끝} 쌍에서 끝은 둘째 원소.",
          "{開始, 結束} 一對入面，結束係第二個。"
        ),
        ok = L(
          "<= merges [1,3] and [3,5] into [1,5]. Use < if touching intervals should stay apart.",
          "<=는 [1,3]과 [3,5]를 [1,5]로 합친다. 닿기만 한 구간을 따로 두려면 <.",
          "<= 會將 [1,3] 同 [3,5] 合成 [1,5]。掂到嘅想分開就用 <。"
        ),
      },
      {
        topic = "EXTEND",
        q = L(
          "They overlap: stretch the merged interval to whichever end is farther. Fill the builtin.",
          "겹친다: 병합 구간을 더 먼 끝까지 늘린다. 내장 함수를 채우기.",
          "重疊：將合併區間拉長到較遠嗰個結束。填內建 function。"
        ),
        code = L(
          [[
    last := out[len(out)-1]
    if cur[0] <= last[1] {
        // overlap: keep the farther end
        last[1] = ___(last[1], cur[1])
        continue
    }
]],
          [[
    last := out[len(out)-1]
    if cur[0] <= last[1] {
        // 겹침: 더 먼 끝을 유지
        last[1] = ___(last[1], cur[1])
        continue
    }
]],
          [[
    last := out[len(out)-1]
    if cur[0] <= last[1] {
        // 重疊：留較遠嗰個結束
        last[1] = ___(last[1], cur[1])
        continue
    }
]]
        ),
        answer = "max",
        accept = { "max" },
        hint = L(
          "The Go 1.21 builtin that picks the larger of two ints.",
          "두 int 중 큰 것을 고르는 Go 1.21 내장 함수.",
          "Go 1.21 揀兩個 int 之中大嗰個嘅內建 function。"
        ),
        ok = L(
          "[1,6] absorbs [2,4]: without the larger-end rule you would shrink it to [1,4]. last is a slice, so out sees the change.",
          "[1,6]이 [2,4]를 흡수: 더 큰 끝 규칙이 없으면 [1,4]로 줄어든다. last는 슬라이스라 out에 변경이 보인다.",
          "[1,6] 吸收 [2,4]：冇「較大結束」規則就會縮成 [1,4]。last 係 slice，所以 out 睇到個改動。"
        ),
      },
      {
        topic = "APPEND",
        q = L(
          "No overlap: cur starts a new merged interval. Fill the builtin.",
          "겹치지 않음: cur가 새 병합 구간을 시작. 내장 함수를 채우기.",
          "冇重疊：cur 開一個新嘅合併區間。填內建 function。"
        ),
        code = L(
          [[
    if cur[0] <= last[1] {
        last[1] = max(last[1], cur[1])
        continue
    }
    out = ___(out, cur)     // a gap: start a new one
}
return out
]],
          [[
    if cur[0] <= last[1] {
        last[1] = max(last[1], cur[1])
        continue
    }
    out = ___(out, cur)     // 틈: 새로 시작
}
return out
]],
          [[
    if cur[0] <= last[1] {
        last[1] = max(last[1], cur[1])
        continue
    }
    out = ___(out, cur)     // 有空隙：開新嘅
}
return out
]]
        ),
        answer = "append",
        accept = { "append" },
        hint = L(
          "The builtin that adds an element to the end of a slice.",
          "슬라이스 끝에 원소를 더하는 내장 함수.",
          "將元素加喺 slice 尾嘅內建 function。"
        ),
        ok = L(
          "The merge pass is O(n); the sort before it makes the whole thing O(n log n).",
          "병합 패스는 O(n), 그 앞의 정렬이 전체를 O(n log n)으로 만든다.",
          "合併嗰次係 O(n)；前面嘅排序令成件事係 O(n log n)。"
        ),
      },
      {
        topic = "ROOMS",
        q = L(
          "Meeting rooms: sort starts and ends separately. A start reuses a room when the earliest end is already over. Fill the test.",
          "회의실: 시작과 끝을 따로 정렬. 가장 이른 끝이 이미 지났으면 시작이 방을 재사용. 검사를 채우기.",
          "會議室：開始同結束分開排序。最早嘅結束已經過咗，開始就可以重用一間房。填檢查。"
        ),
        code = L(
          [[
sort.Ints(starts); sort.Ints(ends)
rooms, e := 0, 0
for _, s := range starts {
    if s ___ ends[e] {      // one meeting already over
        e++
    } else {
        rooms++
]],
          [[
sort.Ints(starts); sort.Ints(ends)
rooms, e := 0, 0
for _, s := range starts {
    if s ___ ends[e] {      // 회의 하나 끝남
        e++
    } else {
        rooms++
]],
          [[
sort.Ints(starts); sort.Ints(ends)
rooms, e := 0, 0
for _, s := range starts {
    if s ___ ends[e] {      // 有個會已經完咗
        e++
    } else {
        rooms++
]]
        ),
        answer = ">=",
        accept = { ">=", "=>" },
        hint = L(
          "A room frees up when this start is not before the earliest end.",
          "이 시작이 가장 이른 끝보다 앞서지 않으면 방이 빈다.",
          "呢個開始唔早過最早嘅結束，就有房空出嚟。"
        ),
        ok = L(
          "Two sorted lists, two pointers: O(n log n). rooms peaks at the answer and never has to come down.",
          "정렬된 리스트 둘, 포인터 둘: O(n log n). rooms는 답에서 최대가 되고 내려올 필요가 없다.",
          "兩個排咗序嘅 list，兩個 pointer：O(n log n)。rooms 去到答案就係頂，唔使落返嚟。"
        ),
      },
    },
  },
  {
    id = "lru",
    station = "LRU",
    name = L("CALLBACK 6  -  the cache", "2차 면접 6  -  캐시", "二面 6  -  cache"),
    title = L("LRU cache", "LRU 캐시", "LRU 緩存"),
    lesson = L(
      "LRU: a map from key to *list.Element plus a container/list in recency order. Get moves the node to the front, Put pushes a new one at the front, over capacity evicts l.Back() from both the list and the map. Every operation O(1).",
      "LRU: 키에서 *list.Element로 가는 맵과 최근 순서의 container/list. Get은 노드를 앞으로 옮기고, Put은 새 노드를 앞에 넣고, 용량 초과면 l.Back()을 리스트와 맵에서 제거. 모든 연산이 O(1).",
      "LRU：一個由 key 去 *list.Element 嘅 map，加一個按最近次序排嘅 container/list。Get 將 node 移去前面，Put 將新 node 推入前面，超過容量就由 list 同 map 都踢走 l.Back()。每個操作都係 O(1)。"
    ),
    bg = "bg_lab",
    portrait = "portrait_hero",
    speaker = L("Alex", "알렉스", "阿力"),
    ground = 348,
    spawn = 160,
    width = 1600,
    npcs = {
      {
        kind = "clerk",
        x = 540,
        facing = -1,
        line = L(
          "Round six, the one we always ask. A cache of the last 100 menus. Get and Put in O(1). Go.",
          "6라운드, 늘 묻는 그 문제. 최근 메뉴 100개의 캐시. Get과 Put을 O(1)에. 시작.",
          "第六題，我哋每次都問嗰條。最近 100 個餐牌嘅 cache。Get 同 Put 都要 O(1)。開始。"
        ),
      },
      {
        kind = "hero",
        x = 800,
        facing = -1,
        line = L(
          "A map finds it, a list remembers the order. Two structures that agree.",
          "맵이 찾고, 리스트가 순서를 기억한다. 서로 맞아떨어지는 구조 둘.",
          "map 負責搵，list 負責記次序。兩個要一致嘅結構。"
        ),
      },
    },
    viz = "chips",
    chips = {
      { "map[int]*list.Element", "cyan" },
      { "l.MoveToFront(e)", "gold" },
      { "l.PushFront(entry)", "pink" },
      { "l.Remove(l.Back())", "green" },
    },
    note = "map + list  front = recent  evict back",
    story = L(
      "The last sheet before the break is the classic: an LRU cache. Lucky Mac's menu service is slow, "
        .. "keep the hundred most recently asked-for menus in memory, throw out the one nobody has touched for longest. "
        .. "Alex draws a map on the left and a doubly linked list on the right and joins them with arrows.",
      "휴식 전 마지막 장은 고전: LRU 캐시. 럭키 맥의 메뉴 서비스가 느리니 "
        .. "가장 최근에 요청된 메뉴 백 개를 메모리에 두고, 가장 오래 아무도 건드리지 않은 것을 버린다. "
        .. "알렉스가 왼쪽에 맵, 오른쪽에 이중 연결 리스트를 그리고 화살표로 잇는다.",
      "小息前最後一張紙係經典：LRU cache。幸運麥嘅餐牌服務好慢，"
        .. "將最近被問過嘅一百個餐牌放喺記憶體，掉走最耐冇人掂過嗰個。"
        .. "阿力左邊畫個 map，右邊畫個雙向 linked list，用箭咀駁埋。"
    ),
    stages = {
      {
        topic = "INDEX",
        q = L(
          "O(1) lookups need a map from key to its node in the list. Fill the value type.",
          "O(1) 조회엔 키에서 리스트 노드로 가는 맵이 필요. 값 타입을 채우기.",
          "O(1) 查找要一個由 key 去 list node 嘅 map。填 value type。"
        ),
        code = L(
          [[
type LRU struct {
    cap int
    m   map[int]___         // key -> its node in l
    l   *list.List          // front = most recent
}
]],
          [[
type LRU struct {
    cap int
    m   map[int]___         // 키 -> l 안의 그 노드
    l   *list.List          // 앞 = 가장 최근
}
]],
          [[
type LRU struct {
    cap int
    m   map[int]___         // key -> l 入面嘅 node
    l   *list.List          // 前面 = 最近
}
]]
        ),
        answer = "*list.Element",
        accept = { "*list.Element", "* list.Element" },
        hint = L(
          "A pointer to the node type of container/list.",
          "container/list의 노드 타입에 대한 포인터.",
          "指住 container/list 嘅 node type 嘅 pointer。"
        ),
        ok = L(
          "The map finds the node in O(1); the list moves it in O(1). Neither alone can do both.",
          "맵이 O(1)에 노드를 찾고, 리스트가 O(1)에 옮긴다. 어느 하나만으론 둘 다 못 한다.",
          "map 用 O(1) 搵到 node；list 用 O(1) 移動佢。單靠一個做唔到兩樣。"
        ),
      },
      {
        topic = "GET",
        q = L(
          "Get: a hit becomes the most recently used. Which list method moves the node to the front?",
          "Get: 적중하면 가장 최근에 쓴 것이 된다. 노드를 앞으로 옮기는 리스트 메서드는?",
          "Get：命中就變成最近用過。邊個 list method 將 node 移去前面？"
        ),
        code = L(
          [[
func (c *LRU) Get(k int) (int, bool) {
    e, ok := c.m[k]
    if !ok {
        return 0, false
    }
    c.l.___(e)              // touched: most recent now
    return e.Value.(entry).val, true
]],
          [[
func (c *LRU) Get(k int) (int, bool) {
    e, ok := c.m[k]
    if !ok {
        return 0, false
    }
    c.l.___(e)              // 이제 가장 최근
    return e.Value.(entry).val, true
]],
          [[
func (c *LRU) Get(k int) (int, bool) {
    e, ok := c.m[k]
    if !ok {
        return 0, false
    }
    c.l.___(e)              // 掂過：而家係最近
    return e.Value.(entry).val, true
]]
        ),
        answer = "MoveToFront",
        accept = { "MoveToFront" },
        hint = L(
          "Move it to the recent end of the list, which is the front. One method, three words.",
          "리스트의 최근 쪽 끝, 즉 앞으로 옮기기. 메서드 하나, 단어 셋.",
          "移去 list 最近嗰一頭，即係前面。一個 method，三個字。"
        ),
        ok = L(
          "No allocation, O(1): the node is relinked in place. Value is an any, so the type assertion unpacks the entry.",
          "할당 없이 O(1): 노드가 제자리에서 다시 연결된다. Value는 any라 타입 단언으로 entry를 꺼낸다.",
          "唔使分配記憶體，O(1)：node 原地重新駁線。Value 係 any，所以用 type assertion 拆出 entry。"
        ),
      },
      {
        topic = "PUT",
        q = L(
          "Put a new key: a new node at the front, and its address in the map. Fill the list method.",
          "새 키를 Put: 앞에 새 노드, 맵엔 그 주소. 리스트 메서드를 채우기.",
          "Put 一個新 key：前面加新 node，map 記住佢嘅地址。填 list method。"
        ),
        code = L(
          [[
func (c *LRU) Put(k, v int) {
    if e, ok := c.m[k]; ok {
        e.Value = entry{k, v}
        c.l.MoveToFront(e)
        return
    }
    c.m[k] = c.l.___(entry{k, v})
]],
          [[
func (c *LRU) Put(k, v int) {
    if e, ok := c.m[k]; ok {
        e.Value = entry{k, v}
        c.l.MoveToFront(e)
        return
    }
    c.m[k] = c.l.___(entry{k, v})
]],
          [[
func (c *LRU) Put(k, v int) {
    if e, ok := c.m[k]; ok {
        e.Value = entry{k, v}
        c.l.MoveToFront(e)
        return
    }
    c.m[k] = c.l.___(entry{k, v})
]]
        ),
        answer = "PushFront",
        accept = { "PushFront" },
        hint = L(
          "Insert at the recent end and get the new node back.",
          "최근 쪽 끝에 넣고 새 노드를 돌려받기.",
          "插入最近嗰一頭，攞返個新 node。"
        ),
        ok = L(
          "It returns the *Element the map needs. An existing key is an update plus a touch, not a second node.",
          "맵에 필요한 *Element를 반환한다. 기존 키는 갱신과 터치이지 둘째 노드가 아니다.",
          "佢回傳 map 需要嘅 *Element。已有嘅 key 係更新加掂一掂，唔係第二個 node。"
        ),
      },
      {
        topic = "EVICT",
        q = L(
          "Over capacity: the least recently used sits at the far end of the list. Which method finds it?",
          "용량 초과: 가장 오래 안 쓴 것이 리스트 반대편 끝에 있다. 그걸 찾는 메서드는?",
          "超過容量：最耐冇用嗰個坐喺 list 最遠嗰一頭。邊個 method 搵到佢？"
        ),
        code = L(
          [[
    if c.l.Len() > c.cap {
        old := c.l.___()        // least recently used
        c.l.Remove(old)
        delete(c.m, old.Value.(entry).key)
    }
}
]],
          [[
    if c.l.Len() > c.cap {
        old := c.l.___()        // 가장 오래 안 씀
        c.l.Remove(old)
        delete(c.m, old.Value.(entry).key)
    }
}
]],
          [[
    if c.l.Len() > c.cap {
        old := c.l.___()        // 最耐冇用
        c.l.Remove(old)
        delete(c.m, old.Value.(entry).key)
    }
}
]]
        ),
        answer = "Back",
        accept = { "Back" },
        hint = L(
          "The opposite end from the front, where the untouched ones drift.",
          "앞의 반대편 끝, 안 건드린 것들이 밀려가는 곳.",
          "同前面相反嗰一頭，冇人掂嘅嘢會漂去嗰度。"
        ),
        ok = L(
          "Get, Put and evict all O(1): that is the whole point of the LRU question.",
          "Get, Put, 퇴출 모두 O(1): 그게 LRU 문제의 핵심 전부.",
          "Get、Put 同踢走全部 O(1)：呢個就係 LRU 呢條題嘅重點。"
        ),
      },
      {
        topic = "FORGET",
        q = L(
          "The list forgot the node; the map must forget the key too. Which builtin removes a map entry?",
          "리스트는 노드를 잊었다. 맵도 키를 잊어야 한다. 맵 항목을 지우는 내장 함수는?",
          "list 唔記得個 node 喇；map 都要唔記得個 key。邊個內建 function 刪 map entry？"
        ),
        code = L(
          [[
    if c.l.Len() > c.cap {
        old := c.l.Back()
        c.l.Remove(old)
        ___(c.m, old.Value.(entry).key)  // or it leaks
    }
}
]],
          [[
    if c.l.Len() > c.cap {
        old := c.l.Back()
        c.l.Remove(old)
        ___(c.m, old.Value.(entry).key)  // 누수 방지
    }
}
]],
          [[
    if c.l.Len() > c.cap {
        old := c.l.Back()
        c.l.Remove(old)
        ___(c.m, old.Value.(entry).key)  // 唔係就漏
    }
}
]]
        ),
        answer = "delete",
        accept = { "delete" },
        hint = L(
          "The builtin that takes a map and a key. Six letters.",
          "맵과 키를 받는 내장 함수. 여섯 글자.",
          "收一個 map 同一個 key 嘅內建 function。六個字母。"
        ),
        ok = L(
          "A map entry pointing at a removed node is a bug waiting: the map and the list must always agree.",
          "제거된 노드를 가리키는 맵 항목은 예고된 버그: 맵과 리스트는 항상 일치해야 한다.",
          "指住已經移走嘅 node 嘅 map entry 係一個等緊爆嘅 bug：map 同 list 一定要一致。"
        ),
      },
    },
  },
  {
    id = "grid",
    station = "GRID",
    name = L("CALLBACK 7  -  the islands", "2차 면접 7  -  섬", "二面 7  -  島"),
    title = L("Number of islands", "섬의 개수", "島嘅數目"),
    lesson = L(
      "Flood fill on a grid: return when out of bounds or not land, sink the cell to mark it, recurse into the four neighbours. Count islands by starting a fill from every land cell still standing.",
      "격자의 플러드 필: 범위 밖이거나 땅이 아니면 return, 셀을 가라앉혀 표시, 이웃 넷으로 재귀. 아직 남은 땅 셀마다 채우기를 시작해 섬을 센다.",
      "格仔上嘅 flood fill：出界或者唔係陸地就 return，將格仔沉落去做記號，再遞歸入四個鄰居。由每個仲企喺度嘅陸地格開始 fill，就數到有幾多個島。"
    ),
    bg = "bg_times",
    portrait = "portrait_clerk",
    speaker = L("Siu Ming", "시우밍", "小明"),
    ground = 348,
    spawn = 160,
    width = 1600,
    npcs = {
      {
        kind = "clerk",
        x = 540,
        facing = -1,
        line = L(
          "Last one. A map of Victoria Harbour as ones and zeros. How many islands?",
          "마지막. 빅토리아 항구 지도가 1과 0으로. 섬은 몇 개?",
          "最後一題。維多利亞港嘅地圖用 1 同 0 寫。有幾多個島？"
        ),
      },
      {
        kind = "mei",
        x = 780,
        facing = -1,
        line = L(
          "Find land, sink the whole island, count one. Repeat until the map is all water.",
          "땅을 찾으면 섬 전체를 가라앉히고 하나 세. 지도가 전부 물이 될 때까지 반복.",
          "搵到陸地，將成個島沉落去，數一個。重複到成張地圖都係水。"
        ),
      },
    },
    viz = "chips",
    chips = {
      { "r < 0 || c < 0 || ...", "cyan" },
      { "g[r][c] != '1'", "gold" },
      { "g[r][c] = '0'", "pink" },
      { "dfs(g, r+1, c)", "green" },
    },
    note = "bounds  water?  sink  four ways  count",
    story = L(
      "The final sheet is a grid of bytes: '1' is land, '0' is water, Hong Kong Island and Kowloon and a scatter of rocks. "
        .. "Siu Ming wants the count. Alex writes a recursive dfs that sinks whatever it touches, "
        .. "then a double loop that calls it on every '1' still standing and counts the calls. The marker squeaks. Then: OFFER.",
      "마지막 장은 바이트 격자: '1'은 땅, '0'은 물, 홍콩섬과 구룡과 흩어진 바위들. "
        .. "시우밍은 개수를 원한다. 알렉스가 닿는 것마다 가라앉히는 재귀 dfs를 쓰고, "
        .. "아직 남은 '1'마다 그것을 부르며 호출을 세는 이중 루프를 쓴다. 마커가 끽 소리를 낸다. 그리고: OFFER.",
      "最後一張紙係一格格嘅 byte：'1' 係陸地，'0' 係水，香港島、九龍同一堆散石。"
        .. "小明想要個數。阿力寫一個掂到咩就沉咩嘅遞歸 dfs，"
        .. "再寫一個雙重 loop，每個仲企喺度嘅 '1' 都叫佢一次，數住叫咗幾多次。支筆吱一聲。然後：OFFER。"
    ),
    stages = {
      {
        topic = "BOUNDS",
        q = L(
          "The flood stops at the edge of the map. Fill the row check.",
          "채우기는 지도 가장자리에서 멈춘다. 행 검사를 채우기.",
          "flood 去到地圖邊就停。填行嘅檢查。"
        ),
        code = L(
          [[
func dfs(g [][]byte, r, c int) {
    if r < 0 || c < 0 || r ___ len(g) || c >= len(g[0]) {
        return              // off the map
    }
]],
          [[
func dfs(g [][]byte, r, c int) {
    if r < 0 || c < 0 || r ___ len(g) || c >= len(g[0]) {
        return              // 지도 밖
    }
]],
          [[
func dfs(g [][]byte, r, c int) {
    if r < 0 || c < 0 || r ___ len(g) || c >= len(g[0]) {
        return              // 出咗地圖
    }
]]
        ),
        answer = ">=",
        accept = { ">=", "=>" },
        hint = L(
          "Rows run from 0 to len(g)-1; len(g) itself is already outside.",
          "행은 0부터 len(g)-1까지, len(g) 자체는 이미 바깥.",
          "行由 0 到 len(g)-1；len(g) 本身已經係出面。"
        ),
        ok = L(
          "Check bounds before you index, or the recursion panics at the shoreline.",
          "인덱싱 전에 범위를 검사하지 않으면 재귀가 해안선에서 패닉.",
          "index 之前先檢查範圍，唔係遞歸就會喺海岸線 panic。"
        ),
      },
      {
        topic = "WATER",
        q = L(
          "Only land spreads the flood. Which byte marks land in the grid?",
          "땅만 채우기를 퍼뜨린다. 격자에서 땅을 나타내는 바이트는?",
          "只有陸地會傳開 flood。格仔入面邊個 byte 代表陸地？"
        ),
        code = L(
          [[
    if g[r][c] != ___ {
        return              // water, or already visited
    }
]],
          [[
    if g[r][c] != ___ {
        return              // 물이거나 이미 방문함
    }
]],
          [[
    if g[r][c] != ___ {
        return              // 水，或者已經去過
    }
]]
        ),
        answer = "'1'",
        accept = { "'1'", "1" },
        hint = L(
          "The digit for land, as a byte literal in single quotes.",
          "땅을 뜻하는 숫자, 작은따옴표의 바이트 리터럴로.",
          "代表陸地嗰個數字，用單引號寫成 byte literal。"
        ),
        ok = L(
          "The grid holds bytes, not ints: '1' is 49, 1 is 1. Compare with the character.",
          "격자엔 int가 아니라 바이트: '1'은 49, 1은 1. 문자와 비교할 것.",
          "格仔裝嘅係 byte 唔係 int：'1' 係 49，1 係 1。要同個字元比較。"
        ),
      },
      {
        topic = "SINK",
        q = L(
          "Mark the cell visited by sinking it. What is written into the grid?",
          "셀을 가라앉혀 방문 표시. 격자에 무엇을 쓰나?",
          "將格仔沉落去做已去過嘅記號。寫咩落格仔？"
        ),
        code = L(
          [[
    g[r][c] = ___           // sink it: never count it twice
    dfs(g, r+1, c)
    dfs(g, r-1, c)
    dfs(g, r, c+1)
    dfs(g, r, c-1)
}
]],
          [[
    g[r][c] = ___           // 가라앉히기
    dfs(g, r+1, c)
    dfs(g, r-1, c)
    dfs(g, r, c+1)
    dfs(g, r, c-1)
}
]],
          [[
    g[r][c] = ___           // 沉咗佢：唔會數兩次
    dfs(g, r+1, c)
    dfs(g, r-1, c)
    dfs(g, r, c+1)
    dfs(g, r, c-1)
}
]]
        ),
        answer = "'0'",
        accept = { "'0'", "0" },
        hint = L(
          "Turn land into water: the byte for water.",
          "땅을 물로 바꾸기: 물을 뜻하는 바이트.",
          "將陸地變成水：代表水嗰個 byte。"
        ),
        ok = L(
          "Mutating the grid is the O(1) extra-space visited set. Copy it first if the caller needs it back.",
          "격자를 바꾸는 게 곧 O(1) 추가 공간의 방문 집합. 호출자가 원본이 필요하면 먼저 복사.",
          "改格仔就係 O(1) 額外空間嘅 visited set。caller 要攞返原本嘅話就先複製。"
        ),
      },
      {
        topic = "FLOOD",
        q = L(
          "Flood the four neighbours: down, up, right and one more. Fill the missing one.",
          "이웃 넷을 채우기: 아래, 위, 오른쪽, 하나 더. 빠진 것을 채우기.",
          "flood 四個鄰居：下、上、右，仲有一個。填漏咗嗰個。"
        ),
        code = L(
          [[
    g[r][c] = '0'
    dfs(g, r+1, c)
    dfs(g, r-1, c)
    dfs(g, r, c+1)
    dfs(g, ___)             // the fourth direction
}
]],
          [[
    g[r][c] = '0'
    dfs(g, r+1, c)
    dfs(g, r-1, c)
    dfs(g, r, c+1)
    dfs(g, ___)             // 네 번째 방향
}
]],
          [[
    g[r][c] = '0'
    dfs(g, r+1, c)
    dfs(g, r-1, c)
    dfs(g, r, c+1)
    dfs(g, ___)             // 第四個方向
}
]]
        ),
        answer = "r, c-1",
        accept = { "r, c-1", "r,c-1", "r, c - 1" },
        hint = L(
          "Left: the same row, one column back.",
          "왼쪽: 같은 행, 한 열 뒤.",
          "左：同一行，退一列。"
        ),
        ok = L(
          "Up, down, right, left. A dirs table {{1,0},{-1,0},{0,1},{0,-1}} is the same thing in a loop.",
          "위, 아래, 오른쪽, 왼쪽. dirs 표 {{1,0},{-1,0},{0,1},{0,-1}}는 같은 것을 루프로.",
          "上、下、右、左。一個 dirs 表 {{1,0},{-1,0},{0,1},{0,-1}} 就係同一樣嘢放入 loop。"
        ),
      },
      {
        topic = "COUNT",
        q = L(
          "Count islands: every land cell still standing starts a new one. Fill the call that sinks the whole island.",
          "섬 세기: 아직 남은 땅 셀마다 새 섬이 시작된다. 섬 전체를 가라앉히는 호출을 채우기.",
          "數島：每個仲企喺度嘅陸地格都開一個新島。填將成個島沉落去嗰個 call。"
        ),
        code = L(
          [[
count := 0
for r := range g {
    for c := range g[r] {
        if g[r][c] == '1' {
            count++         // a new island
            ___(g, r, c)    // sink all of it
]],
          [[
count := 0
for r := range g {
    for c := range g[r] {
        if g[r][c] == '1' {
            count++         // 새 섬
            ___(g, r, c)    // 전부 가라앉히기
]],
          [[
count := 0
for r := range g {
    for c := range g[r] {
        if g[r][c] == '1' {
            count++         // 一個新島
            ___(g, r, c)    // 全部沉落去
]]
        ),
        answer = "dfs",
        accept = { "dfs" },
        hint = L(
          "The flood function from the blanks above.",
          "위 빈칸들의 그 채우기 함수.",
          "上面幾個空格嗰個 flood function。"
        ),
        ok = L(
          "Each cell is visited a constant number of times: O(rows*cols). A BFS with a queue avoids deep recursion. OFFER.",
          "각 셀은 상수 번만 방문: O(행*열). 큐를 쓴 BFS면 깊은 재귀를 피한다. OFFER.",
          "每格只會去常數次：O(行*列)。用 queue 嘅 BFS 可以避開太深嘅遞歸。OFFER。"
        ),
      },
    },
  },
}

return maps
