-- Quest Q7 THREADS: the lunch rush at Lucky Mac, 12:00. The delivery app of
-- Q3 is live and two tills, six woks and forty riders all touch the same
-- numbers at once. Mutexes, atomics, shared references, worker pools,
-- channel pipelines, context and the question every Go newcomer asks:
-- where is async / await? Prize: the SYNCED stamp.
-- Same shape as src/data.lua: the blank ___ is NOT written in the code.

local function L(en, ko, yue)
  return { en = en, ko = ko, yue = yue }
end

local maps = {
  {
    id = "mutex",
    station = "MUTEX",
    name = L("Two tills, one counter", "계산대 둘, 카운터 하나", "兩部收銀，一個計數"),
    title = L(
      "sync.Mutex: one goroutine at a time",
      "sync.Mutex: 한 번에 고루틴 하나",
      "sync.Mutex：一次一個 goroutine"
    ),
    lesson = L(
      "A sync.Mutex is usable at its zero value. Lock, then defer Unlock. Never copy a struct that holds one: go vet calls that passing a lock by value. sync.RWMutex lets many readers in at once with RLock, and TryLock returns instead of waiting.",
      "sync.Mutex는 제로 값 그대로 쓸 수 있다. Lock 다음 defer Unlock. 뮤텍스를 가진 구조체는 복사하지 말 것: go vet이 lock을 값으로 넘겼다고 잡는다. sync.RWMutex는 RLock으로 여러 독자를 동시에 들이고, TryLock은 기다리지 않고 돌아온다.",
      "sync.Mutex 零值就用得。Lock 之後 defer Unlock。唔好複製有 mutex 嘅 struct：go vet 會話你 lock by value。sync.RWMutex 用 RLock 可以一次入好多讀者，TryLock 就唔會等，即刻回。"
    ),
    bg = "bg_till",
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
          "Two tills, both adding to sold. At 12:04 the screen says 311, the drawer says 317.",
          "계산대 둘이 같은 sold를 올려. 12시 4분에 화면은 311, 서랍은 317이야.",
          "兩部收銀都加同一個 sold。12:04 個 mon 話 311，櫃桶話 317。"
        ),
      },
      {
        kind = "hero",
        x = 900,
        facing = -1,
        line = L(
          "sold++ is three machine steps. Two goroutines can land between them. Put a lock around it.",
          "sold++ 는 기계어로 세 단계야. 고루틴 둘이 그 사이에 낄 수 있어. 자물쇠를 채우자.",
          "sold++ 拆開係三步機器指令。兩個 goroutine 可以插喺中間。加把鎖。"
        ),
      },
    },
    viz = "chips",
    chips = {
      { "mu.Lock()", "cyan" },
      { "defer mu.Unlock()", "gold" },
      { "sync.RWMutex", "pink" },
      { "vet: lock by value", "green" },
    },
    note = "Lock  defer Unlock  RLock  TryLock  go vet",
    story = L(
      "12:00. Both tills are open, the queue is out to Percival Street, and the counter on the wall "
        .. "is wrong by six. Nobody stole anything: sold++ is a read, an add and a write, and two "
        .. "goroutines read the same number before either wrote it back.",
      "12:00. 계산대 둘 다 열렸고 줄은 퍼시벌 스트리트까지 늘어섰는데 벽의 카운터가 여섯 개 어긋난다. "
        .. "훔친 사람은 없다: sold++ 는 읽기, 더하기, 쓰기이고, 고루틴 둘이 서로 쓰기 전에 같은 수를 읽었을 뿐이다.",
      "十二點。兩部收銀都開，條龍排到去波斯富街，牆上個計數少咗六。冇人偷嘢："
        .. "sold++ 係讀、加、寫三步，兩個 goroutine 喺對方寫返之前讀咗同一個數。"
    ),
    stages = {
      {
        topic = "ZERO",
        q = L(
          "The lock needs no constructor: its zero value is ready. Which type?",
          "이 자물쇠는 생성자가 필요 없다. 제로 값이 곧 준비된 상태. 어떤 타입?",
          "呢把鎖唔使 constructor，零值就用得。邊個 type？"
        ),
        code = L(
          [[
var mu ___
mu.Lock()
sold++
mu.Unlock()
]],
          [[
var mu ___
mu.Lock()
sold++
mu.Unlock()
]],
          [[
var mu ___
mu.Lock()
sold++
mu.Unlock()
]]
        ),
        accept = { "sync.Mutex", "Mutex" },
        answer = "sync.Mutex",
        hint = L(
          "The package that holds WaitGroup and Once, then the six-letter word for a lock.",
          "WaitGroup과 Once가 들어 있는 패키지, 그리고 자물쇠를 뜻하는 여섯 글자.",
          "有 WaitGroup 同 Once 嗰個 package，加上代表鎖嗰六個字母。"
        ),
        ok = L(
          "var mu sync.Mutex is a working lock. No New, no init: the zero value is unlocked and ready.",
          "var mu sync.Mutex 만으로 동작한다. New도 init도 없다. 제로 값이 곧 잠기지 않은 자물쇠.",
          "var mu sync.Mutex 就已經用得。唔使 New，唔使 init：零值就係一把冇上鎖嘅鎖。"
        ),
      },
      {
        topic = "DEFER",
        q = L(
          "Release the lock however the function leaves, error or not. Which keyword?",
          "에러든 아니든 함수가 어떻게 빠져나가도 자물쇠를 푼다. 키워드는?",
          "唔理係咪出錯，function 一走就要放鎖。邊個 keyword？"
        ),
        code = L(
          [[
func (c *Counter) Add(n int) {
    c.mu.Lock()
    ___ c.mu.Unlock()
    c.n += n
}
]],
          [[
func (c *Counter) Add(n int) {
    c.mu.Lock()
    ___ c.mu.Unlock()
    c.n += n
}
]],
          [[
func (c *Counter) Add(n int) {
    c.mu.Lock()
    ___ c.mu.Unlock()
    c.n += n
}
]]
        ),
        accept = { "defer" },
        answer = "defer",
        hint = L(
          "The same word the till used to shut the drawer. It fires on the way out.",
          "계산대가 서랍을 닫을 때 쓰던 그 단어. 나가는 길에 실행된다.",
          "同收銀閂櫃桶嗰個字一樣。行出去嗰陣先執行。"
        ),
        ok = L(
          "Lock then defer Unlock, on the next line, always. A lock released only on the happy path is a deadlock waiting for the first error.",
          "Lock 다음 줄에 언제나 defer Unlock. 정상 경로에서만 푸는 자물쇠는 첫 에러를 기다리는 데드락이다.",
          "Lock 之後下一行就 defer Unlock，永遠咁做。只喺順利path先解鎖，就係等第一個 error 嚟嘅 deadlock。"
        ),
      },
      {
        topic = "VET",
        q = L(
          "go vet says: passes lock by value. Fix the receiver.",
          "go vet: passes lock by value. 리시버를 고치기.",
          "go vet 話：passes lock by value。改個 receiver。"
        ),
        code = L(
          [[
func (c ___) Add(n int) {
    c.mu.Lock()
    defer c.mu.Unlock()
    c.n += n
}
]],
          [[
func (c ___) Add(n int) {
    c.mu.Lock()
    defer c.mu.Unlock()
    c.n += n
}
]],
          [[
func (c ___) Add(n int) {
    c.mu.Lock()
    defer c.mu.Unlock()
    c.n += n
}
]]
        ),
        accept = { "*Counter", "*counter" },
        answer = "*Counter",
        hint = L(
          "A value receiver copies the struct, mutex and all, and locks the copy. Point at the original.",
          "값 리시버는 뮤텍스까지 통째로 복사해 사본을 잠근다. 원본을 가리켜라.",
          "value receiver 會連 mutex 一齊複製，然後鎖住個複本。要指住原本嗰個。"
        ),
        ok = L(
          "A copied mutex protects nothing. Anything holding a sync type gets pointer receivers, and never travels by value.",
          "복사된 뮤텍스는 아무것도 지키지 못한다. sync 타입을 가진 것은 포인터 리시버를 쓰고 값으로 다니지 않는다.",
          "複製咗嘅 mutex 咩都守唔到。有 sync type 嘅嘢一律用 pointer receiver，唔好用 value 傳。"
        ),
      },
      {
        topic = "RWMUTEX",
        q = L(
          "The menu is read by two hundred goroutines and written once an hour. Which lock?",
          "메뉴는 고루틴 200개가 읽고 한 시간에 한 번 쓴다. 어떤 자물쇠?",
          "個餐牌俾兩百個 goroutine 讀，一個鐘先寫一次。用邊種鎖？"
        ),
        code = L(
          [[
var mu sync.___
mu.RLock()
price := menu["set"]
mu.RUnlock()
]],
          [[
var mu sync.___
mu.RLock()
price := menu["set"]
mu.RUnlock()
]],
          [[
var mu sync.___
mu.RLock()
price := menu["set"]
mu.RUnlock()
]]
        ),
        accept = { "RWMutex" },
        answer = "RWMutex",
        hint = L(
          "Read and write, then the word for lock. Readers share it; a writer gets it alone.",
          "읽기와 쓰기, 그다음 자물쇠. 독자는 나눠 갖고 필자는 혼자 갖는다.",
          "讀同寫，再加個鎖字。讀者可以共用，寫者就獨佔。"
        ),
        ok = L(
          "sync.RWMutex: any number of RLock holders, or exactly one Lock holder. Worth it when reads dominate.",
          "sync.RWMutex: RLock은 몇 개든, Lock은 정확히 하나. 읽기가 압도적일 때 값어치를 한다.",
          "sync.RWMutex：RLock 可以有好多個，Lock 就淨係一個。讀多過寫嗰陣先抵用。"
        ),
      },
      {
        topic = "RLOCK",
        q = L(
          "The 11:00 price change holds the write side. Which call does a reader make?",
          "11시 가격 변경은 쓰기 쪽을 잡는다. 독자는 어떤 호출을 하나?",
          "十一點改價攞住寫嗰邊。讀者呢邊點 call？"
        ),
        code = L(
          [[
mu.Lock()
menu["set"] = 42
mu.Unlock()

mu.___()
]],
          [[
mu.Lock()
menu["set"] = 42
mu.Unlock()

mu.___()
]],
          [[
mu.Lock()
menu["set"] = 42
mu.Unlock()

mu.___()
]]
        ),
        accept = { "RLock" },
        answer = "RLock",
        hint = L(
          "One letter in front of Lock. Its partner is RUnlock.",
          "Lock 앞에 글자 하나. 짝은 RUnlock.",
          "喺 Lock 前面加一個字母。佢嘅拍檔係 RUnlock。"
        ),
        ok = L(
          "RLock blocks only while a writer holds the lock. Readers never block each other.",
          "RLock은 필자가 자물쇠를 쥔 동안에만 막힌다. 독자끼리는 서로 막지 않는다.",
          "RLock 淨係喺有人寫嗰陣先會等。讀者之間唔會互相阻。"
        ),
      },
      {
        topic = "TRYLOCK",
        q = L(
          "Refill the ice only if nobody is at the machine. Which method returns false instead of waiting?",
          "아무도 기계 앞에 없을 때만 얼음을 채운다. 기다리는 대신 false를 돌려주는 메서드는?",
          "冇人用部機先加冰。邊個 method 唔會等，直接回 false？"
        ),
        code = L(
          [[
if mu.___() {
    defer mu.Unlock()
    refillIce()
}
]],
          [[
if mu.___() {
    defer mu.Unlock()
    refillIce()
}
]],
          [[
if mu.___() {
    defer mu.Unlock()
    refillIce()
}
]]
        ),
        accept = { "TryLock" },
        answer = "TryLock",
        hint = L(
          "Three letters in front of Lock, Go 1.18 and up. It attempts, it does not queue.",
          "Lock 앞에 세 글자, Go 1.18부터. 줄 서지 않고 시도만 한다.",
          "喺 Lock 前面加三個字母，Go 1.18 開始有。試一試，唔排隊。"
        ),
        ok = L(
          "TryLock is for work you can skip, not for dodging a design problem. If you reach for it often, the shared state is wrong.",
          "TryLock은 건너뛰어도 되는 일에 쓴다. 설계 문제를 피하는 도구가 아니다. 자주 손이 간다면 공유 상태가 잘못된 것.",
          "TryLock 係俾你跳過得嘅工作用，唔係用嚟閃避設計問題。成日用到佢，即係共享狀態有問題。"
        ),
      },
    },
  },
  {
    id = "atomic",
    station = "ATOMIC",
    name = L("The queue counter", "줄 카운터", "排隊計數器"),
    title = L("Atomics and sync.Once", "원자 연산과 sync.Once", "atomic 同 sync.Once"),
    lesson = L(
      "For one number, an atomic beats a mutex: atomic.Int64 has Add, Load, Store and CompareAndSwap, all lock free. atomic.Pointer[T] swaps a whole value in one step. sync.Once runs setup exactly once; sync.OnceValue caches what it returned.",
      "숫자 하나라면 원자 연산이 뮤텍스보다 낫다. atomic.Int64는 Add, Load, Store, CompareAndSwap을 락 없이 제공한다. atomic.Pointer[T]는 값 전체를 한 번에 바꾼다. sync.Once는 초기화를 정확히 한 번 실행하고, sync.OnceValue는 그 결과를 캐시한다.",
      "得一個數嘅話，atomic 好過 mutex：atomic.Int64 有 Add、Load、Store、CompareAndSwap，全部唔使鎖。atomic.Pointer[T] 一步換成個值。sync.Once 令初始化淨係行一次，sync.OnceValue 仲會 cache 個結果。"
    ),
    bg = "bg_queue",
    portrait = "portrait_hero",
    speaker = L("Alex", "알렉스", "阿力"),
    ground = 348,
    spawn = 170,
    width = 1600,
    npcs = {
      {
        kind = "hero",
        x = 520,
        facing = 1,
        line = L(
          "A mutex for a single int is a lot of ceremony for one number.",
          "정수 하나에 뮤텍스는 격식이 너무 차려진 셈이지.",
          "得一個 int 都要 mutex，未免太隆重。"
        ),
      },
      {
        kind = "clerk",
        x = 880,
        facing = -1,
        line = L(
          "The door sensor counts every customer. Only one number, thousands of times a minute.",
          "출입 센서가 손님을 센다. 숫자는 하나, 1분에 수천 번.",
          "道門個 sensor 數住每位客。得一個數，一分鐘幾千次。"
        ),
      },
    },
    viz = "chips",
    chips = {
      { "sold.Add(1)", "cyan" },
      { "sold.Load()", "gold" },
      { "CompareAndSwap", "pink" },
      { "sync.OnceValue", "green" },
    },
    note = "Add  Load  CAS  Pointer  Once  OnceValue",
    story = L(
      "12:20. The door sensor, the till and the delivery app all raise one counter. A mutex would "
        .. "work and would also be the slowest thing in the building. The hardware can add without "
        .. "a lock; the sync/atomic package is how Go asks it to.",
      "12:20. 출입 센서, 계산대, 배달 앱이 모두 하나의 카운터를 올린다. 뮤텍스도 되지만 건물에서 "
        .. "가장 느린 것이 된다. 하드웨어는 자물쇠 없이 더할 수 있고, sync/atomic 패키지가 그걸 부탁하는 방법이다.",
      "12:20. 道門 sensor、收銀同外賣 App 都加緊同一個數。用 mutex 都得，但會變成成幢樓最慢嘅嘢。"
        .. "硬件本身就識唔使鎖噉加，sync/atomic 就係 Go 叫佢做嘅方法。"
    ),
    stages = {
      {
        topic = "TYPED",
        q = L(
          "A counter no mutex guards. Which sync/atomic type holds a 64-bit int?",
          "뮤텍스 없이 지키는 카운터. 64비트 정수를 담는 sync/atomic 타입은?",
          "唔使 mutex 守嘅計數器。sync/atomic 邊個 type 裝 64-bit int？"
        ),
        code = L(
          [[
var sold atomic.___
sold.Add(1)
fmt.Println(sold.Load())
]],
          [[
var sold atomic.___
sold.Add(1)
fmt.Println(sold.Load())
]],
          [[
var sold atomic.___
sold.Add(1)
fmt.Println(sold.Load())
]]
        ),
        accept = { "Int64" },
        answer = "Int64",
        hint = L(
          "Since Go 1.19 the type itself is atomic, so no &x is needed. Name and bit width.",
          "Go 1.19부터는 타입 자체가 원자적이라 &x가 필요 없다. 이름과 비트 폭.",
          "Go 1.19 開始個 type 自己就係 atomic，唔使 &x。名加位數。"
        ),
        ok = L(
          "atomic.Int64 keeps its own value, so nobody can read it the unsafe way. The old atomic.AddInt64(&n, 1) still works, but the type is safer.",
          "atomic.Int64는 값을 자기 안에 두어 위험하게 읽을 길이 없다. 옛 atomic.AddInt64(&n, 1)도 되지만 타입 쪽이 안전하다.",
          "atomic.Int64 自己揸住個值，冇人可以用唔安全嘅方法讀。舊嘅 atomic.AddInt64(&n, 1) 都仲用得，但用 type 安全啲。"
        ),
      },
      {
        topic = "READ",
        q = L(
          "Read the counter without a lock and without a race. Which method?",
          "락 없이, 레이스 없이 카운터를 읽는다. 어떤 메서드?",
          "唔使鎖又唔會 race 噉讀個數。邊個 method？"
        ),
        code = L(
          [[
var sold atomic.Int64
sold.Add(1)
n := sold.___()
]],
          [[
var sold atomic.Int64
sold.Add(1)
n := sold.___()
]],
          [[
var sold atomic.Int64
sold.Add(1)
n := sold.___()
]]
        ),
        accept = { "Load" },
        answer = "Load",
        hint = L(
          "Four letters, the opposite of Store.",
          "네 글자, Store의 반대.",
          "四個字母，同 Store 相反。"
        ),
        ok = L(
          "Load and Store are the read and write. Reading the field directly is a data race even for one int.",
          "Load와 Store가 읽기와 쓰기. 필드를 직접 읽으면 정수 하나라도 데이터 레이스다.",
          "Load 同 Store 就係讀同寫。直接讀個 field，就算得一個 int 都係 data race。"
        ),
      },
      {
        topic = "CAS",
        q = L(
          "Take one from stock, but only if nobody moved it since you read it. Which method?",
          "재고를 하나 빼되, 읽은 뒤 아무도 건드리지 않았을 때만. 어떤 메서드?",
          "扣一件貨，但要冇人喺你讀完之後郁過先扣。邊個 method？"
        ),
        code = L(
          [[
for {
    old := stock.Load()
    if stock.___(old, old-1) {
        break
    }
}
]],
          [[
for {
    old := stock.Load()
    if stock.___(old, old-1) {
        break
    }
}
]],
          [[
for {
    old := stock.Load()
    if stock.___(old, old-1) {
        break
    }
}
]]
        ),
        accept = { "CompareAndSwap", "CAS" },
        answer = "CompareAndSwap",
        hint = L(
          "Three words in one: check the old value, then put the new one. Everyone calls it CAS.",
          "세 단어가 하나로: 옛 값을 확인하고 새 값을 넣는다. 다들 CAS라고 부른다.",
          "三個字合埋一個：對舊值，再放新值。人人叫佢做 CAS。"
        ),
        ok = L(
          "CompareAndSwap returns false when someone beat you to it, so the loop reads and tries again. That retry loop is how lock-free code is written.",
          "CompareAndSwap은 남이 먼저 바꿨으면 false를 돌려주고, 루프가 다시 읽어 재시도한다. 이 재시도 루프가 락 프리 코드의 형태다.",
          "CompareAndSwap 見到有人快過你就回 false，個 loop 再讀過再試。呢個重試 loop 就係 lock-free 嘅寫法。"
        ),
      },
      {
        topic = "POINTER",
        q = L(
          "Swap the whole menu in one step while readers are reading. Which atomic type?",
          "독자들이 읽는 동안 메뉴 전체를 한 번에 교체. 어떤 atomic 타입?",
          "讀者讀緊嗰陣一次過換成份餐牌。用邊個 atomic type？"
        ),
        code = L(
          [[
var live atomic.___[Menu]
live.Store(&fresh)
m := live.Load()
]],
          [[
var live atomic.___[Menu]
live.Store(&fresh)
m := live.Load()
]],
          [[
var live atomic.___[Menu]
live.Store(&fresh)
m := live.Load()
]]
        ),
        accept = { "Pointer" },
        answer = "Pointer",
        hint = L(
          "The generic one that holds an address, not a number.",
          "숫자가 아니라 주소를 담는 제네릭 타입.",
          "裝地址而唔係裝數字嗰個 generic type。"
        ),
        ok = L(
          "atomic.Pointer[Menu] gives copy-on-write config: build a new menu, Store it, and every reader after that sees the new one whole.",
          "atomic.Pointer[Menu]는 카피 온 라이트 설정이다. 새 메뉴를 만들어 Store하면 이후 독자는 통째로 새것을 본다.",
          "atomic.Pointer[Menu] 做到 copy-on-write：整份新餐牌，Store 落去，之後嘅讀者見到嘅就係完整嘅新版。"
        ),
      },
      {
        topic = "ONCE",
        q = L(
          "Twenty goroutines want the menu loaded; load it exactly once. Which method of sync.Once?",
          "고루틴 스무 개가 메뉴를 원한다. 정확히 한 번만 읽는다. sync.Once의 어떤 메서드?",
          "二十個 goroutine 都想要份餐牌；淨係載入一次。sync.Once 邊個 method？"
        ),
        code = L(
          [[
var once sync.Once

once.___(func() {
    menu = loadMenu()
})
]],
          [[
var once sync.Once

once.___(func() {
    menu = loadMenu()
})
]],
          [[
var once sync.Once

once.___(func() {
    menu = loadMenu()
})
]]
        ),
        accept = { "Do" },
        answer = "Do",
        hint = L(
          "Two letters. The other nineteen goroutines wait inside it until the first is finished.",
          "두 글자. 나머지 고루틴 열아홉은 첫 번째가 끝날 때까지 그 안에서 기다린다.",
          "兩個字母。另外十九個 goroutine 會喺入面等到第一個做完。"
        ),
        ok = L(
          "once.Do(f) runs f the first time and blocks the rest until it returns, so nobody sees a half-loaded menu.",
          "once.Do(f)는 처음에만 f를 실행하고 나머지는 끝날 때까지 막는다. 반쯤 로드된 메뉴를 볼 사람은 없다.",
          "once.Do(f) 第一次先行 f，其他人要等到佢返嚟，所以冇人會見到載到一半嘅餐牌。"
        ),
      },
      {
        topic = "ONCEVAL",
        q = L(
          "Go 1.21 wraps that pattern and caches the result. Which sync helper?",
          "Go 1.21은 그 패턴을 감싸고 결과를 캐시한다. 어떤 sync 헬퍼?",
          "Go 1.21 包起呢個 pattern 仲 cache 埋個結果。sync 邊個 helper？"
        ),
        code = L(
          [[
var menu = sync.___(loadMenu)

fmt.Println(menu()["set"])
]],
          [[
var menu = sync.___(loadMenu)

fmt.Println(menu()["set"])
]],
          [[
var menu = sync.___(loadMenu)

fmt.Println(menu()["set"])
]]
        ),
        accept = { "OnceValue" },
        answer = "OnceValue",
        hint = L(
          "Once, plus the word for what a function gives back. There is a two-result twin for (T, error).",
          "Once에 함수가 돌려주는 것을 뜻하는 단어를 붙인다. (T, error)용 쌍둥이도 있다.",
          "Once 再加返回嘅嘢嗰個字。仲有個孖生兄弟做 (T, error)。"
        ),
        ok = L(
          "sync.OnceValue(f) returns a function: the first call runs f, every later call returns the cached value. sync.OnceValues does the (T, error) pair.",
          "sync.OnceValue(f)는 함수를 돌려준다. 첫 호출만 f를 실행하고 이후엔 캐시된 값을 준다. (T, error) 쌍은 sync.OnceValues.",
          "sync.OnceValue(f) 回一個 function：第一次 call 先行 f，之後都係回 cache 嘅值。(T, error) 就用 sync.OnceValues。"
        ),
      },
    },
  },
  {
    id = "shared",
    station = "SHARE",
    name = L("The shared tray rack", "공유 트레이 선반", "共用托盤架"),
    title = L(
      "Shared references and data races",
      "공유 참조와 데이터 레이스",
      "共享 reference 同 data race"
    ),
    lesson = L(
      "Two goroutines touching one variable, one of them writing, is a data race: go test -race finds it. Share by sending on a channel instead, or protect the reference. A plain map crashes under concurrent writes; sync.Map is built for it. Closing a channel publishes everything written before the close.",
      "고루틴 둘이 한 변수를 만지고 그중 하나가 쓰면 데이터 레이스다. go test -race가 찾아낸다. 대신 채널로 보내 공유하거나 참조를 보호하라. 평범한 맵은 동시 쓰기에 크래시하고, sync.Map은 그 용도로 만들어졌다. 채널을 닫으면 그 전에 쓴 것이 모두 공개된다.",
      "兩個 goroutine 掂同一個變數，其中一個係寫，就係 data race：go test -race 揀得出。應該用 channel 送出去共享，或者保護好個 reference。普通 map 同時寫會 crash，sync.Map 就係為咗呢樣而整。閂 channel 會將閂之前寫嘅嘢全部公開。"
    ),
    bg = "bg_kitchen",
    portrait = "portrait_friends",
    speaker = L("Mei", "메이", "阿美"),
    ground = 348,
    spawn = 160,
    width = 1600,
    npcs = {
      {
        kind = "mei",
        x = 560,
        facing = 1,
        line = L(
          "In Rust the compiler stops you. In Go nothing stops you, so the race detector is the compiler you run at test time.",
          "Rust에선 컴파일러가 막아. Go에선 아무도 안 막으니, 레이스 디텍터가 테스트 때 돌리는 컴파일러야.",
          "喺 Rust 係 compiler 攔住你。喺 Go 冇人攔你，所以 race detector 就係你測試嗰陣行嘅 compiler。"
        ),
      },
      {
        kind = "cook",
        x = 940,
        facing = -1,
        line = L(
          "Six woks, one tray rack, one map of dish counts. The program died with: concurrent map writes.",
          "웍 여섯, 트레이 선반 하나, 요리 수를 담은 맵 하나. 프로그램이 concurrent map writes로 죽었어.",
          "六隻鑊、一個托盤架、一個記住菜數嘅 map。個程式死咗，寫住 concurrent map writes。"
        ),
      },
    },
    viz = "chips",
    chips = {
      { "go test -race", "cyan" },
      { "sync.Map", "gold" },
      { "out[i] = cook(o)", "pink" },
      { "escapes to heap", "green" },
    },
    note = "communicate  race  sync.Map  index  heap  close",
    story = L(
      "12:35. The kitchen board is a map[string]int the six wok goroutines all write to, and Go "
        .. "kills the process for it on purpose: a torn map is worse than a stopped one. Alex has "
        .. "three ways out, and only one of them is a lock.",
      "12:35. 주방 보드는 웍 고루틴 여섯이 모두 쓰는 map[string]int이고, Go는 일부러 프로세스를 "
        .. "죽인다. 찢어진 맵은 멈춘 프로그램보다 나쁘다. 알렉스에게 길이 셋 있고, 그중 자물쇠는 하나뿐이다.",
      "12:35. 廚房塊板係一個 map[string]int，六個鑊嘅 goroutine 都寫住佢，Go 係特登殺咗個 process："
        .. "爛咗嘅 map 衰過停咗嘅程式。阿力有三條路，得一條係用鎖。"
    ),
    stages = {
      {
        topic = "PROVERB",
        q = L(
          "Finish Go's proverb: do not communicate by sharing memory; share memory by ___.",
          "Go 격언을 완성: 메모리를 공유해 통신하지 말고, ___해서 메모리를 공유하라.",
          "完成 Go 嘅諺語：唔好靠共享記憶體嚟溝通；要靠 ___ 嚟共享記憶體。"
        ),
        code = L(
          [[
// Do not communicate by sharing memory;
// share memory by ___.
orders <- Order{id: 7}
]],
          [[
// 메모리를 공유해서 통신하지 말고,
// ___해서 메모리를 공유하라.
orders <- Order{id: 7}
]],
          [[
// 唔好靠共享記憶體嚟溝通；
// 要靠 ___ 嚟共享記憶體。
orders <- Order{id: 7}
]]
        ),
        accept = { "communicating", "communication" },
        answer = "communicating",
        hint = L(
          "What a channel does. The -ing form of the verb in the first half of the line.",
          "채널이 하는 일. 앞 절 동사의 -ing 형.",
          "channel 做緊嘅嘢。上半句嗰個動詞嘅 -ing 形。"
        ),
        ok = L(
          "Hand the value to one owner over a channel and there is nothing to lock. The order belongs to whoever received it.",
          "채널로 값을 한 주인에게 넘기면 잠글 것이 없다. 주문은 받은 쪽의 것이다.",
          "用 channel 將個值交俾一個擁有者，就冇嘢要鎖。張單屬於收到佢嗰個。"
        ),
      },
      {
        topic = "RACE",
        q = L(
          "The counts drift and nothing crashes. Which flag makes the test print WARNING: DATA RACE?",
          "수치가 어긋나는데 크래시는 없다. 테스트가 WARNING: DATA RACE를 찍게 하는 플래그는?",
          "個數對唔上但又唔 crash。邊個 flag 令個 test 印 WARNING: DATA RACE？"
        ),
        code = L(
          [[
$ go test -___ ./kitchen
WARNING: DATA RACE
Write at 0x00c0000b4010 by goroutine 8
Previous read by goroutine 7
]],
          [[
$ go test -___ ./kitchen
WARNING: DATA RACE
Write at 0x00c0000b4010 by goroutine 8
Previous read by goroutine 7
]],
          [[
$ go test -___ ./kitchen
WARNING: DATA RACE
Write at 0x00c0000b4010 by goroutine 8
Previous read by goroutine 7
]]
        ),
        accept = { "race", "-race" },
        answer = "race",
        hint = L(
          "Four letters, the word in the warning itself. It also works on go run and go build.",
          "네 글자, 경고문에 그대로 있는 단어. go run과 go build에도 붙는다.",
          "四個字母，就係個警告入面嗰個字。go run 同 go build 都用得。"
        ),
        ok = L(
          "The race detector watches real memory accesses, so it only sees races the run actually hits. Run your tests with it in CI.",
          "레이스 디텍터는 실제 메모리 접근을 본다. 실행이 실제로 밟은 레이스만 보인다. CI 테스트에 붙여라.",
          "race detector 睇實際嘅記憶體存取，所以淨係見到今次真係行到嘅 race。CI 跑 test 記得開。"
        ),
      },
      {
        topic = "MAP",
        q = L(
          "concurrent map writes killed the process. Which sync type is a map made for goroutines?",
          "concurrent map writes로 프로세스가 죽었다. 고루틴용으로 만들어진 sync 타입은?",
          "concurrent map writes 殺咗個 process。sync 邊個 type 係為 goroutine 而整嘅 map？"
        ),
        code = L(
          [[
var counts sync.___
counts.Store("wonton", 3)
v, ok := counts.Load("wonton")
]],
          [[
var counts sync.___
counts.Store("wonton", 3)
v, ok := counts.Load("wonton")
]],
          [[
var counts sync.___
counts.Store("wonton", 3)
v, ok := counts.Load("wonton")
]]
        ),
        accept = { "Map" },
        answer = "Map",
        hint = L(
          "The same word as the builtin, capitalised, living in sync.",
          "내장 자료구조와 같은 단어를 대문자로, sync 안에.",
          "同內建嗰個字一樣，大楷，住喺 sync 入面。"
        ),
        ok = L(
          "sync.Map pays off for keys written once and read often. For anything else a plain map behind a Mutex is faster and clearer.",
          "sync.Map은 한 번 쓰고 자주 읽는 키에서 이득이다. 그 외엔 뮤텍스 뒤의 평범한 맵이 더 빠르고 명확하다.",
          "sync.Map 適合寫一次讀好多次嘅 key。其他情況，用 Mutex 包住普通 map 又快又清楚。"
        ),
      },
      {
        topic = "INDEX",
        q = L(
          "Six goroutines write one slice with no lock. Which expression keeps that safe?",
          "고루틴 여섯이 락 없이 한 슬라이스에 쓴다. 어떤 식이 안전하게 만드나?",
          "六個 goroutine 冇鎖噉寫同一個 slice。邊個式令佢安全？"
        ),
        code = L(
          [[
out := make([]Dish, len(orders))
for i := range orders {
    go func() {
        out[___] = cook(orders[i])
    }()
}
]],
          [[
out := make([]Dish, len(orders))
for i := range orders {
    go func() {
        out[___] = cook(orders[i])
    }()
}
]],
          [[
out := make([]Dish, len(orders))
for i := range orders {
    go func() {
        out[___] = cook(orders[i])
    }()
}
]]
        ),
        accept = { "i" },
        answer = "i",
        hint = L(
          "One letter: the loop variable. Each goroutine owns exactly one slot.",
          "글자 하나, 루프 변수. 고루틴마다 칸이 정확히 하나.",
          "一個字母：個 loop 變數。每個 goroutine 淨係揸住一格。"
        ),
        ok = L(
          "Different indexes are different memory, so no lock is needed. Since Go 1.22 each iteration gets its own i, so the closure captures the right one.",
          "인덱스가 다르면 메모리도 다르니 락이 필요 없다. Go 1.22부터 반복마다 i가 따로라 클로저가 올바른 값을 잡는다.",
          "唔同 index 就係唔同記憶體，唔使鎖。Go 1.22 開始每一轉都有自己嘅 i，closure 捉到啱嗰個。"
        ),
      },
      {
        topic = "ESCAPE",
        q = L(
          "-gcflags=-m says o escapes. Where does a shared reference have to live?",
          "-gcflags=-m 가 o escapes 라고 한다. 공유되는 참조는 어디에 있어야 하나?",
          "-gcflags=-m 話 o escapes。共享嘅 reference 一定要住喺邊？"
        ),
        code = L(
          [[
func newOrder() *Order {
    o := Order{id: 7}
    return &o
}
// ./main.go:3:9: moved to ___: o
]],
          [[
func newOrder() *Order {
    o := Order{id: 7}
    return &o
}
// ./main.go:3:9: moved to ___: o
]],
          [[
func newOrder() *Order {
    o := Order{id: 7}
    return &o
}
// ./main.go:3:9: moved to ___: o
]]
        ),
        accept = { "heap" },
        answer = "heap",
        hint = L(
          "Not the stack. The other one, the one the garbage collector sweeps.",
          "스택이 아니라 다른 쪽, 가비지 컬렉터가 쓸어 담는 곳.",
          "唔係 stack，係另一邊，垃圾回收器掃嗰邊。"
        ),
        ok = L(
          "Returning &o is safe in Go: the compiler sees the reference outlive the frame and moves the value to the heap. Sharing across goroutines does the same.",
          "Go에서 &o 반환은 안전하다. 컴파일러가 참조가 프레임보다 오래 산다고 보고 값을 힙으로 옮긴다. 고루틴 간 공유도 마찬가지.",
          "喺 Go 回傳 &o 係安全嘅：compiler 見到個 reference 活得耐過個 frame，就將個值搬去 heap。跨 goroutine 共享都一樣。"
        ),
      },
      {
        topic = "PUBLISH",
        q = L(
          "Make the write visible to the other goroutine. Which builtin call ends the wait?",
          "쓴 값을 다른 고루틴에 보이게 한다. 기다림을 끝내는 내장 호출은?",
          "令另一個 goroutine 見到你寫嘅嘢。邊個內建 call 結束個等待？"
        ),
        code = L(
          [[
ready := make(chan struct{})
go func() {
    menu = loadMenu()
    ___(ready)
}()
<-ready
use(menu)
]],
          [[
ready := make(chan struct{})
go func() {
    menu = loadMenu()
    ___(ready)
}()
<-ready
use(menu)
]],
          [[
ready := make(chan struct{})
go func() {
    menu = loadMenu()
    ___(ready)
}()
<-ready
use(menu)
]]
        ),
        accept = { "close" },
        answer = "close",
        hint = L(
          "Five letters, a builtin that takes a channel. It never blocks and every receiver wakes.",
          "다섯 글자, 채널을 받는 내장 함수. 막히지 않고 모든 수신자가 깨어난다.",
          "五個字母，收 channel 嘅內建 function。唔會 block，所有接收者都會醒。"
        ),
        ok = L(
          "Everything written before the close happens before <-ready returns, so reading menu after it is not a race. That rule is the Go memory model.",
          "close 이전에 쓴 모든 것은 <-ready가 돌아오기 전에 일어난다. 그래서 그 뒤의 menu 읽기는 레이스가 아니다. 이것이 Go 메모리 모델.",
          "喺 close 之前寫嘅嘢，全部發生喺 <-ready 返嚟之前，所以之後讀 menu 唔係 race。呢條規矩就係 Go memory model。"
        ),
      },
    },
  },
  {
    id = "pool",
    station = "POOL",
    name = L("Forty riders, eight bikes", "라이더 마흔, 자전거 여덟", "四十個外賣員，八架單車"),
    title = L(
      "Worker pools and how many to start",
      "워커 풀과 몇 개를 띄울까",
      "worker pool 同開幾多個"
    ),
    lesson = L(
      "A goroutine is not an OS thread: the runtime multiplexes many of them onto GOMAXPROCS threads, so a pool sized by runtime.NumCPU() is the usual answer for CPU work. WaitGroup counts the workers, a buffered channel works as a semaphore, and sync.Pool recycles the buffers they allocate.",
      "고루틴은 OS 스레드가 아니다. 런타임이 여러 고루틴을 GOMAXPROCS개 스레드에 다중화하므로, CPU 작업이면 runtime.NumCPU() 크기의 풀이 보통의 답이다. WaitGroup이 워커를 세고, 버퍼 채널은 세마포어가 되며, sync.Pool은 워커가 할당한 버퍼를 재활용한다.",
      "goroutine 唔係 OS thread：runtime 將好多 goroutine 疊喺 GOMAXPROCS 條 thread 上面，所以做 CPU 工作，pool 開 runtime.NumCPU() 個係慣常答案。WaitGroup 數住啲 worker，有 buffer 嘅 channel 就係 semaphore，sync.Pool 回收佢哋開嘅 buffer。"
    ),
    bg = "bg_street",
    portrait = "portrait_hero",
    speaker = L("Alex", "알렉스", "阿力"),
    ground = 348,
    spawn = 150,
    width = 1600,
    npcs = {
      {
        kind = "hero",
        x = 520,
        facing = 1,
        line = L(
          "My first version started one goroutine per order. Forty thousand orders, forty thousand goroutines.",
          "첫 버전은 주문마다 고루틴 하나였어. 주문 사만 개면 고루틴 사만 개.",
          "我第一版係每張單開一個 goroutine。四萬張單，四萬個 goroutine。"
        ),
      },
      {
        kind = "clerk",
        x = 900,
        facing = -1,
        line = L(
          "It did not fall over. It just made the kitchen printer thrash. Give me a queue and a few workers.",
          "쓰러지진 않았지. 대신 주방 프린터가 요동쳤어. 큐 하나랑 워커 몇 개만 줘.",
          "又冇冧，不過廚房打印機癲晒。俾條隊同幾個 worker 我就得。"
        ),
      },
    },
    viz = "chips",
    chips = {
      { "runtime.NumCPU()", "cyan" },
      { "jobs <-chan Order", "gold" },
      { "defer wg.Done()", "pink" },
      { "sem <- struct{}{}", "green" },
    },
    note = "NumCPU  GOMAXPROCS  wg  <-chan  sem  Pool",
    story = L(
      "12:50. Forty riders, eight bikes, one printer. Goroutines are cheap enough that Alex made "
        .. "one per order and the queue turned to noise. A pool is the fix: a fixed number of "
        .. "workers, all reading the same channel, all finishing before the shift ends.",
      "12:50. 라이더 마흔, 자전거 여덟, 프린터 하나. 고루틴이 싸다 보니 알렉스는 주문마다 하나를 "
        .. "만들었고 큐는 소음이 됐다. 해법은 풀이다. 고정된 수의 워커가 같은 채널을 읽고, 근무가 "
        .. "끝나기 전에 모두 끝낸다.",
      "12:50. 四十個外賣員、八架單車、一部打印機。goroutine 太平，阿力就每張單開一個，條隊變咗噪音。"
        .. "解法係 pool：固定數目嘅 worker，全部讀同一條 channel，收工前全部做完。"
    ),
    stages = {
      {
        topic = "NUMCPU",
        q = L(
          "Size the pool by the machine. Which runtime call reports the cores?",
          "머신에 맞춰 풀 크기를 정한다. 코어 수를 알려주는 runtime 호출은?",
          "跟部機定 pool 大細。邊個 runtime call 講到有幾多核？"
        ),
        code = L(
          [[
n := runtime.___()
for i := 0; i < n; i++ {
    go worker(jobs, done)
}
]],
          [[
n := runtime.___()
for i := 0; i < n; i++ {
    go worker(jobs, done)
}
]],
          [[
n := runtime.___()
for i := 0; i < n; i++ {
    go worker(jobs, done)
}
]]
        ),
        accept = { "NumCPU" },
        answer = "NumCPU",
        hint = L(
          "Num, then the three letters on the chip.",
          "Num 다음에 칩 이름 세 글자.",
          "Num，再加塊晶片嗰三個字母。"
        ),
        ok = L(
          "runtime.NumCPU() is the usual pool size for CPU-bound work. For I/O-bound work the right number is higher and only a benchmark knows it.",
          "CPU 작업이면 runtime.NumCPU()가 보통의 풀 크기. I/O 작업이면 더 커야 하고, 정확한 수는 벤치마크만 안다.",
          "做 CPU 工作，runtime.NumCPU() 就係慣常嘅 pool 大細。做 I/O 就要大啲，實際幾多要 benchmark 先知。"
        ),
      },
      {
        topic = "PROCS",
        q = L(
          "How many goroutines may run Go code at the same instant? Which setting?",
          "같은 순간에 Go 코드를 실행할 수 있는 고루틴 수는? 어떤 설정?",
          "同一刻可以有幾多個 goroutine 行緊 Go code？邊個設定？"
        ),
        code = L(
          [[
fmt.Println(runtime.___(0))
// 8: eight OS threads may run Go code at once
]],
          [[
fmt.Println(runtime.___(0))
// 8: 동시 실행 스레드 수
]],
          [[
fmt.Println(runtime.___(0))
// 8：可以有八條 OS thread 同時行 Go code
]]
        ),
        accept = { "GOMAXPROCS" },
        answer = "GOMAXPROCS",
        hint = L(
          "Shouted in capitals, and also an environment variable. GO, MAX, and short for processors.",
          "대문자로 외치는 이름이자 환경 변수. GO, MAX, 그리고 프로세서의 줄임말.",
          "全大楷嗌出嚟嗰個，同時亦係環境變數。GO、MAX，再加 processor 嘅縮寫。"
        ),
        ok = L(
          "GOMAXPROCS(0) reports without changing it. Thousands of goroutines still exist; only this many are running Go code at any instant.",
          "GOMAXPROCS(0)은 바꾸지 않고 보고만 한다. 고루틴은 수천 개라도 어느 순간 Go 코드를 실행하는 것은 이만큼뿐.",
          "GOMAXPROCS(0) 淨係報告，唔會改。幾千個 goroutine 都仲喺度，不過同一刻行 Go code 嘅得咁多個。"
        ),
      },
      {
        topic = "DONE",
        q = L(
          "Every worker must report in before Wait returns. Which method, deferred?",
          "Wait가 돌아오기 전에 워커마다 보고해야 한다. defer로 부를 메서드는?",
          "Wait 返嚟之前，每個 worker 都要報到。defer 邊個 method？"
        ),
        code = L(
          [[
wg.Add(1)
go func() {
    defer wg.___()
    cook(o)
}()
wg.Wait()
]],
          [[
wg.Add(1)
go func() {
    defer wg.___()
    cook(o)
}()
wg.Wait()
]],
          [[
wg.Add(1)
go func() {
    defer wg.___()
    cook(o)
}()
wg.Wait()
]]
        ),
        accept = { "Done" },
        answer = "Done",
        hint = L(
          "Four letters. It counts the group down; Add counted it up.",
          "네 글자. 그룹을 하나 줄인다. Add가 올린 것을 내린다.",
          "四個字母。將個 group 減一；Add 就係加一。"
        ),
        ok = L(
          "Add before the go statement, Done deferred inside it, Wait after the loop. Add inside the goroutine is the classic race.",
          "go 문 앞에 Add, 안에서 defer Done, 루프 뒤에 Wait. 고루틴 안에서 Add하는 것이 전형적인 레이스.",
          "go 之前 Add，入面 defer Done，loop 之後 Wait。喺 goroutine 入面先 Add 就係經典嘅 race。"
        ),
      },
      {
        topic = "RECV",
        q = L(
          "A worker only reads jobs. Which channel type says so in the signature?",
          "워커는 jobs를 읽기만 한다. 시그니처에서 그것을 말하는 채널 타입은?",
          "worker 淨係讀 jobs。signature 入面用邊種 channel type 講出嚟？"
        ),
        code = L(
          [[
func worker(jobs ___ Order, out chan<- Dish) {
    for o := range jobs {
        out <- cook(o)
    }
}
]],
          [[
func worker(jobs ___ Order, out chan<- Dish) {
    for o := range jobs {
        out <- cook(o)
    }
}
]],
          [[
func worker(jobs ___ Order, out chan<- Dish) {
    for o := range jobs {
        out <- cook(o)
    }
}
]]
        ),
        accept = { "<-chan" },
        answer = "<-chan",
        hint = L(
          "The arrow leans out of the channel this time. Mirror of the chan<- next to it.",
          "이번엔 화살표가 채널 밖으로 나온다. 옆의 chan<- 를 거울에 비춘 모양.",
          "今次個箭頭由 channel 出嚟。同隔籬 chan<- 啱啱相反。"
        ),
        ok = L(
          "A receive-only parameter makes the compiler enforce the direction: a worker that tries to send on jobs will not build.",
          "수신 전용 파라미터는 방향을 컴파일러가 강제하게 한다. jobs에 보내려는 워커는 빌드되지 않는다.",
          "receive-only 參數令 compiler 強制方向：worker 想向 jobs send 就 build 唔到。"
        ),
      },
      {
        topic = "SEM",
        q = L(
          "Only four riders out at a time. Complete the release at the end of the trip.",
          "동시에 라이더 넷까지만. 배달이 끝날 때의 반납을 완성하라.",
          "同一時間淨係四個外賣員出街。填返送完之後嗰個放位。"
        ),
        code = L(
          [[
sem := make(chan struct{}, 4)
sem <- struct{}{}
go func() {
    deliver(o)
    ___
}()
]],
          [[
sem := make(chan struct{}, 4)
sem <- struct{}{}
go func() {
    deliver(o)
    ___
}()
]],
          [[
sem := make(chan struct{}, 4)
sem <- struct{}{}
go func() {
    deliver(o)
    ___
}()
]]
        ),
        accept = { "<-sem" },
        answer = "<-sem",
        hint = L(
          "Take one back out of the buffered channel. Arrow, then the channel's name.",
          "버퍼 채널에서 하나를 도로 꺼낸다. 화살표 다음 채널 이름.",
          "由個有 buffer 嘅 channel 攞返一個出嚟。箭頭再加 channel 個名。"
        ),
        ok = L(
          "A buffered channel of capacity 4 is a counting semaphore: the fifth send blocks until a trip finishes.",
          "용량 4의 버퍼 채널은 카운팅 세마포어다. 다섯 번째 전송은 배달 하나가 끝날 때까지 막힌다.",
          "容量 4 嘅 buffered channel 就係 counting semaphore：第五個 send 要等有人送完先入到。"
        ),
      },
      {
        topic = "REUSE",
        q = L(
          "Every worker allocates a receipt buffer. Which sync.Pool method hands one back?",
          "워커마다 영수증 버퍼를 할당한다. 하나를 내주는 sync.Pool 메서드는?",
          "每個 worker 都開個單據 buffer。sync.Pool 邊個 method 派一個出嚟？"
        ),
        code = L(
          [[
var bufs = sync.Pool{
    New: func() any { return new(bytes.Buffer) },
}
b := bufs.___().(*bytes.Buffer)
defer bufs.Put(b)
]],
          [[
var bufs = sync.Pool{
    New: func() any { return new(bytes.Buffer) },
}
b := bufs.___().(*bytes.Buffer)
defer bufs.Put(b)
]],
          [[
var bufs = sync.Pool{
    New: func() any { return new(bytes.Buffer) },
}
b := bufs.___().(*bytes.Buffer)
defer bufs.Put(b)
]]
        ),
        accept = { "Get" },
        answer = "Get",
        hint = L("Three letters, the partner of Put.", "세 글자, Put의 짝.", "三個字母，Put 嘅拍檔。"),
        ok = L(
          "sync.Pool recycles short-lived allocations across goroutines. It is a garbage-collector optimisation, never a place to keep state.",
          "sync.Pool은 짧게 사는 할당을 고루틴 사이에서 재활용한다. GC 최적화이지 상태를 두는 곳이 아니다.",
          "sync.Pool 喺 goroutine 之間回收短命嘅記憶體。佢係 GC 優化，唔係擺狀態嘅地方。"
        ),
      },
    },
  },
  {
    id = "pipe",
    station = "PIPE",
    name = L("The belt to the counter", "카운터로 가는 벨트", "去櫃檯嗰條輸送帶"),
    title = L(
      "Channel pipelines, closed and nil",
      "채널 파이프라인, 닫힘과 nil",
      "channel pipeline、閂咗同 nil"
    ),
    lesson = L(
      "v, ok := <-ch tells a closed channel from a zero value. Receiving from a closed channel returns the zero value at once; sending on one panics. A nil channel blocks for ever, which is how a select case is switched off. len and cap look inside a buffer, and the sender closes, never the receiver.",
      "v, ok := <-ch 는 닫힌 채널과 제로 값을 구분한다. 닫힌 채널에서 받으면 즉시 제로 값이 오고, 닫힌 채널로 보내면 패닉이다. nil 채널은 영원히 막히며, 그것이 select의 한 갈래를 끄는 방법이다. len과 cap은 버퍼 속을 보고, 닫는 쪽은 언제나 보내는 쪽이다.",
      "v, ok := <-ch 分得出「閂咗」同「零值」。喺閂咗嘅 channel 收，即刻攞到零值；向佢 send 就 panic。nil channel 會永遠 block，就係咁樣熄咗 select 一個 case。len 同 cap 睇得到個 buffer 入面，而閂 channel 永遠係 sender 嘅事。"
    ),
    bg = "bg_set",
    portrait = "portrait_clerk",
    speaker = L("Siu Ming", "시우밍", "小明"),
    ground = 348,
    spawn = 160,
    width = 1600,
    npcs = {
      {
        kind = "clerk",
        x = 560,
        facing = -1,
        line = L(
          "The belt kept handing me empty trays after the kitchen shut. Empty tray, or no more trays?",
          "주방이 닫힌 뒤에도 벨트가 빈 트레이를 계속 줬어. 빈 트레이야, 아니면 더는 없다는 거야?",
          "廚房收咗爐之後條帶仲不停俾空托盤我。係空盤定係冇盤呀？"
        ),
      },
      {
        kind = "hero",
        x = 920,
        facing = -1,
        line = L(
          "That is the second value of a receive. One line tells you which.",
          "그건 수신의 두 번째 값이야. 한 줄이면 알 수 있어.",
          "嗰個係接收嘅第二個值。一行就知邊樣。"
        ),
      },
    },
    viz = "chips",
    chips = {
      { "v, ok := <-ch", "cyan" },
      { "close(out)", "gold" },
      { "cap(ch) == 8", "pink" },
      { "ch = nil", "green" },
    },
    note = "ok  zero  panic  nil  cap  close",
    story = L(
      "13:05. The kitchen stopped sending but the counter kept receiving, and every receive came "
        .. "back instantly with an empty Order. A closed channel is not an error: it is a promise "
        .. "that nothing more is coming, and the second value of the receive is where it says so.",
      "13:05. 주방은 보내기를 멈췄는데 카운터는 계속 받았고, 받을 때마다 빈 Order가 즉시 돌아왔다. "
        .. "닫힌 채널은 에러가 아니다. 더 올 것이 없다는 약속이며, 수신의 두 번째 값이 그것을 말한다.",
      "13:05. 廚房停咗送，櫃檯仲收緊，而每次接收都即刻攞到一張空 Order。閂咗嘅 channel 唔係 error："
        .. "係一個「冇嘢再嚟」嘅承諾，而接收嘅第二個值就係講呢件事。"
    ),
    stages = {
      {
        topic = "COMMAOK",
        q = L(
          "Tell an empty order from a shut belt. Name the second variable of the receive.",
          "빈 주문과 멈춘 벨트를 구분한다. 수신의 두 번째 변수 이름은?",
          "分開「空單」同「條帶停咗」。接收嘅第二個變數叫咩？"
        ),
        code = L(
          [[
v, ___ := <-orders
if !___ {
    return
}
]],
          [[
v, ___ := <-orders
if !___ {
    return
}
]],
          [[
v, ___ := <-orders
if !___ {
    return
}
]]
        ),
        accept = { "ok" },
        answer = "ok",
        hint = L(
          "Two letters, the same name a map lookup and a type assertion use.",
          "두 글자. 맵 조회와 타입 단언이 쓰는 그 이름.",
          "兩個字母，同 map 查找、type assertion 用嘅名一樣。"
        ),
        ok = L(
          "ok is false only when the channel is closed and drained. It says nothing about the value: that one is always the zero value.",
          "ok가 false인 것은 채널이 닫히고 비었을 때뿐이다. 값에 대해선 말하지 않는다. 그 값은 언제나 제로 값이다.",
          "ok 係 false 淨係代表 channel 閂咗又抽乾咗。同個值冇關：嗰個一定係零值。"
        ),
      },
      {
        topic = "DRAINED",
        q = L(
          "The belt is closed and empty. What comes out of the next receive?",
          "벨트가 닫히고 비었다. 다음 수신에서 나오는 것은?",
          "條帶閂咗又空咗。下一次接收攞到咩？"
        ),
        code = L(
          [[
close(orders)
v, ok := <-orders
// ok is false and v is the ___ value of Order
]],
          [[
close(orders)
v, ok := <-orders
// ok는 false, v는 Order의 ___ 값
]],
          [[
close(orders)
v, ok := <-orders
// ok 係 false，v 係 Order 嘅 ___ 值
]]
        ),
        accept = { "zero" },
        answer = "zero",
        hint = L(
          "The same word as in 'the ___ value of a struct is all fields blank'.",
          "'구조체의 ___ 값은 모든 필드가 빈 상태'에서의 그 단어.",
          "同「struct 嘅 ___ 值即係所有 field 都係空」嗰個字一樣。"
        ),
        ok = L(
          "A closed channel never blocks again, so a for-range over it ends and a bare receive returns instantly, for ever.",
          "닫힌 채널은 다시는 막히지 않는다. for-range는 끝나고, 그냥 받으면 영원히 즉시 돌아온다.",
          "閂咗嘅 channel 唔會再 block，所以 for-range 會完，直接接收就永遠即刻返嚟。"
        ),
      },
      {
        topic = "SEND",
        q = L(
          "The kitchen sends one more order after closing. What happens?",
          "주방이 닫은 뒤 주문을 하나 더 보낸다. 무슨 일이 일어나나?",
          "廚房閂咗之後再送多張單。會點？"
        ),
        code = L(
          [[
close(orders)
orders <- Order{id: 8}
// fatal: send on closed channel, the program ___
]],
          [[
close(orders)
orders <- Order{id: 8}
// fatal: send on closed channel, 프로그램이 ___
]],
          [[
close(orders)
orders <- Order{id: 8}
// fatal: send on closed channel，個程式 ___
]]
        ),
        accept = { "panics", "panic" },
        answer = "panics",
        hint = L(
          "The crash that pairs with recover. Six letters here, in the third person.",
          "recover와 짝을 이루는 그 크래시. 3인칭 형태.",
          "同 recover 成對嗰個 crash。呢度用第三人稱。"
        ),
        ok = L(
          "That is why the sender closes: only the side that knows nothing more is coming can say so safely.",
          "그래서 닫는 쪽은 보내는 쪽이다. 더 올 것이 없음을 아는 쪽만 안전하게 말할 수 있다.",
          "所以閂 channel 係 sender 嘅事：只有知道冇嘢再嚟嗰邊，先可以安全噉講。"
        ),
      },
      {
        topic = "NIL",
        q = L(
          "Switch one select case off for good. What do you set the channel to?",
          "select의 한 갈래를 영영 끈다. 채널에 무엇을 넣나?",
          "永久熄咗 select 一個 case。將個 channel set 做咩？"
        ),
        code = L(
          [[
orders = ___
select {
case o := <-orders:
    cook(o)
case <-quit:
    return
}
]],
          [[
orders = ___
select {
case o := <-orders:
    cook(o)
case <-quit:
    return
}
]],
          [[
orders = ___
select {
case o := <-orders:
    cook(o)
case <-quit:
    return
}
]]
        ),
        accept = { "nil" },
        answer = "nil",
        hint = L(
          "The zero value of a channel. Receiving on it blocks for ever, which select reads as 'never ready'.",
          "채널의 제로 값. 그 위에서 받으면 영원히 막히고, select는 '준비되지 않음'으로 읽는다.",
          "channel 嘅零值。喺佢度收會永遠 block，select 睇成「永遠未 ready」。"
        ),
        ok = L(
          "Setting a channel to nil disables its case without touching the loop. It is the standard way to drain two inputs that end at different times.",
          "채널을 nil로 두면 루프를 건드리지 않고 그 갈래만 끈다. 끝나는 시점이 다른 두 입력을 소진하는 표준 방법.",
          "將 channel set 做 nil，唔使郁個 loop 就熄咗嗰個 case。兩個唔同時間完嘅輸入，慣常就係咁抽乾。"
        ),
      },
      {
        topic = "ROOM",
        q = L(
          "How much room does the belt have in total? Which builtin?",
          "벨트의 총 용량은? 어떤 내장 함수?",
          "條帶總共有幾多位？邊個內建 function？"
        ),
        code = L(
          [[
ch := make(chan Order, 8)
ch <- Order{id: 1}
fmt.Println(len(ch), ___(ch))
// 1 8
]],
          [[
ch := make(chan Order, 8)
ch <- Order{id: 1}
fmt.Println(len(ch), ___(ch))
// 1 8
]],
          [[
ch := make(chan Order, 8)
ch <- Order{id: 1}
fmt.Println(len(ch), ___(ch))
// 1 8
]]
        ),
        accept = { "cap" },
        answer = "cap",
        hint = L(
          "Three letters, the same builtin a slice uses for its capacity.",
          "세 글자, 슬라이스가 용량에 쓰는 그 내장 함수.",
          "三個字母，同 slice 用嚟睇容量嗰個內建 function 一樣。"
        ),
        ok = L(
          "len is what is waiting, cap is the buffer size. A buffer smooths bursts; it never removes the need to handle a slow consumer.",
          "len은 대기 중인 것, cap은 버퍼 크기. 버퍼는 순간 폭주를 다듬을 뿐, 느린 소비자를 다룰 필요를 없애지 않는다.",
          "len 係等緊嘅嘢，cap 係 buffer 大細。buffer 平滑咗突發流量，但唔會令你唔使處理慢嘅消費者。"
        ),
      },
      {
        topic = "FANIN",
        q = L(
          "Six workers, one out channel. Who ends the range over out, and how?",
          "워커 여섯, out 채널 하나. out에 대한 range를 누가 어떻게 끝내나?",
          "六個 worker，一條 out channel。邊個點樣結束 out 嘅 range？"
        ),
        code = L(
          [[
go func() {
    wg.Wait()
    ___(out)
}()
for d := range out {
    serve(d)
}
]],
          [[
go func() {
    wg.Wait()
    ___(out)
}()
for d := range out {
    serve(d)
}
]],
          [[
go func() {
    wg.Wait()
    ___(out)
}()
for d := range out {
    serve(d)
}
]]
        ),
        accept = { "close" },
        answer = "close",
        hint = L(
          "The builtin that ends a range. One goroutine waits for the workers and then calls it once.",
          "range를 끝내는 내장 함수. 고루틴 하나가 워커를 기다렸다가 한 번 부른다.",
          "結束 range 嗰個內建 function。一個 goroutine 等齊啲 worker 再 call 一次。"
        ),
        ok = L(
          "Fan-in: workers send, one closer closes. Closing from a worker would panic the others, so the closer is the goroutine that waits.",
          "팬인: 워커는 보내고 닫는 이는 하나. 워커가 닫으면 나머지가 패닉하니, 기다리는 고루틴이 닫는다.",
          "Fan-in：worker 負責送，一個人負責閂。worker 自己閂會令其他人 panic，所以由等嗰個 goroutine 閂。"
        ),
      },
    },
  },
  {
    id = "ctx",
    station = "CONTEXT",
    name = L("The rider who gave up", "포기한 라이더", "走咗嘅外賣員"),
    title = L("context: cancel, deadline, value", "context: 취소, 마감, 값", "context：取消、死線、值"),
    lesson = L(
      "A context is the cancel signal of a request. It travels as the first parameter, named ctx, never inside a struct. WithCancel and WithTimeout wrap a parent and hand back a cancel function you always defer. Work watches ctx.Done() and reports ctx.Err(), which is Canceled or DeadlineExceeded.",
      "context는 요청의 취소 신호다. 첫 번째 파라미터 ctx로 전달되며 구조체 안에 넣지 않는다. WithCancel과 WithTimeout은 부모를 감싸고 cancel 함수를 돌려주며, 그것은 항상 defer한다. 작업은 ctx.Done()을 지켜보고 ctx.Err()로 Canceled 또는 DeadlineExceeded를 보고한다.",
      "context 係一個 request 嘅取消訊號。佢做第一個參數，叫 ctx，唔好放入 struct。WithCancel 同 WithTimeout 包住 parent，回一個 cancel function，永遠要 defer。工作就睇住 ctx.Done()，用 ctx.Err() 報告 Canceled 定 DeadlineExceeded。"
    ),
    bg = "bg_mall",
    portrait = "portrait_friends",
    speaker = L("Mei", "메이", "阿美"),
    ground = 348,
    spawn = 170,
    width = 1600,
    npcs = {
      {
        kind = "mei",
        x = 540,
        facing = 1,
        line = L(
          "The customer closed the app two minutes ago and your goroutine is still fetching the ETA.",
          "손님은 2분 전에 앱을 닫았는데 네 고루틴은 아직 ETA를 받아오고 있어.",
          "個客兩分鐘前已經閂咗 App，你個 goroutine 仲攞緊 ETA。"
        ),
      },
      {
        kind = "hero",
        x = 920,
        facing = -1,
        line = L(
          "Nobody told it to stop. Nothing in Go kills a goroutine from outside.",
          "멈추라고 말한 사람이 없었으니까. Go에선 밖에서 고루틴을 죽일 방법이 없어.",
          "冇人叫佢停。Go 入面冇嘢可以喺外面殺一個 goroutine。"
        ),
      },
    },
    viz = "chips",
    chips = {
      { "ctx context.Context", "cyan" },
      { "defer cancel()", "gold" },
      { "<-ctx.Done()", "pink" },
      { "DeadlineExceeded", "green" },
    },
    note = "ctx first  WithCancel  Done  Err  WithValue",
    story = L(
      "13:20. A rider cancels, the customer closes the app, and three goroutines carry on fetching "
        .. "an ETA nobody will read. Go cannot kill a goroutine from outside: cancellation is a value "
        .. "you pass in and a channel the work agrees to watch.",
      "13:20. 라이더가 취소하고 손님이 앱을 닫아도 고루틴 셋은 아무도 읽지 않을 ETA를 계속 받아온다. "
        .. "Go는 밖에서 고루틴을 죽이지 못한다. 취소는 넘겨주는 값이고, 작업이 지켜보기로 한 채널이다.",
      "13:20. 外賣員取消咗，個客閂咗 App，但三個 goroutine 仲攞緊冇人會睇嘅 ETA。"
        .. "Go 唔可以喺外面殺一個 goroutine：取消係你傳入去嘅一個值，同埋一條工作答應會睇住嘅 channel。"
    ),
    stages = {
      {
        topic = "FIRST",
        q = L(
          "Where does a context go? Name the first parameter every Go API uses.",
          "context는 어디에 놓나? 모든 Go API가 쓰는 첫 파라미터 이름은?",
          "context 擺喺邊？講出每個 Go API 都用嘅第一個參數個名。"
        ),
        code = L(
          [[
// first parameter, never a struct field
func Cook(___ context.Context, o Order) error {
    return nil
}
]],
          [[
// 항상 첫 파라미터로
func Cook(___ context.Context, o Order) error {
    return nil
}
]],
          [[
// 永遠係第一個參數，唔好做 struct field
func Cook(___ context.Context, o Order) error {
    return nil
}
]]
        ),
        accept = { "ctx" },
        answer = "ctx",
        hint = L(
          "Three letters, the abbreviation everybody uses. It is a convention, not a rule the compiler knows.",
          "세 글자, 모두가 쓰는 약어. 컴파일러가 아는 규칙이 아니라 관례.",
          "三個字母，人人都用嘅縮寫。呢個係慣例，唔係 compiler 識嘅規則。"
        ),
        ok = L(
          "func F(ctx context.Context, ...) error. Keeping it first and out of structs is what lets cancellation reach every call in the tree.",
          "func F(ctx context.Context, ...) error. 첫 자리에 두고 구조체에 넣지 않아야 취소가 호출 트리 전체에 닿는다.",
          "func F(ctx context.Context, ...) error。擺第一個又唔放入 struct，取消先可以傳到成棵呼叫樹。"
        ),
      },
      {
        topic = "CANCEL",
        q = L(
          "Make a context you can stop by hand. Which constructor?",
          "손으로 멈출 수 있는 context를 만든다. 어떤 생성자?",
          "整一個可以自己叫停嘅 context。用邊個 constructor？"
        ),
        code = L(
          [[
ctx, cancel := context.___(context.Background())
defer cancel()
go fetchETA(ctx, id)
]],
          [[
ctx, cancel := context.___(context.Background())
defer cancel()
go fetchETA(ctx, id)
]],
          [[
ctx, cancel := context.___(context.Background())
defer cancel()
go fetchETA(ctx, id)
]]
        ),
        accept = { "WithCancel" },
        answer = "WithCancel",
        hint = L(
          "With, then the verb for stopping. Its siblings are WithTimeout and WithDeadline.",
          "With 다음에 멈춤을 뜻하는 동사. 형제는 WithTimeout과 WithDeadline.",
          "With 再加代表停止嗰個動詞。佢啲兄弟係 WithTimeout 同 WithDeadline。"
        ),
        ok = L(
          "The second return value is not optional: not calling cancel leaks the context and whatever the parent holds for it.",
          "두 번째 반환값은 선택이 아니다. cancel을 부르지 않으면 context와 부모가 쥔 것이 샌다.",
          "第二個回傳值唔係可有可無：唔 call cancel 就會漏咗個 context 同 parent 幫佢揸住嘅嘢。"
        ),
      },
      {
        topic = "DEADLINE",
        q = L(
          "Give the ETA call two seconds and no more. Which constructor?",
          "ETA 호출에 2초만 준다. 어떤 생성자?",
          "俾 ETA 呼叫兩秒，唔可以再多。用邊個 constructor？"
        ),
        code = L(
          [[
ctx, cancel := context.___(ctx, 2*time.Second)
defer cancel()
resp, err := fetchETA(ctx, id)
]],
          [[
ctx, cancel := context.___(ctx, 2*time.Second)
defer cancel()
resp, err := fetchETA(ctx, id)
]],
          [[
ctx, cancel := context.___(ctx, 2*time.Second)
defer cancel()
resp, err := fetchETA(ctx, id)
]]
        ),
        accept = { "WithTimeout" },
        answer = "WithTimeout",
        hint = L(
          "With, then a duration word. The twin that takes a time.Time is WithDeadline.",
          "With 다음에 시간을 뜻하는 단어. time.Time을 받는 쌍둥이는 WithDeadline.",
          "With 再加一個講時間長度嘅字。收 time.Time 嗰個孖生兄弟叫 WithDeadline。"
        ),
        ok = L(
          "A timeout is a deadline computed from now. It is inherited: a child can be stricter than its parent, never looser.",
          "타임아웃은 지금부터 계산한 마감이다. 상속되며, 자식은 부모보다 엄격할 수는 있어도 느슨할 수는 없다.",
          "timeout 就係由而家計出嚟嘅死線。佢會繼承：仔可以嚴過老豆，但唔可以鬆過。"
        ),
      },
      {
        topic = "DONE",
        q = L(
          "Race the cooking against the cancel. Which method gives the channel to select on?",
          "요리와 취소를 경주시킨다. select할 채널을 주는 메서드는?",
          "煮同取消鬥快。邊個 method 俾條 channel 你 select？"
        ),
        code = L(
          [[
select {
case d := <-cooked:
    return d, nil
case <-ctx.___():
    return Dish{}, ctx.Err()
}
]],
          [[
select {
case d := <-cooked:
    return d, nil
case <-ctx.___():
    return Dish{}, ctx.Err()
}
]],
          [[
select {
case d := <-cooked:
    return d, nil
case <-ctx.___():
    return Dish{}, ctx.Err()
}
]]
        ),
        accept = { "Done" },
        answer = "Done",
        hint = L(
          "Four letters. The channel is closed when the context is finished, so every watcher wakes at once.",
          "네 글자. context가 끝나면 그 채널이 닫히고 지켜보던 모두가 동시에 깨어난다.",
          "四個字母。context 完咗個 channel 就會閂，睇住佢嘅人一齊醒。"
        ),
        ok = L(
          "ctx.Done() is a receive-only channel closed on cancel or deadline. Selecting on it is how a goroutine agrees to be stoppable.",
          "ctx.Done()은 취소나 마감에 닫히는 수신 전용 채널이다. 그것을 select하는 것이 고루틴이 멈출 수 있음에 동의하는 방식이다.",
          "ctx.Done() 係一條 receive-only channel，取消或者到期就會閂。select 佢，就係一個 goroutine 答應可以俾人叫停。"
        ),
      },
      {
        topic = "ERR",
        q = L(
          "The two seconds ran out. Which context error is that?",
          "2초가 다 됐다. 어떤 context 에러인가?",
          "兩秒用完咗。係邊個 context error？"
        ),
        code = L(
          [[
if errors.Is(ctx.Err(), context.___) {
    log.Print("the customer stopped waiting")
}
]],
          [[
if errors.Is(ctx.Err(), context.___) {
    log.Print("손님이 기다리기를 멈췄다")
}
]],
          [[
if errors.Is(ctx.Err(), context.___) {
    log.Print("個客唔等喇")
}
]]
        ),
        accept = { "DeadlineExceeded" },
        answer = "DeadlineExceeded",
        hint = L(
          "Two words: the moment you promised, and what the clock did to it. The other one is Canceled.",
          "두 단어: 약속한 시각과 시계가 그것에 한 일. 다른 하나는 Canceled.",
          "兩個字：你承諾嘅時刻，同個鐘對佢做咗嘅嘢。另一個係 Canceled。"
        ),
        ok = L(
          "context.Canceled means somebody called cancel; context.DeadlineExceeded means the clock did. Both arrive through ctx.Err() after Done closes.",
          "context.Canceled는 누군가 cancel을 불렀다는 뜻, context.DeadlineExceeded는 시계가 그랬다는 뜻. 둘 다 Done이 닫힌 뒤 ctx.Err()로 온다.",
          "context.Canceled 即係有人 call 咗 cancel；context.DeadlineExceeded 即係個鐘到咗。兩個都係 Done 閂咗之後由 ctx.Err() 攞返。"
        ),
      },
      {
        topic = "VALUE",
        q = L(
          "Carry the order id through five calls of logging. Which constructor?",
          "주문 id를 로깅 호출 다섯 개를 거쳐 나른다. 어떤 생성자?",
          "將張單嘅 id 帶過五層 log 呼叫。用邊個 constructor？"
        ),
        code = L(
          [[
type orderKey struct{}

ctx = context.___(ctx, orderKey{}, id)
// five calls deeper:
id, ok := ctx.Value(orderKey{}).(int)
]],
          [[
type orderKey struct{}

ctx = context.___(ctx, orderKey{}, id)
// 다섯 단계 아래에서:
id, ok := ctx.Value(orderKey{}).(int)
]],
          [[
type orderKey struct{}

ctx = context.___(ctx, orderKey{}, id)
// 深五層之後：
id, ok := ctx.Value(orderKey{}).(int)
]]
        ),
        accept = { "WithValue" },
        answer = "WithValue",
        hint = L(
          "With, then the word for what is stored. The key is a private type so nobody can collide with it.",
          "With 다음에 저장되는 것을 뜻하는 단어. 키는 충돌하지 않도록 비공개 타입을 쓴다.",
          "With 再加代表存住嗰樣嘢嘅字。個 key 用私有 type，就冇人會撞。"
        ),
        ok = L(
          "WithValue is for request-scoped data that crosses API boundaries: a trace id, not the parameters of your function.",
          "WithValue는 API 경계를 넘는 요청 범위 데이터용이다. 트레이스 id는 되고, 함수의 파라미터는 아니다.",
          "WithValue 係俾跨 API 邊界嘅 request 範圍資料用：trace id 就啱，你 function 嘅參數就唔啱。"
        ),
      },
    },
  },
  {
    id = "async",
    station = "ASYNC",
    name = L("Where is await?", "await는 어디에?", "await 喺邊？"),
    title = L(
      "Async in Go: a goroutine and a channel",
      "Go의 async: 고루틴과 채널",
      "Go 嘅 async：一個 goroutine 加一條 channel"
    ),
    lesson = L(
      "Go has no async and no await, on purpose. A goroutine plus a buffered channel is a future: go starts it, <-ch awaits it. The runtime parks a goroutine that blocks on I/O and runs another on the same OS thread, so ordinary blocking code is already asynchronous. errgroup runs a batch and returns the first error; runtime.NumGoroutine() shows the ones you forgot to stop.",
      "Go에는 async도 await도 없다. 일부러 그렇다. 고루틴과 버퍼 채널이 곧 퓨처다. go가 시작하고 <-ch가 기다린다. 런타임은 I/O에서 막힌 고루틴을 재우고 같은 OS 스레드에 다른 고루틴을 올리므로, 평범한 블로킹 코드가 이미 비동기다. errgroup은 묶음을 실행해 첫 에러를 돌려주고, runtime.NumGoroutine()은 멈추는 것을 잊은 고루틴을 보여준다.",
      "Go 冇 async 又冇 await，係特登嘅。一個 goroutine 加一條有 buffer 嘅 channel 就係 future：go 開始佢，<-ch 等佢。runtime 會將 I/O 卡住嘅 goroutine 泊低，喺同一條 OS thread 上面行第二個，所以普通嘅阻塞式 code 本身已經係非同步。errgroup 一次過跑一批，回第一個 error；runtime.NumGoroutine() 就照出你唔記得停嘅嗰啲。"
    ),
    bg = "bg_lab",
    portrait = "portrait_hero",
    speaker = L("Alex", "알렉스", "阿力"),
    ground = 348,
    spawn = 150,
    width = 1600,
    npcs = {
      {
        kind = "hero",
        x = 520,
        facing = 1,
        line = L(
          "In JavaScript I would write await fetchMenu(). Go's editor does not even know the word.",
          "자바스크립트면 await fetchMenu()라고 쓸 텐데. Go 에디터는 그 단어를 알지도 못해.",
          "如果係 JavaScript 我就寫 await fetchMenu()。Go 個 editor 連呢個字都唔識。"
        ),
      },
      {
        kind = "mei",
        x = 900,
        facing = -1,
        line = L(
          "Because every Go function is already the async one. There is no second colour of function to await.",
          "Go에선 모든 함수가 이미 비동기니까. 기다려야 할 두 번째 색깔의 함수가 없어.",
          "因為 Go 每個 function 本身已經係 async 嗰款。冇第二種顏色嘅 function 要你 await。"
        ),
      },
    },
    viz = "chips",
    chips = {
      { "go func() { ... }()", "cyan" },
      { "m := <-res", "gold" },
      { "make(chan T, 1)", "pink" },
      { "g.Wait()", "green" },
    },
    note = "go  <-res  buffer 1  errgroup  NumGoroutine",
    story = L(
      "13:40. Alex asks the question every newcomer asks: where is async, where is await? Mei draws "
        .. "two lines on the whiteboard. Start it with go. Wait for it with an arrow. Everything "
        .. "async/await gives you, Go gives you without splitting functions into two kinds.",
      "13:40. 알렉스가 신참이라면 누구나 하는 질문을 한다. async는 어디, await는 어디? 메이는 화이트보드에 "
        .. "두 줄을 긋는다. go로 시작하고, 화살표로 기다린다. async/await가 주는 모든 것을 Go는 함수를 "
        .. "두 종류로 가르지 않고 준다.",
      "13:40. 阿力問咗個新手都會問嘅問題：async 喺邊？await 喺邊？阿美喺白板寫低兩行。"
        .. "用 go 開始佢，用個箭頭等佢。async/await 俾到你嘅嘢，Go 全部都有，仲唔使將 function 分成兩種。"
    ),
    stages = {
      {
        topic = "SPAWN",
        q = L(
          "Start the fetch without waiting for it. Which keyword is Go's async?",
          "기다리지 않고 fetch를 시작한다. Go의 async에 해당하는 키워드는?",
          "唔等佢，直接開始個 fetch。Go 嘅 async 係邊個 keyword？"
        ),
        code = L(
          [[
res := make(chan Menu, 1)
___ func() { res <- fetchMenu() }()
printReceipt()
]],
          [[
res := make(chan Menu, 1)
___ func() { res <- fetchMenu() }()
printReceipt()
]],
          [[
res := make(chan Menu, 1)
___ func() { res <- fetchMenu() }()
printReceipt()
]]
        ),
        accept = { "go" },
        answer = "go",
        hint = L(
          "Two letters, the shortest keyword in the language, and the name of the language.",
          "두 글자, 언어에서 가장 짧은 키워드이자 언어의 이름.",
          "兩個字母，全個語言最短嘅 keyword，亦係個語言嘅名。"
        ),
        ok = L(
          "go f() is the whole of 'async': the call runs on its own goroutine and the current line moves on immediately.",
          "go f()가 'async'의 전부다. 호출은 자기 고루틴에서 돌고 현재 줄은 곧바로 다음으로 간다.",
          "go f() 就係成個「async」：個呼叫喺自己嘅 goroutine 度行，而家呢行即刻繼續落去。"
        ),
      },
      {
        topic = "AWAIT",
        q = L(
          "Now wait for the answer. Write Go's await.",
          "이제 결과를 기다린다. Go의 await를 쓰기.",
          "而家等個答案。寫低 Go 嘅 await。"
        ),
        code = L(
          [[
res := make(chan Menu, 1)
go func() { res <- fetchMenu() }()
printReceipt()
m := ___
]],
          [[
res := make(chan Menu, 1)
go func() { res <- fetchMenu() }()
printReceipt()
m := ___
]],
          [[
res := make(chan Menu, 1)
go func() { res <- fetchMenu() }()
printReceipt()
m := ___
]]
        ),
        accept = { "<-res" },
        answer = "<-res",
        hint = L(
          "An arrow pointing out of the channel, then the channel's name. Two characters and three.",
          "채널에서 나오는 화살표, 그다음 채널 이름. 두 글자와 세 글자.",
          "一個由 channel 出嚟嘅箭頭，再加 channel 個名。兩個符號加三個字母。"
        ),
        ok = L(
          "m := <-res blocks this goroutine, not the program. That is exactly what await does, minus the keyword and minus the coloured functions.",
          "m := <-res는 프로그램이 아니라 이 고루틴만 막는다. 키워드와 색깔 있는 함수를 뺀 await 그 자체.",
          "m := <-res 淨係 block 呢個 goroutine，唔係成個程式。除咗個 keyword 同分顏色嘅 function，其餘同 await 一模一樣。"
        ),
      },
      {
        topic = "BUFFER",
        q = L(
          "Give the future room for one result so a lost caller cannot strand the goroutine.",
          "결과 하나만큼 자리를 준다. 호출자가 사라져도 고루틴이 갇히지 않게.",
          "俾個 future 一格位放結果，就算 caller 唔要，個 goroutine 都唔會困死。"
        ),
        code = L(
          [[
res := make(chan Menu, ___)
go func() { res <- fetchMenu() }()
select {
case m := <-res:
    use(m)
case <-ctx.Done():
}
]],
          [[
res := make(chan Menu, ___)
go func() { res <- fetchMenu() }()
select {
case m := <-res:
    use(m)
case <-ctx.Done():
}
]],
          [[
res := make(chan Menu, ___)
go func() { res <- fetchMenu() }()
select {
case m := <-res:
    use(m)
case <-ctx.Done():
}
]]
        ),
        accept = { "1" },
        answer = "1",
        hint = L(
          "The smallest buffer that still holds something. One result, one slot.",
          "무언가를 담는 가장 작은 버퍼. 결과 하나, 자리 하나.",
          "仲裝到嘢嘅最細 buffer。一個結果，一格位。"
        ),
        ok = L(
          "With cap 1 the sender finishes even if the context won the select. With an unbuffered channel that goroutine would block for ever: a leak.",
          "cap 1이면 select에서 context가 이겨도 보내는 쪽은 끝난다. 무버퍼였다면 그 고루틴은 영원히 막힌다. 누수다.",
          "cap 1 嘅話，就算 select 俾 context 贏咗，sender 都行得完。冇 buffer 就會永遠 block 住：漏 goroutine。"
        ),
      },
      {
        topic = "GROUP",
        q = L(
          "Warm, fry and brew at once; stop all three on the first error. Which package?",
          "데우기, 튀기기, 내리기를 동시에. 첫 에러에 셋 다 멈춤. 어떤 패키지?",
          "翻熱、炸、沖茶一齊做；第一個 error 就三樣一齊停。用邊個 package？"
        ),
        code = L(
          [[
g, ctx := ___.WithContext(ctx)
g.Go(func() error { return warm(ctx) })
g.Go(func() error { return fry(ctx) })
if err := g.Wait(); err != nil {
    return err
}
]],
          [[
g, ctx := ___.WithContext(ctx)
g.Go(func() error { return warm(ctx) })
g.Go(func() error { return fry(ctx) })
if err := g.Wait(); err != nil {
    return err
}
]],
          [[
g, ctx := ___.WithContext(ctx)
g.Go(func() error { return warm(ctx) })
g.Go(func() error { return fry(ctx) })
if err := g.Wait(); err != nil {
    return err
}
]]
        ),
        accept = { "errgroup", "golang.org/x/sync/errgroup" },
        answer = "errgroup",
        hint = L(
          "A WaitGroup that carries an error, from golang.org/x/sync. Two words joined: err and group.",
          "에러를 나르는 WaitGroup, golang.org/x/sync에 있다. err와 group을 붙인 이름.",
          "一個識帶 error 嘅 WaitGroup，喺 golang.org/x/sync。兩個字砌埋：err 同 group。"
        ),
        ok = L(
          "errgroup.WithContext cancels the shared ctx the moment one task fails, and Wait returns that first error. It is Go's Promise.all.",
          "errgroup.WithContext는 한 작업이 실패하는 순간 공유 ctx를 취소하고, Wait이 그 첫 에러를 돌려준다. Go의 Promise.all이다.",
          "errgroup.WithContext 一有工作失敗就即刻取消共用嘅 ctx，Wait 回第一個 error。即係 Go 版嘅 Promise.all。"
        ),
      },
      {
        topic = "FUTURE",
        q = L(
          "If you miss the word, write it yourself. Fill the body of Await.",
          "그 단어가 그리우면 직접 쓰면 된다. Await의 본문을 채우기.",
          "如果真係掛住嗰個字，自己寫一個。填 Await 個 body。"
        ),
        code = L(
          [[
type Future[T any] struct{ ch chan T }

func (f Future[T]) Await() T {
    return ___f.ch
}
]],
          [[
type Future[T any] struct{ ch chan T }

func (f Future[T]) Await() T {
    return ___f.ch
}
]],
          [[
type Future[T any] struct{ ch chan T }

func (f Future[T]) Await() T {
    return ___f.ch
}
]]
        ),
        accept = { "<-" },
        answer = "<-",
        hint = L(
          "Two characters: the receive operator, in front of the channel.",
          "두 글자: 수신 연산자를 채널 앞에.",
          "兩個符號：接收運算子，擺喺 channel 前面。"
        ),
        ok = L(
          "Await is a receive with a nicer name. Go left it out of the language because a generic type and one operator are enough.",
          "Await는 이름만 예쁜 수신이다. 제네릭 타입 하나와 연산자 하나면 충분하니 Go는 언어에 넣지 않았다.",
          "Await 不過係改咗個靚名嘅接收。一個 generic type 加一個運算子已經夠，所以 Go 冇放入語言入面。"
        ),
      },
      {
        topic = "COUNT",
        q = L(
          "Did any of those futures leak? Which runtime call counts the live goroutines?",
          "그 퓨처들이 샜을까? 살아 있는 고루틴을 세는 runtime 호출은?",
          "頭先啲 future 有冇漏？邊個 runtime call 數住仲生存嘅 goroutine？"
        ),
        code = L(
          [[
go fetchMenu()
time.Sleep(time.Millisecond)
fmt.Println(runtime.___())
// 2: main, and the one nobody is waiting for
]],
          [[
go fetchMenu()
time.Sleep(time.Millisecond)
fmt.Println(runtime.___())
// 2: main과 아무도 기다리지 않는 고루틴 하나
]],
          [[
go fetchMenu()
time.Sleep(time.Millisecond)
fmt.Println(runtime.___())
// 2：main，同埋冇人等嗰個
]]
        ),
        accept = { "NumGoroutine" },
        answer = "NumGoroutine",
        hint = L(
          "Num, then the thing Go is famous for, singular.",
          "Num 다음에 Go로 유명한 그것, 단수형.",
          "Num 再加 Go 最出名嗰樣嘢，單數。"
        ),
        ok = L(
          "A goroutine that nobody waits for and nothing cancels is a leak: it holds its stack and whatever it captured until the process ends.",
          "아무도 기다리지 않고 아무것도 취소하지 않는 고루틴은 누수다. 프로세스가 끝날 때까지 스택과 붙잡은 것을 쥔다.",
          "冇人等又冇嘢取消嘅 goroutine 就係漏：佢會揸住自己個 stack 同捉住嘅嘢，直到個 process 完為止。"
        ),
      },
    },
  },
}

return maps
