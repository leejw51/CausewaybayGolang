-- Rust quest R6 CALLBACK: the second interview. 20:30, after the evening
-- CODE RUSH ended in HIRED, the Times Square startup calls Mei back for the
-- whiteboard round in the back office. Siu Ming asks, Mei writes, Alex
-- cheers. Seven classic interview problems the first show skipped: a stack,
-- dynamic programming, a sliding window, a heap, intervals, an LRU cache and
-- a grid. The blanks of one street together form the algorithm. Prize: OFFER.
-- Same shape as src/data_rs_quiz.lua: the blank ___ is NOT written in the code.

local function L(en, ko, yue)
  return { en = en, ko = ko, yue = yue }
end

local maps = {
  {
    id = "rs_stack",
    station = "STACK",
    name = L("ROUND 1  -  the brackets", "라운드 1  -  괄호", "第一回合  -  括號"),
    title = L("Valid parentheses and a min stack", "올바른 괄호와 최소 스택", "合法括號同 min stack"),
    lesson = L(
      "A Vec<char> is the stack: push every opener, pop on every closer and compare. Valid when the stack ends empty. A second Vec of the smallest-so-far gives the minimum in O(1).",
      "Vec<char>가 스택: 여는 괄호는 push, 닫는 괄호마다 pop해서 비교. 스택이 비어 끝나면 올바르다. 지금까지의 최솟값을 담는 둘째 Vec이 O(1)로 최솟값을 준다.",
      "Vec<char> 就係個 stack：開括號就 push，每個閂括號就 pop 嚟比較。最後 stack 係空就合法。第二個 Vec 記住到目前為止最細嘅，O(1) 攞到最細值。"
    ),
    bg = "bg_lab",
    portrait = "portrait_clerk",
    speaker = L("Siu Ming", "시우밍", "小明"),
    ground = 348,
    spawn = 180,
    width = 1600,
    npcs = {
      {
        kind = "clerk",
        x = 560,
        facing = -1,
        line = L(
          "Callback round, Mei. No buzzer this time, just the whiteboard. Warm-up: are these brackets balanced?",
          "콜백 라운드예요, 메이. 이번엔 버저 없이 화이트보드만. 몸풀기: 이 괄호들은 균형이 맞나요?",
          "Callback 回合，阿美。今次冇蜂鳴器，淨係白板。熱身：呢啲括號平唔平衡？"
        ),
      },
      {
        kind = "hero",
        x = 900,
        facing = -1,
        line = L(
          "You got HIRED at seven. This is the OFFER round. A stack, Mei, it's always a stack.",
          "7시에 HIRED 받았잖아. 이번엔 OFFER 라운드야. 스택이야, 메이, 언제나 스택이라고.",
          "七點你已經 HIRED。呢個係 OFFER 回合。stack 呀阿美，永遠都係 stack。"
        ),
      },
    },
    viz = "rust",
    chips = {
      { "let mut st: Vec<char>", "cyan" },
      { "st.pop() != Some(open)", "gold" },
      { "st.is_empty()", "pink" },
      { "low.push(x.min(m))", "green" },
    },
    note = "match closer  push  pop  is_empty  second stack",
    story = L(
      "20:30. The Times Square screen is dark; the startup's back office is not. A whiteboard, a marker, "
        .. "Siu Ming with a clipboard. The callback round: the problems the live show never had time for. "
        .. "First, brackets. Every ( wants its ), in order, and a Vec is the stack.",
      "20:30. 타임스퀘어 전광판은 꺼졌지만 스타트업 사무실은 아니다. 화이트보드, 마커, "
        .. "클립보드를 든 시우밍. 콜백 라운드: 생방송에서 시간이 없어 못 낸 문제들. "
        .. "먼저 괄호. 모든 (는 순서대로 )를 원하고, Vec이 곧 스택이다.",
      "八點半。時代廣場個大螢幕熄咗，但係 startup 嘅後勤房未熄。一塊白板、一支筆、"
        .. "拎住 clipboard 嘅小明。Callback 回合：直播冇時間出嘅題。"
        .. "首先係括號。每個 ( 都要順序搵到佢嘅 )，而 Vec 就係個 stack。"
    ),
    stages = {
      {
        topic = "PAIRS",
        q = L(
          "A closer names the opener it needs. Finish the match: '}' wants which char?",
          "닫는 괄호는 자기가 필요로 하는 여는 괄호를 말한다. match를 완성: '}'는 어떤 문자를 원하나?",
          "閂括號講出佢要嘅開括號。完成個 match：'}' 要邊個字元？"
        ),
        code = L(
          [[
for c in s.chars() {
    let open = match c {
        ')' => '(',
        ']' => '[',
        '}' => ___,
        _ => '\0',          // not a closer
    };
]],
          [[
for c in s.chars() {
    let open = match c {
        ')' => '(',
        ']' => '[',
        '}' => ___,
        _ => '\0',          // 닫는 괄호가 아님
    };
]],
          [[
for c in s.chars() {
    let open = match c {
        ')' => '(',
        ']' => '[',
        '}' => ___,
        _ => '\0',          // 唔係閂括號
    };
]]
        ),
        answer = "'{'",
        accept = { "'{'", "{" },
        hint = L(
          "The curly opener, as a char literal in single quotes.",
          "여는 중괄호, 작은따옴표의 char 리터럴로.",
          "開嘅大括號，用單引號寫做 char literal。"
        ),
        ok = L(
          "Three pairs, one match. '\\0' marks an opener; the rest of the loop branches on that.",
          "쌍 셋, match 하나. '\\0'는 여는 괄호 표시; 루프의 나머지는 그걸로 분기한다.",
          "三對括號，一個 match。'\\0' 代表開括號；loop 嘅其餘部分靠佢分支。"
        ),
      },
      {
        topic = "PUSH",
        q = L(
          "An opener waits for its partner. Which Vec method puts c on top of the stack?",
          "여는 괄호는 짝을 기다린다. c를 스택 맨 위에 올리는 Vec 메서드는?",
          "開括號等佢個拍檔。邊個 Vec method 將 c 放上 stack 頂？"
        ),
        code = L(
          [[
let mut st: Vec<char> = Vec::new();
for c in s.chars() {
    let open = closer_of(c);
    if open == '\0' {
        st.___(c);          // wait here for the closer
        continue;
    }
]],
          [[
let mut st: Vec<char> = Vec::new();
for c in s.chars() {
    let open = closer_of(c);
    if open == '\0' {
        st.___(c);          // 닫는 짝을 기다림
        continue;
    }
]],
          [[
let mut st: Vec<char> = Vec::new();
for c in s.chars() {
    let open = closer_of(c);
    if open == '\0' {
        st.___(c);          // 喺度等閂括號
        continue;
    }
]]
        ),
        answer = "push",
        accept = { "push", "push()", "push(c)" },
        hint = L(
          "The same method that appends to any Vec. The top of the stack is the end of the Vec.",
          "아무 Vec에나 덧붙이는 그 메서드. 스택의 맨 위는 Vec의 끝.",
          "同任何 Vec 加嘢嘅嗰個 method。stack 頂就係 Vec 嘅尾。"
        ),
        ok = L(
          "A Vec is a stack for free: the end is the top, and both ends of work are O(1).",
          "Vec은 공짜 스택: 끝이 맨 위고, 넣고 빼는 것 모두 O(1).",
          "Vec 免費就係個 stack：尾就係頂，放同攞都係 O(1)。"
        ),
      },
      {
        topic = "POP",
        q = L(
          "A closer must match the most recent opener. Which method takes the top off and returns Option<char>?",
          "닫는 괄호는 가장 최근의 여는 괄호와 맞아야 한다. 맨 위를 꺼내 Option<char>를 돌려주는 메서드는?",
          "閂括號一定要對到最近嗰個開括號。邊個 method 攞走個頂，回傳 Option<char>？"
        ),
        code = L(
          [[
    // a closer: the top must be its opener, else bad
    if st.___() != Some(open) {
        return false;
    }
}
]],
          [[
    // 닫는 괄호: 맨 위가 짝이어야, 아니면 실패
    if st.___() != Some(open) {
        return false;
    }
}
]],
          [[
    // 閂括號：個頂要係佢個開括號，否則唔合法
    if st.___() != Some(open) {
        return false;
    }
}
]]
        ),
        answer = "pop",
        accept = { "pop", "pop()" },
        hint = L(
          "Three letters, the opposite of the last blank. None when the stack is already empty, and None != Some(open).",
          "세 글자, 앞 빈칸의 반대. 스택이 이미 비었으면 None이고, None != Some(open).",
          "三個字母，上一個空格嘅相反。stack 已經空就係 None，而 None != Some(open)。"
        ),
        ok = L(
          "Option does the empty case for free: a closer with nothing to pop is a mismatch, no extra if needed.",
          "Option이 빈 경우를 공짜로 처리: 꺼낼 게 없는 닫는 괄호는 불일치, 추가 if가 필요 없다.",
          "Option 免費處理咗空嘅情況：冇嘢 pop 嘅閂括號就係唔對，唔使多一個 if。"
        ),
      },
      {
        topic = "EMPTY",
        q = L(
          "After the loop, what makes the string valid? Every opener found its closer, so the stack is what?",
          "루프가 끝난 뒤, 문자열이 올바르려면? 모든 여는 괄호가 짝을 찾았으니 스택은 어떤 상태?",
          "loop 完咗之後，點先算合法？每個開括號都搵到閂括號，即係 stack 係點？"
        ),
        code = L(
          [[
fn is_valid(s: &str) -> bool {
    let mut st: Vec<char> = Vec::new();
    for c in s.chars() {
        // ... push openers, pop and compare closers ...
    }
    st.___()             // "(()" leaves one behind: false
}
]],
          [[
fn is_valid(s: &str) -> bool {
    let mut st: Vec<char> = Vec::new();
    for c in s.chars() {
        // ... 여는 건 push, 닫는 건 pop ...
    }
    st.___()             // "(()"는 하나 남음: false
}
]],
          [[
fn is_valid(s: &str) -> bool {
    let mut st: Vec<char> = Vec::new();
    for c in s.chars() {
        // ... 開括號 push，閂括號 pop 嚟比較 ...
    }
    st.___()             // "(()" 會剩低一個：false
}
]]
        ),
        answer = "is_empty",
        accept = { "is_empty", "is_empty()" },
        hint = L(
          "A bool method on every collection, two words joined by an underscore. Not len() == 0, though that works too.",
          "모든 컬렉션에 있는 bool 메서드, 밑줄로 이은 두 단어. len() == 0도 되지만 그건 아니다.",
          "每個 collection 都有嘅 bool method，兩個字用底線連住。唔係 len() == 0，雖然嗰個都得。"
        ),
        ok = L(
          "The last expression is the return value. One pass, one stack: O(n) time, O(n) space at worst.",
          "마지막 표현식이 반환값. 한 번 훑기, 스택 하나: O(n) 시간, 최악 O(n) 공간.",
          "最後一個 expression 就係回傳值。行一次，一個 stack：O(n) 時間，最差 O(n) 空間。"
        ),
      },
      {
        topic = "MIN",
        q = L(
          "A stack that also reports its smallest value in O(1). Push keeps a second stack of the smallest so far. Which i32 method picks the smaller of x and m?",
          "최솟값도 O(1)에 알려주는 스택. push는 지금까지의 최솟값을 담는 둘째 스택을 유지한다. x와 m 중 작은 쪽을 고르는 i32 메서드는?",
          "一個 O(1) 就講到最細值嘅 stack。push 維持第二個 stack，記住到目前為止最細嘅。邊個 i32 method 揀 x 同 m 之中細嗰個？"
        ),
        code = L(
          [[
// a second stack: the smallest so far, at every depth
fn push(&mut self, x: i32) {
    let m = *self.low.last().unwrap_or(&x);
    self.st.push(x);
    self.low.push(x.___(m));
}
// the smallest: *self.low.last().unwrap()   O(1)
]],
          [[
// 둘째 스택: 각 깊이에서 지금까지의 최솟값
fn push(&mut self, x: i32) {
    let m = *self.low.last().unwrap_or(&x);
    self.st.push(x);
    self.low.push(x.___(m));
}
// 최솟값: *self.low.last().unwrap()   O(1)
]],
          [[
// 第二個 stack：每層記住到目前為止最細嘅
fn push(&mut self, x: i32) {
    let m = *self.low.last().unwrap_or(&x);
    self.st.push(x);
    self.low.push(x.___(m));
}
// 最細值：*self.low.last().unwrap()   O(1)
]]
        ),
        answer = "min",
        accept = { "min", "min()" },
        hint = L(
          "Three letters, from Ord. Its twin picks the larger one.",
          "세 글자, Ord에서 온다. 쌍둥이 메서드는 더 큰 쪽을 고른다.",
          "三個字母，來自 Ord。佢個孖生兄弟揀大嗰個。"
        ),
        ok = L(
          "pop pops both stacks, so the smallest is always on top of low. O(1) push, pop and get, O(n) space.",
          "pop은 두 스택을 모두 꺼내므로 최솟값은 항상 low의 맨 위. push, pop, 조회 모두 O(1), 공간 O(n).",
          "pop 兩個 stack 一齊 pop，所以最細值永遠喺 low 嘅頂。push、pop、攞值都係 O(1)，空間 O(n)。"
        ),
      },
    },
  },
  {
    id = "rs_dp",
    station = "DP",
    name = L("ROUND 2  -  the stairs", "라운드 2  -  계단", "第二回合  -  樓梯"),
    title = L(
      "Dynamic programming: stairs and coins",
      "동적 계획법: 계단과 동전",
      "動態規劃：樓梯同硬幣"
    ),
    lesson = L(
      "DP fills a table from small answers up. Stairs: dp[i] = dp[i-1] + dp[i-2]. Coin change: dp[a] = min over coins of dp[a-c] + 1, with amount+1 as 'impossible'.",
      "DP는 작은 답부터 표를 채운다. 계단: dp[i] = dp[i-1] + dp[i-2]. 동전 교환: dp[a]는 동전마다 dp[a-c] + 1의 최솟값, amount+1이 '불가능'.",
      "DP 由細答案開始填表。樓梯：dp[i] = dp[i-1] + dp[i-2]。找換硬幣：dp[a] 係每個硬幣 dp[a-c] + 1 之中最細嘅，amount+1 代表「唔可能」。"
    ),
    bg = "bg_lab",
    portrait = "portrait_friends",
    speaker = L("Mei", "메이", "阿美"),
    ground = 348,
    spawn = 180,
    width = 1600,
    npcs = {
      {
        kind = "clerk",
        x = 560,
        facing = -1,
        line = L(
          "Round two. The Times Square stairs: one or two steps at a time. How many ways up? Then make change for the till.",
          "2라운드. 타임스퀘어 계단: 한 번에 한 칸 또는 두 칸. 올라가는 방법은 몇 가지? 그다음 계산대 거스름돈.",
          "第二回合。時代廣場嘅樓梯：一次行一級或者兩級。有幾多種行法？跟住幫收銀機找錢。"
        ),
      },
      {
        kind = "hero",
        x = 900,
        facing = -1,
        line = L(
          "It's fib with a table instead of a memo. Bottom up, Mei. No recursion, no stack overflow.",
          "memo 대신 표로 하는 fib야. 아래에서 위로, 메이. 재귀도 스택 오버플로도 없어.",
          "即係用表代替 memo 嘅 fib。由下而上，阿美。冇遞歸，冇 stack overflow。"
        ),
      },
    },
    viz = "rust",
    chips = {
      { "vec![0u64; n + 1]", "cyan" },
      { "dp[i-1] + dp[i-2]", "gold" },
      { "vec![amount+1; amount+1]", "pink" },
      { "dp[a].min(dp[a-c] + 1)", "green" },
    },
    note = "table  base  step  impossible marker  O(n*coins)",
    story = L(
      "20:38. Siu Ming draws a staircase. One step or two at a time: how many ways to the top? "
        .. "Mei sees fib, but this time there is no memo: a Vec filled from the bottom. "
        .. "Then the till: the fewest coins for 27 dollars, from 1, 5 and 10. Same table, a min instead of a sum.",
      "20:38. 시우밍이 계단을 그린다. 한 번에 한 칸 또는 두 칸: 꼭대기까지 몇 가지 방법? "
        .. "메이는 fib를 알아보지만 이번엔 memo가 없다: 아래부터 채우는 Vec. "
        .. "그다음 계산대: 1, 5, 10으로 27달러를 만드는 최소 동전 수. 같은 표, 합 대신 min.",
      "八點三十八分。小明畫咗條樓梯。一次一級或者兩級：去到頂有幾多種行法？"
        .. "阿美睇出係 fib，不過今次冇 memo：一個由底填上去嘅 Vec。"
        .. "跟住係收銀機：用 1、5、10 砌 27 蚊，最少幾多個硬幣。同一張表，min 代替加。"
    ),
    stages = {
      {
        topic = "BASE",
        q = L(
          "The table starts with what is already known. One way to stand at the bottom, and how many ways to reach step 1?",
          "표는 이미 아는 것에서 시작. 바닥에 서 있는 방법 하나, 그럼 1번 계단에 이르는 방법은 몇 가지?",
          "張表由已知嘅開始。企喺底有一種方法，咁去到第 1 級有幾多種？"
        ),
        code = L(
          [[
fn climb(n: usize) -> u64 {
    let mut dp = vec![0u64; n + 1];
    dp[0] = 1;              // stand still
    dp[1] = ___;            // a single step
]],
          [[
fn climb(n: usize) -> u64 {
    let mut dp = vec![0u64; n + 1];
    dp[0] = 1;              // 제자리
    dp[1] = ___;            // 한 칸
]],
          [[
fn climb(n: usize) -> u64 {
    let mut dp = vec![0u64; n + 1];
    dp[0] = 1;              // 企定
    dp[1] = ___;            // 一級
]]
        ),
        answer = "1",
        accept = { "1" },
        hint = L(
          "Only one move reaches the first step: a single step of one.",
          "1번 계단에 이르는 움직임은 하나뿐: 한 칸 한 번.",
          "去到第 1 級只有一種行法：行一級。"
        ),
        ok = L(
          "Base cases seed the table. From here every entry is built from the two before it.",
          "기저 조건이 표의 씨앗. 여기부터 모든 항목은 앞의 둘로 만들어진다.",
          "Base case 係張表嘅種子。由呢度開始，每一格都由前面兩格砌出嚟。"
        ),
      },
      {
        topic = "STEP",
        q = L(
          "You reach step i from one step below or two steps below. Fill the second index.",
          "i번 계단엔 한 칸 아래나 두 칸 아래에서 도착한다. 둘째 인덱스를 채워라.",
          "去到第 i 級，可以由下面一級或者下面兩級嚟。填第二個 index。"
        ),
        code = L(
          [[
    for i in 2..=n {
        // the last move was a 1 or a 2
        dp[i] = dp[i - 1] + dp[___];
    }
    dp[n]
}
]],
          [[
    for i in 2..=n {
        // 마지막 움직임은 1 아니면 2
        dp[i] = dp[i - 1] + dp[___];
    }
    dp[n]
}
]],
          [[
    for i in 2..=n {
        // 最後一步係 1 或者 2
        dp[i] = dp[i - 1] + dp[___];
    }
    dp[n]
}
]]
        ),
        answer = "i - 2",
        accept = { "i - 2", "i-2" },
        hint = L(
          "Two steps below i. The loop starts at 2 so this index never goes negative.",
          "i의 두 칸 아래. 루프가 2에서 시작해서 이 인덱스는 음수가 되지 않는다.",
          "i 下面兩級。loop 由 2 開始，所以呢個 index 唔會變負數。"
        ),
        ok = L(
          "Bottom-up fib: O(n) time, no recursion, and only two cells are ever needed, so O(1) space is possible.",
          "상향식 fib: O(n) 시간, 재귀 없음, 실제로 필요한 칸은 둘뿐이라 O(1) 공간도 가능.",
          "由下而上嘅 fib：O(n) 時間，冇遞歸，其實淨係用到兩格，所以 O(1) 空間都得。"
        ),
      },
      {
        topic = "ZERO",
        q = L(
          "Coin change: dp[a] is the fewest coins for amount a. The table starts full of 'impossible'. Which amount costs zero coins?",
          "동전 교환: dp[a]는 금액 a의 최소 동전 수. 표는 '불가능'으로 가득 채워 시작. 동전 0개가 드는 금액은?",
          "找換硬幣：dp[a] 係砌到金額 a 最少嘅硬幣數。張表一開始全部係「唔可能」。邊個金額要 0 個硬幣？"
        ),
        code = L(
          [[
fn change(coins: &[usize], amount: usize) -> i64 {
    // amount + 1 is more than any real answer: "impossible"
    let mut dp = vec![amount + 1; amount + 1];
    dp[___] = 0;
]],
          [[
fn change(coins: &[usize], amount: usize) -> i64 {
    // amount + 1은 어떤 답보다 크다: "불가능"
    let mut dp = vec![amount + 1; amount + 1];
    dp[___] = 0;
]],
          [[
fn change(coins: &[usize], amount: usize) -> i64 {
    // amount + 1 大過任何答案：「唔可能」
    let mut dp = vec![amount + 1; amount + 1];
    dp[___] = 0;
]]
        ),
        answer = "0",
        accept = { "0" },
        hint = L(
          "The empty till. Making nothing takes no coins at all.",
          "빈 계산대. 아무것도 안 만드는 데는 동전이 하나도 안 든다.",
          "空嘅收銀機。乜都唔使砌，一個硬幣都唔使。"
        ),
        ok = L(
          "Every real answer grows out of dp[0]. The marker amount + 1 lets min work without an Option.",
          "모든 진짜 답은 dp[0]에서 자란다. amount + 1 표시 덕에 Option 없이 min이 된다.",
          "每個真正嘅答案都由 dp[0] 長出嚟。amount + 1 呢個標記令 min 唔使用 Option 都得。"
        ),
      },
      {
        topic = "MIN",
        q = L(
          "For each amount a and coin c that fits: one coin c on top of the best for a - c. Keep the smaller. Which method?",
          "각 금액 a와 들어맞는 동전 c마다: a - c의 최선 위에 동전 c 하나. 더 작은 쪽을 남긴다. 어떤 메서드?",
          "每個金額 a 同啱用嘅硬幣 c：喺 a - c 嘅最佳答案上面加一個 c。留細嗰個。邊個 method？"
        ),
        code = L(
          [[
    for a in 1..=amount {
        for &c in coins {
            if c <= a {
                dp[a] = dp[a].___(dp[a - c] + 1);
            }
        }
    }
]],
          [[
    for a in 1..=amount {
        for &c in coins {
            if c <= a {
                dp[a] = dp[a].___(dp[a - c] + 1);
            }
        }
    }
]],
          [[
    for a in 1..=amount {
        for &c in coins {
            if c <= a {
                dp[a] = dp[a].___(dp[a - c] + 1);
            }
        }
    }
]]
        ),
        answer = "min",
        accept = { "min", "min()" },
        hint = L(
          "Three letters from Ord: the smaller of the current entry and the new candidate.",
          "Ord의 세 글자: 현재 항목과 새 후보 중 작은 쪽.",
          "Ord 嘅三個字母：而家嘅格同新候選之中細嗰個。"
        ),
        ok = L(
          "O(amount * coins). The greedy 'biggest coin first' fails for coins like 1, 3, 4 and amount 6; the table does not.",
          "O(amount * coins). '큰 동전부터' 탐욕법은 동전 1, 3, 4에 금액 6이면 실패하지만 표는 아니다.",
          "O(amount * coins)。「大硬幣先」嘅貪心法遇到 1、3、4 砌 6 就會錯；張表唔會。"
        ),
      },
      {
        topic = "NONE",
        q = L(
          "If dp[amount] never dropped below the marker, no combination works. What does the function return then?",
          "dp[amount]가 표시 아래로 내려온 적이 없으면 어떤 조합도 안 된다. 그때 함수는 무엇을 반환?",
          "如果 dp[amount] 從來冇跌落標記以下，即係冇組合砌到。咁 function 回傳咩？"
        ),
        code = L(
          [[
    // still the marker: no coins ever reached this amount
    if dp[amount] > amount { ___ }
    else { dp[amount] as i64 }
}
// change(&[1, 5, 10], 27) == 5      change(&[2], 3) == -1
]],
          [[
    // 아직 표시 그대로: 닿은 동전이 없다
    if dp[amount] > amount { ___ }
    else { dp[amount] as i64 }
}
// change(&[1, 5, 10], 27) == 5      change(&[2], 3) == -1
]],
          [[
    // 仲係個標記：冇硬幣去到過呢個金額
    if dp[amount] > amount { ___ }
    else { dp[amount] as i64 }
}
// change(&[1, 5, 10], 27) == 5      change(&[2], 3) == -1
]]
        ),
        answer = "-1",
        accept = { "-1" },
        hint = L(
          "The usual 'not found' number, which is why the return type is i64 and not usize.",
          "흔한 '없음' 숫자, 그래서 반환 타입이 usize가 아닌 i64.",
          "慣常嘅「搵唔到」數字，所以 return type 係 i64 而唔係 usize。"
        ),
        ok = L(
          "Option<usize> would be more Rust; the interview version returns -1. Either way: check the marker before trusting the cell.",
          "Option<usize>가 더 Rust답지만 면접 버전은 -1을 반환. 어느 쪽이든 칸을 믿기 전에 표시를 확인.",
          "Option<usize> 更加 Rust，面試版本就回傳 -1。點都好：信個格之前先檢查個標記。"
        ),
      },
    },
  },
  {
    id = "rs_window",
    station = "WINDOW",
    name = L("ROUND 3  -  the window", "라운드 3  -  창", "第三回合  -  窗口"),
    title = L(
      "Sliding windows and two pointers",
      "슬라이딩 윈도우와 투 포인터",
      "Sliding window 同 two pointers"
    ),
    lesson = L(
      "Kadane: cur = x.max(cur + x). A fixed window adds the new item and drops the old one. A growing window moves its left end while a HashSet says repeat. Two pointers walk in from both ends of a sorted slice.",
      "Kadane: cur = x.max(cur + x). 고정 창은 새 항목을 더하고 옛 항목을 뺀다. 늘어나는 창은 HashSet이 중복이라 하는 동안 왼쪽 끝을 옮긴다. 투 포인터는 정렬된 슬라이스 양끝에서 안으로 걷는다.",
      "Kadane：cur = x.max(cur + x)。固定窗口加新嘅、減舊嘅。會長嘅窗口喺 HashSet 話重複嘅時候移左邊。two pointers 由排好序嘅 slice 兩端行入嚟。"
    ),
    bg = "bg_lab",
    portrait = "portrait_clerk",
    speaker = L("Siu Ming", "시우밍", "小明"),
    ground = 348,
    spawn = 180,
    width = 1600,
    npcs = {
      {
        kind = "clerk",
        x = 560,
        facing = -1,
        line = L(
          "Round three: the best run of sales in a week, the busiest k hours, the longest streak of different dishes. All one pass.",
          "3라운드: 한 주 최고의 매출 구간, 가장 바쁜 k시간, 서로 다른 요리가 가장 길게 이어진 구간. 전부 한 번 훑기.",
          "第三回合：一星期入面最好嘅一段生意、最忙嘅 k 個鐘、最長一段唔重複嘅菜。全部一次過。"
        ),
      },
      {
        kind = "mei",
        x = 900,
        facing = -1,
        line = L(
          "No nested loops. A window slides; the answer updates as it goes.",
          "중첩 루프 없이. 창이 미끄러지고 답은 가면서 갱신돼.",
          "唔使 nested loop。個窗口滑過去，答案一路更新。"
        ),
      },
    },
    viz = "rust",
    chips = {
      { "cur = x.max(cur + x)", "cyan" },
      { "sum += a[i] - a[i - k]", "gold" },
      { "seen.remove(&b[l])", "pink" },
      { "while i < j", "green" },
    },
    note = "Kadane  fixed k  grow / shrink  both ends  O(n)",
    story = L(
      "20:45. A week of Lucky Mac Express sales on the whiteboard, some days negative. Which run of days made the most? "
        .. "Mei writes Kadane in four lines. Then windows of k hours, then the longest stretch of dishes with no repeat. "
        .. "Every one of them is one pass and two indices.",
      "20:45. 화이트보드에 럭키 맥 익스프레스의 한 주 매출, 어떤 날은 마이너스. 어느 구간이 가장 많이 벌었나? "
        .. "메이는 Kadane을 네 줄로 쓴다. 그다음 k시간짜리 창, 그다음 중복 없는 가장 긴 요리 구간. "
        .. "전부 한 번 훑기와 인덱스 둘.",
      "八點四十五分。白板上面係幸運麥 Express 一星期嘅生意，有幾日係負數。邊一段日子賺最多？"
        .. "阿美四行寫完 Kadane。跟住係 k 個鐘嘅窗口，再跟住係最長一段唔重複嘅菜。"
        .. "每一題都係行一次、兩個 index。"
    ),
    stages = {
      {
        topic = "KADANE",
        q = L(
          "Best subarray sum: at each x, either extend the current run or start fresh at x. Which method picks the larger?",
          "최대 부분합: 각 x에서 현재 구간을 잇거나 x에서 새로 시작. 더 큰 쪽을 고르는 메서드는?",
          "最大子陣列和：每個 x，一係接住目前呢段，一係喺 x 重新開始。邊個 method 揀大嗰個？"
        ),
        code = L(
          [[
// biggest run of days: extend the run, or start over at x
let (mut cur, mut best) = (a[0], a[0]);
for &x in &a[1..] {
    cur = x.___(cur + x);
    if cur > best { best = cur; }
}
]],
          [[
// 최대 구간: 잇거나, x에서 다시 시작
let (mut cur, mut best) = (a[0], a[0]);
for &x in &a[1..] {
    cur = x.___(cur + x);
    if cur > best { best = cur; }
}
]],
          [[
// 最賺錢嘅一段：接住，或者由 x 重新開始
let (mut cur, mut best) = (a[0], a[0]);
for &x in &a[1..] {
    cur = x.___(cur + x);
    if cur > best { best = cur; }
}
]]
        ),
        answer = "max",
        accept = { "max", "max()" },
        hint = L(
          "Three letters from Ord, the twin of the one that picks the smaller.",
          "Ord의 세 글자, 더 작은 쪽을 고르는 것의 쌍둥이.",
          "Ord 嘅三個字母，揀細嗰個嘅孖生兄弟。"
        ),
        ok = L(
          "Kadane's algorithm: a negative run is worth dropping. O(n) time, O(1) space, no nested loop.",
          "Kadane 알고리즘: 음수 구간은 버리는 게 낫다. O(n) 시간, O(1) 공간, 중첩 루프 없음.",
          "Kadane 算法：負數嘅一段不如掉咗佢。O(n) 時間，O(1) 空間，冇 nested loop。"
        ),
      },
      {
        topic = "SLIDE",
        q = L(
          "The busiest k hours: keep one running sum. The window moves right by one: add a[i], and subtract which element?",
          "가장 바쁜 k시간: 누적 합 하나를 유지. 창이 오른쪽으로 한 칸: a[i]를 더하고 어떤 원소를 빼나?",
          "最忙嘅 k 個鐘：維持一個累計和。窗口向右移一格：加 a[i]，減邊個元素？"
        ),
        code = L(
          [[
// the sum of every window of k, without re-adding k items
let mut sum: i32 = a[..k].iter().sum();
let mut best = sum;
for i in k..a.len() {
    sum += a[i] - a[___];       // one in, one out
    if sum > best { best = sum; }
}
]],
          [[
// k짜리 창마다의 합, k개를 다시 더하지 않고
let mut sum: i32 = a[..k].iter().sum();
let mut best = sum;
for i in k..a.len() {
    sum += a[i] - a[___];       // 하나 들고 하나 남
    if sum > best { best = sum; }
}
]],
          [[
// 每個 k 窗口嘅和，唔使重新加 k 個
let mut sum: i32 = a[..k].iter().sum();
let mut best = sum;
for i in k..a.len() {
    sum += a[i] - a[___];       // 一個入，一個出
    if sum > best { best = sum; }
}
]]
        ),
        answer = "i - k",
        accept = { "i - k", "i-k" },
        hint = L(
          "The element that just fell off the left edge: k positions behind i.",
          "방금 왼쪽 가장자리로 떨어져 나간 원소: i보다 k칸 뒤.",
          "啱啱跌出左邊嘅元素：喺 i 後面 k 格。"
        ),
        ok = L(
          "A fixed window is O(n), not O(n*k): every element enters once and leaves once.",
          "고정 창은 O(n*k)가 아닌 O(n): 모든 원소는 한 번 들어오고 한 번 나간다.",
          "固定窗口係 O(n)，唔係 O(n*k)：每個元素入一次、出一次。"
        ),
      },
      {
        topic = "SHRINK",
        q = L(
          "Longest run of distinct bytes: a window [l, r] and a HashSet of what is inside. When b[r] is already in, drop from the left until it is not. Which HashSet method removes?",
          "서로 다른 바이트의 가장 긴 구간: 창 [l, r]과 안에 있는 것들의 HashSet. b[r]이 이미 있으면 없어질 때까지 왼쪽에서 뺀다. 제거하는 HashSet 메서드는?",
          "最長一段唔重複嘅 byte：窗口 [l, r] 同一個裝住裏面嘢嘅 HashSet。b[r] 已經喺入面，就由左邊掉，直到佢唔喺入面。邊個 HashSet method 係移除？"
        ),
        code = L(
          [[
let b = s.as_bytes();
let mut seen = HashSet::new();
let (mut l, mut best) = (0, 0);
for r in 0..b.len() {
    while seen.contains(&b[r]) {
        seen.___(&b[l]);    // the left end leaves
        l += 1;
]],
          [[
let b = s.as_bytes();
let mut seen = HashSet::new();
let (mut l, mut best) = (0, 0);
for r in 0..b.len() {
    while seen.contains(&b[r]) {
        seen.___(&b[l]);    // 왼쪽 끝이 나감
        l += 1;
]],
          [[
let b = s.as_bytes();
let mut seen = HashSet::new();
let (mut l, mut best) = (0, 0);
for r in 0..b.len() {
    while seen.contains(&b[r]) {
        seen.___(&b[l]);    // 左邊嗰個走
        l += 1;
]]
        ),
        answer = "remove",
        accept = { "remove", "remove()" },
        hint = L(
          "The opposite of insert, six letters. Takes a reference, returns whether it was there.",
          "insert의 반대, 여섯 글자. 참조를 받고 있었는지를 돌려준다.",
          "insert 嘅相反，六個字母。接收 reference，回傳佢本來喺唔喺度。"
        ),
        ok = L(
          "The left pointer only ever moves right, so the while loop costs O(n) over the whole run, not per r.",
          "왼쪽 포인터는 오른쪽으로만 움직이므로 while 루프는 r마다가 아니라 전체에 걸쳐 O(n).",
          "左邊個 pointer 淨係會向右行，所以個 while loop 整體係 O(n)，唔係每個 r 都 O(n)。"
        ),
      },
      {
        topic = "GROW",
        q = L(
          "The repeat is gone: b[r] joins the window. Which HashSet method adds it?",
          "중복이 사라졌다: b[r]이 창에 합류. 추가하는 HashSet 메서드는?",
          "重複嘅走咗：b[r] 加入窗口。邊個 HashSet method 加佢入去？"
        ),
        code = L(
          [[
    while seen.contains(&b[r]) {
        seen.remove(&b[l]);
        l += 1;
    }
    seen.___(b[r]);         // the right end joins
    best = best.max(r - l + 1);
}
]],
          [[
    while seen.contains(&b[r]) {
        seen.remove(&b[l]);
        l += 1;
    }
    seen.___(b[r]);         // 오른쪽 끝이 합류
    best = best.max(r - l + 1);
}
]],
          [[
    while seen.contains(&b[r]) {
        seen.remove(&b[l]);
        l += 1;
    }
    seen.___(b[r]);         // 右邊嗰個加入
    best = best.max(r - l + 1);
}
]]
        ),
        answer = "insert",
        accept = { "insert", "insert()" },
        hint = L(
          "Six letters, the same method a HashMap uses to store a key. Takes the value, not a reference.",
          "여섯 글자, HashMap이 키를 저장할 때 쓰는 것과 같은 메서드. 참조가 아니라 값을 받는다.",
          "六個字母，同 HashMap 存 key 嗰個 method 一樣。接收值，唔係 reference。"
        ),
        ok = L(
          "r - l + 1 is the window's width. Grow on the right, shrink on the left: O(n) with at most 256 bytes in the set.",
          "r - l + 1이 창의 너비. 오른쪽에서 늘리고 왼쪽에서 줄인다: 집합에 최대 256바이트, O(n).",
          "r - l + 1 係窗口嘅闊度。右邊長、左邊縮：O(n)，個 set 最多 256 個 byte。"
        ),
      },
      {
        topic = "POINTERS",
        q = L(
          "Two-sum on a sorted slice, no HashMap: i from the left, j from the right. The sum is too big: which way does j move?",
          "정렬된 슬라이스의 two-sum, HashMap 없이: i는 왼쪽에서, j는 오른쪽에서. 합이 너무 크다: j는 어느 쪽으로?",
          "排好序嘅 slice 做 two-sum，唔用 HashMap：i 由左，j 由右。個和太大：j 向邊邊行？"
        ),
        code = L(
          [[
let (mut i, mut j) = (0, a.len() - 1);     // a is sorted
while i < j {
    match (a[i] + a[j]).cmp(&target) {
        Ordering::Equal => return Some((i, j)),
        Ordering::Less => i += 1,        // need more
        Ordering::Greater => j ___ 1,    // need less
    }
]],
          [[
let (mut i, mut j) = (0, a.len() - 1);     // a는 정렬됨
while i < j {
    match (a[i] + a[j]).cmp(&target) {
        Ordering::Equal => return Some((i, j)),
        Ordering::Less => i += 1,        // 더 커야 함
        Ordering::Greater => j ___ 1,    // 더 작게
    }
]],
          [[
let (mut i, mut j) = (0, a.len() - 1);     // a 已排序
while i < j {
    match (a[i] + a[j]).cmp(&target) {
        Ordering::Equal => return Some((i, j)),
        Ordering::Less => i += 1,        // 要大啲
        Ordering::Greater => j ___ 1,    // 要細啲
    }
]]
        ),
        answer = "-=",
        accept = { "-=" },
        hint = L(
          "The compound operator that walks j one step toward the smaller values, on the left.",
          "j를 더 작은 값 쪽, 왼쪽으로 한 걸음 옮기는 복합 연산자.",
          "將 j 向細啲嘅值、即係左邊行一步嘅複合運算子。"
        ),
        ok = L(
          "Sorted input trades the HashMap for two indices: O(n) time and O(1) space after the sort.",
          "정렬된 입력은 HashMap을 인덱스 둘로 바꾼다: 정렬 후 O(n) 시간, O(1) 공간.",
          "排好序嘅輸入用兩個 index 換走 HashMap：排序之後 O(n) 時間，O(1) 空間。"
        ),
      },
    },
  },
  {
    id = "rs_heap",
    station = "HEAP",
    name = L("ROUND 4  -  the top k", "라운드 4  -  상위 k", "第四回合  -  頭 k 個"),
    title = L(
      "BinaryHeap: kth largest and top k",
      "BinaryHeap: k번째 큰 수와 상위 k",
      "BinaryHeap：第 k 大同頭 k 個"
    ),
    lesson = L(
      "BinaryHeap is a max-heap. Reverse(x) turns it into a min-heap. kth largest: push everything, pop whenever len > k, peek. Top k frequent: count with a HashMap, collect (count, word) into a heap, pop k times.",
      "BinaryHeap은 최대 힙. Reverse(x)로 최소 힙이 된다. k번째 큰 수: 전부 push, len > k면 pop, peek. 최빈 상위 k: HashMap으로 세고 (count, word)를 힙으로 collect, k번 pop.",
      "BinaryHeap 係 max-heap。Reverse(x) 將佢變成 min-heap。第 k 大：全部 push，len > k 就 pop，再 peek。最常見頭 k 個：用 HashMap 數，將 (count, word) collect 入 heap，pop k 次。"
    ),
    bg = "bg_lab",
    portrait = "portrait_friends",
    speaker = L("Mei", "메이", "阿美"),
    ground = 348,
    spawn = 180,
    width = 1600,
    npcs = {
      {
        kind = "clerk",
        x = 560,
        facing = -1,
        line = L(
          "Round four. Ten thousand receipts: the third biggest, and the five dishes ordered most. Without sorting all of it.",
          "4라운드. 영수증 만 장: 세 번째로 큰 것, 그리고 가장 많이 주문된 요리 다섯. 전부 정렬하지 말고.",
          "第四回合。一萬張收據：第三大嗰張，同埋最多人叫嘅五道菜。唔准全部排序。"
        ),
      },
      {
        kind = "hero",
        x = 900,
        facing = -1,
        line = L(
          "A heap of size k, Mei. Rust's is a max-heap, so you'll need the little wrapper that flips it.",
          "크기 k의 힙이야, 메이. Rust 힙은 최대 힙이라 뒤집어 주는 작은 래퍼가 필요해.",
          "一個大細 k 嘅 heap，阿美。Rust 嘅係 max-heap，你要嗰個將佢反轉嘅細 wrapper。"
        ),
      },
    },
    viz = "rust",
    chips = {
      { "BinaryHeap<Reverse<i32>>", "cyan" },
      { "if heap.len() > k", "gold" },
      { "heap.peek().unwrap()", "pink" },
      { "(count, word)", "green" },
    },
    note = "max-heap  Reverse  size k  peek  O(n log k)",
    story = L(
      "20:52. Siu Ming dumps a box of receipts on the table: ten thousand of them. The third largest, please, "
        .. "and the five most ordered dishes. Sorting is O(n log n) and the crowd knows it. "
        .. "Mei draws a heap of size k on the board and the room goes quiet.",
      "20:52. 시우밍이 영수증 상자를 탁자에 쏟는다: 만 장. 세 번째로 큰 것, "
        .. "그리고 가장 많이 주문된 요리 다섯. 정렬은 O(n log n)이고 다들 안다. "
        .. "메이가 보드에 크기 k의 힙을 그리자 방이 조용해진다.",
      "八點五十二分。小明將一箱收據倒喺枱上面：一萬張。要第三大嗰張，"
        .. "同埋最多人叫嘅五道菜。排序係 O(n log n)，觀眾都知。"
        .. "阿美喺白板畫咗個大細 k 嘅 heap，成間房靜晒。"
    ),
    stages = {
      {
        topic = "REVERSE",
        q = L(
          "kth largest: keep only the k biggest in a MIN-heap, so the smallest of them sits on top. BinaryHeap is a max-heap: which std::cmp wrapper flips the order?",
          "k번째 큰 수: 최소 힙에 가장 큰 k개만 남겨 그중 제일 작은 것이 맨 위에 오게. BinaryHeap은 최대 힙: 순서를 뒤집는 std::cmp 래퍼는?",
          "第 k 大：淨係喺 MIN-heap 留住最大嘅 k 個，咁佢哋之中最細嘅就喺頂。BinaryHeap 係 max-heap：邊個 std::cmp wrapper 反轉次序？"
        ),
        code = L(
          [[
// kth largest: a heap of the k biggest, smallest on top.
// BinaryHeap is a max-heap; a std::cmp wrapper flips it.
let mut heap = BinaryHeap::new();
for &x in nums {
    heap.push(___(x));
    if heap.len() > k { heap.pop(); }
}
]],
          [[
// k번째 큰 수: 큰 k개의 힙, 제일 작은 게 위.
// BinaryHeap은 최대 힙; std::cmp 래퍼로 뒤집기.
let mut heap = BinaryHeap::new();
for &x in nums {
    heap.push(___(x));
    if heap.len() > k { heap.pop(); }
}
]],
          [[
// 第 k 大：最大 k 個嘅 heap，最細喺頂。
// BinaryHeap 係 max-heap；std::cmp wrapper 反轉佢。
let mut heap = BinaryHeap::new();
for &x in nums {
    heap.push(___(x));
    if heap.len() > k { heap.pop(); }
}
]]
        ),
        answer = "Reverse",
        accept = { "Reverse", "Reverse()", "std::cmp::Reverse", "cmp::Reverse" },
        hint = L(
          "A tuple struct with one field whose Ord is the other way round. Same word as the iterator's rev, spelled out.",
          "Ord가 거꾸로인 필드 하나짜리 튜플 구조체. 이터레이터의 rev를 다 쓴 단어.",
          "一個 field 嘅 tuple struct，佢嘅 Ord 係倒轉嘅。同 iterator 嘅 rev 同一個字，寫足全寫。"
        ),
        ok = L(
          "Reverse(3) < Reverse(2). Wrapping at push time is the whole trick; no custom Ord impl needed.",
          "Reverse(3) < Reverse(2). push할 때 감싸는 게 비법의 전부; 직접 Ord를 구현할 필요 없다.",
          "Reverse(3) < Reverse(2)。push 嗰陣包一包就係成個技巧；唔使自己 impl Ord。"
        ),
      },
      {
        topic = "TRIM",
        q = L(
          "More than k inside: the smallest, on top, has to go. Which method removes the top?",
          "k개보다 많다: 맨 위의 제일 작은 것이 나가야 한다. 맨 위를 제거하는 메서드는?",
          "入面多過 k 個：頂嗰個、最細嗰個要走。邊個 method 移走個頂？"
        ),
        code = L(
          [[
for &x in nums {
    heap.push(Reverse(x));
    // k + 1 inside: drop the smallest, it can never be kth
    if heap.len() > k {
        heap.___();
    }
}
]],
          [[
for &x in nums {
    heap.push(Reverse(x));
    // k + 1개: 제일 작은 걸 버린다
    if heap.len() > k {
        heap.___();
    }
}
]],
          [[
for &x in nums {
    heap.push(Reverse(x));
    // 有 k + 1 個：掉咗最細嗰個
    if heap.len() > k {
        heap.___();
    }
}
]]
        ),
        answer = "pop",
        accept = { "pop", "pop()" },
        hint = L(
          "Three letters, the same name as on a Vec, but here it returns the top of the heap in O(log k).",
          "세 글자, Vec에서와 같은 이름이지만 여기선 힙의 맨 위를 O(log k)에 돌려준다.",
          "三個字母，同 Vec 嗰個同名，不過喺度佢 O(log k) 回傳 heap 頂。"
        ),
        ok = L(
          "n pushes and pops on a heap of k: O(n log k) time, O(k) space. Sorting would be O(n log n) and O(n).",
          "크기 k 힙에 n번 push와 pop: O(n log k) 시간, O(k) 공간. 정렬이면 O(n log n)과 O(n).",
          "喺大細 k 嘅 heap 做 n 次 push 同 pop：O(n log k) 時間，O(k) 空間。排序就係 O(n log n) 同 O(n)。"
        ),
      },
      {
        topic = "PEEK",
        q = L(
          "After the loop the heap holds the k biggest and the smallest of them is on top: the kth largest. Which method reads the top without removing it?",
          "루프 뒤 힙엔 가장 큰 k개가 있고 그중 제일 작은 게 맨 위: k번째 큰 수. 제거하지 않고 맨 위를 읽는 메서드는?",
          "loop 完之後 heap 入面係最大嘅 k 個，最細嗰個喺頂：即係第 k 大。邊個 method 唔移走都讀到個頂？"
        ),
        code = L(
          [[
// k items left; the top is the smallest of the k biggest
let Reverse(kth) = *heap.___().unwrap();
kth
// kth_largest(&[3, 2, 1, 5, 6, 4], 2) == 5
]],
          [[
// k개 남음; 맨 위는 그중 제일 작은 것
let Reverse(kth) = *heap.___().unwrap();
kth
// kth_largest(&[3, 2, 1, 5, 6, 4], 2) == 5
]],
          [[
// 剩低 k 個；個頂係最大 k 個之中最細嗰個
let Reverse(kth) = *heap.___().unwrap();
kth
// kth_largest(&[3, 2, 1, 5, 6, 4], 2) == 5
]]
        ),
        answer = "peek",
        accept = { "peek", "peek()" },
        hint = L(
          "Four letters: a look at the top. Returns Option<&T>, hence the * and the unwrap.",
          "네 글자: 맨 위를 들여다보기. Option<&T>를 돌려주니 *와 unwrap이 붙는다.",
          "四個字母：望一望個頂。回傳 Option<&T>，所以有 * 同 unwrap。"
        ),
        ok = L(
          "let Reverse(kth) = ... destructures the wrapper in the pattern. peek is O(1).",
          "let Reverse(kth) = ...는 패턴에서 래퍼를 풀어낸다. peek는 O(1).",
          "let Reverse(kth) = ... 喺 pattern 度拆開個 wrapper。peek 係 O(1)。"
        ),
      },
      {
        topic = "COUNT",
        q = L(
          "Top k frequent dishes: count first. Which HashMap method gives a slot for w, creating it with 0 if new?",
          "최빈 상위 k 요리: 먼저 센다. w의 자리를 주고 없으면 0으로 만드는 HashMap 메서드는?",
          "最多人叫嘅頭 k 道菜：先數。邊個 HashMap method 畀個位 w，冇就用 0 開一個？"
        ),
        code = L(
          [[
// count every dish name once per receipt
let mut cnt: HashMap<&str, usize> = HashMap::new();
for w in words {
    *cnt.___(w).or_insert(0) += 1;
}
]],
          [[
// 영수증마다 요리 이름을 하나씩 센다
let mut cnt: HashMap<&str, usize> = HashMap::new();
for w in words {
    *cnt.___(w).or_insert(0) += 1;
}
]],
          [[
// 每張收據數一次每個菜名
let mut cnt: HashMap<&str, usize> = HashMap::new();
for w in words {
    *cnt.___(w).or_insert(0) += 1;
}
]]
        ),
        answer = "entry",
        accept = { "entry", "entry()" },
        hint = L(
          "Five letters: the Entry API. One lookup for both the check and the insert.",
          "다섯 글자: Entry API. 검사와 삽입을 조회 한 번으로.",
          "五個字母：Entry API。檢查同插入淨係查一次。"
        ),
        ok = L(
          "or_insert returns &mut usize, so the * dereferences and += 1 bumps it in place. O(n) to count.",
          "or_insert가 &mut usize를 돌려주니 *로 역참조하고 += 1로 제자리에서 올린다. 세는 데 O(n).",
          "or_insert 回傳 &mut usize，所以 * 解引用，+= 1 就地加一。數嘢 O(n)。"
        ),
      },
      {
        topic = "TOPK",
        q = L(
          "Build a max-heap of (count, word) straight from the map's iterator. Which method turns an iterator into a collection?",
          "맵의 이터레이터에서 바로 (count, word)의 최대 힙을 만든다. 이터레이터를 컬렉션으로 바꾸는 메서드는?",
          "由 map 嘅 iterator 直接砌一個 (count, word) 嘅 max-heap。邊個 method 將 iterator 變做 collection？"
        ),
        code = L(
          [[
// a max-heap of (count, word), built straight from the map
let mut heap: BinaryHeap<(usize, &str)> =
    cnt.into_iter().map(|(w, c)| (c, w)).___();
// k pops: most frequent first, tuples compare by count
for _ in 0..k {
    if let Some((c, w)) = heap.pop() { print!("{w} "); }
}
]],
          [[
// (count, word)의 최대 힙, 맵에서 바로 만든다
let mut heap: BinaryHeap<(usize, &str)> =
    cnt.into_iter().map(|(w, c)| (c, w)).___();
// k번 pop: 많은 것부터, 튜플은 count로 비교
for _ in 0..k {
    if let Some((c, w)) = heap.pop() { print!("{w} "); }
}
]],
          [[
// (count, word) 嘅 max-heap，直接由 map 砌出嚟
let mut heap: BinaryHeap<(usize, &str)> =
    cnt.into_iter().map(|(w, c)| (c, w)).___();
// pop k 次：最多嗰個先，tuple 按 count 比較
for _ in 0..k {
    if let Some((c, w)) = heap.pop() { print!("{w} "); }
}
]]
        ),
        answer = "collect",
        accept = { "collect", "collect()" },
        hint = L(
          "Seven letters, the end of almost every iterator chain. The type annotation on the left tells it what to build.",
          "일곱 글자, 거의 모든 이터레이터 체인의 끝. 왼쪽의 타입 표기가 무엇을 만들지 알려준다.",
          "七個字母，差唔多每條 iterator chain 嘅結尾。左邊個 type annotation 話佢知砌乜。"
        ),
        ok = L(
          "BinaryHeap implements FromIterator, so collect heapifies in O(n). Then k pops: O(n + k log n).",
          "BinaryHeap은 FromIterator를 구현하므로 collect가 O(n)에 힙을 만든다. 그다음 k번 pop: O(n + k log n).",
          "BinaryHeap 實作咗 FromIterator，所以 collect O(n) 就砌好個 heap。再 pop k 次：O(n + k log n)。"
        ),
      },
    },
  },
  {
    id = "rs_interval",
    station = "INTERVAL",
    name = L("ROUND 5  -  the shifts", "라운드 5  -  근무표", "第五回合  -  更表"),
    title = L("Merge intervals", "구간 병합", "合併區間"),
    lesson = L(
      "Sort by start, then walk once: if the next interval starts before the last merged one ends, extend that end to the larger; otherwise push a new interval. O(n log n) for the sort, O(n) for the walk.",
      "시작으로 정렬한 뒤 한 번 걷기: 다음 구간이 마지막으로 합친 구간이 끝나기 전에 시작하면 그 끝을 더 큰 쪽으로 늘리고, 아니면 새 구간을 push. 정렬 O(n log n), 걷기 O(n).",
      "按開始排序，然後行一次：下一個區間喺上一個合併咗嘅完之前開始，就將個尾延長到大嗰個；否則 push 一個新區間。排序 O(n log n)，行一次 O(n)。"
    ),
    bg = "bg_lab",
    portrait = "portrait_clerk",
    speaker = L("Siu Ming", "시우밍", "小明"),
    ground = 348,
    spawn = 180,
    width = 1600,
    npcs = {
      {
        kind = "cook",
        x = 560,
        facing = -1,
        line = L(
          "Everyone's shifts overlap. Six to ten, nine to two, one to four. When is the kitchen actually staffed?",
          "다들 근무 시간이 겹쳐. 6시부터 10시, 9시부터 2시, 1시부터 4시. 주방에 실제로 사람이 있는 건 언제야?",
          "個個嘅更都重疊。六點到十點、九點到兩點、一點到四點。廚房其實幾時有人？"
        ),
      },
      {
        kind = "clerk",
        x = 900,
        facing = -1,
        line = L(
          "Round five. Merge the intervals, Mei. Sort first; the interviewer always waits for that word.",
          "5라운드. 구간을 합치세요, 메이. 정렬부터; 면접관은 늘 그 단어를 기다려요.",
          "第五回合。合併啲區間，阿美。先排序；面試官永遠等緊呢個字。"
        ),
      },
    },
    viz = "rust",
    chips = {
      { "iv.sort_by_key(|x| x.0)", "cyan" },
      { "out.last_mut()", "gold" },
      { "cur.0 <= last.1", "pink" },
      { "last.1.max(cur.1)", "green" },
    },
    note = "sort by start  last_mut  <=  max  push",
    story = L(
      "21:00. The cook's shift sheet goes up on the board: a dozen (start, end) pairs, out of order, overlapping. "
        .. "When is the kitchen covered, and where are the gaps? Sort by start, keep the last merged shift in view, "
        .. "and each new one either stretches it or starts a fresh block.",
      "21:00. 요리사의 근무표가 보드에 붙는다: 순서도 없고 겹치는 (시작, 끝) 쌍 열두어 개. "
        .. "주방은 언제 커버되고 빈틈은 어디인가? 시작으로 정렬하고 마지막으로 합친 근무를 보면서, "
        .. "새 근무마다 그걸 늘리거나 새 블록을 시작한다.",
      "九點正。廚師嘅更表貼上白板：十幾對 (開始, 結束)，冇次序，又重疊。"
        .. "廚房幾時有人 cover，邊度有窿？按開始排序，望住上一個合併咗嘅更，"
        .. "每個新嘅一係拉長佢，一係開一個新 block。"
    ),
    stages = {
      {
        topic = "SORT",
        q = L(
          "Overlaps are only neighbours once the intervals are ordered by start. Which Vec method sorts by a key closure?",
          "구간을 시작으로 정렬해야 겹치는 것들이 이웃이 된다. 키 클로저로 정렬하는 Vec 메서드는?",
          "區間按開始排好序之後，重疊嘅先會係鄰居。邊個 Vec method 用 key closure 排序？"
        ),
        code = L(
          [[
fn merge(mut iv: Vec<(i32, i32)>) -> Vec<(i32, i32)> {
    // by start: every overlap is now next to its partner
    iv.___(|x| x.0);
    let mut out: Vec<(i32, i32)> = Vec::new();
]],
          [[
fn merge(mut iv: Vec<(i32, i32)>) -> Vec<(i32, i32)> {
    // 시작으로: 겹치는 것은 모두 짝 옆에
    iv.___(|x| x.0);
    let mut out: Vec<(i32, i32)> = Vec::new();
]],
          [[
fn merge(mut iv: Vec<(i32, i32)>) -> Vec<(i32, i32)> {
    // 按開始：每個重疊而家都喺佢拍檔隔籬
    iv.___(|x| x.0);
    let mut out: Vec<(i32, i32)> = Vec::new();
]]
        ),
        answer = "sort_by_key",
        accept = { "sort_by_key", "sort_by_key()", "sort_unstable_by_key" },
        hint = L(
          "Three words with underscores: sort, by, and the thing the closure returns.",
          "밑줄로 이은 세 단어: sort, by, 그리고 클로저가 돌려주는 것.",
          "三個字用底線連住：sort、by，同埋 closure 回傳嘅嗰樣嘢。"
        ),
        ok = L(
          "O(n log n), and it dominates: the merge walk after it is O(n). mut iv lets the function sort in place.",
          "O(n log n)이고 이것이 지배적: 뒤의 병합 걷기는 O(n). mut iv 덕에 함수가 제자리 정렬한다.",
          "O(n log n)，而且係主要成本：之後行一次合併係 O(n)。mut iv 令 function 可以就地排序。"
        ),
      },
      {
        topic = "LAST",
        q = L(
          "Each interval is compared with the last merged one, which may need to grow. Which method borrows the last element mutably as Option?",
          "각 구간은 마지막으로 합친 구간과 비교되고, 그것은 늘어날 수도 있다. 마지막 원소를 Option으로 가변 대여하는 메서드는?",
          "每個區間都同上一個合併咗嘅比較，而嗰個可能要長大。邊個 method 以 Option 可變借用最後一個元素？"
        ),
        code = L(
          [[
    for cur in iv {
        // the newest merged block, editable in place
        match out.___() {
            Some(last) if cur.0 <= last.1 => {
                last.1 = last.1.max(cur.1)
            }
            _ => out.push(cur),
]],
          [[
    for cur in iv {
        // 최근에 합친 블록, 제자리 수정
        match out.___() {
            Some(last) if cur.0 <= last.1 => {
                last.1 = last.1.max(cur.1)
            }
            _ => out.push(cur),
]],
          [[
    for cur in iv {
        // 最新合併咗嘅 block，可以就地改
        match out.___() {
            Some(last) if cur.0 <= last.1 => {
                last.1 = last.1.max(cur.1)
            }
            _ => out.push(cur),
]]
        ),
        answer = "last_mut",
        accept = { "last_mut", "last_mut()" },
        hint = L(
          "Like last(), with the suffix every mutable borrow in std carries.",
          "last()와 같지만 std의 모든 가변 대여가 붙이는 접미사가 붙는다.",
          "同 last() 一樣，加埋 std 入面每個可變借用都有嘅後綴。"
        ),
        ok = L(
          "None on an empty out falls to the _ arm and pushes. The borrow ends with the match, so out.push is allowed there.",
          "out이 비어 None이면 _ 가지로 떨어져 push. 대여는 match와 함께 끝나서 거기서 out.push가 허용된다.",
          "out 空嘅時候係 None，跌落 _ 嗰支，就 push。借用隨 match 結束，所以嗰度可以 out.push。"
        ),
      },
      {
        topic = "OVERLAP",
        q = L(
          "Overlap: the current interval starts no later than the last one ends. (1,3) and (3,5) touch and should merge. Which comparison?",
          "겹침: 현재 구간이 마지막 구간이 끝나는 것보다 늦지 않게 시작. (1,3)과 (3,5)는 맞닿아 합쳐져야 한다. 어떤 비교?",
          "重疊：而家個區間開始得唔遲過上一個結束。(1,3) 同 (3,5) 掂到，應該合併。用邊個比較？"
        ),
        code = L(
          [[
    for cur in iv {
        match out.last_mut() {
            // starts before (or as) the last one ends
            Some(last) if cur.0 ___ last.1 => {
                last.1 = last.1.max(cur.1)
            }
            _ => out.push(cur),
]],
          [[
    for cur in iv {
        match out.last_mut() {
            // 마지막 것이 끝나기 전 (또는 동시) 시작
            Some(last) if cur.0 ___ last.1 => {
                last.1 = last.1.max(cur.1)
            }
            _ => out.push(cur),
]],
          [[
    for cur in iv {
        match out.last_mut() {
            // 上一個結束之前（或者嗰刻）開始
            Some(last) if cur.0 ___ last.1 => {
                last.1 = last.1.max(cur.1)
            }
            _ => out.push(cur),
]]
        ),
        answer = "<=",
        accept = { "<=" },
        hint = L(
          "Less than or equal: the equal case is the touching pair.",
          "작거나 같다: 같은 경우가 맞닿은 쌍.",
          "細過或者等於：等於嗰個情況就係掂到嘅一對。"
        ),
        ok = L(
          "A match guard does the test. With < instead, (1,3) and (3,5) would stay apart; ask the interviewer which they want.",
          "match 가드가 검사한다. <였다면 (1,3)과 (3,5)는 따로 남는다; 면접관에게 어느 쪽을 원하는지 물어라.",
          "match guard 做呢個檢查。用 < 嘅話 (1,3) 同 (3,5) 會分開；問吓面試官想要邊種。"
        ),
      },
      {
        topic = "EXTEND",
        q = L(
          "They overlap: the merged block ends at the later of the two ends. Which method picks the larger end?",
          "겹친다: 합친 블록은 두 끝 중 더 늦은 곳에서 끝난다. 더 큰 끝을 고르는 메서드는?",
          "佢哋重疊：合併咗嘅 block 喺兩個尾之中遲嗰個結束。邊個 method 揀大嗰個尾？"
        ),
        code = L(
          [[
            // (1,6) then (2,4): the end stays 6, not 4
            Some(last) if cur.0 <= last.1 => {
                last.1 = last.1.___(cur.1)
            }
]],
          [[
            // (1,6) 다음 (2,4): 끝은 6 그대로
            Some(last) if cur.0 <= last.1 => {
                last.1 = last.1.___(cur.1)
            }
]],
          [[
            // (1,6) 之後 (2,4)：個尾 keep 住 6
            Some(last) if cur.0 <= last.1 => {
                last.1 = last.1.___(cur.1)
            }
]]
        ),
        answer = "max",
        accept = { "max", "max()" },
        hint = L(
          "Three letters from Ord. A plain assignment of cur.1 would shrink a block that already reached further.",
          "Ord의 세 글자. cur.1을 그냥 대입하면 이미 더 멀리 간 블록이 줄어든다.",
          "Ord 嘅三個字母。直接賦值 cur.1 會縮短一個已經去得更遠嘅 block。"
        ),
        ok = L(
          "The classic bug is forgetting max: a short interval inside a long one must not cut it. last is &mut, so this writes into out.",
          "고전적 버그는 max를 잊는 것: 긴 구간 안의 짧은 구간이 그것을 잘라선 안 된다. last가 &mut이라 이건 out에 쓰인다.",
          "經典 bug 就係唔記得 max：長區間入面嘅短區間唔可以斬短佢。last 係 &mut，所以呢句直接寫入 out。"
        ),
      },
      {
        topic = "PUSH",
        q = L(
          "No overlap, or out is still empty: the current interval starts a new block. Which Vec method appends it?",
          "겹치지 않거나 out이 아직 비었다: 현재 구간이 새 블록을 시작. 덧붙이는 Vec 메서드는?",
          "冇重疊，或者 out 仲係空：而家個區間開一個新 block。邊個 Vec method 加佢落去？"
        ),
        code = L(
          [[
            _ => out.___(cur),      // a gap: new block
        }
    }
    out
}
// merge(vec![(9,14), (6,10), (13,16), (18,20)])
//   == [(6,16), (18,20)]
]],
          [[
            _ => out.___(cur),      // 빈틈: 새 블록
        }
    }
    out
}
// merge(vec![(9,14), (6,10), (13,16), (18,20)])
//   == [(6,16), (18,20)]
]],
          [[
            _ => out.___(cur),      // 有窿：新 block
        }
    }
    out
}
// merge(vec![(9,14), (6,10), (13,16), (18,20)])
//   == [(6,16), (18,20)]
]]
        ),
        answer = "push",
        accept = { "push", "push()" },
        hint = L(
          "Four letters, the append of every Vec.",
          "네 글자, 모든 Vec의 덧붙이기.",
          "四個字母，每個 Vec 嘅加嘢方法。"
        ),
        ok = L(
          "Sort, then one pass with a running last: O(n log n) total, O(n) output. The gaps are between the blocks.",
          "정렬 후 마지막 블록을 들고 한 번 훑기: 총 O(n log n), 출력 O(n). 빈틈은 블록 사이에 있다.",
          "排序，然後拎住上一個 block 行一次：總共 O(n log n)，輸出 O(n)。啲窿就喺 block 同 block 之間。"
        ),
      },
    },
  },
  {
    id = "rs_lru",
    station = "LRU",
    name = L("ROUND 6  -  the cache", "라운드 6  -  캐시", "第六回合  -  cache"),
    title = L("An LRU cache", "LRU 캐시", "LRU cache"),
    lesson = L(
      "LRU: a HashMap for the values and a VecDeque for recency, fresh at the back, stale at the front. get moves the key to the back. put evicts the front when full, then inserts. The O(1) version swaps the VecDeque for a linked list.",
      "LRU: 값은 HashMap, 최근 순서는 VecDeque, 최신은 뒤, 오래된 건 앞. get은 키를 뒤로 옮긴다. put은 가득 차면 앞을 내보내고 넣는다. O(1) 버전은 VecDeque를 연결 리스트로 바꾼다.",
      "LRU：值放 HashMap，新舊次序放 VecDeque，新嘅喺後面，舊嘅喺前面。get 將個 key 移去後面。put 滿咗就趕走前面嗰個，再放入去。O(1) 版本將 VecDeque 換做 linked list。"
    ),
    bg = "bg_lab",
    portrait = "portrait_friends",
    speaker = L("Mei", "메이", "阿美"),
    ground = 348,
    spawn = 180,
    width = 1600,
    npcs = {
      {
        kind = "clerk",
        x = 560,
        facing = -1,
        line = L(
          "Round six. The menu API caches the last hundred dishes. Which one goes when the hundred-and-first arrives?",
          "6라운드. 메뉴 API는 최근 요리 백 개를 캐시해요. 백한 번째가 오면 어느 것이 나가죠?",
          "第六回合。餐牌 API cache 住最近一百道菜。第一百零一道嚟到，邊道要走？"
        ),
      },
      {
        kind = "hero",
        x = 900,
        facing = -1,
        line = L(
          "Least recently used. A map for the values and a queue for the order; every get is a touch.",
          "가장 오래 안 쓴 것. 값은 맵, 순서는 큐; get 할 때마다 건드리는 거야.",
          "最耐冇用嗰個。值用 map，次序用 queue；每次 get 都係摸一摸佢。"
        ),
      },
    },
    viz = "rust",
    chips = {
      { "HashMap<u32, String>", "cyan" },
      { "order: VecDeque<u32>", "gold" },
      { "order.pop_front()", "pink" },
      { "order.push_back(k)", "green" },
    },
    note = "get: touch  put: evict front, insert, push back",
    story = L(
      "21:08. The one every backend interview ends with: a cache with a capacity, where the least recently used entry "
        .. "makes room for the new one. Mei keeps it honest: a HashMap for the values, a VecDeque for the order, "
        .. "and a note on the board that the linked-list version makes every step O(1).",
      "21:08. 모든 백엔드 면접이 끝에 내는 문제: 용량이 있는 캐시, 가장 오래 안 쓴 항목이 새것에 자리를 내준다. "
        .. "메이는 정직하게 간다: 값은 HashMap, 순서는 VecDeque, "
        .. "그리고 연결 리스트 버전이면 모든 단계가 O(1)이라는 메모를 보드에.",
      "九點零八分。每個 backend 面試最後都會出嘅一題：一個有容量嘅 cache，最耐冇用嘅一項要讓位畀新嘅。"
        .. "阿美老老實實：值放 HashMap，次序放 VecDeque，"
        .. "再喺白板寫一句：linked list 版本每一步都係 O(1)。"
    ),
    stages = {
      {
        topic = "TOUCH",
        q = L(
          "get: the key was used just now, so it moves to the back of the order. First find its index. Which iterator method returns the index of the first match?",
          "get: 방금 쓴 키이니 순서의 뒤로 옮긴다. 먼저 인덱스를 찾는다. 첫 일치의 인덱스를 돌려주는 이터레이터 메서드는?",
          "get：個 key 啱啱用過，所以移去次序嘅後面。先搵佢個 index。邊個 iterator method 回傳第一個符合嘅 index？"
        ),
        code = L(
          [[
fn get(&mut self, k: u32) -> Option<&String> {
    // used just now: move k to the back, the fresh end
    if let Some(i) = self.order.iter().___(|&&x| x == k) {
        self.order.remove(i);
        self.order.push_back(k);
    }
    self.map.get(&k)
]],
          [[
fn get(&mut self, k: u32) -> Option<&String> {
    // 방금 사용: k를 뒤, 최신 쪽으로
    if let Some(i) = self.order.iter().___(|&&x| x == k) {
        self.order.remove(i);
        self.order.push_back(k);
    }
    self.map.get(&k)
]],
          [[
fn get(&mut self, k: u32) -> Option<&String> {
    // 啱啱用過：將 k 移去後面，新嘅嗰邊
    if let Some(i) = self.order.iter().___(|&&x| x == k) {
        self.order.remove(i);
        self.order.push_back(k);
    }
    self.map.get(&k)
]]
        ),
        answer = "position",
        accept = { "position", "position()" },
        hint = L(
          "Eight letters: like find, but it gives you where, not what. Option<usize>.",
          "여덟 글자: find와 비슷하지만 무엇이 아니라 어디를 준다. Option<usize>.",
          "八個字母：似 find，不過畀你嘅係喺邊，唔係係乜。Option<usize>。"
        ),
        ok = L(
          "This scan is O(n): the honest cost of a VecDeque order. A doubly linked list with map-held nodes makes it O(1).",
          "이 탐색은 O(n): VecDeque 순서의 정직한 비용. 맵이 노드를 쥔 이중 연결 리스트면 O(1).",
          "呢個掃描係 O(n)：VecDeque 次序嘅老實成本。map 揸住 node 嘅雙向 linked list 就係 O(1)。"
        ),
      },
      {
        topic = "FRESH",
        q = L(
          "Found and removed from its old spot: now k goes to the fresh end. Which VecDeque method appends at the back?",
          "찾아서 옛 자리에서 뺐다: 이제 k는 최신 쪽 끝으로. 뒤에 덧붙이는 VecDeque 메서드는?",
          "搵到，由舊位置移走咗：而家 k 去新嘅嗰邊。邊個 VecDeque method 喺後面加？"
        ),
        code = L(
          [[
    let at = self.order.iter().position(|&&x| x == k);
    if let Some(i) = at {
        self.order.remove(i);
        // the back is fresh, the front is stale
        self.order.___(k);
    }
    self.map.get(&k)
]],
          [[
    let at = self.order.iter().position(|&&x| x == k);
    if let Some(i) = at {
        self.order.remove(i);
        // 뒤는 최신 쪽 끝, 앞은 오래된 쪽
        self.order.___(k);
    }
    self.map.get(&k)
]],
          [[
    let at = self.order.iter().position(|&&x| x == k);
    if let Some(i) = at {
        self.order.remove(i);
        // 後面係新嘅嗰邊，前面係舊嘅嗰邊
        self.order.___(k);
    }
    self.map.get(&k)
]]
        ),
        answer = "push_back",
        accept = { "push_back", "push_back()" },
        hint = L(
          "push, underscore, the end that is not the front.",
          "push, 밑줄, 앞이 아닌 쪽 끝.",
          "push、底線、唔係 front 嗰邊。"
        ),
        ok = L(
          "A VecDeque grows at both ends in O(1). The stale end is the front, so eviction is a pop from there.",
          "VecDeque는 양끝에서 O(1)로 자란다. 오래된 쪽이 앞이라 내보내기는 거기서 pop.",
          "VecDeque 兩邊都 O(1) 加嘢。舊嘅嗰邊係前面，所以趕走就係由前面 pop。"
        ),
      },
      {
        topic = "EVICT",
        q = L(
          "put on a new key when the cache is full: the stale end goes first. Which VecDeque method removes the front as Option?",
          "캐시가 가득 찼을 때 새 키를 put: 오래된 쪽 끝이 먼저 나간다. 앞을 Option으로 제거하는 VecDeque 메서드는?",
          "cache 滿咗，put 一個新 key：舊嘅嗰邊先走。邊個 VecDeque method 以 Option 移走前面？"
        ),
        code = L(
          [[
fn put(&mut self, k: u32, v: String) {
    if self.map.contains_key(&k) { self.get(k); }
    else if self.map.len() == self.cap {
        // full: the least recently used is at the front
        if let Some(old) = self.order.___() {
            self.map.remove(&old);
        }
]],
          [[
fn put(&mut self, k: u32, v: String) {
    if self.map.contains_key(&k) { self.get(k); }
    else if self.map.len() == self.cap {
        // 가득 참: 가장 오래된 것이 앞에
        if let Some(old) = self.order.___() {
            self.map.remove(&old);
        }
]],
          [[
fn put(&mut self, k: u32, v: String) {
    if self.map.contains_key(&k) { self.get(k); }
    else if self.map.len() == self.cap {
        // 滿咗：最耐冇用嗰個喺前面
        if let Some(old) = self.order.___() {
            self.map.remove(&old);
        }
]]
        ),
        answer = "pop_front",
        accept = { "pop_front", "pop_front()" },
        hint = L(
          "pop, underscore, the stale end. The mirror of the last blank.",
          "pop, 밑줄, 오래된 쪽 끝. 앞 빈칸의 거울.",
          "pop、底線、舊嘅嗰邊。上一個空格嘅鏡像。"
        ),
        ok = L(
          "An existing key is a touch, not an eviction: get(k) moves it to the back and the len check is skipped.",
          "이미 있는 키는 내보내기가 아닌 건드리기: get(k)가 뒤로 옮기고 len 검사는 건너뛴다.",
          "已經有嘅 key 係摸一摸，唔係趕走：get(k) 將佢移去後面，len 檢查就跳過。"
        ),
      },
      {
        topic = "FORGET",
        q = L(
          "The evicted key must leave the map too, or the cache leaks. Which HashMap method deletes by key?",
          "내보낸 키는 맵에서도 나가야 한다, 아니면 캐시가 샌다. 키로 삭제하는 HashMap 메서드는?",
          "趕走咗嘅 key 都要離開個 map，否則 cache 會漏。邊個 HashMap method 按 key 刪除？"
        ),
        code = L(
          [[
    else if self.map.len() == self.cap {
        if let Some(old) = self.order.pop_front() {
            // both structures must agree on what is inside
            self.map.___(&old);
        }
    }
]],
          [[
    else if self.map.len() == self.cap {
        if let Some(old) = self.order.pop_front() {
            // 두 구조의 내용은 일치해야 한다
            self.map.___(&old);
        }
    }
]],
          [[
    else if self.map.len() == self.cap {
        if let Some(old) = self.order.pop_front() {
            // 兩個結構要一致，入面有乜要一樣
            self.map.___(&old);
        }
    }
]]
        ),
        answer = "remove",
        accept = { "remove", "remove()" },
        hint = L(
          "Six letters, takes a reference to the key, returns the old value as Option.",
          "여섯 글자, 키의 참조를 받고 옛 값을 Option으로 돌려준다.",
          "六個字母，接收 key 嘅 reference，以 Option 回傳舊值。"
        ),
        ok = L(
          "The invariant: map.len() == order.len(), always. Break it once and the cap check lies.",
          "불변식: 항상 map.len() == order.len(). 한 번 깨지면 cap 검사가 거짓말한다.",
          "不變條件：永遠 map.len() == order.len()。破一次，cap 檢查就講大話。"
        ),
      },
      {
        topic = "STORE",
        q = L(
          "Room made: store the value. Which HashMap method writes k to v, replacing an old value if there was one?",
          "자리 확보: 값을 저장. k에 v를 쓰고 옛 값이 있으면 바꾸는 HashMap 메서드는?",
          "有位喇：存個值。邊個 HashMap method 將 k 寫做 v，有舊值就換走？"
        ),
        code = L(
          [[
    // a new key joins the fresh end
    if !self.map.contains_key(&k) {
        self.order.push_back(k);
    }
    self.map.___(k, v);
}
// cap 2: put(1) put(2) get(1) put(3)  ->  2 is evicted
]],
          [[
    // 새 키는 최신 쪽 끝으로
    if !self.map.contains_key(&k) {
        self.order.push_back(k);
    }
    self.map.___(k, v);
}
// cap 2: put(1) put(2) get(1) put(3)  ->  2가 나간다
]],
          [[
    // 新 key 加入新嘅嗰邊
    if !self.map.contains_key(&k) {
        self.order.push_back(k);
    }
    self.map.___(k, v);
}
// cap 2: put(1) put(2) get(1) put(3)  ->  2 被趕走
]]
        ),
        answer = "insert",
        accept = { "insert", "insert()" },
        hint = L(
          "Six letters, the write of every HashMap. Returns the previous value as Option.",
          "여섯 글자, 모든 HashMap의 쓰기. 이전 값을 Option으로 돌려준다.",
          "六個字母，每個 HashMap 嘅寫入。以 Option 回傳之前嘅值。"
        ),
        ok = L(
          "get(1) made 1 fresh, so put(3) evicts 2. That trace is the whole interview: touch on read, evict the front on write.",
          "get(1)이 1을 최신으로 만들어 put(3)은 2를 내보낸다. 그 흐름이 면접의 전부: 읽으면 건드리고, 쓰면 앞을 내보낸다.",
          "get(1) 令 1 變新，所以 put(3) 趕走 2。呢條 trace 就係成個面試：讀就摸一摸，寫就趕走前面。"
        ),
      },
    },
  },
  {
    id = "rs_grid",
    station = "GRID",
    name = L("FINAL  -  the islands", "파이널  -  섬", "決賽  -  島"),
    title = L("Number of islands: DFS on a grid", "섬의 개수: 격자 위 DFS", "數島：grid 上嘅 DFS"),
    lesson = L(
      "A grid is a graph without an adjacency list. Count islands: for every land cell, count one and sink the whole island with a recursive flood that stops at the edges and at water. usize needs wrapping_sub for 'row minus one'.",
      "격자는 인접 리스트 없는 그래프. 섬 세기: 땅 칸마다 하나 세고, 가장자리와 물에서 멈추는 재귀 플러드로 섬 전체를 가라앉힌다. usize에선 '행 빼기 1'에 wrapping_sub가 필요하다.",
      "grid 係冇 adjacency list 嘅 graph。數島：每個陸地格數一個，再用遞歸 flood 沉晒成個島，去到邊同水就停。usize 要用 wrapping_sub 做「行減一」。"
    ),
    bg = "bg_times",
    portrait = "portrait_clerk",
    speaker = L("Siu Ming", "시우밍", "小明"),
    ground = 348,
    spawn = 180,
    width = 1600,
    npcs = {
      {
        kind = "clerk",
        x = 560,
        facing = -1,
        line = L(
          "Final question. A map of the harbour, ones for land, zeros for water. How many islands? Get this and the offer is yours.",
          "마지막 문제. 항구의 지도, 땅은 1, 물은 0. 섬은 몇 개? 맞히면 오퍼는 당신 거예요.",
          "最後一題。個海港嘅地圖，1 係陸地，0 係水。有幾多個島？答到，offer 就係你嘅。"
        ),
      },
      {
        kind = "hero",
        x = 900,
        facing = -1,
        line = L(
          "It's DFS, Mei, same as the MTR round, but the neighbours are up, down, left, right. Mind the usize!",
          "DFS야, 메이, MTR 라운드랑 같아. 다만 이웃이 위, 아래, 왼쪽, 오른쪽. usize 조심!",
          "係 DFS 呀阿美，同 MTR 嗰回合一樣，不過鄰居係上下左右。小心 usize！"
        ),
      },
    },
    viz = "rust",
    chips = {
      { "g: &mut Vec<Vec<u8>>", "cyan" },
      { "r >= g.len()", "gold" },
      { "g[r][c] = b'0'", "pink" },
      { "r.wrapping_sub(1)", "green" },
    },
    note = "bounds  water  sink  four neighbours  count",
    story = L(
      "21:15. The last board: Victoria Harbour as a grid of ones and zeros. How many islands? Mei writes sink: "
        .. "stop at the edge, stop at water, turn this cell to water, flood the four neighbours. "
        .. "Count one per unsunk land cell. Siu Ming caps the marker. The screen outside lights up: OFFER.",
      "21:15. 마지막 보드: 1과 0의 격자로 그린 빅토리아 항. 섬은 몇 개? 메이가 sink를 쓴다: "
        .. "가장자리에서 멈추고, 물에서 멈추고, 이 칸을 물로 바꾸고, 이웃 넷을 플러드. "
        .. "가라앉지 않은 땅 칸마다 하나씩 센다. 시우밍이 마커 뚜껑을 닫는다. 밖의 전광판이 켜진다: OFFER.",
      "九點十五分。最後一塊板：維多利亞港畫成 1 同 0 嘅 grid。有幾多個島？阿美寫 sink："
        .. "去到邊就停，遇到水就停，將呢格變做水，再 flood 四個鄰居。"
        .. "每個未沉嘅陸地格數一個。小明蓋返支筆。出面個大螢幕亮起：OFFER。"
    ),
    stages = {
      {
        topic = "BOUNDS",
        q = L(
          "sink stops off the map. usize never goes below zero, so only the far edges need a test. Row r is outside when r is what, compared with the row count?",
          "sink는 지도 밖에서 멈춘다. usize는 0 아래로 못 가니 먼 가장자리만 검사하면 된다. 행 r이 밖인 것은 행 수와 비교해 r이 어떨 때?",
          "sink 出咗地圖就停。usize 唔會低過零，所以淨係要檢查遠嗰邊。行 r 同行數比較，點樣先算出界？"
        ),
        code = L(
          [[
fn sink(g: &mut Vec<Vec<u8>>, r: usize, c: usize) {
    // off the map: index equal to len is already outside
    if r ___ g.len() || c >= g[0].len() {
        return;
    }
]],
          [[
fn sink(g: &mut Vec<Vec<u8>>, r: usize, c: usize) {
    // 지도 밖: 인덱스가 len이면 이미 밖
    if r ___ g.len() || c >= g[0].len() {
        return;
    }
]],
          [[
fn sink(g: &mut Vec<Vec<u8>>, r: usize, c: usize) {
    // 出咗地圖：index 等於 len 已經係出界
    if r ___ g.len() || c >= g[0].len() {
        return;
    }
]]
        ),
        answer = ">=",
        accept = { ">=" },
        hint = L(
          "Greater than or equal. With > alone, g[g.len()] would panic.",
          "크거나 같다. >만 쓰면 g[g.len()]에서 패닉.",
          "大過或者等於。淨係用 > 嘅話，g[g.len()] 會 panic。"
        ),
        ok = L(
          "Rows go 0..len, so len itself is out. The same test on c covers the right edge; the top and left are handled by wrapping.",
          "행은 0..len이라 len 자체는 밖. c에 같은 검사가 오른쪽 끝을 막고, 위와 왼쪽은 wrapping이 처리한다.",
          "行係 0..len，所以 len 本身已經出界。c 用同一個檢查擋住右邊；上面同左邊由 wrapping 處理。"
        ),
      },
      {
        topic = "WATER",
        q = L(
          "Water, or land already sunk, ends the flood. The grid holds bytes: which byte literal is land?",
          "물이거나 이미 가라앉은 땅이면 플러드 종료. 격자는 바이트를 담는다: 땅인 바이트 리터럴은?",
          "水，或者已經沉咗嘅陸地，flood 就停。grid 裝住 byte：邊個 byte literal 係陸地？"
        ),
        code = L(
          [[
    if r >= g.len() || c >= g[0].len() {
        return;
    }
    // water, or land this flood already sank
    if g[r][c] != ___ {
        return;
    }
]],
          [[
    if r >= g.len() || c >= g[0].len() {
        return;
    }
    // 물이거나, 이미 가라앉힌 땅
    if g[r][c] != ___ {
        return;
    }
]],
          [[
    if r >= g.len() || c >= g[0].len() {
        return;
    }
    // 水，或者呢次 flood 已經沉咗嘅陸地
    if g[r][c] != ___ {
        return;
    }
]]
        ),
        answer = "b'1'",
        accept = { "b'1'", "b'1", "'1'" },
        hint = L(
          "The digit one as a u8: a b before the single quotes.",
          "u8로 쓴 숫자 1: 작은따옴표 앞에 b.",
          "用 u8 寫嘅數字一：單引號前面加個 b。"
        ),
        ok = L(
          "b'1' is 49u8, the ASCII byte. Vec<Vec<u8>> is what you get from lines of a text map via as_bytes().",
          "b'1'은 ASCII 바이트 49u8. 텍스트 지도의 줄들을 as_bytes()로 읽으면 Vec<Vec<u8>>가 된다.",
          "b'1' 係 ASCII byte 49u8。文字地圖每行用 as_bytes() 就得到 Vec<Vec<u8>>。"
        ),
      },
      {
        topic = "MARK",
        q = L(
          "This cell is land and part of the island. Sink it before flooding onward, so it is never visited twice. What does the cell become?",
          "이 칸은 땅이고 섬의 일부. 계속 퍼지기 전에 가라앉혀 두 번 방문하지 않게. 칸은 무엇이 되나?",
          "呢格係陸地，係個島嘅一部分。再 flood 出去之前先沉咗佢，就唔會行兩次。呢格變做乜？"
        ),
        code = L(
          [[
    if g[r][c] != b'1' {
        return;
    }
    // counted: this land is water from now on
    g[r][c] = ___;
]],
          [[
    if g[r][c] != b'1' {
        return;
    }
    // 세었음: 이 땅은 이제부터 물이다
    g[r][c] = ___;
]],
          [[
    if g[r][c] != b'1' {
        return;
    }
    // 數咗喇：呢塊陸地由而家開始係水
    g[r][c] = ___;
]]
        ),
        answer = "b'0'",
        accept = { "b'0'", "b'0", "'0'" },
        hint = L(
          "The water byte. Same shape as the land literal, other digit.",
          "물 바이트. 땅 리터럴과 같은 모양, 다른 숫자.",
          "水嘅 byte。同陸地 literal 一樣嘅寫法，另一個數字。"
        ),
        ok = L(
          "Marking in place is the visited set: O(1) extra space. Interviewers may ask you not to mutate; then use a HashSet<(usize, usize)>.",
          "제자리 표시가 곧 visited 집합: 추가 공간 O(1). 면접관이 수정 금지를 요구하면 HashSet<(usize, usize)>를 쓴다.",
          "就地標記就係 visited set：額外空間 O(1)。面試官唔畀改嘅話，就用 HashSet<(usize, usize)>。"
        ),
      },
      {
        topic = "FLOOD",
        q = L(
          "Flood the four neighbours. r + 1 is fine, but r - 1 on a usize at row 0 panics in debug. Which method subtracts and wraps to usize::MAX instead?",
          "이웃 넷으로 퍼진다. r + 1은 괜찮지만 0행에서 usize의 r - 1은 디버그에서 패닉. 대신 빼서 usize::MAX로 감싸는 메서드는?",
          "flood 四個鄰居。r + 1 冇問題，但係第 0 行嘅 usize 做 r - 1 喺 debug 會 panic。邊個 method 減咗之後 wrap 去 usize::MAX？"
        ),
        code = L(
          [[
    g[r][c] = b'0';
    // usize has no -1: 0 minus 1 wraps to usize::MAX,
    // and the bounds test at the top rejects that
    sink(g, r + 1, c);
    sink(g, r.___(1), c);
    sink(g, r, c + 1);
    sink(g, r, c.___(1));
]],
          [[
    g[r][c] = b'0';
    // usize엔 -1이 없다: 0 - 1은 usize::MAX,
    // 맨 위의 범위 검사가 그것을 걸러낸다
    sink(g, r + 1, c);
    sink(g, r.___(1), c);
    sink(g, r, c + 1);
    sink(g, r, c.___(1));
]],
          [[
    g[r][c] = b'0';
    // usize 冇 -1：0 減 1 會 wrap 去 usize::MAX，
    // 而最頂嘅邊界檢查會擋走佢
    sink(g, r + 1, c);
    sink(g, r.___(1), c);
    sink(g, r, c + 1);
    sink(g, r, c.___(1));
]]
        ),
        answer = "wrapping_sub",
        accept = { "wrapping_sub", "wrapping_sub()" },
        hint = L(
          "wrapping, underscore, the operation. Its cousins are checked_sub (Option) and saturating_sub (stops at 0).",
          "wrapping, 밑줄, 연산 이름. 사촌으로 checked_sub(Option)와 saturating_sub(0에서 멈춤)가 있다.",
          "wrapping、底線、個運算。佢啲表親係 checked_sub（Option）同 saturating_sub（去到 0 就停）。"
        ),
        ok = L(
          "Four recursive calls, each O(1) plus its own flood: every cell is sunk once, so the whole grid is O(rows * cols).",
          "재귀 호출 넷, 각각 O(1)에 자기 플러드: 모든 칸은 한 번만 가라앉으니 격자 전체가 O(rows * cols).",
          "四個遞歸 call，每個 O(1) 加自己嘅 flood：每格淨係沉一次，所以成個 grid 係 O(rows * cols)。"
        ),
      },
      {
        topic = "COUNT",
        q = L(
          "Walk every cell. Land that is still standing is a new island: count it and sink all of it. Which function does the sinking?",
          "모든 칸을 걷는다. 아직 남아 있는 땅은 새 섬: 세고 전부 가라앉힌다. 가라앉히는 함수는?",
          "行晒每一格。仲企喺度嘅陸地就係新嘅島：數一個，再沉晒佢。邊個 function 負責沉？"
        ),
        code = L(
          [[
let mut n = 0;
for r in 0..g.len() {
    for c in 0..g[0].len() {
        // land still standing: a new island, flood it
        if g[r][c] == b'1' { n += 1; ___(&mut g, r, c); }
    }
}
]],
          [[
let mut n = 0;
for r in 0..g.len() {
    for c in 0..g[0].len() {
        // 아직 남은 땅: 새 섬, 전부 플러드
        if g[r][c] == b'1' { n += 1; ___(&mut g, r, c); }
    }
}
]],
          [[
let mut n = 0;
for r in 0..g.len() {
    for c in 0..g[0].len() {
        // 仲未沉嘅陸地：新嘅島，flood 晒佢
        if g[r][c] == b'1' { n += 1; ___(&mut g, r, c); }
    }
}
]]
        ),
        answer = "sink",
        accept = { "sink", "sink()" },
        hint = L(
          "The recursive flood written above, four letters. Takes &mut g and the cell.",
          "위에 쓴 재귀 플러드, 네 글자. &mut g와 칸을 받는다.",
          "上面寫嘅遞歸 flood，四個字母。接收 &mut g 同個格。"
        ),
        ok = L(
          "Every island is counted exactly once because its cells are water by the time the loop reaches them again. OFFER.",
          "루프가 다시 닿을 때쯤 그 칸들은 물이 되어 있어 모든 섬은 정확히 한 번 세어진다. OFFER.",
          "每個島淨係數一次，因為個 loop 再行到嗰啲格嘅時候，佢哋已經係水。OFFER。"
        ),
      },
    },
  },
}

return maps
