-- Quest P3 CODE RUSH: the midnight edition of the interview game show, in
-- Python. 00:00 on the Times Square screen, the night market still open.
-- Chef Bo is the contestant, Alex and Mei cheer, Siu Ming hosts. Seven
-- classic interview problems; the blanks of one round together form the
-- algorithm. Prize: HIRED.
-- Same shape as src/data.lua: the blank ___ is NOT written in the code.

local function L(en, ko, yue)
  return { en = en, ko = ko, yue = yue }
end

local maps = {
  {
    id = "py_recurse",
    station = "RECURSE",
    name = L("ROUND 1  -  the buzzer", "라운드 1  -  버저", "第一回合  -  蜂鳴器"),
    title = L("Recursion and memoization", "재귀와 메모이제이션", "遞歸同 memoization"),
    lesson = L(
      "A recursive def needs a base case and a smaller call. A dict memo or @functools.cache turns fib from 2^n into n.",
      "재귀 def에는 기저 조건과 더 작은 호출이 필요. dict memo나 @functools.cache가 fib를 2^n에서 n으로 만든다.",
      "遞歸 def 要有 base case 同一個細啲嘅 call。dict memo 或者 @functools.cache 將 fib 由 2^n 變 n。"
    ),
    bg = "bg_mall",
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
          "Midnight edition of CODE RUSH! Python round. Chef Bo at the keyboard. Factorial, then fib. Buzzer's live!",
          "코드 러시 심야 편! Python 라운드. 키보드엔 보 셰프. 팩토리얼, 그다음 fib. 버저 켜졌습니다!",
          "CODE RUSH 午夜場！Python 回合。寶廚坐 keyboard。階乘，然後 fib。蜂鳴器開咗！"
        ),
      },
      {
        kind = "mei",
        x = 900,
        facing = -1,
        line = L(
          "Go, Chef! Same seven rounds as this afternoon. The memo one is a one-liner in Python.",
          "셰프 힘내! 오후와 같은 일곱 라운드. memo 문제는 Python에선 한 줄이에요.",
          "廚師加油！同下晝一樣七個回合。memo 嗰題 Python 一行搞掂。"
        ),
      },
    },
    viz = "python",
    chips = {
      { "def fact(n):", "cyan" },
      { "@functools.cache", "gold" },
      { "memo[n] = v", "pink" },
    },
    note = "base case  n - 1  cache  memo  n - 2",
    story = L(
      "00:00. CODE RUSH, the live coding show on the Times Square screen, midnight edition: Python. "
        .. "The night market crowd, a buzzer, seven rounds, Chef Bo at the keyboard. No misses keeps the combo. Round one: recursion, and why fib needs a memo.",
      "00:00. 타임스퀘어 전광판의 라이브 코딩 쇼 코드 러시, 심야 편: Python. "
        .. "야시장 관중, 버저, 일곱 라운드, 키보드 앞엔 보 셰프. 실수 없으면 콤보가 이어진다. 1라운드: 재귀, 그리고 fib에 memo가 필요한 이유.",
      "凌晨十二點。CODE RUSH，時代廣場大螢幕嘅直播 coding show，午夜場：Python。"
        .. "夜市嘅觀眾、蜂鳴器、七個回合，寶廚坐喺 keyboard 前。冇失誤就保持連擊。第一回合：遞歸，同埋點解 fib 要 memo。"
    ),
    stages = {
      {
        topic = "BASE",
        q = L(
          "Every recursion stops somewhere. fact(0) and fact(1) return what?",
          "모든 재귀는 어딘가에서 멈춘다. fact(0)과 fact(1)은 뭘 반환?",
          "每個遞歸都要有終點。fact(0) 同 fact(1) 回傳咩？"
        ),
        code = L(
          [[
def fact(n):
    if n <= 1:
        return ___          # base case
    return n * fact(n - 1)
]],
          [[
def fact(n):
    if n <= 1:
        return ___          # 기저 조건
    return n * fact(n - 1)
]],
          [[
def fact(n):
    if n <= 1:
        return ___          # base case
    return n * fact(n - 1)
]]
        ),
        answer = "1",
        accept = { "1" },
        hint = L(
          "The multiplicative identity. Returning 0 would zero every factorial.",
          "곱셈의 항등원. 0을 반환하면 모든 팩토리얼이 0이 된다.",
          "乘法嘅單位元。回傳 0 嘅話所有階乘都變 0。"
        ),
        ok = L(
          "Base case first, always. Without it Python raises RecursionError at depth 1000.",
          "기저 조건이 항상 먼저. 없으면 Python은 깊이 1000에서 RecursionError.",
          "Base case 永遠行先。冇佢 Python 會喺深度 1000 拋 RecursionError。"
        ),
      },
      {
        topic = "SMALLER",
        q = L(
          "The recursive call must shrink the problem. Fill: return n * fact(___)",
          "재귀 호출은 문제를 줄여야 한다: return n * fact(___)",
          "遞歸 call 一定要令問題細啲：return n * fact(___)"
        ),
        code = L(
          [[
def fact(n):
    if n <= 1:
        return 1
    return n * fact(___)    # toward the base case
]],
          [[
def fact(n):
    if n <= 1:
        return 1
    return n * fact(___)    # 기저 조건 쪽으로
]],
          [[
def fact(n):
    if n <= 1:
        return 1
    return n * fact(___)    # 向 base case 行
]]
        ),
        answer = "n - 1",
        accept = { "n - 1", "n-1" },
        hint = L(
          "One less than n. fact(n) would never terminate.",
          "n보다 하나 작게. fact(n)이면 절대 끝나지 않는다.",
          "n 減一。fact(n) 永遠唔會完。"
        ),
        ok = L(
          "Each call handles one step and delegates the rest: n * (n-1)!. Python ints never overflow, so fact(100) just works.",
          "각 호출은 한 단계만 처리하고 나머지를 위임: n * (n-1)!. Python int는 오버플로가 없어 fact(100)도 그냥 된다.",
          "每個 call 處理一步，其餘交出去：n * (n-1)!。Python int 唔會 overflow，所以 fact(100) 直接得。"
        ),
      },
      {
        topic = "CACHE",
        q = L(
          "fib(40) naively is a billion calls. One decorator remembers every result. Which one, from functools?",
          "순진한 fib(40)은 십억 번 호출. 데코레이터 하나가 모든 결과를 기억한다. functools의 어떤 것?",
          "fib(40) 直接計要十億次 call。一個 decorator 記住所有結果。functools 嘅邊個？"
        ),
        code = L(
          [[
import functools

@functools.___
def fib(n):
    if n < 2:
        return n
    return fib(n - 1) + fib(n - 2)
]],
          [[
import functools

@functools.___
def fib(n):
    if n < 2:
        return n
    return fib(n - 1) + fib(n - 2)
]],
          [[
import functools

@functools.___
def fib(n):
    if n < 2:
        return n
    return fib(n - 1) + fib(n - 2)
]]
        ),
        answer = "cache",
        accept = { "cache", "lru_cache", "lru_cache()" },
        hint = L(
          "Five letters, the word for a stash of things you already fetched. Its older sibling takes a maxsize.",
          "다섯 글자, 이미 가져온 것들을 쌓아두는 곳. 나이 많은 형제는 maxsize를 받는다.",
          "五個字母，即係你已經攞過嘅嘢嘅儲藏。佢個大哥要收 maxsize。"
        ),
        ok = L(
          "@functools.cache (3.9) memoizes by arguments; @lru_cache(maxsize=128) bounds it. fib(40) becomes 40 calls.",
          "@functools.cache (3.9)는 인자별로 메모이즈. @lru_cache(maxsize=128)는 크기를 제한. fib(40)이 40번 호출이 된다.",
          "@functools.cache (3.9) 按參數 memoize；@lru_cache(maxsize=128) 限住大小。fib(40) 變成 40 次 call。"
        ),
      },
      {
        topic = "MEMO",
        q = L(
          "By hand: look the answer up before computing. Which dict is checked?",
          "직접: 계산하기 전에 답을 찾아본다. 어떤 dict를 검사하나?",
          "手動：計之前先查答案。檢查邊個 dict？"
        ),
        code = L(
          [[
memo = {}
def fib(n):
    if n in ___:
        return memo[n]
    v = n if n < 2 else fib(n - 1) + fib(n - 2)
    memo[n] = v
    return v
]],
          [[
memo = {}
def fib(n):
    if n in ___:
        return memo[n]
    v = n if n < 2 else fib(n - 1) + fib(n - 2)
    memo[n] = v
    return v
]],
          [[
memo = {}
def fib(n):
    if n in ___:
        return memo[n]
    v = n if n < 2 else fib(n - 1) + fib(n - 2)
    memo[n] = v
    return v
]]
        ),
        answer = "memo",
        accept = { "memo" },
        hint = L(
          "The dict defined on the first line, the one written to two lines below the blank.",
          "첫 줄에 정의된 dict, 빈칸 두 줄 아래에서 쓰이는 그것.",
          "第一行定義嘅 dict，空格下面兩行寫入嗰個。"
        ),
        ok = L(
          "n in memo is O(1). Hit: return it. Miss: compute, store, return. That is memoization, spelled out.",
          "n in memo는 O(1). 있으면 반환, 없으면 계산·저장·반환. 그게 풀어 쓴 메모이제이션.",
          "n in memo 係 O(1)。有就回傳；冇就計、存、回傳。呢個就係寫晒出嚟嘅 memoization。"
        ),
      },
      {
        topic = "TWOBACK",
        q = L(
          "fib(n) is the sum of the two before it. Fill the second call: fib(n - 1) + fib(___)",
          "fib(n)은 앞의 둘의 합. 두 번째 호출을 채워라: fib(n - 1) + fib(___)",
          "fib(n) 係前面兩個嘅和。填第二個 call：fib(n - 1) + fib(___)"
        ),
        code = L(
          [[
def fib(n):
    if n < 2:
        return n
    return fib(n - 1) + fib(___)
]],
          [[
def fib(n):
    if n < 2:
        return n
    return fib(n - 1) + fib(___)
]],
          [[
def fib(n):
    if n < 2:
        return n
    return fib(n - 1) + fib(___)
]]
        ),
        answer = "n - 2",
        accept = { "n - 2", "n-2" },
        hint = L(
          "Two less than n. The base case handles 0 and 1, so this never goes negative.",
          "n보다 둘 작게. 기저 조건이 0과 1을 처리하니 음수로 가지 않는다.",
          "n 減二。base case 處理 0 同 1，所以永遠唔會負數。"
        ),
        ok = L(
          "fib(n-1) + fib(n-2): two calls, so 2^n without a memo. With one, each n is computed once. Round one to Chef Bo.",
          "fib(n-1) + fib(n-2): 호출 둘, memo 없으면 2^n. 있으면 각 n을 한 번씩. 1라운드는 보 셰프에게.",
          "fib(n-1) + fib(n-2)：兩個 call，冇 memo 就 2^n。有 memo 每個 n 只計一次。第一回合寶廚贏。"
        ),
      },
    },
  },
  {
    id = "py_tree",
    station = "TREE",
    name = L("ROUND 2  -  the tree", "라운드 2  -  트리", "第二回合  -  樹"),
    title = L("Binary search tree", "이진 탐색 트리", "二元搜尋樹"),
    lesson = L(
      "A Node holds val, left, right; children start as None. Insert goes left when smaller. In-order walk prints sorted. Height is 1 + max of the children. BFS uses a deque and popleft.",
      "Node는 val, left, right를 가지고 자식은 None으로 시작. 삽입은 작으면 왼쪽. 중위 순회는 정렬된 순서로 출력. 높이는 1 + 자식의 max. BFS는 deque와 popleft.",
      "Node 有 val、left、right；子節點由 None 開始。插入細啲就去左。中序走訪印出排好序。高度係 1 + 子節點嘅 max。BFS 用 deque 同 popleft。"
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
          "Round two: a binary search tree. Insert, walk it in order, measure it, then level by level.",
          "2라운드: 이진 탐색 트리. 삽입, 중위 순회, 높이 측정, 그다음 레벨 순서로.",
          "第二回合：二元搜尋樹。插入、中序走訪、量高度，然後逐層行。"
        ),
      },
    },
    viz = "python",
    chips = {
      { "class Node:", "cyan" },
      { "self.left = None", "gold" },
      { "1 + max(hl, hr)", "pink" },
      { "q.popleft()", "green" },
    },
    note = "None  left  right  max  popleft",
    story = L(
      "Round two. The screen shows the whiteboard from the back office: a tree of order numbers. "
        .. "Smaller to the left, larger to the right. Bo has to grow it, walk it in order, measure it and sweep it level by level.",
      "2라운드. 화면에 사무실의 화이트보드가 뜬다: 주문 번호의 트리. 작은 건 왼쪽, 큰 건 오른쪽. "
        .. "보는 그것을 키우고, 중위 순회하고, 높이를 재고, 레벨 순서로 훑어야 한다.",
      "第二回合。螢幕顯示後勤房嘅白板：一棵訂單號碼嘅樹。細嘅去左，大嘅去右。"
        .. "寶廚要種大佢、中序走訪、量高度，再逐層掃一次。"
    ),
    stages = {
      {
        topic = "NODE",
        q = L(
          "A fresh node has no children yet. What are left and right set to?",
          "새 노드엔 아직 자식이 없다. left와 right는 무엇으로 설정?",
          "新 node 未有子節點。left 同 right 設做咩？"
        ),
        code = L(
          [[
class Node:
    def __init__(self, val):
        self.val = val
        self.left = ___
        self.right = ___
]],
          [[
class Node:
    def __init__(self, val):
        self.val = val
        self.left = ___
        self.right = ___
]],
          [[
class Node:
    def __init__(self, val):
        self.val = val
        self.left = ___
        self.right = ___
]]
        ),
        answer = "None",
        accept = { "None" },
        hint = L(
          "Python's nothing, capital N. Go's nil pointer, Rust's Option::None.",
          "Python의 없음, 대문자 N. Go의 nil 포인터, Rust의 Option::None.",
          "Python 嘅「冇」，大楷 N。Go 嘅 nil pointer，Rust 嘅 Option::None。"
        ),
        ok = L(
          "None marks an empty subtree. Every tree function starts with: if node is None.",
          "None이 빈 서브트리를 표시. 모든 트리 함수는 if node is None으로 시작.",
          "None 標記空嘅 subtree。每個樹 function 都由 if node is None 開始。"
        ),
      },
      {
        topic = "INSERT",
        q = L(
          "v is smaller than the node's value. Which side does the insert recurse into?",
          "v가 노드 값보다 작다. 삽입은 어느 쪽으로 재귀하나?",
          "v 細過 node 嘅值。插入向邊一邊遞歸？"
        ),
        code = L(
          [[
def insert(node, v):
    if node is None:
        return Node(v)
    if v < node.val:
        node.___ = insert(node.left, v)
    else:
        node.right = insert(node.right, v)
]],
          [[
def insert(node, v):
    if node is None:
        return Node(v)
    if v < node.val:
        node.___ = insert(node.left, v)
    else:
        node.right = insert(node.right, v)
]],
          [[
def insert(node, v):
    if node is None:
        return Node(v)
    if v < node.val:
        node.___ = insert(node.left, v)
    else:
        node.right = insert(node.right, v)
]]
        ),
        answer = "left",
        accept = { "left" },
        hint = L(
          "The side smaller values live on. The else branch already shows the other side.",
          "작은 값이 사는 쪽. else 분기가 이미 반대쪽을 보여준다.",
          "細嘅值住嘅一邊。else branch 已經顯示另一邊。"
        ),
        ok = L(
          "Smaller left, larger right: the BST invariant. Assigning the result back handles the None case.",
          "작으면 왼쪽, 크면 오른쪽: BST 불변식. 결과를 다시 대입해서 None인 경우를 처리.",
          "細去左，大去右：BST 不變式。將結果賦值返去處理 None 嘅情況。"
        ),
      },
      {
        topic = "INORDER",
        q = L(
          "Left, self, then which side, to print the values in sorted order?",
          "왼쪽, 자기, 그다음 어느 쪽이면 값이 정렬된 순서로 출력되나?",
          "左、自己、然後邊一邊，先會按排序印出值？"
        ),
        code = L(
          [[
def inorder(node):
    if node is None:
        return
    inorder(node.left)
    print(node.val)
    inorder(node.___)
]],
          [[
def inorder(node):
    if node is None:
        return
    inorder(node.left)
    print(node.val)
    inorder(node.___)
]],
          [[
def inorder(node):
    if node is None:
        return
    inorder(node.left)
    print(node.val)
    inorder(node.___)
]]
        ),
        answer = "right",
        accept = { "right" },
        hint = L(
          "The side the larger values live on, visited last.",
          "큰 값이 사는 쪽, 마지막에 방문.",
          "大嘅值住嘅一邊，最後先去。"
        ),
        ok = L(
          "In-order on a BST yields sorted output. Pre-order (self first) copies a tree; post-order (self last) frees one.",
          "BST의 중위 순회는 정렬된 출력. 전위(자기 먼저)는 트리 복사, 후위(자기 마지막)는 해제.",
          "BST 中序走訪出排好序嘅結果。前序（自己先）copy 一棵樹；後序（自己最後）釋放一棵。"
        ),
      },
      {
        topic = "HEIGHT",
        q = L(
          "Height is one plus the taller child. Which built-in picks the taller?",
          "높이는 1 더하기 더 높은 자식. 더 높은 쪽을 고르는 내장 함수는?",
          "高度係一加較高嘅子節點。邊個內建 function 揀較高嗰個？"
        ),
        code = L(
          [[
def height(node):
    if node is None:
        return 0
    return 1 + ___(height(node.left), height(node.right))
]],
          [[
def height(node):
    if node is None:
        return 0
    return 1 + ___(height(node.left), height(node.right))
]],
          [[
def height(node):
    if node is None:
        return 0
    return 1 + ___(height(node.left), height(node.right))
]]
        ),
        answer = "max",
        accept = { "max" },
        hint = L(
          "Three letters, the opposite of min. Built in; Go only got it in 1.21.",
          "세 글자, min의 반대. 내장 함수. Go는 1.21에야 생겼다.",
          "三個字母，min 嘅相反。內建；Go 到 1.21 先有。"
        ),
        ok = L(
          "1 + max(hl, hr). A balanced tree of n nodes is about log2(n) tall; a sorted insert order makes a list, height n.",
          "1 + max(hl, hr). 균형 트리 n개 노드의 높이는 약 log2(n). 정렬된 순서로 삽입하면 리스트, 높이 n.",
          "1 + max(hl, hr)。n 個 node 嘅平衡樹大約 log2(n) 高；排好序插入就變 list，高度 n。"
        ),
      },
      {
        topic = "BFS",
        q = L(
          "Level by level with a deque: take from the front. Which method?",
          "deque로 레벨 순서: 앞에서 꺼낸다. 어떤 메서드?",
          "用 deque 逐層行：由前面攞。邊個 method？"
        ),
        code = L(
          [[
def levels(root):
    q = deque([root])
    while q:
        node = q.___()
        print(node.val)
        q.extend(c for c in (node.left, node.right) if c)
]],
          [[
def levels(root):
    q = deque([root])
    while q:
        node = q.___()
        print(node.val)
        q.extend(c for c in (node.left, node.right) if c)
]],
          [[
def levels(root):
    q = deque([root])
    while q:
        node = q.___()
        print(node.val)
        q.extend(c for c in (node.left, node.right) if c)
]]
        ),
        answer = "popleft",
        accept = { "popleft" },
        hint = L(
          "pop, but from the left end, one word. list.pop(0) would be O(n).",
          "pop이지만 왼쪽 끝에서, 한 단어. list.pop(0)이면 O(n).",
          "pop，但由左邊，一個字。list.pop(0) 會係 O(n)。"
        ),
        ok = L(
          "deque.popleft is O(1); that is why BFS uses a deque and never a list. Round two to Bo.",
          "deque.popleft는 O(1). 그래서 BFS는 리스트가 아니라 deque를 쓴다. 2라운드는 보에게.",
          "deque.popleft 係 O(1)；所以 BFS 用 deque，永遠唔用 list。第二回合寶廚贏。"
        ),
      },
    },
  },
  {
    id = "py_graph",
    station = "GRAPH",
    name = L("ROUND 3  -  the map", "라운드 3  -  지도", "第三回合  -  地圖"),
    title = L("BFS and DFS on the MTR", "MTR 위의 BFS와 DFS", "MTR 上嘅 BFS 同 DFS"),
    lesson = L(
      "A graph is a dict of lists: defaultdict(list). BFS uses a deque and a visited set; DFS recurses. Mark a node visited when you enqueue it, not when you pop it.",
      "그래프는 리스트의 dict: defaultdict(list). BFS는 deque와 visited set, DFS는 재귀. 노드는 pop할 때가 아니라 enqueue할 때 방문 표시.",
      "graph 係一個 list 嘅 dict：defaultdict(list)。BFS 用 deque 同 visited set；DFS 遞歸。node 入隊嗰陣就標記 visited，唔係 pop 嗰陣。"
    ),
    bg = "bg_mtr",
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
          "Round three: the MTR map as a graph. Build it, sweep it wide, then sweep it deep.",
          "3라운드: MTR 지도를 그래프로. 만들고, 넓게 훑고, 깊게 훑기.",
          "第三回合：MTR 地圖做 graph。砌佢、闊掃、再深掃。"
        ),
      },
    },
    viz = "python",
    chips = {
      { "defaultdict(list)", "cyan" },
      { "seen = set()", "gold" },
      { "q = deque([start])", "pink" },
      { "dfs(nb)", "green" },
    },
    note = "list  set  start  add  dfs",
    story = L(
      "Round three. The MTR map: stations are nodes, lines are edges. Bo builds the adjacency dict, "
        .. "then finds every station reachable from Causeway Bay, breadth first, then depth first.",
      "3라운드. MTR 지도: 역은 노드, 노선은 엣지. 보는 인접 dict를 만들고 코즈웨이베이에서 갈 수 있는 모든 역을 너비 우선, 그다음 깊이 우선으로 찾는다.",
      "第三回合。MTR 地圖：站係 node，線係 edge。寶廚砌好 adjacency dict，"
        .. "再由銅鑼灣搵出所有到得嘅站，先闊後深。"
    ),
    stages = {
      {
        topic = "ADJ",
        q = L(
          "Station to its neighbours: a dict whose missing keys start as an empty list. Fill the factory.",
          "역에서 이웃으로: 없는 키가 빈 리스트로 시작하는 dict. 팩토리를 채워라.",
          "站對應鄰站：一個冇 key 就由空 list 開始嘅 dict。填個 factory。"
        ),
        code = L(
          [[
from collections import defaultdict

g = defaultdict(___)
g["Causeway Bay"].append("Tin Hau")
g["Causeway Bay"].append("Admiralty")
]],
          [[
from collections import defaultdict

g = defaultdict(___)
g["Causeway Bay"].append("Tin Hau")
g["Causeway Bay"].append("Admiralty")
]],
          [[
from collections import defaultdict

g = defaultdict(___)
g["Causeway Bay"].append("Tin Hau")
g["Causeway Bay"].append("Admiralty")
]]
        ),
        answer = "list",
        accept = { "list" },
        hint = L(
          "The type whose empty value the append needs. Passed as a callable, no parentheses.",
          "append가 필요로 하는 빈 값의 타입. 호출 가능한 것으로, 괄호 없이 전달.",
          "append 需要嘅空值嘅 type。當 callable 傳入，唔加括號。"
        ),
        ok = L(
          "defaultdict(list) calls list() for a missing key. Go's map[string][]string with the nil-slice append trick, built in.",
          "defaultdict(list)는 없는 키에 list()를 호출. Go의 map[string][]string과 nil 슬라이스 append 트릭을 내장한 것.",
          "defaultdict(list) 對冇嘅 key call list()。Go 嘅 map[string][]string 加 nil slice append 招數，內建咁做。"
        ),
      },
      {
        topic = "VISITED",
        q = L(
          "Remember which stations were seen, with O(1) lookup. Which built-in?",
          "본 역들을 O(1) 조회로 기억. 어떤 내장 함수?",
          "記住見過邊啲站，O(1) 查。邊個內建 function？"
        ),
        code = L(
          [[
def bfs(g, start):
    seen = ___()
    seen.add(start)
    q = deque([start])
]],
          [[
def bfs(g, start):
    seen = ___()
    seen.add(start)
    q = deque([start])
]],
          [[
def bfs(g, start):
    seen = ___()
    seen.add(start)
    q = deque([start])
]]
        ),
        answer = "set",
        accept = { "set" },
        hint = L(
          "Three letters; the next line calls .add on it. Go's map[string]bool, Rust's HashSet.",
          "세 글자. 다음 줄에서 .add를 호출한다. Go의 map[string]bool, Rust의 HashSet.",
          "三個字母；下一行對佢 call .add。Go 嘅 map[string]bool，Rust 嘅 HashSet。"
        ),
        ok = L(
          "A set answers 'seen?' in O(1). A list would make BFS O(n^2).",
          "set은 '봤나?'에 O(1)로 답한다. 리스트면 BFS가 O(n^2).",
          "set 用 O(1) 答「見過未？」。用 list 會令 BFS 變 O(n^2)。"
        ),
      },
      {
        topic = "QUEUE",
        q = L(
          "The queue begins with one station. Which one?",
          "큐는 역 하나로 시작. 어떤 역?",
          "隊由一個站開始。邊個？"
        ),
        code = L(
          [[
def bfs(g, start):
    seen = {start}
    q = deque([___])
    while q:
        st = q.popleft()
]],
          [[
def bfs(g, start):
    seen = {start}
    q = deque([___])
    while q:
        st = q.popleft()
]],
          [[
def bfs(g, start):
    seen = {start}
    q = deque([___])
    while q:
        st = q.popleft()
]]
        ),
        answer = "start",
        accept = { "start" },
        hint = L(
          "The parameter, the station already in seen on the line above.",
          "매개변수, 윗줄에서 이미 seen에 들어간 역.",
          "個參數，上一行已經喺 seen 裏面嗰個站。"
        ),
        ok = L(
          "BFS explores outward in rings: everything one stop away, then two. The first path found is the shortest.",
          "BFS는 고리 모양으로 바깥으로 탐색: 한 정거장 거리 전부, 그다음 두 정거장. 처음 찾은 경로가 최단.",
          "BFS 一環一環向外探索：一個站距離嘅全部，再兩個站。第一條搵到嘅路就係最短。"
        ),
      },
      {
        topic = "ENQUEUE",
        q = L(
          "A new neighbour: mark it seen when you enqueue it. Which set method?",
          "새 이웃: enqueue할 때 본 것으로 표시. 어떤 set 메서드?",
          "新鄰站：入隊嗰陣就標記見過。邊個 set method？"
        ),
        code = L(
          [[
    while q:
        st = q.popleft()
        for nb in g[st]:
            if nb not in seen:
                seen.___(nb)
                q.append(nb)
]],
          [[
    while q:
        st = q.popleft()
        for nb in g[st]:
            if nb not in seen:
                seen.___(nb)
                q.append(nb)
]],
          [[
    while q:
        st = q.popleft()
        for nb in g[st]:
            if nb not in seen:
                seen.___(nb)
                q.append(nb)
]]
        ),
        answer = "add",
        accept = { "add" },
        hint = L(
          "Three letters. Lists append; sets do this.",
          "세 글자. 리스트는 append, set은 이것.",
          "三個字母。list 用 append；set 用呢個。"
        ),
        ok = L(
          "Mark on enqueue, not on dequeue, or a station can be queued twice from two neighbours.",
          "dequeue가 아니라 enqueue 시 표시. 아니면 한 역이 두 이웃에서 두 번 큐에 들어간다.",
          "入隊嗰陣標記，唔係出隊嗰陣，否則一個站可以由兩個鄰站入隊兩次。"
        ),
      },
      {
        topic = "DFS",
        q = L(
          "Depth first, recursive: visit, then call yourself on each unseen neighbour. Fill the call.",
          "깊이 우선, 재귀: 방문, 그다음 안 본 이웃마다 자신을 호출. 호출을 채워라.",
          "深度優先，遞歸：探訪，然後對每個未見過嘅鄰站 call 自己。填個 call。"
        ),
        code = L(
          [[
def dfs(g, st, seen):
    seen.add(st)
    print(st)
    for nb in g[st]:
        if nb not in seen:
            ___(g, nb, seen)
]],
          [[
def dfs(g, st, seen):
    seen.add(st)
    print(st)
    for nb in g[st]:
        if nb not in seen:
            ___(g, nb, seen)
]],
          [[
def dfs(g, st, seen):
    seen.add(st)
    print(st)
    for nb in g[st]:
        if nb not in seen:
            ___(g, nb, seen)
]]
        ),
        answer = "dfs",
        accept = { "dfs" },
        hint = L(
          "The function's own name. The recursion is the stack.",
          "함수 자신의 이름. 재귀가 곧 스택.",
          "個 function 自己嘅名。遞歸就係個 stack。"
        ),
        ok = L(
          "DFS dives down one line before backing up. Same O(V + E) as BFS. Mind the 1000-deep recursion limit. Round three to Bo.",
          "DFS는 한 갈래로 끝까지 내려간 뒤 돌아온다. BFS와 같은 O(V + E). 재귀 한도 1000에 주의. 3라운드는 보에게.",
          "DFS 沿一條線潛到底先返轉頭。同 BFS 一樣 O(V + E)。小心 1000 層遞歸上限。第三回合寶廚贏。"
        ),
      },
    },
  },
  {
    id = "py_list",
    station = "LIST",
    name = L("ROUND 4  -  the chain", "라운드 4  -  체인", "第四回合  -  鏈"),
    title = L("Linked lists", "연결 리스트", "linked list"),
    lesson = L(
      "A ListNode holds val and next. Reverse with three names: prev, cur, nxt. Two runners find the middle; if the fast one meets the slow one, there is a cycle.",
      "ListNode는 val과 next를 가진다. 역순은 이름 셋: prev, cur, nxt. 러너 둘이 중간을 찾고, 빠른 쪽이 느린 쪽을 만나면 사이클.",
      "ListNode 有 val 同 next。倒轉用三個名：prev、cur、nxt。兩個 runner 搵中點；快嗰個撞到慢嗰個就係有 cycle。"
    ),
    bg = "bg_street",
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
          "Round four: a linked list. Reverse it, find the middle, catch the loop.",
          "4라운드: 연결 리스트. 뒤집고, 중간을 찾고, 루프를 잡기.",
          "第四回合：linked list。倒轉佢、搵中點、捉個 loop。"
        ),
      },
    },
    viz = "python",
    chips = {
      { "self.next = None", "cyan" },
      { "cur.next = prev", "gold" },
      { "fast = fast.next.next", "pink" },
      { "slow is fast", "green" },
    },
    note = "None  prev  nxt  next  is",
    story = L(
      "Round four. A chain of delivery stops, each pointing to the next. Bo reverses it in place, "
        .. "sends two riders down it at different speeds to find the middle, and checks whether the route loops.",
      "4라운드. 다음을 가리키는 배달 지점의 체인. 보는 제자리에서 뒤집고, 속도가 다른 라이더 둘을 보내 중간을 찾고, 경로가 순환하는지 확인한다.",
      "第四回合。一條外賣點嘅鏈，每個指向下一個。寶廚就地倒轉佢，"
        .. "派兩個唔同速度嘅車手行落去搵中點，再檢查條路有冇 loop。"
    ),
    stages = {
      {
        topic = "NODE",
        q = L(
          "The last stop points nowhere. What is next set to at creation?",
          "마지막 지점은 아무 데도 가리키지 않는다. 생성 시 next는 무엇으로?",
          "最後一站唔指向任何地方。建立嗰陣 next 設做咩？"
        ),
        code = L(
          [[
class ListNode:
    def __init__(self, val):
        self.val = val
        self.next = ___
]],
          [[
class ListNode:
    def __init__(self, val):
        self.val = val
        self.next = ___
]],
          [[
class ListNode:
    def __init__(self, val):
        self.val = val
        self.next = ___
]]
        ),
        answer = "None",
        accept = { "None" },
        hint = L(
          "The end of every Python chain, capital N.",
          "모든 Python 체인의 끝, 대문자 N.",
          "每條 Python 鏈嘅盡頭，大楷 N。"
        ),
        ok = L(
          "None terminates the list. Walk with while node: and stop when it is falsy.",
          "None이 리스트를 끝낸다. while node:로 걷고 거짓이 되면 멈춘다.",
          "None 終止個 list。用 while node: 行，falsy 就停。"
        ),
      },
      {
        topic = "REVERSE",
        q = L(
          "Reverse in place: point the current node back at the one before it. Fill: cur.next = ___",
          "제자리 역순: 현재 노드가 그 앞 노드를 가리키게. 채워라: cur.next = ___",
          "就地倒轉：令當前 node 指返前面嗰個。填：cur.next = ___"
        ),
        code = L(
          [[
def reverse(head):
    prev, cur = None, head
    while cur:
        nxt = cur.next
        cur.next = ___
        prev, cur = cur, nxt
    return prev
]],
          [[
def reverse(head):
    prev, cur = None, head
    while cur:
        nxt = cur.next
        cur.next = ___
        prev, cur = cur, nxt
    return prev
]],
          [[
def reverse(head):
    prev, cur = None, head
    while cur:
        nxt = cur.next
        cur.next = ___
        prev, cur = cur, nxt
    return prev
]]
        ),
        answer = "prev",
        accept = { "prev" },
        hint = L(
          "The node that was before cur, saved on the first line. That is what reversing means.",
          "cur 앞에 있던 노드, 첫 줄에 저장된 것. 그게 뒤집기의 뜻.",
          "喺 cur 前面嗰個 node，第一行存起嗰個。呢個就係倒轉嘅意思。"
        ),
        ok = L(
          "Save nxt, flip the pointer, step. Three names, one pass, O(1) space. The tuple swap on the last line steps both.",
          "nxt 저장, 포인터 뒤집기, 전진. 이름 셋, 한 번 통과, O(1) 공간. 마지막 줄의 튜플 스왑이 둘을 함께 전진.",
          "存 nxt、反轉 pointer、行前一步。三個名，一次過，O(1) 空間。最後一行嘅 tuple swap 兩個一齊行。"
        ),
      },
      {
        topic = "STEP",
        q = L(
          "After flipping, move on: prev becomes cur, and cur becomes the saved node. Fill it.",
          "뒤집은 뒤 전진: prev는 cur가 되고, cur는 저장한 노드가 된다. 채워라.",
          "反轉之後行前：prev 變 cur，cur 變存起嗰個 node。填佢。"
        ),
        code = L(
          [[
    while cur:
        nxt = cur.next
        cur.next = prev
        prev = cur
        cur = ___
    return prev
]],
          [[
    while cur:
        nxt = cur.next
        cur.next = prev
        prev = cur
        cur = ___
    return prev
]],
          [[
    while cur:
        nxt = cur.next
        cur.next = prev
        prev = cur
        cur = ___
    return prev
]]
        ),
        answer = "nxt",
        accept = { "nxt" },
        hint = L(
          "The name saved on the first line of the loop, before the pointer was flipped. cur.next is no longer it.",
          "포인터를 뒤집기 전 루프 첫 줄에 저장한 이름. cur.next는 이제 그것이 아니다.",
          "loop 第一行、反轉 pointer 之前存起嘅名。cur.next 已經唔係佢。"
        ),
        ok = L(
          "cur = nxt: without saving it first, the flip would have cut the rest of the chain loose.",
          "cur = nxt: 먼저 저장하지 않았다면 뒤집기가 나머지 체인을 끊어버렸을 것.",
          "cur = nxt：唔先存起佢，反轉嗰下就會將條鏈其餘部分切斷。"
        ),
      },
      {
        topic = "RUNNERS",
        q = L(
          "Find the middle: slow moves one, fast moves two. Fill the fast step: fast = fast.next.___",
          "중간 찾기: slow는 하나, fast는 둘. fast 전진을 채워라: fast = fast.next.___",
          "搵中點：slow 行一步，fast 行兩步。填 fast 嘅一步：fast = fast.next.___"
        ),
        code = L(
          [[
def middle(head):
    slow = fast = head
    while fast and fast.next:
        slow = slow.next
        fast = fast.next.___
    return slow
]],
          [[
def middle(head):
    slow = fast = head
    while fast and fast.next:
        slow = slow.next
        fast = fast.next.___
    return slow
]],
          [[
def middle(head):
    slow = fast = head
    while fast and fast.next:
        slow = slow.next
        fast = fast.next.___
    return slow
]]
        ),
        answer = "next",
        accept = { "next" },
        hint = L(
          "The pointer field, twice in a row. The while condition guards both hops.",
          "포인터 필드를 연달아 두 번. while 조건이 두 번의 도약을 지킨다.",
          "個 pointer field，連續兩次。while 條件守住兩步。"
        ),
        ok = L(
          "When fast reaches the end, slow is halfway. One pass, no length count.",
          "fast가 끝에 닿을 때 slow는 중간. 한 번 통과, 길이 세기 없음.",
          "fast 到尾嗰陣 slow 喺中間。一次過，唔使數長度。"
        ),
      },
      {
        topic = "CYCLE",
        q = L(
          "Floyd's check: if the fast rider ever lands on the slow one, the route loops. Which operator compares identity?",
          "플로이드 검사: 빠른 라이더가 느린 라이더와 같은 노드에 서면 경로가 순환. 동일성을 비교하는 연산자는?",
          "Floyd 檢查：快車手撞正慢車手嗰陣，條路就有 loop。邊個運算符比較同一性？"
        ),
        code = L(
          [[
def has_cycle(head):
    slow = fast = head
    while fast and fast.next:
        slow, fast = slow.next, fast.next.next
        if slow ___ fast:
            return True
    return False
]],
          [[
def has_cycle(head):
    slow = fast = head
    while fast and fast.next:
        slow, fast = slow.next, fast.next.next
        if slow ___ fast:
            return True
    return False
]],
          [[
def has_cycle(head):
    slow = fast = head
    while fast and fast.next:
        slow, fast = slow.next, fast.next.next
        if slow ___ fast:
            return True
    return False
]]
        ),
        answer = "is",
        accept = { "is", "==" },
        hint = L(
          "Two letters: the same object, not merely equal values. == would work here too, but this is the honest one.",
          "두 글자: 값이 같은 게 아니라 같은 객체. ==도 여기선 되지만 이게 정직한 쪽.",
          "兩個字母：同一個 object，唔係只係值相等。== 呢度都得，但呢個先係老實嗰個。"
        ),
        ok = L(
          "is compares identity. Two riders in a loop must meet; on a straight route fast falls off the end. Round four to Bo.",
          "is는 동일성 비교. 루프 안의 라이더 둘은 반드시 만나고, 직선 경로에선 fast가 끝에서 떨어진다. 4라운드는 보에게.",
          "is 比較同一性。loop 裏面兩個車手一定會撞到；直路 fast 會行到尾跌出去。第四回合寶廚贏。"
        ),
      },
    },
  },
  {
    id = "py_sort",
    station = "SORT",
    name = L("ROUND 5  -  the shuffle", "라운드 5  -  셔플", "第五回合  -  洗牌"),
    title = L("Merge sort and binary search", "병합 정렬과 이진 탐색", "合併排序同二元搜尋"),
    lesson = L(
      "Merge sort: split at len // 2, sort both halves, merge with <=. sorted and list.sort take key=. bisect finds a slot in a sorted list in O(log n).",
      "병합 정렬: len // 2에서 나누고 양쪽을 정렬하고 <=로 병합. sorted와 list.sort는 key=를 받는다. bisect는 정렬된 리스트의 자리를 O(log n)에 찾는다.",
      "合併排序：喺 len // 2 分開，兩邊排好，用 <= 合併。sorted 同 list.sort 收 key=。bisect 用 O(log n) 喺排好序嘅 list 搵位。"
    ),
    bg = "bg_times",
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
          "Round five: sort the night's receipts. Write merge sort, then use the built-ins like a grown-up.",
          "5라운드: 오늘 밤 영수증 정렬. 병합 정렬을 쓰고, 그다음 어른답게 내장 함수를 쓰기.",
          "第五回合：排好今晚嘅收據。寫 merge sort，然後好似大人咁用內建。"
        ),
      },
    },
    viz = "python",
    chips = {
      { "mid = len(a) // 2", "cyan" },
      { "if l[i] <= r[j]:", "gold" },
      { "words.sort(key=len)", "pink" },
      { "bisect_left(a, x)", "green" },
    },
    note = "//  mid  <=  len  bisect_left",
    story = L(
      "Round five. A shoebox of receipts on the screen. Bo writes merge sort by hand for the crowd, "
        .. "then admits that sorted() has been Timsort all along, and finds a receipt by amount with bisect.",
      "5라운드. 화면에 영수증이 든 신발 상자. 보는 관중을 위해 병합 정렬을 손으로 쓰고, "
        .. "sorted()가 원래 Timsort였음을 인정하고, bisect로 금액으로 영수증을 찾는다.",
      "第五回合。螢幕上一個鞋盒裝住收據。寶廚為觀眾手寫 merge sort，"
        .. "然後承認 sorted() 一直都係 Timsort，再用 bisect 按金額搵收據。"
    ),
    stages = {
      {
        topic = "SPLIT",
        q = L(
          "Merge sort splits in the middle. Which operator gives a whole-number midpoint?",
          "병합 정렬은 중간에서 나눈다. 정수 중간점을 주는 연산자는?",
          "merge sort 喺中間分開。邊個運算符畀整數中點？"
        ),
        code = L(
          [[
def msort(a):
    if len(a) <= 1:
        return a
    mid = len(a) ___ 2
    return merge(msort(a[:mid]), msort(a[mid:]))
]],
          [[
def msort(a):
    if len(a) <= 1:
        return a
    mid = len(a) ___ 2
    return merge(msort(a[:mid]), msort(a[mid:]))
]],
          [[
def msort(a):
    if len(a) <= 1:
        return a
    mid = len(a) ___ 2
    return merge(msort(a[:mid]), msort(a[mid:]))
]]
        ),
        answer = "//",
        accept = { "//" },
        hint = L(
          "Two slashes: floor division. A single slash would make 3.5 and the slice would raise TypeError.",
          "슬래시 두 개: 내림 나눗셈. 하나면 3.5가 되고 슬라이스에서 TypeError.",
          "兩條斜線：向下除。一條會出 3.5，slice 就拋 TypeError。"
        ),
        ok = L(
          "len(a) // 2 splits [3, 1, 2] into [3] and [1, 2]. Each level halves; log2(n) levels.",
          "len(a) // 2는 [3, 1, 2]를 [3]과 [1, 2]로 나눈다. 레벨마다 절반, log2(n) 레벨.",
          "len(a) // 2 將 [3, 1, 2] 分做 [3] 同 [1, 2]。每層一半；log2(n) 層。"
        ),
      },
      {
        topic = "MERGE",
        q = L(
          "Merge two sorted halves: take from the left while its item is no bigger. Which comparison keeps the sort stable?",
          "정렬된 두 절반을 병합: 왼쪽 항목이 더 크지 않은 동안 왼쪽에서 가져온다. 정렬을 안정적으로 유지하는 비교는?",
          "合併兩個排好序嘅一半：左邊項目唔大過右邊就攞左邊。邊個比較保持排序穩定？"
        ),
        code = L(
          [[
def merge(l, r):
    out, i, j = [], 0, 0
    while i < len(l) and j < len(r):
        if l[i] ___ r[j]:
            out.append(l[i]); i += 1
        else:
            out.append(r[j]); j += 1
]],
          [[
def merge(l, r):
    out, i, j = [], 0, 0
    while i < len(l) and j < len(r):
        if l[i] ___ r[j]:
            out.append(l[i]); i += 1
        else:
            out.append(r[j]); j += 1
]],
          [[
def merge(l, r):
    out, i, j = [], 0, 0
    while i < len(l) and j < len(r):
        if l[i] ___ r[j]:
            out.append(l[i]); i += 1
        else:
            out.append(r[j]); j += 1
]]
        ),
        answer = "<=",
        accept = { "<=" },
        hint = L(
          "Less than or equal. With a strict < equal items would swap order and the sort would not be stable.",
          "작거나 같다. 엄격한 <면 같은 항목의 순서가 바뀌어 안정 정렬이 아니다.",
          "小於或等於。用嚴格 < 相等嘅項目會調位，排序就唔穩定。"
        ),
        ok = L(
          "<= takes the left item on ties, so equal receipts keep their order. Merge is O(n); the whole sort O(n log n).",
          "<=는 같을 때 왼쪽을 택해 같은 영수증의 순서가 유지된다. 병합은 O(n), 전체는 O(n log n).",
          "<= 打和嗰陣攞左邊，所以相同收據保持次序。merge 係 O(n)；整個排序 O(n log n)。"
        ),
      },
      {
        topic = "MID",
        q = L(
          "Binary search: the target is bigger than a[mid]. Where does lo move?",
          "이진 탐색: 목표가 a[mid]보다 크다. lo는 어디로?",
          "二元搜尋：目標大過 a[mid]。lo 移去邊？"
        ),
        code = L(
          [[
def search(a, x):
    lo, hi = 0, len(a)
    while lo < hi:
        mid = (lo + hi) // 2
        if a[mid] == x: return mid
        if a[mid] < x: lo = ___ + 1
        else: hi = mid
]],
          [[
def search(a, x):
    lo, hi = 0, len(a)
    while lo < hi:
        mid = (lo + hi) // 2
        if a[mid] == x: return mid
        if a[mid] < x: lo = ___ + 1
        else: hi = mid
]],
          [[
def search(a, x):
    lo, hi = 0, len(a)
    while lo < hi:
        mid = (lo + hi) // 2
        if a[mid] == x: return mid
        if a[mid] < x: lo = ___ + 1
        else: hi = mid
]]
        ),
        answer = "mid",
        accept = { "mid" },
        hint = L(
          "The index just checked, plus one: everything up to it is too small.",
          "방금 확인한 인덱스에 1을 더한 것: 거기까지는 전부 너무 작다.",
          "剛剛檢查過嘅 index 加一：去到佢為止全部太細。"
        ),
        ok = L(
          "lo = mid + 1 drops the left half. Each step halves the range: O(log n). The array must be sorted first.",
          "lo = mid + 1이 왼쪽 절반을 버린다. 단계마다 범위가 절반: O(log n). 배열은 먼저 정렬돼 있어야.",
          "lo = mid + 1 丟掉左半邊。每步範圍減半：O(log n)。array 要先排好序。"
        ),
      },
      {
        topic = "KEY",
        q = L(
          "Sort the dish names shortest first, in place. Which built-in is the key?",
          "요리 이름을 짧은 것부터 제자리 정렬. key로 쓰는 내장 함수는?",
          "將菜名由最短開始就地排序。key 用邊個內建 function？"
        ),
        code = L(
          [[
words = ["noodles", "tea", "toast"]
words.sort(key=___)
print(words)     # ['tea', 'toast', 'noodles']
]],
          [[
words = ["noodles", "tea", "toast"]
words.sort(key=___)
print(words)     # ['tea', 'toast', 'noodles']
]],
          [[
words = ["noodles", "tea", "toast"]
words.sort(key=___)
print(words)     # ['tea', 'toast', 'noodles']
]]
        ),
        answer = "len",
        accept = { "len" },
        hint = L(
          "The function that measures a string, passed by name, no parentheses.",
          "문자열을 재는 함수, 괄호 없이 이름으로 전달.",
          "量度字串嘅 function，用名傳入，唔加括號。"
        ),
        ok = L(
          "key= is called once per item; sort by its result. sorted(words, key=str.lower) is the case-insensitive classic.",
          "key=는 항목마다 한 번 호출되고 그 결과로 정렬. sorted(words, key=str.lower)가 대소문자 무시의 고전.",
          "key= 每個項目 call 一次；按結果排序。sorted(words, key=str.lower) 係唔分大小楷嘅經典。"
        ),
      },
      {
        topic = "BISECT",
        q = L(
          "Find where 38 belongs in the sorted amounts in O(log n). Which bisect function?",
          "정렬된 금액에서 38의 자리를 O(log n)에 찾기. 어떤 bisect 함수?",
          "用 O(log n) 喺排好序嘅金額搵 38 應該喺邊。邊個 bisect function？"
        ),
        code = L(
          [[
import bisect

amounts = [6, 12, 38, 52]
i = bisect.___(amounts, 38)
print(i)     # 2
]],
          [[
import bisect

amounts = [6, 12, 38, 52]
i = bisect.___(amounts, 38)
print(i)     # 2
]],
          [[
import bisect

amounts = [6, 12, 38, 52]
i = bisect.___(amounts, 38)
print(i)     # 2
]]
        ),
        answer = "bisect_left",
        accept = { "bisect_left", "bisect" },
        hint = L(
          "The module's name, an underscore, and the side an equal item is inserted on: the left one here.",
          "모듈 이름, 밑줄, 그리고 같은 항목이 삽입되는 쪽: 여기선 왼쪽.",
          "module 個名、一條底線、同相等項目插入嘅一邊：呢度係左。"
        ),
        ok = L(
          "bisect_left returns the first index >= x; bisect_right the one after equals. insort inserts. Round five to Bo.",
          "bisect_left는 x 이상인 첫 인덱스, bisect_right는 같은 값들 뒤. insort는 삽입. 5라운드는 보에게.",
          "bisect_left 回傳第一個 >= x 嘅 index；bisect_right 係相等項目之後。insort 插入。第五回合寶廚贏。"
        ),
      },
    },
  },
  {
    id = "py_hash",
    station = "HASH",
    name = L("ROUND 6  -  the classics", "라운드 6  -  고전", "第六回合  -  經典"),
    title = L(
      "Two-sum, anagrams, palindromes",
      "두 수의 합, 애너그램, 회문",
      "two-sum、anagram、palindrome"
    ),
    lesson = L(
      "Two-sum: a dict of seen values, one pass. Anagram: sorted(a) == sorted(b), or a Counter. Palindrome: two pointers from both ends.",
      "두 수의 합: 본 값들의 dict, 한 번 통과. 애너그램: sorted(a) == sorted(b) 또는 Counter. 회문: 양끝에서 포인터 둘.",
      "two-sum：見過嘅值放 dict，一次過。anagram：sorted(a) == sorted(b)，或者 Counter。palindrome：兩端各一個 pointer。"
    ),
    bg = "bg_queue",
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
          "Round six: the three questions every interview asks. Two-sum, anagram, palindrome. Go!",
          "6라운드: 모든 면접이 묻는 세 문제. 두 수의 합, 애너그램, 회문. 시작!",
          "第六回合：每個面試都會問嘅三條題。two-sum、anagram、palindrome。開始！"
        ),
      },
    },
    viz = "python",
    chips = {
      { "if target - x in seen:", "cyan" },
      { "sorted(a) == sorted(b)", "gold" },
      { "i, j = 0, len(s) - 1", "pink" },
      { "Counter(word)", "green" },
    },
    note = "seen  i  sorted  -  Counter",
    story = L(
      "Round six. The classics: which two receipts add up to the till's total, are two dish names anagrams, "
        .. "is the shop's slogan a palindrome. A dict, a sort and two pointers. The crowd knows these; Bo has to be fast.",
      "6라운드. 고전: 어떤 두 영수증이 계산대 합계가 되나, 두 요리 이름이 애너그램인가, 가게 슬로건이 회문인가. dict, 정렬, 포인터 둘. 관중도 아는 문제, 보는 빨라야 한다.",
      "第六回合。經典題：邊兩張收據加埋係收銀機總數、兩個菜名係唔係 anagram、間舖嘅口號係唔係 palindrome。"
        .. "一個 dict、一次排序、兩個 pointer。觀眾都識；寶廚要快。"
    ),
    stages = {
      {
        topic = "TWOSUM",
        q = L(
          "Two-sum in one pass: for each x, is target minus x already known? Which dict is checked?",
          "한 번 통과로 두 수의 합: 각 x에 대해 target 빼기 x를 이미 아는가? 어떤 dict를 검사?",
          "一次過 two-sum：每個 x，target 減 x 係唔係已經知？檢查邊個 dict？"
        ),
        code = L(
          [[
def two_sum(nums, target):
    seen = {}
    for i, x in enumerate(nums):
        if target - x in ___:
            return seen[target - x], i
        seen[x] = i
]],
          [[
def two_sum(nums, target):
    seen = {}
    for i, x in enumerate(nums):
        if target - x in ___:
            return seen[target - x], i
        seen[x] = i
]],
          [[
def two_sum(nums, target):
    seen = {}
    for i, x in enumerate(nums):
        if target - x in ___:
            return seen[target - x], i
        seen[x] = i
]]
        ),
        answer = "seen",
        accept = { "seen" },
        hint = L(
          "The dict from the first line of the body, value to index.",
          "본문 첫 줄의 dict, 값에서 인덱스로.",
          "body 第一行嘅 dict，值對應 index。"
        ),
        ok = L(
          "O(n) with a dict instead of O(n^2) with two loops. Check before storing so x does not pair with itself.",
          "루프 둘의 O(n^2) 대신 dict로 O(n). 저장 전에 검사해서 x가 자기 자신과 짝이 되지 않게.",
          "用 dict 係 O(n)，兩個 loop 係 O(n^2)。先檢查再存，x 就唔會同自己配對。"
        ),
      },
      {
        topic = "STORE",
        q = L(
          "No partner yet: remember this value and where it was. What is stored under seen[x]?",
          "아직 짝이 없다: 이 값과 위치를 기억. seen[x]에 무엇을 저장?",
          "暫時冇伴：記住呢個值同佢喺邊。seen[x] 存咩？"
        ),
        code = L(
          [[
def two_sum(nums, target):
    seen = {}
    for i, x in enumerate(nums):
        if target - x in seen:
            return seen[target - x], i
        seen[x] = ___
]],
          [[
def two_sum(nums, target):
    seen = {}
    for i, x in enumerate(nums):
        if target - x in seen:
            return seen[target - x], i
        seen[x] = ___
]],
          [[
def two_sum(nums, target):
    seen = {}
    for i, x in enumerate(nums):
        if target - x in seen:
            return seen[target - x], i
        seen[x] = ___
]]
        ),
        answer = "i",
        accept = { "i" },
        hint = L(
          "The index enumerate hands out, one letter. The return line reads it back.",
          "enumerate가 내주는 인덱스, 한 글자. return 줄이 그걸 다시 읽는다.",
          "enumerate 交出嚟嘅 index，一個字母。return 嗰行讀返佢。"
        ),
        ok = L(
          "seen[x] = i maps value to position. Returning (seen[target - x], i) gives the pair of indexes the question wants.",
          "seen[x] = i는 값을 위치에 매핑. (seen[target - x], i)를 반환하면 문제가 원하는 인덱스 쌍.",
          "seen[x] = i 將值對應位置。回傳 (seen[target - x], i) 就係題目要嘅 index 對。"
        ),
      },
      {
        topic = "ANAGRAM",
        q = L(
          "Two words are anagrams if their letters, put in order, match. Which built-in orders them?",
          "두 단어의 글자를 순서대로 놓았을 때 같으면 애너그램. 순서대로 놓는 내장 함수는?",
          "兩個字嘅字母排好序後一樣就係 anagram。邊個內建 function 排佢們？"
        ),
        code = L(
          [[
def anagram(a, b):
    return ___(a) == sorted(b)

print(anagram("listen", "silent"))   # True
]],
          [[
def anagram(a, b):
    return ___(a) == sorted(b)

print(anagram("listen", "silent"))   # True
]],
          [[
def anagram(a, b):
    return ___(a) == sorted(b)

print(anagram("listen", "silent"))   # True
]]
        ),
        answer = "sorted",
        accept = { "sorted" },
        hint = L(
          "The same function the right side of the == already uses. It takes a string and returns a list of characters.",
          "==의 오른콈이 이미 쓰는 함수. 문자열을 받아 문자 리스트를 반환.",
          "== 右邊已經用嘅同一個 function。收一個 string，回傳一個字元 list。"
        ),
        ok = L(
          "sorted(a) == sorted(b) is O(n log n) and one line. Counter(a) == Counter(b) is O(n) and just as short.",
          "sorted(a) == sorted(b)는 O(n log n)이고 한 줄. Counter(a) == Counter(b)는 O(n)이고 똑같이 짧다.",
          "sorted(a) == sorted(b) 係 O(n log n)，一行。Counter(a) == Counter(b) 係 O(n)，一樣短。"
        ),
      },
      {
        topic = "POINTERS",
        q = L(
          "Palindrome with two pointers: i at the start, j at the end. Fill: j = len(s) ___ 1",
          "포인터 둘로 회문: i는 시작, j는 끝. 채워라: j = len(s) ___ 1",
          "兩個 pointer 做 palindrome：i 喺頭，j 喺尾。填：j = len(s) ___ 1"
        ),
        code = L(
          [[
def palindrome(s):
    i, j = 0, len(s) ___ 1
    while i < j:
        if s[i] != s[j]:
            return False
        i, j = i + 1, j - 1
    return True
]],
          [[
def palindrome(s):
    i, j = 0, len(s) ___ 1
    while i < j:
        if s[i] != s[j]:
            return False
        i, j = i + 1, j - 1
    return True
]],
          [[
def palindrome(s):
    i, j = 0, len(s) ___ 1
    while i < j:
        if s[i] != s[j]:
            return False
        i, j = i + 1, j - 1
    return True
]]
        ),
        answer = "-",
        accept = { "-" },
        hint = L(
          "Indexes start at 0, so the last one is the length less one. One character.",
          "인덱스는 0부터라 마지막은 길이에서 하나 뺀 것. 한 글자.",
          "index 由 0 開始，所以最後一個係長度減一。一個字元。"
        ),
        ok = L(
          "len(s) - 1 is the last index. Two pointers meet in the middle: O(n) time, O(1) space. s == s[::-1] is the one-liner.",
          "len(s) - 1이 마지막 인덱스. 포인터 둘이 중간에서 만난다: O(n) 시간, O(1) 공간. s == s[::-1]이 한 줄 버전.",
          "len(s) - 1 係最後一個 index。兩個 pointer 喺中間相遇：O(n) 時間，O(1) 空間。s == s[::-1] 係一行版。"
        ),
      },
      {
        topic = "COUNTER",
        q = L(
          "Count each letter of a word in one call. Which collections class?",
          "단어의 각 글자를 한 번의 호출로 세기. collections의 어떤 클래스?",
          "一個 call 數晒一個字每個字母。collections 嘅邊個 class？"
        ),
        code = L(
          [[
from collections import ___

c = ___("noodles")
print(c["o"])     # 2
]],
          [[
from collections import ___

c = ___("noodles")
print(c["o"])     # 2
]],
          [[
from collections import ___

c = ___("noodles")
print(c["o"])     # 2
]]
        ),
        answer = "Counter",
        accept = { "Counter" },
        hint = L(
          "A thing that counts, capitalized. It is a dict subclass with 0 for missing keys.",
          "세는 것, 대문자로. 없는 키에 0을 주는 dict의 서브클래스.",
          "數數嘅嘢，大楷。係 dict 嘅 subclass，冇嘅 key 畀 0。"
        ),
        ok = L(
          "Counter(word).most_common(1) gives the top letter. Go's count[c-'a']++ in one line. Round six to Bo.",
          "Counter(word).most_common(1)이 최다 글자. Go의 count[c-'a']++를 한 줄로. 6라운드는 보에게.",
          "Counter(word).most_common(1) 畀最多嗰個字母。Go 嘅 count[c-'a']++ 一行搞掂。第六回合寶廚贏。"
        ),
      },
    },
  },
  {
    id = "py_workers",
    station = "WORKERS",
    name = L("ROUND 7  -  the kitchen", "라운드 7  -  주방", "第七回合  -  廚房"),
    title = L("A worker pool with queue.Queue", "queue.Queue로 만든 워커 풀", "用 queue.Queue 做 worker pool"),
    lesson = L(
      "queue.Queue is thread-safe: put adds a job, get takes one, task_done marks it finished, join waits until every job is done.",
      "queue.Queue는 스레드 안전: put이 작업을 넣고, get이 하나 꺼내고, task_done이 완료 표시, join은 모든 작업이 끝날 때까지 기다린다.",
      "queue.Queue 係 thread-safe：put 加一個 job，get 攞一個，task_done 標記完成，join 等到所有 job 做完。"
    ),
    bg = "bg_kitchen",
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
          "Final round: a worker pool. Three cooks, one queue, nine orders. Nothing lost, nothing done twice.",
          "마지막 라운드: 워커 풀. 요리사 셋, 큐 하나, 주문 아홉. 잃는 것도 두 번 하는 것도 없이.",
          "最後回合：worker pool。三個廚師、一條隊、九張單。一張都唔漏，一張都唔重做。"
        ),
      },
      {
        kind = "hero",
        x = 900,
        facing = -1,
        line = L(
          "Channels in Go, mpsc in Rust, and now a Queue. Same kitchen every time.",
          "Go의 채널, Rust의 mpsc, 이제 Queue. 매번 같은 주방이네.",
          "Go 用 channel，Rust 用 mpsc，而家係 Queue。每次都係同一個廚房。"
        ),
      },
    },
    viz = "python",
    chips = {
      { "q = queue.Queue()", "cyan" },
      { "job = q.get()", "gold" },
      { "q.task_done()", "pink" },
      { "q.join()", "green" },
    },
    note = "Queue  put  get  task_done  join",
    story = L(
      "The final round. Three cook threads pull orders from one queue and fry them. Bo has to feed the queue, "
        .. "drain it safely, mark every job finished and wait for the last one before the receipt prints. Then the screen says HIRED.",
      "마지막 라운드. 요리사 스레드 셋이 큐 하나에서 주문을 꺼내 부친다. 보는 큐를 채우고, 안전하게 비우고, "
        .. "작업마다 완료 표시를 하고, 영수증이 찍히기 전 마지막 하나를 기다려야 한다. 그러면 화면에 HIRED.",
      "最後回合。三個廚師 thread 由一條隊攞單煎。寶廚要餵隊、安全地清隊、"
        .. "每個 job 標記完成，並喺收據印出前等埋最後一個。然後螢幕寫住 HIRED。"
    ),
    stages = {
      {
        topic = "QUEUE",
        q = L(
          "A thread-safe queue of orders. Which class from the queue module?",
          "스레드 안전한 주문 큐. queue 모듈의 어떤 클래스?",
          "一條 thread-safe 嘅訂單隊。queue module 嘅邊個 class？"
        ),
        code = L(
          [[
import queue, threading

jobs = queue.___()
]],
          [[
import queue, threading

jobs = queue.___()
]],
          [[
import queue, threading

jobs = queue.___()
]]
        ),
        answer = "Queue",
        accept = { "Queue" },
        hint = L(
          "The module's name, capitalized. Not deque: that one has no locks.",
          "모듈 이름의 대문자 버전. deque가 아니다: 그건 락이 없다.",
          "module 個名，大楷。唔係 deque：嗰個冇鎖。"
        ),
        ok = L(
          "queue.Queue locks every operation. Queue(maxsize=3) blocks put when full: a buffered channel.",
          "queue.Queue는 모든 연산에 락. Queue(maxsize=3)는 가득 차면 put이 막힌다: 버퍼 채널.",
          "queue.Queue 每個操作都上鎖。Queue(maxsize=3) 滿嗰陣 put 會 block：即係 buffered channel。"
        ),
      },
      {
        topic = "PUT",
        q = L(
          "Feed nine orders into the queue. Which method adds one?",
          "주문 아홉을 큐에 넣기. 하나를 추가하는 메서드는?",
          "將九張單放入隊。邊個 method 加一張？"
        ),
        code = L(
          [[
for order in range(1, 10):
    jobs.___(order)
]],
          [[
for order in range(1, 10):
    jobs.___(order)
]],
          [[
for order in range(1, 10):
    jobs.___(order)
]]
        ),
        answer = "put",
        accept = { "put" },
        hint = L(
          "Three letters, the opposite of the method a worker calls. Go's jobs <- order.",
          "세 글자, 워커가 호출하는 메서드의 반대. Go의 jobs <- order.",
          "三個字母，worker call 嘅 method 嘅相反。Go 嘅 jobs <- order。"
        ),
        ok = L(
          "put blocks only when maxsize is reached. put_nowait raises queue.Full instead.",
          "put은 maxsize에 닿았을 때만 막힌다. put_nowait는 대신 queue.Full을 던진다.",
          "put 只有到 maxsize 先會 block。put_nowait 改為拋 queue.Full。"
        ),
      },
      {
        topic = "GET",
        q = L(
          "A cook takes the next order, waiting if the queue is empty. Which method?",
          "요리사가 다음 주문을 가져가고, 큐가 비면 기다린다. 어떤 메서드?",
          "廚師攞下一張單，隊空就等。邊個 method？"
        ),
        code = L(
          [[
def cook():
    while True:
        order = jobs.___()
        fry(order)
        jobs.task_done()
]],
          [[
def cook():
    while True:
        order = jobs.___()
        fry(order)
        jobs.task_done()
]],
          [[
def cook():
    while True:
        order = jobs.___()
        fry(order)
        jobs.task_done()
]]
        ),
        answer = "get",
        accept = { "get" },
        hint = L(
          "Three letters, the opposite of put. Go's <-jobs.",
          "세 글자, put의 반대. Go의 <-jobs.",
          "三個字母，put 嘅相反。Go 嘅 <-jobs。"
        ),
        ok = L(
          "get blocks until an item arrives; get(timeout=1) raises queue.Empty. Three cooks each block on the same call.",
          "get은 항목이 올 때까지 막힌다. get(timeout=1)은 queue.Empty를 던진다. 요리사 셋이 같은 호출에서 막혀 기다린다.",
          "get block 到有項目為止；get(timeout=1) 拋 queue.Empty。三個廚師都喺同一個 call 上等。"
        ),
      },
      {
        topic = "DONE",
        q = L(
          "After frying, tell the queue this job is finished so join can count it. Which method?",
          "부친 뒤 큐에 이 작업이 끝났다고 알려 join이 셀 수 있게. 어떤 메서드?",
          "煎完之後話畀隊知呢個 job 做完，join 先數得到。邊個 method？"
        ),
        code = L(
          [[
def cook():
    while True:
        order = jobs.get()
        fry(order)
        jobs.___()
]],
          [[
def cook():
    while True:
        order = jobs.get()
        fry(order)
        jobs.___()
]],
          [[
def cook():
    while True:
        order = jobs.get()
        fry(order)
        jobs.___()
]]
        ),
        answer = "task_done",
        accept = { "task_done" },
        hint = L(
          "Two words with an underscore: the task, and the state it is now in.",
          "밑줄로 이은 두 단어: 작업, 그리고 지금 놓인 상태.",
          "兩個字用底線連住：個 task，同佢而家嘅狀態。"
        ),
        ok = L(
          "Every get must be paired with a task_done, or join waits forever. Go's wg.Done().",
          "모든 get은 task_done과 짝이어야 한다. 아니면 join이 영원히 기다린다. Go의 wg.Done().",
          "每個 get 一定要配一個 task_done，否則 join 永遠等。Go 嘅 wg.Done()。"
        ),
      },
      {
        topic = "JOIN",
        q = L(
          "Main waits until all nine orders are marked done, then prints the receipt. Which queue method?",
          "메인은 주문 아홉이 모두 완료 표시될 때까지 기다린 뒤 영수증을 찍는다. 어떤 큐 메서드?",
          "main 等到九張單全部標記完成先印收據。邊個 queue method？"
        ),
        code = L(
          [[
for _ in range(3):
    threading.Thread(target=cook, daemon=True).start()
jobs.___()
print("all nine served")
]],
          [[
for _ in range(3):
    threading.Thread(target=cook, daemon=True).start()
jobs.___()
print("all nine served")
]],
          [[
for _ in range(3):
    threading.Thread(target=cook, daemon=True).start()
jobs.___()
print("all nine served")
]]
        ),
        answer = "join",
        accept = { "join" },
        hint = L(
          "Four letters, the same word as Thread.join, but on the queue: wait until the count of unfinished tasks is zero.",
          "네 글자, Thread.join과 같은 단어지만 큐에: 미완료 작업 수가 0이 될 때까지 기다린다.",
          "四個字母，同 Thread.join 同一個字，但係對隊用：等未完成 task 數變零。"
        ),
        ok = L(
          "jobs.join() returns when every put has a matching task_done. daemon=True lets the idle cooks die with main. Seven rounds, no misses. HIRED, at midnight, in Python.",
          "jobs.join()은 모든 put에 task_done이 짝지어졌을 때 반환. daemon=True로 놀고 있는 요리사는 메인과 함께 종료. 일곱 라운드 무실수. 심야에, Python으로, HIRED.",
          "jobs.join() 喺每個 put 都配到 task_done 嗰陣返。daemon=True 令閒住嘅廚師同 main 一齊收工。七個回合零失誤。午夜，用 Python，HIRED。"
        ),
      },
    },
  },
}

return maps
