-- Quest P4 BIG O: how fast is it, the Python round. The same seven streets
-- as src/data_bigo.lua, O(1) to O(2^n) and then space, with Python on the
-- whiteboard: list, dict, set, bisect, sorted, functools.cache.
-- Same shape as src/data.lua: the blank ___ is NOT written in the code.

local function L(en, ko, yue)
  return { en = en, ko = ko, yue = yue }
end

local maps = {
  {
    id = "py_bigo_one",
    station = "O(1)",
    name = L("The counter", "카운터", "櫃位"),
    title = L("Constant time", "상수 시간", "常數時間"),
    lesson = L(
      "O(1): the same number of steps however big the input. Indexing a list, a dict lookup, items[-1]. Doubling n changes nothing.",
      "O(1): 입력이 얼마나 커도 같은 단계 수. 리스트 인덱싱, dict 조회, items[-1]. n이 두 배가 돼도 변하지 않는다.",
      "O(1)：輸入幾大都係同樣步數。list index、dict 查找、items[-1]。n 翻倍都冇變。"
    ),
    bg = "bg_lab",
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
          "Last board of the night, Python column. Same question: input doubles, then what?",
          "오늘 밤 마지막 보드, Python 칸. 같은 질문: 입력이 두 배면, 그다음은?",
          "今晚最後一塊白板，Python 欄。同一條問題：輸入翻倍，然後點？"
        ),
      },
    },
    viz = "python",
    chips = {
      { "items[3]", "cyan" },
      { 'menu["tea"]', "gold" },
      { "items[-1]", "pink" },
      { "O(1)", "green" },
    },
    note = "index  dict  [-1]  n doubles -> same",
    story = L(
      "The whiteboard one more time, the Python column. Chef Bo takes the marker: n across, work up. "
        .. "First street: the operations whose line stays flat, written the Python way.",
      "화이트보드를 한 번 더, Python 칸. 보 셰프가 마커를 잡는다: 가로 n, 세로 일. 첫 거리: 선이 평평한 연산들, Python식으로.",
      "白板再嚟一次，Python 欄。寶廚攞起筆：橫係 n，直係工作量。第一條街：條線平嘅操作，用 Python 寫法。"
    ),
    stages = {
      {
        topic = "INDEX",
        q = L(
          "Reading items[3] from a list of n items: how many steps, in Big O?",
          "n개짜리 리스트에서 items[3]을 읽기: 빅오로 몇 단계?",
          "由 n 個元素嘅 list 讀 items[3]：Big O 係幾多步？"
        ),
        code = L(
          [[
def fourth(items):
    return items[3]    # ___ : one address, one read
]],
          [[
def fourth(items):
    return items[3]    # ___ : 주소 하나, 읽기 한 번
]],
          [[
def fourth(items):
    return items[3]    # ___ ：一個地址，一次讀取
]]
        ),
        answer = "O(1)",
        accept = { "O(1)", "1", "constant" },
        hint = L(
          "Constant. A Python list is an array of pointers; index 3 is base plus 3 times a pointer's size.",
          "상수. Python 리스트는 포인터 배열. 3번은 기준 더하기 3 곱하기 포인터 크기.",
          "常數。Python list 係一個 pointer array；index 3 係 base 加 3 乘一個 pointer 嘅大小。"
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
          "Which built-in type finds a price by name in O(1), on average?",
          "어떤 내장 타입이 이름으로 가격을 평균 O(1)에 찾나?",
          "邊個內建 type 平均用 O(1) 按名搵價錢？"
        ),
        code = L(
          [[
menu = ___(tea=12, noodles=38)
price = menu["tea"]    # hash the key, jump to the slot
]],
          [[
menu = ___(tea=12, noodles=38)
price = menu["tea"]    # 키를 해시하고 슬롯으로 점프
]],
          [[
menu = ___(tea=12, noodles=38)
price = menu["tea"]    # hash 個 key，跳去個 slot
]]
        ),
        answer = "dict",
        accept = { "dict" },
        hint = L(
          "Four letters, the type {} makes. A list of pairs would need a scan, O(n).",
          "네 글자, {}가 만드는 타입. 쌍의 리스트면 O(n) 스캔.",
          "四個字母，{} 造出嚟嘅 type。用 pair list 要 scan，O(n)。"
        ),
        ok = L(
          "dict: hash, slot, compare. O(1) average, O(n) worst when everything collides. Go's map, Rust's HashMap.",
          "dict: 해시, 슬롯, 비교. 평균 O(1), 전부 충돌하면 최악 O(n). Go의 map, Rust의 HashMap.",
          "dict：hash、slot、比較。平均 O(1)，全部撞埋最差 O(n)。Go 嘅 map，Rust 嘅 HashMap。"
        ),
      },
      {
        topic = "LAST",
        q = L(
          "The last item of a list in one step, without len. Which index?",
          "len 없이 리스트의 마지막 항목을 한 단계로. 어떤 인덱스?",
          "唔用 len 一步攞 list 最後一個。邊個 index？"
        ),
        code = L(
          [[
last = items[___]    # still O(1): negative indexes count from the end
]],
          [[
last = items[___]    # 여전히 O(1): 음수 인덱스는 끝에서부터
]],
          [[
last = items[___]    # 仍然 O(1)：負數 index 由尾數起
]]
        ),
        answer = "-1",
        accept = { "-1" },
        hint = L(
          "One less than zero. Go spells the same thing items[len(items)-1].",
          "0보다 하나 작게. Go는 같은 것을 items[len(items)-1]로 쓴다.",
          "零減一。Go 寫 items[len(items)-1] 做同一件事。"
        ),
        ok = L(
          "items[-1]. Python adds len for you. Constant time, like append at the end (amortized) and pop().",
          "items[-1]. Python이 len을 대신 더해준다. 상수 시간, 끝에 append(분할 상환)와 pop()처럼.",
          "items[-1]。Python 幫你加 len。常數時間，同尾部 append（攤分）同 pop() 一樣。"
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
# n = 1000 -> items[3] : 1 step
# n = 2000 -> items[3] : 1 step
# the cost stays the ___
]],
          [[
# n = 1000 -> items[3] : 1단계
# n = 2000 -> items[3] : 1단계
# 비용은 그대로: the ___
]],
          [[
# n = 1000 -> items[3] : 1 步
# n = 2000 -> items[3] : 1 步
# 成本保持 the ___
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
    id = "py_bigo_n",
    station = "O(N)",
    name = L("The queue", "줄", "條隊"),
    title = L("Linear time", "선형 시간", "線性時間"),
    lesson = L(
      "O(n): one pass over the input; double n, double the work. sum, max, x in list. O(n) + O(n) is still O(n): constants drop.",
      "O(n): 입력을 한 번 통과. n이 두 배면 일도 두 배. sum, max, x in list. O(n) + O(n)도 O(n): 상수는 버린다.",
      "O(n)：輸入行一次；n 翻倍，工作翻倍。sum、max、x in list。O(n) + O(n) 仍然係 O(n)：常數掉走。"
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
    viz = "python",
    chips = {
      { "sum(prices)", "cyan" },
      { "x in names", "gold" },
      { "O(n) + O(n) = O(n)", "pink" },
      { "n - 1 comparisons", "green" },
    },
    note = "one pass  sum  in  drop constants",
    story = L(
      "The queue outside the shutter. To total everyone's bill you visit each person once. "
        .. "Bo draws the diagonal, and reminds Alex that a built-in like sum hides the loop, not its cost.",
      "셔터 밖의 줄. 모두의 계산서를 합하려면 한 사람씩 한 번 방문. 보가 대각선을 그리고, sum 같은 내장 함수는 루프를 숨길 뿐 비용을 숨기지 않는다고 알렉스에게 일러준다.",
      "閘門外面條隊。要加埋每個人嘅單，每人探訪一次。寶廚畫斜線，提阿力 sum 呢類內建收埋個 loop，收唔埋成本。"
    ),
    stages = {
      {
        topic = "PASS",
        q = L(
          "sum over n prices: what is the cost in Big O?",
          "n개 가격의 sum: 빅오로 비용은?",
          "對 n 個價錢 sum：Big O 成本係？"
        ),
        code = L(
          [[
total = sum(prices)    # ___ : n items, n adds, inside C
]],
          [[
total = sum(prices)    # ___ : n개 항목, n번 더하기, C 안에서
]],
          [[
total = sum(prices)    # ___ ：n 個項目，n 次加，喺 C 裏面
]]
        ),
        answer = "O(n)",
        accept = { "O(n)", "linear" },
        hint = L(
          "Linear: the work grows in step with the input. A one-word built-in is still a loop underneath.",
          "선형: 일이 입력과 나란히 자란다. 한 단어 내장 함수도 밑에서는 루프.",
          "線性：工作量同輸入一齊增長。一個字嘅內建下面仍然係一個 loop。"
        ),
        ok = L(
          "O(n). sum, max, min, any, all, list.count: every one is a pass. Faster in C, same order.",
          "O(n). sum, max, min, any, all, list.count: 모두 한 번 통과. C라서 빠르지만 차수는 같다.",
          "O(n)。sum、max、min、any、all、list.count：每個都係一次過。C 裏面快啲，order 一樣。"
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
total = sum(prices)    # n steps
top = max(prices)      # n more
# 2n steps, written O(___)
]],
          [[
total = sum(prices)    # n단계
top = max(prices)      # n단계 더
# 2n단계, 표기는 O(___)
]],
          [[
total = sum(prices)    # n 步
top = max(prices)      # 再 n 步
# 2n 步，寫成 O(___)
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
          "O(n). Sequential passes add and the constant drops. Nested passes multiply: that is two streets on.",
          "O(n). 순차 통과는 더해지고 상수는 버려진다. 중첩 통과는 곱해진다: 그건 두 거리 뒤.",
          "O(n)。先後嘅 pass 相加，常數掉走。嵌套嘅 pass 相乘：嗰個係兩條街之後。"
        ),
      },
      {
        topic = "SCAN",
        q = L(
          "Is a name in the list? Python has a keyword for it, but on a list it scans. Which keyword?",
          "이름이 리스트에 있나? Python엔 키워드가 있지만 리스트에선 스캔한다. 어떤 키워드?",
          "個名喺唔喺 list 裏面？Python 有個 keyword，但對 list 佢會 scan。邊個 keyword？"
        ),
        code = L(
          [[
def has(names, q):
    return q ___ names    # list: O(n)   set: O(1)
]],
          [[
def has(names, q):
    return q ___ names    # 리스트: O(n)   set: O(1)
]],
          [[
def has(names, q):
    return q ___ names    # list：O(n)   set：O(1)
]]
        ),
        answer = "in",
        accept = { "in" },
        hint = L(
          "Two letters. The same word the for loop uses. Its cost depends entirely on the type on the right.",
          "두 글자. for 루프가 쓰는 그 단어. 비용은 오른쪽 타입에 전적으로 달려 있다.",
          "兩個字母。for loop 用嘅同一個字。成本完全睇右邊個 type。"
        ),
        ok = L(
          "x in list walks every element; x in set hashes once. One keyword, two costs. Know which one you are paying.",
          "x in list는 모든 원소를 걷고, x in set은 해시 한 번. 키워드 하나, 비용 둘. 어느 쪽을 내는지 알아야.",
          "x in list 行晒每個元素；x in set hash 一次。一個 keyword，兩種成本。要知自己交嘅係邊種。"
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
top = prices[0]
for p in prices[1:]:    # ___ comparisons
    if p > top:
        top = p
]],
          [[
top = prices[0]
for p in prices[1:]:    # 비교 ___ 번
    if p > top:
        top = p
]],
          [[
top = prices[0]
for p in prices[1:]:    # ___ 次比較
    if p > top:
        top = p
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
          "n-1 comparisons, which is O(n): you cannot know the max without seeing every value. max() does exactly this.",
          "비교 n-1번, 즉 O(n): 모든 값을 보지 않고는 최대를 알 수 없다. max()가 정확히 이걸 한다.",
          "n-1 次比較，即 O(n)：唔望晒所有值就唔會知最大。max() 做嘅就係呢樣。"
        ),
      },
    },
  },
  {
    id = "py_bigo_log",
    station = "O(LOG N)",
    name = L("The phone book", "전화번호부", "電話簿"),
    title = L("Logarithmic time", "로그 시간", "對數時間"),
    lesson = L(
      "O(log n): each step halves what is left. bisect on a sorted list: 1024 items in 10 steps, a million in 20. Needs sorted input.",
      "O(log n): 단계마다 남은 것이 절반. 정렬된 리스트의 bisect: 1024개를 10단계에, 백만을 20단계에. 정렬된 입력이 필요.",
      "O(log n)：每步將剩低嘅減半。排好序嘅 list 上 bisect：1024 個 10 步，一百萬個 20 步。要排好序嘅輸入。"
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
          "Open the middle, decide left or right, throw half away. The bisect module did it first.",
          "가운데를 펴고, 왼쪽인지 오른쪽인지 정하고, 절반을 버려. bisect 모듈이 먼저 해놨어.",
          "打開中間，決定左定右，掉走一半。bisect module 早就做好。"
        ),
      },
    },
    viz = "python",
    chips = {
      { "mid = (lo + hi) // 2", "cyan" },
      { "1024 -> 10 steps", "gold" },
      { "bisect_left(a, x)", "pink" },
      { "sort first", "green" },
    },
    note = "halve  bisect  log2  sorted",
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
          "Binary search checks the middle of lo..hi. Which operator gives a whole-number midpoint?",
          "이진 탐색은 lo..hi의 가운데를 확인. 정수 중간점을 주는 연산자는?",
          "二元搜尋檢查 lo..hi 嘅中間。邊個運算符畀整數中點？"
        ),
        code = L(
          [[
lo, hi = 0, len(a)
while lo < hi:
    mid = (lo + hi) ___ 2    # floor division
    if a[mid] < x: lo = mid + 1
    else: hi = mid
]],
          [[
lo, hi = 0, len(a)
while lo < hi:
    mid = (lo + hi) ___ 2    # 내림 나눗셈
    if a[mid] < x: lo = mid + 1
    else: hi = mid
]],
          [[
lo, hi = 0, len(a)
while lo < hi:
    mid = (lo + hi) ___ 2    # 向下除
    if a[mid] < x: lo = mid + 1
    else: hi = mid
]]
        ),
        answer = "//",
        accept = { "//" },
        hint = L(
          "Two slashes. A single one makes a float, and a[3.5] raises TypeError.",
          "슬래시 두 개. 하나면 float가 되고 a[3.5]는 TypeError.",
          "兩條斜線。一條會出 float，a[3.5] 就拋 TypeError。"
        ),
        ok = L(
          "(lo + hi) // 2. Python ints never overflow, so the plain form is safe. Each pass throws away half the range.",
          "(lo + hi) // 2. Python int는 오버플로가 없어 단순한 형태가 안전. 통과마다 범위의 절반을 버린다.",
          "(lo + hi) // 2。Python int 唔會 overflow，所以簡單寫法係安全嘅。每一輪掉走一半範圍。"
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
# 1024 -> 512 -> 256 -> 128 -> 64 -> 32 -> 16 -> 8 -> 4 -> 2 -> 1
# ___ halvings: math.log2(1024)
]],
          [[
# 1024 -> 512 -> 256 -> 128 -> 64 -> 32 -> 16 -> 8 -> 4 -> 2 -> 1
# 절반으로 ___ 번: math.log2(1024)
]],
          [[
# 1024 -> 512 -> 256 -> 128 -> 64 -> 32 -> 16 -> 8 -> 4 -> 2 -> 1
# ___ 次減半：math.log2(1024)
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
          "So bisect on n sorted items costs how much, in Big O?",
          "그러면 정렬된 n개의 bisect는 빅오로 얼마?",
          "所以 n 個排好序項目嘅 bisect，Big O 係幾多？"
        ),
        code = L(
          [[
import bisect
i = bisect.bisect_left(a, x)    # ___
]],
          [[
import bisect
i = bisect.bisect_left(a, x)    # ___
]],
          [[
import bisect
i = bisect.bisect_left(a, x)    # ___
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
          "O(log n). heapq lives at the same cost per push and pop. The second-best cost after O(1).",
          "O(log n). heapq도 push와 pop마다 같은 비용. O(1) 다음으로 좋은 비용.",
          "O(log n)。heapq 每次 push 同 pop 都係同樣成本。O(1) 之後第二好嘅成本。"
        ),
      },
      {
        topic = "SORTED",
        q = L(
          "bisect has one precondition. The list must be ___",
          "bisect엔 전제 조건 하나가 있다. 리스트는 ___여야 한다",
          "bisect 有一個前提。list 必須係 ___"
        ),
        code = L(
          [[
# bisect on an unsorted list returns nonsense.
# Precondition: a is ___ ascending.
a.sort()
i = bisect.bisect_left(a, 38)
]],
          [[
# 정렬되지 않은 리스트의 bisect는 엉뚱한 값을 준다.
# 전제 조건: a는 오름차순으로 ___.
a.sort()
i = bisect.bisect_left(a, 38)
]],
          [[
# 未排序 list 上嘅 bisect 回傳亂嘢。
# 前提：a 係升序 ___。
a.sort()
i = bisect.bisect_left(a, 38)
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
    id = "py_bigo_nlogn",
    station = "N LOG N",
    name = L("The sorting hat", "정렬 모자", "分類帽"),
    title = L("Sorting: n log n", "정렬: n log n", "排序：n log n"),
    lesson = L(
      "O(n log n): the cost of a good sort. Merge sort has log n levels, each doing O(n) work. sorted and list.sort are Timsort and live here. Sort once, search many times.",
      "O(n log n): 좋은 정렬의 비용. 병합 정렬은 log n 레벨, 각 레벨이 O(n) 일. sorted와 list.sort는 Timsort이고 여기 산다. 한 번 정렬하고 여러 번 탐색.",
      "O(n log n)：一個好排序嘅成本。merge sort 有 log n 層，每層做 O(n) 工作。sorted 同 list.sort 係 Timsort，住呢度。排一次，搵好多次。"
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
        kind = "cook",
        x = 900,
        facing = -1,
        line = L(
          "sorted() is Timsort: merge sort that notices runs already in order. Still n log n in the worst case.",
          "sorted()는 Timsort: 이미 정렬된 구간을 알아보는 병합 정렬. 최악은 여전히 n log n.",
          "sorted() 係 Timsort：會留意已經有序嘅 run 嘅 merge sort。最差情況仍然 n log n。"
        ),
      },
    },
    viz = "python",
    chips = {
      { "sorted(a)", "cyan" },
      { "log n levels x O(n)", "gold" },
      { "sorted(a, key=len)", "pink" },
      { "search: O(log n)", "green" },
    },
    note = "merge sort  levels x merge  sort once",
    story = L(
      "The sorting hat: a shoebox of receipts. Alex sorts them by splitting the pile in half, again and again, "
        .. "then merging back in order. Bo draws the line between linear and quadratic and labels it n log n.",
      "정렬 모자: 영수증이 든 신발 상자. 알렉스는 더미를 반으로, 또 반으로 나눈 뒤 순서대로 병합해 정렬한다. 보가 선형과 이차 사이에 선을 그리고 n log n이라 적는다.",
      "分類帽：一個裝住收據嘅鞋盒。阿力將疊嘢分兩半，再分，再分，然後按次序合併返。寶廚畫一條喺線性同二次之間嘅線，寫上 n log n。"
    ),
    stages = {
      {
        topic = "SORT",
        q = L(
          "sorted on n receipts: what does it cost, in Big O?",
          "n개 영수증에 sorted: 빅오로 비용은?",
          "對 n 張收據 sorted：Big O 成本係？"
        ),
        code = L(
          [[
ordered = sorted(amounts)    # ___ : Timsort
]],
          [[
ordered = sorted(amounts)    # ___ : Timsort
]],
          [[
ordered = sorted(amounts)    # ___ ：Timsort
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
          "O(n log n). A million items: about 20 million comparisons. Timsort is O(n) on already-sorted input, a bonus.",
          "O(n log n). 백만 개: 약 2천만 번 비교. Timsort는 이미 정렬된 입력에 O(n), 보너스.",
          "O(n log n)。一百萬個：大約二千萬次比較。Timsort 對已經排好嘅輸入係 O(n)，係 bonus。"
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
# level 1: merge 2 halves      -> n items moved
# level 2: merge 4 quarters    -> n items moved
# each level: ___ ; levels: log n ; total: n log n
]],
          [[
# 레벨 1: 절반 2개 병합      -> n개 이동
# 레벨 2: 4분의 1 4개 병합   -> n개 이동
# 레벨마다: ___ ; 레벨 수: log n ; 합계: n log n
]],
          [[
# 第 1 層：合併 2 半      -> 移動 n 個
# 第 2 層：合併 4 份      -> 移動 n 個
# 每層：___ ；層數：log n ；總計：n log n
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
        topic = "KEY",
        q = L(
          "Sort the dish names by length, into a new list. Which built-in?",
          "요리 이름을 길이순으로 새 리스트에. 어떤 내장 함수?",
          "將菜名按長度排入新 list。邊個內建 function？"
        ),
        code = L(
          [[
names = ["noodles", "tea", "toast"]
short_first = ___(names, key=len)    # O(n log n)
]],
          [[
names = ["noodles", "tea", "toast"]
short_first = ___(names, key=len)    # O(n log n)
]],
          [[
names = ["noodles", "tea", "toast"]
short_first = ___(names, key=len)    # O(n log n)
]]
        ),
        answer = "sorted",
        accept = { "sorted" },
        hint = L(
          "A function, past tense, returning a new list. names.sort(key=len) would do it in place.",
          "함수, 과거형, 새 리스트를 반환. names.sort(key=len)이면 제자리.",
          "一個 function，過去式，回傳新 list。names.sort(key=len) 會就地排。"
        ),
        ok = L(
          "sorted(names, key=len). The key is called n times, O(n), then Timsort. Both together: n log n.",
          "sorted(names, key=len). key는 n번 호출, O(n), 그다음 Timsort. 합쳐서 n log n.",
          "sorted(names, key=len)。key call n 次，O(n)，再 Timsort。加埋：n log n。"
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
a.sort()                              # once: n log n
for x in queries:
    i = bisect.bisect_left(a, x)      # each: O(___)
]],
          [[
a.sort()                              # 한 번: n log n
for x in queries:
    i = bisect.bisect_left(a, x)      # 각각: O(___)
]],
          [[
a.sort()                              # 一次：n log n
for x in queries:
    i = bisect.bisect_left(a, x)      # 每次：O(___)
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
    id = "py_bigo_quad",
    station = "O(N^2)",
    name = L("The seating chart", "좌석 배치표", "座位表"),
    title = L("Quadratic time", "이차 시간", "二次時間"),
    lesson = L(
      "O(n^2): a loop inside a loop over the same n. Comparing every pair. 100 items is 4950 pairs; 10,000 is fifty million. A set turns most of these into O(n).",
      "O(n^2): 같은 n을 도는 루프 안의 루프. 모든 쌍 비교. 100개면 4950쌍, 만 개면 5천만. set이 대부분을 O(n)으로 바꾼다.",
      "O(n^2)：同一個 n 嘅 loop 裏面再一個 loop。比較每一對。100 個係 4950 對；一萬個係五千萬。用 set 大部分變返 O(n)。"
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
    viz = "python",
    chips = {
      { "for i: for j: ...", "cyan" },
      { "n(n-1)/2 pairs", "gold" },
      { "seen = set()", "pink" },
      { "O(n*m)", "green" },
    },
    note = "nested  pairs  set fix  n*m",
    story = L(
      "The seating chart for a banquet. Siu Ming's script checks every guest against every other for a duplicate. "
        .. "Bo draws the curve that leaves the board. Nested loops over the same list: the shape to avoid.",
      "연회 좌석 배치표. 시우밍의 스크립트는 중복을 찾으려고 모든 손님을 모든 다른 손님과 비교한다. 보가 보드를 벗어나는 곡선을 그린다. 같은 리스트를 도는 중첩 루프: 피해야 할 모양.",
      "宴會嘅座位表。小明嘅 script 每個客同每個其他客比較搵重複。寶廚畫出咗白板嘅曲線。同一個 list 嘅嵌套 loop：要避開嘅形狀。"
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
for i in range(len(guests)):
    for j in range(len(guests)):    # ___ : n x n checks
        if i != j and guests[i] == guests[j]:
            dup = True
]],
          [[
for i in range(len(guests)):
    for j in range(len(guests)):    # ___ : n x n번 확인
        if i != j and guests[i] == guests[j]:
            dup = True
]],
          [[
for i in range(len(guests)):
    for j in range(len(guests)):    # ___ ：n x n 次檢查
        if i != j and guests[i] == guests[j]:
            dup = True
]]
        ),
        answer = "O(n^2)",
        accept = { "O(n^2)", "n^2", "quadratic", "O(n²)", "n²", "O(n**2)" },
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
# n = 100
# pairs = 100 * 99 // 2 = ___
# still O(n^2): the /2 is a constant
]],
          [[
# n = 100
# 쌍 = 100 * 99 // 2 = ___
# 여전히 O(n^2): /2는 상수
]],
          [[
# n = 100
# 對數 = 100 * 99 // 2 = ___
# 仍然 O(n^2)：/2 係常數
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
          "The O(n) fix: remember each name as you go. Which built-in is the set?",
          "O(n) 해법: 지나가며 이름을 기억. 집합인 내장 함수는?",
          "O(n) 嘅解法：一路行一路記住每個名。邊個內建係 set？"
        ),
        code = L(
          [[
seen = ___()
for g in guests:            # one pass: O(n)
    if g in seen:
        dup = True
    seen.add(g)
]],
          [[
seen = ___()
for g in guests:            # 한 번 통과: O(n)
    if g in seen:
        dup = True
    seen.add(g)
]],
          [[
seen = ___()
for g in guests:            # 一次過：O(n)
    if g in seen:
        dup = True
    seen.add(g)
]]
        ),
        answer = "set",
        accept = { "set" },
        hint = L(
          "Three letters; the loop calls .add on it. len(set(guests)) < len(guests) is the one-liner.",
          "세 글자. 루프가 .add를 호출한다. len(set(guests)) < len(guests)가 한 줄 버전.",
          "三個字母；loop 對佢 call .add。len(set(guests)) < len(guests) 係一行版。"
        ),
        ok = L(
          "set: one O(1) check per guest, O(n) total. Fifty million checks become ten thousand.",
          "set: 손님당 O(1) 확인 한 번, 합계 O(n). 5천만 번이 만 번이 된다.",
          "set：每個客一次 O(1) 檢查，總共 O(n)。五千萬次變一萬次。"
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
for t in tables:        # m
    for g in guests:    # n
        fits(t, g)      # ___ calls
]],
          [[
for t in tables:        # m
    for g in guests:    # n
        fits(t, g)      # ___ 번 호출
]],
          [[
for t in tables:        # m
    for g in guests:    # n
        fits(t, g)      # ___ 次 call
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
    id = "py_bigo_exp",
    station = "O(2^N)",
    name = L("The combinatorics counter", "조합 카운터", "組合櫃位"),
    title = L("Exponential time", "지수 시간", "指數時間"),
    lesson = L(
      "O(2^n): the work doubles when n grows by one. Naive fib makes two calls per call. @functools.cache brings it to O(n). Listing every subset of n items is 2^n and cannot be helped.",
      "O(2^n): n이 1 늘 때 일이 두 배. 순진한 fib는 호출마다 호출 둘. @functools.cache가 O(n)으로 만든다. n개의 모든 부분집합 나열은 2^n이고 피할 수 없다.",
      "O(2^n)：n 加一，工作翻倍。天真嘅 fib 每個 call 再 call 兩次。@functools.cache 令佢變 O(n)。列出 n 個項目嘅所有子集係 2^n，冇得救。"
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
    viz = "python",
    chips = {
      { "fib(n-1) + fib(n-2)", "cyan" },
      { "@functools.cache", "gold" },
      { "2 ** n subsets", "pink" },
      { "O(2^n) -> O(n)", "green" },
    },
    note = "two calls  doubling  cache  subsets",
    story = L(
      "The combinatorics counter at the noodle stall: pick any toppings. Bo counts the combinations and the number "
        .. "doubles with every topping. He draws the curve that goes vertical almost at once.",
      "국수 노점의 조합 카운터: 토핑을 아무렇게나 고른다. 보가 조합을 세는데 토핑 하나마다 수가 두 배. 거의 곧바로 수직이 되는 곡선을 그린다.",
      "麵檔嘅組合櫃位：任揀配料。寶廚數組合，每加一種配料數目翻倍。佢畫幾乎即刻變垂直嗰條曲線。"
    ),
    stages = {
      {
        topic = "NAIVE",
        q = L(
          "fib calls itself twice per call, no cache. Cost, in Big O?",
          "fib가 cache 없이 호출마다 자신을 두 번 호출. 빅오로 비용은?",
          "fib 冇 cache，每個 call 再 call 自己兩次。Big O 成本？"
        ),
        code = L(
          [[
def fib(n):
    if n < 2:
        return n
    return fib(n - 1) + fib(n - 2)    # ___ : two calls each
]],
          [[
def fib(n):
    if n < 2:
        return n
    return fib(n - 1) + fib(n - 2)    # ___ : 각각 호출 둘
]],
          [[
def fib(n):
    if n < 2:
        return n
    return fib(n - 1) + fib(n - 2)    # ___ ：每個兩次 call
]]
        ),
        answer = "O(2^n)",
        accept = { "O(2^n)", "exponential", "O(2**n)" },
        hint = L(
          "Exponential: two to the power of n. Each level of the call tree is twice as wide as the one above.",
          "지수: 2의 n제곱. 호출 트리의 각 레벨이 위 레벨의 두 배 폭.",
          "指數：2 嘅 n 次方。call tree 每一層都係上一層嘅兩倍闊。"
        ),
        ok = L(
          "O(2^n). fib(35) already takes seconds in Python; fib(50) would take days. The worst curve on the board.",
          "O(2^n). Python에서 fib(35)는 이미 몇 초, fib(50)은 며칠. 보드에서 가장 나쁜 곡선.",
          "O(2^n)。Python fib(35) 已經要幾秒；fib(50) 要幾日。白板上最差嘅曲線。"
        ),
      },
      {
        topic = "MEMOCOST",
        q = L(
          "With a cache every fib(k) is computed once. The cost drops to O(___)",
          "cache가 있으면 모든 fib(k)는 한 번만 계산. 비용은 O(___)로",
          "有 cache 每個 fib(k) 只計一次。成本跌到 O(___)"
        ),
        code = L(
          [[
# without cache: 2^n calls
# with cache: fib(0) .. fib(n), each once -> O(___)
]],
          [[
# cache 없이: 2^n번 호출
# cache 있으면: fib(0) .. fib(n), 각 한 번 -> O(___)
]],
          [[
# 冇 cache：2^n 次 call
# 有 cache：fib(0) .. fib(n)，每個一次 -> O(___)
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
          "One decorator remembers every result by argument. Which one, from functools?",
          "데코레이터 하나가 인자별로 모든 결과를 기억. functools의 어떤 것?",
          "一個 decorator 按參數記住所有結果。functools 嘅邊個？"
        ),
        code = L(
          [[
@functools.___
def fib(n):
    if n < 2:
        return n
    return fib(n - 1) + fib(n - 2)    # now O(n)
]],
          [[
@functools.___
def fib(n):
    if n < 2:
        return n
    return fib(n - 1) + fib(n - 2)    # 이제 O(n)
]],
          [[
@functools.___
def fib(n):
    if n < 2:
        return n
    return fib(n - 1) + fib(n - 2)    # 而家 O(n)
]]
        ),
        answer = "cache",
        accept = { "cache", "lru_cache", "lru_cache()" },
        hint = L(
          "Five letters, a stash of things already fetched. Its older sibling takes a maxsize.",
          "다섯 글자, 이미 가져온 것들의 저장소. 나이 많은 형제는 maxsize를 받는다.",
          "五個字母，已經攞過嘅嘢嘅儲藏。佢個大哥要收 maxsize。"
        ),
        ok = L(
          "@functools.cache: a dict keyed by the arguments, O(1) per hit. Go spells this a comma-ok test; Rust memo.get(&n).",
          "@functools.cache: 인자로 키를 잡은 dict, 히트마다 O(1). Go는 comma-ok 검사, Rust는 memo.get(&n).",
          "@functools.cache：以參數做 key 嘅 dict，每次 hit O(1)。Go 寫 comma-ok 檢查；Rust 寫 memo.get(&n)。"
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
# 1 topping: 2 combos   2 toppings: 4   3 toppings: 8
# n toppings: ___ combos; 2 ** n computes it
]],
          [[
# 토핑 1개: 조합 2   2개: 4   3개: 8
# 토핑 n개: 조합 ___ 개; 2 ** n 으로 계산
]],
          [[
# 1 種配料：2 種組合   2 種：4   3 種：8
# n 種配料：___ 種組合；2 ** n 計出嚟
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
          "2^n subsets. itertools.combinations lists them; when the output itself is exponential no algorithm can be faster.",
          "부분집합 2^n개. itertools.combinations가 나열한다. 출력 자체가 지수적이면 어떤 알고리즘도 더 빠를 수 없다.",
          "2^n 個子集。itertools.combinations 列出佢們；輸出本身係指數嗰陣冇算法可以更快。"
        ),
      },
    },
  },
  {
    id = "py_bigo_space",
    station = "SPACE",
    name = L("The storeroom", "창고", "貨倉"),
    title = L("Space complexity", "공간 복잡도", "空間複雜度"),
    lesson = L(
      "Space counts extra memory, not the input. list.sort in place: O(1). sorted() makes a copy: O(n). Recursion uses stack: quicksort O(log n) on average. Memos trade space for time.",
      "공간은 입력이 아닌 추가 메모리를 센다. 제자리 list.sort: O(1). sorted()는 복사: O(n). 재귀는 스택을 쓴다: 퀵소트는 평균 O(log n). memo는 공간으로 시간을 산다.",
      "空間計額外記憶體，唔計輸入。就地 list.sort：O(1)。sorted() 會 copy：O(n)。遞歸用 stack：quicksort 平均 O(log n)。memo 用空間換時間。"
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
          "Time is one axis. Memory is the other. Every cache you loved tonight paid rent here.",
          "시간이 한 축, 메모리가 다른 축. 오늘 밤 네가 좋아한 모든 cache는 여기서 집세를 냈어.",
          "時間係一條軸。記憶體係另一條。今晚你鍾意嘅每個 cache 都喺呢度交租。"
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
    viz = "python",
    chips = {
      { "a.sort()  # in place", "cyan" },
      { "b = sorted(a)  # copy", "gold" },
      { "stack depth", "pink" },
      { "space for time", "green" },
    },
    note = "extra memory  in place  copy  stack",
    story = L(
      "The storeroom: every algorithm needs somewhere to put things. Sorting the trays where they stand costs "
        .. "no shelf; copying them onto a new rack costs a rack the size of the input. Mei adds the second axis to the last board of the night.",
      "창고: 모든 알고리즘은 물건을 둘 곳이 필요하다. 트레이를 선 자리에서 정렬하면 선반이 필요 없고, 새 선반에 복사하면 입력 크기의 선반이 든다. 메이가 오늘 밤 마지막 보드에 둘째 축을 더한다.",
      "貨倉：每個算法都要有地方放嘢。盤喺原位排唔使多一個架；copy 上新架就要一個同輸入一樣大嘅架。阿美喺今晚最後一塊白板加第二條軸。"
    ),
    stages = {
      {
        topic = "INPLACE",
        q = L(
          "a.sort() sorts the list where it is. Extra memory, in Big O: O(___)",
          "a.sort()는 리스트를 제자리에서 정렬. 추가 메모리는 빅오로 O(___)",
          "a.sort() 就地排 list。額外記憶體，Big O：O(___)"
        ),
        code = L(
          [[
a.sort()    # in place: O(___) extra space (Timsort's small buffer aside)
]],
          [[
a.sort()    # 제자리: 추가 공간 O(___) (Timsort의 작은 버퍼는 제외)
]],
          [[
a.sort()    # 就地：額外空間 O(___)（Timsort 嘅小 buffer 不計）
]]
        ),
        answer = "1",
        accept = { "1", "constant" },
        hint = L(
          "A handful of index variables, however long the list. Constant.",
          "리스트가 얼마나 길든 인덱스 변수 몇 개. 상수.",
          "唔理 list 幾長都只係幾個 index 變數。常數。"
        ),
        ok = L(
          "O(1) extra, near enough: the list is rearranged where it lives and sort() returns None to say so.",
          "추가 O(1), 거의: 리스트는 있는 자리에서 재배열되고 sort()는 그걸 말하려고 None을 반환.",
          "額外 O(1)，差唔多：個 list 就喺原位重排，sort() 回傳 None 就係咁講。"
        ),
      },
      {
        topic = "COPY",
        q = L(
          "A sorted copy, leaving the original untouched, needs a second list. Extra space: O(___)",
          "원본을 건드리지 않은 정렬 복사본에는 둘째 리스트가 필요. 추가 공간: O(___)",
          "唔掂原本嘅排好序副本要第二個 list。額外空間：O(___)"
        ),
        code = L(
          [[
b = sorted(a)    # a second list of n items: O(___)
]],
          [[
b = sorted(a)    # n개 항목의 둘째 리스트: O(___)
]],
          [[
b = sorted(a)    # 第二個 n 個項目嘅 list：O(___)
]]
        ),
        answer = "n",
        accept = { "n", "linear" },
        hint = L(
          "As many new slots as there are old ones. Linear, without the O( ).",
          "옛 것과 같은 수의 새 슬롯. 선형, O( ) 없이.",
          "新 slot 同舊嘅一樣多。線性，冇 O( )。"
        ),
        ok = L(
          "O(n). sorted() always copies; a.sort() never does. Choose by whether you still need the original order.",
          "O(n). sorted()는 항상 복사, a.sort()는 절대 안 한다. 원래 순서가 필요한지로 고른다.",
          "O(n)。sorted() 永遠 copy；a.sort() 永遠唔 copy。睇你仲要唔要原本嘅次序嚟揀。"
        ),
      },
      {
        topic = "MAKE",
        q = L(
          "Make that copy without sorting: a new list with the same items. Which built-in, called on a?",
          "정렬 없이 그 복사본 만들기: 같은 항목의 새 리스트. a에 호출하는 내장 함수는?",
          "唔排序整個副本：一個相同項目嘅新 list。對 a call 邊個內建？"
        ),
        code = L(
          [[
b = ___(a)    # allocate n slots and copy: O(n) time, O(n) space
]],
          [[
b = ___(a)    # n개 슬롯 할당 후 복사: O(n) 시간, O(n) 공간
]],
          [[
b = ___(a)    # 分配 n 個 slot 再 copy：O(n) 時間，O(n) 空間
]]
        ),
        answer = "list",
        accept = { "list" },
        hint = L(
          "The type itself, used as a constructor. a[:] and a.copy() are the other two spellings.",
          "타입 자체를 생성자로. a[:]와 a.copy()가 다른 두 표기.",
          "個 type 本身，當 constructor 用。a[:] 同 a.copy() 係另外兩個寫法。"
        ),
        ok = L(
          "list(a), a[:] or a.copy(): all shallow, all O(n). Allocation is where space complexity is paid.",
          "list(a), a[:], a.copy(): 모두 얕은 복사, 모두 O(n). 할당이 공간 복잡도를 내는 곳.",
          "list(a)、a[:] 或 a.copy()：全部淺 copy，全部 O(n)。分配就係交空間複雜度嘅地方。"
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
# quicksort halves the range each level on average
# depth ~ log2(n) frames on the stack: O(___) space
# (naive fib without cache: depth n, RecursionError near 1000)
]],
          [[
# 퀵소트는 평균적으로 레벨마다 범위를 절반으로
# 깊이 ~ 스택 프레임 log2(n)개: 공간 O(___)
# (cache 없는 순진한 fib: 깊이 n, 1000 근처에서 RecursionError)
]],
          [[
# quicksort 平均每層將範圍減半
# 深度 ~ stack 上 log2(n) 個 frame：O(___) 空間
# （冇 cache 嘅天真 fib：深度 n，接近 1000 就 RecursionError）
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
          "O(log n) stack frames on average. Every axis on the last board has a name. The Python round takes the O(1) stamp; the night is over.",
          "평균 스택 프레임 O(log n). 마지막 보드의 모든 축에 이름이 있다. Python 라운드가 O(1) 도장을 받고 밤이 끝난다.",
          "平均 O(log n) 個 stack frame。最後一塊白板每條軸都有名。Python 回合攞到 O(1) 印；今晚完。"
        ),
      },
    },
  },
}

return maps
