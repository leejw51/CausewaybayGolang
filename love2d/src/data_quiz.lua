-- Quest 4 QUIZ: the coding interview. After lunch a Times Square startup
-- runs a Go coding quiz. Seven classic problems; the blanks of one street
-- together form the algorithm.
-- Same shape as src/data.lua: the blank ___ is NOT written in the code.

local function L(en, ko, yue)
  return { en = en, ko = ko, yue = yue }
end

local maps = {
  {
    id = "recurse",
    station = "RECURSE",
    name = L("ROUND 1  -  the buzzer", "라운드 1  -  버저", "第一回合  -  蜂鳴器"),
    title = L("Recursion and memoization", "재귀와 메모이제이션", "遞歸同 memoization"),
    lesson = L(
      "A recursive func needs a base case and a smaller call. A memo map turns fib from 2^n into n.",
      "재귀 함수엔 기저 조건과 더 작은 호출이 필요. memo 맵이 fib를 2^n에서 n으로 만든다.",
      "遞歸 function 要有 base case 同一個細啲嘅 call。memo map 將 fib 由 2^n 變 n。"
    ),
    bg = "bg_mall",
    portrait = "portrait_hero",
    speaker = L("Alex", "알렉스", "阿力"),
    ground = 348,
    spawn = 180,
    width = 1600,
    npcs = {
      {
        kind = "clerk",
        x = 560,
        facing = -1,
        line = L(
          "Welcome to CODE RUSH! Round one: factorial, then fib without the exponential blowup. Buzzer's live!",
          "코드 러시에 오신 걸 환영합니다! 1라운드: 팩토리얼, 그리고 지수 폭발 없는 fib. 버저 켜졌습니다!",
          "歡迎嚟到 CODE RUSH！第一回合：階乘，然後係唔會指數爆炸嘅 fib。蜂鳴器開咗！"
        ),
      },
    },
    viz = "recurse",
    story = L(
      "13:00. CODE RUSH, the live coding show on the Times Square screen. A crowd, a buzzer, "
        .. "seven rounds. Answer without a miss to keep the combo. Round one: recursion, and why fib needs a memo.",
      "13:00. 타임스퀘어 전광판의 라이브 코딩 쇼, 코드 러시. 관중, 버저, "
        .. "일곱 라운드. 실수 없이 답하면 콤보가 이어진다. 1라운드: 재귀, 그리고 fib에 memo가 필요한 이유.",
      "下晝一點。CODE RUSH，時代廣場大螢幕嘅直播 coding show。有觀眾、有蜂鳴器、"
        .. "七個回合。冇失誤就可以保持連擊。第一回合：遞歸，同埋點解 fib 要 memo。"
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
func fact(n int) int {
    if n <= 1 {
        return ___          // base case
    }
    return n * fact(n-1)
}
]],
          [[
func fact(n int) int {
    if n <= 1 {
        return ___          // 기저 조건
    }
    return n * fact(n-1)
}
]],
          [[
func fact(n int) int {
    if n <= 1 {
        return ___          // base case
    }
    return n * fact(n-1)
}
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
          "Base case first, always. Without it the stack overflows.",
          "기저 조건이 항상 먼저. 없으면 스택 오버플로.",
          "Base case 永遠行先。冇佢就 stack overflow。"
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
func fact(n int) int {
    if n <= 1 {
        return 1
    }
    return n * fact(___)    // toward the base case
}
]],
          [[
func fact(n int) int {
    if n <= 1 {
        return 1
    }
    return n * fact(___)    // 기저 조건 쪽으로
}
]],
          [[
func fact(n int) int {
    if n <= 1 {
        return 1
    }
    return n * fact(___)    // 行向 base case
}
]]
        ),
        answer = "n-1",
        accept = { "n-1", "n - 1" },
        hint = L(
          "One less than n. fact(n) would never terminate.",
          "n보다 하나 작게. fact(n)이면 절대 끝나지 않는다.",
          "n 減一。fact(n) 永遠唔會完。"
        ),
        ok = L(
          "Each call handles one step and delegates the rest: n * (n-1)!",
          "각 호출은 한 단계만 처리하고 나머지를 위임: n * (n-1)!",
          "每個 call 處理一步，其餘交出去：n * (n-1)!"
        ),
      },
      {
        topic = "MEMO",
        q = L(
          "Return the cached answer if it is there. Fill the comma-ok test: if v, ok := memo[n]; ___",
          "캐시된 답이 있으면 반환. comma-ok 검사: if v, ok := memo[n]; ___",
          "有 cache 就直接回傳。comma-ok 檢查：if v, ok := memo[n]; ___"
        ),
        code = L(
          [[
var memo = map[int]int{}

func fib(n int) int {
    if v, ok := memo[n]; ___ {
        return v            // seen before
    }
]],
          [[
var memo = map[int]int{}

func fib(n int) int {
    if v, ok := memo[n]; ___ {
        return v            // 전에 계산함
    }
]],
          [[
var memo = map[int]int{}

func fib(n int) int {
    if v, ok := memo[n]; ___ {
        return v            // 之前計過
    }
]]
        ),
        answer = "ok",
        accept = { "ok" },
        hint = L(
          "The bool from the map lookup. True when the key exists.",
          "맵 조회의 bool. 키가 있으면 true.",
          "map lookup 嘅 bool。key 存在就 true。"
        ),
        ok = L(
          "Memoization: check the map before computing. fib(90) becomes instant.",
          "메모이제이션: 계산 전에 맵을 확인. fib(90)이 즉시 나온다.",
          "Memoization：計之前先查 map。fib(90) 即刻有答案。"
        ),
      },
      {
        topic = "STORE",
        q = L(
          "Compute, remember, return. Fill the second term: fib(n-1) + fib(___)",
          "계산하고, 기억하고, 반환. 둘째 항: fib(n-1) + fib(___)",
          "計、記住、回傳。第二項：fib(n-1) + fib(___)"
        ),
        code = L(
          [[
    if n < 2 {
        return n
    }
    memo[n] = fib(n-1) + fib(___)
    return memo[n]
}
]],
          [[
    if n < 2 {
        return n
    }
    memo[n] = fib(n-1) + fib(___)
    return memo[n]
}
]],
          [[
    if n < 2 {
        return n
    }
    memo[n] = fib(n-1) + fib(___)
    return memo[n]
}
]]
        ),
        answer = "n-2",
        accept = { "n-2", "n - 2" },
        hint = L(
          "Each Fibonacci number is the sum of the two before it.",
          "피보나치 수는 앞의 두 수의 합.",
          "每個 Fibonacci 數係前面兩個嘅和。"
        ),
        ok = L(
          "Store into memo[n] before returning. Same shape works for any overlapping subproblem.",
          "반환 전에 memo[n]에 저장. 겹치는 부분 문제라면 같은 형태로 된다.",
          "回傳之前存入 memo[n]。任何重疊子問題都可以用同一個寫法。"
        ),
      },
    },
  },
  {
    id = "tree",
    station = "TREE",
    name = L("ROUND 2  -  the tree", "라운드 2  -  트리", "第二回合  -  樹"),
    title = L("Binary search tree", "이진 탐색 트리", "二元搜尋樹"),
    lesson = L(
      "A tree node holds *Node children. insert recurses left or right until nil. height is 1 + max of both sides.",
      "트리 노드는 *Node 자식을 갖는다. insert는 nil까지 왼쪽/오른쪽으로 재귀. height는 1 + 양쪽 최대.",
      "樹嘅 node 有 *Node 子節點。insert 向左或右遞歸直到 nil。height 係 1 + 兩邊最大值。"
    ),
    bg = "bg_mall",
    portrait = "portrait_friends",
    speaker = L("Mei", "메이", "阿美"),
    ground = 348,
    spawn = 180,
    width = 1600,
    npcs = {
      {
        kind = "mei",
        x = 560,
        facing = -1,
        line = L(
          "Smaller goes left, bigger goes right. Draw it before you type it.",
          "작으면 왼쪽, 크면 오른쪽. 치기 전에 그려봐.",
          "細嘅去左，大嘅去右。打之前先畫出嚟。"
        ),
      },
    },
    viz = "tree",
    story = L(
      "Problem two: a binary search tree of order numbers. Insert, walk in order, measure the height. "
        .. "In Go a tree is just a struct with two pointers and a nil at every leaf.",
      "두 번째 문제: 주문 번호의 이진 탐색 트리. 삽입, 중위 순회, 높이 측정. "
        .. "Go에서 트리는 포인터 둘과 잎마다 nil이 있는 구조체일 뿐.",
      "第二條：訂單號碼嘅二元搜尋樹。插入、中序走一次、量高度。"
        .. "喺 Go 入面，樹不過係一個有兩個 pointer、每塊葉係 nil 嘅 struct。"
    ),
    stages = {
      {
        topic = "NODE",
        q = L(
          "A node points at two children of its own type. Fill the field type: Left, Right ___",
          "노드는 같은 타입의 자식 둘을 가리킨다. 필드 타입: Left, Right ___",
          "一個 node 指住兩個同 type 嘅子節點。field type：Left, Right ___"
        ),
        code = L(
          [[
type Node struct {
    Val         int
    Left, Right ___      // nil at the leaves
}
]],
          [[
type Node struct {
    Val         int
    Left, Right ___      // 잎에서는 nil
}
]],
          [[
type Node struct {
    Val         int
    Left, Right ___      // 葉係 nil
}
]]
        ),
        answer = "*Node",
        accept = { "*Node" },
        hint = L(
          "A pointer, or the struct would contain itself forever. Star then the type.",
          "포인터여야 한다, 아니면 구조체가 자기 자신을 무한히 담는다. 별표 다음 타입.",
          "要用 pointer，唔係個 struct 會無限包住自己。星然後 type。"
        ),
        ok = L(
          "Recursive types need a pointer. nil children mark the end.",
          "재귀 타입엔 포인터가 필요. nil 자식이 끝을 표시.",
          "遞歸 type 要用 pointer。nil 子節點就係盡頭。"
        ),
      },
      {
        topic = "LEAF",
        q = L(
          "Reached an empty spot: make the node here. Fill: if n == ___",
          "빈 자리에 도착: 여기에 노드를 만든다: if n == ___",
          "去到空位：喺呢度整個 node：if n == ___"
        ),
        code = L(
          [[
func insert(n *Node, v int) *Node {
    if n == ___ {
        return &Node{Val: v}
    }
]],
          [[
func insert(n *Node, v int) *Node {
    if n == ___ {
        return &Node{Val: v}
    }
]],
          [[
func insert(n *Node, v int) *Node {
    if n == ___ {
        return &Node{Val: v}
    }
]]
        ),
        answer = "nil",
        accept = { "nil" },
        hint = L(
          "The zero pointer. This is the base case of the tree recursion.",
          "제로 포인터. 트리 재귀의 기저 조건.",
          "零值 pointer。呢個係樹遞歸嘅 base case。"
        ),
        ok = L(
          "nil check first, then recurse. insert returns the (possibly new) subtree root.",
          "nil 검사 먼저, 그 다음 재귀. insert는 (새로울 수 있는) 서브트리 루트를 반환.",
          "先 check nil，再遞歸。insert 回傳（可能係新嘅）子樹 root。"
        ),
      },
      {
        topic = "INSERT",
        q = L(
          "Smaller values go left. Fill: n.Left = insert(n.___, v)",
          "작은 값은 왼쪽으로: n.Left = insert(n.___, v)",
          "細嘅值去左邊：n.Left = insert(n.___, v)"
        ),
        code = L(
          [[
    if v < n.Val {
        n.Left = insert(n.___, v)
    } else {
        n.Right = insert(n.Right, v)
    }
    return n
}
]],
          [[
    if v < n.Val {
        n.Left = insert(n.___, v)
    } else {
        n.Right = insert(n.Right, v)
    }
    return n
}
]],
          [[
    if v < n.Val {
        n.Left = insert(n.___, v)
    } else {
        n.Right = insert(n.Right, v)
    }
    return n
}
]]
        ),
        answer = "Left",
        accept = { "Left" },
        hint = L(
          "Recurse into the same side you assign to. Mirror of the else branch.",
          "대입하는 쪽과 같은 쪽으로 재귀. else 분기의 거울.",
          "遞歸入你 assign 嗰一邊。else 分支嘅鏡像。"
        ),
        ok = L(
          "BST invariant: left < node <= right. Average insert is O(log n).",
          "BST 불변식: left < node <= right. 평균 삽입 O(log n).",
          "BST 不變式：left < node <= right。平均插入 O(log n)。"
        ),
      },
      {
        topic = "INORDER",
        q = L(
          "Print the values sorted: left subtree, node, right subtree. Fill the first call.",
          "값을 정렬된 순서로 출력: 왼쪽, 노드, 오른쪽. 첫 호출을 채워라.",
          "按排序印出值：左子樹、node、右子樹。填第一個 call。"
        ),
        code = L(
          [[
func inorder(n *Node) {
    if n == nil { return }
    ___(n.Left)
    fmt.Println(n.Val)
    inorder(n.Right)
}
]],
          [[
func inorder(n *Node) {
    if n == nil { return }
    ___(n.Left)
    fmt.Println(n.Val)
    inorder(n.Right)
}
]],
          [[
func inorder(n *Node) {
    if n == nil { return }
    ___(n.Left)
    fmt.Println(n.Val)
    inorder(n.Right)
}
]]
        ),
        answer = "inorder",
        accept = { "inorder" },
        hint = L(
          "The function calls itself. Same name as on the last line.",
          "함수가 자기 자신을 호출. 마지막 줄과 같은 이름.",
          "個 function call 返自己。同最後一行一樣嘅名。"
        ),
        ok = L(
          "In-order on a BST yields sorted output. Pre-order: node first. Post-order: node last.",
          "BST의 중위 순회는 정렬된 출력. 전위: 노드 먼저. 후위: 노드 마지막.",
          "BST 嘅中序會出排好序嘅結果。前序：node 先。後序：node 最後。"
        ),
      },
      {
        topic = "HEIGHT",
        q = L(
          "Height is one plus the taller subtree. Fill: 1 + max(height(n.Left), height(n.___))",
          "높이는 더 높은 서브트리 + 1: 1 + max(height(n.Left), height(n.___))",
          "高度係較高嘅子樹加一：1 + max(height(n.Left), height(n.___))"
        ),
        code = L(
          [[
func height(n *Node) int {
    if n == nil {
        return 0
    }
    return 1 + max(height(n.Left), height(n.___))
}
]],
          [[
func height(n *Node) int {
    if n == nil {
        return 0
    }
    return 1 + max(height(n.Left), height(n.___))
}
]],
          [[
func height(n *Node) int {
    if n == nil {
        return 0
    }
    return 1 + max(height(n.Left), height(n.___))
}
]]
        ),
        answer = "Right",
        accept = { "Right" },
        hint = L(
          "The other child. max is a Go 1.21 built-in.",
          "다른 쪽 자식. max는 Go 1.21 내장 함수.",
          "另一個子節點。max 係 Go 1.21 內置。"
        ),
        ok = L(
          "Most tree questions are this shape: nil returns a base value, else combine both sides.",
          "대부분의 트리 문제는 이 형태: nil이면 기저값, 아니면 양쪽을 합친다.",
          "大部分樹嘅題目都係咁：nil 回傳 base 值，否則合併兩邊。"
        ),
      },
    },
  },
  {
    id = "graph",
    station = "GRAPH",
    name = L("ROUND 3  -  the map", "라운드 3  -  노선도", "第三回合  -  路線圖"),
    title = L("BFS and DFS", "BFS와 DFS", "BFS 同 DFS"),
    lesson = L(
      "BFS: a slice as a queue, pop the front with q[1:]. DFS: recursion plus a visited map.",
      "BFS: 슬라이스를 큐로, q[1:]로 앞을 꺼낸다. DFS: 재귀와 visited 맵.",
      "BFS：用 slice 做 queue，q[1:] 攞走前面。DFS：遞歸加 visited map。"
    ),
    bg = "bg_mtr",
    portrait = "portrait_officer",
    speaker = L("Chef Bo", "보 셰프", "寶廚"),
    ground = 348,
    spawn = 180,
    width = 1680,
    npcs = {
      {
        kind = "cook",
        x = 600,
        facing = -1,
        line = L(
          "The MTR map is a graph. Level by level is BFS; as deep as you can is DFS.",
          "MTR 노선도는 그래프. 층별로는 BFS, 끝까지 파고들면 DFS.",
          "港鐵路線圖係一個 graph。逐層行係 BFS；一路行到底係 DFS。"
        ),
      },
    },
    viz = "graph",
    story = L(
      "Problem three: walk the MTR graph. Breadth-first with a queue for shortest hops, "
        .. "depth-first with recursion for reachability. Both need a visited set.",
      "세 번째 문제: MTR 그래프 순회. 최단 홉은 큐를 쓰는 너비 우선, "
        .. "도달 가능성은 재귀를 쓰는 깊이 우선. 둘 다 visited 집합이 필요.",
      "第三條：行港鐵 graph。用 queue 嘅 breadth-first 搵最少站，"
        .. "用遞歸嘅 depth-first 睇可唔可以到。兩個都要 visited set。"
    ),
    stages = {
      {
        topic = "VISITED",
        q = L(
          "A set of seen stations. Fill the value type: map[string]___",
          "본 역들의 집합. 값 타입: map[string]___",
          "去過嘅站嘅 set。value type：map[string]___"
        ),
        code = L(
          [[
visited := map[string]___{}
queue := []string{"Causeway Bay"}
visited["Causeway Bay"] = true
]],
          [[
visited := map[string]___{}
queue := []string{"Causeway Bay"}
visited["Causeway Bay"] = true
]],
          [[
visited := map[string]___{}
queue := []string{"Causeway Bay"}
visited["Causeway Bay"] = true
]]
        ),
        answer = "bool",
        accept = { "bool" },
        hint = L(
          "Go has no set type; a map to this type is the idiom. struct{} also works.",
          "Go에는 set 타입이 없다; 이 타입으로의 맵이 관용구. struct{}도 된다.",
          "Go 冇 set type；map 去呢個 type 係慣用寫法。struct{} 都得。"
        ),
        ok = L(
          "map[K]bool is the everyday set. Missing keys read as false.",
          "map[K]bool이 일상적인 set. 없는 키는 false로 읽힌다.",
          "map[K]bool 係日常嘅 set。冇嘅 key 讀出嚟係 false。"
        ),
      },
      {
        topic = "POP",
        q = L(
          "Take the front station off the queue. Fill: queue = queue[___]",
          "큐 앞의 역을 꺼낸다: queue = queue[___]",
          "由 queue 前面攞走個站：queue = queue[___]"
        ),
        code = L(
          [[
for len(queue) > 0 {
    st := queue[0]
    queue = queue[___]      // dequeue
    fmt.Println(st)
]],
          [[
for len(queue) > 0 {
    st := queue[0]
    queue = queue[___]      // 큐에서 제거
    fmt.Println(st)
]],
          [[
for len(queue) > 0 {
    st := queue[0]
    queue = queue[___]      // dequeue
    fmt.Println(st)
]]
        ),
        answer = "1:",
        accept = { "1:" },
        hint = L(
          "Everything from index 1 to the end. A slice expression, no copy.",
          "인덱스 1부터 끝까지. 슬라이스 식, 복사 없음.",
          "由 index 1 到尾。slice expression，冇 copy。"
        ),
        ok = L(
          "queue[0] then queue[1:] is the Go queue. For big queues use a ring or container/list.",
          "queue[0] 다음 queue[1:]가 Go의 큐. 큰 큐는 링이나 container/list.",
          "queue[0] 然後 queue[1:] 就係 Go 嘅 queue。大 queue 用 ring 或者 container/list。"
        ),
      },
      {
        topic = "PUSH",
        q = L(
          "Unseen neighbours go to the back of the queue. Fill: queue = ___(queue, nb)",
          "안 본 이웃은 큐 뒤로: queue = ___(queue, nb)",
          "未去過嘅鄰站放去 queue 後面：queue = ___(queue, nb)"
        ),
        code = L(
          [[
    for _, nb := range lines[st] {
        if !visited[nb] {
            visited[nb] = true
            queue = ___(queue, nb)   // enqueue
        }
    }
}
]],
          [[
    for _, nb := range lines[st] {
        if !visited[nb] {
            visited[nb] = true
            queue = ___(queue, nb)   // 큐에 추가
        }
    }
}
]],
          [[
    for _, nb := range lines[st] {
        if !visited[nb] {
            visited[nb] = true
            queue = ___(queue, nb)   // enqueue
        }
    }
}
]]
        ),
        answer = "append",
        accept = { "append" },
        hint = L(
          "The slice built-in that grows. Mark visited when you enqueue, not when you pop.",
          "슬라이스를 늘리는 내장 함수. pop이 아니라 enqueue할 때 visited 표시.",
          "加大 slice 嘅內置 function。入 queue 嗰陣就標 visited，唔係 pop 嗰陣。"
        ),
        ok = L(
          "That is BFS: pop front, push unseen neighbours. First arrival is the shortest path.",
          "그게 BFS: 앞을 꺼내고 안 본 이웃을 넣는다. 첫 도착이 최단 경로.",
          "呢個就係 BFS：pop 前面，push 未見過嘅鄰站。第一次到就係最短路。"
        ),
      },
      {
        topic = "DFS",
        q = L(
          "Depth-first: visit, then recurse into each unseen neighbour. Fill the call.",
          "깊이 우선: 방문 후 안 본 이웃마다 재귀. 호출을 채워라.",
          "Depth-first：訪問，然後對每個未見過嘅鄰站遞歸。填個 call。"
        ),
        code = L(
          [[
func dfs(st string, seen map[string]bool) {
    seen[st] = true
    for _, nb := range lines[st] {
        if !seen[nb] { ___(nb, seen) }
    }
}
]],
          [[
func dfs(st string, seen map[string]bool) {
    seen[st] = true
    for _, nb := range lines[st] {
        if !seen[nb] { ___(nb, seen) }
    }
}
]],
          [[
func dfs(st string, seen map[string]bool) {
    seen[st] = true
    for _, nb := range lines[st] {
        if !seen[nb] { ___(nb, seen) }
    }
}
]]
        ),
        answer = "dfs",
        accept = { "dfs" },
        hint = L(
          "The function itself. The map is shared, so a plain map argument works.",
          "함수 자신. 맵은 공유되니 그냥 맵 인자로 충분.",
          "個 function 自己。map 係共用嘅，直接傳 map 就得。"
        ),
        ok = L(
          "DFS is recursion plus a visited set. Maps are reference-like: no pointer needed.",
          "DFS는 재귀 + visited 집합. 맵은 참조처럼 동작: 포인터 불필요.",
          "DFS 係遞歸加 visited set。map 似 reference：唔使 pointer。"
        ),
      },
    },
  },
  {
    id = "list",
    station = "LIST",
    name = L("ROUND 4  -  the chain", "라운드 4  -  체인", "第四回合  -  鏈"),
    title = L("Linked list: reverse, cycle", "연결 리스트: 뒤집기, 순환", "Linked list：反轉、cycle"),
    lesson = L(
      "Reverse with prev/cur/next pointers. Floyd's cycle check: slow moves one, fast moves two.",
      "prev/cur/next 포인터로 뒤집기. Floyd 순환 검사: slow는 한 칸, fast는 두 칸.",
      "用 prev/cur/next pointer 反轉。Floyd cycle 檢查：slow 行一步，fast 行兩步。"
    ),
    bg = "bg_queue",
    portrait = "portrait_clerk",
    speaker = L("Siu Ming", "시우밍", "小明"),
    ground = 348,
    spawn = 180,
    width = 1680,
    npcs = {
      {
        kind = "clerk",
        x = 620,
        facing = -1,
        line = L(
          "The queue is a linked list. Reverse it without allocating, then find the loop.",
          "줄은 연결 리스트. 할당 없이 뒤집고, 순환을 찾아.",
          "條隊係 linked list。唔 allocate 反轉佢，然後搵個 loop。"
        ),
      },
    },
    viz = "list",
    story = L(
      "Problem four: the order queue as a singly linked list. Reverse it in place with three pointers, "
        .. "then detect a cycle with two runners of different speed.",
      "네 번째 문제: 주문 줄을 단일 연결 리스트로. 포인터 셋으로 제자리 뒤집기, "
        .. "그 다음 속도가 다른 두 주자로 순환 감지.",
      "第四條：訂單隊係 singly linked list。用三個 pointer 就地反轉，"
        .. "然後用兩個唔同速度嘅 runner 搵 cycle。"
    ),
    stages = {
      {
        topic = "NEXT",
        q = L(
          "Each node links to the next one. Fill the field type: Next ___",
          "각 노드는 다음 노드로 연결. 필드 타입: Next ___",
          "每個 node 連住下一個。field type：Next ___"
        ),
        code = L(
          [[
type ListNode struct {
    Val  int
    Next ___             // nil at the tail
}
]],
          [[
type ListNode struct {
    Val  int
    Next ___             // 꼬리에서는 nil
}
]],
          [[
type ListNode struct {
    Val  int
    Next ___             // 尾係 nil
}
]]
        ),
        answer = "*ListNode",
        accept = { "*ListNode" },
        hint = L(
          "Pointer to the same struct type, like the tree node.",
          "트리 노드처럼 같은 구조체 타입의 포인터.",
          "同樹 node 一樣，指住同一個 struct type 嘅 pointer。"
        ),
        ok = L(
          "One pointer per node: singly linked. Two (Prev) makes it doubly linked.",
          "노드당 포인터 하나: 단일 연결. 둘(Prev)이면 이중 연결.",
          "每個 node 一個 pointer：singly linked。兩個（Prev）就係 doubly linked。"
        ),
      },
      {
        topic = "REVERSE",
        q = L(
          "Point the current node backwards. Fill: cur.Next = ___",
          "현재 노드를 뒤로 향하게: cur.Next = ___",
          "令現時嘅 node 指返後面：cur.Next = ___"
        ),
        code = L(
          [[
var prev *ListNode
cur := head
for cur != nil {
    next := cur.Next      // save before we cut it
    cur.Next = ___
    prev, cur = cur, next
}
]],
          [[
var prev *ListNode
cur := head
for cur != nil {
    next := cur.Next      // 끊기 전에 저장
    cur.Next = ___
    prev, cur = cur, next
}
]],
          [[
var prev *ListNode
cur := head
for cur != nil {
    next := cur.Next      // 斬之前先存起
    cur.Next = ___
    prev, cur = cur, next
}
]]
        ),
        answer = "prev",
        accept = { "prev" },
        hint = L(
          "The node we just came from. nil on the first step, which becomes the new tail.",
          "방금 지나온 노드. 첫 단계에서는 nil이고 그게 새 꼬리가 된다.",
          "我哋啱啱嚟嘅嗰個 node。第一步係 nil，佢會變新嘅尾。"
        ),
        ok = L(
          "Save next, flip the link, advance both. prev is the new head when the loop ends.",
          "next 저장, 링크 뒤집기, 둘 다 전진. 루프가 끝나면 prev가 새 head.",
          "存 next、反轉 link、兩個一齊前進。loop 完嘅時候 prev 就係新 head。"
        ),
      },
      {
        topic = "STOP",
        q = L(
          "The walk stops when the runner falls off the end. Fill the condition: ___ != nil",
          "주자가 끝에서 떨어지면 순회가 멈춘다. 조건: ___ != nil",
          "個 runner 行出盡頭就停。條件：___ != nil"
        ),
        code = L(
          [[
func reverse(head *ListNode) *ListNode {
    var prev *ListNode
    for cur := head; ___ != nil; {
        cur.Next, prev, cur = prev, cur, cur.Next
    }
    return prev              // new head
}
]],
          [[
func reverse(head *ListNode) *ListNode {
    var prev *ListNode
    for cur := head; ___ != nil; {
        cur.Next, prev, cur = prev, cur, cur.Next
    }
    return prev              // new head
}
]],
          [[
func reverse(head *ListNode) *ListNode {
    var prev *ListNode
    for cur := head; ___ != nil; {
        cur.Next, prev, cur = prev, cur, cur.Next
    }
    return prev              // new head
}
]]
        ),
        answer = "cur",
        accept = { "cur" },
        hint = L(
          "The pointer that walks the list. prev is the new head once it is nil.",
          "리스트를 걷는 포인터. 그게 nil이 되면 prev가 새 head.",
          "行條 list 嗰個 pointer。佢變 nil 嘅時候 prev 就係新 head。"
        ),
        ok = L(
          "The tuple assignment does all three moves at once: Go evaluates the right side first.",
          "튜플 대입이 세 이동을 한 번에: Go는 오른쪽을 먼저 평가.",
          "tuple assignment 一次做晒三個動作：Go 先計右邊。"
        ),
      },
      {
        topic = "RUNNERS",
        q = L(
          "Floyd: fast moves two steps per turn. Fill: fast = fast.Next.___",
          "Floyd: fast는 한 턴에 두 칸: fast = fast.Next.___",
          "Floyd：fast 每轉行兩步：fast = fast.Next.___"
        ),
        code = L(
          [[
slow, fast := head, head
for fast != nil && fast.Next != nil {
    slow = slow.Next
    fast = fast.Next.___
    if slow == fast { return true }   // cycle
}
]],
          [[
slow, fast := head, head
for fast != nil && fast.Next != nil {
    slow = slow.Next
    fast = fast.Next.___
    if slow == fast { return true }   // 순환
}
]],
          [[
slow, fast := head, head
for fast != nil && fast.Next != nil {
    slow = slow.Next
    fast = fast.Next.___
    if slow == fast { return true }   // cycle
}
]]
        ),
        answer = "Next",
        accept = { "Next" },
        hint = L(
          "Next of Next. The loop condition already checked fast.Next is not nil.",
          "Next의 Next. 루프 조건이 fast.Next가 nil이 아님을 이미 확인.",
          "Next 嘅 Next。loop 條件已經 check 咗 fast.Next 唔係 nil。"
        ),
        ok = L(
          "If there is a loop the fast runner laps the slow one. O(1) memory.",
          "순환이 있으면 fast가 slow를 따라잡는다. 메모리 O(1).",
          "有 loop 嘅話 fast 會追到 slow。O(1) memory。"
        ),
      },
    },
  },
  {
    id = "sort",
    station = "SORT",
    name = L("ROUND 5  -  the shuffle", "라운드 5  -  셔플", "第五回合  -  洗牌"),
    title = L("Binary search and merge sort", "이진 탐색과 병합 정렬", "Binary search 同 merge sort"),
    lesson = L(
      "Binary search halves [lo, hi) with mid. Merge sort splits, recurses, and merges two sorted halves.",
      "이진 탐색은 mid로 [lo, hi)를 반으로. 병합 정렬은 나누고, 재귀하고, 정렬된 두 절반을 합친다.",
      "Binary search 用 mid 將 [lo, hi) 減半。Merge sort 分開、遞歸、再合併兩個排好嘅一半。"
    ),
    bg = "bg_times",
    portrait = "portrait_hero",
    speaker = L("Alex", "알렉스", "阿力"),
    ground = 348,
    spawn = 180,
    width = 1680,
    npcs = {
      {
        kind = "mei",
        x = 700,
        facing = -1,
        line = L(
          "Sorted prices. Find 25 in log n. Then sort the unsorted ones in n log n.",
          "정렬된 가격. 25를 log n에 찾아. 그 다음 정렬 안 된 것들을 n log n에 정렬.",
          "排好序嘅價錢。用 log n 搵 25。然後用 n log n 排未排嘅。"
        ),
      },
    },
    viz = "sort",
    story = L(
      "Problem five: search and sort. Binary search on a sorted slice with half-open bounds, "
        .. "then merge sort, the recursion every interviewer loves. And the one-liner from the library.",
      "다섯 번째 문제: 탐색과 정렬. 반열린 구간으로 정렬된 슬라이스를 이진 탐색, "
        .. "그 다음 면접관이 사랑하는 재귀, 병합 정렬. 그리고 라이브러리 한 줄.",
      "第五條：搜尋同排序。用半開區間喺排好嘅 slice 做 binary search，"
        .. "然後係面試官最鍾意嘅遞歸 merge sort。仲有 library 嘅一行。"
    ),
    stages = {
      {
        topic = "MID",
        q = L(
          "The middle index without overflow. Fill: mid := lo + (hi-lo)/___",
          "오버플로 없는 가운데 인덱스: mid := lo + (hi-lo)/___",
          "唔會 overflow 嘅中間 index：mid := lo + (hi-lo)/___"
        ),
        code = L(
          [[
lo, hi := 0, len(a)         // [lo, hi)
for lo < hi {
    mid := lo + (hi-lo)/___
]],
          [[
lo, hi := 0, len(a)         // [lo, hi)
for lo < hi {
    mid := lo + (hi-lo)/___
]],
          [[
lo, hi := 0, len(a)         // [lo, hi)
for lo < hi {
    mid := lo + (hi-lo)/___
]]
        ),
        answer = "2",
        accept = { "2" },
        hint = L(
          "Halve the gap. (lo+hi)/2 can overflow in other languages; this form never does.",
          "간격을 반으로. (lo+hi)/2는 다른 언어에서 오버플로할 수 있다; 이 형태는 안 한다.",
          "將距離減半。(lo+hi)/2 喺其他語言會 overflow；呢個寫法唔會。"
        ),
        ok = L(
          "Half-open [lo, hi): loop while lo < hi, no off-by-one.",
          "반열린 [lo, hi): lo < hi 동안 루프, off-by-one 없음.",
          "半開 [lo, hi)：lo < hi 就 loop，冇 off-by-one。"
        ),
      },
      {
        topic = "NARROW",
        q = L(
          "a[mid] is too small: the answer is to the right. Fill: lo = ___ + 1",
          "a[mid]가 너무 작다: 답은 오른쪽. lo = ___ + 1",
          "a[mid] 太細：答案喺右邊。lo = ___ + 1"
        ),
        code = L(
          [[
    switch {
    case a[mid] == x: return mid
    case a[mid] < x:
        lo = ___ + 1        // drop the left half
    default:
        hi = mid
    }
]],
          [[
    switch {
    case a[mid] == x: return mid
    case a[mid] < x:
        lo = ___ + 1        // 왼쪽 절반 버림
    default:
        hi = mid
    }
]],
          [[
    switch {
    case a[mid] == x: return mid
    case a[mid] < x:
        lo = ___ + 1        // 掉咗左邊一半
    default:
        hi = mid
    }
]]
        ),
        answer = "mid",
        accept = { "mid" },
        hint = L(
          "We already checked mid, so skip past it. hi = mid keeps the half-open rule.",
          "mid는 이미 확인했으니 건너뛴다. hi = mid가 반열린 규칙을 지킨다.",
          "mid 已經 check 過，跳過佢。hi = mid 保持半開規則。"
        ),
        ok = L(
          "A switch with no condition is Go's if-else chain. sort.SearchInts does this for you.",
          "조건 없는 switch가 Go의 if-else 체인. sort.SearchInts가 대신 해준다.",
          "冇條件嘅 switch 係 Go 嘅 if-else chain。sort.SearchInts 幫你做埋。"
        ),
      },
      {
        topic = "MERGE",
        q = L(
          "Merge two sorted halves: take the smaller head and advance that side. Fill: ___++",
          "정렬된 두 절반 병합: 작은 머리를 취하고 그쪽을 전진. ___++",
          "合併兩個排好嘅一半：攞細嗰個頭，推進嗰邊。___++"
        ),
        code = L(
          [[
for i, j := 0, 0; i < len(l) && j < len(r); {
    if l[i] <= r[j] {
        out = append(out, l[i])
        ___++
    } else {
        out = append(out, r[j])
        j++
]],
          [[
for i, j := 0, 0; i < len(l) && j < len(r); {
    if l[i] <= r[j] {
        out = append(out, l[i])
        ___++
    } else {
        out = append(out, r[j])
        j++
]],
          [[
for i, j := 0, 0; i < len(l) && j < len(r); {
    if l[i] <= r[j] {
        out = append(out, l[i])
        ___++
    } else {
        out = append(out, r[j])
        j++
]]
        ),
        answer = "i",
        accept = { "i" },
        hint = L(
          "The index of the left half, mirroring j++ in the else.",
          "왼쪽 절반의 인덱스, else의 j++와 대칭.",
          "左邊一半嘅 index，同 else 入面嘅 j++ 對稱。"
        ),
        ok = L(
          "After the loop append the leftovers: out = append(out, l[i:]...) and r[j:]...",
          "루프 후 남은 것 추가: out = append(out, l[i:]...) 그리고 r[j:]...",
          "loop 之後加返剩低嘅：out = append(out, l[i:]...) 同 r[j:]..."
        ),
      },
      {
        topic = "SPLIT",
        q = L(
          "Merge sort recurses on both halves. Fill: merge(mergeSort(a[:m]), mergeSort(a[___]))",
          "병합 정렬은 양 절반에 재귀: merge(mergeSort(a[:m]), mergeSort(a[___]))",
          "Merge sort 對兩邊遞歸：merge(mergeSort(a[:m]), mergeSort(a[___]))"
        ),
        code = L(
          [[
func mergeSort(a []int) []int {
    if len(a) <= 1 {
        return a
    }
    m := len(a) / 2
    return merge(mergeSort(a[:m]), mergeSort(a[___]))
}
]],
          [[
func mergeSort(a []int) []int {
    if len(a) <= 1 {
        return a
    }
    m := len(a) / 2
    return merge(mergeSort(a[:m]), mergeSort(a[___]))
}
]],
          [[
func mergeSort(a []int) []int {
    if len(a) <= 1 {
        return a
    }
    m := len(a) / 2
    return merge(mergeSort(a[:m]), mergeSort(a[___]))
}
]]
        ),
        answer = "m:",
        accept = { "m:" },
        hint = L(
          "From m to the end. a[:m] and a[m:] cover the slice exactly once.",
          "m부터 끝까지. a[:m]과 a[m:]이 슬라이스를 정확히 한 번 덮는다.",
          "由 m 到尾。a[:m] 同 a[m:] 啱啱好覆蓋成個 slice 一次。"
        ),
        ok = L(
          "Divide, recurse, merge: O(n log n) always. Base case is a slice of length 0 or 1.",
          "나누고, 재귀하고, 합치기: 항상 O(n log n). 기저는 길이 0 또는 1의 슬라이스.",
          "分開、遞歸、合併：永遠 O(n log n)。base case 係長度 0 或 1 嘅 slice。"
        ),
      },
      {
        topic = "LIBRARY",
        q = L(
          "In real code: sort a slice of structs by price. Fill: sort.___(orders, func(i, j int) bool {...})",
          "실제 코드: 구조체 슬라이스를 가격순 정렬. sort.___(orders, func(i, j int) bool {...})",
          "真實 code：將 struct slice 按價錢排序。sort.___(orders, func(i, j int) bool {...})"
        ),
        code = L(
          [[
sort.___(orders, func(i, j int) bool {
    return orders[i].Price < orders[j].Price
})
]],
          [[
sort.___(orders, func(i, j int) bool {
    return orders[i].Price < orders[j].Price
})
]],
          [[
sort.___(orders, func(i, j int) bool {
    return orders[i].Price < orders[j].Price
})
]]
        ),
        answer = "Slice",
        accept = { "Slice" },
        hint = L(
          "sort.Slice with a less function. slices.SortFunc is the generic Go 1.21 way.",
          "less 함수를 받는 sort.Slice. slices.SortFunc가 Go 1.21의 제네릭 방식.",
          "sort.Slice 加一個 less function。slices.SortFunc 係 Go 1.21 嘅 generic 寫法。"
        ),
        ok = L(
          "Know the algorithm for the whiteboard, use the library in production.",
          "화이트보드에선 알고리즘을 알고, 실무에선 라이브러리를 쓴다.",
          "白板上要識演算法，production 就用 library。"
        ),
      },
    },
  },
  {
    id = "hash",
    station = "HASH",
    name = L("ROUND 6  -  the classics", "라운드 6  -  고전", "第六回合  -  經典"),
    title = L("Two-sum, palindrome, anagram", "two-sum, 회문, 애너그램", "Two-sum、回文、anagram"),
    lesson = L(
      "A map turns O(n^2) two-sum into O(n). Two pointers check a palindrome. A [26]int counts letters.",
      "맵이 O(n^2) two-sum을 O(n)으로. 두 포인터로 회문 검사. [26]int로 글자 세기.",
      "map 將 O(n^2) 嘅 two-sum 變 O(n)。兩個 pointer 檢查回文。[26]int 數字母。"
    ),
    bg = "bg_street",
    portrait = "portrait_friends",
    speaker = L("Mei", "메이", "阿美"),
    ground = 348,
    spawn = 160,
    width = 1680,
    npcs = {
      {
        kind = "mei",
        x = 560,
        facing = -1,
        line = L(
          "Every one of these is 'use a map' or 'use two pointers'. Pick the right one.",
          "이것들은 전부 '맵을 써라' 아니면 '포인터 둘을 써라'. 맞는 걸 골라.",
          "呢啲題全部係「用 map」或者「用兩個 pointer」。揀啱嗰個。"
        ),
      },
    },
    viz = "hash",
    story = L(
      "Problem six: the classics. Two numbers that add up to the set price, "
        .. "a palindrome check that handles CJK, and whether two dish names are anagrams.",
      "여섯 번째 문제: 고전들. 세트 가격이 되는 두 수, "
        .. "한중일 글자도 처리하는 회문 검사, 두 메뉴 이름이 애너그램인지.",
      "第六條：經典題。加埋等於套餐價錢嘅兩個數、"
        .. "處理到中日韓字嘅回文檢查、同埋兩個餐名係咪 anagram。"
    ),
    stages = {
      {
        topic = "TWOSUM",
        q = L(
          "Have we seen the partner of x? Fill the lookup: seen[target-x]",
          "x의 짝을 본 적 있나? 조회를 채워라: seen[target-x]",
          "見過 x 嘅拍檔未？填個 lookup：seen[target-x]"
        ),
        code = L(
          [[
seen := map[int]int{}          // value -> index
for i, x := range nums {
    if j, ok := seen[target-___]; ok {
        return []int{j, i}
    }
    seen[x] = i
}
]],
          [[
seen := map[int]int{}          // 값 -> 인덱스
for i, x := range nums {
    if j, ok := seen[target-___]; ok {
        return []int{j, i}
    }
    seen[x] = i
}
]],
          [[
seen := map[int]int{}          // 值 -> index
for i, x := range nums {
    if j, ok := seen[target-___]; ok {
        return []int{j, i}
    }
    seen[x] = i
}
]]
        ),
        answer = "x",
        accept = { "x" },
        hint = L(
          "The current value. Its partner is target minus it.",
          "현재 값. 짝은 target에서 그것을 뺀 값.",
          "而家嘅值。佢嘅拍檔係 target 減佢。"
        ),
        ok = L(
          "One pass, one map: O(n). Store after checking so x does not pair with itself.",
          "한 번 순회, 맵 하나: O(n). 검사 후 저장해야 x가 자기와 짝이 안 된다.",
          "一次 pass 一個 map：O(n)。check 完先存，x 就唔會同自己配對。"
        ),
      },
      {
        topic = "RUNES",
        q = L(
          "Compare characters, not bytes, so 銅鑼灣 works. Fill: r := []___(s)",
          "바이트가 아니라 글자를 비교해 銅鑼灣도 되게: r := []___(s)",
          "比較字元唔係 byte，銅鑼灣都 work：r := []___(s)"
        ),
        code = L(
          [[
func isPalindrome(s string) bool {
    r := []___(s)             // code points
]],
          [[
func isPalindrome(s string) bool {
    r := []___(s)             // 코드 포인트
]],
          [[
func isPalindrome(s string) bool {
    r := []___(s)             // code point
]]
        ),
        answer = "rune",
        accept = { "rune" },
        hint = L(
          "The int32 code point type. Indexing a string gives bytes.",
          "int32 코드 포인트 타입. 문자열 인덱싱은 바이트를 준다.",
          "int32 code point type。直接 index 一個 string 會攞到 byte。"
        ),
        ok = L(
          "[]rune(s) once, then index freely. Interviewers check this in Go.",
          "[]rune(s) 한 번, 그 다음 자유롭게 인덱싱. 면접관이 Go에서 이걸 본다.",
          "[]rune(s) 一次，之後隨便 index。面試官喺 Go 會考呢樣。"
        ),
      },
      {
        topic = "POINTERS",
        q = L(
          "Two pointers walk inward from both ends. Fill the step: i, j = i+1, ___",
          "두 포인터가 양 끝에서 안쪽으로. 한 걸음: i, j = i+1, ___",
          "兩個 pointer 由兩頭向入面行。一步：i, j = i+1, ___"
        ),
        code = L(
          [[
    for i, j := 0, len(r)-1; i < j; i, j = i+1, ___ {
        if r[i] != r[j] {
            return false
        }
    }
    return true
}
]],
          [[
    for i, j := 0, len(r)-1; i < j; i, j = i+1, ___ {
        if r[i] != r[j] {
            return false
        }
    }
    return true
}
]],
          [[
    for i, j := 0, len(r)-1; i < j; i, j = i+1, ___ {
        if r[i] != r[j] {
            return false
        }
    }
    return true
}
]]
        ),
        answer = "j-1",
        accept = { "j-1", "j - 1" },
        hint = L(
          "j moves left as i moves right. Stop when they meet.",
          "i가 오른쪽으로 갈 때 j는 왼쪽으로. 만나면 멈춘다.",
          "i 向右嗰陣 j 向左。相遇就停。"
        ),
        ok = L(
          "Two pointers: O(n) time, O(1) extra space. Same trick for sorted-array pair sums.",
          "두 포인터: 시간 O(n), 추가 공간 O(1). 정렬된 배열의 쌍 합에도 같은 기법.",
          "兩個 pointer：O(n) 時間，O(1) 額外空間。排好序嘅 array 搵 pair sum 都係咁。"
        ),
      },
      {
        topic = "COUNT",
        q = L(
          "Count letters of a, uncount letters of b; all zero means anagram. Fill: count[c-'a']___",
          "a의 글자를 세고 b의 글자를 빼고; 전부 0이면 애너그램. count[c-'a']___",
          "數 a 嘅字母，減 b 嘅字母；全部零就係 anagram。count[c-'a']___"
        ),
        code = L(
          [[
var count [26]int
for _, c := range a {
    count[c-'a']___          // add
}
for _, c := range b {
    count[c-'a']--           // remove
}
]],
          [[
var count [26]int
for _, c := range a {
    count[c-'a']___          // 더하기
}
for _, c := range b {
    count[c-'a']--           // 빼기
}
]],
          [[
var count [26]int
for _, c := range a {
    count[c-'a']___          // 加
}
for _, c := range b {
    count[c-'a']--           // 減
}
]]
        ),
        answer = "++",
        accept = { "++" },
        hint = L(
          "The opposite of the -- below. Go's ++ is a statement, not an expression.",
          "아래 --의 반대. Go의 ++는 식이 아니라 문장.",
          "下面 -- 嘅相反。Go 嘅 ++ 係 statement，唔係 expression。"
        ),
        ok = L(
          "A fixed [26]int beats a map for lowercase ASCII. Then check every count == 0.",
          "소문자 ASCII엔 고정 [26]int가 맵보다 낫다. 그 다음 모든 count == 0 확인.",
          "細楷 ASCII 用固定 [26]int 好過 map。然後 check 每個 count == 0。"
        ),
      },
    },
  },
  {
    id = "workers",
    station = "WORKERS",
    name = L("FINAL  -  the kitchen", "파이널  -  주방", "決賽  -  廚房"),
    title = L("Worker pool and pipeline", "워커 풀과 파이프라인", "Worker pool 同 pipeline"),
    lesson = L(
      "Worker pool: N goroutines range over a jobs channel; close(jobs) ends them; WaitGroup then close(results).",
      "워커 풀: 고루틴 N개가 jobs 채널을 range; close(jobs)로 종료; WaitGroup 후 close(results).",
      "Worker pool：N 個 goroutine range jobs channel；close(jobs) 結束佢哋；WaitGroup 之後 close(results)。"
    ),
    bg = "bg_kitchen",
    portrait = "portrait_officer",
    speaker = L("Chef Bo", "보 셰프", "寶廚"),
    ground = 348,
    spawn = 180,
    width = 1680,
    npcs = {
      {
        kind = "cook",
        x = 580,
        facing = -1,
        line = L(
          "Three cooks, one ticket rail, one pass. That is a worker pool.",
          "요리사 셋, 주문 레일 하나, 패스 하나. 그게 워커 풀.",
          "三個廚師、一條單軌、一個 pass。呢個就係 worker pool。"
        ),
      },
    },
    viz = "workers",
    story = L(
      "Problem seven, the one they always ask: N workers pull jobs from a channel and push results. "
        .. "Get the close and the wait in the right order and the job is yours.",
      "일곱 번째, 늘 나오는 문제: 워커 N개가 채널에서 작업을 꺼내 결과를 밀어 넣는다. "
        .. "close와 wait의 순서를 맞추면 합격.",
      "第七條，佢哋一定會問嘅：N 個 worker 由 channel 攞 job，再推 result 出去。"
        .. "close 同 wait 嘅次序啱，份工就係你嘅。"
    ),
    stages = {
      {
        topic = "WORKER",
        q = L(
          "A worker runs until the jobs channel closes. Fill: for j := ___ jobs",
          "워커는 jobs 채널이 닫힐 때까지 돈다: for j := ___ jobs",
          "Worker 一直行到 jobs channel 閂：for j := ___ jobs"
        ),
        code = L(
          [[
func worker(jobs <-chan int, results chan<- int, wg *sync.WaitGroup) {
    defer wg.Done()
    for j := ___ jobs {      // until close(jobs)
        results <- cook(j)
    }
}
]],
          [[
func worker(jobs <-chan int, results chan<- int, wg *sync.WaitGroup) {
    defer wg.Done()
    for j := ___ jobs {      // close(jobs)까지
        results <- cook(j)
    }
}
]],
          [[
func worker(jobs <-chan int, results chan<- int, wg *sync.WaitGroup) {
    defer wg.Done()
    for j := ___ jobs {      // 直到 close(jobs)
        results <- cook(j)
    }
}
]]
        ),
        answer = "range",
        accept = { "range" },
        hint = L(
          "range over a channel. Note the directional channel types in the signature.",
          "채널 range. 시그니처의 방향 있는 채널 타입에 주목.",
          "range 一個 channel。留意 signature 入面嘅有方向 channel type。"
        ),
        ok = L(
          "Workers are identical goroutines sharing one input channel. The channel is the queue.",
          "워커는 입력 채널 하나를 공유하는 동일한 고루틴들. 채널이 곧 큐.",
          "Worker 係共用一個 input channel 嘅相同 goroutine。個 channel 就係 queue。"
        ),
      },
      {
        topic = "SPAWN",
        q = L(
          "Start three workers, counting each one first. Fill: wg.___(1)",
          "워커 셋을 시작, 각각 먼저 센다: wg.___(1)",
          "開三個 worker，每個先數一次：wg.___(1)"
        ),
        code = L(
          [[
jobs := make(chan int, 10)
results := make(chan int, 10)
var wg sync.WaitGroup
for w := 1; w <= 3; w++ {
    wg.___(1)
    go worker(jobs, results, &wg)
}
]],
          [[
jobs := make(chan int, 10)
results := make(chan int, 10)
var wg sync.WaitGroup
for w := 1; w <= 3; w++ {
    wg.___(1)
    go worker(jobs, results, &wg)
}
]],
          [[
jobs := make(chan int, 10)
results := make(chan int, 10)
var wg sync.WaitGroup
for w := 1; w <= 3; w++ {
    wg.___(1)
    go worker(jobs, results, &wg)
}
]]
        ),
        answer = "Add",
        accept = { "Add" },
        hint = L(
          "Add before go, Done inside, Wait after. Never Add inside the goroutine.",
          "go 전에 Add, 안에서 Done, 후에 Wait. 고루틴 안에서 Add하지 말 것.",
          "go 之前 Add，入面 Done，之後 Wait。千祈唔好喺 goroutine 入面 Add。"
        ),
        ok = L(
          "wg.Add(1) per worker, or wg.Add(3) once. Pass &wg: a WaitGroup must not be copied.",
          "워커마다 wg.Add(1), 또는 한 번 wg.Add(3). &wg로 전달: WaitGroup은 복사 금지.",
          "每個 worker wg.Add(1)，或者一次過 wg.Add(3)。傳 &wg：WaitGroup 唔可以 copy。"
        ),
      },
      {
        topic = "FEED",
        q = L(
          "Send the jobs, then tell the workers there are no more. Which built-in?",
          "작업을 보내고, 워커에게 더 없다고 알린다. 어떤 내장 함수?",
          "送晒啲 job，然後話畀 worker 知冇嘞。咩內置 function？"
        ),
        code = L(
          [[
for j := 1; j <= 9; j++ {
    jobs <- j
}
___(jobs)                    // workers' range loops end
]],
          [[
for j := 1; j <= 9; j++ {
    jobs <- j
}
___(jobs)                    // 워커들의 range 루프 종료
]],
          [[
for j := 1; j <= 9; j++ {
    jobs <- j
}
___(jobs)                    // worker 嘅 range loop 結束
]]
        ),
        answer = "close",
        accept = { "close" },
        hint = L(
          "Only the sender closes. Sending after this panics.",
          "보내는 쪽만 닫는다. 이후에 보내면 panic.",
          "淨係 sender 嗰邊先閂得。閂完再 send 會 panic。"
        ),
        ok = L(
          "close(jobs) is the shutdown signal: every worker's range loop drains and exits.",
          "close(jobs)가 종료 신호: 모든 워커의 range 루프가 비우고 나간다.",
          "close(jobs) 係關機訊號：每個 worker 嘅 range loop 清完就走。"
        ),
      },
      {
        topic = "COLLECT",
        q = L(
          "Close results only after every worker is done. Fill: wg.___(); close(results)",
          "모든 워커가 끝난 뒤에만 results를 닫는다: wg.___(); close(results)",
          "所有 worker 完咗先閂 results：wg.___(); close(results)"
        ),
        code = L(
          [[
go func() {
    wg.___()                 // all workers returned
    close(results)
}()
for r := range results {
    fmt.Println(r)
}
]],
          [[
go func() {
    wg.___()                 // 모든 워커가 반환됨
    close(results)
}()
for r := range results {
    fmt.Println(r)
}
]],
          [[
go func() {
    wg.___()                 // 所有 worker 都 return 咗
    close(results)
}()
for r := range results {
    fmt.Println(r)
}
]]
        ),
        answer = "Wait",
        accept = { "Wait" },
        hint = L(
          "Blocks until the counter is zero. In its own goroutine so main can keep reading.",
          "카운터가 0이 될 때까지 블록. main이 계속 읽도록 별도 고루틴에서.",
          "block 到 counter 係零。放喺自己嘅 goroutine，main 先可以繼續讀。"
        ),
        ok = L(
          "Wait then close(results) in a goroutine: the receiver's range ends cleanly. No leaks.",
          "고루틴에서 Wait 후 close(results): 받는 쪽 range가 깔끔히 끝난다. 누수 없음.",
          "喺 goroutine 入面 Wait 再 close(results)：receiver 嘅 range 乾淨咁完。冇 leak。"
        ),
      },
      {
        topic = "LIMIT",
        q = L(
          "At most 3 requests in flight: a semaphore from a buffered channel. Fill: make(chan struct{}, ___)",
          "동시 요청 최대 3개: 버퍼 채널로 세마포어. make(chan struct{}, ___)",
          "最多 3 個 request 同時進行：用 buffered channel 做 semaphore。make(chan struct{}, ___)"
        ),
        code = L(
          [[
sem := make(chan struct{}, ___)
for _, u := range urls {
    sem <- struct{}{}        // acquire (blocks when full)
    go func(u string) {
        defer func() { <-sem }()   // release
        fetch(u) }(u)
}
]],
          [[
sem := make(chan struct{}, ___)
for _, u := range urls {
    sem <- struct{}{}        // 획득 (가득 차면 블록)
    go func(u string) {
        defer func() { <-sem }()   // 해제
        fetch(u) }(u)
}
]],
          [[
sem := make(chan struct{}, ___)
for _, u := range urls {
    sem <- struct{}{}        // 攞 (滿咗會 block)
    go func(u string) {
        defer func() { <-sem }()   // 放返
        fetch(u) }(u)
}
]]
        ),
        answer = "3",
        accept = { "3" },
        hint = L(
          "The buffer size is the number of tokens. The fourth send waits.",
          "버퍼 크기가 토큰 수. 네 번째 send는 기다린다.",
          "buffer 大小就係 token 數。第四個 send 要等。"
        ),
        ok = L(
          "A buffered channel is a counting semaphore. golang.org/x/sync/semaphore is the weighted version.",
          "버퍼 채널은 카운팅 세마포어. golang.org/x/sync/semaphore가 가중치 버전.",
          "buffered channel 係 counting semaphore。golang.org/x/sync/semaphore 係加權版本。"
        ),
      },
    },
  },
}

return maps
