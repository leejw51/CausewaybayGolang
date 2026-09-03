-- Quest 2 ADVANCED: inside Lucky Mac, earn the morning set.
-- Goroutines, channels, select, sync, generics, context, tests.

local function L(en, ko, yue)
  return { en = en, ko = ko, yue = yue }
end

local maps = {
  {
    id = "till",
    station = "DEFER",
    name = L("The till", "계산대", "收銀"),
    title = L("Errors and defer", "에러와 defer", "error 同 defer"),
    lesson = L(
      "error is an interface. Check err != nil. defer runs when the function returns.",
      "error는 인터페이스. err != nil을 확인. defer는 함수가 반환할 때 실행.",
      "error 係 interface。檢查 err != nil。defer 喺 function 回傳嗰陣行。"
    ),
    bg = "bg_till",
    portrait = "portrait_clerk",
    speaker = L("Siu Ming", "시우밍", "小明"),
    ground = 348,
    spawn = 180,
    width = 1600,
    npcs = {
      {
        kind = "clerk",
        x = 540,
        facing = 1,
        line = L(
          "Pay() can fail. Check the error. Close the drawer with defer.",
          "Pay()는 실패할 수 있어. 에러를 봐. defer로 서랍을 닫아.",
          "Pay() 可以失敗。睇 error。用 defer 閂櫃桶。"
        ),
      },
    },
    viz = "till",
    story = L(
      "The till returns (receipt, err). If err is not the zero value of error, "
        .. "stop. defer close() runs even if you return early.",
      "계산대는 (receipt, err)를 반환. err가 error의 제로 값이 아니면 멈춘다. "
        .. "defer close()는 일찍 반환해도 실행된다.",
      "收銀回傳 (receipt, err)。如果 err 唔係 error 嘅零值，就停。"
        .. "defer close() 就算提早 return 都會行。"
    ),
    stages = {
      {
        topic = "NIL",
        q = L(
          "The zero value of a pointer, slice, map, chan, func, or error is ___.",
          "포인터, 슬라이스, 맵, 채널, 함수, 에러의 제로 값은 ___.",
          "pointer、slice、map、chan、func、error 嘅零值係 ___。"
        ),
        code = L(
          [[
var err error
if err != ___ {
    return err
}
]],
          [[
var err error
if err != ___ {
    return err
}
]],
          [[
var err error
if err != ___ {
    return err
}
]]
        ),
        accept = { "nil" },
        answer = "nil",
        hint = L(
          "Not null, not None. Three letters. The only zero for interfaces with no type.",
          "null도 None도 아님. 세 글자. 타입 없는 인터페이스의 유일한 제로.",
          "唔係 null，唔係 None。三個字母。冇類型嘅 interface 唯一零值。"
        ),
        ok = L(
          "if err != nil { return err }. The first line after a call that can fail.",
          "if err != nil { return err }. 실패할 수 있는 호출 다음 첫 줄.",
          "if err != nil { return err }。可能失敗嘅呼叫之後第一行。"
        ),
      },
      {
        topic = "DEFER",
        q = L(
          "Run close() when this function returns, even on error. Which keyword?",
          "에러가 나도 이 함수가 반환할 때 close()를 실행. 키워드는?",
          "就算有 error，呢個 function 回傳都要行 close()。邊個 keyword？"
        ),
        code = L(
          [[
f, err := os.Open("order.txt")
___ f.Close()
]],
          [[
f, err := os.Open("order.txt")
___ f.Close()
]],
          [[
f, err := os.Open("order.txt")
___ f.Close()
]]
        ),
        accept = { "defer" },
        answer = "defer",
        hint = L(
          "Schedules a call for later. Last in, first out. After the return happens.",
          "나중에 호출을 예약. 나중에 넣은 것이 먼저. return이 일어난 다음.",
          "稍後先呼叫。後入先出。return 發生之後。"
        ),
        ok = L(
          "defer f.Close(). The drawer shuts even if Pay fails.",
          "defer f.Close(). Pay가 실패해도 서랍은 닫힌다.",
          "defer f.Close()。就算 Pay 失敗，櫃桶都會閂。"
        ),
      },
      {
        topic = "PANIC",
        q = L(
          "A crash you can catch in the same goroutine. Which pair: panic and ___?",
          "같은 고루틴에서 잡을 수 있는 크래시. 짝은 panic과 ___?",
          "同一個 goroutine 可以捉到嘅 crash。一對係 panic 同 ___？"
        ),
        code = L(
          [[
defer func() {
    if r := ___(); r != nil {
        // saved the till
    }
}()
]],
          [[
defer func() {
    if r := ___(); r != nil {
        // 계산대 구함
    }
}()
]],
          [[
defer func() {
    if r := ___(); r != nil {
        // 救咗收銀
    }
}()
]]
        ),
        accept = { "recover" },
        answer = "recover",
        hint = L(
          "Only useful inside defer. Returns nil if we are not panicking.",
          "defer 안에서만 쓸모 있다. 패닉이 아니면 nil.",
          "只喺 defer 入面有用。冇 panic 就回 nil。"
        ),
        ok = L(
          "panic stops the goroutine. recover() inside defer can save it. Rare in libraries.",
          "panic은 고루틴을 멈춘다. defer 안의 recover()가 구할 수 있다. 라이브러리에선 드물다.",
          "panic 停 goroutine。defer 入面嘅 recover() 可以救。library 好少用。"
        ),
      },
      {
        topic = "PANIC",
        q = L(
          "Stop everything: the till has no paper and that is a bug. Which built-in raises the crash?",
          "전부 멈춰: 영수증 용지가 없고 그건 버그다. 어떤 내장 함수가 크래시를 일으키나?",
          "全部停：收銀機冇紙，係 bug。咩內置 function 會引發 crash？"
        ),
        code = L(
          [[
if paper == 0 {
    ___("till: no paper")   // unwinds, runs defers
}
]],
          [[
if paper == 0 {
    ___("till: no paper")   // 되감기, defer 실행
}
]],
          [[
if paper == 0 {
    ___("till: no paper")   // 回捲，行晒 defer
}
]]
        ),
        answer = "panic",
        accept = { "panic" },
        hint = L(
          "Five letters. Return an error for expected failure; this is for the impossible.",
          "다섯 글자. 예상되는 실패는 error 반환; 이건 불가능한 상황용.",
          "五個字母。預期嘅失敗回傳 error；呢個係畀唔可能發生嘅事。"
        ),
        ok = L(
          "panic unwinds the stack running every defer. recover in a defer can stop it.",
          "panic은 모든 defer를 실행하며 스택을 되감는다. defer 안의 recover가 막을 수 있다.",
          "panic 回捲 stack，行晒每個 defer。defer 入面嘅 recover 可以截停。"
        ),
      },
      {
        topic = "DEFERARG",
        q = L(
          "defer captures its arguments now, not later. What does this print?",
          "defer는 인자를 나중이 아니라 지금 잡는다. 뭘 출력?",
          "defer 而家就攞住啲 argument，唔係遲啲。印咩？"
        ),
        code = L(
          [[
x := 1
defer fmt.Println(x)    // prints ___ at the end
x = 2
]],
          [[
x := 1
defer fmt.Println(x)    // 마지막에 ___ 출력
x = 2
]],
          [[
x := 1
defer fmt.Println(x)    // 最後印出 ___
x = 2
]]
        ),
        answer = "1",
        accept = { "1" },
        hint = L(
          "The argument is evaluated on the defer line. Only the call is delayed.",
          "인자는 defer 줄에서 평가된다. 호출만 미뤄진다.",
          "argument 喺 defer 嗰行就計咗。淨係個 call 延遲。"
        ),
        ok = L(
          "defer evaluates arguments immediately. defer func() { fmt.Println(x) }() would print 2.",
          "defer는 인자를 즉시 평가. defer func() { fmt.Println(x) }()라면 2를 출력.",
          "defer 即刻計 argument。defer func() { fmt.Println(x) }() 就會印 2。"
        ),
      },
    },
  },

  {
    id = "kitchen",
    station = "GO",
    name = L("The kitchen", "주방", "廚房"),
    title = L("Goroutines", "고루틴", "Goroutine"),
    lesson = L(
      "go starts a goroutine: a lightweight thread the runtime multiplexes onto OS threads.",
      "go는 고루틴을 시작한다: 런타임이 OS 스레드에 올리는 가벼운 스레드.",
      "go 開一個 goroutine：runtime 放上 OS thread 嘅輕量 thread。"
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
        facing = 1,
        line = L(
          "Hash brown on one burner. Muffin on another. Both at once.",
          "해시브라운은 이쪽 불. 머핀은 저쪽. 동시에.",
          "薯餅一個爐。鬆餅另一個。一齊做。"
        ),
      },
    },
    viz = "kitchen",
    story = L(
      "The kitchen is concurrent. One cook cannot wait for the hash brown before "
        .. "starting the muffin. go fry() starts a function in a new goroutine.",
      "주방은 동시적이다. 한 요리사가 해시브라운을 기다린 뒤에야 머핀을 시작해서는 안 된다. "
        .. "go fry()는 새 고루틴에서 함수를 시작한다.",
      "廚房係並行。一個廚師唔可以等薯餅先至開始鬆餅。"
        .. "go fry() 喺新 goroutine 開一個 function。"
    ),
    stages = {
      {
        topic = "GO",
        q = L(
          "Start fry() in a new goroutine. Which keyword?",
          "새 고루틴에서 fry()를 시작. 키워드는?",
          "喺新 goroutine 開 fry()。邊個 keyword？"
        ),
        code = L(
          [[
___ fry("hashbrown")
___ toast("muffin")
]],
          [[
___ fry("hashbrown")
___ toast("muffin")
]],
          [[
___ fry("hashbrown")
___ toast("muffin")
]]
        ),
        accept = { "go" },
        answer = "go",
        hint = L(
          "Two letters. Then a function call. The caller does not wait.",
          "두 글자. 그다음 함수 호출. 호출자는 기다리지 않는다.",
          "兩個字母。然後 function call。呼叫者唔會等。"
        ),
        ok = L(
          "go fry() returns at once. fry runs concurrently. Two burners, one program.",
          "go fry()는 바로 반환. fry는 동시에 돈다. 버너 둘, 프로그램 하나.",
          "go fry() 即刻 return。fry 並行行。兩個爐，一個程式。"
        ),
      },
      {
        topic = "NAME",
        q = L(
          "What is the lightweight thread go starts called?",
          "go가 시작하는 가벼운 스레드의 이름은?",
          "go 開嘅輕量 thread 叫咩名？"
        ),
        code = L(
          [[
// go f() starts a ___
// thousands of them are cheap
]],
          [[
// go f()가 ___를 시작
// 수천 개도 싸다
]],
          [[
// go f() 開一個 ___
// 數千個都平
]]
        ),
        accept = { "goroutine", "go routine", "goroutines" },
        answer = "goroutine",
        hint = L(
          "Go + routine. Not a full OS thread. The scheduler parks them.",
          "Go + routine. 완전한 OS 스레드가 아님. 스케줄러가 재운다.",
          "Go + routine。唔係完整 OS thread。scheduler 會停佢哋。"
        ),
        ok = L(
          "A goroutine is cheap. Don't confuse it with a thread you create by hand.",
          "고루틴은 싸다. 손으로 만드는 스레드와 혼동하지 마라.",
          "goroutine 好平。唔好同自己開嘅 thread 撈亂。"
        ),
      },
      {
        topic = "CALL",
        q = L(
          "Start an anonymous function as a goroutine. What closes the line?",
          "익명 함수를 고루틴으로 시작. 줄 끝에 뭐가 오나?",
          "將匿名 function 當 goroutine 開始。行尾係咩？"
        ),
        code = L(
          [[
go func() {
    fry("hashbrown")
}___                    // call it right away
]],
          [[
go func() {
    fry("hashbrown")
}___                    // 바로 호출
]],
          [[
go func() {
    fry("hashbrown")
}___                    // 即刻 call
]]
        ),
        answer = "()",
        accept = { "()" },
        hint = L(
          "Empty parentheses. go needs a call, not just a function value.",
          "빈 괄호. go는 함수 값이 아니라 호출이 필요하다.",
          "空括號。go 要一個 call，唔係淨係 function 值。"
        ),
        ok = L(
          "go func(){...}() is the everyday goroutine launcher. Pass loop variables as arguments.",
          "go func(){...}()가 일상적인 고루틴 시작법. 루프 변수는 인자로 넘길 것.",
          "go func(){...}() 係日常開 goroutine 嘅寫法。loop 變數要當 argument 傳入。"
        ),
      },
    },
  },

  {
    id = "pass",
    station = "CHAN",
    name = L("The pass", "패스", "出餐口"),
    title = L("Channels", "채널", "Channel"),
    lesson = L(
      "chan is a typed pipe. <- sends and receives. close tells receivers to stop.",
      "chan은 타입 있는 파이프. <-가 보내고 받는다. close는 수신자에게 멈추라고 한다.",
      "chan 係有類型嘅喉。<- 送同收。close 話收嘅人停。"
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
        x = 640,
        facing = -1,
        line = L(
          "Don't share memory. Pass the hash brown on a channel.",
          "메모리를 나누지 마. 해시브라운을 채널로 넘겨.",
          "唔好分享 memory。用 channel 傳薯餅。"
        ),
      },
    },
    viz = "pass",
    story = L(
      "The pass window is a channel. One goroutine fries, another plates. "
        .. "Do not share the same variable; send the value through the pipe.",
      "출창은 채널이다. 한 고루틴이 튀기고 다른 고루틴이 담는다. "
        .. "같은 변수를 나누지 말고 파이프로 값을 보내라.",
      "出餐口係 channel。一個 goroutine 炸，另一個碟。"
        .. "唔好分享同一個變數；用條喉送個值。"
    ),
    stages = {
      {
        topic = "CHAN",
        q = L(
          "A pipe that carries string. Fill: ch := make(___)",
          "string을 나르는 파이프. 채우세요: ch := make(___)",
          "送 string 嘅喉。填：ch := make(___)"
        ),
        code = L(
          [[
ch := make(___)        // unbuffered
]],
          [[
ch := make(___)        // 버퍼 없음
]],
          [[
ch := make(___)        // 冇 buffer
]]
        ),
        accept = { "chan string", "chanstring" },
        answer = "chan string",
        hint = L(
          "Keyword chan, then the element type. make allocates it.",
          "키워드 chan, 그다음 원소 타입. make가 할당.",
          "keyword chan，然後元素類型。make 分配。"
        ),
        ok = L(
          "make(chan string). Unbuffered: send waits for receive.",
          "make(chan string). 언버퍼: 보내기는 받기를 기다린다.",
          "make(chan string)。冇 buffer：送要等收。"
        ),
      },
      {
        topic = "SEND",
        q = L(
          "Send a value into the channel. Fill the operator: ch ___ muffin",
          "채널에 값을 넣는다. 연산자: ch ___ muffin",
          "將值送入 channel。運算符：ch ___ muffin"
        ),
        code = L(
          [[
ch := make(chan string)
ch ___ "muffin"        // send
]],
          [[
ch := make(chan string)
ch ___ "muffin"        // 보내기
]],
          [[
ch := make(chan string)
ch ___ "muffin"        // 送
]]
        ),
        accept = { "<-", "< -" },
        answer = "<-",
        hint = L(
          "Arrow pointing at the channel. Receive is the same arrow on the left of =.",
          "채널을 가리키는 화살표. 받기는 같은 화살표가 = 왼쪽.",
          "箭咀指住 channel。收係同一個箭咀喺 = 左邊。"
        ),
        ok = L(
          "ch <- x sends. x := <-ch receives. Same operator, different place.",
          "ch <- x는 보내기. x := <-ch는 받기. 같은 연산자, 다른 자리.",
          "ch <- x 送。x := <-ch 收。同一個運算符，唔同位。"
        ),
      },
      {
        topic = "CLOSE",
        q = L(
          "Tell receivers no more hash browns will come. Which built-in?",
          "수신자에게 해시브라운이 더 안 온다고 알린다. 내장 함수는?",
          "話收嘅人唔會再有薯餅。邊個內建函數？"
        ),
        code = L(
          [[
___(ch)
x, ok := <-ch          // ok is false after
]],
          [[
___(ch)
x, ok := <-ch          // 이후 ok는 false
]],
          [[
___(ch)
x, ok := <-ch          // 之後 ok 係 false
]]
        ),
        accept = { "close" },
        answer = "close",
        hint = L(
          "Only the sender should call it. Never close from the receive side.",
          "보내는 쪽만 호출. 받는 쪽에서 닫지 마라.",
          "只有送嘅人應該 call。永遠唔好由收嘅一邊閂。"
        ),
        ok = L(
          "close(ch). range ch stops when the channel is closed.",
          "close(ch). range ch는 채널이 닫히면 멈춘다.",
          "close(ch)。range ch 喺 channel 閂咗就停。"
        ),
      },
      {
        topic = "BUFFER",
        q = L(
          "A channel that holds 3 muffins before a send blocks. Fill: make(chan string, ___)",
          "send가 블록되기 전에 머핀 3개를 담는 채널: make(chan string, ___)",
          "send 會 block 之前可以裝 3 個鬆餅嘅 channel：make(chan string, ___)"
        ),
        code = L(
          [[
ch := make(chan string, ___)   // buffered
ch <- "muffin"                 // does not block yet
]],
          [[
ch := make(chan string, ___)   // 버퍼 있음
ch <- "muffin"                 // 아직 블록 안 됨
]],
          [[
ch := make(chan string, ___)   // 有 buffer
ch <- "muffin"                 // 仲未 block
]]
        ),
        answer = "3",
        accept = { "3" },
        hint = L(
          "The second argument to make is the buffer size.",
          "make의 두 번째 인자가 버퍼 크기.",
          "make 第二個 argument 係 buffer 大小。"
        ),
        ok = L(
          "A buffered channel blocks only when full. Unbuffered blocks on every send until someone receives.",
          "버퍼 채널은 찼을 때만 블록. 버퍼 없는 채널은 누가 받을 때까지 매 send가 블록.",
          "有 buffer 嘅 channel 滿咗先 block。冇 buffer 嘅每次 send 都 block 到有人收。"
        ),
      },
      {
        topic = "DIRECTION",
        q = L(
          "plate only receives. Fill the parameter type: in ___ string",
          "plate는 받기만 한다. 매개변수 타입: in ___ string",
          "plate 淨係收。parameter type：in ___ string"
        ),
        code = L(
          [[
func plate(in ___ string) {   // receive-only
    for m := range in {
        serve(m)
    }
}
]],
          [[
func plate(in ___ string) {   // 받기 전용
    for m := range in {
        serve(m)
    }
}
]],
          [[
func plate(in ___ string) {   // 淨係收
    for m := range in {
        serve(m)
    }
}
]]
        ),
        answer = "<-chan",
        accept = { "<-chan" },
        hint = L(
          "Arrow then chan. chan<- string would be send-only.",
          "화살표 다음 chan. chan<- string은 보내기 전용.",
          "箭嘴然後 chan。chan<- string 就係淨係送。"
        ),
        ok = L(
          "<-chan T and chan<- T let the compiler stop the wrong side from sending or closing.",
          "<-chan T와 chan<- T로 컴파일러가 잘못된 쪽의 send/close를 막는다.",
          "<-chan T 同 chan<- T 畀 compiler 阻止錯嘅一邊 send 或者 close。"
        ),
      },
      {
        topic = "RANGE",
        q = L(
          "Receive until the channel is closed. Fill: for m := ___ ch",
          "채널이 닫힐 때까지 받는다: for m := ___ ch",
          "收到 channel 閂為止：for m := ___ ch"
        ),
        code = L(
          [[
for m := ___ ch {       // ends when ch is closed
    serve(m)
}
]],
          [[
for m := ___ ch {       // ch가 닫히면 끝
    serve(m)
}
]],
          [[
for m := ___ ch {       // ch 閂咗就完
    serve(m)
}
]]
        ),
        answer = "range",
        accept = { "range" },
        hint = L(
          "Same keyword as for slices. No index; just the value.",
          "슬라이스와 같은 키워드. 인덱스 없이 값만.",
          "同 slice 一樣嘅關鍵字。冇 index，淨係值。"
        ),
        ok = L(
          "range over a channel ends when the sender calls close. Without close it blocks forever.",
          "채널 range는 보내는 쪽이 close하면 끝. close 없으면 영원히 블록.",
          "range channel 會喺 sender close 嘅時候完。冇 close 就永遠 block。"
        ),
      },
      {
        topic = "DEADLOCK",
        q = L(
          "main sends on an unbuffered channel with nobody receiving. The runtime reports: all goroutines are asleep - ___!",
          "main이 받는 쪽 없이 버퍼 없는 채널에 보낸다. 런타임 메시지: all goroutines are asleep - ___!",
          "main 喺冇人收嘅情況下向冇 buffer 嘅 channel send。runtime 報：all goroutines are asleep - ___!"
        ),
        code = L(
          [[
ch := make(chan int)
ch <- 1                // nobody receives
fmt.Println(<-ch)
// fatal error: all goroutines are asleep - ___!
]],
          [[
ch := make(chan int)
ch <- 1                // 받는 쪽이 없음
fmt.Println(<-ch)
// fatal error: all goroutines are asleep - ___!
]],
          [[
ch := make(chan int)
ch <- 1                // 冇人收
fmt.Println(<-ch)
// fatal error: all goroutines are asleep - ___!
]]
        ),
        answer = "deadlock",
        accept = { "deadlock" },
        hint = L(
          "Eight letters: every goroutine waits on every other. The send never returns.",
          "여덟 글자: 모든 고루틴이 서로를 기다린다. send가 절대 돌아오지 않는다.",
          "八個字母：每個 goroutine 都等緊其他。個 send 永遠唔會 return。"
        ),
        ok = L(
          "An unbuffered send needs a receiver already waiting. Put the send in a goroutine or buffer the channel.",
          "버퍼 없는 send는 이미 기다리는 receiver가 필요. send를 고루틴에 넣거나 채널에 버퍼를.",
          "冇 buffer 嘅 send 要有人已經等緊收。將 send 放入 goroutine 或者畀個 buffer。"
        ),
      },
      {
        topic = "DONE",
        q = L(
          "A done signal that carries no data. Fill the element type: make(chan ___)",
          "데이터 없는 완료 신호. 원소 타입: make(chan ___)",
          "冇資料嘅 done 訊號。元素 type：make(chan ___)"
        ),
        code = L(
          [[
done := make(chan ___)   // zero bytes per value
go func() {
    cook()
    close(done)
}()
<-done
]],
          [[
done := make(chan ___)   // 값당 0바이트
go func() {
    cook()
    close(done)
}()
<-done
]],
          [[
done := make(chan ___)   // 每個值零 byte
go func() {
    cook()
    close(done)
}()
<-done
]]
        ),
        answer = "struct{}",
        accept = { "struct{}" },
        hint = L(
          "An empty struct. Zero size. The idiom for 'just a signal'.",
          "빈 구조체. 크기 0. '신호만'의 관용구.",
          "空 struct。零大小。「淨係一個訊號」嘅慣用寫法。"
        ),
        ok = L(
          "chan struct{} plus close is the cheapest done signal. context.Done() returns one.",
          "chan struct{}와 close가 가장 싼 완료 신호. context.Done()도 이걸 반환.",
          "chan struct{} 加 close 係最平嘅 done 訊號。context.Done() 回傳嘅就係呢個。"
        ),
      },
    },
  },

  {
    id = "bell",
    station = "SELECT",
    name = L("The bell", "벨", "叫號鈴"),
    title = L("select", "select", "select"),
    lesson = L(
      "select waits on several channel ops. default is the non-blocking branch.",
      "select는 여러 채널 연산을 기다린다. default는 비차단 분기.",
      "select 等幾個 channel 操作。default 係非阻塞分支。"
    ),
    bg = "bg_till",
    portrait = "portrait_clerk",
    speaker = L("Siu Ming", "시우밍", "小明"),
    ground = 348,
    spawn = 180,
    width = 1600,
    npcs = {
      {
        kind = "clerk",
        x = 500,
        facing = 1,
        line = L(
          "Muffin ready, or hash brown, or timeout. Pick one.",
          "머핀이 됐거나, 해시브라운, 아니면 타임아웃. 하나 골라.",
          "鬆餅好、薯餅好、定 timeout。揀一個。"
        ),
      },
    },
    viz = "bell",
    story = L(
      "The pickup bell is a select. Whichever channel is ready first wins. "
        .. "If none are ready, default fires instead of blocking the till.",
      "픽업 벨은 select. 먼저 준비된 채널이 이긴다. "
        .. "아무도 준비되지 않으면 default가 계산대를 막지 않고 실행된다.",
      "叫號鈴係 select。邊個 channel 先準備好就贏。"
        .. "如果都未準備，default 會行，唔會堵住收銀。"
    ),
    stages = {
      {
        topic = "SELECT",
        q = L(
          "Wait on muffin or hash brown, whichever is ready. Which keyword?",
          "머핀 또는 해시브라운, 준비된 쪽을 기다린다. 키워드는?",
          "等鬆餅定薯餅，邊個準備好。邊個 keyword？"
        ),
        code = L(
          [[
___ {
case m := <-muffin:
    serve(m)
case h := <-hash:
    serve(h)
}
]],
          [[
___ {
case m := <-muffin:
    serve(m)
case h := <-hash:
    serve(h)
}
]],
          [[
___ {
case m := <-muffin:
    serve(m)
case h := <-hash:
    serve(h)
}
]]
        ),
        accept = { "select" },
        answer = "select",
        hint = L(
          "Looks like switch, but every case is a channel send or receive.",
          "switch처럼 보이지만 모든 case는 채널 보내기 또는 받기.",
          "好似 switch，但每個 case 都係 channel 送或收。"
        ),
        ok = L(
          "select { case x := <-ch: ... }. Random choice if several are ready.",
          "select { case x := <-ch: ... }. 여럿이 준비되면 무작위.",
          "select { case x := <-ch: ... }。幾個都準備就隨機。"
        ),
      },
      {
        topic = "DEFAULT",
        q = L(
          "Do not block if nothing is ready. Which case label?",
          "준비된 것이 없으면 막지 않는다. 어떤 case 라벨?",
          "冇嘢準備好就唔好堵住。邊個 case 標籤？"
        ),
        code = L(
          [[
select {
case m := <-muffin:
    serve(m)
___:
    skip()
}
]],
          [[
select {
case m := <-muffin:
    serve(m)
___:
    skip()
}
]],
          [[
select {
case m := <-muffin:
    serve(m)
___:
    skip()
}
]]
        ),
        accept = { "default" },
        answer = "default",
        hint = L(
          "Same word as in switch. Turns select into a poll.",
          "switch와 같은 단어. select를 폴로 만든다.",
          "同 switch 同一個字。將 select 變成 poll。"
        ),
        ok = L(
          "default: runs when every channel would block. The till stays free.",
          "default: 모든 채널이 막을 때 실행. 계산대는 비어 있다.",
          "default：每個 channel 都會堵住嗰陣行。收銀保持空閒。"
        ),
      },
      {
        topic = "TIMEOUT",
        q = L(
          "Give up after one second. Fill: case <-time.___(time.Second)",
          "1초 후 포기: case <-time.___(time.Second)",
          "一秒之後放棄：case <-time.___(time.Second)"
        ),
        code = L(
          [[
select {
case m := <-muffin:
    serve(m)
case <-time.___(time.Second):
    fmt.Println("timeout")
}
]],
          [[
select {
case m := <-muffin:
    serve(m)
case <-time.___(time.Second):
    fmt.Println("timeout")
}
]],
          [[
select {
case m := <-muffin:
    serve(m)
case <-time.___(time.Second):
    fmt.Println("timeout")
}
]]
        ),
        answer = "After",
        accept = { "After" },
        hint = L(
          "Returns a channel that fires once, later. Capital A.",
          "나중에 한 번 울리는 채널을 반환. 대문자 A.",
          "回傳一個遲啲響一次嘅 channel。大寫 A。"
        ),
        ok = L(
          "time.After in a select is the classic timeout. In a loop prefer a time.Timer.",
          "select 안의 time.After가 고전적인 타임아웃. 루프에서는 time.Timer가 낫다.",
          "select 入面用 time.After 係經典 timeout。喺 loop 入面用 time.Timer 好啲。"
        ),
      },
      {
        topic = "CANCEL",
        q = L(
          "Stop when the guest walks out. Fill: case <-ctx.___()",
          "손님이 나가면 멈춤: case <-ctx.___()",
          "客人走咗就停：case <-ctx.___()"
        ),
        code = L(
          [[
select {
case m := <-muffin:
    serve(m)
case <-ctx.___():
    return ctx.Err()
}
]],
          [[
select {
case m := <-muffin:
    serve(m)
case <-ctx.___():
    return ctx.Err()
}
]],
          [[
select {
case m := <-muffin:
    serve(m)
case <-ctx.___():
    return ctx.Err()
}
]]
        ),
        answer = "Done",
        accept = { "Done" },
        hint = L(
          "A method on context.Context. Its channel closes on cancel.",
          "context.Context의 메서드. 취소되면 그 채널이 닫힌다.",
          "context.Context 嘅 method。cancel 嘅時候佢個 channel 會閂。"
        ),
        ok = L(
          "ctx.Done() closes on cancel or deadline; ctx.Err() says which one.",
          "ctx.Done()은 취소나 마감 시 닫힌다; ctx.Err()가 어느 쪽인지 알려준다.",
          "ctx.Done() 喺 cancel 或者 deadline 會閂；ctx.Err() 話你知係邊個。"
        ),
      },
    },
  },

  {
    id = "tray",
    station = "SYNC",
    name = L("The tray rail", "트레이 레일", "餐盤軌"),
    title = L("Mutex and WaitGroup", "Mutex와 WaitGroup", "Mutex 同 WaitGroup"),
    lesson = L(
      "Mutex locks shared memory. WaitGroup waits for a set of goroutines to finish.",
      "Mutex는 공유 메모리를 잠근다. WaitGroup은 고루틴 무리가 끝나기를 기다린다.",
      "Mutex 鎖共享 memory。WaitGroup 等一組 goroutine 做完。"
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
        x = 500,
        facing = 1,
        line = L(
          "Two hands, one tray counter. Lock it. Then wait for both cooks.",
          "손 둘, 카운터 하나. 잠가. 그다음 요리사 둘을 기다려.",
          "兩隻手，一個櫃檯。鎖住。然後等兩個廚師。"
        ),
      },
    },
    viz = "tray",
    story = L(
      "Two cooks increment the same tray count. Without a lock that is a race. "
        .. "WaitGroup.Add, Done, Wait is how the pass knows both items are ready.",
      "요리사 둘이 같은 트레이 수를 올린다. 잠금이 없으면 레이스. "
        .. "WaitGroup.Add, Done, Wait로 출창은 둘 다 준비됐음을 안다.",
      "兩個廚師加同一個餐盤數。冇鎖就係 race。"
        .. "WaitGroup.Add、Done、Wait 等出餐口知兩樣都好。"
    ),
    stages = {
      {
        topic = "MUTEX",
        q = L(
          "Lock a shared counter. Fill the type: var mu sync.___",
          "공유 카운터를 잠근다. 타입: var mu sync.___",
          "鎖共享計數器。類型：var mu sync.___"
        ),
        code = L(
          [[
var mu sync.___
mu.Lock()
count++
mu.Unlock()
]],
          [[
var mu sync.___
mu.Lock()
count++
mu.Unlock()
]],
          [[
var mu sync.___
mu.Lock()
count++
mu.Unlock()
]]
        ),
        accept = { "Mutex", "mutex" },
        answer = "Mutex",
        hint = L(
          "Mutual exclusion. Capital M. In package sync.",
          "상호 배제. 대문자 M. sync 패키지.",
          "互相排除。大階 M。喺 sync package。"
        ),
        ok = L(
          "sync.Mutex. Lock, change, Unlock. Prefer channels when you can.",
          "sync.Mutex. Lock, 변경, Unlock. 가능하면 채널을 선호.",
          "sync.Mutex。Lock、改、Unlock。可以嘅話寧願用 channel。"
        ),
      },
      {
        topic = "WAIT",
        q = L(
          "Wait until both cooks call Done. Fill: var wg sync.___",
          "요리사 둘이 Done을 호출할 때까지 기다린다. 타입: var wg sync.___",
          "等兩個廚師都 call Done。類型：var wg sync.___"
        ),
        code = L(
          [[
var wg sync.___
wg.Add(2)
go cook(&wg)
wg.Wait()
]],
          [[
var wg sync.___
wg.Add(2)
go cook(&wg)
wg.Wait()
]],
          [[
var wg sync.___
wg.Add(2)
go cook(&wg)
wg.Wait()
]]
        ),
        accept = { "WaitGroup", "waitgroup" },
        answer = "WaitGroup",
        hint = L(
          "Add before you go. Done in the goroutine. Wait in main.",
          "go 전에 Add. 고루틴 안에서 Done. main에서 Wait.",
          "go 之前 Add。goroutine 入面 Done。main 度 Wait。"
        ),
        ok = L(
          "WaitGroup.Add(n), Done(), Wait(). The tray leaves when n hits zero.",
          "WaitGroup.Add(n), Done(), Wait(). n이 0이 되면 트레이가 떠난다.",
          "WaitGroup.Add(n)、Done()、Wait()。n 到 0 餐盤先走。"
        ),
      },
      {
        topic = "UNLOCK",
        q = L(
          "Release the lock however the function exits. Fill: defer mu.___()",
          "함수가 어떻게 끝나든 락을 해제: defer mu.___()",
          "無論 function 點樣完都要放鎖：defer mu.___()"
        ),
        code = L(
          [[
mu.Lock()
defer mu.___()          // even on panic
count++
]],
          [[
mu.Lock()
defer mu.___()          // panic이어도
count++
]],
          [[
mu.Lock()
defer mu.___()          // panic 都會
count++
]]
        ),
        answer = "Unlock",
        accept = { "Unlock" },
        hint = L(
          "The opposite of Lock. defer it on the very next line.",
          "Lock의 반대. 바로 다음 줄에서 defer.",
          "Lock 嘅相反。即刻下一行就 defer。"
        ),
        ok = L(
          "Lock; defer Unlock is the pattern. A forgotten Unlock deadlocks the next caller.",
          "Lock; defer Unlock이 패턴. Unlock을 잊으면 다음 호출자가 데드락.",
          "Lock; defer Unlock 係固定寫法。唔記得 Unlock，下一個 caller 就 deadlock。"
        ),
      },
      {
        topic = "RWMUTEX",
        q = L(
          "Many readers at once, one writer. Fill the read lock: mu.___()",
          "여러 reader 동시에, writer는 하나. 읽기 락: mu.___()",
          "好多 reader 一齊，一個 writer。read lock：mu.___()"
        ),
        code = L(
          [[
var mu sync.RWMutex
mu.___()                // readers share
n := count
mu.RUnlock()
]],
          [[
var mu sync.RWMutex
mu.___()                // reader들은 공유
n := count
mu.RUnlock()
]],
          [[
var mu sync.RWMutex
mu.___()                // reader 可以共用
n := count
mu.RUnlock()
]]
        ),
        answer = "RLock",
        accept = { "RLock" },
        hint = L(
          "R then Lock. Writers still use Lock and Unlock.",
          "R 다음 Lock. writer는 여전히 Lock과 Unlock.",
          "R 然後 Lock。writer 仍然用 Lock 同 Unlock。"
        ),
        ok = L(
          "RWMutex: RLock for readers, Lock for the one writer. Use it when reads dominate.",
          "RWMutex: reader는 RLock, writer 하나는 Lock. 읽기가 많을 때 사용.",
          "RWMutex：reader 用 RLock，唯一嘅 writer 用 Lock。讀多過寫嘅時候用。"
        ),
      },
      {
        topic = "ATOMIC",
        q = L(
          "Increment a counter without a mutex. Which package? ___.AddInt64(&count, 1)",
          "뮤텍스 없이 카운터 증가. 어떤 패키지? ___.AddInt64(&count, 1)",
          "唔用 mutex 去加 counter。咩 package？___.AddInt64(&count, 1)"
        ),
        code = L(
          [[
import "sync/___"
var count int64
___.AddInt64(&count, 1)   // lock-free
]],
          [[
import "sync/___"
var count int64
___.AddInt64(&count, 1)   // 락 없음
]],
          [[
import "sync/___"
var count int64
___.AddInt64(&count, 1)   // 冇鎖
]]
        ),
        answer = "atomic",
        accept = { "atomic" },
        hint = L(
          "Six letters, under sync/. Go 1.19 also has atomic.Int64 with .Add(1).",
          "여섯 글자, sync/ 아래. Go 1.19부터 atomic.Int64의 .Add(1)도 있다.",
          "六個字母，喺 sync/ 下面。Go 1.19 都有 atomic.Int64 嘅 .Add(1)。"
        ),
        ok = L(
          "sync/atomic is for single words: counters, flags. Anything bigger wants a Mutex.",
          "sync/atomic은 단일 워드용: 카운터, 플래그. 더 크면 Mutex.",
          "sync/atomic 係畀單一 word 用：counter、flag。再大就要 Mutex。"
        ),
      },
      {
        topic = "ONCE",
        q = L(
          "Warm the grill exactly once, however many cooks call it. Fill: var once sync.___",
          "요리사가 몇 명이 부르든 그릴은 딱 한 번 예열: var once sync.___",
          "無論幾多個廚師 call，燒烤爐淨係熱一次：var once sync.___"
        ),
        code = L(
          [[
var once sync.___
func grill() {
    once.Do(warm)      // warm runs one time
}
]],
          [[
var once sync.___
func grill() {
    once.Do(warm)      // warm은 한 번만 실행
}
]],
          [[
var once sync.___
func grill() {
    once.Do(warm)      // warm 淨係行一次
}
]]
        ),
        answer = "Once",
        accept = { "Once" },
        hint = L(
          "Four letters, capital O. Its only method is Do.",
          "네 글자, 대문자 O. 메서드는 Do 하나.",
          "四個字母，大寫 O。唯一嘅 method 係 Do。"
        ),
        ok = L(
          "sync.Once.Do runs the function once and blocks the others until it finishes. Go 1.21 adds sync.OnceValue.",
          "sync.Once.Do는 함수를 한 번 실행하고 끝날 때까지 다른 쪽을 막는다. Go 1.21에 sync.OnceValue 추가.",
          "sync.Once.Do 行一次個 function，其他人等佢完。Go 1.21 加咗 sync.OnceValue。"
        ),
      },
      {
        topic = "ERRGROUP",
        q = L(
          "Run the cooks, stop on the first error, wait for all. Fill: g.___()",
          "요리사들을 돌리고, 첫 에러에 멈추고, 전부 기다린다: g.___()",
          "開晒啲廚師，第一個 error 就停，等晒全部：g.___()"
        ),
        code = L(
          [[
g, ctx := errgroup.WithContext(ctx)
for _, item := range items {
    g.Go(func() error { return cook(ctx, item) })
}
if err := g.___(); err != nil {   // first error
    return err
}
]],
          [[
g, ctx := errgroup.WithContext(ctx)
for _, item := range items {
    g.Go(func() error { return cook(ctx, item) })
}
if err := g.___(); err != nil {   // 첫 에러
    return err
}
]],
          [[
g, ctx := errgroup.WithContext(ctx)
for _, item := range items {
    g.Go(func() error { return cook(ctx, item) })
}
if err := g.___(); err != nil {   // 第一個 error
    return err
}
]]
        ),
        answer = "Wait",
        accept = { "Wait" },
        hint = L(
          "Same word as WaitGroup's. It returns the first non-nil error.",
          "WaitGroup과 같은 단어. 첫 non-nil 에러를 반환.",
          "同 WaitGroup 一樣嘅字。回傳第一個非 nil 嘅 error。"
        ),
        ok = L(
          "golang.org/x/sync/errgroup: WaitGroup plus errors plus context cancel. The interview answer for fan-out.",
          "golang.org/x/sync/errgroup: WaitGroup + 에러 + context 취소. fan-out 면접 정답.",
          "golang.org/x/sync/errgroup：WaitGroup 加 error 加 context cancel。fan-out 嘅面試標準答案。"
        ),
      },
      {
        topic = "RACE",
        q = L(
          "Ask the tool chain to find data races at run time. Fill the flag: go test ___ ./...",
          "실행 중 데이터 레이스를 찾도록 도구에 요청. 플래그: go test ___ ./...",
          "叫 toolchain 喺運行時搵 data race。flag：go test ___ ./..."
        ),
        code = L(
          [[
$ go test ___ ./...
WARNING: DATA RACE
Write at 0x00c0000 by goroutine 7
]],
          [[
$ go test ___ ./...
WARNING: DATA RACE
Write at 0x00c0000 by goroutine 7
]],
          [[
$ go test ___ ./...
WARNING: DATA RACE
Write at 0x00c0000 by goroutine 7
]]
        ),
        answer = "-race",
        accept = { "-race", "race" },
        hint = L(
          "A flag: dash then four letters. Works with run and build too.",
          "플래그: 대시 다음 네 글자. run과 build에도 된다.",
          "一個 flag：一橫然後四個字母。run 同 build 都用得。"
        ),
        ok = L(
          "go test -race catches unsynchronized access while the tests run. Turn it on in CI.",
          "go test -race는 테스트 실행 중 동기화 안 된 접근을 잡는다. CI에서 켤 것.",
          "go test -race 喺測試行嘅時候捉冇同步嘅存取。CI 要開住。"
        ),
      },
    },
  },

  {
    id = "table",
    station = "GENERIC",
    name = L("The booth", "부스", "卡位"),
    title = L("Generics, embedding, closures", "제네릭, 임베딩, 클로저", "Generics、嵌入、closure"),
    lesson = L(
      "Type parameters go in [T any]. Embedding promotes methods. A closure captures nearby names.",
      "타입 매개변수는 [T any]. 임베딩은 메서드를 올린다. 클로저는 근처 이름을 붙잡는다.",
      "類型參數寫 [T any]。嵌入會提升 method。closure 捉附近嘅名。"
    ),
    bg = "bg_set",
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
          "One function for muffin or hash brown. Don't copy-paste.",
          "머핀이든 해시브라운이든 함수 하나. 복붙하지 마.",
          "鬆餅定薯餅都用同一個 function。唔好 copy-paste。"
        ),
      },
    },
    viz = "table",
    story = L(
      "The booth code used to duplicate fry for every item. Generics write it once. "
        .. "A Kitchen that embeds Grill gets Grill's methods for free.",
      "부스 코드는 품목마다 fry를 복제했다. 제네릭은 한 번만 쓴다. "
        .. "Grill을 임베드한 Kitchen은 Grill의 메서드를 공짜로 얻는다.",
      "卡位程式以前每個食物都複製 fry。Generics 寫一次。"
        .. "嵌入 Grill 嘅 Kitchen 免費得到 Grill 嘅 method。"
    ),
    stages = {
      {
        topic = "GENERIC",
        q = L(
          "A type parameter that accepts anything. Fill: func ident[T ___](v T) T",
          "무엇이든 받는 타입 매개변수. 채우세요: func ident[T ___](v T) T",
          "接受任何嘢嘅類型參數。填：func ident[T ___](v T) T"
        ),
        code = L(
          [[
func ident[T ___](v T) T {
    return v
}
]],
          [[
func ident[T ___](v T) T {
    return v
}
]],
          [[
func ident[T ___](v T) T {
    return v
}
]]
        ),
        accept = { "any", "interface{}" },
        answer = "any",
        hint = L(
          "Alias for interface{}. The constraint that allows every type.",
          "interface{}의 별칭. 모든 타입을 허용하는 제약.",
          "interface{} 嘅別名。允許所有類型嘅約束。"
        ),
        ok = L(
          "[T any] is the widest constraint. comparable is for map keys.",
          "[T any]가 가장 넓은 제약. comparable은 맵 키용.",
          "[T any] 係最闊約束。comparable 用嚟做 map key。"
        ),
      },
      {
        topic = "EMBED",
        q = L(
          "Kitchen should gain Grill's methods without wrapping. Put Grill where?",
          "Kitchen이 감싸지 않고 Grill의 메서드를 얻는다. Grill을 어디에?",
          "Kitchen 唔使包裝都得到 Grill 嘅 method。Grill 放邊？"
        ),
        code = L(
          [[
type Kitchen struct {
    ___                  // promoted methods
}
]],
          [[
type Kitchen struct {
    ___                  // 승격된 메서드
}
]],
          [[
type Kitchen struct {
    ___                  // 提升咗嘅 method
}
]]
        ),
        accept = { "Grill" },
        answer = "Grill",
        hint = L(
          "A field with no name, only the type. That is embedding.",
          "이름 없이 타입만 있는 필드. 그게 임베딩.",
          "冇名淨係類型嘅欄位。呢個就係嵌入。"
        ),
        ok = L(
          "type Kitchen struct { Grill }. k.Toast() calls Grill.Toast.",
          "type Kitchen struct { Grill }. k.Toast()는 Grill.Toast를 호출.",
          "type Kitchen struct { Grill }。k.Toast() 會 call Grill.Toast。"
        ),
      },
      {
        topic = "CLOSURE",
        q = L(
          "A function that remembers n after ident returns. What is that function called?",
          "ident가 반환한 뒤에도 n을 기억하는 함수. 그 함수의 이름은?",
          "ident return 之後仲記得 n 嘅 function。嗰個 function 叫咩？"
        ),
        code = L(
          [[
func add(n int) func(int) int {
    return func(x int) int {
        return x + n     // a ___
    }
}
]],
          [[
func add(n int) func(int) int {
    return func(x int) int {
        return x + n     // ___
    }
}
]],
          [[
func add(n int) func(int) int {
    return func(x int) int {
        return x + n     // 一個 ___
    }
}
]]
        ),
        accept = { "closure", "closure." },
        answer = "closure",
        hint = L(
          "It closes over n. Inner func, outer variable.",
          "n을 닫아 넣는다. 안쪽 함수, 바깥 변수.",
          "佢 close 住 n。入面 function，外面變數。"
        ),
        ok = L(
          "A closure captures n. Each call to add(2) has its own n.",
          "클로저는 n을 붙잡는다. add(2)를 호출할 때마다 자신의 n.",
          "closure 捉住 n。每次 call add(2) 都有自己嘅 n。"
        ),
      },
      {
        topic = "COMPARABLE",
        q = L(
          "Map keys must support ==. Fill the constraint: func Has[K ___](m map[K]bool, k K)",
          "맵 키는 ==가 돼야 한다. 제약: func Has[K ___](m map[K]bool, k K)",
          "map key 一定要支援 ==。constraint：func Has[K ___](m map[K]bool, k K)"
        ),
        code = L(
          [[
func Has[K ___](m map[K]bool, k K) bool {
    _, ok := m[k]
    return ok
}
]],
          [[
func Has[K ___](m map[K]bool, k K) bool {
    _, ok := m[k]
    return ok
}
]],
          [[
func Has[K ___](m map[K]bool, k K) bool {
    _, ok := m[k]
    return ok
}
]]
        ),
        answer = "comparable",
        accept = { "comparable" },
        hint = L(
          "The built-in constraint for types that allow == and !=.",
          "==와 !=가 되는 타입을 위한 내장 제약.",
          "支援 == 同 != 嘅 type 用嘅內置 constraint。"
        ),
        ok = L(
          "comparable for map keys and ==. any allows everything but promises nothing.",
          "맵 키와 ==에는 comparable. any는 다 허용하지만 아무것도 보장하지 않는다.",
          "map key 同 == 用 comparable。any 咩都容許但係咩都唔保證。"
        ),
      },
      {
        topic = "UNION",
        q = L(
          "A constraint that allows int and every type built on int. Fill: ___int | ___float64",
          "int와 int 기반 타입 전부를 허용하는 제약: ___int | ___float64",
          "容許 int 同所有底層係 int 嘅 type 嘅 constraint：___int | ___float64"
        ),
        code = L(
          [[
type Number interface {
    ___int | ___float64      // underlying types
}
func Sum[T Number](xs []T) T
]],
          [[
type Number interface {
    ___int | ___float64      // 기반 타입
}
func Sum[T Number](xs []T) T
]],
          [[
type Number interface {
    ___int | ___float64      // 底層 type
}
func Sum[T Number](xs []T) T
]]
        ),
        answer = "~",
        accept = { "~" },
        hint = L(
          "Tilde. Without it, type Cents int would not satisfy Number.",
          "물결표. 없으면 type Cents int는 Number를 만족하지 않는다.",
          "波浪號。冇佢嘅話 type Cents int 唔會滿足 Number。"
        ),
        ok = L(
          "~T means 'underlying type T'. | joins the choices. See constraints.Ordered.",
          "~T는 '기반 타입이 T'. |가 선택지를 잇는다. constraints.Ordered 참고.",
          "~T 即係「底層 type 係 T」。| 連埋啲選擇。睇下 constraints.Ordered。"
        ),
      },
    },
  },

  {
    id = "set",
    station = "CONTEXT",
    name = L("The morning set", "모닝세트", "早餐套餐"),
    title = L("Context and tests", "컨텍스트와 테스트", "context 同 test"),
    lesson = L(
      "context carries deadlines and cancel. go test runs Test* in _test.go.",
      "context는 기한과 취소를 나른다. go test는 _test.go의 Test*를 실행한다.",
      "context 帶期限同取消。go test 跑 _test.go 入面嘅 Test*。"
    ),
    bg = "bg_set",
    portrait = "portrait_hero",
    speaker = L("Alex", "알렉스", "阿力"),
    ground = 348,
    spawn = 200,
    width = 1680,
    npcs = {
      {
        kind = "mei",
        x = 420,
        facing = 1,
        line = L(
          "Steam. Hash brown. We did it.",
          "김. 해시브라운. 해냈어.",
          "蒸氣。薯餅。我哋得咗。"
        ),
      },
      {
        kind = "clerk",
        x = 720,
        facing = -1,
        line = L(
          "Order 18. Morning set. Don't forget to cancel the context.",
          "18번. 모닝세트. 컨텍스트 취소 잊지 마.",
          "18號。早餐套餐。唔好唔記得 cancel context。"
        ),
      },
      {
        kind = "cook",
        x = 980,
        facing = -1,
        line = L(
          "If the guest leaves, cancel. The fryer stops.",
          "손님이 떠나면 취소. 튀김기가 멈춘다.",
          "客人走就 cancel。炸爐會停。"
        ),
      },
    },
    viz = "set",
    story = L(
      "The tray is on the table. One last lesson: a request has a context so the "
        .. "kitchen can stop if the guest walks out. And a test so the next morning still compiles.",
      "트레이가 테이블 위에. 마지막 수업: 요청에는 context가 있어서 "
        .. "손님이 나가면 주방이 멈춘다. 그리고 다음 아침도 컴파일되게 하는 테스트.",
      "餐盤喺枱上面。最後一課：請求有 context，客人走出廚房可以停。"
        .. "仲有 test，第二朝都 compile 到。"
    ),
    stages = {
      {
        topic = "CONTEXT",
        q = L(
          "The root of every request tree. Fill: ctx := context.___()",
          "모든 요청 트리의 뿌리. 채우세요: ctx := context.___()",
          "每個請求樹嘅根。填：ctx := context.___()"
        ),
        code = L(
          [[
ctx := context.___()
ctx, cancel := context.WithCancel(ctx)
defer cancel()
]],
          [[
ctx := context.___()
ctx, cancel := context.WithCancel(ctx)
defer cancel()
]],
          [[
ctx := context.___()
ctx, cancel := context.WithCancel(ctx)
defer cancel()
]]
        ),
        accept = { "Background" },
        answer = "Background",
        hint = L(
          "Not TODO (that is a placeholder). The empty, never-cancelled root.",
          "TODO가 아님 (그건 자리 표시). 비어 있고 취소되지 않는 뿌리.",
          "唔係 TODO（嗰個係佔位）。空嘅、永遠唔 cancel 嘅根。"
        ),
        ok = L(
          "context.Background() then WithCancel. Always defer cancel().",
          "context.Background() 다음에 WithCancel. 항상 defer cancel().",
          "context.Background() 然後 WithCancel。永遠 defer cancel()。"
        ),
      },
      {
        topic = "TEST",
        q = L(
          "A test function in order_test.go. Fill the name prefix: func ___(t *testing.T)",
          "order_test.go의 테스트 함수. 이름 접두사: func ___(t *testing.T)",
          "order_test.go 入面嘅 test function。名前綴：func ___(t *testing.T)"
        ),
        code = L(
          [[
func ___(t *testing.T) {
    t.Run("set", func(t *testing.T) {})
}
]],
          [[
func ___(t *testing.T) {
    t.Run("set", func(t *testing.T) {})
}
]],
          [[
func ___(t *testing.T) {
    t.Run("set", func(t *testing.T) {})
}
]]
        ),
        accept = { "TestOrder", "TestFoo", "TestX", "TestSet", "Test" },
        answer = "TestOrder",
        hint = L(
          "Must start with Test and take *testing.T. File name ends with _test.go.",
          "Test로 시작하고 *testing.T를 받는다. 파일 이름은 _test.go로 끝.",
          "一定要以 Test 開頭，收 *testing.T。檔名以 _test.go 結尾。"
        ),
        ok = L(
          "func TestOrder(t *testing.T). go test ./...  The morning set is served.",
          "func TestOrder(t *testing.T). go test ./...  모닝세트가 나온다.",
          "func TestOrder(t *testing.T)。go test ./...  早餐套餐出嚟。"
        ),
      },
      {
        topic = "TIMEOUT",
        q = L(
          "Cancel automatically after two seconds. Fill: context.___(ctx, 2*time.Second)",
          "2초 후 자동 취소: context.___(ctx, 2*time.Second)",
          "兩秒之後自動 cancel：context.___(ctx, 2*time.Second)"
        ),
        code = L(
          [[
ctx, cancel := context.___(ctx, 2*time.Second)
defer cancel()          // always
]],
          [[
ctx, cancel := context.___(ctx, 2*time.Second)
defer cancel()          // 항상
]],
          [[
ctx, cancel := context.___(ctx, 2*time.Second)
defer cancel()          // 一定要
]]
        ),
        answer = "WithTimeout",
        accept = { "WithTimeout" },
        hint = L(
          "With, then the word for a time limit. WithDeadline takes a clock time instead.",
          "With 다음 시간 제한을 뜻하는 단어. WithDeadline은 시각을 받는다.",
          "With，然後係時限嗰個字。WithDeadline 收嘅係一個時間點。"
        ),
        ok = L(
          "WithTimeout returns a child that cancels itself. Always defer cancel() or you leak.",
          "WithTimeout은 스스로 취소되는 자식을 반환. defer cancel()을 잊으면 누수.",
          "WithTimeout 回傳一個會自己 cancel 嘅 child。一定要 defer cancel()，唔係會 leak。"
        ),
      },
      {
        topic = "ERRORF",
        q = L(
          'Report a failed check and keep the test running. Fill: t.___("got %d", n)',
          '실패를 보고하고 테스트는 계속: t.___("got %d", n)',
          '報告一個失敗嘅檢查，但係測試繼續行：t.___("got %d", n)'
        ),
        code = L(
          [[
func TestPrice(t *testing.T) {
    if n := price("set"); n != 25 {
        t.___("got %d, want 25", n)
    }
}
]],
          [[
func TestPrice(t *testing.T) {
    if n := price("set"); n != 25 {
        t.___("got %d, want 25", n)
    }
}
]],
          [[
func TestPrice(t *testing.T) {
    if n := price("set"); n != 25 {
        t.___("got %d, want 25", n)
    }
}
]]
        ),
        answer = "Errorf",
        accept = { "Errorf" },
        hint = L(
          "Like fmt.Errorf but on t. Fatalf would stop this test at once.",
          "fmt.Errorf와 비슷하지만 t에. Fatalf는 이 테스트를 즉시 멈춘다.",
          "似 fmt.Errorf 但係喺 t 上面。Fatalf 就會即刻停呢個 test。"
        ),
        ok = L(
          "t.Errorf marks failure and continues; t.Fatalf stops. Table tests loop over cases with t.Run.",
          "t.Errorf는 실패 표시 후 계속; t.Fatalf는 멈춤. 테이블 테스트는 t.Run으로 케이스를 돈다.",
          "t.Errorf 標記失敗然後繼續；t.Fatalf 就停。table test 用 t.Run loop 啲 case。"
        ),
      },
      {
        topic = "BENCH",
        q = L(
          "Time the grill. Fill the prefix: func ___Grill(b *testing.B)",
          "그릴 시간 측정. 접두사: func ___Grill(b *testing.B)",
          "計燒烤爐嘅時間。prefix：func ___Grill(b *testing.B)"
        ),
        code = L(
          [[
func ___Grill(b *testing.B) {
    for i := 0; i < b.N; i++ {
        grill()
    }
}
]],
          [[
func ___Grill(b *testing.B) {
    for i := 0; i < b.N; i++ {
        grill()
    }
}
]],
          [[
func ___Grill(b *testing.B) {
    for i := 0; i < b.N; i++ {
        grill()
    }
}
]]
        ),
        answer = "Benchmark",
        accept = { "Benchmark" },
        hint = L(
          "Nine letters. go test -bench=. runs them.",
          "아홉 글자. go test -bench=.으로 실행.",
          "九個字母。go test -bench=. 會行佢哋。"
        ),
        ok = L(
          "Benchmark* takes *testing.B and loops b.N times. Go 1.24 adds b.Loop().",
          "Benchmark*는 *testing.B를 받고 b.N번 돈다. Go 1.24에 b.Loop() 추가.",
          "Benchmark* 收 *testing.B，loop b.N 次。Go 1.24 加咗 b.Loop()。"
        ),
      },
    },
  },
}

return maps
