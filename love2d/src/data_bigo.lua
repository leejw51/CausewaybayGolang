-- Quest Q5 BIG O: how fast is it. Seven streets, one order of growth each,
-- from O(1) to O(2^n) and then space. Every street reads a Go loop, names
-- its cost, then writes the faster version. The back-office whiteboard from
-- the Python night is the classroom; the gopher keeps score.
-- Same shape as src/data.lua: the blank ___ is NOT written in the code.
--
-- Answers are complexities or code. "O(n)" and "n" are different answers
-- inside one street, so a street never asks the same thing twice.

local function L(en, ko, yue)
  return { en = en, ko = ko, yue = yue }
end

local maps = {
  {
    id = "bigo_one",
    station = "O(1)",
    name = L("The counter", "카운터", "櫃位"),
    title = L("Constant time", "상수 시간", "常數時間"),
    lesson = L(
      "O(1): the same number of steps however big the input. Indexing a slice, a map lookup, the last element. Doubling n changes nothing.",
      "O(1): 입력이 얼마나 커도 같은 단계 수. 슬라이스 인덱싱, 맵 조회, 마지막 원소. n이 두 배가 돼도 변하지 않는다.",
      "O(1)：輸入幾大都係同樣步數。slice index、map 查找、最後一個元素。n 翻倍都冇變。"
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
          "Big O is one question: when the input doubles, what happens to the work?",
          "빅오는 질문 하나야: 입력이 두 배가 되면 일은 어떻게 되는가?",
          "Big O 就係一條問題：輸入翻倍，工作量點變？"
        ),
      },
      {
        kind = "hero",
        x = 900,
        facing = -1,
        line = L(
          "The interview asked me this three times. Let's get it right in Go first.",
          "면접에서 이걸 세 번 물었어. 먼저 Go로 제대로 해보자.",
          "面試問過我三次。先用 Go 搞清楚。"
        ),
      },
    },
    viz = "chips",
    chips = {
      { "items[3]", "cyan" },
      { 'menu["tea"]', "gold" },
      { "items[len(items)-1]", "pink" },
      { "O(1)", "green" },
    },
    note = "index  map  last  n doubles -> same",
    story = L(
      "The whiteboard in the back office, wiped clean. Mei draws one axis: n, the size of the input. "
        .. "The other axis is work. First street: operations whose line stays flat however far n goes.",
      "사무실 화이트보드가 깨끗이 지워졌다. 메이가 축 하나를 그린다: n, 입력의 크기. 다른 축은 일. "
        .. "첫 거리: n이 아무리 커져도 선이 평평한 연산들.",
      "後勤房嘅白板擦乾淨。阿美畫一條軸：n，輸入嘅大小。另一條軸係工作量。"
        .. "第一條街：n 去到幾遠條線都係平嘅操作。"
    ),
    stages = {
      {
        topic = "INDEX",
        q = L(
          "Reading items[3] from a slice of n items: how many steps, in Big O?",
          "n개짜리 슬라이스에서 items[3]을 읽기: 빅오로 몇 단계?",
          "由 n 個元素嘅 slice 讀 items[3]：Big O 係幾多步？"
        ),
        code = L(
          [[
func fourth(items []int) int {
    return items[3]    // ___ : one address, one read
}
]],
          [[
func fourth(items []int) int {
    return items[3]    // ___ : 주소 하나, 읽기 한 번
}
]],
          [[
func fourth(items []int) int {
    return items[3]    // ___ ：一個地址，一次讀取
}
]]
        ),
        answer = "O(1)",
        accept = { "O(1)", "1", "constant" },
        hint = L(
          "Constant. The slice knows its base address; index 3 is base plus 3 times the element size.",
          "상수. 슬라이스는 기준 주소를 알고, 3번은 기준 더하기 3 곱하기 원소 크기.",
          "常數。slice 知道自己嘅 base address；index 3 就係 base 加 3 乘元素大小。"
        ),
        ok = L(
          "O(1): a million items or ten, one multiply and one load. Written O(1), read 'order one'.",
          "O(1): 백만 개든 열 개든 곱셈 한 번, 로드 한 번. O(1)로 쓰고 '오더 원'으로 읽는다.",
          "O(1)：一百萬個定十個，一次乘、一次 load。寫 O(1)，讀「order one」。"
        ),
      },
      {
        topic = "LOOKUP",
        q = L(
          "Which Go type finds a price by name in O(1), on average?",
          "어떤 Go 타입이 이름으로 가격을 평균 O(1)에 찾나?",
          "邊個 Go type 平均用 O(1) 按名搵價錢？"
        ),
        code = L(
          [[
var menu ___[string]int
price := menu["tea"]    // hash the key, jump to the bucket
]],
          [[
var menu ___[string]int
price := menu["tea"]    // 키를 해시하고 버킷으로 점프
]],
          [[
var menu ___[string]int
price := menu["tea"]    // hash 個 key，跳去個 bucket
]]
        ),
        answer = "map",
        accept = { "map" },
        hint = L(
          "Three letters. A slice of pairs would need a scan, O(n); this hashes the key instead.",
          "세 글자. 쌍의 슬라이스면 O(n) 스캔, 이건 대신 키를 해시한다.",
          "三個字母。一個 pair slice 要 scan，O(n)；呢個改為 hash 個 key。"
        ),
        ok = L(
          "map[string]int: hash, bucket, compare. O(1) average, O(n) worst when everything collides. Python's dict, Rust's HashMap.",
          "map[string]int: 해시, 버킷, 비교. 평균 O(1), 전부 충돌하면 최악 O(n). Python의 dict, Rust의 HashMap.",
          "map[string]int：hash、bucket、比較。平均 O(1)，全部撞埋最差 O(n)。Python 嘅 dict，Rust 嘅 HashMap。"
        ),
      },
      {
        topic = "LAST",
        q = L(
          "The last item of a slice in one step. What is subtracted from the length?",
          "슬라이스의 마지막 항목을 한 단계로. 길이에서 무엇을 빼나?",
          "一步攞 slice 最後一個。長度減咩？"
        ),
        code = L(
          [[
last := items[len(items)___]    // still O(1): len is stored
]],
          [[
last := items[len(items)___]    // 여전히 O(1): len은 저장돼 있다
]],
          [[
last := items[len(items)___]    // 仍然 O(1)：len 係存起嘅
]]
        ),
        answer = "-1",
        accept = { "-1", "- 1" },
        hint = L(
          "Indexes start at 0, so the last one is one less than the count. len itself is O(1): Go keeps it in the slice header.",
          "인덱스는 0부터라 마지막은 개수보다 하나 작다. len 자체가 O(1): Go는 슬라이스 헤더에 보관.",
          "index 由 0 開始，所以最後一個係數量減一。len 本身係 O(1)：Go 存喺 slice header。"
        ),
        ok = L(
          "items[len(items)-1]. Python spells it items[-1]. Both constant time. So is append at the end, amortized.",
          "items[len(items)-1]. Python은 items[-1]. 둘 다 상수 시간. 끝에 append도 분할 상환으로 그렇다.",
          "items[len(items)-1]。Python 寫 items[-1]。兩個都係常數時間。尾部 append 攤分之後都係。"
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
          "Same. Big O drops constants: O(2), O(500) are all written O(1). The flat line is drawn; the counter street is done.",
          "그대로. 빅오는 상수를 버린다: O(2), O(500)은 모두 O(1)로 쓴다. 평평한 선이 그려지고 카운터 거리는 끝.",
          "一樣。Big O 掉走常數：O(2)、O(500) 全部寫 O(1)。平線畫好；櫃位街完成。"
        ),
      },
    },
  },
  {
    id = "bigo_n",
    station = "O(N)",
    name = L("The queue", "줄", "條隊"),
    title = L("Linear time", "선형 시간", "線性時間"),
    lesson = L(
      "O(n): one pass over the input; double n, double the work. A range loop, a sum, a scan for a value. O(n) + O(n) is still O(n): constants drop.",
      "O(n): 입력을 한 번 통과. n이 두 배면 일도 두 배. range 루프, 합계, 값 찾기 스캔. O(n) + O(n)도 O(n): 상수는 버린다.",
      "O(n)：輸入行一次；n 翻倍，工作翻倍。range loop、求和、scan 搵值。O(n) + O(n) 仍然係 O(n)：常數掉走。"
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
    viz = "chips",
    chips = {
      { "for _, x := range items", "cyan" },
      { "sum += x", "gold" },
      { "O(n) + O(n) = O(n)", "pink" },
      { "n - 1 comparisons", "green" },
    },
    note = "one pass  range  scan  drop constants",
    story = L(
      "The queue outside the shutter. To total the bill of everyone in it you visit each person once. "
        .. "Mei draws the second line on the whiteboard: a straight diagonal. Double the queue, double the work.",
      "셔터 밖의 줄. 모두의 계산서를 합하려면 한 사람씩 한 번 방문. 메이가 화이트보드에 둘째 선을 그린다: 곧은 대각선. 줄이 두 배면 일도 두 배.",
      "閘門外面條隊。要加埋每個人嘅單，每人探訪一次。阿美喺白板畫第二條線：一條直斜線。隊長一倍，工作多一倍。"
    ),
    stages = {
      {
        topic = "PASS",
        q = L(
          "One loop over n prices, adding each: what is the cost in Big O?",
          "n개 가격을 한 번 돌며 더하기: 빅오로 비용은?",
          "一個 loop 行 n 個價錢，逐個加：Big O 成本係？"
        ),
        code = L(
          [[
sum := 0
for _, p := range prices {    // ___ : n items, n adds
    sum += p
}
]],
          [[
sum := 0
for _, p := range prices {    // ___ : n개 항목, n번 더하기
    sum += p
}
]],
          [[
sum := 0
for _, p := range prices {    // ___ ：n 個項目，n 次加
    sum += p
}
]]
        ),
        answer = "O(n)",
        accept = { "O(n)", "linear" },
        hint = L(
          "Linear: the work grows in step with the input. Write it with a capital O and the size in brackets.",
          "선형: 일이 입력과 나란히 자란다. 대문자 O와 괄호 안의 크기로 쓴다.",
          "線性：工作量同輸入一齊增長。用大楷 O 加括號裏面嘅大小寫出嚟。"
        ),
        ok = L(
          "O(n). Every element is touched once. The most common cost in everyday code, and often the best possible.",
          "O(n). 모든 원소를 한 번씩 건드린다. 일상 코드에서 가장 흔한 비용이고 종종 가능한 최선.",
          "O(n)。每個元素掂一次。日常 code 最常見嘅成本，好多時已經係最好。"
        ),
      },
      {
        topic = "DROP",
        q = L(
          "Two separate loops over the same n items, one after the other: O(n) + O(n) simplifies to O(___)",
          "같은 n개 항목을 도는 별개의 루프 둘, 차례로: O(n) + O(n)은 O(___)로 단순화",
          "兩個獨立 loop 先後行同一個 n 個項目：O(n) + O(n) 簡化做 O(___)"
        ),
        code = L(
          [[
for _, p := range prices { total += p }       // n steps
for _, p := range prices { if p > max { max = p } }  // n more
// 2n steps, written O(___)
]],
          [[
for _, p := range prices { total += p }       // n단계
for _, p := range prices { if p > max { max = p } }  // n단계 더
// 2n단계, 표기는 O(___)
]],
          [[
for _, p := range prices { total += p }       // n 步
for _, p := range prices { if p > max { max = p } }  // 再 n 步
// 2n 步，寫成 O(___)
]]
        ),
        answer = "n",
        accept = { "n" },
        hint = L(
          "Just the size, no coefficient. 2n, 3n and n/2 are all the same order.",
          "크기만, 계수 없이. 2n, 3n, n/2는 모두 같은 차수.",
          "只係大小，冇系數。2n、3n 同 n/2 全部係同一個 order。"
        ),
        ok = L(
          "O(n). Big O keeps only the fastest-growing term and drops its coefficient. Sequential loops add; nested loops multiply.",
          "O(n). 빅오는 가장 빨리 자라는 항만 남기고 계수를 버린다. 순차 루프는 더하고 중첩 루프는 곱한다.",
          "O(n)。Big O 只留增長最快嘅項，掉走系數。先後嘅 loop 相加；嵌套嘅 loop 相乘。"
        ),
      },
      {
        topic = "SCAN",
        q = L(
          "Is a name in the slice? Without a map you must look at each one. Which keyword walks the slice?",
          "이름이 슬라이스에 있나? 맵 없이는 하나씩 봐야 한다. 슬라이스를 순회하는 키워드는?",
          "個名喺唔喺 slice 裏面？冇 map 就要逐個望。邊個 keyword 行 slice？"
        ),
        code = L(
          [[
func has(names []string, q string) bool {
    for _, s := ___ names {    // O(n): worst case, every one
        if s == q { return true }
    }
    return false
}
]],
          [[
func has(names []string, q string) bool {
    for _, s := ___ names {    // O(n): 최악엔 전부
        if s == q { return true }
    }
    return false
}
]],
          [[
func has(names []string, q string) bool {
    for _, s := ___ names {    // O(n)：最差要望晒
        if s == q { return true }
    }
    return false
}
]]
        ),
        answer = "range",
        accept = { "range" },
        hint = L(
          "Five letters, Go's only way to loop over a slice's elements. slices.Contains does exactly this inside.",
          "다섯 글자, Go에서 슬라이스 원소를 도는 유일한 방법. slices.Contains가 안에서 정확히 이걸 한다.",
          "五個字母，Go 行 slice 元素嘅唯一方法。slices.Contains 裏面做嘅就係呢樣。"
        ),
        ok = L(
          "A linear scan. Found early is lucky; Big O counts the worst case, n. A map[string]bool makes it O(1).",
          "선형 스캔. 일찍 찾으면 운이 좋은 것. 빅오는 최악, n을 센다. map[string]bool이면 O(1).",
          "線性 scan。早搵到係好運；Big O 計最差情況，n。用 map[string]bool 就變 O(1)。"
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
max := prices[0]
for _, p := range prices[1:] {   // ___ comparisons
    if p > max {
        max = p
    }
}
]],
          [[
max := prices[0]
for _, p := range prices[1:] {   // 비교 ___ 번
    if p > max {
        max = p
    }
}
]],
          [[
max := prices[0]
for _, p := range prices[1:] {   // ___ 次比較
    if p > max {
        max = p
    }
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
          "n-1 comparisons, which is O(n): you cannot know the max without seeing every value. The diagonal is drawn.",
          "비교 n-1번, 즉 O(n): 모든 값을 보지 않고는 최대를 알 수 없다. 대각선이 그려진다.",
          "n-1 次比較，即 O(n)：唔望晒所有值就唔會知最大係邊個。斜線畫好。"
        ),
      },
    },
  },
  {
    id = "bigo_log",
    station = "O(LOG N)",
    name = L("The phone book", "전화번호부", "電話簿"),
    title = L("Logarithmic time", "로그 시간", "對數時間"),
    lesson = L(
      "O(log n): each step halves what is left. Binary search on a sorted slice: 1024 items in 10 steps, a million in 20. Needs sorted input.",
      "O(log n): 단계마다 남은 것이 절반. 정렬된 슬라이스의 이진 탐색: 1024개를 10단계에, 백만을 20단계에. 정렬된 입력이 필요.",
      "O(log n)：每步將剩低嘅減半。排好序嘅 slice 上二元搜尋：1024 個 10 步，一百萬個 20 步。要排好序嘅輸入。"
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
          "A phone book: open the middle, decide left or right, throw half away. Again.",
          "전화번호부: 가운데를 펴고, 왼쪽인지 오른콕인지 정하고, 절반을 버려. 다시.",
          "電話簿：打開中間，決定左定右，掉走一半。再嚟。"
        ),
      },
    },
    viz = "chips",
    chips = {
      { "mid := (lo + hi) / 2", "cyan" },
      { "1024 -> 10 steps", "gold" },
      { "O(log n)", "pink" },
      { "sort first", "green" },
    },
    note = "halve  binary search  log2  sorted",
    story = L(
      "Siu Ming's phone book of suppliers, sorted by name. Nobody reads it from the front. Open the middle, "
        .. "go left or right, and the book is half as thick every time. Mei draws a line that climbs, then almost stops.",
      "시우밍의 공급업체 전화번호부, 이름순 정렬. 아무도 앞에서부터 읽지 않는다. 가운데를 펴고 왼쪽이나 오른쪽으로, 매번 책이 절반 두께가 된다. 메이가 올라가다 거의 멈추는 선을 그린다.",
      "小明嘅供應商電話簿，按名排好。冇人由頭讀。打開中間，向左或者向右，每次本書都薄一半。阿美畫一條升到差唔多停嘅線。"
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
lo, hi := 0, len(a)
for lo < hi {
    mid := (lo + hi) ___ 2   // integer division in Go
    if a[mid] < x { lo = mid + 1 } else { hi = mid }
}
]],
          [[
lo, hi := 0, len(a)
for lo < hi {
    mid := (lo + hi) ___ 2   // Go의 정수 나눗셈
    if a[mid] < x { lo = mid + 1 } else { hi = mid }
}
]],
          [[
lo, hi := 0, len(a)
for lo < hi {
    mid := (lo + hi) ___ 2   // Go 嘅整數除法
    if a[mid] < x { lo = mid + 1 } else { hi = mid }
}
]]
        ),
        answer = "/",
        accept = { "/" },
        hint = L(
          "One slash. On ints Go rounds toward zero, so no floor operator is needed.",
          "슬래시 하나. int에서 Go는 0 방향으로 버리므로 내림 연산자가 필요 없다.",
          "一條斜線。對 int Go 向零取整，所以唔使向下除運算符。"
        ),
        ok = L(
          "(lo + hi) / 2, or lo + (hi-lo)/2 to dodge overflow. Each pass throws away half the range.",
          "(lo + hi) / 2, 또는 오버플로를 피하려면 lo + (hi-lo)/2. 통과마다 범위의 절반을 버린다.",
          "(lo + hi) / 2，或者 lo + (hi-lo)/2 避 overflow。每一輪掉走一半範圍。"
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
// ___ halvings: log2(1024)
]],
          [[
// 1024 -> 512 -> 256 -> 128 -> 64 -> 32 -> 16 -> 8 -> 4 -> 2 -> 1
// 절반으로 ___ 번: log2(1024)
]],
          [[
// 1024 -> 512 -> 256 -> 128 -> 64 -> 32 -> 16 -> 8 -> 4 -> 2 -> 1
// ___ 次減半：log2(1024)
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
          "10. A million items take 20, a billion 30. That is how slowly log n grows: the line almost lies down.",
          "10. 백만 개는 20, 십억은 30. log n은 그만큼 느리게 자란다: 선이 거의 눕는다.",
          "10。一百萬個要 20，十億要 30。log n 就係咁慢：條線幾乎躺平。"
        ),
      },
      {
        topic = "COST",
        q = L(
          "So binary search on n sorted items costs how much, in Big O?",
          "그러면 정렬된 n개의 이진 탐색은 빅오로 얼마?",
          "所以 n 個排好序項目嘅二元搜尋，Big O 係幾多？"
        ),
        code = L(
          [[
i, found := slices.BinarySearch(a, x)   // ___
]],
          [[
i, found := slices.BinarySearch(a, x)   // ___
]],
          [[
i, found := slices.BinarySearch(a, x)   // ___
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
          "O(log n). Balanced trees, heaps and skip lists live here too. It is the second-best cost after O(1).",
          "O(log n). 균형 트리, 힙, 스킵 리스트도 여기 산다. O(1) 다음으로 좋은 비용.",
          "O(log n)。平衡樹、heap 同 skip list 都住喺呢度。O(1) 之後第二好嘅成本。"
        ),
      },
      {
        topic = "SORTED",
        q = L(
          "Binary search has one precondition. The slice must be ___",
          "이진 탐색엔 전제 조건 하나가 있다. 슬라이스는 ___여야 한다",
          "二元搜尋有一個前提。slice 必須係 ___"
        ),
        code = L(
          [[
// BinarySearch on an unsorted slice returns nonsense.
// Precondition: a is ___ ascending.
sort.Ints(a)
i, found := slices.BinarySearch(a, 38)
]],
          [[
// 정렬되지 않은 슬라이스의 BinarySearch는 엉뚱한 값을 준다.
// 전제 조건: a는 오름차순으로 ___.
sort.Ints(a)
i, found := slices.BinarySearch(a, 38)
]],
          [[
// 未排序 slice 上嘅 BinarySearch 回傳亂嘢。
// 前提：a 係升序 ___。
sort.Ints(a)
i, found := slices.BinarySearch(a, 38)
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
    id = "bigo_nlogn",
    station = "N LOG N",
    name = L("The sorting hat", "정렬 모자", "分類帽"),
    title = L("Sorting: n log n", "정렬: n log n", "排序：n log n"),
    lesson = L(
      "O(n log n): the cost of a good sort. Merge sort has log n levels, each doing O(n) work. sort.Ints, sort.Strings and slices.Sort all live here. Sort once, search many times.",
      "O(n log n): 좋은 정렬의 비용. 병합 정렬은 log n 레벨, 각 레벨이 O(n) 일. sort.Ints, sort.Strings, slices.Sort가 여기 산다. 한 번 정렬하고 여러 번 탐색.",
      "O(n log n)：一個好排序嘅成本。merge sort 有 log n 層，每層做 O(n) 工作。sort.Ints、sort.Strings 同 slices.Sort 都住呢度。排一次，搵好多次。"
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
          "And the log n is how many times you can halve. Levels times work per level.",
          "그리고 log n은 절반으로 나눌 수 있는 횟수. 레벨 수 곱하기 레벨당 일.",
          "而 log n 係你可以減半幾多次。層數乘每層工作。"
        ),
      },
    },
    viz = "chips",
    chips = {
      { "sort.Ints(a)", "cyan" },
      { "log n levels x O(n)", "gold" },
      { "sort.Strings(names)", "pink" },
      { "search: O(log n)", "green" },
    },
    note = "merge sort  levels x merge  sort once",
    story = L(
      "The sorting hat: a shoebox of the night's receipts. Alex sorts them by splitting the pile in half, "
        .. "again and again, then merging the piles back in order. Mei draws the line between linear and quadratic.",
      "정렬 모자: 오늘 밤 영수증이 든 신발 상자. 알렉스는 더미를 반으로, 또 반으로 나눈 뒤 순서대로 다시 병합해 정렬한다. 메이가 선형과 이차 사이에 선을 그린다.",
      "分類帽：一個裝住今晚收據嘅鞋盒。阿力將疊嘢分兩半，再分，再分，然後按次序合併返。阿美畫一條喺線性同二次之間嘅線。"
    ),
    stages = {
      {
        topic = "SORT",
        q = L(
          "sort.Ints on n receipts: what does it cost, in Big O?",
          "n개 영수증에 sort.Ints: 빅오로 비용은?",
          "對 n 張收據 sort.Ints：Big O 成本係？"
        ),
        code = L(
          [[
sort.Ints(amounts)    // ___ : pdqsort, comparison-based
]],
          [[
sort.Ints(amounts)    // ___ : pdqsort, 비교 기반
]],
          [[
sort.Ints(amounts)    // ___ ：pdqsort，基於比較
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
          "O(n log n). A million items: about 20 million comparisons, not a trillion. The proven lower bound for comparison sorts.",
          "O(n log n). 백만 개: 약 2천만 번 비교, 1조가 아니라. 비교 정렬의 증명된 하한.",
          "O(n log n)。一百萬個：大約二千萬次比較，唔係一萬億。比較排序已證明嘅下限。"
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
        topic = "STRINGS",
        q = L(
          "Sort the supplier names. Which function from the sort package?",
          "공급업체 이름을 정렬. sort 패키지의 어떤 함수?",
          "排供應商嘅名。sort package 嘅邊個 function？"
        ),
        code = L(
          [[
names := []string{"Wing", "Bo", "Mei"}
sort.___(names)          // O(n log n)
fmt.Println(names)       // [Bo Mei Wing]
]],
          [[
names := []string{"Wing", "Bo", "Mei"}
sort.___(names)          // O(n log n)
fmt.Println(names)       // [Bo Mei Wing]
]],
          [[
names := []string{"Wing", "Bo", "Mei"}
sort.___(names)          // O(n log n)
fmt.Println(names)       // [Bo Mei Wing]
]]
        ),
        answer = "Strings",
        accept = { "Strings" },
        hint = L(
          "The element type, plural, capitalized, like sort.Ints for ints.",
          "원소 타입의 복수형, 대문자로. int의 sort.Ints처럼.",
          "元素 type 嘅眾數，大楷，好似 int 嘅 sort.Ints。"
        ),
        ok = L(
          "sort.Strings(names). Go 1.21's slices.Sort(names) is generic and does the same. Both n log n.",
          "sort.Strings(names). Go 1.21의 slices.Sort(names)는 제네릭이고 같은 일을 한다. 둘 다 n log n.",
          "sort.Strings(names)。Go 1.21 嘅 slices.Sort(names) 係 generic，做同一件事。兩個都係 n log n。"
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
sort.Ints(a)                        // once: n log n
for _, x := range queries {
    _, ok := slices.BinarySearch(a, x)   // each: O(___)
}
]],
          [[
sort.Ints(a)                        // 한 번: n log n
for _, x := range queries {
    _, ok := slices.BinarySearch(a, x)   // 각각: O(___)
}
]],
          [[
sort.Ints(a)                        // 一次：n log n
for _, x := range queries {
    _, ok := slices.BinarySearch(a, x)   // 每次：O(___)
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
          "탐색당 O(log n). 먼저 정렬하는 것은 처음 몇 번의 조회 후 이득이 된다. 정렬 모자 완료.",
          "每次搵 O(log n)。先排序，搵幾次之後就回本。分類帽完成。"
        ),
      },
    },
  },
  {
    id = "bigo_quad",
    station = "O(N^2)",
    name = L("The seating chart", "좌석 배치표", "座位表"),
    title = L("Quadratic time", "이차 시간", "二次時間"),
    lesson = L(
      "O(n^2): a loop inside a loop over the same n. Comparing every pair. 100 items is 4950 pairs; 10,000 is fifty million. A map turns most of these into O(n).",
      "O(n^2): 같은 n을 도는 루프 안의 루프. 모든 쌍 비교. 100개면 4950쌍, 만 개면 5천만. 맵이 대부분을 O(n)으로 바꾼다.",
      "O(n^2)：同一個 n 嘅 loop 裏面再一個 loop。比較每一對。100 個係 4950 對；一萬個係五千萬。用 map 大部分變返 O(n)。"
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
          "Checking every guest against every other guest for a double booking. It was fine with 20. It is not fine with 2000.",
          "중복 예약을 찾으려고 모든 손님을 모든 다른 손님과 비교했어요. 20명일 땐 괜찮았죠. 2000명은 아니에요.",
          "為咗搵重複訂位，每個客同每個其他客比較。20 個人冇問題。2000 個就唔得。"
        ),
      },
    },
    viz = "chips",
    chips = {
      { "for i { for j { ... } }", "cyan" },
      { "n(n-1)/2 pairs", "gold" },
      { "map[string]bool{}", "pink" },
      { "O(n*m)", "green" },
    },
    note = "nested  pairs  map fix  n*m",
    story = L(
      "The seating chart for a banquet. Siu Ming's script checks every guest against every other for a duplicate. "
        .. "Mei draws a curve that bends upward and leaves the board. Nested loops over the same list: the shape to avoid.",
      "연회 좌석 배치표. 시우밍의 스크립트는 중복을 찾으려고 모든 손님을 모든 다른 손님과 비교한다. 메이가 위로 꺾여 보드를 벗어나는 곡선을 그린다. 같은 리스트를 도는 중첩 루프: 피해야 할 모양.",
      "宴會嘅座位表。小明嘅 script 每個客同每個其他客比較搵重複。阿美畫一條向上彎到出咗白板嘅曲線。同一個 list 嘅嵌套 loop：要避開嘅形狀。"
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
for i := range guests {
    for j := range guests {       // ___ : n x n checks
        if i != j && guests[i] == guests[j] { dup = true }
    }
}
]],
          [[
for i := range guests {
    for j := range guests {       // ___ : n x n번 확인
        if i != j && guests[i] == guests[j] { dup = true }
    }
}
]],
          [[
for i := range guests {
    for j := range guests {       // ___ ：n x n 次檢查
        if i != j && guests[i] == guests[j] { dup = true }
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
          "4950. For 10,000 guests it is about fifty million. Big O ignores the /2, and rightly: the curve is the same.",
          "4950. 손님 만 명이면 약 5천만. 빅오는 /2를 무시하고, 그게 맞다: 곡선은 같다.",
          "4950。一萬個客就大約五千萬。Big O 唔理個 /2，亦係啱嘅：條曲線一樣。"
        ),
      },
      {
        topic = "MAPFIX",
        q = L(
          "The O(n) fix: remember each name as you go. What value type makes the map a set?",
          "O(n) 해법: 지나가며 이름을 기억. 어떤 값 타입이 맵을 집합으로 만드나?",
          "O(n) 嘅解法：一路行一路記住每個名。邊個值 type 令 map 變成 set？"
        ),
        code = L(
          [[
seen := map[string]___{}
for _, g := range guests {        // one pass: O(n)
    if seen[g] { dup = true }
    seen[g] = true
}
]],
          [[
seen := map[string]___{}
for _, g := range guests {        // 한 번 통과: O(n)
    if seen[g] { dup = true }
    seen[g] = true
}
]],
          [[
seen := map[string]___{}
for _, g := range guests {        // 一次過：O(n)
    if seen[g] { dup = true }
    seen[g] = true
}
]]
        ),
        answer = "bool",
        accept = { "bool", "struct{}" },
        hint = L(
          "Four letters, the type of true. map[T]struct{} saves a byte per entry and is the other idiom.",
          "네 글자, true의 타입. map[T]struct{}는 항목당 1바이트를 아끼는 다른 관용구.",
          "四個字母，true 嘅 type。map[T]struct{} 每個項目慳一個 byte，係另一個慣用寫法。"
        ),
        ok = L(
          "map[string]bool as a set: one O(1) lookup per guest, O(n) total. Fifty million checks become ten thousand.",
          "집합으로서의 map[string]bool: 손님당 O(1) 조회 한 번, 합계 O(n). 5천만 번이 만 번이 된다.",
          "map[string]bool 當 set：每個客一次 O(1) 查找，總共 O(n)。五千萬次變一萬次。"
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
for _, t := range tables {      // m
    for _, g := range guests {  // n
        fits(t, g)              // ___ calls
    }
}
]],
          [[
for _, t := range tables {      // m
    for _, g := range guests {  // n
        fits(t, g)              // ___ 번 호출
    }
}
]],
          [[
for _, t := range tables {      // m
    for _, g := range guests {  // n
        fits(t, g)              // ___ 次 call
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
    id = "bigo_exp",
    station = "O(2^N)",
    name = L("The combinatorics counter", "조합 카운터", "組合櫃位"),
    title = L("Exponential time", "지수 시간", "指數時間"),
    lesson = L(
      "O(2^n): the work doubles when n grows by one. Naive fib makes two calls per call. A memo brings it to O(n). Listing every subset of n items is 2^n and cannot be helped.",
      "O(2^n): n이 1 늘 때 일이 두 배. 순진한 fib는 호출마다 호출 둘. memo가 O(n)으로 만든다. n개의 모든 부분집합 나열은 2^n이고 피할 수 없다.",
      "O(2^n)：n 加一，工作翻倍。天真嘅 fib 每個 call 再 call 兩次。memo 令佢變 O(n)。列出 n 個項目嘅所有子集係 2^n，冇得救。"
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
    viz = "chips",
    chips = {
      { "fib(n-1) + fib(n-2)", "cyan" },
      { "memo[n]", "gold" },
      { "2^n subsets", "pink" },
      { "O(2^n) -> O(n)", "green" },
    },
    note = "two calls  doubling  memo  subsets",
    story = L(
      "The combinatorics counter at the noodle stall: pick any toppings. Bo counts the combinations and the number "
        .. "doubles with every topping. Mei draws the last curve, the one that goes vertical almost at once.",
      "국수 노점의 조합 카운터: 토핑을 아무렇게나 고른다. 보가 조합을 세는데 토핑 하나마다 수가 두 배. 메이가 마지막 곡선, 거의 곧바로 수직이 되는 곡선을 그린다.",
      "麵檔嘅組合櫃位：任揀配料。寶廚數組合，每加一種配料數目翻倍。阿美畫最後一條曲線，幾乎即刻變垂直嗰條。"
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
func fib(n int) int {
    if n < 2 { return n }
    return fib(n-1) + fib(n-2)   // ___ : two calls each
}
]],
          [[
func fib(n int) int {
    if n < 2 { return n }
    return fib(n-1) + fib(n-2)   // ___ : 각각 호출 둘
}
]],
          [[
func fib(n int) int {
    if n < 2 { return n }
    return fib(n-1) + fib(n-2)   // ___ ：每個兩次 call
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
          "O(2^n). fib(40) is about a billion calls; fib(50) would take a day. The worst curve on the board.",
          "O(2^n). fib(40)은 약 십억 번 호출, fib(50)은 하루. 보드에서 가장 나쁜 곡선.",
          "O(2^n)。fib(40) 大約十億次 call；fib(50) 要一日。白板上最差嘅曲線。"
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
          "O(n). Memoization trades O(n) memory for the exponential time. The single biggest win in this whole quest.",
          "O(n). 메모이제이션은 O(n) 메모리로 지수 시간을 산다. 이 퀘스트 전체에서 가장 큰 승리.",
          "O(n)。memoization 用 O(n) 記憶體換走指數時間。成個任務裏面最大嘅一次勝利。"
        ),
      },
      {
        topic = "MEMOCODE",
        q = L(
          "Look the answer up before computing. Fill the comma-ok test: if v, ok := memo[n]; ___",
          "계산 전에 답을 찾아본다. comma-ok 검사를 채워라: if v, ok := memo[n]; ___",
          "計之前先查答案。填 comma-ok 檢查：if v, ok := memo[n]; ___"
        ),
        code = L(
          [[
var memo = map[int]int{}
func fib(n int) int {
    if v, ok := memo[n]; ___ { return v }
    if n < 2 { return n }
    memo[n] = fib(n-1) + fib(n-2)
    return memo[n]
}
]],
          [[
var memo = map[int]int{}
func fib(n int) int {
    if v, ok := memo[n]; ___ { return v }
    if n < 2 { return n }
    memo[n] = fib(n-1) + fib(n-2)
    return memo[n]
}
]],
          [[
var memo = map[int]int{}
func fib(n int) int {
    if v, ok := memo[n]; ___ { return v }
    if n < 2 { return n }
    memo[n] = fib(n-1) + fib(n-2)
    return memo[n]
}
]]
        ),
        answer = "ok",
        accept = { "ok" },
        hint = L(
          "The second value of the map lookup, the boolean that says the key was present.",
          "맵 조회의 두 번째 값, 키가 있었다는 불리언.",
          "map 查找嘅第二個值，話你知個 key 存在嘅 boolean。"
        ),
        ok = L(
          "if v, ok := memo[n]; ok. Hit: return. Miss: compute and store. Python spells this @functools.cache.",
          "if v, ok := memo[n]; ok. 있으면 반환, 없으면 계산하고 저장. Python은 @functools.cache.",
          "if v, ok := memo[n]; ok。有就回傳；冇就計並存起。Python 寫 @functools.cache。"
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
// n toppings: ___ combos, and listing them all cannot be faster
]],
          [[
// 토핑 1개: 조합 2   2개: 4   3개: 8
// 토핑 n개: 조합 ___ 개, 전부 나열하는 건 더 빠를 수 없다
]],
          [[
// 1 種配料：2 種組合   2 種：4   3 種：8
// n 種配料：___ 種組合，全部列出唔可能更快
]]
        ),
        answer = "2^n",
        accept = { "2^n", "2**n" },
        hint = L(
          "Two choices per topping, multiplied n times. Two, a caret, n.",
          "토핑마다 선택 둘, n번 곱하기. 2, 캐럿, n.",
          "每種配料兩個選擇，乘 n 次。2、^、n。"
        ),
        ok = L(
          "2^n subsets. When the output itself is exponential no algorithm can be faster; when only the answer is needed, look for a memo. The board is full.",
          "부분집합 2^n개. 출력 자체가 지수적이면 어떤 알고리즘도 더 빠를 수 없다. 답만 필요하면 memo를 찾자. 보드가 가득 찼다.",
          "2^n 個子集。輸出本身係指數嗰陣冇算法可以更快；只需要答案嗰陣就搵 memo。白板寫滿。"
        ),
      },
    },
  },
  {
    id = "bigo_space",
    station = "SPACE",
    name = L("The storeroom", "창고", "貨倉"),
    title = L("Space complexity", "공간 복잡도", "空間複雜度"),
    lesson = L(
      "Space counts extra memory, not the input. In-place sort: O(1). A copy of the list: O(n). Recursion uses stack: quicksort O(log n) on average. Memos trade space for time.",
      "공간은 입력이 아닌 추가 메모리를 센다. 제자리 정렬: O(1). 리스트 복사: O(n). 재귀는 스택을 쓴다: 퀵소트는 평균 O(log n). memo는 공간으로 시간을 산다.",
      "空間計額外記憶體，唔計輸入。就地排序：O(1)。copy 個 list：O(n)。遞歸用 stack：quicksort 平均 O(log n)。memo 用空間換時間。"
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
          "Time is one axis. Memory is the other. Every memo you loved tonight paid rent here.",
          "시간이 한 축, 메모리가 다른 축. 오늘 밤 네가 좋아한 모든 memo는 여기서 집세를 냈어.",
          "時間係一條軸。記憶體係另一條。今晚你鍾意嘅每個 memo 都喺呢度交租。"
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
    viz = "chips",
    chips = {
      { "sort.Ints(a) // in place", "cyan" },
      { "b := make([]int, len(a))", "gold" },
      { "stack depth", "pink" },
      { "space for time", "green" },
    },
    note = "extra memory  in place  copy  stack",
    story = L(
      "The storeroom: every algorithm needs somewhere to put things. Sorting the trays where they stand costs "
        .. "no shelf; copying them onto a new rack costs a rack the size of the input. Mei adds the second axis to the board.",
      "창고: 모든 알고리즘은 물건을 둘 곳이 필요하다. 트레이를 선 자리에서 정렬하면 선반이 필요 없고, 새 선반에 복사하면 입력 크기의 선반이 든다. 메이가 보드에 둘째 축을 더한다.",
      "貨倉：每個算法都要有地方放嘢。盤喺原位排唔使多一個架；copy 上新架就要一個同輸入一樣大嘅架。阿美喺白板加第二條軸。"
    ),
    stages = {
      {
        topic = "INPLACE",
        q = L(
          "sort.Ints sorts the slice where it is. Extra memory, in Big O: O(___)",
          "sort.Ints는 슬라이스를 제자리에서 정렬. 추가 메모리는 빅오로 O(___)",
          "sort.Ints 就地排 slice。額外記憶體，Big O：O(___)"
        ),
        code = L(
          [[
sort.Ints(a)    // in place: O(___) extra space
]],
          [[
sort.Ints(a)    // 제자리: 추가 공간 O(___)
]],
          [[
sort.Ints(a)    // 就地：額外空間 O(___)
]]
        ),
        answer = "1",
        accept = { "1", "constant" },
        hint = L(
          "A handful of index variables, however long the slice. Constant.",
          "슬라이스가 얼마나 길든 인덱스 변수 몇 개. 상수.",
          "唔理 slice 幾長都只係幾個 index 變數。常數。"
        ),
        ok = L(
          "O(1) extra: pdqsort swaps within the slice. The input itself is never counted as extra space.",
          "추가 O(1): pdqsort는 슬라이스 안에서 교환. 입력 자체는 추가 공간으로 세지 않는다.",
          "額外 O(1)：pdqsort 喺 slice 裏面交換。輸入本身永遠唔計做額外空間。"
        ),
      },
      {
        topic = "COPY",
        q = L(
          "A sorted copy, leaving the original untouched, needs a second slice. Extra space: O(___)",
          "원본을 건드리지 않은 정렬 복사본에는 둘째 슬라이스가 필요. 추가 공간: O(___)",
          "唔掂原本嘅排好序副本要第二個 slice。額外空間：O(___)"
        ),
        code = L(
          [[
b := slices.Clone(a)    // a second slice of n ints: O(___)
sort.Ints(b)
]],
          [[
b := slices.Clone(a)    // n개 int의 둘째 슬라이스: O(___)
sort.Ints(b)
]],
          [[
b := slices.Clone(a)    // 第二個 n 個 int 嘅 slice：O(___)
sort.Ints(b)
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
          "O(n). Merge sort needs the same: an O(n) scratch buffer for merging. Python's sorted() copies too.",
          "O(n). 병합 정렬도 같다: 병합용 O(n) 임시 버퍼. Python의 sorted()도 복사한다.",
          "O(n)。merge sort 都一樣：合併用嘅 O(n) 暫存 buffer。Python 嘅 sorted() 都會 copy。"
        ),
      },
      {
        topic = "MAKE",
        q = L(
          "Build that copy by hand: a new slice as long as a, then copy into it. Which built-in gives the length?",
          "그 복사본을 손으로: a만큼 긴 새 슬라이스, 그다음 복사. 길이를 주는 내장 함수는?",
          "手動整個副本：一個同 a 一樣長嘅新 slice，再 copy 入去。邊個內建 function 畀長度？"
        ),
        code = L(
          [[
b := make([]int, ___(a))    // allocate n ints
copy(b, a)                  // O(n) time, O(n) space
]],
          [[
b := make([]int, ___(a))    // n개 int 할당
copy(b, a)                  // O(n) 시간, O(n) 공간
]],
          [[
b := make([]int, ___(a))    // 分配 n 個 int
copy(b, a)                  // O(n) 時間，O(n) 空間
]]
        ),
        answer = "len",
        accept = { "len" },
        hint = L(
          "Three letters, O(1) itself: the slice header stores it.",
          "세 글자, 자체는 O(1): 슬라이스 헤더에 저장돼 있다.",
          "三個字母，本身係 O(1)：slice header 存住佢。"
        ),
        ok = L(
          "make([]int, len(a)) then copy. Allocation is where space complexity is paid; the garbage collector collects the rent later.",
          "make([]int, len(a)) 다음 copy. 할당이 공간 복잡도를 내는 곳. 가비지 컬렉터가 나중에 집세를 걷는다.",
          "make([]int, len(a)) 再 copy。分配就係交空間複雜度嘅地方；GC 遲啲收租。"
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
          "O(log n) stack frames on average. Every axis on the board has a name now. Alex takes the O(1) stamp.",
          "평균 스택 프레임 O(log n). 보드의 모든 축에 이제 이름이 있다. 알렉스가 O(1) 도장을 받는다.",
          "平均 O(log n) 個 stack frame。白板上每條軸都有名了。阿力攞到 O(1) 印。"
        ),
      },
    },
  },
}

return maps
