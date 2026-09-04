-- Quest P5 CALLBACK: the second interview, in Python. 01:00, after the
-- midnight CODE RUSH said HIRED, the Times Square startup calls Chef Bo
-- back for the whiteboard round at the back office. Siu Ming asks, Bo
-- writes, Alex and Mei watch from the door, Monty grins from the laptop
-- lid. Seven interview classics; the blanks of one street together form
-- the algorithm. Prize: an OFFER.
-- Same shape as src/data.lua: the blank ___ is NOT written in the code.

local function L(en, ko, yue)
  return { en = en, ko = ko, yue = yue }
end

local maps = {
  {
    id = "py_stack",
    station = "STACK",
    name = L("CALLBACK 1  -  the brackets", "콜백 1  -  괄호", "第二輪 1  -  括號"),
    title = L("Valid parentheses, min stack", "올바른 괄호, 최소 스택", "合法括號、min stack"),
    lesson = L(
      "A list is a stack: append pushes, pop takes the top, st[-1] peeks. Openers go on, closers must match the top. A second list of running minimums makes a min stack.",
      "리스트가 곧 스택: append로 넣고, pop으로 꼭대기를 꺼내고, st[-1]로 엿본다. 여는 괄호는 올리고, 닫는 괄호는 꼭대기와 맞아야 한다. 누적 최솟값 리스트 하나를 더하면 최소 스택.",
      "list 就係 stack：append 推入，pop 攞頂，st[-1] 偷睇。開括號放上去，閉括號要同頂配對。多一個累積最細值嘅 list 就係 min stack。"
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
          "Callback round, Chef. Whiteboard, no keyboard. First: are these brackets balanced?",
          "콜백 라운드예요, 셰프. 화이트보드, 키보드 없음. 첫 문제: 이 괄호들 균형이 맞나요?",
          "第二輪面試，廚師。白板，冇 keyboard。第一題：呢啲括號配唔配對？"
        ),
      },
      {
        kind = "hero",
        x = 900,
        facing = -1,
        line = L(
          "They asked me this one too. A stack, Bo. Every closer looks at the top.",
          "나한테도 이거 물었어. 스택이야, 보. 닫는 괄호는 전부 꼭대기를 봐.",
          "佢哋都問過我呢題。用 stack 呀，寶廚。每個閉括號都望住個頂。"
        ),
      },
    },
    viz = "python",
    chips = {
      { 'pairs = {")": "("}', "cyan" },
      { "st.append(c)", "gold" },
      { "st.pop() != pairs[c]", "pink" },
      { "return not st", "green" },
    },
    note = '"{"  append  pop  -1  not st  min',
    story = L(
      "01:00. The night market is packing up and the startup's back office is still lit. Siu Ming, host by night, "
        .. "interviewer by later night, hands Chef Bo a marker. The Times Square screen said HIRED; the whiteboard decides the offer. "
        .. "Round one: a receipt full of brackets. Are they balanced?",
      "01:00. 야시장은 정리 중이고 스타트업 사무실은 아직 불이 켜져 있다. 밤엔 진행자, 더 늦은 밤엔 면접관인 시우밍이 보 셰프에게 마커를 건넨다. "
        .. "타임스퀘어 전광판은 HIRED라고 했고, 오퍼는 화이트보드가 정한다. 1라운드: 괄호로 가득한 영수증. 균형이 맞는가?",
      "凌晨一點。夜市收緊檔，startup 嘅後勤房仲亮住燈。夜晚做主持、更夜做面試官嘅小明，遞支白板筆畀寶廚。"
        .. "時代廣場個大 mon 話 HIRED；offer 就由白板決定。第一題：一張全係括號嘅收據。配唔配對？"
    ),
    stages = {
      {
        topic = "PAIRS",
        q = L(
          "Every closer knows its opener. Fill the opener that } maps to.",
          "닫는 괄호마다 짝이 있다. }가 가리키는 여는 괄호를 채워라.",
          "每個閉括號都知自己嘅開括號。填 } 對應嘅開括號。"
        ),
        code = L(
          [[
def valid(s):
    pairs = {")": "(", "]": "[", "}": ___}
    st = []
    for c in s:
        if c in "([{":
            st.append(c)
]],
          [[
def valid(s):
    pairs = {")": "(", "]": "[", "}": ___}
    st = []
    for c in s:
        if c in "([{":
            st.append(c)
]],
          [[
def valid(s):
    pairs = {")": "(", "]": "[", "}": ___}
    st = []
    for c in s:
        if c in "([{":
            st.append(c)
]]
        ),
        answer = '"{"',
        accept = { '"{"', "'{'", "{" },
        hint = L(
          "The curly opener, as a one-character string like the other two values.",
          "중괄호 여는 쪽, 다른 두 값처럼 한 글자 문자열로.",
          "大括號開嗰邊，同其餘兩個值一樣係一個字嘅 string。"
        ),
        ok = L(
          "A dict from closer to opener. Looking up a closer is O(1); no chain of ifs.",
          "닫는 괄호에서 여는 괄호로 가는 dict. 닫는 괄호 조회는 O(1); if 사슬이 필요 없다.",
          "由閉括號去開括號嘅 dict。查一個閉括號係 O(1)；唔使一串 if。"
        ),
      },
      {
        topic = "PUSH",
        q = L(
          "An opener waits for its closer on the stack. Which list method puts c on top?",
          "여는 괄호는 스택 위에서 짝을 기다린다. c를 꼭대기에 올리는 리스트 메서드는?",
          "開括號喺 stack 上面等佢嘅閉括號。邊個 list method 將 c 放上頂？"
        ),
        code = L(
          [[
    st = []
    for c in s:
        if c in "([{":
            st.___(c)             # onto the top
        elif not st or st.pop() != pairs[c]:
            return False
]],
          [[
    st = []
    for c in s:
        if c in "([{":
            st.___(c)             # 꼭대기로
        elif not st or st.pop() != pairs[c]:
            return False
]],
          [[
    st = []
    for c in s:
        if c in "([{":
            st.___(c)             # 放上頂
        elif not st or st.pop() != pairs[c]:
            return False
]]
        ),
        answer = "append",
        accept = { "append" },
        hint = L(
          "The list method that grows the end. The end of the list is the top of the stack.",
          "리스트 끝을 늘리는 메서드. 리스트의 끝이 스택의 꼭대기.",
          "令 list 尾變長嘅 method。list 嘅尾就係 stack 嘅頂。"
        ),
        ok = L(
          "append is amortized O(1). Python has no stack class; a list is the stack.",
          "append는 상각 O(1). Python엔 스택 클래스가 없다; 리스트가 스택.",
          "append 係攤分 O(1)。Python 冇 stack class；list 就係 stack。"
        ),
      },
      {
        topic = "POP",
        q = L(
          "A closer must match the most recent opener. Which method removes and returns the top?",
          "닫는 괄호는 가장 최근의 여는 괄호와 맞아야 한다. 꼭대기를 꺼내 반환하는 메서드는?",
          "閉括號要同最近嘅開括號配對。邊個 method 攞走並回傳個頂？"
        ),
        code = L(
          [[
    for c in s:
        if c in "([{":
            st.append(c)
        elif not st or st.___() != pairs[c]:
            return False      # wrong closer, or none open
    return not st
]],
          [[
    for c in s:
        if c in "([{":
            st.append(c)
        elif not st or st.___() != pairs[c]:
            return False      # 틀린 닫는 괄호, 또는 열린 게 없음
    return not st
]],
          [[
    for c in s:
        if c in "([{":
            st.append(c)
        elif not st or st.___() != pairs[c]:
            return False      # 閉錯咗，或者根本冇嘢開住
    return not st
]]
        ),
        answer = "pop",
        accept = { "pop" },
        hint = L(
          "Three letters, the opposite of push. With no argument it takes the last item.",
          "세 글자, push의 반대. 인자 없이 마지막 항목을 꺼낸다.",
          "三個字母，push 嘅相反。冇 argument 就攞最後一個。"
        ),
        ok = L(
          "not st first: pop on an empty list raises IndexError. Then compare with the opener the dict expects.",
          "not st가 먼저: 빈 리스트에 pop하면 IndexError. 그다음 dict가 기대하는 여는 괄호와 비교.",
          "not st 行先：空 list pop 會拋 IndexError。然後同 dict 預期嘅開括號比較。"
        ),
      },
      {
        topic = "TOP",
        q = L(
          "Peek at the most recent opener without removing it. Which index?",
          "가장 최근의 여는 괄호를 꺼내지 않고 엿본다. 어떤 인덱스?",
          "唔攞走、淨係偷睇最近嘅開括號。邊個 index？"
        ),
        code = L(
          [[
st = []
st.append("(")
st.append("[")
top = st[___]        # the most recent opener
print(top)           # [
]],
          [[
st = []
st.append("(")
st.append("[")
top = st[___]        # 가장 최근의 여는 괄호
print(top)           # [
]],
          [[
st = []
st.append("(")
st.append("[")
top = st[___]        # 最近嘅開括號
print(top)           # [
]]
        ),
        answer = "-1",
        accept = { "-1", "len(st) - 1", "len(st)-1" },
        hint = L(
          "Negative indexing counts from the end; the last item is one back.",
          "음수 인덱스는 끝에서 센다; 마지막 항목은 하나 뒤.",
          "負數 index 由尾數起；最後一個係退一格。"
        ),
        ok = L(
          "st[-1] is the peek. Guard it with if st: the same way as pop.",
          "st[-1]이 peek. pop과 마찬가지로 if st:로 보호.",
          "st[-1] 就係 peek。同 pop 一樣用 if st: 守住。"
        ),
      },
      {
        topic = "EMPTY",
        q = L(
          "Every opener must have found its closer. What does valid return after the loop?",
          "모든 여는 괄호가 짝을 찾았어야 한다. 루프 뒤에 valid는 무엇을 반환?",
          "每個開括號都要搵到佢嘅閉括號。loop 之後 valid 回傳咩？"
        ),
        code = L(
          [[
        elif len(st) == 0 or st.pop() != pairs[c]:
            return False
    # done reading: is anything still waiting for a closer?
    return ___
]],
          [[
        elif len(st) == 0 or st.pop() != pairs[c]:
            return False
    # 다 읽었다: 아직 짝을 기다리는 게 있나?
    return ___
]],
          [[
        elif len(st) == 0 or st.pop() != pairs[c]:
            return False
    # 讀完喇：仲有冇嘢等緊閉括號？
    return ___
]]
        ),
        answer = "not st",
        accept = { "not st", "len(st) == 0", "st == []" },
        hint = L(
          "True when the stack is empty. An empty list is falsy; negate it.",
          "스택이 비었을 때 True. 빈 리스트는 거짓; 부정하라.",
          "stack 空嗰陣係 True。空 list 係 falsy；反轉佢。"
        ),
        ok = L(
          '"(()" fails here, not in the loop. O(n) time, O(n) stack in the worst case.',
          '"(()"는 루프가 아니라 여기서 실패. O(n) 시간, 최악의 경우 O(n) 스택.',
          '"(()" 係喺呢度衰，唔係喺 loop 入面。O(n) 時間，最差 O(n) stack。'
        ),
      },
      {
        topic = "MIN",
        q = L(
          "A min stack answers the minimum in O(1). Each push also records the smaller of x and the old low. Which built-in?",
          "최소 스택은 최솟값을 O(1)에 답한다. push마다 x와 이전 최저 중 작은 쪽도 기록. 어떤 내장 함수?",
          "min stack 用 O(1) 答最細值。每次 push 都記低 x 同舊最低值之中細嗰個。邊個內建 function？"
        ),
        code = L(
          [[
class MinStack:
    def __init__(self):
        self.st, self.lows = [], []
    def push(self, x):
        self.st.append(x)
        m = self.lows[-1] if self.lows else x
        self.lows.append(___(x, m))
]],
          [[
class MinStack:
    def __init__(self):
        self.st, self.lows = [], []
    def push(self, x):
        self.st.append(x)
        m = self.lows[-1] if self.lows else x
        self.lows.append(___(x, m))
]],
          [[
class MinStack:
    def __init__(self):
        self.st, self.lows = [], []
    def push(self, x):
        self.st.append(x)
        m = self.lows[-1] if self.lows else x
        self.lows.append(___(x, m))
]]
        ),
        answer = "min",
        accept = { "min" },
        hint = L(
          "The built-in that picks the smaller of two values.",
          "두 값 중 작은 쪽을 고르는 내장 함수.",
          "揀兩個值之中細嗰個嘅內建 function。"
        ),
        ok = L(
          "lows[-1] is always the minimum of what is on st. pop both lists together. O(1) push, pop and get_min.",
          "lows[-1]은 항상 st에 있는 것들의 최솟값. 두 리스트를 함께 pop. push, pop, get_min 모두 O(1).",
          "lows[-1] 永遠係 st 上面嘢嘅最細值。兩個 list 一齊 pop。push、pop、get_min 全部 O(1)。"
        ),
      },
    },
  },
  {
    id = "py_dp",
    station = "DP",
    name = L("CALLBACK 2  -  the stairs", "콜백 2  -  계단", "第二輪 2  -  樓梯"),
    title = L(
      "Dynamic programming: stairs and coins",
      "동적 계획법: 계단과 동전",
      "動態規劃：樓梯同硬幣"
    ),
    lesson = L(
      "DP: solve the small cases once, build the bigger ones from them. Stairs: ways(i) = ways(i-1) + ways(i-2). Coins: dp[a] = min over coins of dp[a-c] + 1, with inf for unreachable.",
      "DP: 작은 경우를 한 번 풀고, 큰 경우를 그 위에 쌓는다. 계단: ways(i) = ways(i-1) + ways(i-2). 동전: dp[a] = 동전마다 dp[a-c] + 1의 최솟값, 못 만드는 금액은 inf.",
      "DP：細嘅 case 解一次，大嘅由佢哋砌出嚟。樓梯：ways(i) = ways(i-1) + ways(i-2)。硬幣：dp[a] = 每個硬幣 dp[a-c] + 1 嘅最細值，砌唔到嘅係 inf。"
    ),
    bg = "bg_lab",
    portrait = "portrait_officer",
    speaker = L("Chef Bo", "보 셰프", "寶廚"),
    ground = 348,
    spawn = 180,
    width = 1600,
    npcs = {
      {
        kind = "clerk",
        x = 560,
        facing = -1,
        line = L(
          "Round two. The MTR exit has n steps, you take one or two at a time. How many ways up?",
          "2라운드. MTR 출구에 계단이 n개, 한 번에 하나나 둘씩. 올라가는 방법은 몇 가지?",
          "第二題。MTR 出口有 n 級樓梯，一次行一級或兩級。有幾多種行法？"
        ),
      },
      {
        kind = "mei",
        x = 900,
        facing = -1,
        line = L(
          "It's fib in a hat, Chef. Then the coin one: fewest coins for the exact change.",
          "모자 쓴 fib예요, 셰프. 그다음은 동전 문제: 정확한 거스름돈에 최소 동전.",
          "呢個係戴住帽嘅 fib 咋，廚師。之後係硬幣題：最少硬幣砌到啱啱好嘅找續。"
        ),
      },
    },
    viz = "python",
    chips = {
      { "dp[i-1] + dp[i-2]", "cyan" },
      { "@functools.cache", "gold" },
      { 'float("inf")', "pink" },
      { "min(dp[a], dp[a-c]+1)", "green" },
    },
    note = "1  i - 2  cache  inf  min  -1",
    story = L(
      "Round two. Siu Ming draws a staircase and a pile of coins. Bo has climbed the MTR exit ten thousand times "
        .. "and counted the till's change every night; now the question is how many ways and how few coins. "
        .. "A table that fills from the bottom up, and a marker for the impossible.",
      "2라운드. 시우밍이 계단과 동전 더미를 그린다. 보는 MTR 출구를 만 번은 올랐고 매일 밤 계산대 거스름돈을 세었다; "
        .. "이제 질문은 몇 가지 방법인지, 동전은 몇 개면 되는지. 아래에서 위로 채우는 표 하나, 그리고 불가능을 뜻하는 표시.",
      "第二題。小明畫咗一條樓梯同一堆硬幣。寶廚行過 MTR 出口一萬次，每晚都數收銀機嘅找續；"
        .. "而家問嘅係有幾多種行法、最少幾多個硬幣。一個由下而上填嘅表，同一個代表「砌唔到」嘅記號。"
    ),
    stages = {
      {
        topic = "BASE",
        q = L(
          "Ways to climb 0 steps and 1 step: one each. Fill the base cases.",
          "0계단과 1계단을 오르는 방법: 각각 하나. 기저 조건을 채워라.",
          "行 0 級同 1 級嘅方法：各一種。填 base case。"
        ),
        code = L(
          [[
def stairs(n):
    # ways to climb n steps, one or two at a time
    dp = [0] * (n + 1)
    dp[0] = dp[1] = ___
    for i in range(2, n + 1):
        dp[i] = dp[i - 1] + dp[i - 2]
    return dp[n]
]],
          [[
def stairs(n):
    # 한 번에 하나나 둘씩, n계단을 오르는 방법의 수
    dp = [0] * (n + 1)
    dp[0] = dp[1] = ___
    for i in range(2, n + 1):
        dp[i] = dp[i - 1] + dp[i - 2]
    return dp[n]
]],
          [[
def stairs(n):
    # 一次行一級或兩級，行 n 級嘅方法數
    dp = [0] * (n + 1)
    dp[0] = dp[1] = ___
    for i in range(2, n + 1):
        dp[i] = dp[i - 1] + dp[i - 2]
    return dp[n]
]]
        ),
        answer = "1",
        accept = { "1" },
        hint = L(
          "There is exactly one way to stand still, and one way to take a single step.",
          "가만히 서 있는 방법도 하나, 한 계단 오르는 방법도 하나.",
          "企喺度唔郁係一種方法，行一級都係一種。"
        ),
        ok = L(
          "Base cases seed the table. dp[0] = 1 is the empty climb; without it dp[2] would be wrong.",
          "기저 조건이 표의 씨앗. dp[0] = 1은 빈 오르기; 없으면 dp[2]가 틀린다.",
          "base case 係個表嘅種子。dp[0] = 1 係空嘅一次攀爬；冇佢 dp[2] 就錯。"
        ),
      },
      {
        topic = "STEP",
        q = L(
          "You reach step i from one below or two below. Fill the second term: dp[i - 1] + dp[___]",
          "i계단엔 하나 아래나 둘 아래에서 온다. 둘째 항: dp[i - 1] + dp[___]",
          "去到第 i 級，係由下一級或者下兩級嚟。填第二項：dp[i - 1] + dp[___]"
        ),
        code = L(
          [[
    dp = [0] * (n + 1)
    dp[0] = dp[1] = 1
    for i in range(2, n + 1):
        # last move was a single or a double step
        dp[i] = dp[i - 1] + dp[___]
    return dp[n]
]],
          [[
    dp = [0] * (n + 1)
    dp[0] = dp[1] = 1
    for i in range(2, n + 1):
        # 마지막 걸음이 한 계단이었거나 두 계단이었거나
        dp[i] = dp[i - 1] + dp[___]
    return dp[n]
]],
          [[
    dp = [0] * (n + 1)
    dp[0] = dp[1] = 1
    for i in range(2, n + 1):
        # 最後一步係行一級或者兩級
        dp[i] = dp[i - 1] + dp[___]
    return dp[n]
]]
        ),
        answer = "i - 2",
        accept = { "i - 2", "i-2" },
        hint = L(
          "Two steps below i. The same shape as fib, without the recursion.",
          "i보다 두 계단 아래. 재귀 없는 fib와 같은 모양.",
          "i 之下兩級。同 fib 一樣嘅形狀，但冇遞歸。"
        ),
        ok = L(
          "Bottom-up DP: O(n) time, O(n) table, and two variables would make it O(1) space.",
          "상향식 DP: O(n) 시간, O(n) 표, 변수 둘만 쓰면 O(1) 공간.",
          "由下而上嘅 DP：O(n) 時間，O(n) 個表，用兩個變數就 O(1) 空間。"
        ),
      },
      {
        topic = "CACHE",
        q = L(
          "Top-down instead: recurse, but remember every result. Which functools decorator?",
          "대신 하향식: 재귀하되 모든 결과를 기억. functools의 어떤 데코레이터?",
          "反過嚟由上而下：遞歸，但記住每個結果。functools 邊個 decorator？"
        ),
        code = L(
          [[
from functools import ___

@___
def stairs(n):
    if n <= 1:
        return 1
    return stairs(n - 1) + stairs(n - 2)
]],
          [[
from functools import ___

@___
def stairs(n):
    if n <= 1:
        return 1
    return stairs(n - 1) + stairs(n - 2)
]],
          [[
from functools import ___

@___
def stairs(n):
    if n <= 1:
        return 1
    return stairs(n - 1) + stairs(n - 2)
]]
        ),
        answer = "cache",
        accept = { "cache", "lru_cache" },
        hint = L(
          "Five letters, since Python 3.9: the unbounded memo. Its older cousin takes a maxsize.",
          "다섯 글자, Python 3.9부터: 상한 없는 memo. 옛 사촌은 maxsize를 받는다.",
          "五個字母，Python 3.9 起有：冇上限嘅 memo。佢嘅舊表親要畀 maxsize。"
        ),
        ok = L(
          "Memoized recursion is DP from the top. Same O(n), but the call stack is n deep: RecursionError near 1000.",
          "메모이제이션 재귀는 위에서 내려오는 DP. 같은 O(n)이지만 호출 스택이 n 깊이: 1000 근처에서 RecursionError.",
          "有 memo 嘅遞歸就係由上而下嘅 DP。一樣 O(n)，但 call stack 深 n 層：接近 1000 就 RecursionError。"
        ),
      },
      {
        topic = "INF",
        q = L(
          "Coin change: fewest coins for each amount. Unreachable amounts start at infinity. Fill the float.",
          "동전 교환: 금액마다 최소 동전 수. 못 만드는 금액은 무한대에서 시작. float를 채워라.",
          "換硬幣：每個金額嘅最少硬幣數。砌唔到嘅金額由無限大開始。填個 float。"
        ),
        code = L(
          [[
def coins(cs, amount):
    dp = [float("___")] * (amount + 1)
    dp[0] = 0
    for a in range(1, amount + 1):
        for c in cs:
            if c <= a:
                dp[a] = min(dp[a], dp[a - c] + 1)
]],
          [[
def coins(cs, amount):
    dp = [float("___")] * (amount + 1)
    dp[0] = 0
    for a in range(1, amount + 1):
        for c in cs:
            if c <= a:
                dp[a] = min(dp[a], dp[a - c] + 1)
]],
          [[
def coins(cs, amount):
    dp = [float("___")] * (amount + 1)
    dp[0] = 0
    for a in range(1, amount + 1):
        for c in cs:
            if c <= a:
                dp[a] = min(dp[a], dp[a - c] + 1)
]]
        ),
        answer = "inf",
        accept = { "inf", "Infinity" },
        hint = L(
          "Three letters. Bigger than any coin count, so the first real answer replaces it.",
          "세 글자. 어떤 동전 수보다 커서 첫 실제 답이 그것을 대체한다.",
          "三個字母。大過任何硬幣數，所以第一個真答案會取代佢。"
        ),
        ok = L(
          "dp[0] = 0: zero coins make zero. Everything else waits at inf until a coin reaches it.",
          "dp[0] = 0: 동전 0개로 0을 만든다. 나머지는 동전이 닿을 때까지 inf에서 기다린다.",
          "dp[0] = 0：零個硬幣砌零。其餘全部喺 inf 等，直到有硬幣掂到佢。"
        ),
      },
      {
        topic = "MIN",
        q = L(
          "Coin c on top of the best answer for a - c, if that beats what we have. Which built-in keeps the smaller?",
          "a - c의 최선 위에 동전 c 하나, 그게 지금 것보다 나으면. 작은 쪽을 남기는 내장 함수는?",
          "喺 a - c 嘅最佳答案上面加一個硬幣 c，如果好過而家嘅。邊個內建 function 留低細嗰個？"
        ),
        code = L(
          [[
    dp[0] = 0
    for a in range(1, amount + 1):
        for c in cs:
            if c <= a:
                # one coin c on top of the best for a - c
                dp[a] = ___(dp[a], dp[a - c] + 1)
]],
          [[
    dp[0] = 0
    for a in range(1, amount + 1):
        for c in cs:
            if c <= a:
                # a - c의 최선 위에 동전 c 하나
                dp[a] = ___(dp[a], dp[a - c] + 1)
]],
          [[
    dp[0] = 0
    for a in range(1, amount + 1):
        for c in cs:
            if c <= a:
                # a - c 嘅最佳答案上面加一個硬幣 c
                dp[a] = ___(dp[a], dp[a - c] + 1)
]]
        ),
        answer = "min",
        accept = { "min" },
        hint = L(
          "Fewest coins wins, so keep the smaller of the old value and the new candidate.",
          "동전이 적을수록 이기니, 옛 값과 새 후보 중 작은 쪽을 남겨라.",
          "硬幣越少越好，所以留低舊值同新候選之中細嗰個。"
        ),
        ok = L(
          "O(amount * coins). Greedy fails here: coins [1, 3, 4] for 6 is two coins, not 4 + 1 + 1.",
          "O(amount * coins). 탐욕법은 여기서 실패: 동전 [1, 3, 4]로 6은 4 + 1 + 1이 아니라 두 개.",
          "O(amount * coins)。貪心法呢度會衰：硬幣 [1, 3, 4] 砌 6 係兩個，唔係 4 + 1 + 1。"
        ),
      },
      {
        topic = "NONE",
        q = L(
          "If the amount is still infinite, no coins reach it. What does the function return then?",
          "금액이 아직 무한대면 어떤 동전도 닿지 못한 것. 그때 함수는 무엇을 반환?",
          "如果金額仲係無限大，即係冇硬幣掂到佢。咁 function 回傳咩？"
        ),
        code = L(
          [[
            if c <= a:
                dp[a] = min(dp[a], dp[a - c] + 1)
    # still infinite: no combination of coins reaches amount
    return ___ if dp[amount] == float("inf") else dp[amount]
]],
          [[
            if c <= a:
                dp[a] = min(dp[a], dp[a - c] + 1)
    # 아직 무한대: 어떤 동전 조합도 amount에 닿지 못함
    return ___ if dp[amount] == float("inf") else dp[amount]
]],
          [[
            if c <= a:
                dp[a] = min(dp[a], dp[a - c] + 1)
    # 仲係無限大：冇任何硬幣組合砌到 amount
    return ___ if dp[amount] == float("inf") else dp[amount]
]]
        ),
        answer = "-1",
        accept = { "-1" },
        hint = L(
          "The usual impossible marker: a negative one, since a real count is never below zero.",
          "흔한 불가능 표시: 음수 하나, 실제 개수는 절대 0 아래가 아니니까.",
          "慣用嘅「唔可能」記號：負一，因為真正嘅數目永遠唔會細過零。"
        ),
        ok = L(
          "Coins [2] for 3 returns -1. Table, transition, base case, impossible marker: every DP has the four.",
          "동전 [2]로 3은 -1 반환. 표, 전이, 기저 조건, 불가능 표시: 모든 DP에 이 넷이 있다.",
          "硬幣 [2] 砌 3 回傳 -1。表、轉移、base case、「唔可能」記號：每個 DP 都有呢四樣。"
        ),
      },
    },
  },
  {
    id = "py_window",
    station = "WINDOW",
    name = L("CALLBACK 3  -  the window", "콜백 3  -  창", "第二輪 3  -  窗口"),
    title = L(
      "Sliding windows and two pointers",
      "슬라이딩 윈도우와 포인터 둘",
      "sliding window 同兩個 pointer"
    ),
    lesson = L(
      "Kadane: cur = max(x, cur + x), best = max(best, cur). A fixed window adds one and drops one. A growing window moves l forward until the window is clean again.",
      "카데인: cur = max(x, cur + x), best = max(best, cur). 고정 창은 하나 더하고 하나 뺀다. 늘어나는 창은 창이 다시 깨끗해질 때까지 l을 앞으로 옮긴다.",
      "Kadane：cur = max(x, cur + x)，best = max(best, cur)。固定窗口加一個減一個。會長嘅窗口將 l 推前，直到個窗口再次乾淨。"
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
          "Round three. A week of profits and losses per hour. Which run of hours made the most?",
          "3라운드. 일주일치 시간당 손익. 어느 연속 시간대가 가장 많이 벌었나?",
          "第三題。一星期每個鐘嘅盈虧。邊一段連續鐘數賺最多？"
        ),
      },
      {
        kind = "hero",
        x = 900,
        facing = -1,
        line = L(
          "One pass, Bo. Keep the run if it's still helping, drop it the moment it isn't.",
          "한 번만 훑어, 보. 도움이 되는 동안은 연속을 유지하고, 아니면 바로 버려.",
          "一次過搞掂，寶廚。仲有幫助就留住嗰段，一冇幫助就即刻掉。"
        ),
      },
    },
    viz = "python",
    chips = {
      { "cur = max(x, cur + x)", "cyan" },
      { "s += a[i] - a[i - k]", "gold" },
      { "while c in seen:", "pink" },
      { "r - l + 1", "green" },
    },
    note = "cur + x  a[0]  a[i - k]  remove  r - l + 1",
    story = L(
      "Round three. Siu Ming writes a row of numbers on the board: the till, hour by hour, some hours negative. "
        .. "The best run of hours, the best three hours in a row, then the longest streak of orders with no dish repeated. "
        .. "Three windows, each slid across the row exactly once.",
      "3라운드. 시우밍이 보드에 숫자 한 줄을 쓴다: 시간대별 계산대, 어떤 시간은 음수. "
        .. "가장 좋은 연속 시간대, 가장 좋은 연속 세 시간, 그리고 요리가 겹치지 않는 가장 긴 주문 연속. "
        .. "창 셋, 각각 줄을 정확히 한 번씩 지나간다.",
      "第三題。小明喺板上寫一行數字：收銀機逐個鐘嘅數，有啲鐘係負數。"
        .. "最好嘅一段連續鐘數、最好嘅連續三個鐘，然後係冇菜式重複嘅最長一串訂單。"
        .. "三個窗口，每個都啱啱好掃一次呢行數。"
    ),
    stages = {
      {
        topic = "KADANE",
        q = L(
          "Max subarray: extend the current run with x, or restart at x alone. Fill the second choice.",
          "최대 부분 배열: 현재 연속에 x를 더하거나, x 하나로 새로 시작. 둘째 선택지를 채워라.",
          "最大子陣列：將 x 加入而家嗰段，或者由 x 一個重新開始。填第二個選擇。"
        ),
        code = L(
          [[
def biggest_run(a):
    cur = best = a[0]
    for x in a[1:]:
        cur = max(x, ___)      # extend the run, or restart
        best = max(best, cur)
    return best
]],
          [[
def biggest_run(a):
    cur = best = a[0]
    for x in a[1:]:
        cur = max(x, ___)      # 연속을 잇거나, 새로 시작
        best = max(best, cur)
    return best
]],
          [[
def biggest_run(a):
    cur = best = a[0]
    for x in a[1:]:
        cur = max(x, ___)      # 延續嗰段，或者重新開始
        best = max(best, cur)
    return best
]]
        ),
        answer = "cur + x",
        accept = { "cur + x", "cur+x", "x + cur", "x+cur" },
        hint = L(
          "The run so far with x added. If that is worse than x alone, the old run was dead weight.",
          "지금까지의 연속에 x를 더한 것. 그게 x 혼자보다 못하면 옛 연속은 짐이었던 것.",
          "到而家為止嗰段加埋 x。如果差過 x 自己一個，即係舊嗰段係負累。"
        ),
        ok = L(
          "Kadane's algorithm: O(n), one pass, two variables. A negative run never helps, so it is dropped.",
          "카데인 알고리즘: O(n), 한 번 통과, 변수 둘. 음수 연속은 도움이 안 되니 버린다.",
          "Kadane 算法：O(n)，一次過，兩個變數。負數嗰段永遠冇幫助，所以掉咗佢。"
        ),
      },
      {
        topic = "START",
        q = L(
          "Where do cur and best start? Not at 0: a list of only losses still has a best hour.",
          "cur와 best는 어디서 시작? 0은 아니다: 손실뿐인 리스트에도 최고의 시간은 있다.",
          "cur 同 best 由邊度開始？唔係 0：全部係虧損嘅 list 都有一個最好嘅鐘。"
        ),
        code = L(
          [[
def biggest_run(a):
    cur = best = ___       # not 0: all may be negative
    for x in a[1:]:
        cur = max(x, cur + x)
        best = max(best, cur)
    return best
]],
          [[
def biggest_run(a):
    cur = best = ___       # 0 아님: 전부 음수일 수 있다
    for x in a[1:]:
        cur = max(x, cur + x)
        best = max(best, cur)
    return best
]],
          [[
def biggest_run(a):
    cur = best = ___       # 唔係 0：可能全部負數
    for x in a[1:]:
        cur = max(x, cur + x)
        best = max(best, cur)
    return best
]]
        ),
        answer = "a[0]",
        accept = { "a[0]" },
        hint = L(
          "The first element. The loop then starts from the second, see the slice.",
          "첫 원소. 루프는 그다음 둘째부터 시작, 슬라이스를 보라.",
          "第一個元素。個 loop 之後由第二個開始，睇下個 slice。"
        ),
        ok = L(
          "Starting at 0 would answer 0 for [-3, -1]; the right answer is -1. Seed from the data.",
          "0에서 시작하면 [-3, -1]에 0이라 답한다; 정답은 -1. 데이터에서 씨앗을 얻어라.",
          "由 0 開始嘅話 [-3, -1] 會答 0；正確係 -1。種子要由數據嚟。"
        ),
      },
      {
        topic = "SLIDE",
        q = L(
          "Best k hours in a row: slide a window of size k. One element enters, which one leaves?",
          "연속 k시간 중 최고: 크기 k의 창을 밀어라. 하나가 들어오면, 무엇이 나가나?",
          "連續 k 個鐘最好嘅：推一個大小 k 嘅窗口。一個入，邊個出？"
        ),
        code = L(
          [[
def best_k(a, k):
    s = sum(a[:k])
    best = s
    for i in range(k, len(a)):
        s += a[i] - ___        # one in, one out
        best = max(best, s)
    return best
]],
          [[
def best_k(a, k):
    s = sum(a[:k])
    best = s
    for i in range(k, len(a)):
        s += a[i] - ___        # 하나 들어오고, 하나 나가고
        best = max(best, s)
    return best
]],
          [[
def best_k(a, k):
    s = sum(a[:k])
    best = s
    for i in range(k, len(a)):
        s += a[i] - ___        # 一個入，一個出
        best = max(best, s)
    return best
]]
        ),
        answer = "a[i - k]",
        accept = { "a[i - k]", "a[i-k]" },
        hint = L(
          "The element that just fell off the left edge: k places behind i.",
          "왼쪽 끝에서 방금 떨어진 원소: i보다 k칸 뒤.",
          "啱啱由左邊跌出去嘅元素：i 後面 k 格。"
        ),
        ok = L(
          "O(n) instead of O(n * k): the sum is updated, never recomputed. Fixed windows are always this trick.",
          "O(n * k) 대신 O(n): 합을 갱신할 뿐 다시 계산하지 않는다. 고정 창은 늘 이 요령.",
          "O(n) 而唔係 O(n * k)：個和只係更新，唔會重新計。固定窗口永遠係呢一招。"
        ),
      },
      {
        topic = "SHRINK",
        q = L(
          "Longest run with no repeated dish. When c is already in the window, drop from the left until it is not. Which set method?",
          "요리가 겹치지 않는 가장 긴 연속. c가 이미 창 안이면 없어질 때까지 왼쪽에서 뺀다. 어떤 set 메서드?",
          "冇菜式重複嘅最長一段。c 已經喺窗口入面嗰陣，由左邊掉，掉到佢唔喺度為止。邊個 set method？"
        ),
        code = L(
          [[
def longest(s):
    seen, l, best = set(), 0, 0
    for r, c in enumerate(s):
        while c in seen:
            seen.___(s[l])     # drop the left end
            l += 1
        seen.add(c)
]],
          [[
def longest(s):
    seen, l, best = set(), 0, 0
    for r, c in enumerate(s):
        while c in seen:
            seen.___(s[l])     # 왼쪽 끝을 버린다
            l += 1
        seen.add(c)
]],
          [[
def longest(s):
    seen, l, best = set(), 0, 0
    for r, c in enumerate(s):
        while c in seen:
            seen.___(s[l])     # 掉走左邊嗰個
            l += 1
        seen.add(c)
]]
        ),
        answer = "remove",
        accept = { "remove", "discard" },
        hint = L(
          "The set method that takes one element out; it raises KeyError if the element is missing.",
          "원소 하나를 빼는 set 메서드; 원소가 없으면 KeyError.",
          "攞走一個元素嘅 set method；元素唔喺度會拋 KeyError。"
        ),
        ok = L(
          "l only moves right, so each character enters and leaves once: O(n) despite the nested while.",
          "l은 오른쪽으로만 가니 각 문자는 한 번 들어가고 한 번 나온다: 중첩 while에도 O(n).",
          "l 只會向右行，所以每個字入一次出一次：雖然有 nested while，都係 O(n)。"
        ),
      },
      {
        topic = "LONGEST",
        q = L(
          "The window is s[l:r+1]. Record its width if it is the widest yet. Fill the width.",
          "창은 s[l:r+1]. 지금까지 가장 넓으면 폭을 기록. 폭을 채워라.",
          "個窗口係 s[l:r+1]。如果係到而家最闊嘅就記低闊度。填個闊度。"
        ),
        code = L(
          [[
        while c in seen:
            seen.remove(s[l])
            l += 1
        seen.add(c)
        best = max(best, ___)  # the window is s[l:r+1]
    return best
]],
          [[
        while c in seen:
            seen.remove(s[l])
            l += 1
        seen.add(c)
        best = max(best, ___)  # 창은 s[l:r+1]
    return best
]],
          [[
        while c in seen:
            seen.remove(s[l])
            l += 1
        seen.add(c)
        best = max(best, ___)  # 個窗口係 s[l:r+1]
    return best
]]
        ),
        answer = "r - l + 1",
        accept = { "r - l + 1", "r-l+1", "r + 1 - l", "r+1-l" },
        hint = L(
          "Inclusive count from l to r: the difference, plus one.",
          "l부터 r까지 양끝 포함 개수: 차이에 하나 더하기.",
          "由 l 到 r 包埋兩端嘅數目：個差，加一。"
        ),
        ok = L(
          '"abcabcbb" gives 3. Two pointers, one set, one pass. Round three to Bo.',
          '"abcabcbb"는 3. 포인터 둘, set 하나, 한 번 통과. 3라운드는 보에게.',
          '"abcabcbb" 得 3。兩個 pointer、一個 set、一次過。第三題寶廚贏。'
        ),
      },
    },
  },
  {
    id = "py_heap",
    station = "HEAP",
    name = L("CALLBACK 4  -  the heap", "콜백 4  -  힙", "第二輪 4  -  heap"),
    title = L("heapq: kth largest, top k", "heapq: k번째로 큰 수, 상위 k", "heapq：第 k 大、top k"),
    lesson = L(
      "heapq turns a list into a min-heap: heappush and heappop are O(log n), h[0] is the smallest. Keep a heap of size k and its root is the kth largest. nlargest, nsmallest and Counter.most_common are the shortcuts.",
      "heapq는 리스트를 최소 힙으로: heappush와 heappop은 O(log n), h[0]이 최솟값. 크기 k의 힙을 유지하면 그 루트가 k번째로 큰 수. nlargest, nsmallest, Counter.most_common이 지름길.",
      "heapq 將 list 變 min-heap：heappush 同 heappop 係 O(log n)，h[0] 係最細。keep 住一個大小 k 嘅 heap，佢個 root 就係第 k 大。nlargest、nsmallest 同 Counter.most_common 係捷徑。"
    ),
    bg = "bg_lab",
    portrait = "portrait_officer",
    speaker = L("Chef Bo", "보 셰프", "寶廚"),
    ground = 348,
    spawn = 180,
    width = 1600,
    npcs = {
      {
        kind = "clerk",
        x = 560,
        facing = -1,
        line = L(
          "Round four. A million receipts stream past. The third biggest, at any moment, without sorting.",
          "4라운드. 영수증 백만 장이 흘러간다. 언제든 세 번째로 큰 것, 정렬 없이.",
          "第四題。一百萬張收據流過。任何時刻嘅第三大，唔准排序。"
        ),
      },
      {
        kind = "mei",
        x = 900,
        facing = -1,
        line = L(
          "Keep only three, Chef. The smallest of the three is the answer; throw out anything smaller.",
          "셋만 남겨요, 셰프. 셋 중 가장 작은 게 답; 그보다 작은 건 버려요.",
          "淨係留三個，廚師。三個之中最細嗰個就係答案；細過佢嘅全部掉。"
        ),
      },
    },
    viz = "python",
    chips = {
      { "heapq.heappush(h, x)", "cyan" },
      { "if len(h) > k:", "gold" },
      { "heapq.nlargest(3, xs)", "pink" },
      { "c.most_common(k)", "green" },
    },
    note = "heappush  heappop  0  nlargest  most_common",
    story = L(
      "Round four. Receipts by the million, and Siu Ming wants the kth biggest while they are still arriving. "
        .. "Sorting everything is n log n and needs it all in memory; a heap of k keeps just the contenders. "
        .. "Bo draws a small pile with the smallest on top and starts pushing.",
      "4라운드. 백만 장의 영수증, 시우밍은 아직 도착 중인데 k번째로 큰 것을 원한다. "
        .. "전부 정렬하면 n log n에 메모리도 다 필요하다; k짜리 힙은 후보만 남긴다. "
        .. "보는 가장 작은 게 위에 오는 작은 더미를 그리고 밀어 넣기 시작한다.",
      "第四題。收據以百萬計，仲喺度嚟緊，小明就要第 k 大嗰張。"
        .. "全部排序係 n log n，仲要全部放喺記憶體；一個 k 大小嘅 heap 淨係留住有機會嗰啲。"
        .. "寶廚畫咗一堆細細嘅、最細嗰個喺頂，然後開始推。"
    ),
    stages = {
      {
        topic = "PUSH",
        q = L(
          "Every receipt goes onto a min-heap. Which heapq function adds x and keeps the heap order?",
          "모든 영수증을 최소 힙에. x를 넣고 힙 순서를 유지하는 heapq 함수는?",
          "每張收據都放上 min-heap。邊個 heapq function 加 x 而且保持 heap 次序？"
        ),
        code = L(
          [[
def kth_largest(nums, k):
    h = []                     # a min-heap of the k biggest
    for x in nums:
        heapq.___(h, x)
        if len(h) > k:
            heapq.heappop(h)
    return h[0]
]],
          [[
def kth_largest(nums, k):
    h = []                     # 가장 큰 k개의 최소 힙
    for x in nums:
        heapq.___(h, x)
        if len(h) > k:
            heapq.heappop(h)
    return h[0]
]],
          [[
def kth_largest(nums, k):
    h = []                     # 最大 k 個嘅 min-heap
    for x in nums:
        heapq.___(h, x)
        if len(h) > k:
            heapq.heappop(h)
    return h[0]
]]
        ),
        answer = "heappush",
        accept = { "heappush" },
        hint = L(
          "heap plus the stack verb for adding, one word, lowercase.",
          "heap에 넣기를 뜻하는 스택 동사를 붙인 한 단어, 소문자.",
          "heap 加上 stack 入嘢嗰個動詞，一個字，細楷。"
        ),
        ok = L(
          "O(log k) per push. Python's heapq is a min-heap only; for a max-heap push -x.",
          "push마다 O(log k). Python의 heapq는 최소 힙뿐; 최대 힙이 필요하면 -x를 넣어라.",
          "每次 push O(log k)。Python 嘅 heapq 只有 min-heap；要 max-heap 就推 -x。"
        ),
      },
      {
        topic = "POP",
        q = L(
          "More than k inside: the smallest cannot be the kth largest. Which function removes the root?",
          "k개보다 많으면 가장 작은 것은 k번째로 큰 수일 수 없다. 루트를 빼는 함수는?",
          "入面多過 k 個：最細嗰個唔可能係第 k 大。邊個 function 攞走個 root？"
        ),
        code = L(
          [[
    for x in nums:
        heapq.heappush(h, x)
        if len(h) > k:
            heapq.___(h)       # the smallest leaves
    return h[0]
]],
          [[
    for x in nums:
        heapq.heappush(h, x)
        if len(h) > k:
            heapq.___(h)       # 가장 작은 것이 나간다
    return h[0]
]],
          [[
    for x in nums:
        heapq.heappush(h, x)
        if len(h) > k:
            heapq.___(h)       # 最細嗰個走
    return h[0]
]]
        ),
        answer = "heappop",
        accept = { "heappop" },
        hint = L(
          "heap plus the stack verb for taking, one word. It returns the smallest.",
          "heap에 꺼내기를 뜻하는 스택 동사를 붙인 한 단어. 최솟값을 반환.",
          "heap 加上 stack 攞嘢嗰個動詞，一個字。佢回傳最細嗰個。"
        ),
        ok = L(
          "The heap never grows past k: O(n log k) time, O(k) space. Sorting would be O(n log n) and O(n).",
          "힙은 k를 넘지 않는다: O(n log k) 시간, O(k) 공간. 정렬은 O(n log n)에 O(n).",
          "個 heap 永遠唔會大過 k：O(n log k) 時間，O(k) 空間。排序會係 O(n log n) 同 O(n)。"
        ),
      },
      {
        topic = "ROOT",
        q = L(
          "k contenders left; the smallest of them is the kth largest overall. Which index holds it?",
          "후보 k개가 남았다; 그중 가장 작은 것이 전체에서 k번째로 큰 수. 어떤 인덱스에?",
          "剩低 k 個候選；佢哋之中最細嗰個就係全部之中第 k 大。喺邊個 index？"
        ),
        code = L(
          [[
        if len(h) > k:
            heapq.heappop(h)
    # k items left; the root is the smallest of them
    return h[___]
]],
          [[
        if len(h) > k:
            heapq.heappop(h)
    # k개 남음; 루트가 그중 가장 작다
    return h[___]
]],
          [[
        if len(h) > k:
            heapq.heappop(h)
    # 剩低 k 個；個 root 係佢哋之中最細
    return h[___]
]]
        ),
        answer = "0",
        accept = { "0" },
        hint = L(
          "A heap is a list whose front is its root. The front index.",
          "힙은 앞이 루트인 리스트. 맨 앞 인덱스.",
          "heap 係一個前面係 root 嘅 list。最前嗰個 index。"
        ),
        ok = L(
          "h[0] peeks in O(1). Never index deeper: the rest of the list is only partially ordered.",
          "h[0]은 O(1) 엿보기. 더 깊이 인덱싱하지 말 것: 나머지는 부분적으로만 정렬됨.",
          "h[0] 係 O(1) 偷睇。唔好 index 入啲：其餘部分只係部分排好序。"
        ),
      },
      {
        topic = "NLARGEST",
        q = L(
          "The three biggest prices, biggest first, in one call. Which heapq helper?",
          "가장 비싼 세 가격, 큰 순서로, 호출 한 번에. 어떤 heapq 도우미?",
          "最貴三個價錢，由大到細，一個 call 搞掂。邊個 heapq helper？"
        ),
        code = L(
          [[
import heapq
prices = [38, 12, 55, 20, 41]
top3 = heapq.___(3, prices)      # [55, 41, 38]
low2 = heapq.nsmallest(2, prices)   # [12, 20]
]],
          [[
import heapq
prices = [38, 12, 55, 20, 41]
top3 = heapq.___(3, prices)      # [55, 41, 38]
low2 = heapq.nsmallest(2, prices)   # [12, 20]
]],
          [[
import heapq
prices = [38, 12, 55, 20, 41]
top3 = heapq.___(3, prices)      # [55, 41, 38]
low2 = heapq.nsmallest(2, prices)   # [12, 20]
]]
        ),
        answer = "nlargest",
        accept = { "nlargest" },
        hint = L(
          "The mirror of the helper on the next line: n, then the superlative of big.",
          "다음 줄 도우미의 거울: n, 그다음 big의 최상급.",
          "下一行嗰個 helper 嘅鏡像：n，然後係 big 嘅最高級。"
        ),
        ok = L(
          "nlargest(n, xs, key=...) is O(n log k) and takes a key. sorted(xs)[-3:] would be O(n log n).",
          "nlargest(n, xs, key=...)는 O(n log k)에 key도 받는다. sorted(xs)[-3:]는 O(n log n).",
          "nlargest(n, xs, key=...) 係 O(n log k)，仲收 key。sorted(xs)[-3:] 會係 O(n log n)。"
        ),
      },
      {
        topic = "COUNTER",
        q = L(
          "Top k most ordered dishes. Count them, then take the k highest counts. Which Counter method?",
          "가장 많이 주문된 요리 k개. 세고, 가장 높은 k개를 취한다. 어떤 Counter 메서드?",
          "最多人叫嘅 k 款菜。數一數，然後攞最高嘅 k 個。邊個 Counter method？"
        ),
        code = L(
          [[
from collections import Counter

def top_k(dishes, k):
    c = Counter(dishes)
    # (dish, count) pairs, highest count first
    return [d for d, _ in c.___(k)]
]],
          [[
from collections import Counter

def top_k(dishes, k):
    c = Counter(dishes)
    # (요리, 개수) 쌍, 많은 순서로
    return [d for d, _ in c.___(k)]
]],
          [[
from collections import Counter

def top_k(dishes, k):
    c = Counter(dishes)
    # (菜, 次數) 對，次數高嘅先
    return [d for d, _ in c.___(k)]
]]
        ),
        answer = "most_common",
        accept = { "most_common" },
        hint = L(
          "Two words joined by an underscore: the ones that appear the most, the way people say it.",
          "밑줄로 이은 두 단어: 가장 자주 나오는 것들, 사람들이 말하는 그대로.",
          "兩個字用底線連住：出現最多嗰啲，照人講嘅咁講。"
        ),
        ok = L(
          "most_common uses heapq.nlargest inside when k is given. Count in O(n), pick in O(n log k). Round four to Bo.",
          "most_common은 k가 주어지면 내부에서 heapq.nlargest를 쓴다. O(n)에 세고 O(n log k)에 고른다. 4라운드는 보에게.",
          "most_common 畀咗 k 嘅話入面用 heapq.nlargest。O(n) 數，O(n log k) 揀。第四題寶廚贏。"
        ),
      },
    },
  },
  {
    id = "py_interval",
    station = "INTERVAL",
    name = L("CALLBACK 5  -  the shifts", "콜백 5  -  교대", "第二輪 5  -  更表"),
    title = L("Merge intervals", "구간 병합", "合併區間"),
    lesson = L(
      "Sort by start. Walk once: if the next interval starts before the last merged one ends, extend that end to the larger of the two; otherwise start a new block.",
      "시작으로 정렬. 한 번 걷는다: 다음 구간이 마지막으로 합친 것이 끝나기 전에 시작하면 그 끝을 둘 중 큰 쪽으로 늘린다; 아니면 새 블록을 시작.",
      "按開始時間排序。行一次：下一個區間喺上一個合併咗嘅完之前開始，就將個尾延長到兩者較大嗰個；否則開一個新 block。"
    ),
    bg = "bg_market",
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
          "Round five. Every cook's shift as [start, end]. When is the kitchen staffed at all, as one clean list?",
          "5라운드. 요리사마다 교대를 [시작, 끝]으로. 주방에 사람이 있는 시간은 언제인가, 깔끔한 리스트 하나로?",
          "第五題。每個廚師嘅更係 [開始, 完]。廚房幾時有人，用一個乾淨嘅 list 講？"
        ),
      },
      {
        kind = "hero",
        x = 900,
        facing = -1,
        line = L(
          "Sort first, Bo. Once they're in order, overlaps are always neighbours.",
          "먼저 정렬해, 보. 순서만 잡히면 겹치는 건 늘 이웃이야.",
          "先排序，寶廚。一排好序，重疊嘅永遠係隔籬。"
        ),
      },
    },
    viz = "python",
    chips = {
      { "ivs.sort(key=...)", "cyan" },
      { "s <= out[-1][1]", "gold" },
      { "max(out[-1][1], e)", "pink" },
      { "out.append([s, e])", "green" },
    },
    note = "0  s <= out[-1][1]  max  append  1:",
    story = L(
      "Round five. The night market's noodle stall next door lends its counter as a second whiteboard. "
        .. "Siu Ming lists the cooks' shifts, overlapping every which way, and wants the hours the kitchen is covered "
        .. "as a list of clean blocks. Sort, then one pass: every merged interval is either extended or started.",
      "5라운드. 옆 야시장 국수 노점이 카운터를 두 번째 화이트보드로 빌려준다. "
        .. "시우밍이 요리사들의 교대를 죄다 겹치게 나열하고, 주방에 사람이 있는 시간을 깔끔한 블록 리스트로 원한다. "
        .. "정렬, 그다음 한 번 통과: 합쳐진 구간은 늘어나거나 새로 시작하거나.",
      "第五題。隔籬夜市嘅麵檔借個枱面做第二塊白板。"
        .. "小明列出廚師嘅更表，重疊到亂晒龍，想要廚房有人嘅時間，用一串乾淨嘅 block 表示。"
        .. "排序，然後一次過：每個合併咗嘅區間，要麼延長，要麼新開。"
    ),
    stages = {
      {
        topic = "SORT",
        q = L(
          "Sort the shifts by start time so overlaps sit side by side. Which element does the key pick?",
          "겹치는 것이 나란히 오도록 교대를 시작 시각으로 정렬. key가 고르는 원소는?",
          "按開始時間排更表，等重疊嘅排埋一齊。個 key 揀邊個元素？"
        ),
        code = L(
          [=[
shifts = [[13, 15], [9, 11], [10, 12]]
# sort by start so overlapping shifts sit side by side
shifts.sort(key=lambda iv: iv[___])
print(shifts)    # [[9, 11], [10, 12], [13, 15]]
]=],
          [=[
shifts = [[13, 15], [9, 11], [10, 12]]
# 시작으로 정렬해 겹치는 교대가 나란히 오게
shifts.sort(key=lambda iv: iv[___])
print(shifts)    # [[9, 11], [10, 12], [13, 15]]
]=],
          [=[
shifts = [[13, 15], [9, 11], [10, 12]]
# 按開始排序，等重疊嘅更排埋一齊
shifts.sort(key=lambda iv: iv[___])
print(shifts)    # [[9, 11], [10, 12], [13, 15]]
]=]
        ),
        answer = "0",
        accept = { "0" },
        hint = L(
          "The first element of each pair is the start.",
          "각 쌍의 첫 원소가 시작.",
          "每對嘅第一個元素係開始。"
        ),
        ok = L(
          "O(n log n) for the sort; everything after is O(n). Lists sort by first element anyway, so shifts.sort() works here too.",
          "정렬에 O(n log n); 그 뒤는 전부 O(n). 리스트는 어차피 첫 원소로 정렬되니 shifts.sort()도 된다.",
          "排序 O(n log n)；之後全部 O(n)。list 本身都係按第一個元素排，所以 shifts.sort() 都得。"
        ),
      },
      {
        topic = "OVERLAP",
        q = L(
          "Does this shift start before the last merged block ends? Fill the overlap test.",
          "이 교대가 마지막으로 합친 블록이 끝나기 전에 시작하는가? 겹침 검사를 채워라.",
          "呢個更係咪喺上一個合併咗嘅 block 完之前開始？填重疊檢查。"
        ),
        code = L(
          [[
def merge(ivs):
    out = []
    for s, e in sorted(ivs):
        if out and ___:          # touches the last block
            out[-1][1] = max(out[-1][1], e)
        else:
            out.append([s, e])
]],
          [[
def merge(ivs):
    out = []
    for s, e in sorted(ivs):
        if out and ___:          # 마지막 블록에 닿는다
            out[-1][1] = max(out[-1][1], e)
        else:
            out.append([s, e])
]],
          [[
def merge(ivs):
    out = []
    for s, e in sorted(ivs):
        if out and ___:          # 掂到上一個 block
            out[-1][1] = max(out[-1][1], e)
        else:
            out.append([s, e])
]]
        ),
        answer = "s <= out[-1][1]",
        accept = { "s <= out[-1][1]", "out[-1][1] >= s" },
        hint = L(
          "Compare the start with the end of the last block in out. Equal counts as touching.",
          "시작을 out의 마지막 블록의 끝과 비교. 같으면 닿은 것으로.",
          "將開始同 out 最後一個 block 嘅完比較。相等都算掂到。"
        ),
        ok = L(
          "out[-1] is the last merged block, [1] its end. The sort guarantees s is never before the block's start.",
          "out[-1]은 마지막으로 합친 블록, [1]은 그 끝. 정렬 덕에 s가 블록 시작보다 앞설 일은 없다.",
          "out[-1] 係最後一個合併咗嘅 block，[1] 係佢個尾。排序保證 s 永遠唔會早過 block 嘅開始。"
        ),
      },
      {
        topic = "EXTEND",
        q = L(
          "They overlap: the merged block ends at the later of the two ends. Which built-in?",
          "겹친다: 합친 블록은 두 끝 중 늦은 쪽에서 끝난다. 어떤 내장 함수?",
          "重疊喇：合併咗嘅 block 喺兩個尾之中較遲嗰個完。邊個內建 function？"
        ),
        code = L(
          [[
    for s, e in ivs:
        if out and s <= out[-1][1]:
            # [9, 15] then [10, 12] still ends at 15
            out[-1][1] = ___(out[-1][1], e)
        else:
            out.append([s, e])
]],
          [[
    for s, e in ivs:
        if out and s <= out[-1][1]:
            # [9, 15] 다음 [10, 12]여도 끝은 여전히 15
            out[-1][1] = ___(out[-1][1], e)
        else:
            out.append([s, e])
]],
          [[
    for s, e in ivs:
        if out and s <= out[-1][1]:
            # [9, 15] 之後 [10, 12]，尾都仲係 15
            out[-1][1] = ___(out[-1][1], e)
        else:
            out.append([s, e])
]]
        ),
        answer = "max",
        accept = { "max" },
        hint = L(
          "The larger of the two ends wins; a shift fully inside another must not shrink the block.",
          "두 끝 중 큰 쪽이 이긴다; 다른 교대 안에 완전히 든 교대가 블록을 줄이면 안 된다.",
          "兩個尾之中大嗰個贏；完全喺另一個入面嘅更唔可以縮細個 block。"
        ),
        ok = L(
          "Assigning e alone is the classic bug: [1, 10] then [2, 3] would end at 3.",
          "그냥 e를 대입하는 게 고전적 버그: [1, 10] 다음 [2, 3]이면 3에서 끝나버린다.",
          "淨係 assign e 係經典 bug：[1, 10] 之後 [2, 3] 會變成喺 3 完。"
        ),
      },
      {
        topic = "APPEND",
        q = L(
          "A gap: this shift starts after the last block ended. Start a new block. Which list method?",
          "빈틈: 이 교대는 마지막 블록이 끝난 뒤 시작. 새 블록을 시작. 어떤 리스트 메서드?",
          "有空隙：呢個更喺上一個 block 完咗之後先開始。開一個新 block。邊個 list method？"
        ),
        code = L(
          [[
        if out and s <= out[-1][1]:
            out[-1][1] = max(out[-1][1], e)
        else:
            out.___([s, e])     # a gap: a new block
    return out
]],
          [[
        if out and s <= out[-1][1]:
            out[-1][1] = max(out[-1][1], e)
        else:
            out.___([s, e])     # 빈틈: 새 블록
    return out
]],
          [[
        if out and s <= out[-1][1]:
            out[-1][1] = max(out[-1][1], e)
        else:
            out.___([s, e])     # 有空隙：新 block
    return out
]]
        ),
        answer = "append",
        accept = { "append" },
        hint = L(
          "Add to the end of out. A list, not a tuple, so the end can still be extended later.",
          "out의 끝에 추가. 나중에 끝을 늘릴 수 있도록 튜플이 아니라 리스트로.",
          "加落 out 嘅尾。用 list 唔用 tuple，咁個尾之後仲可以延長。"
        ),
        ok = L(
          "[[9, 11], [10, 12], [13, 15]] becomes [[9, 12], [13, 15]]. Sort plus one pass: O(n log n).",
          "[[9, 11], [10, 12], [13, 15]]는 [[9, 12], [13, 15]]가 된다. 정렬 더하기 한 번 통과: O(n log n).",
          "[[9, 11], [10, 12], [13, 15]] 變成 [[9, 12], [13, 15]]。排序加一次過：O(n log n)。"
        ),
      },
      {
        topic = "GAPS",
        q = L(
          "The free slots are the gaps between merged blocks: pair each block with the next. Fill the slice.",
          "빈 시간은 합친 블록 사이의 틈: 각 블록을 다음 블록과 짝짓는다. 슬라이스를 채워라.",
          "空檔就係合併咗嘅 block 之間嘅空隙：將每個 block 同下一個配對。填個 slice。"
        ),
        code = L(
          [=[
out = [[9, 12], [13, 15], [16, 18]]
# the free slots between blocks: (12, 13), (15, 16)
free = [(a[1], b[0]) for a, b in zip(out, out[___])]
]=],
          [=[
out = [[9, 12], [13, 15], [16, 18]]
# 블록 사이의 빈 시간: (12, 13), (15, 16)
free = [(a[1], b[0]) for a, b in zip(out, out[___])]
]=],
          [=[
out = [[9, 12], [13, 15], [16, 18]]
# block 之間嘅空檔：(12, 13), (15, 16)
free = [(a[1], b[0]) for a, b in zip(out, out[___])]
]=]
        ),
        answer = "1:",
        accept = { "1:" },
        hint = L(
          "Everything from the second block on. zip stops at the shorter list, so no index error.",
          "둘째 블록부터 끝까지. zip은 짧은 쪽에서 멈추니 인덱스 에러가 없다.",
          "由第二個 block 起到尾。zip 喺短嗰邊停，所以唔會 index error。"
        ),
        ok = L(
          "zip(xs, xs[1:]) walks neighbouring pairs. Since 3.10 itertools.pairwise does the same. Round five to Bo.",
          "zip(xs, xs[1:])는 이웃 쌍을 걷는다. 3.10부터는 itertools.pairwise가 같은 일을 한다. 5라운드는 보에게.",
          "zip(xs, xs[1:]) 行過每對隔籬。3.10 起 itertools.pairwise 做一樣嘅嘢。第五題寶廚贏。"
        ),
      },
    },
  },
  {
    id = "py_lru",
    station = "LRU",
    name = L("CALLBACK 6  -  the cache", "콜백 6  -  캐시", "第二輪 6  -  cache"),
    title = L("An LRU cache with OrderedDict", "OrderedDict로 만든 LRU 캐시", "用 OrderedDict 做 LRU cache"),
    lesson = L(
      "LRU: least recently used goes first. OrderedDict remembers order: move_to_end on every use, popitem(last=False) evicts the oldest. get and put are O(1). functools.lru_cache is the built-in.",
      "LRU: 가장 오래 안 쓴 것부터 나간다. OrderedDict는 순서를 기억: 쓸 때마다 move_to_end, popitem(last=False)로 가장 오래된 것을 내보낸다. get과 put은 O(1). 내장은 functools.lru_cache.",
      "LRU：最耐冇用嗰個先走。OrderedDict 記住次序：每次用就 move_to_end，popitem(last=False) 趕走最舊嗰個。get 同 put 係 O(1)。內建係 functools.lru_cache。"
    ),
    bg = "bg_lab",
    portrait = "portrait_officer",
    speaker = L("Chef Bo", "보 셰프", "寶廚"),
    ground = 348,
    spawn = 180,
    width = 1600,
    npcs = {
      {
        kind = "clerk",
        x = 560,
        facing = -1,
        line = L(
          "Round six. A cache that holds n routes. When it is full, the one nobody asked for longest goes.",
          "6라운드. 경로 n개를 담는 캐시. 가득 차면 가장 오래 아무도 찾지 않은 것이 나간다.",
          "第六題。一個裝 n 條路線嘅 cache。滿咗嘅話，最耐冇人問嗰條走。"
        ),
      },
      {
        kind = "mei",
        x = 900,
        facing = -1,
        line = L(
          "The one everybody gets asked, Chef. In Python the dict already remembers the order for you.",
          "다들 받는 그 문제예요, 셰프. Python에선 dict가 이미 순서를 기억해줘요.",
          "個個都會被問嘅嗰題，廚師。Python 嘅 dict 已經幫你記住次序。"
        ),
      },
    },
    viz = "python",
    chips = {
      { "OrderedDict()", "cyan" },
      { "d.move_to_end(key)", "gold" },
      { "d.popitem(last=False)", "pink" },
      { "@lru_cache(maxsize=128)", "green" },
    },
    note = "OrderedDict  -1  move_to_end  popitem  maxsize",
    story = L(
      "Round six. The delivery app looks up the same few routes all night, and the map API charges per call. "
        .. "Siu Ming wants a cache of n routes where the least recently used one leaves first, with get and put in O(1). "
        .. "Bo writes one dict that remembers its order and two methods.",
      "6라운드. 배달 앱은 밤새 같은 몇 경로만 조회하고, 지도 API는 호출마다 돈을 받는다. "
        .. "시우밍은 가장 오래 안 쓴 것이 먼저 나가는 경로 n개짜리 캐시를 원한다, get과 put은 O(1)로. "
        .. "보는 순서를 기억하는 dict 하나와 메서드 둘을 쓴다.",
      "第六題。外賣 app 成晚查嘅都係嗰幾條路線，地圖 API 每個 call 都收錢。"
        .. "小明想要一個裝 n 條路線嘅 cache，最耐冇用嗰條先走，get 同 put 都要 O(1)。"
        .. "寶廚寫一個記住次序嘅 dict 同兩個 method。"
    ),
    stages = {
      {
        topic = "ORDERED",
        q = L(
          "A dict that also remembers which key is oldest. Which class from collections?",
          "어떤 키가 가장 오래됐는지도 기억하는 dict. collections의 어떤 클래스?",
          "一個仲記得邊個 key 最舊嘅 dict。collections 嘅邊個 class？"
        ),
        code = L(
          [[
from collections import ___

class LRU:
    def __init__(self, cap):
        self.cap = cap
        self.d = ___()      # remembers insertion order
]],
          [[
from collections import ___

class LRU:
    def __init__(self, cap):
        self.cap = cap
        self.d = ___()      # 삽입 순서를 기억한다
]],
          [[
from collections import ___

class LRU:
    def __init__(self, cap):
        self.cap = cap
        self.d = ___()      # 記住插入次序
]]
        ),
        answer = "OrderedDict",
        accept = { "OrderedDict" },
        hint = L(
          "Two words, CamelCase: a dict with an order.",
          "두 단어, 카멜케이스: 순서가 있는 dict.",
          "兩個字，CamelCase：有次序嘅 dict。"
        ),
        ok = L(
          "Plain dicts keep insertion order since 3.7, but only this one has move_to_end and popitem(last=False).",
          "일반 dict도 3.7부터 삽입 순서를 지키지만, move_to_end와 popitem(last=False)는 이것에만 있다.",
          "普通 dict 由 3.7 起都保持插入次序，但只有呢個有 move_to_end 同 popitem(last=False)。"
        ),
      },
      {
        topic = "MISS",
        q = L(
          "get of a key that is not cached. What does it return, by the usual convention?",
          "캐시에 없는 키의 get. 관례상 무엇을 반환?",
          "get 一個冇 cache 嘅 key。照慣例回傳咩？"
        ),
        code = L(
          [[
    def get(self, key):
        if key not in self.d:
            return ___          # a miss
        self.d.move_to_end(key)
        return self.d[key]
]],
          [[
    def get(self, key):
        if key not in self.d:
            return ___          # 미스
        self.d.move_to_end(key)
        return self.d[key]
]],
          [[
    def get(self, key):
        if key not in self.d:
            return ___          # miss 咗
        self.d.move_to_end(key)
        return self.d[key]
]]
        ),
        answer = "-1",
        accept = { "-1", "None" },
        hint = L(
          "The interview convention: a negative one, since cached values are non-negative.",
          "면접 관례: 음수 하나, 캐시 값은 음수가 아니니까.",
          "面試慣例：負一，因為 cache 嘅值都係非負數。"
        ),
        ok = L(
          "In real code None is more honest. key in self.d is O(1): a hash lookup.",
          "실제 코드에선 None이 더 정직하다. key in self.d는 O(1): 해시 조회.",
          "真正嘅 code 用 None 老實啲。key in self.d 係 O(1)：hash 查找。"
        ),
      },
      {
        topic = "TOUCH",
        q = L(
          "A hit: the key was just used, so it becomes the newest. Which OrderedDict method?",
          "히트: 키를 방금 썼으니 가장 최근이 된다. OrderedDict의 어떤 메서드?",
          "hit 咗：個 key 啱啱用過，所以變成最新。OrderedDict 邊個 method？"
        ),
        code = L(
          [[
    def get(self, key):
        if key not in self.d:
            return -1
        self.d.___(key)        # just used: newest now
        return self.d[key]
]],
          [[
    def get(self, key):
        if key not in self.d:
            return -1
        self.d.___(key)        # 방금 사용: 이제 가장 최근
        return self.d[key]
]],
          [[
    def get(self, key):
        if key not in self.d:
            return -1
        self.d.___(key)        # 啱啱用過：而家最新
        return self.d[key]
]]
        ),
        answer = "move_to_end",
        accept = { "move_to_end" },
        hint = L(
          "Three words with underscores: relocate the key to the back of the order.",
          "밑줄로 이은 세 단어: 키를 순서의 맨 뒤로 옮긴다.",
          "三個字用底線連住：將個 key 搬去次序嘅最後。"
        ),
        ok = L(
          "O(1): the OrderedDict is a doubly linked list plus a dict. The newest lives at the end, the oldest at the front.",
          "O(1): OrderedDict는 이중 연결 리스트에 dict를 더한 것. 가장 최근은 끝에, 가장 오래된 것은 앞에.",
          "O(1)：OrderedDict 係一條雙向 linked list 加一個 dict。最新喺尾，最舊喺頭。"
        ),
      },
      {
        topic = "EVICT",
        q = L(
          "put made the cache one too big. Remove the oldest pair, at the front. Which method, with last=False?",
          "put으로 캐시가 하나 넘쳤다. 맨 앞의 가장 오래된 쌍을 제거. last=False를 받는 메서드는?",
          "put 之後 cache 多咗一個。攞走最前面最舊嗰對。邊個 method，帶 last=False？"
        ),
        code = L(
          [[
    def put(self, key, val):
        self.d[key] = val
        self.d.move_to_end(key)
        if len(self.d) > self.cap:
            # drop the oldest: the front of the order
            self.d.___(last=False)
]],
          [[
    def put(self, key, val):
        self.d[key] = val
        self.d.move_to_end(key)
        if len(self.d) > self.cap:
            # 가장 오래된 것을 버린다: 순서의 맨 앞
            self.d.___(last=False)
]],
          [[
    def put(self, key, val):
        self.d[key] = val
        self.d.move_to_end(key)
        if len(self.d) > self.cap:
            # 掉走最舊嘅：次序嘅最前面
            self.d.___(last=False)
]]
        ),
        answer = "popitem",
        accept = { "popitem" },
        hint = L(
          "The dict method that removes and returns one (key, value) pair; last=False takes it from the front.",
          "(키, 값) 쌍 하나를 꺼내 반환하는 dict 메서드; last=False면 앞에서 꺼낸다.",
          "攞走並回傳一對 (key, value) 嘅 dict method；last=False 就由前面攞。"
        ),
        ok = L(
          "get and put both O(1). Overwriting a key must also move it to the end, hence the move before the check.",
          "get과 put 모두 O(1). 키를 덮어써도 끝으로 옮겨야 하니, 검사 전에 move가 있다.",
          "get 同 put 都係 O(1)。覆寫一個 key 都要搬去尾，所以檢查之前先 move。"
        ),
      },
      {
        topic = "BUILTIN",
        q = L(
          "For a pure function, the standard library has the whole cache as a decorator. Which keyword caps its size?",
          "순수 함수라면 표준 라이브러리에 캐시 전체가 데코레이터로 있다. 크기를 제한하는 키워드는?",
          "pure function 嘅話，標準庫成個 cache 都係一個 decorator。邊個 keyword 限個大小？"
        ),
        code = L(
          [[
from functools import lru_cache

@lru_cache(___=128)
def eta(stop):
    return slow_map_lookup(stop)
# the 128 most recent stops stay; older ones are evicted
]],
          [[
from functools import lru_cache

@lru_cache(___=128)
def eta(stop):
    return slow_map_lookup(stop)
# 가장 최근 128개 정류장만 남고, 오래된 것은 내보낸다
]],
          [[
from functools import lru_cache

@lru_cache(___=128)
def eta(stop):
    return slow_map_lookup(stop)
# 最近嘅 128 個站留低，舊嘅趕走
]]
        ),
        answer = "maxsize",
        accept = { "maxsize" },
        hint = L(
          "One word, no underscore: the largest size the cache may reach. None means unbounded.",
          "밑줄 없는 한 단어: 캐시가 닿을 수 있는 최대 크기. None이면 무제한.",
          "一個字，冇底線：cache 可以去到嘅最大 size。None 即係無上限。"
        ),
        ok = L(
          "eta.cache_info() shows hits and misses; eta.cache_clear() empties it. Arguments must be hashable. Round six to Bo.",
          "eta.cache_info()가 히트와 미스를 보여주고, eta.cache_clear()가 비운다. 인자는 해시 가능해야 한다. 6라운드는 보에게.",
          "eta.cache_info() 顯示 hit 同 miss；eta.cache_clear() 清空佢。argument 要 hashable。第六題寶廚贏。"
        ),
      },
    },
  },
  {
    id = "py_grid",
    station = "GRID",
    name = L("FINAL  -  the islands", "파이널  -  섬", "決賽  -  島"),
    title = L("Number of islands: DFS on a grid", "섬의 개수: 격자 위의 DFS", "數島：grid 上嘅 DFS"),
    lesson = L(
      "A grid is a graph: each cell has four neighbours. Flood fill: stop off the map or on water, sink the cell, recurse four ways. Count one island per unsunk land cell in the double loop.",
      "격자는 그래프: 각 칸에 이웃이 넷. 플러드 필: 지도 밖이나 물이면 멈추고, 칸을 가라앉히고, 네 방향으로 재귀. 이중 루프에서 아직 안 가라앉은 땅 칸마다 섬 하나.",
      "grid 就係 graph：每格有四個鄰居。flood fill：出咗地圖或者係水就停，將格沉落去，四個方向遞歸。double loop 入面每格未沉嘅陸地算一個島。"
    ),
    bg = "bg_night",
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
          "Final round. The delivery map as a grid of 1s and 0s. How many separate islands of buildings?",
          "마지막 라운드. 배달 지도를 1과 0의 격자로. 서로 떨어진 건물 섬은 몇 개?",
          "決賽。外賣地圖係一個 1 同 0 嘅 grid。有幾多個分開嘅建築物島？"
        ),
      },
      {
        kind = "hero",
        x = 900,
        facing = -1,
        line = L(
          "It's the graph round in disguise, Bo. Sink every island as you find it, and count the finds.",
          "변장한 그래프 라운드야, 보. 찾는 대로 섬을 가라앉히고, 찾은 횟수를 세.",
          "呢個係扮咗嘢嘅 graph 題，寶廚。搵到一個島就沉一個，數下搵到幾多次。"
        ),
      },
    },
    viz = "python",
    chips = {
      { "if r < 0 or c < 0", "cyan" },
      { 'g[r][c] = "0"', "gold" },
      { "dfs(r + 1, c)", "pink" },
      { "count += 1", "green" },
    },
    note = 'len(g[0])  "1"  "0"  c - 1  +=',
    story = L(
      "The final. 01:40. Siu Ming draws Causeway Bay as a grid: 1 for a building, 0 for the road. "
        .. "Bo has to count the islands of buildings, each a patch of 1s touching up, down, left or right. "
        .. "One DFS per island, sinking it as it goes; the count of sinkings is the answer, and the answer is the OFFER.",
      "파이널. 01:40. 시우밍이 코즈웨이베이를 격자로 그린다: 건물은 1, 도로는 0. "
        .. "보는 상하좌우로 맞닿은 1의 덩어리, 즉 건물 섬을 세야 한다. "
        .. "섬마다 DFS 하나, 지나가며 가라앉힌다; 가라앉힌 횟수가 답이고, 그 답이 오퍼다.",
      "決賽。凌晨一點四十。小明將銅鑼灣畫成 grid：建築物係 1，馬路係 0。"
        .. "寶廚要數建築物嘅島，每個島係一片上下左右掂住嘅 1。"
        .. "每個島一次 DFS，邊行邊沉；沉咗幾多次就係答案，而答案就係 OFFER。"
    ),
    stages = {
      {
        topic = "BOUNDS",
        q = L(
          "Off the map on any side: stop. Fill the width the column index is checked against.",
          "어느 쪽이든 지도 밖이면 멈춘다. 열 인덱스를 비교할 너비를 채워라.",
          "任何一邊出咗地圖：停。填 column index 要同佢比較嘅闊度。"
        ),
        code = L(
          [[
def islands(g):
    def dfs(r, c):
        # off the map on any side: stop
        if r < 0 or c < 0 or r >= len(g) or c >= ___:
            return
]],
          [[
def islands(g):
    def dfs(r, c):
        # 어느 쪽이든 지도 밖: 멈춤
        if r < 0 or c < 0 or r >= len(g) or c >= ___:
            return
]],
          [[
def islands(g):
    def dfs(r, c):
        # 任何一邊出咗地圖：停
        if r < 0 or c < 0 or r >= len(g) or c >= ___:
            return
]]
        ),
        answer = "len(g[0])",
        accept = { "len(g[0])", "cols", "w" },
        hint = L(
          "The number of columns: the length of one row, say the first.",
          "열의 개수: 한 행, 이를테면 첫 행의 길이.",
          "column 嘅數目：一行、譬如第一行嘅長度。"
        ),
        ok = L(
          "Check bounds before touching g[r][c]: Python would raise IndexError on the right edge, and g[-1] silently wraps.",
          "g[r][c]를 만지기 전에 경계 검사: 오른쪽 끝에선 IndexError, g[-1]은 조용히 뒤로 감긴다.",
          "掂 g[r][c] 之前先檢查邊界：右邊會 IndexError，g[-1] 仲會靜靜哋繞返去尾。"
        ),
      },
      {
        topic = "WATER",
        q = L(
          "Only land spreads. Which cell value means a building?",
          "땅만 퍼진다. 건물을 뜻하는 칸 값은?",
          "淨係陸地會擴散。邊個格值代表建築物？"
        ),
        code = L(
          [[
        if r < 0 or c < 0 or r >= len(g) or c >= len(g[0]):
            return
        if g[r][c] != ___:
            return          # water, or already sunk
        g[r][c] = "0"
]],
          [[
        if r < 0 or c < 0 or r >= len(g) or c >= len(g[0]):
            return
        if g[r][c] != ___:
            return          # 물이거나, 이미 가라앉음
        g[r][c] = "0"
]],
          [[
        if r < 0 or c < 0 or r >= len(g) or c >= len(g[0]):
            return
        if g[r][c] != ___:
            return          # 係水，或者已經沉咗
        g[r][c] = "0"
]]
        ),
        answer = '"1"',
        accept = { '"1"', "'1'", "1" },
        hint = L(
          "The grid holds one-character strings, and the road is the zero.",
          "격자는 한 글자 문자열을 담고, 도로가 0.",
          "個 grid 裝嘅係一個字嘅 string，馬路係零。"
        ),
        ok = L(
          'Strings, not ints: "1" != 1 in Python. Read the input type before the first line.',
          '정수가 아니라 문자열: Python에서 "1" != 1. 첫 줄 전에 입력 타입부터 읽어라.',
          '係 string 唔係 int：Python 入面 "1" != 1。寫第一行之前先睇清楚 input type。'
        ),
      },
      {
        topic = "SINK",
        q = L(
          "Mark the cell visited by turning it into water. Fill the value.",
          "칸을 물로 바꿔 방문 표시. 값을 채워라.",
          "將格變成水，當作已經行過。填個值。"
        ),
        code = L(
          [[
        if g[r][c] != "1":
            return
        g[r][c] = ___        # sink it: never counted twice
        dfs(r + 1, c)
        dfs(r - 1, c)
        dfs(r, c + 1)
        dfs(r, c - 1)
]],
          [[
        if g[r][c] != "1":
            return
        g[r][c] = ___        # 가라앉힌다: 두 번 세지 않게
        dfs(r + 1, c)
        dfs(r - 1, c)
        dfs(r, c + 1)
        dfs(r, c - 1)
]],
          [[
        if g[r][c] != "1":
            return
        g[r][c] = ___        # 沉咗佢：唔會數兩次
        dfs(r + 1, c)
        dfs(r - 1, c)
        dfs(r, c - 1)
        dfs(r, c + 1)
]]
        ),
        answer = '"0"',
        accept = { '"0"', "'0'", "0" },
        hint = L(
          "The road value, as a one-character string. Sinking is the visited set for free.",
          "도로 값, 한 글자 문자열로. 가라앉히기가 곧 공짜 방문 집합.",
          "馬路嘅值，一個字嘅 string。沉落去就係免費嘅 visited set。"
        ),
        ok = L(
          "Mutating the input saves a visited set. If the caller needs the grid back, copy it first.",
          "입력을 바꾸면 방문 집합이 필요 없다. 호출자가 격자를 돌려받아야 하면 먼저 복사.",
          "改 input 就慳返一個 visited set。如果 caller 要攞返個 grid，先 copy。"
        ),
      },
      {
        topic = "FLOOD",
        q = L(
          "Spread to all four neighbours: down, up, right, and the last one. Fill it.",
          "이웃 넷으로 퍼진다: 아래, 위, 오른쪽, 그리고 마지막 하나. 채워라.",
          "擴散去四個鄰居：下、上、右，同埋最後一個。填佢。"
        ),
        code = L(
          [[
        g[r][c] = "0"
        dfs(r + 1, c)
        dfs(r - 1, c)
        dfs(r, c + 1)
        dfs(r, ___)          # the fourth neighbour
]],
          [[
        g[r][c] = "0"
        dfs(r + 1, c)
        dfs(r - 1, c)
        dfs(r, c + 1)
        dfs(r, ___)          # 넷째 이웃
]],
          [[
        g[r][c] = "0"
        dfs(r + 1, c)
        dfs(r - 1, c)
        dfs(r, c + 1)
        dfs(r, ___)          # 第四個鄰居
]]
        ),
        answer = "c - 1",
        accept = { "c - 1", "c-1" },
        hint = L("Same row, one column to the left.", "같은 행, 한 열 왼쪽.", "同一行，左邊一格。"),
        ok = L(
          "Four directions, no diagonals. Deep grids hit the recursion limit near 1000: an explicit stack of (r, c) fixes that.",
          "네 방향, 대각선 없음. 깊은 격자는 1000 근처에서 재귀 한계에 닿는다: (r, c)의 명시적 스택이 해결.",
          "四個方向，冇斜角。深嘅 grid 接近 1000 就撞 recursion limit：用一個 (r, c) 嘅 stack 就解決。"
        ),
      },
      {
        topic = "COUNT",
        q = L(
          "Walk every cell. Each unsunk building starts a new island: sink it whole, then add one. Fill the operator.",
          "모든 칸을 걷는다. 아직 안 가라앉은 건물마다 새 섬: 통째로 가라앉히고 하나 더한다. 연산자를 채워라.",
          "行勻每一格。每個未沉嘅建築物都係一個新島：整個沉咗佢，再加一。填個運算符。"
        ),
        code = L(
          [[
    count = 0
    for r in range(len(g)):
        for c in range(len(g[0])):
            if g[r][c] == "1":
                dfs(r, c)         # sinks the whole island
                count ___ 1
    return count
]],
          [[
    count = 0
    for r in range(len(g)):
        for c in range(len(g[0])):
            if g[r][c] == "1":
                dfs(r, c)         # 섬 전체를 가라앉힌다
                count ___ 1
    return count
]],
          [[
    count = 0
    for r in range(len(g)):
        for c in range(len(g[0])):
            if g[r][c] == "1":
                dfs(r, c)         # 沉晒成個島
                count ___ 1
    return count
]]
        ),
        answer = "+=",
        accept = { "+=" },
        hint = L(
          "Add one to count, in place: the augmented assignment.",
          "count에 하나를 제자리에서 더한다: 복합 대입.",
          "就地將 count 加一：增量賦值。"
        ),
        ok = L(
          "Every cell is visited once by the loop and at most once by a DFS: O(rows * cols). The screen says OFFER.",
          "모든 칸은 루프에서 한 번, DFS에서 최대 한 번 방문: O(rows * cols). 화면에 OFFER.",
          "每格 loop 行一次、DFS 最多一次：O(rows * cols)。個 mon 寫住 OFFER。"
        ),
      },
    },
  },
}

return maps
