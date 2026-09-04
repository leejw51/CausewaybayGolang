-- Rust quest 4 CODE RUSH: the evening edition of the interview game show.
-- 19:00 on the Times Square screen. Mei is the contestant, Alex cheers,
-- Siu Ming hosts. Seven classic interview problems in Rust; the blanks of
-- one round together form the algorithm. Prize: HIRED.
-- Same shape as src/data.lua: the blank ___ is NOT written in the code.

local function L(en, ko, yue)
  return { en = en, ko = ko, yue = yue }
end

local maps = {
  {
    id = "rs_recurse",
    station = "RECURSE",
    name = L("ROUND 1  -  the buzzer", "라운드 1  -  버저", "第一回合  -  蜂鳴器"),
    title = L("Recursion and memoization", "재귀와 메모이제이션", "遞歸同 memoization"),
    lesson = L(
      "A recursive fn needs a base case and a smaller call. A HashMap memo turns fib from 2^n into n.",
      "재귀 fn에는 기저 조건과 더 작은 호출이 필요. HashMap memo가 fib를 2^n에서 n으로 만든다.",
      "遞歸 fn 要有 base case 同一個細啲嘅 call。HashMap memo 將 fib 由 2^n 變 n。"
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
          "Evening edition of CODE RUSH! Rust round. Mei, you're up. Factorial, then fib. Buzzer's live!",
          "코드 러시 저녁 편! Rust 라운드. 메이, 나와요. 팩토리얼, 그다음 fib. 버저 켜졌습니다!",
          "CODE RUSH 夜晚場！Rust 回合。阿美，到你。階乘，然後 fib。蜂鳴器開咗！"
        ),
      },
      {
        kind = "hero",
        x = 900,
        facing = -1,
        line = L(
          "Go, Mei! I did this show at lunch. The memo one gets everybody.",
          "메이 힘내! 나 점심에 이 쇼 나갔어. memo 문제에서 다들 걸려.",
          "阿美加油！我中午上過呢個 show。memo 嗰題個個都中招。"
        ),
      },
    },
    viz = "rust",
    chips = {
      { "fn fact(n: u64) -> u64", "cyan" },
      { "HashMap<u64, u64>", "gold" },
      { "memo.insert(n, v)", "pink" },
    },
    note = "base case  n - 1  memo.get  memo.insert  O(n)",
    story = L(
      "19:00. CODE RUSH, the live coding show on the Times Square screen, evening edition: Rust. "
        .. "A crowd, a buzzer, seven rounds, Mei at the keyboard. No misses keeps the combo. Round one: recursion, and why fib needs a memo.",
      "19:00. 타임스퀘어 전광판의 라이브 코딩 쇼 코드 러시, 저녁 편: Rust. "
        .. "관중, 버저, 일곱 라운드, 키보드 앞엔 메이. 실수 없으면 콤보가 이어진다. 1라운드: 재귀, 그리고 fib에 memo가 필요한 이유.",
      "夜晚七點。CODE RUSH，時代廣場大螢幕嘅直播 coding show，夜晚場：Rust。"
        .. "有觀眾、有蜂鳴器、七個回合，阿美坐喺 keyboard 前。冇失誤就保持連擊。第一回合：遞歸，同埋點解 fib 要 memo。"
    ),
    stages = {
      {
        topic = "BASE",
        q = L(
          "Every recursion stops somewhere. fact(0) and fact(1) evaluate to what?",
          "모든 재귀는 어딘가에서 멈춘다. fact(0)과 fact(1)의 값은?",
          "每個遞歸都要有終點。fact(0) 同 fact(1) 係咩值？"
        ),
        code = L(
          [[
fn fact(n: u64) -> u64 {
    if n <= 1 {
        ___                  // base case
    } else {
        n * fact(n - 1)
    }
}
]],
          [[
fn fact(n: u64) -> u64 {
    if n <= 1 {
        ___                  // 기저 조건
    } else {
        n * fact(n - 1)
    }
}
]],
          [[
fn fact(n: u64) -> u64 {
    if n <= 1 {
        ___                  // base case
    } else {
        n * fact(n - 1)
    }
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
          "Base case first, always. Without it the stack overflows. No semicolon: the if is the return value.",
          "기저 조건이 항상 먼저. 없으면 스택 오버플로. 세미콜론 없음: if 자체가 반환값.",
          "Base case 永遠行先。冇佢就 stack overflow。冇分號：個 if 就係回傳值。"
        ),
      },
      {
        topic = "SMALLER",
        q = L(
          "The recursive call must shrink the problem. Fill: n * fact(___)",
          "재귀 호출은 문제를 줄여야 한다: n * fact(___)",
          "遞歸 call 一定要令問題細啲：n * fact(___)"
        ),
        code = L(
          [[
fn fact(n: u64) -> u64 {
    if n <= 1 {
        1
    } else {
        n * fact(___)        // toward the base case
    }
}
]],
          [[
fn fact(n: u64) -> u64 {
    if n <= 1 {
        1
    } else {
        n * fact(___)        // 기저 조건 쪽으로
    }
}
]],
          [[
fn fact(n: u64) -> u64 {
    if n <= 1 {
        1
    } else {
        n * fact(___)        // 向 base case 行
    }
}
]]
        ),
        answer = "n - 1",
        accept = { "n - 1", "n-1" },
        hint = L(
          "One less than n. u64 cannot go below zero, which is why the base case checks <= 1.",
          "n보다 하나 작게. u64는 0 아래로 못 가니 기저 조건이 <= 1을 본다.",
          "n 減一。u64 唔可以細過零，所以 base case 睇 <= 1。"
        ),
        ok = L(
          "Each call is one step closer to 1. fact(20) is the biggest that fits in u64. The crowd claps.",
          "호출마다 1에 한 걸음 가까이. u64에 들어가는 최대는 fact(20). 관중이 박수.",
          "每個 call 都行近 1 一步。u64 裝得落嘅最大係 fact(20)。觀眾拍手。"
        ),
      },
      {
        topic = "MEMO",
        q = L(
          "fib(40) naively is a billion calls. Look the answer up first. Which HashMap method?",
          "순진한 fib(40)은 십억 번 호출. 먼저 답을 찾아본다. HashMap의 어떤 메서드?",
          "fib(40) 直接計要十億次 call。先查吓有冇答案。HashMap 邊個 method？"
        ),
        code = L(
          [[
fn fib(n: u64, memo: &mut HashMap<u64, u64>) -> u64 {
    if n < 2 {
        return n;
    }
    if let Some(&v) = memo.___(&n) {   // seen before?
        return v;
    }
]],
          [[
fn fib(n: u64, memo: &mut HashMap<u64, u64>) -> u64 {
    if n < 2 {
        return n;
    }
    if let Some(&v) = memo.___(&n) {   // 본 적 있나?
        return v;
    }
]],
          [[
fn fib(n: u64, memo: &mut HashMap<u64, u64>) -> u64 {
    if n < 2 {
        return n;
    }
    if let Some(&v) = memo.___(&n) {   // 之前見過？
        return v;
    }
]]
        ),
        answer = "get",
        accept = { "get" },
        hint = L(
          "Three letters. Takes a reference to the key, returns Option<&V>. The &v pattern copies the u64 out.",
          "세 글자. 키의 참조를 받아 Option<&V>를 반환. &v 패턴이 u64를 복사해 꺼낸다.",
          "三個字母。攞 key 嘅 reference，回傳 Option<&V>。&v pattern 將個 u64 copy 出嚟。"
        ),
        ok = L(
          "memo.get(&n) is O(1). Hit: return it. Miss: compute it. That is memoization.",
          "memo.get(&n)은 O(1). 있으면 반환, 없으면 계산. 그게 메모이제이션.",
          "memo.get(&n) 係 O(1)。有就回傳，冇就計。呢個就係 memoization。"
        ),
      },
      {
        topic = "TWOBACK",
        q = L(
          "A miss: compute it from the two smaller ones. Fill the second call: fib(___, memo)",
          "없으면 더 작은 둘로 계산. 두 번째 호출을 채워라: fib(___, memo)",
          "冇嘅話就用細兩個計。填第二個 call：fib(___, memo)"
        ),
        code = L(
          [[
    if let Some(&v) = memo.get(&n) {
        return v;
    }
    // not cached: both neighbours below n
    let v = fib(n - 1, memo) + fib(___, memo);
]],
          [[
    if let Some(&v) = memo.get(&n) {
        return v;
    }
    // 캐시에 없음: n 아래의 이웃 둘
    let v = fib(n - 1, memo) + fib(___, memo);
]],
          [[
    if let Some(&v) = memo.get(&n) {
        return v;
    }
    // 冇 cache：n 下面嘅兩個鄰居
    let v = fib(n - 1, memo) + fib(___, memo);
]]
        ),
        answer = "n - 2",
        accept = { "n - 2", "n-2" },
        hint = L(
          "fib(n) = fib(n-1) + the one before that. The base case n < 2 guarantees this never underflows.",
          "fib(n) = fib(n-1) + 그 앞의 것. 기저 조건 n < 2가 언더플로를 막는다.",
          "fib(n) = fib(n-1) + 再前一個。base case n < 2 保證唔會 underflow。"
        ),
        ok = L(
          "Same &mut memo goes into both calls, one after the other. The borrow checker is happy: they do not overlap.",
          "같은 &mut memo가 두 호출에 차례로 들어간다. 겹치지 않으니 borrow checker도 만족.",
          "同一個 &mut memo 一個跟一個咁入兩個 call。唔重疊，borrow checker 滿意。"
        ),
      },
      {
        topic = "STORE",
        q = L(
          "Computed once, never again. Put v into the memo under key n. Which method?",
          "한 번 계산하면 끝. v를 키 n으로 memo에 넣어라. 어떤 메서드?",
          "計一次就夠。將 v 用 key n 放入 memo。邊個 method？"
        ),
        code = L(
          [[
    let v = fib(n - 1, memo) + fib(n - 2, memo);
    memo.___(n, v);        // remember it for next time
    v
}
]],
          [[
    let v = fib(n - 1, memo) + fib(n - 2, memo);
    memo.___(n, v);        // 다음을 위해 기억
    v
}
]],
          [[
    let v = fib(n - 1, memo) + fib(n - 2, memo);
    memo.___(n, v);        // 記住佢，下次用
    v
}
]]
        ),
        answer = "insert",
        accept = { "insert" },
        hint = L(
          "Takes the key and the value by value. Returns the old value as an Option, which we ignore here.",
          "키와 값을 값으로 받는다. 옛 값을 Option으로 돌려주지만 여기선 무시.",
          "攞 key 同 value 本身。回傳舊值嘅 Option，呢度唔理佢。"
        ),
        ok = L(
          "Each n is computed once: O(n) calls, O(n) memory. Round one, no misses. Combo x1.",
          "n마다 한 번만 계산: 호출 O(n), 메모리 O(n). 1라운드 무실수. 콤보 x1.",
          "每個 n 只計一次：O(n) call，O(n) memory。第一回合零失誤。連擊 x1。"
        ),
      },
    },
  },

  {
    id = "rs_tree",
    station = "TREE",
    name = L("ROUND 2  -  the tree", "라운드 2  -  트리", "第二回合  -  樹"),
    title = L("Binary search tree", "이진 탐색 트리", "二元搜尋樹"),
    lesson = L(
      "A tree node owns Option<Box<Node>> children. insert recurses left or right until None. height is 1 + max of both sides.",
      "트리 노드는 Option<Box<Node>> 자식을 소유. insert는 None까지 왼쪽/오른쪽으로 재귀. height는 1 + 양쪽 최대.",
      "樹嘅 node 擁有 Option<Box<Node>> 子節點。insert 向左或右遞歸直到 None。height 係 1 + 兩邊最大值。"
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
          "Smaller goes left, bigger goes right. In Rust a leaf is None and a child is a Box.",
          "작으면 왼쪽, 크면 오른쪽. Rust에서 잎은 None, 자식은 Box.",
          "細嘅去左，大嘅去右。喺 Rust 入面，葉係 None，子節點係 Box。"
        ),
      },
    },
    viz = "rust",
    chips = {
      { "Option<Box<Node>>", "cyan" },
      { "None => 0", "gold" },
      { "1 + l.max(r)", "green" },
    },
    note = "Box  None  as_ref  inorder  height  O(log n)",
    story = L(
      "19:08. Round two, and the screen shows a tree of order numbers. Insert, walk in order, measure the height. "
        .. "In Rust a tree is a struct with two Option<Box<Node>> fields, and the compiler wants to know its size.",
      "19:08. 2라운드, 화면엔 주문 번호의 트리. 삽입, 중위 순회, 높이 측정. "
        .. "Rust에서 트리는 Option<Box<Node>> 필드 둘을 가진 구조체이고, 컴파일러는 그 크기를 알고 싶어 한다.",
      "七點零八分。第二回合，螢幕出咗一棵訂單號碼嘅樹。插入、中序走一次、量高度。"
        .. "喺 Rust 入面，樹係一個有兩個 Option<Box<Node>> field 嘅 struct，compiler 想知佢有幾大。"
    ),
    stages = {
      {
        topic = "NODE",
        q = L(
          "Node contains Node. The compiler needs a fixed size, so the child lives on the heap behind which pointer?",
          "Node 안에 Node. 컴파일러는 고정 크기가 필요하니 자식은 힙에 둔다. 어떤 포인터 뒤에?",
          "Node 入面有 Node。compiler 要固定大小，所以子節點放喺 heap。用邊個 pointer？"
        ),
        code = L(
          [[
// The child lives on the heap, behind a pointer.
type Link = Option<___<Node>>;
struct Node {
    val: i32,
    left: Link,
    right: Link,
}
]],
          [[
// 자식은 힙에, 포인터 뒤에 산다.
type Link = Option<___<Node>>;
struct Node {
    val: i32,
    left: Link,
    right: Link,
}
]],
          [[
// 子節點住喺 heap，喺 pointer 後面。
type Link = Option<___<Node>>;
struct Node {
    val: i32,
    left: Link,
    right: Link,
}
]]
        ),
        answer = "Box",
        accept = { "Box" },
        hint = L(
          "Three letters. The owned heap pointer: one owner, freed when dropped. Not Rc, nobody shares a child.",
          "세 글자. 소유하는 힙 포인터: 주인 하나, drop 시 해제. Rc 아님, 자식을 공유하지 않는다.",
          "三個字母。擁有嘅 heap pointer：一個主人，drop 就釋放。唔係 Rc，冇人共用子節點。"
        ),
        ok = L(
          "Box<Node> is one pointer wide, so Node has a size. Option<Box<T>> costs nothing extra: None is the null pointer.",
          "Box<Node>는 포인터 하나 크기라 Node에 크기가 생긴다. Option<Box<T>>는 추가 비용 없음: None이 널 포인터.",
          "Box<Node> 得一個 pointer 咁大，所以 Node 有大小。Option<Box<T>> 冇額外成本：None 就係 null pointer。"
        ),
      },
      {
        topic = "LEAF",
        q = L(
          "insert walks down until it finds an empty spot. Which pattern is the empty spot?",
          "insert는 빈자리를 찾을 때까지 내려간다. 빈자리를 나타내는 패턴은?",
          "insert 一路行落去直到搵到空位。空位係邊個 pattern？"
        ),
        code = L(
          [[
fn insert(link: &mut Link, v: i32) {
    match link {
        ___ => *link = Some(Box::new(Node::leaf(v))),
        Some(n) if v < n.val => insert(&mut n.left, v),
        Some(n) => insert(&mut n.right, v),
    }
}
]],
          [[
fn insert(link: &mut Link, v: i32) {
    match link {
        ___ => *link = Some(Box::new(Node::leaf(v))),
        Some(n) if v < n.val => insert(&mut n.left, v),
        Some(n) => insert(&mut n.right, v),
    }
}
]],
          [[
fn insert(link: &mut Link, v: i32) {
    match link {
        ___ => *link = Some(Box::new(Node::leaf(v))),
        Some(n) if v < n.val => insert(&mut n.left, v),
        Some(n) => insert(&mut n.right, v),
    }
}
]]
        ),
        answer = "None",
        accept = { "None" },
        hint = L(
          "The other half of Option. Not nil, not null. Four letters, capital N.",
          "Option의 나머지 반쪽. nil도 null도 아님. 네 글자, 대문자 N.",
          "Option 嘅另一半。唔係 nil，唔係 null。四個字母，大楷 N。"
        ),
        ok = L(
          "None is the base case: put a fresh leaf there. The Some arms recurse. Match ergonomics let n be &mut Box<Node>.",
          "None이 기저 조건: 새 잎을 거기 둔다. Some 갈래는 재귀. match ergonomics 덕에 n은 &mut Box<Node>.",
          "None 係 base case：擺塊新葉落去。Some 嗰啲 arm 遞歸。match ergonomics 令 n 係 &mut Box<Node>。"
        ),
      },
      {
        topic = "LEFT",
        q = L(
          "Smaller values go down one side. Fill the arm: if v < n.val => insert(&mut n.___, v)",
          "작은 값은 한쪽으로 내려간다. 갈래를 채워라: if v < n.val => insert(&mut n.___, v)",
          "細嘅值向一邊落去。填個 arm：if v < n.val => insert(&mut n.___, v)"
        ),
        code = L(
          [[
fn insert(link: &mut Link, v: i32) {
    match link {
        None => *link = Some(Box::new(Node::leaf(v))),
        Some(n) if v < n.val => insert(&mut n.___, v),
        Some(n) => insert(&mut n.right, v),
    }
}
]],
          [[
fn insert(link: &mut Link, v: i32) {
    match link {
        None => *link = Some(Box::new(Node::leaf(v))),
        Some(n) if v < n.val => insert(&mut n.___, v),
        Some(n) => insert(&mut n.right, v),
    }
}
]],
          [[
fn insert(link: &mut Link, v: i32) {
    match link {
        None => *link = Some(Box::new(Node::leaf(v))),
        Some(n) if v < n.val => insert(&mut n.___, v),
        Some(n) => insert(&mut n.right, v),
    }
}
]]
        ),
        answer = "left",
        accept = { "left" },
        hint = L(
          "The field that is not right. Mei said it in her speech bubble.",
          "right가 아닌 필드. 메이가 말풍선에서 말했다.",
          "唔係 right 嘅嗰個 field。阿美喺對話框講咗。"
        ),
        ok = L(
          "BST rule: everything smaller is in the left subtree. &mut n.left reborrows the child for the recursive call.",
          "BST 규칙: 더 작은 건 모두 왼쪽 서브트리. &mut n.left가 재귀 호출용으로 자식을 다시 빌린다.",
          "BST 規則：細嘅全部喺左邊 subtree。&mut n.left 將子節點 reborrow 俾遞歸 call。"
        ),
      },
      {
        topic = "PEEK",
        q = L(
          "Read the root value without moving the Box out of the Option. Which Option method borrows the inside?",
          "Box를 Option에서 꺼내지 않고 루트 값을 읽는다. 안쪽을 빌리는 Option 메서드는?",
          "唔搬個 Box 出嚟就讀 root 嘅值。邊個 Option method 借入面嗰個？"
        ),
        code = L(
          [[
// &Option<T> to Option<&T>: a borrow, not a move.
fn root_val(tree: &Link) -> Option<i32> {
    tree.___().map(|n| n.val)
}
]],
          [[
// &Option<T>에서 Option<&T>로: 이동이 아닌 빌림.
fn root_val(tree: &Link) -> Option<i32> {
    tree.___().map(|n| n.val)
}
]],
          [[
// &Option<T> 變 Option<&T>：係借，唔係搬。
fn root_val(tree: &Link) -> Option<i32> {
    tree.___().map(|n| n.val)
}
]]
        ),
        answer = "as_ref",
        accept = { "as_ref", "as_ref()", "as_deref", "as_deref()" },
        hint = L(
          "as_ followed by the short word for reference. Its cousin as_deref goes one step further, to Option<&Node>.",
          "as_ 뒤에 reference의 줄임말. 사촌 as_deref는 한 걸음 더 가서 Option<&Node>.",
          "as_ 後面跟 reference 嘅縮寫。佢嘅表親 as_deref 再行多一步，去到 Option<&Node>。"
        ),
        ok = L(
          "tree.as_ref() turns &Option<T> into Option<&T>. Without it, map would try to move out of the borrow.",
          "tree.as_ref()는 &Option<T>를 Option<&T>로 바꾼다. 없으면 map이 빌린 것에서 이동하려 한다.",
          "tree.as_ref() 將 &Option<T> 變 Option<&T>。冇佢，map 會想由借嘅嘢入面搬走。"
        ),
      },
      {
        topic = "INORDER",
        q = L(
          "In-order walk: left subtree, this node, then which subtree? That gives sorted output.",
          "중위 순회: 왼쪽 서브트리, 이 노드, 그다음 어느 서브트리? 그러면 정렬된 출력.",
          "中序走：左邊 subtree、呢個 node，然後邊個 subtree？咁樣出嚟就係排好序。"
        ),
        code = L(
          [[
fn inorder(link: &Link, out: &mut Vec<i32>) {
    if let Some(n) = link {
        inorder(&n.left, out);
        out.push(n.val);           // the node itself
        inorder(&n.___, out);
    }
}
]],
          [[
fn inorder(link: &Link, out: &mut Vec<i32>) {
    if let Some(n) = link {
        inorder(&n.left, out);
        out.push(n.val);           // 노드 자신
        inorder(&n.___, out);
    }
}
]],
          [[
fn inorder(link: &Link, out: &mut Vec<i32>) {
    if let Some(n) = link {
        inorder(&n.left, out);
        out.push(n.val);           // node 自己
        inorder(&n.___, out);
    }
}
]]
        ),
        answer = "right",
        accept = { "right" },
        hint = L(
          "Everything bigger than the node. Five letters.",
          "노드보다 큰 것 전부. 다섯 글자.",
          "所有大過個 node 嘅嘢。五個字母。"
        ),
        ok = L(
          "Left, node, right: a BST walked in order comes out sorted. if let on &Link needs no unwrap.",
          "왼쪽, 노드, 오른쪽: BST를 중위로 걸으면 정렬된 채 나온다. &Link의 if let엔 unwrap이 필요 없다.",
          "左、node、右：BST 中序行一次出嚟就係排好序。&Link 上面用 if let 唔使 unwrap。"
        ),
      },
      {
        topic = "HEIGHT",
        q = L(
          "height is 1 plus the taller of the two subtrees. Which method picks the larger of two usize?",
          "height는 1 + 두 서브트리 중 더 큰 쪽. 두 usize 중 큰 값을 고르는 메서드는?",
          "height 係 1 加兩個 subtree 入面高嗰個。邊個 method 揀兩個 usize 入面大嗰個？"
        ),
        code = L(
          [[
fn height(link: &Link) -> usize {
    match link {
        None => 0,
        Some(n) => 1 + height(&n.left)
            .___(height(&n.right)),   // taller side wins
    }
}
]],
          [[
fn height(link: &Link) -> usize {
    match link {
        None => 0,
        Some(n) => 1 + height(&n.left)
            .___(height(&n.right)),   // 높은 쪽
    }
}
]],
          [[
fn height(link: &Link) -> usize {
    match link {
        None => 0,
        Some(n) => 1 + height(&n.left)
            .___(height(&n.right)),   // 高嗰邊贏
    }
}
]]
        ),
        answer = "max",
        accept = { "max" },
        hint = L(
          "Three letters, from the Ord trait. a.max(b) reads better than std::cmp::max(a, b).",
          "세 글자, Ord 트레이트. a.max(b)가 std::cmp::max(a, b)보다 읽기 좋다.",
          "三個字母，嚟自 Ord trait。a.max(b) 好讀過 std::cmp::max(a, b)。"
        ),
        ok = L(
          "Method calls bind tighter than +, so it is 1 + (left.max(right)). Round two clean. Combo x2.",
          "메서드 호출이 +보다 우선이니 1 + (left.max(right)). 2라운드 깔끔. 콤보 x2.",
          "method call 比 + 更緊，所以係 1 + (left.max(right))。第二回合乾淨。連擊 x2。"
        ),
      },
    },
  },

  {
    id = "rs_graph",
    station = "GRAPH",
    name = L("ROUND 3  -  the map", "라운드 3  -  노선도", "第三回合  -  路線圖"),
    title = L("Graphs: BFS and DFS", "그래프: BFS와 DFS", "Graph：BFS 同 DFS"),
    lesson = L(
      "Adjacency list: HashMap<u32, Vec<u32>>. BFS uses a VecDeque and pop_front, DFS a Vec and pop. A HashSet remembers visits.",
      "인접 리스트: HashMap<u32, Vec<u32>>. BFS는 VecDeque와 pop_front, DFS는 Vec과 pop. HashSet이 방문을 기억.",
      "Adjacency list：HashMap<u32, Vec<u32>>。BFS 用 VecDeque 同 pop_front，DFS 用 Vec 同 pop。HashSet 記住去過邊。"
    ),
    bg = "bg_times",
    portrait = "portrait_hero",
    speaker = L("Alex", "알렉스", "阿力"),
    ground = 348,
    spawn = 180,
    width = 1600,
    npcs = {
      {
        kind = "clerk",
        x = 520,
        facing = -1,
        line = L(
          "Round three: the MTR map as a graph. Breadth first, then depth first. Do not visit a station twice!",
          "3라운드: 그래프로 본 MTR 노선도. 너비 우선, 그다음 깊이 우선. 같은 역을 두 번 가지 마세요!",
          "第三回合：MTR 路線圖當 graph。先闊度優先，再深度優先。唔好去同一個站兩次！"
        ),
      },
      {
        kind = "mei",
        x = 880,
        facing = -1,
        line = L(
          "Queue for wide, stack for deep. Same loop, different end of the Vec.",
          "넓게는 큐, 깊게는 스택. 같은 루프, Vec의 다른 끝.",
          "闊就用 queue，深就用 stack。同一個 loop，Vec 嘅另一端。"
        ),
      },
    },
    viz = "rust",
    chips = {
      { "HashMap<u32, Vec<u32>>", "cyan" },
      { "VecDeque::from([s])", "gold" },
      { "seen.insert(n) -> bool", "pink" },
      { "stack.pop()", "green" },
    },
    note = "BFS: VecDeque  DFS: Vec  HashSet  O(V + E)",
    story = L(
      "19:17. Round three puts the MTR map on the big screen: stations are nodes, lines are edges. "
        .. "Mei has to reach every station once. Wide first with a queue, then deep with a stack, and a HashSet so nobody loops forever.",
      "19:17. 3라운드는 대형 화면에 MTR 노선도: 역은 노드, 노선은 간선. "
        .. "메이는 모든 역을 한 번씩 가야 한다. 먼저 큐로 넓게, 다음 스택으로 깊게, 그리고 무한 루프를 막는 HashSet.",
      "七點十七分。第三回合將 MTR 路線圖放上大螢幕：站係 node，線係 edge。"
        .. "阿美要每個站去一次。先用 queue 行闊，再用 stack 行深，仲有個 HashSet 令冇人無限 loop。"
    ),
    stages = {
      {
        topic = "ADJ",
        q = L(
          "An adjacency list: each station id maps to the ids one hop away. What holds the list of neighbours?",
          "인접 리스트: 각 역 id가 한 정거장 거리의 id들로 대응. 이웃 목록을 담는 타입은?",
          "Adjacency list：每個站 id 對應一站之隔嘅 id。用咩裝鄰站列表？"
        ),
        code = L(
          [[
use std::collections::HashMap;
// station id -> the ids one hop away (an adjacency list)
type Graph = HashMap<u32, ___<u32>>;
fn degree(g: &Graph, n: u32) -> usize {
    g[&n].len()          // how many exits this station has
}
]],
          [[
use std::collections::HashMap;
// 역 id -> 한 정거장 거리의 id들
type Graph = HashMap<u32, ___<u32>>;
fn degree(g: &Graph, n: u32) -> usize {
    g[&n].len()          // 이 역의 출구 수
}
]],
          [[
use std::collections::HashMap;
// 站 id -> 一站之隔嘅 id (adjacency list)
type Graph = HashMap<u32, ___<u32>>;
fn degree(g: &Graph, n: u32) -> usize {
    g[&n].len()          // 呢個站有幾多個出口
}
]]
        ),
        answer = "Vec",
        accept = { "Vec" },
        hint = L(
          "The growable array. Three letters, capital V. A neighbour can be pushed on.",
          "늘어나는 배열. 세 글자, 대문자 V. 이웃을 push할 수 있다.",
          "會大嘅 array。三個字母，大楷 V。鄰站可以 push 落去。"
        ),
        ok = L(
          "HashMap<u32, Vec<u32>>: O(1) to find a station, then its neighbours in order. g[&n] panics on a missing key; get returns Option.",
          "HashMap<u32, Vec<u32>>: 역 찾기 O(1), 그다음 이웃이 순서대로. g[&n]은 키가 없으면 panic; get은 Option을 반환.",
          "HashMap<u32, Vec<u32>>：搵站 O(1)，然後鄰站按次序。g[&n] 冇 key 會 panic；get 回傳 Option。"
        ),
      },
      {
        topic = "ENTRY",
        q = L(
          "Adding an edge to a station with no list yet. Which entry method starts an empty Vec on demand?",
          "아직 목록이 없는 역에 간선 추가. 필요할 때 빈 Vec을 만들어 주는 entry 메서드는?",
          "幫一個仲未有列表嘅站加 edge。邊個 entry method 有需要就開一個空 Vec？"
        ),
        code = L(
          [[
fn add_edge(g: &mut Graph, a: u32, b: u32) {
    // no list for a yet? start an empty one, then push b
    g.entry(a).___().push(b);
    // the long spelling of the same thing, other direction
    g.entry(b).or_insert_with(Vec::new).push(a);
}
]],
          [[
fn add_edge(g: &mut Graph, a: u32, b: u32) {
    // a의 목록이 없으면 만들고 b를 push
    g.entry(a).___().push(b);
    // 같은 일의 긴 표기, 반대 방향
    g.entry(b).or_insert_with(Vec::new).push(a);
}
]],
          [[
fn add_edge(g: &mut Graph, a: u32, b: u32) {
    // a 仲未有列表？開個空嘅，然後 push b
    g.entry(a).___().push(b);
    // 同一樣嘢嘅長寫法，另一個方向
    g.entry(b).or_insert_with(Vec::new).push(a);
}
]]
        ),
        answer = "or_default",
        accept = {
          "or_default",
          "or_default()",
          "or_insert_with(Vec::new)",
          "or_insert(Vec::new())",
          "or_insert(vec![])",
        },
        hint = L(
          "or_ plus the word for Default::default(). An empty Vec is the default Vec.",
          "or_ 뒤에 Default::default()를 뜻하는 단어. 빈 Vec이 Vec의 기본값.",
          "or_ 加上代表 Default::default() 嘅字。空 Vec 就係 Vec 嘅 default。"
        ),
        ok = L(
          "entry(a).or_default() returns &mut Vec<u32>, so push works in one line. One hash lookup, not two.",
          "entry(a).or_default()는 &mut Vec<u32>를 돌려주니 한 줄에 push. 해시 조회 두 번이 아니라 한 번.",
          "entry(a).or_default() 回傳 &mut Vec<u32>，一行就 push 到。hash 查一次，唔係兩次。"
        ),
      },
      {
        topic = "QUEUE",
        q = L(
          "Breadth first needs a FIFO: in at the back, out at the front. Which std collection?",
          "너비 우선엔 FIFO가 필요: 뒤로 넣고 앞에서 뺀다. 어떤 std 컬렉션?",
          "闊度優先要 FIFO：後面入，前面出。邊個 std collection？"
        ),
        code = L(
          [[
fn bfs(g: &Graph, start: u32) -> Vec<u32> {
    let mut order = Vec::new();
    let mut seen = HashSet::from([start]);
    // FIFO: newest at the back, oldest out at the front
    let mut q = ___::from([start]);
]],
          [[
fn bfs(g: &Graph, start: u32) -> Vec<u32> {
    let mut order = Vec::new();
    let mut seen = HashSet::from([start]);
    // FIFO: 최신은 뒤에, 오래된 것은 앞에서
    let mut q = ___::from([start]);
]],
          [[
fn bfs(g: &Graph, start: u32) -> Vec<u32> {
    let mut order = Vec::new();
    let mut seen = HashSet::from([start]);
    // FIFO：最新喺後面，最舊由前面出
    let mut q = ___::from([start]);
]]
        ),
        answer = "VecDeque",
        accept = { "VecDeque", "std::collections::VecDeque", "collections::VecDeque" },
        hint = L(
          "Vec plus Deque, a double-ended queue. A ring buffer: O(1) at both ends. Vec::remove(0) would be O(n).",
          "Vec 더하기 Deque, 양끝 큐. 링 버퍼: 양쪽 끝 O(1). Vec::remove(0)은 O(n).",
          "Vec 加 Deque，雙端 queue。ring buffer：兩端都 O(1)。Vec::remove(0) 會係 O(n)。"
        ),
        ok = L(
          "VecDeque::from([start]) seeds the queue. seen starts with start too, so it is never queued twice.",
          "VecDeque::from([start])로 큐를 시작. seen에도 start가 있어 두 번 큐에 들어가지 않는다.",
          "VecDeque::from([start]) 開個 queue。seen 一開始都有 start，所以佢唔會入 queue 兩次。"
        ),
      },
      {
        topic = "POP",
        q = L(
          "Take the station that has waited longest. Which VecDeque method returns Option<u32> from the front?",
          "가장 오래 기다린 역을 꺼낸다. 앞에서 Option<u32>를 돌려주는 VecDeque 메서드는?",
          "攞等得最耐嗰個站。邊個 VecDeque method 由前面回傳 Option<u32>？"
        ),
        code = L(
          [[
    // the station that has waited longest goes next
    while let Some(n) = q.___() {
        order.push(n);
        for &m in &g[&n] {
            if seen.insert(m) { q.push_back(m); }
        }
    }
]],
          [[
    // 가장 오래 기다린 역이 다음
    while let Some(n) = q.___() {
        order.push(n);
        for &m in &g[&n] {
            if seen.insert(m) { q.push_back(m); }
        }
    }
]],
          [[
    // 等得最耐嗰個站下一個行
    while let Some(n) = q.___() {
        order.push(n);
        for &m in &g[&n] {
            if seen.insert(m) { q.push_back(m); }
        }
    }
]]
        ),
        answer = "pop_front",
        accept = { "pop_front", "pop_front()" },
        hint = L(
          "pop, underscore, the end that is not back. The while let ends when it returns None.",
          "pop, 밑줄, back이 아닌 쪽 끝. None이 나오면 while let이 끝난다.",
          "pop、底線、唔係 back 嗰一端。回傳 None 嗰陣 while let 就完。"
        ),
        ok = L(
          "pop_front is O(1). Stations come out in rings: one hop, two hops, three. That is BFS.",
          "pop_front는 O(1). 역이 동심원처럼 나온다: 한 정거장, 두 정거장, 셋. 그게 BFS.",
          "pop_front 係 O(1)。啲站一圈一圈咁出：一站、兩站、三站。呢個就係 BFS。"
        ),
      },
      {
        topic = "VISITED",
        q = L(
          "One HashSet method adds m and tells you whether it was new. Which one?",
          "m을 추가하면서 새것이었는지도 알려주는 HashSet 메서드 하나. 어떤 것?",
          "有個 HashSet method 加 m 之餘仲話你知佢係咪新嘅。邊個？"
        ),
        code = L(
          [[
    while let Some(n) = q.pop_front() {
        order.push(n);
        for &m in &g[&n] {
            // adds m; true only if it was not there yet
            if seen.___(m) { q.push_back(m); }
        }
    }
]],
          [[
    while let Some(n) = q.pop_front() {
        order.push(n);
        for &m in &g[&n] {
            // m을 추가; 아직 없던 경우에만 true
            if seen.___(m) { q.push_back(m); }
        }
    }
]],
          [[
    while let Some(n) = q.pop_front() {
        order.push(n);
        for &m in &g[&n] {
            // 加 m；之前未有先係 true
            if seen.___(m) { q.push_back(m); }
        }
    }
]]
        ),
        answer = "insert",
        accept = { "insert" },
        hint = L(
          "Same name as on HashMap, but on a set it returns bool. No contains check needed first.",
          "HashMap과 같은 이름, 하지만 집합에선 bool을 반환. contains를 먼저 볼 필요 없음.",
          "同 HashMap 上面同一個名，但喺 set 上面回傳 bool。唔使先 check contains。"
        ),
        ok = L(
          "seen.insert(m) is one lookup for check and mark. Without it, a loop in the map queues forever.",
          "seen.insert(m) 한 번으로 확인과 표시를 동시에. 없으면 노선도의 순환이 영원히 큐에 쌓인다.",
          "seen.insert(m) 一次查就 check 埋 mark 埋。冇佢，路線圖有個圈就永遠入 queue。"
        ),
      },
      {
        topic = "STACK",
        q = L(
          "Depth first: same loop, but the newest station goes next. Which Vec method takes from the end?",
          "깊이 우선: 같은 루프지만 가장 새 역이 다음. 끝에서 꺼내는 Vec 메서드는?",
          "深度優先：同一個 loop，但最新嘅站下一個行。邊個 Vec method 由尾攞？"
        ),
        code = L(
          [[
fn dfs(g: &Graph, start: u32, seen: &mut HashSet<u32>) {
    let mut stack = vec![start];     // a Vec is a stack too
    while let Some(n) = stack.___() { // LIFO: newest first
        if !seen.insert(n) { continue; }
        print!("{n} "); stack.extend(&g[&n]);
    }
}
]],
          [[
fn dfs(g: &Graph, start: u32, seen: &mut HashSet<u32>) {
    let mut stack = vec![start];     // Vec은 이미 스택
    while let Some(n) = stack.___() { // LIFO: 새것 먼저
        if !seen.insert(n) { continue; }
        print!("{n} "); stack.extend(&g[&n]);
    }
}
]],
          [[
fn dfs(g: &Graph, start: u32, seen: &mut HashSet<u32>) {
    let mut stack = vec![start];     // Vec 已經係 stack
    while let Some(n) = stack.___() { // LIFO：最新先
        if !seen.insert(n) { continue; }
        print!("{n} "); stack.extend(&g[&n]);
    }
}
]]
        ),
        answer = "pop",
        accept = { "pop", "pop()" },
        hint = L(
          "Three letters, no underscore. The opposite of push. Returns Option<T>.",
          "세 글자, 밑줄 없음. push의 반대. Option<T>를 반환.",
          "三個字母，冇底線。push 嘅相反。回傳 Option<T>。"
        ),
        ok = L(
          "pop_front is BFS, pop is DFS: the only difference is which end. Both O(V + E). Combo x3.",
          "pop_front는 BFS, pop은 DFS: 차이는 어느 끝이냐뿐. 둘 다 O(V + E). 콤보 x3.",
          "pop_front 係 BFS，pop 係 DFS：分別只係邊一端。兩個都 O(V + E)。連擊 x3。"
        ),
      },
    },
  },

  {
    id = "rs_list",
    station = "LIST",
    name = L("ROUND 4  -  the chain", "라운드 4  -  체인", "第四回合  -  鏈"),
    title = L("Linked list without pointers", "포인터 없는 연결 리스트", "冇 pointer 嘅 linked list"),
    lesson = L(
      "A list is Option<Box<ListNode>>. take() moves a node out and leaves None. Reverse with prev and cur; slow and fast runners find the middle.",
      "리스트는 Option<Box<ListNode>>. take()는 노드를 꺼내고 None을 남긴다. prev와 cur로 뒤집고, slow와 fast 주자가 중간을 찾는다.",
      "List 係 Option<Box<ListNode>>。take() 搬個 node 出嚟留低 None。用 prev 同 cur 反轉；slow 同 fast 兩個 runner 搵中間。"
    ),
    bg = "bg_street",
    portrait = "portrait_friends",
    speaker = L("Mei", "메이", "阿美"),
    ground = 348,
    spawn = 180,
    width = 1600,
    npcs = {
      {
        kind = "hero",
        x = 540,
        facing = -1,
        line = L(
          "In Go this was three pointers. In Rust, who owns the next node?",
          "Go에선 포인터 셋이었지. Rust에선 다음 노드의 주인이 누구야?",
          "喺 Go 係三個 pointer。喺 Rust，下一個 node 係邊個擁有？"
        ),
      },
      {
        kind = "clerk",
        x = 900,
        facing = -1,
        line = L(
          "Round four: reverse the chain, then find its middle. The borrow checker is watching.",
          "4라운드: 체인을 뒤집고 중간을 찾으세요. borrow checker가 보고 있습니다.",
          "第四回合：反轉條鏈，然後搵中間。borrow checker 睇住你。"
        ),
      },
    },
    viz = "rust",
    chips = {
      { "Option<Box<ListNode>>", "cyan" },
      { "head.take()?", "gold" },
      { "node.next = prev;", "pink" },
      { "hop(hop(fast))", "green" },
    },
    note = "take  while let  prev  cur  slow / fast  O(n)",
    story = L(
      "19:26. Round four is the chain: a linked list of order tickets, out on the street where the delivery riders queue. "
        .. "Each node owns the next one. Reverse it, walk it, find the middle, and never touch a raw pointer.",
      "19:26. 4라운드는 체인: 주문표의 연결 리스트, 배달 기사들이 줄 선 거리에서. "
        .. "각 노드가 다음 노드를 소유한다. 뒤집고, 걷고, 중간을 찾되 raw 포인터는 절대 만지지 말 것.",
      "七點二十六分。第四回合係條鏈：訂單票嘅 linked list，喺外賣車手排隊嘅街上。"
        .. "每個 node 擁有下一個。反轉佢、行一次、搵中間，而且永遠唔掂 raw pointer。"
    ),
    stages = {
      {
        topic = "NEXT",
        q = L(
          "The rest of the chain, or nothing at the end. Which type wraps Box<ListNode> so it can be empty?",
          "체인의 나머지, 혹은 끝에는 없음. Box<ListNode>를 감싸 비어 있을 수 있게 하는 타입은?",
          "條鏈嘅其餘部分，或者去到尾就冇。邊個 type 包住 Box<ListNode> 令佢可以係空？"
        ),
        code = L(
          [[
struct ListNode {
    val: i32,
    next: ___<Box<ListNode>>,   // the rest, or the end
}
]],
          [[
struct ListNode {
    val: i32,
    next: ___<Box<ListNode>>,   // 나머지, 아니면 끝
}
]],
          [[
struct ListNode {
    val: i32,
    next: ___<Box<ListNode>>,   // 其餘，或者係尾
}
]]
        ),
        answer = "Option",
        accept = { "Option" },
        hint = L(
          "Some or None. Rust has no null, so the possibly-empty next is spelled out in the type.",
          "Some 아니면 None. Rust엔 null이 없어 비어 있을 수 있는 next를 타입에 적는다.",
          "Some 或者 None。Rust 冇 null，所以可能係空嘅 next 要喺 type 度寫明。"
        ),
        ok = L(
          "Option<Box<ListNode>>: each node owns the next, the last one holds None. Same size as a raw pointer.",
          "Option<Box<ListNode>>: 각 노드가 다음을 소유, 마지막은 None. 크기는 raw 포인터와 같다.",
          "Option<Box<ListNode>>：每個 node 擁有下一個，最後嗰個係 None。大小同 raw pointer 一樣。"
        ),
      },
      {
        topic = "TAKE",
        q = L(
          "pop the first node. We only have &mut head, so move the node out and leave None behind. Which Option method?",
          "첫 노드를 pop. &mut head밖에 없으니 노드를 꺼내고 None을 남긴다. 어떤 Option 메서드?",
          "pop 第一個 node。我哋淨係有 &mut head，所以搬個 node 出嚟留低 None。邊個 Option method？"
        ),
        code = L(
          [[
type Link = Option<Box<ListNode>>;
fn pop(head: &mut Link) -> Option<i32> {
    // move the first node out, leave None in its place
    let node = head.___()?;
    *head = node.next;
    Some(node.val)
}
]],
          [[
type Link = Option<Box<ListNode>>;
fn pop(head: &mut Link) -> Option<i32> {
    // 첫 노드를 꺼내고 None을 남긴다
    let node = head.___()?;
    *head = node.next;
    Some(node.val)
}
]],
          [[
type Link = Option<Box<ListNode>>;
fn pop(head: &mut Link) -> Option<i32> {
    // 搬第一個 node 出嚟，佢個位留低 None
    let node = head.___()?;
    *head = node.next;
    Some(node.val)
}
]]
        ),
        answer = "take",
        accept = { "take", "take()" },
        hint = L(
          "Four letters. Like std::mem::take: gives you the value, puts the default (None) back.",
          "네 글자. std::mem::take처럼: 값을 주고 기본값(None)을 돌려놓는다.",
          "四個字母。好似 std::mem::take：俾你個值，放返 default（None）落去。"
        ),
        ok = L(
          "head.take() is how you move out of a &mut Option. The ? returns None on an empty list. Then relink the head.",
          "head.take()가 &mut Option에서 꺼내는 법. 빈 리스트면 ?가 None을 반환. 그다음 head를 다시 잇는다.",
          "head.take() 就係由 &mut Option 搬嘢出嚟嘅方法。空 list 嘅話 ? 回傳 None。然後駁返個 head。"
        ),
      },
      {
        topic = "FLIP",
        q = L(
          "Reverse: point the current node backwards. Fill: node.next = ___",
          "뒤집기: 현재 노드를 뒤로 향하게: node.next = ___",
          "反轉：令現時嘅 node 指返後面：node.next = ___"
        ),
        code = L(
          [[
fn reverse(head: Link) -> Link {
    let mut prev: Link = None;
    let mut cur = head;
    while let Some(mut node) = cur {
        cur = node.next;          // save the rest first
        node.next = ___;          // point back, not forward
        prev = Some(node);
]],
          [[
fn reverse(head: Link) -> Link {
    let mut prev: Link = None;
    let mut cur = head;
    while let Some(mut node) = cur {
        cur = node.next;          // 나머지 먼저 저장
        node.next = ___;          // 뒤를 가리킨다
        prev = Some(node);
]],
          [[
fn reverse(head: Link) -> Link {
    let mut prev: Link = None;
    let mut cur = head;
    while let Some(mut node) = cur {
        cur = node.next;          // 先存起其餘部分
        node.next = ___;          // 指返後面
        prev = Some(node);
]]
        ),
        answer = "prev",
        accept = { "prev" },
        hint = L(
          "The part already flipped. None on the first lap, which becomes the new tail.",
          "이미 뒤집힌 부분. 첫 바퀴엔 None이고 그게 새 꼬리가 된다.",
          "已經反轉咗嘅部分。第一圈係 None，佢會變新嘅尾。"
        ),
        ok = L(
          "Move next out, flip the arrow, push node onto prev. No take() needed: while let moved cur into node. prev is the new head.",
          "next를 꺼내고, 화살표를 뒤집고, node를 prev에 얹는다. take()는 불필요: while let이 cur를 node로 이동시켰다. prev가 새 head.",
          "搬 next 出嚟、反轉個箭嘴、將 node 放上 prev。唔使 take()：while let 已經將 cur move 入 node。prev 就係新 head。"
        ),
      },
      {
        topic = "WALK",
        q = L(
          "Count the nodes without taking ownership: cur is a &Link. Step to the following node: cur = &node.___",
          "소유권 없이 노드 세기: cur는 &Link. 다음 노드로 이동: cur = &node.___",
          "唔攞 ownership 咁數 node：cur 係 &Link。行去下一個 node：cur = &node.___"
        ),
        code = L(
          [[
fn len(head: &Link) -> usize {
    let mut n = 0;
    let mut cur = head;
    while let Some(node) = cur {
        n += 1;
        cur = &node.___;        // follow the arrow
    }
]],
          [[
fn len(head: &Link) -> usize {
    let mut n = 0;
    let mut cur = head;
    while let Some(node) = cur {
        n += 1;
        cur = &node.___;        // 화살표를 따라간다
    }
]],
          [[
fn len(head: &Link) -> usize {
    let mut n = 0;
    let mut cur = head;
    while let Some(node) = cur {
        n += 1;
        cur = &node.___;        // 跟住個箭嘴行
    }
]]
        ),
        answer = "next",
        accept = { "next" },
        hint = L(
          "The field from stage one. Borrow it with &, and cur stays a &Link.",
          "1단계의 그 필드. &로 빌리면 cur는 계속 &Link.",
          "第一關嗰個 field。用 & 借佢，cur 就一直係 &Link。"
        ),
        ok = L(
          "Walking by reference: no clone, no take, nothing moves. node is &Box<ListNode>, auto-deref reaches next.",
          "참조로 걷기: clone도 take도 없고 아무것도 이동하지 않는다. node는 &Box<ListNode>, auto-deref가 next에 닿는다.",
          "用 reference 行：冇 clone、冇 take，冇嘢 move。node 係 &Box<ListNode>，auto-deref 掂到 next。"
        ),
      },
      {
        topic = "RUNNERS",
        q = L(
          "Two runners: slow hops one node a lap, fast two. hop turns Option<Box<T>> into Option<&T>. Which method?",
          "주자 둘: slow는 한 바퀴에 한 노드, fast는 둘. hop은 Option<Box<T>>를 Option<&T>로 바꾼다. 어떤 메서드?",
          "兩個 runner：slow 每圈行一個 node，fast 行兩個。hop 將 Option<Box<T>> 變 Option<&T>。邊個 method？"
        ),
        code = L(
          [[
fn hop(n: Option<&ListNode>) -> Option<&ListNode> {
    n?.next.___()        // through the Box, by ref
}
let (mut slow, mut fast) = (Some(head), Some(head));
while hop(fast).is_some() {      // fast still has a next
    fast = hop(hop(fast)); slow = hop(slow);
}
]],
          [[
fn hop(n: Option<&ListNode>) -> Option<&ListNode> {
    n?.next.___()        // Box를 지나 참조로
}
let (mut slow, mut fast) = (Some(head), Some(head));
while hop(fast).is_some() {      // fast에 next가 있다
    fast = hop(hop(fast)); slow = hop(slow);
}
]],
          [[
fn hop(n: Option<&ListNode>) -> Option<&ListNode> {
    n?.next.___()        // 穿過個 Box，用 ref
}
let (mut slow, mut fast) = (Some(head), Some(head));
while hop(fast).is_some() {      // fast 仲有 next
    fast = hop(hop(fast)); slow = hop(slow);
}
]]
        ),
        answer = "as_deref",
        accept = { "as_deref", "as_deref()" },
        hint = L(
          "as_ref would give Option<&Box<T>>. This one also derefs the Box. as_ plus deref.",
          "as_ref는 Option<&Box<T>>를 준다. 이건 Box도 deref한다. as_ 더하기 deref.",
          "as_ref 會俾 Option<&Box<T>>。呢個仲會 deref 埋個 Box。as_ 加 deref。"
        ),
        ok = L(
          "When fast runs out, slow stands in the middle. O(n) time, O(1) space, and Option<&T> is Copy so the hops are free. Combo x4.",
          "fast가 끝나면 slow는 중간에 서 있다. 시간 O(n), 공간 O(1), Option<&T>는 Copy라 hop은 공짜. 콤보 x4.",
          "fast 行到盡，slow 就企喺中間。時間 O(n)，空間 O(1)，Option<&T> 係 Copy 所以 hop 唔使錢。連擊 x4。"
        ),
      },
    },
  },

  {
    id = "rs_sort",
    station = "SORT",
    name = L("ROUND 5  -  the shuffle", "라운드 5  -  셔플", "第五回合  -  洗牌"),
    title = L("Sorting and searching", "정렬과 탐색", "排序同搜尋"),
    lesson = L(
      "Merge sort: split_at(len / 2), sort both, merge with <= for stability. In practice: sort_by_key, sort_unstable, binary_search.",
      "머지 소트: split_at(len / 2), 양쪽 정렬, 안정성을 위해 <=로 병합. 실전은 sort_by_key, sort_unstable, binary_search.",
      "Merge sort：split_at(len / 2)，兩邊排好，用 <= 合併保持 stable。實戰用 sort_by_key、sort_unstable、binary_search。"
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
        x = 540,
        facing = -1,
        line = L(
          "Round five: the shuffle. Write merge sort by hand, then show me you know the std sorts. O(n log n) or bust!",
          "5라운드: 셔플. 머지 소트를 직접 쓰고, std 정렬도 아는지 보여주세요. O(n log n) 아니면 탈락!",
          "第五回合：洗牌。手寫 merge sort，再證明你識 std 嘅 sort。O(n log n) 唔係就出局！"
        ),
      },
      {
        kind = "mei",
        x = 900,
        facing = -1,
        line = L(
          "Halve, halve, halve, then zip the halves back together. Ties go left.",
          "반, 반, 반으로 나눈 다음 다시 지퍼처럼 합친다. 같으면 왼쪽 먼저.",
          "一半、一半、再一半，然後好似拉鏈咁合返埋。打和就左邊先。"
        ),
      },
    },
    viz = "rust",
    chips = {
      { "v.split_at(len / 2)", "cyan" },
      { "sort_by_key(|o| o.price)", "gold" },
      { "binary_search(&x)", "pink" },
    },
    note = "merge sort O(n log n)  binary_search O(log n)",
    story = L(
      "19:35. Round five, the shuffle. The screen dumps a hundred order prices in random order. "
        .. "Mei writes merge sort from memory, then the host wants the std spelling: stable, unstable, and a binary search on the result.",
      "19:35. 5라운드, 셔플. 화면에 주문 가격 백 개가 뒤섞여 쏟아진다. "
        .. "메이는 기억으로 머지 소트를 쓰고, 진행자는 std 표기를 원한다: 안정, 불안정, 그리고 결과에 이진 탐색.",
      "七點三十五分。第五回合，洗牌。螢幕倒出一百個亂晒次序嘅訂單價錢。"
        .. "阿美憑記憶寫 merge sort，然後主持要 std 嘅寫法：stable、unstable，仲要喺結果上面 binary search。"
    ),
    stages = {
      {
        topic = "MID",
        q = L(
          "Divide and conquer: split the slice in the middle. Fill: let mid = v.len() / ___",
          "분할 정복: 슬라이스를 중간에서 나눈다: let mid = v.len() / ___",
          "分而治之：喺中間切開個 slice：let mid = v.len() / ___"
        ),
        code = L(
          [[
fn merge_sort(v: &[i32]) -> Vec<i32> {
    if v.len() <= 1 { return v.to_vec(); }  // sorted
    let mid = v.len() / ___;                 // halve it
    let (l, r) = v.split_at(mid);
    merge(&merge_sort(l), &merge_sort(r))
}
]],
          [[
fn merge_sort(v: &[i32]) -> Vec<i32> {
    if v.len() <= 1 { return v.to_vec(); }  // 정렬됨
    let mid = v.len() / ___;                 // 반으로
    let (l, r) = v.split_at(mid);
    merge(&merge_sort(l), &merge_sort(r))
}
]],
          [[
fn merge_sort(v: &[i32]) -> Vec<i32> {
    if v.len() <= 1 { return v.to_vec(); }  // 排好咗
    let mid = v.len() / ___;                 // 分一半
    let (l, r) = v.split_at(mid);
    merge(&merge_sort(l), &merge_sort(r))
}
]]
        ),
        answer = "2",
        accept = { "2" },
        hint = L(
          "Halving gives log n levels. Integer division: 5 / 2 is 2, and that is fine.",
          "반으로 나누면 log n 단계. 정수 나눗셈: 5 / 2는 2, 그래도 괜찮다.",
          "分一半得 log n 層。整數除法：5 / 2 係 2，冇問題。"
        ),
        ok = L(
          "log n levels, n work per level: O(n log n). The base case is a slice of 0 or 1.",
          "log n 단계, 단계마다 n 작업: O(n log n). 기저 조건은 길이 0 또는 1의 슬라이스.",
          "log n 層，每層 n 咁多工：O(n log n)。base case 係長度 0 或 1 嘅 slice。"
        ),
      },
      {
        topic = "SPLIT",
        q = L(
          "Cut a slice into two slices at mid, no copying. Which slice method returns the pair?",
          "복사 없이 슬라이스를 mid에서 둘로 자른다. 쌍을 돌려주는 슬라이스 메서드는?",
          "唔 copy，喺 mid 將 slice 切成兩個 slice。邊個 slice method 回傳嗰對？"
        ),
        code = L(
          [[
fn merge_sort(v: &[i32]) -> Vec<i32> {
    if v.len() <= 1 { return v.to_vec(); }
    let mid = v.len() / 2;
    // two borrows of v: [..mid] and [mid..]
    let (l, r) = v.___(mid);
    merge(&merge_sort(l), &merge_sort(r))
}
]],
          [[
fn merge_sort(v: &[i32]) -> Vec<i32> {
    if v.len() <= 1 { return v.to_vec(); }
    let mid = v.len() / 2;
    // v를 두 번 빌림: [..mid]와 [mid..]
    let (l, r) = v.___(mid);
    merge(&merge_sort(l), &merge_sort(r))
}
]],
          [[
fn merge_sort(v: &[i32]) -> Vec<i32> {
    if v.len() <= 1 { return v.to_vec(); }
    let mid = v.len() / 2;
    // 借 v 兩次：[..mid] 同 [mid..]
    let (l, r) = v.___(mid);
    merge(&merge_sort(l), &merge_sort(r))
}
]]
        ),
        answer = "split_at",
        accept = { "split_at", "split_at()" },
        hint = L(
          "split, underscore, at. Panics if mid is past the end; here it never is.",
          "split, 밑줄, at. mid가 끝을 넘으면 panic; 여기선 절대 안 넘는다.",
          "split、底線、at。mid 超過尾會 panic；呢度永遠唔會。"
        ),
        ok = L(
          "split_at gives (&v[..mid], &v[mid..]) as one tuple. Two shared borrows of one slice are fine.",
          "split_at은 (&v[..mid], &v[mid..])를 튜플 하나로 준다. 한 슬라이스의 공유 빌림 둘은 괜찮다.",
          "split_at 俾你 (&v[..mid], &v[mid..]) 一個 tuple。一個 slice 借兩次 shared 冇問題。"
        ),
      },
      {
        topic = "MERGE",
        q = L(
          "Merging two sorted halves. On a tie take from the left, so equal items keep their order. Which comparison?",
          "정렬된 두 반쪽 병합. 같으면 왼쪽에서 가져와 같은 항목의 순서를 지킨다. 어떤 비교?",
          "合併兩個排好嘅半邊。打和就由左邊攞，等相同嘅嘢保持次序。用邊個比較？"
        ),
        code = L(
          [[
// merge(l, r): both slices are already sorted
let (mut i, mut j, mut out) = (0, 0, Vec::new());
while i < l.len() && j < r.len() {
    if l[i] ___ r[j] { out.push(l[i]); i += 1; }
    else { out.push(r[j]); j += 1; }
}
out.extend(&l[i..]); out.extend(&r[j..]);
]],
          [[
// merge(l, r): both slices are already sorted
let (mut i, mut j, mut out) = (0, 0, Vec::new());
while i < l.len() && j < r.len() {
    if l[i] ___ r[j] { out.push(l[i]); i += 1; }
    else { out.push(r[j]); j += 1; }
}
out.extend(&l[i..]); out.extend(&r[j..]);
]],
          [[
// merge(l, r): both slices are already sorted
let (mut i, mut j, mut out) = (0, 0, Vec::new());
while i < l.len() && j < r.len() {
    if l[i] ___ r[j] { out.push(l[i]); i += 1; }
    else { out.push(r[j]); j += 1; }
}
out.extend(&l[i..]); out.extend(&r[j..]);
]]
        ),
        answer = "<=",
        accept = { "<=" },
        hint = L(
          "Less than, or equal. A strict < would take the right one on a tie and break stability.",
          "작거나 같다. 엄격한 <는 같을 때 오른쪽을 가져가 안정성을 깬다.",
          "細過或者等於。淨係 < 嘅話打和會攞右邊，stable 就冇咗。"
        ),
        ok = L(
          "l[i] <= r[j] keeps the merge stable. The leftovers are appended with extend. O(n) per merge.",
          "l[i] <= r[j]가 병합을 안정적으로. 남은 것은 extend로 붙인다. 병합당 O(n).",
          "l[i] <= r[j] 令 merge 保持 stable。剩低嘅用 extend 駁埋。每次 merge O(n)。"
        ),
      },
      {
        topic = "KEY",
        q = L(
          "Real life: sort orders by price, cheapest first, equal prices keep their order. Which stable slice method takes a key closure?",
          "실전: 주문을 가격순, 싼 것 먼저, 같은 가격은 순서 유지. 키 클로저를 받는 안정 정렬 메서드는?",
          "實戰：訂單按價錢排，平嘅先，同價保持次序。邊個 stable 嘅 slice method 收 key closure？"
        ),
        code = L(
          [[
struct Order { id: u32, price: u32 }
let mut orders = vec![
    Order { id: 7, price: 45 },
    Order { id: 3, price: 18 },
];
// cheapest first; equal prices keep their order (stable)
orders.___(|o| o.price);
]],
          [[
struct Order { id: u32, price: u32 }
let mut orders = vec![
    Order { id: 7, price: 45 },
    Order { id: 3, price: 18 },
];
// 싼 것 먼저; 같은 가격은 순서 유지 (안정)
orders.___(|o| o.price);
]],
          [[
struct Order { id: u32, price: u32 }
let mut orders = vec![
    Order { id: 7, price: 45 },
    Order { id: 3, price: 18 },
];
// 平嘅先；同價保持次序（stable）
orders.___(|o| o.price);
]]
        ),
        answer = "sort_by_key",
        accept = { "sort_by_key", "sort_by_key()", "sort_by_cached_key" },
        hint = L(
          "sort, by, key with underscores. The closure returns something Ord; here a u32.",
          "sort, by, key를 밑줄로. 클로저는 Ord인 값을 반환; 여기선 u32.",
          "sort、by、key 用底線串埋。closure 回傳一個 Ord 嘅嘢；呢度係 u32。"
        ),
        ok = L(
          "sort_by_key is a stable merge sort, like the one you just wrote. sort_by takes a full comparator instead.",
          "sort_by_key는 방금 쓴 것과 같은 안정 머지 소트. sort_by는 대신 전체 비교자를 받는다.",
          "sort_by_key 係 stable 嘅 merge sort，同你啱啱寫嗰個一樣。sort_by 就係收成個 comparator。"
        ),
      },
      {
        topic = "SEARCH",
        q = L(
          "The prices are sorted. Find 45 in O(log n). Which slice method returns Result<usize, usize>?",
          "가격은 정렬돼 있다. 45를 O(log n)에 찾아라. Result<usize, usize>를 돌려주는 슬라이스 메서드는?",
          "價錢已經排好。用 O(log n) 搵 45。邊個 slice method 回傳 Result<usize, usize>？"
        ),
        code = L(
          [[
let prices = [18, 22, 45, 60];       // already sorted
// halve the range each step
match prices.___(&45) {
    Ok(i) => println!("found at {i}"),
    Err(i) => println!("would insert at {i}"),
}
]],
          [[
let prices = [18, 22, 45, 60];       // 이미 정렬됨
// 매 단계 범위를 반으로
match prices.___(&45) {
    Ok(i) => println!("found at {i}"),
    Err(i) => println!("would insert at {i}"),
}
]],
          [[
let prices = [18, 22, 45, 60];       // 已經排好
// 每一步範圍減半
match prices.___(&45) {
    Ok(i) => println!("found at {i}"),
    Err(i) => println!("would insert at {i}"),
}
]]
        ),
        answer = "binary_search",
        accept = { "binary_search", "binary_search()" },
        hint = L(
          "binary, underscore, search. Takes a reference to the wanted value. Err carries the insertion point.",
          "binary, 밑줄, search. 찾는 값의 참조를 받는다. Err에는 삽입 위치가 담긴다.",
          "binary、底線、search。收想搵嘅值嘅 reference。Err 帶住插入嘅位置。"
        ),
        ok = L(
          "Ok(2). On an unsorted slice the result is meaningless, so sort first. Err(i) is where to insert to stay sorted.",
          "Ok(2). 정렬 안 된 슬라이스에선 결과가 무의미하니 먼저 정렬. Err(i)는 정렬을 유지하며 넣을 자리.",
          "Ok(2)。未排好嘅 slice 結果冇意思，所以要先 sort。Err(i) 係保持排序嘅插入位置。"
        ),
      },
      {
        topic = "UNSTABLE",
        q = L(
          "Plain integers: equal values are indistinguishable, so stability is wasted. The faster in-place sort with no allocation?",
          "그냥 정수: 같은 값은 구별이 없으니 안정성은 낭비. 할당 없이 제자리에서 더 빠른 정렬은?",
          "純整數：相同嘅值分唔出，stable 係浪費。唔 allocate、原地、更快嘅 sort 係？"
        ),
        code = L(
          [[
let mut ids = vec![9, 2, 7, 2, 5];
// equal ids may swap places; nobody can tell
ids.___();
assert_eq!(ids, [2, 2, 5, 7, 9]);
]],
          [[
let mut ids = vec![9, 2, 7, 2, 5];
// 같은 id끼리 자리가 바뀌어도 모른다
ids.___();
assert_eq!(ids, [2, 2, 5, 7, 9]);
]],
          [[
let mut ids = vec![9, 2, 7, 2, 5];
// 相同嘅 id 換位都冇人分得出
ids.___();
assert_eq!(ids, [2, 2, 5, 7, 9]);
]]
        ),
        answer = "sort_unstable",
        accept = { "sort_unstable", "sort_unstable()" },
        hint = L(
          "sort, underscore, the opposite of stable. A pattern-defeating quicksort inside.",
          "sort, 밑줄, stable의 반대. 내부는 pattern-defeating quicksort.",
          "sort、底線、stable 嘅相反。入面係 pattern-defeating quicksort。"
        ),
        ok = L(
          "sort_unstable: O(n log n), in place, usually faster than sort. Use sort only when order among equals matters. Combo x5.",
          "sort_unstable: O(n log n), 제자리, 보통 sort보다 빠름. 같은 값의 순서가 중요할 때만 sort. 콤보 x5.",
          "sort_unstable：O(n log n)、原地、通常快過 sort。相同值嘅次序緊要先用 sort。連擊 x5。"
        ),
      },
    },
  },

  {
    id = "rs_hash",
    station = "HASH",
    name = L("ROUND 6  -  the classics", "라운드 6  -  고전", "第六回合  -  經典"),
    title = L("Hash maps, chars and counts", "해시 맵, 문자, 카운트", "Hash map、字元同計數"),
    lesson = L(
      "two-sum with a HashMap, palindrome with chars().rev(), anagram with a [0; 26] counter, word count with entry().or_insert(0).",
      "HashMap으로 two-sum, chars().rev()로 회문, [0; 26] 카운터로 애너그램, entry().or_insert(0)으로 단어 세기.",
      "用 HashMap 做 two-sum，用 chars().rev() 做回文，用 [0; 26] counter 做 anagram，用 entry().or_insert(0) 數字。"
    ),
    bg = "bg_mall",
    portrait = "portrait_friends",
    speaker = L("Mei", "메이", "阿美"),
    ground = 348,
    spawn = 180,
    width = 1600,
    npcs = {
      {
        kind = "hero",
        x = 540,
        facing = -1,
        line = L(
          "The classics! Two-sum, palindrome, anagram. Everyone has done these. Once.",
          "고전 문제들! two-sum, 회문, 애너그램. 다들 해봤지. 딱 한 번.",
          "經典題！two-sum、回文、anagram。個個都做過。一次。"
        ),
      },
      {
        kind = "clerk",
        x = 900,
        facing = -1,
        line = L(
          "Round six. Fast hands, Mei. The crab on the kiosk is keeping time.",
          "6라운드. 손 빨리, 메이. 키오스크의 게가 시간을 재고 있어요.",
          "第六回合。手要快，阿美。部機上面隻蟹計緊時。"
        ),
      },
    },
    viz = "rust",
    chips = {
      { "seen.contains_key(&w)", "cyan" },
      { "s.chars().rev()", "gold" },
      { "[0i32; 26]", "pink" },
      { "entry(w).or_insert(0)", "green" },
    },
    note = "HashMap  chars().rev()  [0; 26]  entry  O(n)",
    story = L(
      "19:44. Round six, the classics, back on the mall floor with the crowd pressing in. "
        .. "Two-sum, a palindrome, an anagram, a word count. Every one of them is a hash map or an array of 26, and every one is O(n).",
      "19:44. 6라운드, 고전, 관중이 몰려든 쇼핑몰 바닥으로 다시. "
        .. "two-sum, 회문, 애너그램, 단어 세기. 전부 해시 맵 아니면 길이 26의 배열이고, 전부 O(n).",
      "七點四十四分。第六回合，經典題，返到商場地下，觀眾迫埋嚟。"
        .. "two-sum、回文、anagram、數字。每一題都係 hash map 或者長度 26 嘅 array，每一題都係 O(n)。"
    ),
    stages = {
      {
        topic = "TWOSUM",
        q = L(
          "Two numbers that add up to target. Store value to index; for each x ask if target - x is already there. Which method?",
          "합이 target인 두 수. 값을 인덱스로 저장; x마다 target - x가 이미 있는지 묻는다. 어떤 메서드?",
          "兩個數加埋等於 target。存值對 index；每個 x 問吓 target - x 係咪已經喺度。邊個 method？"
        ),
        code = L(
          [[
// two_sum: value -> index in a HashMap, one pass, O(n)
let mut seen = HashMap::new();
for (i, &x) in nums.iter().enumerate() {
    let want = target - x;
    if seen.___(&want) { return Some((seen[&want], i)); }
    seen.insert(x, i);
}
]],
          [[
// two_sum: HashMap에 값 -> 인덱스, O(n)
let mut seen = HashMap::new();
for (i, &x) in nums.iter().enumerate() {
    let want = target - x;
    if seen.___(&want) { return Some((seen[&want], i)); }
    seen.insert(x, i);
}
]],
          [[
// two_sum：HashMap 存值 -> index，行一次，O(n)
let mut seen = HashMap::new();
for (i, &x) in nums.iter().enumerate() {
    let want = target - x;
    if seen.___(&want) { return Some((seen[&want], i)); }
    seen.insert(x, i);
}
]]
        ),
        answer = "contains_key",
        accept = { "contains_key", "contains_key()" },
        hint = L(
          "contains, underscore, key. Returns bool. Its cousin get would return the index directly.",
          "contains, 밑줄, key. bool 반환. 사촌 get은 인덱스를 바로 돌려준다.",
          "contains、底線、key。回傳 bool。佢表親 get 會直接俾你個 index。"
        ),
        ok = L(
          "One pass, one HashMap: O(n) instead of the O(n^2) double loop. seen[&want] then fetches the partner's index.",
          "한 번 훑기, HashMap 하나: O(n^2) 이중 루프 대신 O(n). seen[&want]가 짝의 인덱스를 가져온다.",
          "行一次，一個 HashMap：O(n) 取代 O(n^2) 嘅雙重 loop。seen[&want] 再攞返個拍檔嘅 index。"
        ),
      },
      {
        topic = "REV",
        q = L(
          "Palindrome: the chars read the same backwards. Which iterator method walks from the end?",
          "회문: 거꾸로 읽어도 같은 문자열. 끝에서부터 걷는 이터레이터 메서드는?",
          "回文：啲字元倒轉讀都一樣。邊個 iterator method 由尾行起？"
        ),
        code = L(
          [[
fn is_palindrome(s: &str) -> bool {
    // forwards and backwards, compared element by element
    s.chars().eq(s.chars().___())
}
]],
          [[
fn is_palindrome(s: &str) -> bool {
    // 앞으로와 뒤로, 원소 하나씩 비교
    s.chars().eq(s.chars().___())
}
]],
          [[
fn is_palindrome(s: &str) -> bool {
    // 順住同倒住，逐個元素比較
    s.chars().eq(s.chars().___())
}
]]
        ),
        answer = "rev",
        accept = { "rev", "rev()" },
        hint = L(
          "Three letters, short for reverse. Only a DoubleEndedIterator has it, and Chars is one.",
          "세 글자, reverse의 줄임. DoubleEndedIterator에만 있고 Chars가 그중 하나.",
          "三個字母，reverse 嘅縮寫。淨係 DoubleEndedIterator 有，Chars 係其中一個。"
        ),
        ok = L(
          "Iterator::eq compares two iterators without building a String. chars() walks Unicode scalars, not bytes.",
          "Iterator::eq는 String을 만들지 않고 두 이터레이터를 비교. chars()는 바이트가 아닌 유니코드 스칼라를 걷는다.",
          "Iterator::eq 唔使砌 String 就比較兩個 iterator。chars() 行嘅係 Unicode scalar，唔係 byte。"
        ),
      },
      {
        topic = "CLEAN",
        q = L(
          '"Lucky Mac, cam ykcul" should pass: skip spaces and commas first. Which iterator adapter keeps only some items?',
          '"Lucky Mac, cam ykcul"도 통과해야 한다: 먼저 공백과 쉼표를 건너뛴다. 일부만 남기는 이터레이터 어댑터는?',
          '"Lucky Mac, cam ykcul" 都要過：先跳過空格同逗號。邊個 iterator adapter 淨係留低某啲項目？'
        ),
        code = L(
          [[
fn is_palindrome(s: &str) -> bool {
    let t: Vec<char> = s.chars()
        .___(|c| c.is_alphanumeric())  // letters, digits
        .map(|c| c.to_ascii_lowercase())
        .collect();
    t.iter().eq(t.iter().rev())
}
]],
          [[
fn is_palindrome(s: &str) -> bool {
    let t: Vec<char> = s.chars()
        .___(|c| c.is_alphanumeric())  // 글자, 숫자만
        .map(|c| c.to_ascii_lowercase())
        .collect();
    t.iter().eq(t.iter().rev())
}
]],
          [[
fn is_palindrome(s: &str) -> bool {
    let t: Vec<char> = s.chars()
        .___(|c| c.is_alphanumeric())  // 淨要字母數字
        .map(|c| c.to_ascii_lowercase())
        .collect();
    t.iter().eq(t.iter().rev())
}
]]
        ),
        answer = "filter",
        accept = { "filter", "filter()" },
        hint = L(
          "Six letters. The closure gets &char and returns bool; true keeps the item.",
          "여섯 글자. 클로저는 &char를 받아 bool을 반환; true면 남긴다.",
          "六個字母。closure 收 &char 回傳 bool；true 就留低。"
        ),
        ok = L(
          "filter, map, collect: the chain is lazy until collect. Collecting once lets us iterate twice, forwards and rev.",
          "filter, map, collect: 체인은 collect 전까지 지연. 한 번 모아두면 앞뒤로 두 번 순회할 수 있다.",
          "filter、map、collect：條 chain 去到 collect 先真係行。collect 一次就可以順住倒住行兩次。"
        ),
      },
      {
        topic = "ANAGRAM",
        q = L(
          "Anagram: same letters, same counts. Lowercase ASCII only. How many slots does the counter array need?",
          "애너그램: 같은 글자, 같은 개수. 소문자 ASCII만. 카운터 배열에 칸이 몇 개 필요?",
          "Anagram：同樣嘅字母、同樣嘅數量。淨係細楷 ASCII。個 counter array 要幾多格？"
        ),
        code = L(
          [[
fn is_anagram(a: &str, b: &str) -> bool {
    let mut count = [0i32; ___];    // one slot per letter
    for c in a.bytes() { count[(c - b'a') as usize] += 1; }
    for c in b.bytes() { count[(c - b'a') as usize] -= 1; }
    count.iter().all(|&n| n == 0)
}
]],
          [[
fn is_anagram(a: &str, b: &str) -> bool {
    let mut count = [0i32; ___];    // 글자마다 한 칸
    for c in a.bytes() { count[(c - b'a') as usize] += 1; }
    for c in b.bytes() { count[(c - b'a') as usize] -= 1; }
    count.iter().all(|&n| n == 0)
}
]],
          [[
fn is_anagram(a: &str, b: &str) -> bool {
    let mut count = [0i32; ___];    // 每個字母一格
    for c in a.bytes() { count[(c - b'a') as usize] += 1; }
    for c in b.bytes() { count[(c - b'a') as usize] -= 1; }
    count.iter().all(|&n| n == 0)
}
]]
        ),
        answer = "26",
        accept = { "26" },
        hint = L(
          "a to z. The array length is part of the type, so it must be a constant.",
          "a부터 z까지. 배열 길이는 타입의 일부라 상수여야 한다.",
          "a 到 z。array 長度係 type 嘅一部分，所以一定要係常數。"
        ),
        ok = L(
          "[0i32; 26] lives on the stack: no HashMap, no allocation. Add for a, subtract for b, all zero means anagram.",
          "[0i32; 26]은 스택에: HashMap도 할당도 없음. a는 더하고 b는 빼서 전부 0이면 애너그램.",
          "[0i32; 26] 放喺 stack：冇 HashMap、冇 allocation。a 加、b 減，全部係零就係 anagram。"
        ),
      },
      {
        topic = "INDEX",
        q = L(
          "c - b'a' is a u8 from 0 to 25. Arrays are indexed by exactly one integer type. Cast to which?",
          "c - b'a'는 0부터 25까지의 u8. 배열 인덱스는 정확히 한 정수 타입만. 어디로 캐스팅?",
          "c - b'a' 係 0 到 25 嘅 u8。array 淨係可以用一種整數 type 做 index。cast 去邊個？"
        ),
        code = L(
          [[
// b'a' is the byte 97. Subtracting it maps a..z onto 0..26.
// An array index must be the pointer-sized unsigned type.
let mut count = [0i32; 26];
for c in "muffin".bytes() {
    count[(c - b'a') as ___] += 1;
}
]],
          [[
// b'a'는 바이트 97. 빼면 a..z가 0..26이 된다.
// 배열 인덱스는 포인터 크기의 unsigned 타입.
let mut count = [0i32; 26];
for c in "muffin".bytes() {
    count[(c - b'a') as ___] += 1;
}
]],
          [[
// b'a' 係 byte 97。減咗佢，a..z 就對應 0..26。
// array index 一定係 pointer 咁大嘅無符號 type。
let mut count = [0i32; 26];
for c in "muffin".bytes() {
    count[(c - b'a') as ___] += 1;
}
]]
        ),
        answer = "usize",
        accept = { "usize" },
        hint = L(
          "u for unsigned, then the word for pointer size. Same type as len() returns.",
          "unsigned의 u, 그다음 포인터 크기를 뜻하는 단어. len()이 반환하는 타입과 같다.",
          "u 係 unsigned，後面係代表 pointer 大小嘅字。同 len() 回傳嘅 type 一樣。"
        ),
        ok = L(
          "as usize widens the u8 for free. A u8 index would not compile: Rust never converts integers silently.",
          "as usize는 u8을 공짜로 넓힌다. u8 인덱스는 컴파일 안 됨: Rust는 정수를 조용히 변환하지 않는다.",
          "as usize 免費將 u8 擴闊。用 u8 做 index compile 唔到：Rust 永遠唔會靜靜雞轉整數。"
        ),
      },
      {
        topic = "COUNT",
        q = L(
          "Word count. New word: start at 0. Seen word: bump it. One entry call does both. Fill: entry(w).___(0)",
          "단어 세기. 새 단어: 0에서 시작. 본 단어: 하나 올린다. entry 호출 하나로 둘 다: entry(w).___(0)",
          "數字。新字：由 0 開始。見過嘅字：加一。一個 entry call 做晒兩樣：entry(w).___(0)"
        ),
        code = L(
          [[
let mut counts: HashMap<&str, u32> = HashMap::new();
for w in "muffin coffee muffin".split(' ') {
    // start at 0 if w is new, then bump it either way
    *counts.entry(w).___(0) += 1;
}
assert_eq!(counts["muffin"], 2);
]],
          [[
let mut counts: HashMap<&str, u32> = HashMap::new();
for w in "muffin coffee muffin".split(' ') {
    // 새 단어면 0에서 시작, 그다음 +1
    *counts.entry(w).___(0) += 1;
}
assert_eq!(counts["muffin"], 2);
]],
          [[
let mut counts: HashMap<&str, u32> = HashMap::new();
for w in "muffin coffee muffin".split(' ') {
    // w 係新字就由 0 開始，兩種情況都加一
    *counts.entry(w).___(0) += 1;
}
assert_eq!(counts["muffin"], 2);
]]
        ),
        answer = "or_insert",
        accept = { "or_insert", "or_insert()" },
        hint = L(
          "or, underscore, insert. Takes the starting value and returns &mut u32, which the * dereferences.",
          "or, 밑줄, insert. 시작값을 받고 &mut u32를 반환, *가 그걸 역참조.",
          "or、底線、insert。收起始值，回傳 &mut u32，個 * 就 deref 佢。"
        ),
        ok = L(
          "The entry API: one lookup, insert or update. The classics done, no misses. Combo x6. One round left.",
          "entry API: 조회 한 번으로 삽입 또는 갱신. 고전 문제 무실수 완료. 콤보 x6. 한 라운드 남았다.",
          "entry API：查一次，插入或者更新。經典題零失誤完成。連擊 x6。剩返一個回合。"
        ),
      },
    },
  },

  {
    id = "rs_workers",
    station = "WORKERS",
    name = L("FINAL  -  the kitchen", "파이널  -  주방", "決賽  -  廚房"),
    title = L("Worker pool with threads", "스레드 워커 풀", "用 thread 做 worker pool"),
    lesson = L(
      "Worker pool: an mpsc channel of jobs, the Receiver in Arc<Mutex<>>, N thread::spawn workers looping on recv. drop(tx) ends them, join waits.",
      "워커 풀: 작업의 mpsc 채널, Receiver는 Arc<Mutex<>>에, thread::spawn 워커 N개가 recv를 반복. drop(tx)로 종료, join으로 대기.",
      "Worker pool：一條 job 嘅 mpsc channel，Receiver 放喺 Arc<Mutex<>>，N 個 thread::spawn worker loop 住 recv。drop(tx) 結束佢哋，join 等佢哋。"
    ),
    bg = "bg_mall",
    portrait = "portrait_clerk",
    speaker = L("Siu Ming", "시우밍", "小明"),
    ground = 348,
    spawn = 180,
    width = 1680,
    npcs = {
      {
        kind = "cook",
        x = 560,
        facing = -1,
        line = L(
          "Three cooks, one ticket rail, one lock on the rail. That is a worker pool.",
          "요리사 셋, 주문 레일 하나, 레일에 자물쇠 하나. 그게 워커 풀.",
          "三個廚師、一條單軌、單軌上面一把鎖。呢個就係 worker pool。"
        ),
      },
      {
        kind = "hero",
        x = 920,
        facing = -1,
        line = L(
          "Final round, Mei! Get the drop and the join in the right order and you're HIRED!",
          "파이널이야, 메이! drop과 join 순서만 맞추면 HIRED야!",
          "決賽啦，阿美！drop 同 join 嘅次序啱就 HIRED！"
        ),
      },
    },
    viz = "rust",
    chips = {
      { "mpsc::channel::<Job>()", "cyan" },
      { "Arc<Mutex<Receiver>>", "gold" },
      { "thread::spawn(move ||", "pink" },
      { "h.join().unwrap()", "green" },
    },
    note = "channel  Arc<Mutex>  spawn  recv  drop  join",
    story = L(
      "19:55. The final, the one they always ask: N worker threads pull jobs from one channel. "
        .. "The Times Square screen shows the Lucky Mac Express kitchen as the diagram. Get the lock, the drop and the join right and the prize is HIRED.",
      "19:55. 파이널, 늘 나오는 그 문제: 워커 스레드 N개가 채널 하나에서 작업을 꺼낸다. "
        .. "타임스퀘어 전광판이 럭키 맥 익스프레스 주방을 다이어그램으로 보여준다. 자물쇠, drop, join만 맞추면 상품은 HIRED.",
      "七點五十五分。決賽，佢哋一定會問嘅：N 個 worker thread 由一條 channel 攞 job。"
        .. "時代廣場大螢幕將幸運麥 Express 嘅廚房畫成圖。鎖、drop 同 join 都啱嘅話，獎品就係 HIRED。"
    ),
    stages = {
      {
        topic = "CHANNEL",
        q = L(
          "One ticket rail: the front sends boxed jobs, the cooks receive them. Which mpsc function makes the (tx, rx) pair?",
          "주문 레일 하나: 프런트가 박스에 담긴 작업을 보내고 요리사가 받는다. (tx, rx) 쌍을 만드는 mpsc 함수는?",
          "一條單軌：前台送 box 住嘅 job，廚師收。邊個 mpsc function 整 (tx, rx) 嗰對？"
        ),
        code = L(
          [[
use std::sync::mpsc;
type Job = Box<dyn FnOnce() + Send>;
// one rail: many senders allowed, exactly one receiver
let (tx, rx) = mpsc::___::<Job>();
]],
          [[
use std::sync::mpsc;
type Job = Box<dyn FnOnce() + Send>;
// 레일 하나: 송신자는 여럿, 수신자는 하나
let (tx, rx) = mpsc::___::<Job>();
]],
          [[
use std::sync::mpsc;
type Job = Box<dyn FnOnce() + Send>;
// 一條軌：send 可以好多個，receive 淨係一個
let (tx, rx) = mpsc::___::<Job>();
]]
        ),
        answer = "channel",
        accept = { "channel", "channel()", "mpsc::channel" },
        hint = L(
          "Seven letters, the unbounded one. sync_channel(n) would take a capacity.",
          "일곱 글자, 무제한 버전. sync_channel(n)은 용량을 받는다.",
          "七個字母，冇上限嗰個。sync_channel(n) 就要俾容量。"
        ),
        ok = L(
          "mpsc: multi-producer, single-consumer. Job is Send so it may cross to another thread; FnOnce because each ticket runs once.",
          "mpsc: 다중 생산자, 단일 소비자. Job은 Send라 다른 스레드로 넘어갈 수 있고, 티켓은 한 번만 실행되니 FnOnce.",
          "mpsc：多個 producer，一個 consumer。Job 係 Send 所以可以過去另一個 thread；每張單得行一次所以係 FnOnce。"
        ),
      },
      {
        topic = "SHARE",
        q = L(
          "Receiver is Send but not Sync: three cooks cannot read the rail at once. Arc shares it; what hands out turns?",
          "Receiver는 Send지만 Sync는 아님: 요리사 셋이 동시에 레일을 읽을 수 없다. Arc로 공유; 차례를 나눠주는 것은?",
          "Receiver 係 Send 但唔係 Sync：三個廚師唔可以同時讀條軌。Arc 共用佢；邊個負責派輪次？"
        ),
        code = L(
          [[
use std::sync::Arc;
// Arc: one receiver, many owners across threads.
// The lock: only one cook holds the rail at a time.
let rx = Arc::new(___::new(rx));
let rx2 = Arc::clone(&rx);       // one clone per cook
]],
          [[
use std::sync::Arc;
// Arc: 리시버 하나, 스레드 너머 주인은 여럿.
// 자물쇠: 한 번에 요리사 한 명만
let rx = Arc::new(___::new(rx));
let rx2 = Arc::clone(&rx);       // 요리사마다 clone
]],
          [[
use std::sync::Arc;
// Arc：一個 receiver，跨 thread 有好多主人。
// 把鎖：同一時間淨係一個廚師揸住條軌。
let rx = Arc::new(___::new(rx));
let rx2 = Arc::clone(&rx);       // 每個廚師一個 clone
]]
        ),
        answer = "Mutex",
        accept = { "Mutex", "std::sync::Mutex", "sync::Mutex" },
        hint = L(
          "Mutual exclusion, shortened to five letters. lock() gives a guard; the guard unlocks on drop.",
          "mutual exclusion을 다섯 글자로. lock()이 guard를 주고, guard가 drop되면 잠금 해제.",
          "mutual exclusion 縮做五個字母。lock() 俾你個 guard；guard drop 就解鎖。"
        ),
        ok = L(
          "Arc<Mutex<Receiver<Job>>> is Send + Sync, so it can be moved into every worker. The rail is shared, the pull is exclusive.",
          "Arc<Mutex<Receiver<Job>>>는 Send + Sync라 모든 워커로 이동 가능. 레일은 공유, 꺼내기는 배타적.",
          "Arc<Mutex<Receiver<Job>>> 係 Send + Sync，所以可以 move 入每個 worker。條軌共用，攞嘢就獨佔。"
        ),
      },
      {
        topic = "SPAWN",
        q = L(
          "Three cooks, three OS threads. Which thread function runs a closure and returns a JoinHandle?",
          "요리사 셋, OS 스레드 셋. 클로저를 실행하고 JoinHandle을 돌려주는 thread 함수는?",
          "三個廚師，三個 OS thread。邊個 thread function 行一個 closure 然後回傳 JoinHandle？"
        ),
        code = L(
          [[
let mut handles = Vec::new();
for id in 0..3 {
    let rx = Arc::clone(&rx);
    // a new OS thread runs the closure; move hands over rx
    handles.push(thread::___(move || worker(id, rx)));
}
]],
          [[
let mut handles = Vec::new();
for id in 0..3 {
    let rx = Arc::clone(&rx);
    // 새 OS 스레드가 클로저 실행; move로 rx
    handles.push(thread::___(move || worker(id, rx)));
}
]],
          [[
let mut handles = Vec::new();
for id in 0..3 {
    let rx = Arc::clone(&rx);
    // 新 OS thread 行個 closure；move 交 rx 俾佢
    handles.push(thread::___(move || worker(id, rx)));
}
]]
        ),
        answer = "spawn",
        accept = { "spawn", "spawn()", "thread::spawn" },
        hint = L(
          "Five letters, what a fish does with eggs. The closure must be 'static, hence move.",
          "다섯 글자, 물고기가 알을 낳는 것. 클로저는 'static이어야 하니 move.",
          "五個字母，魚生蛋嗰個字。closure 一定要係 'static，所以要 move。"
        ),
        ok = L(
          "thread::spawn returns JoinHandle<T>. Keep them in a Vec, or the threads are detached and main may exit first.",
          "thread::spawn은 JoinHandle<T>를 반환. Vec에 보관하지 않으면 스레드는 분리되어 main이 먼저 끝날 수 있다.",
          "thread::spawn 回傳 JoinHandle<T>。要放喺 Vec 度，唔係啲 thread 就 detach 咗，main 可能先走。"
        ),
      },
      {
        topic = "RECV",
        q = L(
          "A cook locks the rail, pulls one ticket, releases. Which Receiver method blocks until a job arrives?",
          "요리사가 레일을 잠그고 티켓 하나를 꺼내고 푼다. 작업이 올 때까지 막는 Receiver 메서드는?",
          "廚師鎖住條軌，攞一張單，放手。邊個 Receiver method 會 block 住直到有 job 到？"
        ),
        code = L(
          [[
// worker(id, rx): the let drops the lock guard at the
// semicolon, so the job runs with the rail unlocked.
loop {
    let msg = rx.lock().unwrap().___();
    let Ok(job) = msg else { break };  // Err: senders gone
    job();
}
]],
          [[
// worker(id, rx): let 문이 세미콜론에서 guard를
// drop하니 작업은 레일이 풀린 채 실행된다.
loop {
    let msg = rx.lock().unwrap().___();
    let Ok(job) = msg else { break };  // Err: 송신자 0
    job();
}
]],
          [[
// worker(id, rx)：let 句喺分號 drop 個 lock guard，
// 所以 job 行嗰陣條軌已經解咗鎖。
loop {
    let msg = rx.lock().unwrap().___();
    let Ok(job) = msg else { break };  // Err：冇 sender
    job();
}
]]
        ),
        answer = "recv",
        accept = { "recv", "recv()" },
        hint = L(
          "Four letters, short for receive. Returns Result<Job, RecvError>. try_recv would not wait.",
          "네 글자, receive의 줄임. Result<Job, RecvError> 반환. try_recv는 기다리지 않는다.",
          "四個字母，receive 嘅縮寫。回傳 Result<Job, RecvError>。try_recv 就唔會等。"
        ),
        ok = L(
          "recv blocks with no busy loop. Not while let: its temporaries live for the whole body and would hold the lock during job().",
          "recv는 바쁜 대기 없이 막는다. while let은 안 됨: 임시값이 본문 내내 살아 job() 동안 lock을 쥔다.",
          "recv 會 block，冇 busy loop。唔好用 while let：佢啲 temporary 成個 body 都生存，job() 期間會揸住個 lock。"
        ),
      },
      {
        topic = "HANGUP",
        q = L(
          "Six tickets sent. Now end the cooks' loops: recv must return Err. What do you do with tx?",
          "티켓 여섯 장 전송 완료. 이제 요리사들의 루프를 끝내려면 recv가 Err를 돌려줘야 한다. tx를 어떻게?",
          "送咗六張單。而家要結束廚師嘅 loop：recv 一定要回傳 Err。tx 要點？"
        ),
        code = L(
          [[
for i in 0..6 {
    tx.send(Box::new(move || println!("#{i}"))).unwrap();
}
// hang up our end: once every sender is gone, recv() is Err
// and each cook leaves the loop after the rail is empty
___(tx);
]],
          [[
for i in 0..6 {
    tx.send(Box::new(move || println!("#{i}"))).unwrap();
}
// 우리 쪽을 끊는다: 송신자 0이면 recv()는 Err,
// 레일이 비면 요리사들이 루프를 나간다
___(tx);
]],
          [[
for i in 0..6 {
    tx.send(Box::new(move || println!("#{i}"))).unwrap();
}
// 收線：所有 sender 冇晒，recv() 就回傳 Err，
// 條軌清空之後每個廚師都會離開 loop
___(tx);
]]
        ),
        answer = "drop",
        accept = { "drop", "std::mem::drop", "mem::drop" },
        hint = L(
          "The four-letter function from the prelude that ends a value early. Not close: channels have no close.",
          "값을 일찍 끝내는 prelude의 네 글자 함수. close 아님: 채널엔 close가 없다.",
          "prelude 入面提早結束一個值嘅四個字母 function。唔係 close：channel 冇 close。"
        ),
        ok = L(
          "drop(tx): the channel closes when the last Sender is gone. Queued jobs are still delivered first. Forget this and join waits forever.",
          "drop(tx): 마지막 Sender가 사라지면 채널이 닫힌다. 쌓인 작업은 먼저 다 전달된다. 이걸 잊으면 join이 영원히 기다린다.",
          "drop(tx)：最後一個 Sender 冇咗，channel 就閂。排緊隊嘅 job 仲會先派晒。唔記得呢步，join 就永遠等落去。"
        ),
      },
      {
        topic = "JOIN",
        q = L(
          "Wait for every cook to finish before closing the kitchen. Which JoinHandle method blocks until the thread ends?",
          "주방을 닫기 전에 모든 요리사가 끝나길 기다린다. 스레드가 끝날 때까지 막는 JoinHandle 메서드는?",
          "閂廚房之前等每個廚師做完。邊個 JoinHandle method 會 block 住直到 thread 完？"
        ),
        code = L(
          [[
drop(tx);
// wait for each cook; unwrap re-raises a panic from it
for h in handles {
    h.___().unwrap();
}
println!("kitchen closed");
]],
          [[
drop(tx);
// 요리사를 다 기다림; unwrap은 panic 재전파
for h in handles {
    h.___().unwrap();
}
println!("kitchen closed");
]],
          [[
drop(tx);
// 等晒所有廚師；unwrap 會再拋出嗰邊嘅 panic
for h in handles {
    h.___().unwrap();
}
println!("kitchen closed");
]]
        ),
        answer = "join",
        accept = { "join", "join()" },
        hint = L(
          "Four letters. Consumes the handle and returns Result<T, Box<dyn Any + Send>>.",
          "네 글자. 핸들을 소비하고 Result<T, Box<dyn Any + Send>>를 반환.",
          "四個字母。食咗個 handle，回傳 Result<T, Box<dyn Any + Send>>。"
        ),
        ok = L(
          "drop, then join, in that order. Seven rounds, no misses, combo x7. The screen says HIRED and the crab on the kiosk waves.",
          "drop 다음 join, 그 순서. 일곱 라운드 무실수, 콤보 x7. 화면에 HIRED가 뜨고 키오스크의 게가 손을 흔든다.",
          "先 drop，再 join，次序係咁。七個回合零失誤，連擊 x7。螢幕寫住 HIRED，部機上面隻蟹揮手。"
        ),
      },
    },
  },
}

return maps
