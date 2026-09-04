-- Quest R5 BIG O: how fast is it, the Rust round. The same seven streets as
-- src/data_bigo.lua, O(1) to O(2^n) and then space, with Rust on the
-- whiteboard: Vec, HashMap, HashSet, binary_search, sort_unstable.
-- Same shape as src/data.lua: the blank ___ is NOT written in the code.

local function L(en, ko, yue)
  return { en = en, ko = ko, yue = yue }
end

local maps = {
  {
    id = "rs_bigo_one",
    station = "O(1)",
    name = L("The counter", "카운터", "櫃位"),
    title = L("Constant time", "상수 시간", "常數時間"),
    lesson = L(
      "O(1): the same number of steps however big the input. Indexing a Vec, a HashMap lookup, .last(). Doubling n changes nothing.",
      "O(1): 입력이 얼마나 커도 같은 단계 수. Vec 인덱싱, HashMap 조회, .last(). n이 두 배가 돼도 변하지 않는다.",
      "O(1)：輸入幾大都係同樣步數。Vec index、HashMap 查找、.last()。n 翻倍都冇變。"
    ),
    bg = "bg_lab",
    portrait = "portrait_friends",
    speaker = L("Mei", "메이", "阿美"),
    ground = 348,
    spawn = 160,
    width = 1600,
    npcs = {
      {
        kind = "mei",
        x = 540,
        facing = -1,
        line = L(
          "Same board, Rust this time. The question never changes: input doubles, then what?",
          "같은 보드, 이번엔 Rust. 질문은 변하지 않아: 입력이 두 배면, 그다음은?",
          "同一塊白板，今次 Rust。問題永遠唔變：輸入翻倍，然後點？"
        ),
      },
    },
    viz = "rust",
    chips = {
      { "items[3]", "cyan" },
      { 'menu["tea"]', "gold" },
      { "items.last()", "pink" },
      { "O(1)", "green" },
    },
    note = "index  HashMap  last  n doubles -> same",
    story = L(
      "The whiteboard again, the Rust column this time. Mei redraws the axes: n across, work up. "
        .. "First street: the operations whose line stays flat, written the Rust way.",
      "다시 화이트보드, 이번엔 Rust 칸. 메이가 축을 다시 그린다: 가로 n, 세로 일. 첫 거리: 선이 평평한 연산들, Rust식으로.",
      "又係白板，今次係 Rust 欄。阿美重畫兩條軸：橫係 n，直係工作量。第一條街：條線平嘅操作，用 Rust 寫法。"
    ),
    stages = {
      {
        topic = "INDEX",
        q = L(
          "Reading items[3] from a Vec of n items: how many steps, in Big O?",
          "n개짜리 Vec에서 items[3]을 읽기: 빅오로 몇 단계?",
          "由 n 個元素嘅 Vec 讀 items[3]：Big O 係幾多步？"
        ),
        code = L(
          [[
fn fourth(items: &[i32]) -> i32 {
    items[3]    // ___ : one address, one read
}
]],
          [[
fn fourth(items: &[i32]) -> i32 {
    items[3]    // ___ : 주소 하나, 읽기 한 번
}
]],
          [[
fn fourth(items: &[i32]) -> i32 {
    items[3]    // ___ ：一個地址，一次讀取
}
]]
        ),
        answer = "O(1)",
        accept = { "O(1)", "1", "constant" },
        hint = L(
          "Constant. A slice is a pointer and a length; index 3 is pointer plus 3 times the element size, after a bounds check.",
          "상수. 슬라이스는 포인터와 길이. 3번은 경계 검사 뒤 포인터 더하기 3 곱하기 원소 크기.",
          "常數。slice 係一個 pointer 加長度；index 3 係 bounds check 之後 pointer 加 3 乘元素大小。"
        ),
        ok = L(
          "O(1): the bounds check is one compare, the read one load, whatever n is. Read 'order one'.",
          "O(1): 경계 검사는 비교 한 번, 읽기는 로드 한 번, n이 무엇이든. '오더 원'으로 읽는다.",
          "O(1)：bounds check 一次比較，讀取一次 load，n 係幾多都一樣。讀「order one」。"
        ),
      },
      {
        topic = "LOOKUP",
        q = L(
          "Which std collection finds a price by name in O(1), on average?",
          "어떤 std 컬렉션이 이름으로 가격을 평균 O(1)에 찾나?",
          "邊個 std collection 平均用 O(1) 按名搵價錢？"
        ),
        code = L(
          [[
use std::collections::___;

let mut menu = ___::new();
menu.insert("tea", 12);
let price = menu["tea"];    // hash, bucket, compare
]],
          [[
use std::collections::___;

let mut menu = ___::new();
menu.insert("tea", 12);
let price = menu["tea"];    // 해시, 버킷, 비교
]],
          [[
use std::collections::___;

let mut menu = ___::new();
menu.insert("tea", 12);
let price = menu["tea"];    // hash、bucket、比較
]]
        ),
        answer = "HashMap",
        accept = { "HashMap" },
        hint = L(
          "A map built on hashing, CapWords. A Vec of pairs would need a scan, O(n).",
          "해시 기반의 맵, CapWords. 쌍의 Vec이면 O(n) 스캔.",
          "基於 hash 嘅 map，CapWords。用 pair Vec 要 scan，O(n)。"
        ),
        ok = L(
          "HashMap: O(1) average, O(n) worst case when everything collides. BTreeMap is O(log n) but ordered.",
          "HashMap: 평균 O(1), 전부 충돌하면 최악 O(n). BTreeMap은 O(log n)이지만 정렬돼 있다.",
          "HashMap：平均 O(1)，全部撞埋最差 O(n)。BTreeMap 係 O(log n) 但有序。"
        ),
      },
      {
        topic = "LAST",
        q = L(
          "The last item of a Vec in one step, as an Option. Which method?",
          "Vec의 마지막 항목을 한 단계로, Option으로. 어떤 메서드?",
          "一步攞 Vec 最後一個，以 Option 形式。邊個 method？"
        ),
        code = L(
          [[
let tail = items.___();    // Some(&x) or None; still O(1)
]],
          [[
let tail = items.___();    // Some(&x) 또는 None; 여전히 O(1)
]],
          [[
let tail = items.___();    // Some(&x) 或 None；仍然 O(1)
]]
        ),
        answer = "last",
        accept = { "last" },
        hint = L(
          "Four letters, the opposite of first. The length is stored, so no counting.",
          "네 글자, first의 반대. 길이가 저장돼 있어 세지 않는다.",
          "四個字母，first 嘅相反。長度係存起嘅，唔使數。"
        ),
        ok = L(
          "items.last() is items.get(len - 1). O(1), and no panic on an empty Vec. push at the end is O(1) amortized.",
          "items.last()는 items.get(len - 1). O(1)이고 빈 Vec에서도 패닉 없음. 끝에 push는 분할 상환 O(1).",
          "items.last() 就係 items.get(len - 1)。O(1)，空 Vec 都唔會 panic。尾部 push 攤分係 O(1)。"
        ),
      },
      {
        topic = "DOUBLE",
        q = L(
          "n doubles from 1000 to 2000 items. An O(1) operation takes how long compared to before, in one word?",
          "n이 1000에서 2000으로 두 배. O(1) 연산은 전보다 얼마나 걸리나, 한 단어로?",
          "n 由 1000 翻倍到 2000。O(1) 操作同之前比要幾長時間，一個字？"
        ),
        code = L(
          [[
// n = 1000 -> items[3] : 1 step
// n = 2000 -> items[3] : 1 step
// the cost stays the ___
]],
          [[
// n = 1000 -> items[3] : 1단계
// n = 2000 -> items[3] : 1단계
// 비용은 그대로: the ___
]],
          [[
// n = 1000 -> items[3] : 1 步
// n = 2000 -> items[3] : 1 步
// 成本保持 the ___
]]
        ),
        answer = "same",
        accept = { "same", "constant", "unchanged", "equal" },
        hint = L(
          "Unchanged. That is the whole meaning of the 1 in O(1).",
          "변하지 않는다. 그게 O(1)의 1이 뜻하는 전부.",
          "冇變。呢個就係 O(1) 裏面個 1 嘅全部意思。"
        ),
        ok = L(
          "Same. Big O drops constants: O(2), O(500) are all O(1). The flat line is drawn.",
          "그대로. 빅오는 상수를 버린다: O(2), O(500)은 모두 O(1). 평평한 선이 그려진다.",
          "一樣。Big O 掉走常數：O(2)、O(500) 全部係 O(1)。平線畫好。"
        ),
      },
    },
  },
  {
    id = "rs_bigo_n",
    station = "O(N)",
    name = L("The queue", "줄", "條隊"),
    title = L("Linear time", "선형 시간", "線性時間"),
    lesson = L(
      "O(n): one pass over the input; double n, double the work. iter().sum(), any(), Vec::contains. O(n) + O(n) is still O(n): constants drop.",
      "O(n): 입력을 한 번 통과. n이 두 배면 일도 두 배. iter().sum(), any(), Vec::contains. O(n) + O(n)도 O(n): 상수는 버린다.",
      "O(n)：輸入行一次；n 翻倍，工作翻倍。iter().sum()、any()、Vec::contains。O(n) + O(n) 仍然係 O(n)：常數掉走。"
    ),
    bg = "bg_queue",
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
          "Counting the queue takes one look per person. Twice the queue, twice the looking.",
          "줄을 세는 데는 사람마다 한 번씩 봐야 해요. 줄이 두 배면 보는 것도 두 배.",
          "數條隊每個人望一眼。隊長一倍，望多一倍。"
        ),
      },
    },
    viz = "rust",
    chips = {
      { "prices.iter().sum()", "cyan" },
      { ".any(|s| s == q)", "gold" },
      { "O(n) + O(n) = O(n)", "pink" },
      { "n - 1 comparisons", "green" },
    },
    note = "one pass  iter  any  drop constants",
    story = L(
      "The queue outside the shutter. To total everyone's bill you visit each person once. "
        .. "Mei draws the diagonal again, and Alex writes it as an iterator chain instead of a loop.",
      "셔터 밖의 줄. 모두의 계산서를 합하려면 한 사람씩 한 번 방문. 메이가 대각선을 다시 그리고, 알렉스는 루프 대신 이터레이터 체인으로 쓴다.",
      "閘門外面條隊。要加埋每個人嘅單，每人探訪一次。阿美再畫斜線，阿力用 iterator chain 代替 loop 寫出嚟。"
    ),
    stages = {
      {
        topic = "PASS",
        q = L(
          "Summing n prices with an iterator: what is the cost in Big O?",
          "이터레이터로 n개 가격 합하기: 빅오로 비용은?",
          "用 iterator 加 n 個價錢：Big O 成本係？"
        ),
        code = L(
          [[
let total: i32 = prices.iter().sum();   // ___ : n items, n adds
]],
          [[
let total: i32 = prices.iter().sum();   // ___ : n개 항목, n번 더하기
]],
          [[
let total: i32 = prices.iter().sum();   // ___ ：n 個項目，n 次加
]]
        ),
        answer = "O(n)",
        accept = { "O(n)", "linear" },
        hint = L(
          "Linear: the work grows in step with the input. Iterator chains hide the loop but not the cost.",
          "선형: 일이 입력과 나란히 자란다. 이터레이터 체인은 루프를 숨기지만 비용은 숨기지 못한다.",
          "線性：工作量同輸入一齊增長。iterator chain 收埋個 loop，但收唔埋成本。"
        ),
        ok = L(
          "O(n). sum, map, filter, count: every adapter is one pass. Zero-cost abstractions are still O(n) abstractions.",
          "O(n). sum, map, filter, count: 모든 어댑터가 한 번 통과. 제로 코스트 추상화도 O(n) 추상화.",
          "O(n)。sum、map、filter、count：每個 adapter 都係一次過。零成本抽象仍然係 O(n) 抽象。"
        ),
      },
      {
        topic = "DROP",
        q = L(
          "Two separate passes over the same n items, one after the other: O(n) + O(n) simplifies to O(___)",
          "같은 n개 항목을 도는 별개의 통과 둘, 차례로: O(n) + O(n)은 O(___)로 단순화",
          "兩次獨立 pass 先後行同一個 n 個項目：O(n) + O(n) 簡化做 O(___)"
        ),
        code = L(
          [[
let total: i32 = prices.iter().sum();        // n steps
let max = prices.iter().max();                // n more
// 2n steps, written O(___)
]],
          [[
let total: i32 = prices.iter().sum();        // n단계
let max = prices.iter().max();                // n단계 더
// 2n단계, 표기는 O(___)
]],
          [[
let total: i32 = prices.iter().sum();        // n 步
let max = prices.iter().max();                // 再 n 步
// 2n 步，寫成 O(___)
]]
        ),
        answer = "n",
        accept = { "n" },
        hint = L(
          "Just the size, no coefficient. 2n, 3n and n/2 are the same order.",
          "크기만, 계수 없이. 2n, 3n, n/2는 같은 차수.",
          "只係大小，冇系數。2n、3n 同 n/2 係同一個 order。"
        ),
        ok = L(
          "O(n). Sequential passes add and the constant drops. Nested passes multiply: that is the next street but one.",
          "O(n). 순차 통과는 더해지고 상수는 버려진다. 중첩 통과는 곱해진다: 그건 다음다음 거리.",
          "O(n)。先後嘅 pass 相加，常數掉走。嵌套嘅 pass 相乘：嗰個係下下條街。"
        ),
      },
      {
        topic = "SCAN",
        q = L(
          "Is a name in the Vec? Without a set you must look at each one. Which iterator adapter stops at the first match?",
          "이름이 Vec에 있나? 집합 없이는 하나씩 봐야 한다. 첫 일치에서 멈추는 이터레이터 어댑터는?",
          "個名喺唔喺 Vec 裏面？冇 set 就要逐個望。邊個 iterator adapter 第一個 match 就停？"
        ),
        code = L(
          [[
fn has(names: &[String], q: &str) -> bool {
    names.iter().___(|s| s == q)    // O(n) worst case
}
]],
          [[
fn has(names: &[String], q: &str) -> bool {
    names.iter().___(|s| s == q)    // 최악 O(n)
}
]],
          [[
fn has(names: &[String], q: &str) -> bool {
    names.iter().___(|s| s == q)    // 最差 O(n)
}
]]
        ),
        answer = "any",
        accept = { "any" },
        hint = L(
          "Three letters: is there any element for which the closure is true. Vec::contains does the same for one value.",
          "세 글자: 클로저가 참인 원소가 하나라도 있나. Vec::contains는 값 하나에 대해 같은 일.",
          "三個字母：有冇任何元素令 closure 係 true。Vec::contains 對一個值做同一件事。"
        ),
        ok = L(
          "A linear scan. Found early is lucky; Big O counts the worst case, n. A HashSet<String> makes it O(1).",
          "선형 스캔. 일찍 찾으면 운. 빅오는 최악 n을 센다. HashSet<String>이면 O(1).",
          "線性 scan。早搵到係好運；Big O 計最差，n。用 HashSet<String> 就變 O(1)。"
        ),
      },
      {
        topic = "MINIMUM",
        q = L(
          "Finding the largest of n unsorted prices needs at least how many comparisons?",
          "정렬되지 않은 n개 가격 중 최대를 찾는 데 최소 몇 번의 비교가 필요한가?",
          "喺 n 個未排序嘅價錢搵最大，最少要幾多次比較？"
        ),
        code = L(
          [[
let mut max = prices[0];
for &p in &prices[1..] {    // ___ comparisons
    if p > max { max = p; }
}
]],
          [[
let mut max = prices[0];
for &p in &prices[1..] {    // 비교 ___ 번
    if p > max { max = p; }
}
]],
          [[
let mut max = prices[0];
for &p in &prices[1..] {    // ___ 次比較
    if p > max { max = p; }
}
]]
        ),
        answer = "n-1",
        accept = { "n-1", "n - 1" },
        hint = L(
          "Every price but the first must lose a comparison to be ruled out. One less than the count.",
          "첫 값을 뺀 모든 가격이 탈락하려면 비교에서 져야 한다. 개수보다 하나 적게.",
          "除第一個之外每個價錢都要輸一次比較先排除得。數量減一。"
        ),
        ok = L(
          "n-1 comparisons, which is O(n): you cannot know the max without seeing every value. iter().max() does exactly this.",
          "비교 n-1번, 즉 O(n): 모든 값을 보지 않고는 최대를 알 수 없다. iter().max()가 정확히 이걸 한다.",
          "n-1 次比較，即 O(n)：唔望晒所有值就唔會知最大。iter().max() 做嘅就係呢樣。"
        ),
      },
    },
  },
  {
    id = "rs_bigo_log",
    station = "O(LOG N)",
    name = L("The phone book", "전화번호부", "電話簿"),
    title = L("Logarithmic time", "로그 시간", "對數時間"),
    lesson = L(
      "O(log n): each step halves what is left. slice::binary_search on a sorted Vec: 1024 items in 10 steps, a million in 20. Needs sorted input.",
      "O(log n): 단계마다 남은 것이 절반. 정렬된 Vec의 slice::binary_search: 1024개를 10단계에, 백만을 20단계에. 정렬된 입력이 필요.",
      "O(log n)：每步將剩低嘅減半。排好序嘅 Vec 上 slice::binary_search：1024 個 10 步，一百萬個 20 步。要排好序嘅輸入。"
    ),
    bg = "bg_mtr",
    portrait = "portrait_friends",
    speaker = L("Mei", "메이", "阿美"),
    ground = 348,
    spawn = 160,
    width = 1600,
    npcs = {
      {
        kind = "mei",
        x = 540,
        facing = -1,
        line = L(
          "Open the middle, decide left or right, throw half away. The std library already wrote it.",
          "가운데를 펴고, 왼쪽인지 오른쪽인지 정하고, 절반을 버려. std 라이브러리가 이미 써놨어.",
          "打開中間，決定左定右，掉走一半。std library 已經寫好。"
        ),
      },
    },
    viz = "rust",
    chips = {
      { "lo + (hi - lo) / 2", "cyan" },
      { "1024 -> 10 steps", "gold" },
      { "a.binary_search(&x)", "pink" },
      { "sort first", "green" },
    },
    note = "halve  binary_search  log2  sorted",
    story = L(
      "Siu Ming's phone book of suppliers, sorted by name. Open the middle, go left or right, and the book "
        .. "is half as thick every time. Mei draws the line that climbs, then almost lies down.",
      "시우밍의 공급업체 전화번호부, 이름순. 가운데를 펴고 왼쪽이나 오른쪽으로, 매번 책이 절반 두께. 메이가 올라가다 거의 눕는 선을 그린다.",
      "小明嘅供應商電話簿，按名排好。打開中間，向左或者向右，每次本書薄一半。阿美畫一條升到差唔多躺平嘅線。"
    ),
    stages = {
      {
        topic = "HALVE",
        q = L(
          "Binary search checks the middle of lo..hi. Which operator finds the midpoint index?",
          "이진 탐색은 lo..hi의 가운데를 확인. 중간 인덱스를 구하는 연산자는?",
          "二元搜尋檢查 lo..hi 嘅中間。邊個運算符搵中點 index？"
        ),
        code = L(
          [[
let (mut lo, mut hi) = (0, a.len());
while lo < hi {
    let mid = lo + (hi - lo) ___ 2;   // integer division on usize
    if a[mid] < x { lo = mid + 1 } else { hi = mid }
}
]],
          [[
let (mut lo, mut hi) = (0, a.len());
while lo < hi {
    let mid = lo + (hi - lo) ___ 2;   // usize의 정수 나눗셈
    if a[mid] < x { lo = mid + 1 } else { hi = mid }
}
]],
          [[
let (mut lo, mut hi) = (0, a.len());
while lo < hi {
    let mid = lo + (hi - lo) ___ 2;   // usize 嘅整數除法
    if a[mid] < x { lo = mid + 1 } else { hi = mid }
}
]]
        ),
        answer = "/",
        accept = { "/" },
        hint = L(
          "One slash. On integers Rust truncates, so no floor operator is needed. lo + (hi-lo)/2 avoids overflow.",
          "슬래시 하나. 정수에서 Rust는 버림, 내림 연산자가 필요 없다. lo + (hi-lo)/2는 오버플로를 피한다.",
          "一條斜線。對整數 Rust 截斷，唔使向下除運算符。lo + (hi-lo)/2 避 overflow。"
        ),
        ok = L(
          "(hi - lo) / 2. Each pass throws away half the range. usize overflow panics in debug builds, so the subtraction form matters.",
          "(hi - lo) / 2. 통과마다 범위의 절반을 버린다. usize 오버플로는 디버그 빌드에서 패닉이라 뺄셈 형태가 중요.",
          "(hi - lo) / 2。每一輪掉走一半範圍。usize overflow 喺 debug build 會 panic，所以減法寫法有分別。"
        ),
      },
      {
        topic = "STEPS",
        q = L(
          "1024 sorted items. Halving each time, at most how many steps until one is left?",
          "정렬된 1024개. 매번 절반으로, 하나가 남을 때까지 최대 몇 단계?",
          "1024 個排好序嘅項目。每次減半，最多幾多步剩一個？"
        ),
        code = L(
          [[
// 1024 -> 512 -> 256 -> 128 -> 64 -> 32 -> 16 -> 8 -> 4 -> 2 -> 1
// ___ halvings: 1024_u32.ilog2()
]],
          [[
// 1024 -> 512 -> 256 -> 128 -> 64 -> 32 -> 16 -> 8 -> 4 -> 2 -> 1
// 절반으로 ___ 번: 1024_u32.ilog2()
]],
          [[
// 1024 -> 512 -> 256 -> 128 -> 64 -> 32 -> 16 -> 8 -> 4 -> 2 -> 1
// ___ 次減半：1024_u32.ilog2()
]]
        ),
        answer = "10",
        accept = { "10" },
        hint = L(
          "Count the arrows. 2 to this power is 1024.",
          "화살표를 세어라. 2의 이 거듭제곱이 1024.",
          "數箭嘴。2 嘅呢個次方係 1024。"
        ),
        ok = L(
          "10. A million items take 20, a billion 30. That is how slowly log n grows.",
          "10. 백만 개는 20, 십억은 30. log n은 그만큼 느리게 자란다.",
          "10。一百萬個要 20，十億要 30。log n 就係咁慢。"
        ),
      },
      {
        topic = "COST",
        q = L(
          "So binary_search on n sorted items costs how much, in Big O?",
          "그러면 정렬된 n개의 binary_search는 빅오로 얼마?",
          "所以 n 個排好序項目嘅 binary_search，Big O 係幾多？"
        ),
        code = L(
          [[
match a.binary_search(&x) {     // ___
    Ok(i) => println!("at {i}"),
    Err(i) => println!("insert at {i}"),
}
]],
          [[
match a.binary_search(&x) {     // ___
    Ok(i) => println!("at {i}"),
    Err(i) => println!("insert at {i}"),
}
]],
          [[
match a.binary_search(&x) {     // ___
    Ok(i) => println!("at {i}"),
    Err(i) => println!("insert at {i}"),
}
]]
        ),
        answer = "O(log n)",
        accept = { "O(log n)", "log n", "logarithmic", "O(logn)" },
        hint = L(
          "Logarithmic: O of the logarithm of n. The base does not matter in Big O.",
          "로그: n의 로그의 O. 빅오에서 밑은 상관없다.",
          "對數：n 嘅對數嘅 O。Big O 裏面底數唔重要。"
        ),
        ok = L(
          "O(log n). Err(i) even tells you where to insert. BTreeMap and BinaryHeap live at the same cost.",
          "O(log n). Err(i)는 어디에 넣을지까지 알려준다. BTreeMap과 BinaryHeap도 같은 비용.",
          "O(log n)。Err(i) 仲話你知插入喺邊。BTreeMap 同 BinaryHeap 都係同樣成本。"
        ),
      },
      {
        topic = "SORTED",
        q = L(
          "binary_search has one precondition. The slice must be ___",
          "binary_search엔 전제 조건 하나가 있다. 슬라이스는 ___여야 한다",
          "binary_search 有一個前提。slice 必須係 ___"
        ),
        code = L(
          [[
// binary_search on an unsorted slice returns nonsense.
// Precondition: a is ___ ascending.
a.sort();
let i = a.binary_search(&38);
]],
          [[
// 정렬되지 않은 슬라이스의 binary_search는 엉뚱한 값을 준다.
// 전제 조건: a는 오름차순으로 ___.
a.sort();
let i = a.binary_search(&38);
]],
          [[
// 未排序 slice 上嘅 binary_search 回傳亂嘢。
// 前提：a 係升序 ___。
a.sort();
let i = a.binary_search(&38);
]]
        ),
        answer = "sorted",
        accept = { "sorted", "ordered" },
        hint = L(
          "In order, smallest to largest. The line above the search does it.",
          "순서대로, 작은 것부터 큰 것으로. 탐색 윗줄이 그렇게 만든다.",
          "有序，由細到大。搵嘢上面嗰行做嘅就係呢樣。"
        ),
        ok = L(
          "Sorted. Sorting costs O(n log n) once; every search after is O(log n). The phone book street is done.",
          "정렬됨. 정렬은 한 번 O(n log n), 이후 모든 탐색은 O(log n). 전화번호부 거리 완료.",
          "排好序。排序一次 O(n log n)；之後每次搵都係 O(log n)。電話簿街完成。"
        ),
      },
    },
  },
  {
    id = "rs_bigo_nlogn",
    station = "N LOG N",
    name = L("The sorting hat", "정렬 모자", "分類帽"),
    title = L("Sorting: n log n", "정렬: n log n", "排序：n log n"),
    lesson = L(
      "O(n log n): the cost of a good sort. Merge sort has log n levels, each doing O(n) work. sort, sort_unstable and sort_by_key all live here. Sort once, search many times.",
      "O(n log n): 좋은 정렬의 비용. 병합 정렬은 log n 레벨, 각 레벨이 O(n) 일. sort, sort_unstable, sort_by_key가 여기 산다. 한 번 정렬하고 여러 번 탐색.",
      "O(n log n)：一個好排序嘅成本。merge sort 有 log n 層，每層做 O(n) 工作。sort、sort_unstable 同 sort_by_key 都住呢度。排一次，搵好多次。"
    ),
    bg = "bg_times",
    portrait = "portrait_hero",
    speaker = L("Alex", "알렉스", "阿力"),
    ground = 348,
    spawn = 160,
    width = 1600,
    npcs = {
      {
        kind = "hero",
        x = 540,
        facing = 1,
        line = L(
          "Split in half, sort each half, merge. The merge is where the n comes from.",
          "반으로 나누고, 각각 정렬하고, 병합. 병합에서 n이 나와.",
          "分兩半，各自排好，合併。個 n 就係由 merge 嚟。"
        ),
      },
      {
        kind = "mei",
        x = 900,
        facing = -1,
        line = L(
          "Vec::sort is a merge sort; sort_unstable is pattern-defeating quicksort. Both n log n.",
          "Vec::sort는 병합 정렬, sort_unstable은 pdq 퀵소트. 둘 다 n log n.",
          "Vec::sort 係 merge sort；sort_unstable 係 pattern-defeating quicksort。兩個都 n log n。"
        ),
      },
    },
    viz = "rust",
    chips = {
      { "v.sort()", "cyan" },
      { "log n levels x O(n)", "gold" },
      { "v.sort_unstable()", "pink" },
      { "search: O(log n)", "green" },
    },
    note = "merge sort  levels x merge  sort once",
    story = L(
      "The sorting hat: a shoebox of receipts. Alex sorts them by splitting the pile in half, again and again, "
        .. "then merging back in order. Mei draws the line between linear and quadratic and labels it n log n.",
      "정렬 모자: 영수증이 든 신발 상자. 알렉스는 더미를 반으로, 또 반으로 나눈 뒤 순서대로 병합해 정렬한다. 메이가 선형과 이차 사이에 선을 그리고 n log n이라 적는다.",
      "分類帽：一個裝住收據嘅鞋盒。阿力將疊嘢分兩半，再分，再分，然後按次序合併返。阿美畫一條喺線性同二次之間嘅線，寫上 n log n。"
    ),
    stages = {
      {
        topic = "SORT",
        q = L(
          "v.sort() on n receipts: what does it cost, in Big O?",
          "n개 영수증에 v.sort(): 빅오로 비용은?",
          "對 n 張收據 v.sort()：Big O 成本係？"
        ),
        code = L(
          [[
amounts.sort();    // ___ : stable merge sort
]],
          [[
amounts.sort();    // ___ : 안정 병합 정렬
]],
          [[
amounts.sort();    // ___ ：穩定 merge sort
]]
        ),
        answer = "O(n log n)",
        accept = { "O(n log n)", "n log n", "nlogn", "O(nlogn)" },
        hint = L(
          "n times the logarithm of n. No comparison sort can beat it in the worst case.",
          "n 곱하기 n의 로그. 어떤 비교 정렬도 최악에서 이걸 이길 수 없다.",
          "n 乘 n 嘅對數。冇任何比較排序可以喺最差情況贏過佢。"
        ),
        ok = L(
          "O(n log n). A million items: about 20 million comparisons. The proven lower bound for comparison sorts.",
          "O(n log n). 백만 개: 약 2천만 번 비교. 비교 정렬의 증명된 하한.",
          "O(n log n)。一百萬個：大約二千萬次比較。比較排序已證明嘅下限。"
        ),
      },
      {
        topic = "LEVEL",
        q = L(
          "Merge sort has log n levels of splitting. Merging all the pieces on one level costs how much?",
          "병합 정렬은 log n 레벨로 나눈다. 한 레벨의 모든 조각을 병합하는 비용은?",
          "merge sort 有 log n 層分割。合併一層所有碎片要幾多？"
        ),
        code = L(
          [[
// level 1: merge 2 halves      -> n items moved
// level 2: merge 4 quarters    -> n items moved
// each level: ___ ; levels: log n ; total: n log n
]],
          [[
// 레벨 1: 절반 2개 병합      -> n개 이동
// 레벨 2: 4분의 1 4개 병합   -> n개 이동
// 레벨마다: ___ ; 레벨 수: log n ; 합계: n log n
]],
          [[
// 第 1 層：合併 2 半      -> 移動 n 個
// 第 2 層：合併 4 份      -> 移動 n 個
// 每層：___ ；層數：log n ；總計：n log n
]]
        ),
        answer = "O(n)",
        accept = { "O(n)", "linear" },
        hint = L(
          "Every item is moved exactly once per level, however many pieces there are.",
          "조각이 몇 개든 모든 항목은 레벨마다 정확히 한 번 이동.",
          "唔理有幾多份，每個項目每層剛好移動一次。"
        ),
        ok = L(
          "O(n) per level times log n levels. That product is the whole reason n log n exists.",
          "레벨당 O(n) 곱하기 log n 레벨. 그 곱이 n log n이 존재하는 이유의 전부.",
          "每層 O(n) 乘 log n 層。呢個乘積就係 n log n 存在嘅全部原因。"
        ),
      },
      {
        topic = "UNSTABLE",
        q = L(
          "Sort the amounts a little faster, when equal items may swap order. Which Vec method?",
          "같은 항목의 순서가 바뀌어도 될 때 금액을 조금 더 빨리 정렬. 어떤 Vec 메서드?",
          "相等項目可以調位嗰陣，排金額快一啲。邊個 Vec method？"
        ),
        code = L(
          [[
amounts.___();     // pdqsort, no scratch buffer, O(n log n)
]],
          [[
amounts.___();     // pdqsort, 임시 버퍼 없음, O(n log n)
]],
          [[
amounts.___();     // pdqsort，冇暫存 buffer，O(n log n)
]]
        ),
        answer = "sort_unstable",
        accept = { "sort_unstable" },
        hint = L(
          "sort, an underscore, and the word for 'may reorder equal items'.",
          "sort, 밑줄, 그리고 '같은 항목의 순서가 바뀔 수 있다'는 단어.",
          "sort、一條底線、同「相等項目可能調位」嗰個字。"
        ),
        ok = L(
          "sort_unstable: same O(n log n), less memory, usually faster. sort_by_key(|o| o.price) sorts by a field.",
          "sort_unstable: 같은 O(n log n), 메모리 덜 쓰고 보통 더 빠름. sort_by_key(|o| o.price)는 필드로 정렬.",
          "sort_unstable：同樣 O(n log n)，用少啲記憶體，通常快啲。sort_by_key(|o| o.price) 按 field 排。"
        ),
      },
      {
        topic = "THENSEARCH",
        q = L(
          "Sort once for O(n log n), then look items up many times. Each lookup then costs O(___)",
          "한 번 O(n log n)으로 정렬한 뒤 여러 번 조회. 조회 하나의 비용은 O(___)",
          "排一次 O(n log n)，之後搵好多次。每次搵成本係 O(___)"
        ),
        code = L(
          [[
a.sort();                                  // once: n log n
for x in &queries {
    let hit = a.binary_search(x).is_ok();  // each: O(___)
}
]],
          [[
a.sort();                                  // 한 번: n log n
for x in &queries {
    let hit = a.binary_search(x).is_ok();  // 각각: O(___)
}
]],
          [[
a.sort();                                  // 一次：n log n
for x in &queries {
    let hit = a.binary_search(x).is_ok();  // 每次：O(___)
}
]]
        ),
        answer = "log n",
        accept = { "log n", "logn", "log" },
        hint = L(
          "The phone book street's answer, without the O( ). Halving each step.",
          "전화번호부 거리의 답, O( ) 없이. 단계마다 절반.",
          "電話簿街嘅答案，冇 O( )。每步減半。"
        ),
        ok = L(
          "O(log n) per search. Sorting first pays off after the first few lookups. The sorting hat is done.",
          "탐색당 O(log n). 먼저 정렬하는 것은 처음 몇 번의 조회 후 이득. 정렬 모자 완료.",
          "每次搵 O(log n)。先排序，搵幾次之後就回本。分類帽完成。"
        ),
      },
    },
  },
  {
    id = "rs_bigo_quad",
    station = "O(N^2)",
    name = L("The seating chart", "좌석 배치표", "座位表"),
    title = L("Quadratic time", "이차 시간", "二次時間"),
    lesson = L(
      "O(n^2): a loop inside a loop over the same n. Comparing every pair. 100 items is 4950 pairs; 10,000 is fifty million. A HashSet turns most of these into O(n).",
      "O(n^2): 같은 n을 도는 루프 안의 루프. 모든 쌍 비교. 100개면 4950쌍, 만 개면 5천만. HashSet이 대부분을 O(n)으로 바꾼다.",
      "O(n^2)：同一個 n 嘅 loop 裏面再一個 loop。比較每一對。100 個係 4950 對；一萬個係五千萬。用 HashSet 大部分變返 O(n)。"
    ),
    bg = "bg_mall",
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
          "Checking every guest against every other guest for a double booking. Fine with 20. Not with 2000.",
          "중복 예약을 찾으려고 모든 손님을 모든 다른 손님과 비교했어요. 20명은 괜찮았죠. 2000명은 아니에요.",
          "為咗搵重複訂位，每個客同每個其他客比較。20 個冇問題。2000 個唔得。"
        ),
      },
    },
    viz = "rust",
    chips = {
      { "for i { for j { .. } }", "cyan" },
      { "n(n-1)/2 pairs", "gold" },
      { "HashSet::new()", "pink" },
      { "O(n*m)", "green" },
    },
    note = "nested  pairs  HashSet fix  n*m",
    story = L(
      "The seating chart for a banquet. Siu Ming's script checks every guest against every other for a duplicate. "
        .. "Mei draws the curve that leaves the board. Nested loops over the same Vec: the shape to avoid.",
      "연회 좌석 배치표. 시우밍의 스크립트는 중복을 찾으려고 모든 손님을 모든 다른 손님과 비교한다. 메이가 보드를 벗어나는 곡선을 그린다. 같은 Vec을 도는 중첩 루프: 피해야 할 모양.",
      "宴會嘅座位表。小明嘅 script 每個客同每個其他客比較搵重複。阿美畫出咗白板嘅曲線。同一個 Vec 嘅嵌套 loop：要避開嘅形狀。"
    ),
    stages = {
      {
        topic = "NESTED",
        q = L(
          "A loop over n guests inside a loop over the same n guests. Cost, in Big O?",
          "같은 n명 손님을 도는 루프 안에 n명을 도는 루프. 빅오로 비용은?",
          "行 n 個客嘅 loop 裏面再行同一個 n 個客。Big O 成本？"
        ),
        code = L(
          [[
for i in 0..guests.len() {
    for j in 0..guests.len() {       // ___ : n x n checks
        if i != j && guests[i] == guests[j] { dup = true; }
    }
}
]],
          [[
for i in 0..guests.len() {
    for j in 0..guests.len() {       // ___ : n x n번 확인
        if i != j && guests[i] == guests[j] { dup = true; }
    }
}
]],
          [[
for i in 0..guests.len() {
    for j in 0..guests.len() {       // ___ ：n x n 次檢查
        if i != j && guests[i] == guests[j] { dup = true; }
    }
}
]]
        ),
        answer = "O(n^2)",
        accept = { "O(n^2)", "n^2", "quadratic", "O(n²)", "n²" },
        hint = L(
          "Quadratic: n squared. Write the power with a caret.",
          "이차: n의 제곱. 거듭제곱은 캐럿으로 쓴다.",
          "二次：n 嘅平方。次方用 ^ 寫。"
        ),
        ok = L(
          "O(n^2). Double the guests, four times the checks. Bubble sort and selection sort live here too.",
          "O(n^2). 손님이 두 배면 확인은 네 배. 버블 정렬과 선택 정렬도 여기 산다.",
          "O(n^2)。客翻倍，檢查四倍。bubble sort 同 selection sort 都住呢度。"
        ),
      },
      {
        topic = "PAIRS",
        q = L(
          "Comparing each pair once is n(n-1)/2 checks. For 100 guests, how many?",
          "각 쌍을 한 번씩 비교하면 n(n-1)/2번. 손님 100명이면 몇 번?",
          "每對比較一次係 n(n-1)/2 次。100 個客，幾多次？"
        ),
        code = L(
          [[
// n = 100
// pairs = 100 * 99 / 2 = ___
// still O(n^2): the /2 is a constant
]],
          [[
// n = 100
// 쌍 = 100 * 99 / 2 = ___
// 여전히 O(n^2): /2는 상수
]],
          [[
// n = 100
// 對數 = 100 * 99 / 2 = ___
// 仍然 O(n^2)：/2 係常數
]]
        ),
        answer = "4950",
        accept = { "4950" },
        hint = L(
          "Multiply 100 by 99, then halve it.",
          "100에 99를 곱하고 반으로.",
          "100 乘 99，再減半。"
        ),
        ok = L(
          "4950. For 10,000 guests it is about fifty million. Big O ignores the /2: the curve is the same.",
          "4950. 손님 만 명이면 약 5천만. 빅오는 /2를 무시한다: 곡선은 같다.",
          "4950。一萬個客就大約五千萬。Big O 唔理個 /2：條曲線一樣。"
        ),
      },
      {
        topic = "SETFIX",
        q = L(
          "The O(n) fix: remember each name as you go. Which std collection is the set?",
          "O(n) 해법: 지나가며 이름을 기억. 집합인 std 컬렉션은?",
          "O(n) 嘅解法：一路行一路記住每個名。邊個 std collection 係 set？"
        ),
        code = L(
          [[
let mut seen = ___::new();
for g in &guests {               // one pass: O(n)
    if !seen.insert(g) { dup = true; }   // false = already there
}
]],
          [[
let mut seen = ___::new();
for g in &guests {               // 한 번 통과: O(n)
    if !seen.insert(g) { dup = true; }   // false = 이미 있음
}
]],
          [[
let mut seen = ___::new();
for g in &guests {               // 一次過：O(n)
    if !seen.insert(g) { dup = true; }   // false = 已經有
}
]]
        ),
        answer = "HashSet",
        accept = { "HashSet" },
        hint = L(
          "A set built on hashing, CapWords, in std::collections. insert returns false when the value was already in.",
          "해시 기반 집합, CapWords, std::collections에. insert는 값이 이미 있으면 false를 반환.",
          "基於 hash 嘅 set，CapWords，喺 std::collections。insert 個值已經有嗰陣回傳 false。"
        ),
        ok = L(
          "HashSet: one O(1) insert per guest, O(n) total. Fifty million checks become ten thousand.",
          "HashSet: 손님당 O(1) 삽입 한 번, 합계 O(n). 5천만 번이 만 번이 된다.",
          "HashSet：每個客一次 O(1) insert，總共 O(n)。五千萬次變一萬次。"
        ),
      },
      {
        topic = "TWOSIZES",
        q = L(
          "A loop over n guests inside a loop over m tables. The two sizes differ. Cost?",
          "m개 테이블을 도는 루프 안에 n명 손님을 도는 루프. 두 크기가 다르다. 비용은?",
          "行 m 張枱嘅 loop 裏面行 n 個客。兩個大小唔同。成本？"
        ),
        code = L(
          [[
for t in &tables {          // m
    for g in &guests {      // n
        fits(t, g);         // ___ calls
    }
}
]],
          [[
for t in &tables {          // m
    for g in &guests {      // n
        fits(t, g);         // ___ 번 호출
    }
}
]],
          [[
for t in &tables {          // m
    for g in &guests {      // n
        fits(t, g);         // ___ 次 call
    }
}
]]
        ),
        answer = "O(n*m)",
        accept = { "O(n*m)", "n*m", "nm", "n m", "O(nm)", "O(m*n)", "m*n", "mn" },
        hint = L(
          "Nested loops multiply their sizes. Two different letters, a star between them.",
          "중첩 루프는 크기를 곱한다. 서로 다른 글자 둘, 사이에 별표.",
          "嵌套 loop 將大小相乘。兩個唔同字母，中間一個星號。"
        ),
        ok = L(
          "O(n*m). Only when both loops run over the same n does it collapse to n^2. The seating chart is fixed.",
          "O(n*m). 두 루프가 같은 n을 돌 때만 n^2으로 줄어든다. 좌석 배치표 수리 완료.",
          "O(n*m)。只有兩個 loop 都行同一個 n 先會變 n^2。座位表修好。"
        ),
      },
    },
  },
  {
    id = "rs_bigo_exp",
    station = "O(2^N)",
    name = L("The combinatorics counter", "조합 카운터", "組合櫃位"),
    title = L("Exponential time", "지수 시간", "指數時間"),
    lesson = L(
      "O(2^n): the work doubles when n grows by one. Naive fib makes two calls per call. A HashMap memo brings it to O(n). Listing every subset of n items is 2^n and cannot be helped.",
      "O(2^n): n이 1 늘 때 일이 두 배. 순진한 fib는 호출마다 호출 둘. HashMap memo가 O(n)으로 만든다. n개의 모든 부분집합 나열은 2^n이고 피할 수 없다.",
      "O(2^n)：n 加一，工作翻倍。天真嘅 fib 每個 call 再 call 兩次。HashMap memo 令佢變 O(n)。列出 n 個項目嘅所有子集係 2^n，冇得救。"
    ),
    bg = "bg_kitchen",
    portrait = "portrait_officer",
    speaker = L("Chef Bo", "보 셰프", "寶廚"),
    ground = 348,
    spawn = 160,
    width = 1600,
    npcs = {
      {
        kind = "cook",
        x = 540,
        facing = -1,
        line = L(
          "Every topping can be on or off. Ten toppings, a thousand combos. Twenty, a million. That is 2^n.",
          "토핑마다 넣거나 빼거나. 토핑 열 개면 조합 천 개. 스무 개면 백만. 그게 2^n이야.",
          "每種配料可以加或者唔加。十種配料，一千種組合。二十種，一百萬。呢個就係 2^n。"
        ),
      },
    },
    viz = "rust",
    chips = {
      { "fib(n-1) + fib(n-2)", "cyan" },
      { "memo.get(&n)", "gold" },
      { "2^n subsets", "pink" },
      { "O(2^n) -> O(n)", "green" },
    },
    note = "two calls  doubling  memo  subsets",
    story = L(
      "The combinatorics counter at the noodle stall: pick any toppings. Bo counts the combinations and the number "
        .. "doubles with every topping. Mei draws the curve that goes vertical almost at once.",
      "국수 노점의 조합 카운터: 토핑을 아무렇게나 고른다. 보가 조합을 세는데 토핑 하나마다 수가 두 배. 메이가 거의 곧바로 수직이 되는 곡선을 그린다.",
      "麵檔嘅組合櫃位：任揀配料。寶廚數組合，每加一種配料數目翻倍。阿美畫幾乎即刻變垂直嗰條曲線。"
    ),
    stages = {
      {
        topic = "NAIVE",
        q = L(
          "fib calls itself twice per call, no memo. Cost, in Big O?",
          "fib가 memo 없이 호출마다 자신을 두 번 호출. 빅오로 비용은?",
          "fib 冇 memo，每個 call 再 call 自己兩次。Big O 成本？"
        ),
        code = L(
          [[
fn fib(n: u64) -> u64 {
    if n < 2 { return n; }
    fib(n - 1) + fib(n - 2)   // ___ : two calls each
}
]],
          [[
fn fib(n: u64) -> u64 {
    if n < 2 { return n; }
    fib(n - 1) + fib(n - 2)   // ___ : 각각 호출 둘
}
]],
          [[
fn fib(n: u64) -> u64 {
    if n < 2 { return n; }
    fib(n - 1) + fib(n - 2)   // ___ ：每個兩次 call
}
]]
        ),
        answer = "O(2^n)",
        accept = { "O(2^n)", "exponential" },
        hint = L(
          "Exponential: two to the power of n. Each level of the call tree is twice as wide as the one above.",
          "지수: 2의 n제곱. 호출 트리의 각 레벨이 위 레벨의 두 배 폭.",
          "指數：2 嘅 n 次方。call tree 每一層都係上一層嘅兩倍闊。"
        ),
        ok = L(
          "O(2^n). fib(40) is about a billion calls even in Rust; fib(50) would take a day. The worst curve on the board.",
          "O(2^n). Rust에서도 fib(40)은 약 십억 번 호출, fib(50)은 하루. 보드에서 가장 나쁜 곡선.",
          "O(2^n)。就算 Rust，fib(40) 都大約十億次 call；fib(50) 要一日。白板上最差嘅曲線。"
        ),
      },
      {
        topic = "MEMOCOST",
        q = L(
          "With a memo every fib(k) is computed once. The cost drops to O(___)",
          "memo가 있으면 모든 fib(k)는 한 번만 계산. 비용은 O(___)로",
          "有 memo 每個 fib(k) 只計一次。成本跌到 O(___)"
        ),
        code = L(
          [[
// without memo: 2^n calls
// with memo: fib(0) .. fib(n), each once -> O(___)
]],
          [[
// memo 없이: 2^n번 호출
// memo 있으면: fib(0) .. fib(n), 각 한 번 -> O(___)
]],
          [[
// 冇 memo：2^n 次 call
// 有 memo：fib(0) .. fib(n)，每個一次 -> O(___)
]]
        ),
        answer = "n",
        accept = { "n", "linear" },
        hint = L(
          "n+1 distinct inputs, each solved once. Linear, without the O( ).",
          "서로 다른 입력 n+1개, 각각 한 번. 선형, O( ) 없이.",
          "n+1 個唔同嘅輸入，每個解一次。線性，冇 O( )。"
        ),
        ok = L(
          "O(n). Memoization trades O(n) memory for the exponential time. The biggest win in this whole quest.",
          "O(n). 메모이제이션은 O(n) 메모리로 지수 시간을 산다. 이 퀘스트 전체에서 가장 큰 승리.",
          "O(n)。memoization 用 O(n) 記憶體換走指數時間。成個任務裏面最大嘅勝利。"
        ),
      },
      {
        topic = "MEMOCODE",
        q = L(
          "Look the answer up before computing. Which HashMap method?",
          "계산 전에 답을 찾아본다. HashMap의 어떤 메서드?",
          "計之前先查答案。HashMap 邊個 method？"
        ),
        code = L(
          [[
fn fib(n: u64, memo: &mut HashMap<u64, u64>) -> u64 {
    if let Some(&v) = memo.___(&n) { return v; }
    let v = if n < 2 { n } else { fib(n - 1, memo) + fib(n - 2, memo) };
    memo.insert(n, v);
    v
}
]],
          [[
fn fib(n: u64, memo: &mut HashMap<u64, u64>) -> u64 {
    if let Some(&v) = memo.___(&n) { return v; }
    let v = if n < 2 { n } else { fib(n - 1, memo) + fib(n - 2, memo) };
    memo.insert(n, v);
    v
}
]],
          [[
fn fib(n: u64, memo: &mut HashMap<u64, u64>) -> u64 {
    if let Some(&v) = memo.___(&n) { return v; }
    let v = if n < 2 { n } else { fib(n - 1, memo) + fib(n - 2, memo) };
    memo.insert(n, v);
    v
}
]]
        ),
        answer = "get",
        accept = { "get" },
        hint = L(
          "Three letters. Takes a reference to the key, returns Option<&V>.",
          "세 글자. 키의 참조를 받아 Option<&V>를 반환.",
          "三個字母。攞 key 嘅 reference，回傳 Option<&V>。"
        ),
        ok = L(
          "memo.get(&n) is O(1). Hit: return. Miss: compute and insert. Go spells this the comma-ok test; Python @functools.cache.",
          "memo.get(&n)은 O(1). 있으면 반환, 없으면 계산하고 insert. Go는 comma-ok 검사, Python은 @functools.cache.",
          "memo.get(&n) 係 O(1)。有就回傳；冇就計並 insert。Go 寫 comma-ok 檢查；Python 寫 @functools.cache。"
        ),
      },
      {
        topic = "SUBSETS",
        q = L(
          "Every topping on or off, n toppings. How many combinations, as a power?",
          "토핑마다 넣거나 빼거나, 토핑 n개. 조합은 몇 개, 거듭제곱으로?",
          "每種配料加或唔加，n 種配料。幾多種組合，用次方寫？"
        ),
        code = L(
          [[
// 1 topping: 2 combos   2 toppings: 4   3 toppings: 8
// n toppings: ___ combos; 1u64 << n computes it
]],
          [[
// 토핑 1개: 조합 2   2개: 4   3개: 8
// 토핑 n개: 조합 ___ 개; 1u64 << n 으로 계산
]],
          [[
// 1 種配料：2 種組合   2 種：4   3 種：8
// n 種配料：___ 種組合；1u64 << n 計出嚟
]]
        ),
        answer = "2^n",
        accept = { "2^n", "2**n", "1 << n" },
        hint = L(
          "Two choices per topping, multiplied n times. Two, a caret, n.",
          "토핑마다 선택 둘, n번 곱하기. 2, 캐럿, n.",
          "每種配料兩個選擇，乘 n 次。2、^、n。"
        ),
        ok = L(
          "2^n subsets. When the output itself is exponential no algorithm can be faster; when only the answer is needed, look for a memo.",
          "부분집합 2^n개. 출력 자체가 지수적이면 어떤 알고리즘도 더 빠를 수 없다. 답만 필요하면 memo를 찾자.",
          "2^n 個子集。輸出本身係指數嗰陣冇算法可以更快；只需要答案嗰陣就搵 memo。"
        ),
      },
    },
  },
  {
    id = "rs_bigo_space",
    station = "SPACE",
    name = L("The storeroom", "창고", "貨倉"),
    title = L("Space complexity", "공간 복잡도", "空間複雜度"),
    lesson = L(
      "Space counts extra memory, not the input. sort_unstable in place: O(1). A clone of the Vec: O(n). Recursion uses stack: quicksort O(log n) on average. Memos trade space for time.",
      "공간은 입력이 아닌 추가 메모리를 센다. 제자리 sort_unstable: O(1). Vec의 clone: O(n). 재귀는 스택을 쓴다: 퀵소트는 평균 O(log n). memo는 공간으로 시간을 산다.",
      "空間計額外記憶體，唔計輸入。就地 sort_unstable：O(1)。clone 個 Vec：O(n)。遞歸用 stack：quicksort 平均 O(log n)。memo 用空間換時間。"
    ),
    bg = "bg_lab",
    portrait = "portrait_friends",
    speaker = L("Mei", "메이", "阿美"),
    ground = 348,
    spawn = 160,
    width = 1600,
    npcs = {
      {
        kind = "mei",
        x = 540,
        facing = -1,
        line = L(
          "Time is one axis. Memory is the other. Rust makes you see every allocation; that is the point.",
          "시간이 한 축, 메모리가 다른 축. Rust는 모든 할당을 보게 만들어. 그게 핵심이야.",
          "時間係一條軸。記憶體係另一條。Rust 令你睇到每一次分配；呢個就係重點。"
        ),
      },
      {
        kind = "cook",
        x = 900,
        facing = -1,
        line = L(
          "The storeroom is small. Sort the trays where they stand; do not build a second rack.",
          "창고는 작아. 트레이는 서 있는 자리에서 정렬해. 두 번째 선반은 만들지 마.",
          "貨倉細。盤就喺原位排；唔要砌第二個架。"
        ),
      },
    },
    viz = "rust",
    chips = {
      { "a.sort_unstable()", "cyan" },
      { "let b = a.clone();", "gold" },
      { "stack depth", "pink" },
      { "space for time", "green" },
    },
    note = "extra memory  in place  clone  stack",
    story = L(
      "The storeroom: every algorithm needs somewhere to put things. Sorting the trays where they stand costs "
        .. "no shelf; cloning them onto a new rack costs a rack the size of the input. Mei adds the second axis.",
      "창고: 모든 알고리즘은 물건을 둘 곳이 필요하다. 트레이를 선 자리에서 정렬하면 선반이 필요 없고, 새 선반에 clone하면 입력 크기의 선반이 든다. 메이가 둘째 축을 더한다.",
      "貨倉：每個算法都要有地方放嘢。盤喺原位排唔使多一個架；clone 上新架就要一個同輸入一樣大嘅架。阿美加第二條軸。"
    ),
    stages = {
      {
        topic = "INPLACE",
        q = L(
          "sort_unstable sorts the Vec where it is. Extra memory, in Big O: O(___)",
          "sort_unstable은 Vec을 제자리에서 정렬. 추가 메모리는 빅오로 O(___)",
          "sort_unstable 就地排 Vec。額外記憶體，Big O：O(___)"
        ),
        code = L(
          [[
a.sort_unstable();    // in place: O(___) extra space
]],
          [[
a.sort_unstable();    // 제자리: 추가 공간 O(___)
]],
          [[
a.sort_unstable();    // 就地：額外空間 O(___)
]]
        ),
        answer = "1",
        accept = { "1", "constant" },
        hint = L(
          "A handful of index variables, however long the Vec. Constant.",
          "Vec이 얼마나 길든 인덱스 변수 몇 개. 상수.",
          "唔理 Vec 幾長都只係幾個 index 變數。常數。"
        ),
        ok = L(
          "O(1) extra: pdqsort swaps within the slice. Vec::sort, the stable one, allocates an O(n) buffer instead.",
          "추가 O(1): pdqsort는 슬라이스 안에서 교환. 안정 정렬인 Vec::sort는 대신 O(n) 버퍼를 할당.",
          "額外 O(1)：pdqsort 喺 slice 裏面交換。穩定嗰個 Vec::sort 反而會分配 O(n) buffer。"
        ),
      },
      {
        topic = "COPY",
        q = L(
          "A sorted copy, leaving the original untouched, needs a second Vec. Extra space: O(___)",
          "원본을 건드리지 않은 정렬 복사본에는 둘째 Vec이 필요. 추가 공간: O(___)",
          "唔掂原本嘅排好序副本要第二個 Vec。額外空間：O(___)"
        ),
        code = L(
          [[
let mut b = a.clone();    // a second Vec of n ints: O(___)
b.sort();
]],
          [[
let mut b = a.clone();    // n개 int의 둘째 Vec: O(___)
b.sort();
]],
          [[
let mut b = a.clone();    // 第二個 n 個 int 嘅 Vec：O(___)
b.sort();
]]
        ),
        answer = "n",
        accept = { "n", "linear" },
        hint = L(
          "As many new ints as there are old ones. Linear, without the O( ).",
          "옛 것과 같은 수의 새 int. 선형, O( ) 없이.",
          "新 int 同舊 int 一樣多。線性，冇 O( )。"
        ),
        ok = L(
          "O(n). Rust makes the cost visible: clone() is a word you have to type. Python's sorted() copies silently.",
          "O(n). Rust는 비용을 보이게 한다: clone()은 직접 쳐야 하는 단어. Python의 sorted()는 조용히 복사.",
          "O(n)。Rust 令成本睇得見：clone() 係你要親手打嘅字。Python 嘅 sorted() 靜靜地 copy。"
        ),
      },
      {
        topic = "CLONE",
        q = L(
          "Make that copy: a new owned Vec with the same contents. Which method?",
          "그 복사본 만들기: 같은 내용을 가진 새 소유 Vec. 어떤 메서드?",
          "整個副本：一個內容相同、自己擁有嘅新 Vec。邊個 method？"
        ),
        code = L(
          [[
let b = a.___();    // allocate n ints and copy: O(n) time, O(n) space
]],
          [[
let b = a.___();    // n개 int 할당 후 복사: O(n) 시간, O(n) 공간
]],
          [[
let b = a.___();    // 分配 n 個 int 再 copy：O(n) 時間，O(n) 空間
]]
        ),
        answer = "clone",
        accept = { "clone", "to_vec" },
        hint = L(
          "Five letters, the trait every Vec<T: Clone> implements. to_vec() from a slice is the other spelling.",
          "다섯 글자, 모든 Vec<T: Clone>이 구현하는 트레이트. 슬라이스의 to_vec()이 다른 표기.",
          "五個字母，每個 Vec<T: Clone> 都實作嘅 trait。slice 嘅 to_vec() 係另一個寫法。"
        ),
        ok = L(
          "a.clone(). Allocation is where space complexity is paid; drop frees it at the end of scope, no collector needed.",
          "a.clone(). 할당이 공간 복잡도를 내는 곳. 스코프 끝에서 drop이 해제, 컬렉터가 필요 없다.",
          "a.clone()。分配就係交空間複雜度嘅地方；scope 完 drop 就釋放，唔使 collector。"
        ),
      },
      {
        topic = "STACK",
        q = L(
          "Recursion uses the call stack. Quicksort's average recursion depth, hence stack space, is O(___)",
          "재귀는 호출 스택을 쓴다. 퀵소트의 평균 재귀 깊이, 즉 스택 공간은 O(___)",
          "遞歸用 call stack。quicksort 平均遞歸深度，即 stack 空間，係 O(___)"
        ),
        code = L(
          [[
// quicksort halves the range each level on average
// depth ~ log2(n) frames on the stack: O(___) space
// (naive fib without memo: depth n)
]],
          [[
// 퀵소트는 평균적으로 레벨마다 범위를 절반으로
// 깊이 ~ 스택 프레임 log2(n)개: 공간 O(___)
// (memo 없는 순진한 fib: 깊이 n)
]],
          [[
// quicksort 平均每層將範圍減半
// 深度 ~ stack 上 log2(n) 個 frame：O(___) 空間
// （冇 memo 嘅天真 fib：深度 n）
]]
        ),
        answer = "log n",
        accept = { "log n", "logn", "log" },
        hint = L(
          "The number of times you can halve n. Same answer as the phone book, applied to memory.",
          "n을 절반으로 나눌 수 있는 횟수. 전화번호부와 같은 답을 메모리에 적용.",
          "n 可以減半幾多次。同電話簿一樣嘅答案，套用喺記憶體。"
        ),
        ok = L(
          "O(log n) stack frames on average. Every axis on the board has a name. Mei takes the O(1) stamp for the Rust round.",
          "평균 스택 프레임 O(log n). 보드의 모든 축에 이름이 있다. 메이가 Rust 라운드의 O(1) 도장을 받는다.",
          "平均 O(log n) 個 stack frame。白板上每條軸都有名。阿美攞到 Rust 回合嘅 O(1) 印。"
        ),
      },
    },
  },
}

return maps
