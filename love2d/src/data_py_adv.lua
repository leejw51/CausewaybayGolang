-- Quest P2 ADVANCED: the back office. 22:00, behind the kitchen: a rack of
-- blinking servers, two laptops and a whiteboard. The order robot's brain
-- runs on exceptions, generators, decorators, context managers, asyncio,
-- type hints and threads. Chef Bo explains; Mei translates from Rust.
-- Same shape as src/data_py.lua: the blank ___ is NOT written in the code.

local function L(en, ko, yue)
  return { en = en, ko = ko, yue = yue }
end

local maps = {
  {
    id = "py_except",
    station = "EXCEPT",
    name = L("The refund desk", "환불 창구", "退款櫃位"),
    title = L("try, except, raise", "try와 except, raise", "try、except、raise"),
    lesson = L(
      "Errors are exceptions: try runs the risky part, except catches a type, finally always runs, raise throws. Your own errors subclass Exception.",
      "에러는 예외다: try가 위험한 부분을 실행, except가 타입을 잡고, finally는 항상 실행, raise가 던진다. 직접 만든 에러는 Exception을 상속.",
      "錯誤係 exception：try 跑有風險嘅部分，except 捉某個 type，finally 一定會行，raise 掟出去。自己嘅錯誤繼承 Exception。"
    ),
    bg = "bg_till",
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
          "Go returns errors. Python throws them. Catch the one you expect, let the rest fly.",
          "Go는 에러를 반환하고 Python은 던져. 예상한 것만 잡고 나머진 날려 보내.",
          "Go 回傳 error。Python 掟出嚟。捉你預期嗰個，其餘畀佢飛。"
        ),
      },
    },
    viz = "python",
    chips = {
      { "try:", "cyan" },
      { "except ValueError:", "gold" },
      { "finally:", "pink" },
      { 'raise OutOfStock("egg")', "green" },
    },
    note = "try  except  finally  raise  as  Exception",
    story = L(
      "22:00. The back office behind the kitchen: a humming rack, two laptops, a whiteboard with a tree on it. "
        .. "The refund script crashes on the first bad receipt because nobody catches anything. "
        .. "Alex reaches for if err != nil; Bo shakes his head.",
      "22:00. 주방 뒤 사무실: 웅웅대는 서버 랙, 노트북 둘, 트리가 그려진 화이트보드. "
        .. "환불 스크립트는 아무도 예외를 잡지 않아 첫 잘못된 영수증에서 죽는다. 알렉스가 if err != nil을 꺼내려 하자 보가 고개를 젓는다.",
      "晚上十點。廚房後面嘅後勤房：嗡嗡響嘅機架、兩部電腦、畫住一棵樹嘅白板。"
        .. "退款 script 一遇到壞收據就 crash，因為冇人捉錯誤。阿力想寫 if err != nil；寶廚搖頭。"
    ),
    stages = {
      {
        topic = "TRY",
        q = L(
          "Which keyword opens the block whose errors you want to catch?",
          "에러를 잡고 싶은 블록을 여는 키워드는?",
          "邊個 keyword 開始你想捉錯誤嘅 block？"
        ),
        code = L(
          [[
___:
    qty = int(raw)
except ValueError:
    qty = 0
]],
          [[
___:
    qty = int(raw)
except ValueError:
    qty = 0
]],
          [[
___:
    qty = int(raw)
except ValueError:
    qty = 0
]]
        ),
        accept = { "try" },
        answer = "try",
        hint = L(
          "Three letters, a verb: attempt it. The except below only makes sense after this.",
          "세 글자, 동사: 시도해 본다. 아래의 except는 이것 뒤에서만 의미가 있다.",
          "三個字母，一個動詞：試一試。下面嘅 except 要有呢個先有意義。"
        ),
        ok = L(
          "try: guards the risky lines. Rust has Result and ?; Python unwinds the stack to the nearest except.",
          "try:가 위험한 줄을 지킨다. Rust엔 Result와 ?가 있고, Python은 가장 가까운 except까지 스택을 되감는다.",
          "try: 守住有風險嘅幾行。Rust 有 Result 同 ?；Python 就將 stack 一直解到最近嘅 except。"
        ),
      },
      {
        topic = "EXCEPT",
        q = L(
          "int('abc') fails. Which keyword catches that error type?",
          "int('abc')가 실패한다. 그 에러 타입을 잡는 키워드는?",
          "int('abc') 會失敗。邊個 keyword 捉呢個錯誤 type？"
        ),
        code = L(
          [[
try:
    qty = int(raw)
___ ValueError:
    print("not a number:", raw)
    qty = 0
]],
          [[
try:
    qty = int(raw)
___ ValueError:
    print("not a number:", raw)
    qty = 0
]],
          [[
try:
    qty = int(raw)
___ ValueError:
    print("not a number:", raw)
    qty = 0
]]
        ),
        accept = { "except" },
        answer = "except",
        hint = L(
          "Six letters; other languages say catch. Name the type after it, never bare.",
          "여섯 글자. 다른 언어는 catch라 한다. 뒤에 타입을 쓸 것, 빈 채로 두지 말 것.",
          "六個字母；其他語言叫 catch。後面寫個 type，唔要淨係一個字。"
        ),
        ok = L(
          "except ValueError: catches only that. A bare except: swallows everything, even Ctrl-C. Name the type.",
          "except ValueError:는 그것만 잡는다. 빈 except:는 Ctrl-C까지 전부 삼킨다. 타입을 쓰자.",
          "except ValueError: 只捉呢一種。淨係 except: 會吞晒所有嘢，連 Ctrl-C 都吞。寫個 type。"
        ),
      },
      {
        topic = "FINALLY",
        q = L(
          "Close the receipt printer whether the refund worked or not. Which clause always runs?",
          "환불이 되든 안 되든 영수증 프린터를 닫기. 항상 실행되는 절은?",
          "退款成唔成功都要關收據打印機。邊個 clause 一定會行？"
        ),
        code = L(
          [[
try:
    refund(receipt)
except KeyError:
    print("no such receipt")
___:
    printer.close()
]],
          [[
try:
    refund(receipt)
except KeyError:
    print("no such receipt")
___:
    printer.close()
]],
          [[
try:
    refund(receipt)
except KeyError:
    print("no such receipt")
___:
    printer.close()
]]
        ),
        accept = { "finally" },
        answer = "finally",
        hint = L(
          "Seven letters, an adverb: at the end, no matter what. Go's defer.",
          "일곱 글자, 부사: 무슨 일이 있어도 마지막에. Go의 defer.",
          "七個字母，一個副詞：無論如何最後都行。Go 嘅 defer。"
        ),
        ok = L(
          "finally: runs after try and except, even on return or a fresh exception. else: runs only when nothing was raised.",
          "finally:는 try와 except 뒤에, return이나 새 예외가 있어도 실행. else:는 예외가 없었을 때만.",
          "finally: 喺 try 同 except 之後行，就算 return 或者再拋錯都行。else: 只喺冇拋錯嗰陣行。"
        ),
      },
      {
        topic = "RAISE",
        q = L(
          "No eggs left: stop the order with an error. Which keyword throws?",
          "계란이 없다: 에러로 주문을 멈추기. 던지는 키워드는?",
          "冇蛋了：用一個錯誤停止落單。邊個 keyword 掟出去？"
        ),
        code = L(
          [[
def take(stock, item):
    if stock[item] == 0:
        ___ ValueError(f"no {item} left")
    stock[item] -= 1
]],
          [[
def take(stock, item):
    if stock[item] == 0:
        ___ ValueError(f"no {item} left")
    stock[item] -= 1
]],
          [[
def take(stock, item):
    if stock[item] == 0:
        ___ ValueError(f"no {item} left")
    stock[item] -= 1
]]
        ),
        accept = { "raise" },
        answer = "raise",
        hint = L(
          "Five letters; Java and JavaScript say throw. Rust's panic!, but meant to be caught.",
          "다섯 글자. Java와 JavaScript는 throw. Rust의 panic!이지만 잡히도록 만든 것.",
          "五個字母；Java 同 JavaScript 叫 throw。Rust 嘅 panic!，但係預咗畀人捉。"
        ),
        ok = L(
          "raise ValueError(...) throws an instance. A bare raise inside except re-throws the current one.",
          "raise ValueError(...)는 인스턴스를 던진다. except 안의 빈 raise는 현재 예외를 다시 던진다.",
          "raise ValueError(...) 掟一個 instance。except 裏面淨係 raise 會將當前嗰個再掟一次。"
        ),
      },
      {
        topic = "AS",
        q = L(
          "Print the missing key from the error object. Which keyword binds the exception to a name?",
          "에러 객체에서 빠진 키를 출력. 예외를 이름에 묶는 키워드는?",
          "由錯誤 object 印出漏咗嘅 key。邊個 keyword 將 exception 綁到一個名？"
        ),
        code = L(
          [[
try:
    price = menu[dish]
except KeyError ___ e:
    print("unknown dish", e)
]],
          [[
try:
    price = menu[dish]
except KeyError ___ e:
    print("unknown dish", e)
]],
          [[
try:
    price = menu[dish]
except KeyError ___ e:
    print("unknown dish", e)
]]
        ),
        accept = { "as" },
        answer = "as",
        hint = L(
          "Two letters, the same word import and with use to give something a local name.",
          "두 글자, import와 with가 지역 이름을 붙일 때 쓰는 그 단어.",
          "兩個字母，import 同 with 攞嚟畀嘢一個本地名嘅同一個字。"
        ),
        ok = L(
          "except KeyError as e: e is the exception; str(e) is its message, e.args the details. The name dies after the block.",
          "except KeyError as e: e가 예외. str(e)는 메시지, e.args는 세부. 이름은 블록 뒤에 사라진다.",
          "except KeyError as e: e 係個 exception；str(e) 係訊息，e.args 係細節。個名 block 完就冇。"
        ),
      },
      {
        topic = "CUSTOM",
        q = L(
          "Define your own error type for the kitchen. What must it inherit from?",
          "주방용 에러 타입을 직접 정의. 무엇을 상속해야 하나?",
          "為廚房定義自己嘅錯誤 type。必須繼承咩？"
        ),
        code = L(
          [[
class OutOfStock(___):
    pass

raise OutOfStock("egg")
]],
          [[
class OutOfStock(___):
    pass

raise OutOfStock("egg")
]],
          [[
class OutOfStock(___):
    pass

raise OutOfStock("egg")
]]
        ),
        accept = { "Exception" },
        answer = "Exception",
        hint = L(
          "The base class of every catchable error, capital E. Not BaseException: that one includes Ctrl-C.",
          "잡을 수 있는 모든 에러의 기반 클래스, 대문자 E. BaseException은 아님: 그건 Ctrl-C까지 포함.",
          "所有捉得到嘅錯誤嘅 base class，大楷 E。唔係 BaseException：嗰個連 Ctrl-C 都包。"
        ),
        ok = L(
          "class OutOfStock(Exception) is enough. Callers write except OutOfStock:. The refund desk stops crashing.",
          "class OutOfStock(Exception)으로 충분. 호출자는 except OutOfStock:를 쓴다. 환불 창구가 더는 죽지 않는다.",
          "class OutOfStock(Exception) 就夠。caller 寫 except OutOfStock:。退款櫃位唔再 crash。"
        ),
      },
    },
  },
  {
    id = "py_yield",
    station = "YIELD",
    name = L("The conveyor", "컨베이어", "輸送帶"),
    title = L("Generators and iterators", "제너레이터와 이터레이터", "generator 同 iterator"),
    lesson = L(
      "yield turns a function into a generator: it hands out one value at a time and remembers where it was. next pulls one. iter, enumerate and zip are the everyday iterator tools.",
      "yield는 함수를 제너레이터로 만든다: 값을 하나씩 내주고 어디까지 했는지 기억. next가 하나 뽑는다. iter, enumerate, zip이 일상의 이터레이터 도구.",
      "yield 將 function 變成 generator：一次交出一個值，記住行到邊。next 拉一個出嚟。iter、enumerate 同 zip 係日常嘅 iterator 工具。"
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
        x = 520,
        facing = -1,
        line = L(
          "A generator is a Rust iterator that writes itself. yield instead of impl Iterator.",
          "제너레이터는 스스로 써지는 Rust 이터레이터야. impl Iterator 대신 yield.",
          "generator 係一個自己寫自己嘅 Rust iterator。用 yield 代替 impl Iterator。"
        ),
      },
      {
        kind = "cook",
        x = 900,
        facing = -1,
        line = L(
          "The conveyor script loads every bowl into memory at once. Ten thousand bowls.",
          "컨베이어 스크립트가 모든 그릇을 한 번에 메모리에 올려. 만 그릇을.",
          "輸送帶 script 一次將所有碗載入記憶體。一萬碗。"
        ),
      },
    },
    viz = "python",
    chips = {
      { "yield bowl", "cyan" },
      { "next(belt)", "gold" },
      { "enumerate(trays, 1)", "pink" },
      { "zip(names, qtys)", "green" },
    },
    note = "yield  next  iter  enumerate  zip  StopIteration",
    story = L(
      "The conveyor carries bowls from the wok to the pass. Its script builds a list of every bowl "
        .. "of the night before serving the first. A generator would hand them out one at a time, "
        .. "and the belt would never wait.",
      "컨베이어가 웍에서 패스로 그릇을 옮긴다. 스크립트는 첫 그릇을 내기 전에 밤새 나올 그릇 전체의 리스트를 만든다. "
        .. "제너레이터라면 하나씩 내줄 테고 벨트는 기다릴 일이 없다.",
      "輸送帶將碗由鑊送去出餐口。個 script 喺出第一碗之前先砌好成晚所有碗嘅 list。"
        .. "用 generator 就會一碗一碗交出嚟，條帶永遠唔使等。"
    ),
    stages = {
      {
        topic = "YIELD",
        q = L(
          "Hand out one bowl at a time and pause. Which keyword makes a function a generator?",
          "그릇을 하나씩 내주고 멈추기. 함수를 제너레이터로 만드는 키워드는?",
          "一次交出一碗然後暫停。邊個 keyword 令 function 變成 generator？"
        ),
        code = L(
          [[
def belt(orders):
    for o in orders:
        bowl = cook(o)
        ___ bowl

for b in belt(orders):
    serve(b)
]],
          [[
def belt(orders):
    for o in orders:
        bowl = cook(o)
        ___ bowl

for b in belt(orders):
    serve(b)
]],
          [[
def belt(orders):
    for o in orders:
        bowl = cook(o)
        ___ bowl

for b in belt(orders):
    serve(b)
]]
        ),
        accept = { "yield" },
        answer = "yield",
        hint = L(
          "Five letters, meaning 'give way'. Like return, but the function resumes on the next pull.",
          "다섯 글자, '양보하다'라는 뜻. return 같지만 다음에 뽑을 때 함수가 이어서 실행된다.",
          "五個字母，意思係「讓出」。好似 return，但下次拉嗰陣 function 會繼續行。"
        ),
        ok = L(
          "yield suspends the function; the loop resumes it. Nothing is built ahead: one bowl in memory at a time.",
          "yield는 함수를 멈추고 루프가 다시 살린다. 미리 만드는 게 없다: 메모리엔 한 번에 한 그릇.",
          "yield 暫停個 function；loop 再叫醒佢。冇嘢係預先砌好嘅：記憶體一次只有一碗。"
        ),
      },
      {
        topic = "NEXT",
        q = L(
          "Pull exactly one bowl from the generator by hand. Which built-in?",
          "제너레이터에서 손으로 그릇 하나만 뽑기. 어떤 내장 함수?",
          "手動由 generator 拉一碗出嚟。邊個內建 function？"
        ),
        code = L(
          [[
gen = belt(orders)
first = ___(gen)
print(first)
]],
          [[
gen = belt(orders)
first = ___(gen)
print(first)
]],
          [[
gen = belt(orders)
first = ___(gen)
print(first)
]]
        ),
        accept = { "next" },
        answer = "next",
        hint = L(
          "Four letters: the one after this one. Rust's iterator method has the same name.",
          "네 글자: 이것의 다음 것. Rust의 이터레이터 메서드도 같은 이름.",
          "四個字母：呢個之後嗰個。Rust 嘅 iterator method 同名。"
        ),
        ok = L(
          "next(gen) runs to the next yield. next(gen, None) returns None at the end instead of raising.",
          "next(gen)은 다음 yield까지 실행. next(gen, None)은 끝에서 예외 대신 None을 반환.",
          "next(gen) 行到下一個 yield。next(gen, None) 完咗嗰陣回傳 None 而唔係拋錯。"
        ),
      },
      {
        topic = "ITER",
        q = L(
          "A list is not an iterator; get one from it. Which built-in?",
          "리스트는 이터레이터가 아니다. 리스트에서 하나 얻기. 어떤 내장 함수?",
          "list 唔係 iterator；由佢攞一個出嚟。邊個內建 function？"
        ),
        code = L(
          [[
trays = ["egg", "tea", "toast"]
it = ___(trays)
print(next(it))     # egg
print(next(it))     # tea
]],
          [[
trays = ["egg", "tea", "toast"]
it = ___(trays)
print(next(it))     # egg
print(next(it))     # tea
]],
          [[
trays = ["egg", "tea", "toast"]
it = ___(trays)
print(next(it))     # egg
print(next(it))     # tea
]]
        ),
        accept = { "iter" },
        answer = "iter",
        hint = L(
          "Four letters, the start of iterator. A for loop calls it for you.",
          "네 글자, iterator의 앞부분. for 루프가 대신 호출해 준다.",
          "四個字母，iterator 嘅開頭。for loop 會幫你 call。"
        ),
        ok = L(
          "iter(x) calls x.__iter__(); next(it) calls __next__. That pair is the whole iterator protocol.",
          "iter(x)는 x.__iter__()를, next(it)는 __next__를 호출. 그 둘이 이터레이터 프로토콜의 전부.",
          "iter(x) call x.__iter__()；next(it) call __next__。呢一對就係整個 iterator protocol。"
        ),
      },
      {
        topic = "ENUMERATE",
        q = L(
          "Number the trays from 1 while looping. Which built-in pairs an index with each item?",
          "루프 돌면서 트레이에 1부터 번호 붙이기. 각 항목에 인덱스를 짝지어주는 내장 함수는?",
          "loop 嗰陣由 1 開始為盤編號。邊個內建 function 將 index 同每個項目配對？"
        ),
        code = L(
          [[
for i, tray in ___(trays, 1):
    print(i, tray)
# 1 egg / 2 tea / 3 toast
]],
          [[
for i, tray in ___(trays, 1):
    print(i, tray)
# 1 egg / 2 tea / 3 toast
]],
          [[
for i, tray in ___(trays, 1):
    print(i, tray)
# 1 egg / 2 tea / 3 toast
]]
        ),
        accept = { "enumerate" },
        answer = "enumerate",
        hint = L(
          "Nine letters, 'to count off'. Go gives you the index for free in range; Python asks you to wrap the list.",
          "아홉 글자, '하나씩 세다'. Go는 range에서 인덱스를 그냥 준다. Python은 리스트를 감싸라고 한다.",
          "九個字母，「逐個數」。Go 喺 range 免費畀你 index；Python 要你包住個 list。"
        ),
        ok = L(
          "enumerate(xs, start) yields (i, x). Never write for i in range(len(xs)) when you also need xs[i].",
          "enumerate(xs, start)는 (i, x)를 낸다. xs[i]도 필요하다면 for i in range(len(xs))는 쓰지 말자.",
          "enumerate(xs, start) 畀 (i, x)。需要 xs[i] 嗰陣，永遠唔要寫 for i in range(len(xs))。"
        ),
      },
      {
        topic = "ZIP",
        q = L(
          "Walk names and quantities side by side. Which built-in pairs two lists?",
          "이름과 수량을 나란히 순회. 두 리스트를 짝지어주는 내장 함수는?",
          "並排行名同數量。邊個內建 function 將兩個 list 配對？"
        ),
        code = L(
          [[
names = ["egg", "tea"]
qtys = [2, 1]
for name, qty in ___(names, qtys):
    print(qty, "x", name)
]],
          [[
names = ["egg", "tea"]
qtys = [2, 1]
for name, qty in ___(names, qtys):
    print(qty, "x", name)
]],
          [[
names = ["egg", "tea"]
qtys = [2, 1]
for name, qty in ___(names, qtys):
    print(qty, "x", name)
]]
        ),
        accept = { "zip" },
        answer = "zip",
        hint = L(
          "Three letters, like the fastener that joins two sides tooth by tooth.",
          "세 글자, 양쪽을 이 하나씩 맞물려 잇는 그 지퍼처럼.",
          "三個字母，好似拉鏈一樣將兩邊一格一格扣埋。"
        ),
        ok = L(
          "zip stops at the shorter list; zip(a, b, strict=True) raises on a mismatch (3.10). zip(*pairs) unzips.",
          "zip은 짧은 리스트에서 멈춘다. zip(a, b, strict=True)는 길이가 다르면 예외 (3.10). zip(*pairs)는 다시 풀어준다.",
          "zip 喺較短嘅 list 停；zip(a, b, strict=True) 長度唔同會拋錯（3.10）。zip(*pairs) 反過來拆開。"
        ),
      },
      {
        topic = "STOP",
        q = L(
          "next() on an exhausted generator raises which exception?",
          "다 소진된 제너레이터에 next()를 하면 어떤 예외가 나오나?",
          "對一個用完嘅 generator 做 next() 會拋邊個 exception？"
        ),
        code = L(
          [[
it = iter([1])
next(it)      # 1
try:
    next(it)
except ___:
    print("belt empty")
]],
          [[
it = iter([1])
next(it)      # 1
try:
    next(it)
except ___:
    print("belt empty")
]],
          [[
it = iter([1])
next(it)      # 1
try:
    next(it)
except ___:
    print("belt empty")
]]
        ),
        accept = { "StopIteration" },
        answer = "StopIteration",
        hint = L(
          "Two words joined, CapWords: stop, and the thing generators do. A for loop catches it silently.",
          "두 단어를 붙인 CapWords: 멈춤, 그리고 제너레이터가 하는 일. for 루프는 이것을 조용히 잡는다.",
          "兩個字連埋，CapWords：停，同 generator 做嘅嗰件事。for loop 會靜靜地捉住佢。"
        ),
        ok = L(
          "StopIteration ends the protocol; return inside a generator raises it. The conveyor serves ten thousand bowls, one at a time.",
          "StopIteration이 프로토콜을 끝낸다. 제너레이터 안의 return이 이것을 던진다. 컨베이어가 만 그릇을 하나씩 내놓는다.",
          "StopIteration 結束 protocol；generator 裏面 return 就會拋佢。輸送帶一碗一碗出齊一萬碗。"
        ),
      },
    },
  },
  {
    id = "py_decor",
    station = "DECOR",
    name = L("The stamp desk", "도장 창구", "蓋印櫃位"),
    title = L("Decorators", "데코레이터", "decorator"),
    lesson = L(
      "A decorator is a function that takes a function and returns a new one; @name applies it. functools.wraps keeps the name. @property, @staticmethod and @classmethod are built-in decorators.",
      "데코레이터는 함수를 받아 새 함수를 반환하는 함수. @name으로 적용. functools.wraps가 이름을 지킨다. @property, @staticmethod, @classmethod는 내장 데코레이터.",
      "decorator 係一個收 function 回傳新 function 嘅 function；@name 套用佢。functools.wraps 保住個名。@property、@staticmethod 同 @classmethod 係內建 decorator。"
    ),
    bg = "bg_mall",
    portrait = "portrait_officer",
    speaker = L("Chef Bo", "보 셰프", "寶廚"),
    ground = 348,
    spawn = 160,
    width = 1600,
    npcs = {
      {
        kind = "cook",
        x = 560,
        facing = -1,
        line = L(
          "Every dish gets a stamp: time it, log it. I do not want to write that in fifty functions.",
          "모든 요리에 도장을 찍어: 시간 재고 기록해. 그걸 함수 쉰 개에 쓰긴 싫어.",
          "每道菜都蓋個印：計時、記錄。我唔想喺五十個 function 都寫一次。"
        ),
      },
    },
    viz = "python",
    chips = {
      { "@timer", "cyan" },
      { "@functools.wraps(fn)", "gold" },
      { "@property", "pink" },
      { "return wrapper", "green" },
    },
    note = "@  wraps  property  staticmethod  classmethod",
    story = L(
      "The stamp desk. Bo wants every kitchen function timed and logged without touching its body. "
        .. "In Python a function is a value: wrap it in another and put the wrapper's name, with an @, "
        .. "on the line above.",
      "도장 창구. 보는 본문을 건드리지 않고 모든 주방 함수의 시간을 재고 기록하고 싶다. "
        .. "Python에서 함수는 값이다: 다른 함수로 감싸고, 감싸는 함수의 이름을 @와 함께 바로 윗줄에 둔다.",
      "蓋印櫃位。寶廚想每個廚房 function 都計時同記錄，但唔掂佢嘅 body。"
        .. "Python 裏面 function 係一個值：用另一個包住佢，再將包住嗰個嘅名連 @ 放喺上面一行。"
    ),
    stages = {
      {
        topic = "AT",
        q = L(
          "Apply the timer wrapper to fry without changing its body. Which character goes before timer?",
          "fry의 본문을 바꾸지 않고 timer 래퍼를 적용. timer 앞에 오는 문자는?",
          "唔改 fry 嘅 body 而套用 timer wrapper。timer 前面放邊個字元？"
        ),
        code = L(
          [[
___timer
def fry(item):
    return f"fried {item}"
]],
          [[
___timer
def fry(item):
    return f"fried {item}"
]],
          [[
___timer
def fry(item):
    return f"fried {item}"
]]
        ),
        accept = { "@" },
        answer = "@",
        hint = L(
          "One character, the one in an email address. Rust uses it for attributes with #[...] instead.",
          "한 글자, 이메일 주소에 있는 그것. Rust는 대신 #[...] 어트리뷰트를 쓴다.",
          "一個字元，電郵地址嗰個。Rust 用 #[...] attribute 代替。"
        ),
        ok = L(
          "@timer above def fry is exactly fry = timer(fry). Sugar, nothing more. Decorators stack, top one runs last.",
          "def fry 위의 @timer는 정확히 fry = timer(fry). 그저 문법 설탕. 데코레이터는 쌓이고 맨 위가 마지막에 적용.",
          "def fry 上面嘅 @timer 就等於 fry = timer(fry)。純語法糖。decorator 可以疊，最上面嗰個最後套用。"
        ),
      },
      {
        topic = "WRAPPER",
        q = L(
          "The decorator builds an inner function and must hand it back. What does timer return?",
          "데코레이터는 내부 함수를 만들고 그것을 돌려줘야 한다. timer는 무엇을 반환?",
          "decorator 造一個內層 function，要交返佢出去。timer 回傳咩？"
        ),
        code = L(
          [[
def timer(fn):
    def wrapper(*args, **kwargs):
        t0 = time.perf_counter()
        out = fn(*args, **kwargs)
        print(fn.__name__, time.perf_counter() - t0)
        return out
    return ___
]],
          [[
def timer(fn):
    def wrapper(*args, **kwargs):
        t0 = time.perf_counter()
        out = fn(*args, **kwargs)
        print(fn.__name__, time.perf_counter() - t0)
        return out
    return ___
]],
          [[
def timer(fn):
    def wrapper(*args, **kwargs):
        t0 = time.perf_counter()
        out = fn(*args, **kwargs)
        print(fn.__name__, time.perf_counter() - t0)
        return out
    return ___
]]
        ),
        accept = { "wrapper" },
        answer = "wrapper",
        hint = L(
          "The inner def's name, without parentheses: the function itself, not a call of it.",
          "내부 def의 이름, 괄호 없이: 호출이 아니라 함수 자체.",
          "內層 def 嘅名，唔加括號：係 function 本身，唔係 call 佢。"
        ),
        ok = L(
          "return wrapper, not wrapper(). The caller gets the wrapper and calls it later; *args, **kwargs pass anything through.",
          "return wrapper, wrapper()가 아니다. 호출자는 래퍼를 받아 나중에 호출. *args, **kwargs가 무엇이든 통과시킨다.",
          "return wrapper，唔係 wrapper()。caller 攞到個 wrapper 遲啲先 call；*args, **kwargs 將任何嘢傳過去。"
        ),
      },
      {
        topic = "WRAPS",
        q = L(
          "After decorating, fry.__name__ says 'wrapper'. Which functools decorator keeps the original name and docstring?",
          "데코레이트 후 fry.__name__이 'wrapper'라고 한다. 원래 이름과 docstring을 지키는 functools 데코레이터는?",
          "裝飾之後 fry.__name__ 話係「wrapper」。邊個 functools decorator 保住原本嘅名同 docstring？"
        ),
        code = L(
          [[
import functools

def timer(fn):
    @functools.___(fn)
    def wrapper(*a, **kw):
        return fn(*a, **kw)
    return wrapper
]],
          [[
import functools

def timer(fn):
    @functools.___(fn)
    def wrapper(*a, **kw):
        return fn(*a, **kw)
    return wrapper
]],
          [[
import functools

def timer(fn):
    @functools.___(fn)
    def wrapper(*a, **kw):
        return fn(*a, **kw)
    return wrapper
]]
        ),
        accept = { "wraps" },
        answer = "wraps",
        hint = L(
          "Five letters, a verb in the third person: what the wrapper does to fn.",
          "다섯 글자, 3인칭 동사: 래퍼가 fn에게 하는 일.",
          "五個字母，第三人稱動詞：wrapper 對 fn 做嘅事。"
        ),
        ok = L(
          "@functools.wraps(fn) copies __name__, __doc__ and more onto the wrapper. Every decorator you write should use it.",
          "@functools.wraps(fn)은 __name__, __doc__ 등을 래퍼에 복사. 직접 쓰는 모든 데코레이터에 넣을 것.",
          "@functools.wraps(fn) 將 __name__、__doc__ 等等 copy 到 wrapper 上。你寫嘅每個 decorator 都應該用。"
        ),
      },
      {
        topic = "PROPERTY",
        q = L(
          "order.total should read like an attribute but be computed. Which built-in decorator?",
          "order.total은 속성처럼 읽히지만 계산되어야 한다. 어떤 내장 데코레이터?",
          "order.total 要似 attribute 咁讀，但係計出嚟嘅。邊個內建 decorator？"
        ),
        code = L(
          [[
class Order:
    def __init__(self, qty, price):
        self.qty, self.price = qty, price

    @___
    def total(self):
        return self.qty * self.price
]],
          [[
class Order:
    def __init__(self, qty, price):
        self.qty, self.price = qty, price

    @___
    def total(self):
        return self.qty * self.price
]],
          [[
class Order:
    def __init__(self, qty, price):
        self.qty, self.price = qty, price

    @___
    def total(self):
        return self.qty * self.price
]]
        ),
        accept = { "property" },
        answer = "property",
        hint = L(
          "Eight letters, what a house or an object has. Then o.total works, no parentheses.",
          "여덟 글자, 집이나 객체가 갖는 것. 그러면 o.total이 괄호 없이 된다.",
          "八個字母，一間屋或者一個 object 擁有嘅嘢。之後 o.total 唔使括號就得。"
        ),
        ok = L(
          "@property makes a getter; @total.setter adds assignment. Go would write a Total() method; Python hides the call.",
          "@property는 getter를 만든다. @total.setter가 대입을 추가. Go라면 Total() 메서드, Python은 호출을 숨긴다.",
          "@property 造一個 getter；@total.setter 加賦值。Go 會寫 Total() method；Python 將 call 收埋。"
        ),
      },
      {
        topic = "STATIC",
        q = L(
          "A helper inside the class that needs neither self nor the class. Which decorator?",
          "self도 클래스도 필요 없는 클래스 안의 도우미. 어떤 데코레이터?",
          "class 裏面一個唔使 self 亦唔使 class 嘅 helper。邊個 decorator？"
        ),
        code = L(
          [[
class Till:
    @___
    def round_up(cents):
        return (cents + 9) // 10 * 10

print(Till.round_up(123))    # 130
]],
          [[
class Till:
    @___
    def round_up(cents):
        return (cents + 9) // 10 * 10

print(Till.round_up(123))    # 130
]],
          [[
class Till:
    @___
    def round_up(cents):
        return (cents + 9) // 10 * 10

print(Till.round_up(123))    # 130
]]
        ),
        accept = { "staticmethod" },
        answer = "staticmethod",
        hint = L(
          "Two words joined, lowercase: not moving, and what a def in a class is.",
          "두 단어를 붙인 소문자: 움직이지 않는, 그리고 클래스 안의 def를 부르는 말.",
          "兩個字連埋，細楷：唔郁嘅，同 class 裏面一個 def 叫咩。"
        ),
        ok = L(
          "@staticmethod: no implicit first argument. It is a namespaced plain function. Often a module-level def is clearer.",
          "@staticmethod: 암묵적 첫 인자가 없다. 이름 공간 안의 평범한 함수. 모듈 수준 def가 더 명확할 때가 많다.",
          "@staticmethod：冇隱含嘅第一個參數。係一個有 namespace 嘅普通 function。好多時 module 層級嘅 def 更清楚。"
        ),
      },
      {
        topic = "CLS",
        q = L(
          "An alternative constructor: Order.from_line('2 x egg'). Which decorator passes the class instead of an instance?",
          "대체 생성자: Order.from_line('2 x egg'). 인스턴스 대신 클래스를 넘기는 데코레이터는?",
          "另一個 constructor：Order.from_line('2 x egg')。邊個 decorator 傳 class 而唔係 instance？"
        ),
        code = L(
          [[
class Order:
    @___
    def from_line(cls, line):
        qty, _, item = line.split()
        return cls(item, int(qty))
]],
          [[
class Order:
    @___
    def from_line(cls, line):
        qty, _, item = line.split()
        return cls(item, int(qty))
]],
          [[
class Order:
    @___
    def from_line(cls, line):
        qty, _, item = line.split()
        return cls(item, int(qty))
]]
        ),
        accept = { "classmethod" },
        answer = "classmethod",
        hint = L(
          "Two words joined, lowercase. The first parameter is spelled cls by convention.",
          "두 단어를 붙인 소문자. 첫 매개변수는 관례상 cls.",
          "兩個字連埋，細楷。第一個參數慣例上寫 cls。"
        ),
        ok = L(
          "@classmethod gets cls; return cls(...) builds the right subclass too. The stamp desk closes.",
          "@classmethod는 cls를 받는다. return cls(...)는 서브클래스도 올바르게 만든다. 도장 창구 마감.",
          "@classmethod 攞到 cls；return cls(...) 連 subclass 都會造對。蓋印櫃位收工。"
        ),
      },
    },
  },
  {
    id = "py_with",
    station = "WITH",
    name = L("The safe", "금고", "夾萬"),
    title = L("Context managers", "컨텍스트 매니저", "context manager"),
    lesson = L(
      "with opens a resource and guarantees it is closed, even on error. __enter__ and __exit__ make a class a context manager; @contextmanager makes one from a generator.",
      "with는 자원을 열고 에러가 나도 닫힘을 보장. __enter__와 __exit__이 클래스를 컨텍스트 매니저로 만든다. @contextmanager는 제너레이터로 만든다.",
      "with 打開一個資源並保證會關，出錯都會。__enter__ 同 __exit__ 令 class 變成 context manager；@contextmanager 由 generator 造一個。"
    ),
    bg = "bg_lab",
    portrait = "portrait_hero",
    speaker = L("Alex", "알렉스", "阿力"),
    ground = 348,
    spawn = 160,
    width = 1600,
    npcs = {
      {
        kind = "cook",
        x = 520,
        facing = -1,
        line = L(
          "The stock file is left open every night. Then the count is wrong in the morning.",
          "재고 파일이 매일 밤 열린 채로 남아. 그래서 아침에 숫자가 틀려.",
          "存貨檔每晚都冇關。到早上數目就錯。"
        ),
      },
    },
    viz = "python",
    chips = {
      { "with open(p) as f:", "cyan" },
      { "def __enter__(self):", "gold" },
      { "def __exit__(self, *e):", "pink" },
      { "@contextmanager", "green" },
    },
    note = "with  as  __enter__  __exit__  contextmanager",
    story = L(
      "The safe behind the till holds the stock file. The script opens it, writes, and forgets to close "
        .. "when a line is bad. Alex knows defer f.Close(); Python puts the whole idea into one keyword.",
      "계산대 뒤 금고에 재고 파일이 있다. 스크립트는 열고 쓰다가 잘못된 줄을 만나면 닫는 걸 잊는다. "
        .. "알렉스는 defer f.Close()를 안다. Python은 그 아이디어 전체를 키워드 하나에 담았다.",
      "收銀機後面嘅夾萬放住存貨檔。個 script 打開、寫入，遇到壞行就唔記得關。"
        .. "阿力識 defer f.Close()；Python 將成個概念放入一個 keyword。"
    ),
    stages = {
      {
        topic = "WITH",
        q = L(
          "Open the file so it is closed no matter what happens inside. Which keyword?",
          "안에서 무슨 일이 있어도 닫히도록 파일 열기. 어떤 키워드?",
          "打開檔案，無論裏面發生咩都會關。邊個 keyword？"
        ),
        code = L(
          [[
___ open("stock.csv") as f:
    for line in f:
        count(line)
# f is closed here
]],
          [[
___ open("stock.csv") as f:
    for line in f:
        count(line)
# 여기서 f는 닫혀 있다
]],
          [[
___ open("stock.csv") as f:
    for line in f:
        count(line)
# 到呢度 f 已經關咗
]]
        ),
        accept = { "with" },
        answer = "with",
        hint = L(
          "Four letters, a preposition. It replaces try/finally: f.close() for the common case.",
          "네 글자, 전치사. 흔한 경우의 try/finally: f.close()를 대신한다.",
          "四個字母，一個介詞。代替常見嘅 try/finally: f.close()。"
        ),
        ok = L(
          "with calls __enter__ on the way in and __exit__ on the way out, exception or not. Go's defer, scoped to a block.",
          "with는 들어갈 때 __enter__, 나올 때 __exit__을 호출, 예외가 있어도. 블록 범위의 Go defer.",
          "with 入去嗰陣 call __enter__，出嚟嗰陣 call __exit__，有冇 exception 都係。Go 嘅 defer，範圍係一個 block。"
        ),
      },
      {
        topic = "AS",
        q = L(
          "Give the opened file a name inside the block. Which keyword?",
          "블록 안에서 열린 파일에 이름 붙이기. 어떤 키워드?",
          "喺 block 裏面畀打開嘅檔案一個名。邊個 keyword？"
        ),
        code = L(
          [[
with open("stock.csv") ___ f:
    data = f.read()
]],
          [[
with open("stock.csv") ___ f:
    data = f.read()
]],
          [[
with open("stock.csv") ___ f:
    data = f.read()
]]
        ),
        accept = { "as" },
        answer = "as",
        hint = L(
          "Two letters, the same word except and import use to bind a name.",
          "두 글자, except와 import가 이름을 묶을 때 쓰는 그 단어.",
          "兩個字母，except 同 import 用嚟綁名嘅同一個字。"
        ),
        ok = L(
          "as f binds what __enter__ returned. with a() as x, b() as y: manages two at once.",
          "as f는 __enter__가 반환한 것을 묶는다. with a() as x, b() as y:로 둘을 동시에.",
          "as f 綁住 __enter__ 回傳嘅嘢。with a() as x, b() as y: 一次管兩個。"
        ),
      },
      {
        topic = "ENTER",
        q = L(
          "Make the Safe class usable with 'with'. Which method runs on the way in?",
          "Safe 클래스를 with에 쓸 수 있게. 들어갈 때 실행되는 메서드는?",
          "令 Safe class 可以用 with。入去嗰陣執行邊個 method？"
        ),
        code = L(
          [[
class Safe:
    def ___(self):
        self.f = open("stock.csv")
        return self.f
]],
          [[
class Safe:
    def ___(self):
        self.f = open("stock.csv")
        return self.f
]],
          [[
class Safe:
    def ___(self):
        self.f = open("stock.csv")
        return self.f
]]
        ),
        accept = { "__enter__", "enter" },
        answer = "__enter__",
        hint = L(
          "Dunder around the verb for going in. Its return value is what as binds.",
          "들어가다를 뜻하는 동사를 던더로 감싼 것. 반환값이 as에 묶인다.",
          "「入」呢個動詞前後加 dunder。佢嘅回傳值就係 as 綁住嘅嘢。"
        ),
        ok = L(
          "__enter__ runs at the with line. Return self or the resource. Rust would use Drop for the other half.",
          "__enter__는 with 줄에서 실행. self나 자원을 반환. Rust는 나머지 절반에 Drop을 쓴다.",
          "__enter__ 喺 with 嗰行執行。回傳 self 或者個資源。Rust 另一半會用 Drop。"
        ),
      },
      {
        topic = "EXIT",
        q = L(
          "And on the way out, error or not. Which method closes the file?",
          "그리고 나올 때, 에러가 있든 없든. 파일을 닫는 메서드는?",
          "出嚟嗰陣，有冇錯都好。邊個 method 關檔案？"
        ),
        code = L(
          [[
class Safe:
    def __enter__(self):
        self.f = open("stock.csv")
        return self.f

    def ___(self, exc_type, exc, tb):
        self.f.close()
]],
          [[
class Safe:
    def __enter__(self):
        self.f = open("stock.csv")
        return self.f

    def ___(self, exc_type, exc, tb):
        self.f.close()
]],
          [[
class Safe:
    def __enter__(self):
        self.f = open("stock.csv")
        return self.f

    def ___(self, exc_type, exc, tb):
        self.f.close()
]]
        ),
        accept = { "__exit__", "exit" },
        answer = "__exit__",
        hint = L(
          "Dunder around the verb for going out. It receives three values about any exception.",
          "나가다를 뜻하는 동사를 던더로 감싼 것. 예외에 관한 값 셋을 받는다.",
          "「出」呢個動詞前後加 dunder。佢收到關於 exception 嘅三個值。"
        ),
        ok = L(
          "__exit__(self, exc_type, exc, tb) always runs. Return True to swallow the exception; return None to let it propagate.",
          "__exit__(self, exc_type, exc, tb)는 항상 실행. True를 반환하면 예외를 삼키고, None이면 전파.",
          "__exit__(self, exc_type, exc, tb) 一定會行。回傳 True 就吞掉 exception；回傳 None 就畀佢傳上去。"
        ),
      },
      {
        topic = "CONTEXTLIB",
        q = L(
          "Same thing from a generator: setup, yield, teardown. Which contextlib decorator?",
          "제너레이터로 같은 것: 설정, yield, 정리. 어떤 contextlib 데코레이터?",
          "用 generator 做同一件事：setup、yield、teardown。邊個 contextlib decorator？"
        ),
        code = L(
          [[
@contextlib.___
def safe():
    f = open("stock.csv")
    try:
        yield f
    finally:
        f.close()
]],
          [[
@contextlib.___
def safe():
    f = open("stock.csv")
    try:
        yield f
    finally:
        f.close()
]],
          [[
@contextlib.___
def safe():
    f = open("stock.csv")
    try:
        yield f
    finally:
        f.close()
]]
        ),
        accept = { "contextmanager" },
        answer = "contextmanager",
        hint = L(
          "Two words joined, lowercase: the thing a with statement needs, as one name.",
          "두 단어를 붙인 소문자: with 문이 필요로 하는 그것을 한 이름으로.",
          "兩個字連埋，細楷：with statement 需要嘅嗰樣嘢，寫成一個名。"
        ),
        ok = L(
          "@contextlib.contextmanager: everything before yield is __enter__, everything after is __exit__. Ten lines become five.",
          "@contextlib.contextmanager: yield 앞은 __enter__, 뒤는 __exit__. 열 줄이 다섯 줄로.",
          "@contextlib.contextmanager：yield 之前係 __enter__，之後係 __exit__。十行變五行。"
        ),
      },
      {
        topic = "CLOSE",
        q = L(
          "Without with, which method must you remember to call on the file?",
          "with 없이는 파일에 어떤 메서드를 꼭 호출해야 하나?",
          "冇 with 嘅話，你要記得對檔案 call 邊個 method？"
        ),
        code = L(
          [[
f = open("stock.csv", "w")
f.write("egg,12\n")
f.___()      # flush and release; with does this for you
]],
          [[
f = open("stock.csv", "w")
f.write("egg,12\n")
f.___()      # 플러시 후 해제; with가 대신 함
]],
          [[
f = open("stock.csv", "w")
f.write("egg,12\n")
f.___()      # flush 並釋放；with 會幫你做
]]
        ),
        accept = { "close" },
        answer = "close",
        hint = L(
          "Five letters, the opposite of open. Forgetting it is why the morning count was wrong.",
          "다섯 글자, open의 반대. 이걸 잊은 게 아침 숫자가 틀린 이유.",
          "五個字母，open 嘅相反。忘記佢就係早上數目錯嘅原因。"
        ),
        ok = L(
          "f.close() flushes the buffer. Until then the last lines may not be on disk. The safe locks properly tonight.",
          "f.close()가 버퍼를 플러시. 그전까지 마지막 줄들은 디스크에 없을 수 있다. 오늘 밤 금고는 제대로 잠긴다.",
          "f.close() flush 個 buffer。之前最後幾行未必喺 disk 上。今晚夾萬鎖得好好。"
        ),
      },
    },
  },
  {
    id = "py_async",
    station = "ASYNC",
    name = L("The delivery radio", "배달 무전기", "外賣對講機"),
    title = L("asyncio", "asyncio 비동기", "asyncio 非同步"),
    lesson = L(
      "async def makes a coroutine; await pauses it until the result is in. asyncio.run starts the loop, gather runs several at once, sleep waits without blocking, create_task fires and forgets.",
      "async def가 코루틴을 만든다. await는 결과가 올 때까지 멈춘다. asyncio.run이 루프를 시작, gather는 여럿을 동시에, sleep은 막지 않고 기다림, create_task는 던져두기.",
      "async def 造一個 coroutine；await 暫停到結果返嚟。asyncio.run 開個 loop，gather 同時跑幾個，sleep 唔阻塞地等，create_task 放出去唔理。"
    ),
    bg = "bg_street",
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
          "You did tokio this afternoon. asyncio is the same shape: one loop, many awaits.",
          "오후에 tokio 했잖아. asyncio도 같은 모양이야: 루프 하나, await 여럿.",
          "你下晝做過 tokio。asyncio 同一個形狀：一個 loop，好多 await。"
        ),
      },
      {
        kind = "clerk",
        x = 900,
        facing = -1,
        line = L(
          "Three riders, three radios. The script calls them one after another and the noodles go cold.",
          "라이더 셋, 무전기 셋. 스크립트가 하나씩 차례로 불러서 국수가 식어요.",
          "三個車手，三部對講機。個 script 逐個 call，麵都凍咗。"
        ),
      },
    },
    viz = "python",
    chips = {
      { "async def fetch(rider):", "cyan" },
      { "await fetch(r)", "gold" },
      { "asyncio.gather(*tasks)", "pink" },
      { "asyncio.run(main())", "green" },
    },
    note = "async  await  run  gather  sleep  create_task",
    story = L(
      "The delivery radio at the door. Three riders report their position; the script asks each in turn "
        .. "and waits a full second for every answer. Asked at once, the three answers would arrive together.",
      "문 옆 배달 무전기. 라이더 셋이 위치를 보고한다. 스크립트는 차례로 묻고 답마다 꼬박 1초를 기다린다. "
        .. "동시에 물으면 세 답이 함께 도착할 텐데.",
      "門口嘅外賣對講機。三個車手報位置；個 script 逐個問，每個答案都等足一秒。"
        .. "一齊問嘅話三個答案會一齊返。"
    ),
    stages = {
      {
        topic = "ASYNC",
        q = L(
          "Which keyword before def makes fetch a coroutine?",
          "def 앞의 어떤 키워드가 fetch를 코루틴으로 만드나?",
          "def 前面邊個 keyword 令 fetch 變成 coroutine？"
        ),
        code = L(
          [[
import asyncio

___ def fetch(rider):
    await asyncio.sleep(1)
    return f"{rider}: Percival St"
]],
          [[
import asyncio

___ def fetch(rider):
    await asyncio.sleep(1)
    return f"{rider}: Percival St"
]],
          [[
import asyncio

___ def fetch(rider):
    await asyncio.sleep(1)
    return f"{rider}: Percival St"
]]
        ),
        accept = { "async" },
        answer = "async",
        hint = L(
          "Five letters, short for asynchronous. Rust spells it the same way in front of fn.",
          "다섯 글자, asynchronous의 줄임. Rust도 fn 앞에 같은 철자.",
          "五個字母，asynchronous 嘅簡寫。Rust 喺 fn 前面串法一樣。"
        ),
        ok = L(
          "async def returns a coroutine object when called; nothing runs until it is awaited or scheduled.",
          "async def는 호출 시 코루틴 객체를 반환. await되거나 예약될 때까지 아무것도 실행되지 않는다.",
          "async def call 嗰陣回傳一個 coroutine object；未 await 或者未排程之前咩都唔會行。"
        ),
      },
      {
        topic = "AWAIT",
        q = L(
          "Pause here until fetch has its answer, letting other tasks run. Which keyword?",
          "fetch가 답을 얻을 때까지 여기서 멈추고 다른 태스크를 돌리기. 어떤 키워드?",
          "喺呢度暫停直到 fetch 有答案，畀其他 task 行。邊個 keyword？"
        ),
        code = L(
          [[
async def main():
    where = ___ fetch("Ken")
    print(where)
]],
          [[
async def main():
    where = ___ fetch("Ken")
    print(where)
]],
          [[
async def main():
    where = ___ fetch("Ken")
    print(where)
]]
        ),
        accept = { "await" },
        answer = "await",
        hint = L(
          "Five letters, a verb: wait for it. Rust puts the same word after a dot.",
          "다섯 글자, 동사: 기다린다. Rust는 같은 단어를 점 뒤에 둔다.",
          "五個字母，一個動詞：等佢。Rust 將同一個字放喺點後面。"
        ),
        ok = L(
          "await hands control to the event loop until the coroutine finishes. Only allowed inside async def.",
          "await는 코루틴이 끝날 때까지 이벤트 루프에 제어를 넘긴다. async def 안에서만 허용.",
          "await 將控制權交畀 event loop 直到 coroutine 完成。只可以喺 async def 裏面用。"
        ),
      },
      {
        topic = "RUN",
        q = L(
          "Start the event loop with main(). Which asyncio function?",
          "main()으로 이벤트 루프 시작. 어떤 asyncio 함수?",
          "用 main() 開個 event loop。邊個 asyncio function？"
        ),
        code = L(
          [[
if __name__ == "__main__":
    asyncio.___(main())
]],
          [[
if __name__ == "__main__":
    asyncio.___(main())
]],
          [[
if __name__ == "__main__":
    asyncio.___(main())
]]
        ),
        accept = { "run" },
        answer = "run",
        hint = L(
          "Three letters, the plainest verb for starting a program. Once, at the top level.",
          "세 글자, 프로그램을 시작하는 가장 평범한 동사. 최상위에서 한 번.",
          "三個字母，開始一個程式最平實嘅動詞。最頂層用一次。"
        ),
        ok = L(
          "asyncio.run(main()) creates the loop, runs the coroutine, closes the loop. Rust's #[tokio::main].",
          "asyncio.run(main())이 루프를 만들고 코루틴을 돌리고 루프를 닫는다. Rust의 #[tokio::main].",
          "asyncio.run(main()) 開 loop、跑 coroutine、閂 loop。Rust 嘅 #[tokio::main]。"
        ),
      },
      {
        topic = "GATHER",
        q = L(
          "Ask all three riders at once and collect the answers. Which asyncio function?",
          "라이더 셋에게 동시에 묻고 답을 모으기. 어떤 asyncio 함수?",
          "同時問三個車手並收齊答案。邊個 asyncio function？"
        ),
        code = L(
          [[
async def main():
    riders = ["Ken", "Mei", "Bo"]
    where = await asyncio.___(*(fetch(r) for r in riders))
    print(where)     # one second total, not three
]],
          [[
async def main():
    riders = ["Ken", "Mei", "Bo"]
    where = await asyncio.___(*(fetch(r) for r in riders))
    print(where)     # 3초가 아니라 총 1초
]],
          [[
async def main():
    riders = ["Ken", "Mei", "Bo"]
    where = await asyncio.___(*(fetch(r) for r in riders))
    print(where)     # 總共一秒，唔係三秒
]]
        ),
        accept = { "gather" },
        answer = "gather",
        hint = L(
          "Six letters: to bring together. tokio::join! does the same for a fixed number.",
          "여섯 글자: 모으다. tokio::join!이 고정 개수에 같은 일을 한다.",
          "六個字母：聚埋一齊。tokio::join! 對固定數量做同一件事。"
        ),
        ok = L(
          "gather runs them concurrently and returns the results in order. One second total. The noodles stay hot.",
          "gather는 동시에 실행하고 결과를 순서대로 반환. 총 1초. 국수가 뜨겁게 남는다.",
          "gather 同時跑佢們，按次序回傳結果。總共一秒。麵仲係熱嘅。"
        ),
      },
      {
        topic = "SLEEP",
        q = L(
          "Wait one second without freezing the loop. Which asyncio function, never time.sleep?",
          "루프를 멈추지 않고 1초 기다리기. time.sleep이 아닌 어떤 asyncio 함수?",
          "唔凍住個 loop 等一秒。邊個 asyncio function，唔係 time.sleep？"
        ),
        code = L(
          [[
async def fetch(rider):
    await asyncio.___(1)     # the radio takes a second
    return rider
]],
          [[
async def fetch(rider):
    await asyncio.___(1)     # 무전기가 1초 걸린다
    return rider
]],
          [[
async def fetch(rider):
    await asyncio.___(1)     # 對講機要一秒
    return rider
]]
        ),
        accept = { "sleep" },
        answer = "sleep",
        hint = L(
          "Same name as the blocking one in the time module, but awaited.",
          "time 모듈의 블로킹 함수와 같은 이름, 하지만 await 한다.",
          "同 time module 嗰個阻塞版同名，但要 await。"
        ),
        ok = L(
          "await asyncio.sleep(1) yields to the loop; time.sleep(1) would freeze every task. Same trap as in tokio.",
          "await asyncio.sleep(1)은 루프에 양보. time.sleep(1)은 모든 태스크를 얼린다. tokio와 같은 함정.",
          "await asyncio.sleep(1) 讓畀 loop；time.sleep(1) 會凍住所有 task。同 tokio 一樣嘅陷阱。"
        ),
      },
      {
        topic = "TASK",
        q = L(
          "Start fetch in the background and keep going without awaiting it yet. Which asyncio function?",
          "fetch를 백그라운드에서 시작하고 아직 await하지 않은 채 계속 진행. 어떤 asyncio 함수?",
          "喺背景開始 fetch，暫時唔 await 佢繼續行。邊個 asyncio function？"
        ),
        code = L(
          [[
async def main():
    t = asyncio.___(fetch("Ken"))
    print("radio sent")
    print(await t)
]],
          [[
async def main():
    t = asyncio.___(fetch("Ken"))
    print("radio sent")
    print(await t)
]],
          [[
async def main():
    t = asyncio.___(fetch("Ken"))
    print("radio sent")
    print(await t)
]]
        ),
        accept = { "create_task", "createtask" },
        answer = "create_task",
        hint = L(
          "Two words with an underscore: make one of the things the loop schedules. tokio::spawn.",
          "밑줄로 이은 두 단어: 루프가 예약하는 그것을 하나 만든다. tokio::spawn.",
          "兩個字用底線連住：造一個 loop 會排程嘅嘢。tokio::spawn。"
        ),
        ok = L(
          "create_task schedules the coroutine now; await t later collects it. Keep a reference or it may be garbage-collected mid-flight.",
          "create_task는 코루틴을 지금 예약. 나중에 await t로 회수. 참조를 잡아두지 않으면 도중에 가비지 컬렉션될 수 있다.",
          "create_task 即刻排程個 coroutine；遲啲 await t 收返。要保留 reference，否則可能半路被 GC。"
        ),
      },
    },
  },
  {
    id = "py_typing",
    station = "TYPING",
    name = L("The label maker", "라벨 프린터", "標籤機"),
    title = L("Type hints", "타입 힌트", "type hint"),
    lesson = L(
      "Hints document types without enforcing them: def f(x: int) -> str. list[str], dict[str, float], Optional[str]. mypy checks them before you run.",
      "힌트는 강제하지 않고 타입을 문서화: def f(x: int) -> str. list[str], dict[str, float], Optional[str]. mypy가 실행 전에 검사.",
      "hint 記錄 type 但唔強制：def f(x: int) -> str。list[str]、dict[str, float]、Optional[str]。mypy 喺你跑之前檢查。"
    ),
    bg = "bg_lab",
    portrait = "portrait_hero",
    speaker = L("Alex", "알렉스", "阿力"),
    ground = 348,
    spawn = 160,
    width = 1600,
    npcs = {
      {
        kind = "hero",
        x = 520,
        facing = 1,
        line = L(
          "Finally, types. Even if the interpreter ignores them.",
          "드디어 타입. 인터프리터가 무시하더라도.",
          "終於有 type。就算 interpreter 唔理。"
        ),
      },
      {
        kind = "cook",
        x = 880,
        facing = -1,
        line = L(
          "The label maker printed 'None' on forty bowls. Somebody returned nothing.",
          "라벨 프린터가 그릇 마흔 개에 'None'을 찍었어. 누가 아무것도 반환하지 않았어.",
          "標籤機喺四十碗上面印咗「None」。有人咩都冇回傳。"
        ),
      },
    },
    viz = "python",
    chips = {
      { "def brew(n: int) -> str:", "cyan" },
      { "orders: list[str] = []", "gold" },
      { "note: Optional[str]", "pink" },
      { "$ mypy shop.py", "green" },
    },
    note = "int  None  list  Optional  dict  mypy",
    story = L(
      "The label maker prints a name and a price per bowl. Half its functions return None by accident "
        .. "and nobody noticed until forty bowls said so. Type hints would have caught it before the shift.",
      "라벨 프린터는 그릇마다 이름과 가격을 찍는다. 함수 절반이 실수로 None을 반환하는데 그릇 마흔 개가 그렇게 말할 때까지 아무도 몰랐다. "
        .. "타입 힌트가 있었다면 근무 전에 잡았을 것이다.",
      "標籤機每碗印一個名同價錢。佢一半 function 不小心回傳 None，直到四十碗都咁樣寫先有人發現。"
        .. "有 type hint 就會喺開工前捉到。"
    ),
    stages = {
      {
        topic = "PARAM",
        q = L(
          "brew takes a whole number of cups and returns text. Annotate the parameter.",
          "brew는 정수 개수의 컵을 받고 텍스트를 반환. 매개변수에 주석을 달아라.",
          "brew 收整數杯數，回傳文字。為參數加 annotation。"
        ),
        code = L(
          [[
def brew(cups: ___) -> str:
    return f"{cups} cups of tea"
]],
          [[
def brew(cups: ___) -> str:
    return f"{cups} cups of tea"
]],
          [[
def brew(cups: ___) -> str:
    return f"{cups} cups of tea"
]]
        ),
        accept = { "int" },
        answer = "int",
        hint = L(
          "The built-in whole-number type, three letters, after the colon.",
          "내장 정수 타입, 세 글자, 콜론 뒤에.",
          "內建整數 type，三個字母，放喺冒號後面。"
        ),
        ok = L(
          "cups: int is a hint, not a check: brew('two') still runs. mypy or pyright flags it before that.",
          "cups: int는 힌트일 뿐 검사가 아니다: brew('two')도 실행된다. mypy나 pyright가 그전에 표시.",
          "cups: int 係 hint，唔係檢查：brew('two') 照跑。mypy 或者 pyright 會喺之前標出嚟。"
        ),
      },
      {
        topic = "RETURNS",
        q = L(
          "log prints and returns nothing. What goes after the arrow?",
          "log는 출력만 하고 아무것도 반환하지 않는다. 화살표 뒤엔?",
          "log 只印，咩都唔回傳。箭嘴後面寫咩？"
        ),
        code = L(
          [[
def log(msg: str) -> ___:
    print("[night]", msg)
]],
          [[
def log(msg: str) -> ___:
    print("[night]", msg)
]],
          [[
def log(msg: str) -> ___:
    print("[night]", msg)
]]
        ),
        accept = { "None" },
        answer = "None",
        hint = L(
          "The value a function without return gives back, capital letter, used as the type here.",
          "return 없는 함수가 돌려주는 값, 대문자, 여기선 타입으로 쓰인다.",
          "冇 return 嘅 function 交返嘅值，大楷，呢度當 type 用。"
        ),
        ok = L(
          "-> None says: no useful result. mypy then complains if you assign the call. Forty bowls saved.",
          "-> None은 유용한 결과가 없다는 뜻. 호출 결과를 대입하면 mypy가 불평. 그릇 마흔 개를 살렸다.",
          "-> None 話：冇有用嘅結果。之後你將 call 賦值 mypy 就會投訴。救返四十碗。"
        ),
      },
      {
        topic = "LIST",
        q = L(
          "A list of order names. Which built-in generic, lowercase since 3.9?",
          "주문 이름의 리스트. 3.9부터 소문자인 내장 제네릭은?",
          "一個訂單名嘅 list。邊個內建 generic，3.9 起用細楷？"
        ),
        code = L(
          [[
orders: ___[str] = []
orders.append("noodles")
]],
          [[
orders: ___[str] = []
orders.append("noodles")
]],
          [[
orders: ___[str] = []
orders.append("noodles")
]]
        ),
        accept = { "list", "List" },
        answer = "list",
        hint = L(
          "The type of [] itself, with the item type in square brackets. Older code imported a capitalized one from typing.",
          "[] 자체의 타입, 항목 타입을 대괄호 안에. 옛 코드는 typing에서 대문자 버전을 import했다.",
          "[] 本身嘅 type，項目 type 放喺方括號。舊 code 由 typing import 大楷版。"
        ),
        ok = L(
          "list[str] since 3.9; typing.List[str] before. Go's []string, Rust's Vec<String>.",
          "3.9부터 list[str], 그전엔 typing.List[str]. Go의 []string, Rust의 Vec<String>.",
          "3.9 起 list[str]；之前係 typing.List[str]。Go 嘅 []string，Rust 嘅 Vec<String>。"
        ),
      },
      {
        topic = "OPTIONAL",
        q = L(
          "The note may be text or None. Which typing name says so?",
          "메모는 텍스트일 수도 None일 수도 있다. 그것을 나타내는 typing 이름은?",
          "備註可能係文字或者 None。邊個 typing 名咁講？"
        ),
        code = L(
          [[
from typing import Optional

note: ___[str] = None
]],
          [[
from typing import Optional

note: ___[str] = None
]],
          [[
from typing import Optional

note: ___[str] = None
]]
        ),
        accept = { "Optional", "str | None" },
        answer = "Optional",
        hint = L(
          "The name imported on the first line. Since 3.10 you may write the type, a pipe, and None instead.",
          "첫 줄에서 import한 이름. 3.10부터는 타입, 파이프, None으로 써도 된다.",
          "第一行 import 嘅個名。3.10 起可以寫 type、一條直線、None。"
        ),
        ok = L(
          "Optional[str] is str | None. Rust's Option<String>, made visible to the checker.",
          "Optional[str]은 str | None. Rust의 Option<String>을 검사기에 보이게 한 것.",
          "Optional[str] 係 str | None。Rust 嘅 Option<String>，畀 checker 睇得見。"
        ),
      },
      {
        topic = "DICT",
        q = L(
          "The menu maps dish names to prices. Which generic takes two types?",
          "메뉴는 요리 이름을 가격에 매핑. 두 타입을 받는 제네릭은?",
          "餐牌將菜名對應價錢。邊個 generic 收兩個 type？"
        ),
        code = L(
          [[
menu: ___[str, float] = {"tea": 12.0}
]],
          [[
menu: ___[str, float] = {"tea": 12.0}
]],
          [[
menu: ___[str, float] = {"tea": 12.0}
]]
        ),
        accept = { "dict", "Dict" },
        answer = "dict",
        hint = L(
          "The type of {} itself, lowercase, key type then value type inside the brackets.",
          "{} 자체의 타입, 소문자, 대괄호 안에 키 타입 다음 값 타입.",
          "{} 本身嘅 type，細楷，方括號裏面先 key type 再 value type。"
        ),
        ok = L(
          "dict[str, float]. Go's map[string]float64, Rust's HashMap<String, f64>. TypedDict names each key.",
          "dict[str, float]. Go의 map[string]float64, Rust의 HashMap<String, f64>. TypedDict는 각 키에 이름을 준다.",
          "dict[str, float]。Go 嘅 map[string]float64，Rust 嘅 HashMap<String, f64>。TypedDict 為每個 key 命名。"
        ),
      },
      {
        topic = "CHECKER",
        q = L(
          "Check the hints before running the shift. Which tool, the classic one?",
          "근무 전에 힌트를 검사. 어떤 도구, 고전적인 그것?",
          "開工前檢查 hint。邊個工具，最經典嗰個？"
        ),
        code = L(
          [[
$ ___ shop.py
shop.py:12: error: Incompatible return value type
    (got "None", expected "str")
Found 1 error in 1 file
]],
          [[
$ ___ shop.py
shop.py:12: error: Incompatible return value type
    (got "None", expected "str")
Found 1 error in 1 file
]],
          [[
$ ___ shop.py
shop.py:12: error: Incompatible return value type
    (got "None", expected "str")
Found 1 error in 1 file
]]
        ),
        accept = { "mypy", "pyright" },
        answer = "mypy",
        hint = L(
          "Four letters: my, and the language's first two. pyright is the other common one.",
          "네 글자: my, 그리고 언어 이름의 앞 두 글자. pyright가 다른 흔한 도구.",
          "四個字母：my，加呢個語言嘅頭兩個字母。pyright 係另一個常見嘅。"
        ),
        ok = L(
          "mypy runs no code; it reads the hints. Go and Rust do this in the compiler; Python does it on request. The labels print right.",
          "mypy는 코드를 실행하지 않고 힌트를 읽는다. Go와 Rust는 컴파일러가 하고 Python은 요청 시 한다. 라벨이 제대로 찍힌다.",
          "mypy 唔跑 code；佢讀 hint。Go 同 Rust 喺 compiler 做；Python 你叫佢先做。標籤印得啱。"
        ),
      },
    },
  },
  {
    id = "py_threads",
    station = "THREADS",
    name = L("The kitchen at 23:00", "23:00의 주방", "晚上十一點嘅廚房"),
    title = L("Threads and the GIL", "스레드와 GIL", "thread 同 GIL"),
    lesson = L(
      "threading.Thread(target=f).start() runs f beside the main thread; join waits. Lock guards shared state. ThreadPoolExecutor manages a pool. The GIL lets one thread run bytecode at a time.",
      "threading.Thread(target=f).start()는 메인 스레드 옆에서 f를 실행, join은 기다림. Lock이 공유 상태를 지킨다. ThreadPoolExecutor는 풀을 관리. GIL은 한 번에 한 스레드만 바이트코드를 실행하게 한다.",
      "threading.Thread(target=f).start() 喺 main thread 旁邊跑 f；join 等。Lock 守住共享狀態。ThreadPoolExecutor 管理一個 pool。GIL 令一次只有一個 thread 跑 bytecode。"
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
          "Three woks, one cook script. It fries one egg at a time while the other two woks sit cold.",
          "웍 셋, 요리 스크립트 하나. 계란을 하나씩 부치는 동안 나머지 웍 둘은 식어 있어.",
          "三隻鑊，一個煮食 script。一次煎一隻蛋，另外兩隻鑊凍住。"
        ),
      },
      {
        kind = "hero",
        x = 900,
        facing = -1,
        line = L(
          "Goroutines, then. What is the Python word?",
          "그럼 고루틴이네. Python 단어는 뭐야?",
          "咁即係 goroutine。Python 叫咩？"
        ),
      },
    },
    viz = "python",
    chips = {
      { "Thread(target=fry)", "cyan" },
      { "t.start(); t.join()", "gold" },
      { "with lock:", "pink" },
      { "ThreadPoolExecutor(4)", "green" },
    },
    note = "Thread  start  join  Lock  Executor  GIL",
    story = L(
      "23:00. The last orders of the night hit three woks. The cook script runs them one after another. "
        .. "Threads will overlap the waiting; the GIL means they will not overlap the arithmetic. "
        .. "For frying, waiting is all that matters.",
      "23:00. 밤의 마지막 주문들이 웍 셋에 떨어진다. 요리 스크립트는 차례로 처리한다. "
        .. "스레드는 기다림을 겹치게 하지만 GIL 때문에 계산은 겹치지 않는다. 부치는 일엔 기다림이 전부다.",
      "晚上十一點。今晚最後幾張單落到三隻鑊。煮食 script 逐個處理。"
        .. "thread 會令等待重疊；GIL 意味着計算唔會重疊。煎嘢嘅話，等待就係一切。"
    ),
    stages = {
      {
        topic = "THREAD",
        q = L(
          "Run fry beside the main thread. Which class from threading?",
          "메인 스레드 옆에서 fry 실행. threading의 어떤 클래스?",
          "喺 main thread 旁邊跑 fry。threading 嘅邊個 class？"
        ),
        code = L(
          [[
import threading

t = threading.___(target=fry, args=("egg",))
]],
          [[
import threading

t = threading.___(target=fry, args=("egg",))
]],
          [[
import threading

t = threading.___(target=fry, args=("egg",))
]]
        ),
        accept = { "Thread" },
        answer = "Thread",
        hint = L(
          "The module name, singular, capitalized. Go's go keyword, as an object.",
          "모듈 이름의 단수형, 대문자로. Go의 go 키워드를 객체로.",
          "個 module 嘅名，單數，大楷。Go 嘅 go keyword，變成一個 object。"
        ),
        ok = L(
          "Thread(target=fn, args=(...)) wraps a call. It is an OS thread, heavier than a goroutine, fine for I/O.",
          "Thread(target=fn, args=(...))가 호출을 감싼다. OS 스레드라 고루틴보다 무겁지만 I/O엔 충분.",
          "Thread(target=fn, args=(...)) 包住一個 call。係 OS thread，重過 goroutine，做 I/O 就啱。"
        ),
      },
      {
        topic = "START",
        q = L(
          "Nothing runs yet. Which method actually starts the thread?",
          "아직 아무것도 실행되지 않는다. 스레드를 실제로 시작하는 메서드는?",
          "暫時咩都未跑。邊個 method 真正開始個 thread？"
        ),
        code = L(
          [[
t = threading.Thread(target=fry, args=("egg",))
t.___()
print("frying in the background")
]],
          [[
t = threading.Thread(target=fry, args=("egg",))
t.___()
print("frying in the background")
]],
          [[
t = threading.Thread(target=fry, args=("egg",))
t.___()
print("frying in the background")
]]
        ),
        accept = { "start" },
        answer = "start",
        hint = L(
          "Five letters, the opposite of stop. Not run(): that would call fry in the current thread.",
          "다섯 글자, stop의 반대. run()이 아니다: 그건 현재 스레드에서 fry를 호출한다.",
          "五個字母，stop 嘅相反。唔係 run()：嗰個會喺當前 thread call fry。"
        ),
        ok = L(
          "t.start() spawns the OS thread and returns at once. t.run() is the body; calling it yourself gains nothing.",
          "t.start()는 OS 스레드를 만들고 즉시 반환. t.run()은 본문. 직접 부르면 얻는 게 없다.",
          "t.start() 生一個 OS thread 並即刻返。t.run() 係 body；自己 call 咩都冇得着。"
        ),
      },
      {
        topic = "JOIN",
        q = L(
          "Wait for all three woks before printing the receipt. Which method blocks until a thread is done?",
          "영수증을 찍기 전에 웍 셋을 기다리기. 스레드가 끝날 때까지 막는 메서드는?",
          "印收據之前等齊三隻鑊。邊個 method 阻塞到 thread 完成？"
        ),
        code = L(
          [[
for t in threads:
    t.start()
for t in threads:
    t.___()
print("all served")
]],
          [[
for t in threads:
    t.start()
for t in threads:
    t.___()
print("all served")
]],
          [[
for t in threads:
    t.start()
for t in threads:
    t.___()
print("all served")
]]
        ),
        accept = { "join" },
        answer = "join",
        hint = L(
          "Four letters, the same word Rust's JoinHandle uses. Go spells it wg.Wait().",
          "네 글자, Rust의 JoinHandle이 쓰는 단어. Go는 wg.Wait().",
          "四個字母，Rust 嘅 JoinHandle 用嘅同一個字。Go 寫 wg.Wait()。"
        ),
        ok = L(
          "Start them all first, then join them all: otherwise the second loop waits for the first wok before lighting the second.",
          "먼저 전부 start, 그다음 전부 join: 아니면 둘째 루프가 둘째 웍에 불을 붙이기 전에 첫 웍을 기다린다.",
          "先全部 start，再全部 join：否則第二個 loop 會等第一隻鑊完先點第二隻。"
        ),
      },
      {
        topic = "LOCK",
        q = L(
          "Three threads add to one counter. Which threading object guards it?",
          "스레드 셋이 카운터 하나에 더한다. 지키는 threading 객체는?",
          "三個 thread 加同一個 counter。邊個 threading object 守住佢？"
        ),
        code = L(
          [[
lock = threading.___()
served = 0

def serve():
    global served
    with lock:
        served += 1
]],
          [[
lock = threading.___()
served = 0

def serve():
    global served
    with lock:
        served += 1
]],
          [[
lock = threading.___()
served = 0

def serve():
    global served
    with lock:
        served += 1
]]
        ),
        accept = { "Lock" },
        answer = "Lock",
        hint = L(
          "Four letters, capitalized; Go calls it a Mutex. with acquires and releases it.",
          "네 글자, 대문자로. Go는 Mutex라 부른다. with가 잡고 놓는다.",
          "四個字母，大楷；Go 叫 Mutex。with 攞住再放開。"
        ),
        ok = L(
          "with lock: is acquire and release, even on error. served += 1 is not atomic, GIL or no GIL.",
          "with lock:은 acquire와 release, 에러가 나도. served += 1은 GIL이 있든 없든 원자적이지 않다.",
          "with lock: 就係 acquire 加 release，出錯都會放。served += 1 唔係 atomic，有冇 GIL 都一樣。"
        ),
      },
      {
        topic = "POOL",
        q = L(
          "Four workers, many eggs, no hand-made threads. Which executor from concurrent.futures?",
          "워커 넷, 계란 여러 개, 수제 스레드 없이. concurrent.futures의 어떤 executor?",
          "四個 worker，好多蛋，唔手動開 thread。concurrent.futures 嘅邊個 executor？"
        ),
        code = L(
          [[
from concurrent.futures import ThreadPoolExecutor

with ___(max_workers=4) as pool:
    done = list(pool.map(fry, eggs))
]],
          [[
from concurrent.futures import ThreadPoolExecutor

with ___(max_workers=4) as pool:
    done = list(pool.map(fry, eggs))
]],
          [[
from concurrent.futures import ThreadPoolExecutor

with ___(max_workers=4) as pool:
    done = list(pool.map(fry, eggs))
]]
        ),
        accept = { "ThreadPoolExecutor" },
        answer = "ThreadPoolExecutor",
        hint = L(
          "The name imported on the first line: a pool of threads that executes.",
          "첫 줄에서 import한 이름: 실행하는 스레드의 풀.",
          "第一行 import 嘅個名：一個會執行嘅 thread pool。"
        ),
        ok = L(
          "pool.map keeps order; pool.submit returns a Future. ProcessPoolExecutor is the same API on processes, past the GIL.",
          "pool.map은 순서 유지. pool.submit은 Future 반환. ProcessPoolExecutor는 같은 API를 프로세스로, GIL을 넘어서.",
          "pool.map 保持次序；pool.submit 回傳 Future。ProcessPoolExecutor 係同一個 API 但用 process，越過 GIL。"
        ),
      },
      {
        topic = "GIL",
        q = L(
          "Why do four threads not make four times the arithmetic? Name the lock, three letters.",
          "왜 스레드 넷이 계산을 네 배로 하지 못하나? 그 락의 이름, 세 글자.",
          "點解四個 thread 唔會做四倍計算？講出個鎖嘅名，三個字母。"
        ),
        code = L(
          [[
# One thread runs Python bytecode at a time: the ___.
# Threads overlap I/O and sleep, not CPU work.
# For CPU-bound work use multiprocessing.
]],
          [[
# 한 번에 한 스레드만 바이트코드 실행: ___.
# 스레드는 I/O와 sleep만 겹친다, CPU는 아니다.
# CPU 위주 작업엔 multiprocessing.
]],
          [[
# 一次只有一個 thread 跑 Python bytecode：___。
# thread 重疊 I/O 同 sleep，唔重疊 CPU 工作。
# CPU 密集嘅工作用 multiprocessing。
]]
        ),
        accept = { "GIL", "global interpreter lock" },
        answer = "GIL",
        hint = L(
          "Global Interpreter Lock, by its initials.",
          "Global Interpreter Lock의 머리글자.",
          "Global Interpreter Lock 嘅縮寫。"
        ),
        ok = L(
          "The GIL serializes bytecode; C extensions and I/O release it. Python 3.13 can build without it. Three woks fry at once; the shift is over.",
          "GIL이 바이트코드를 직렬화한다. C 확장과 I/O는 놓아준다. Python 3.13은 GIL 없이 빌드할 수 있다. 웍 셋이 동시에 부친다. 근무 끝.",
          "GIL 將 bytecode 串行化；C extension 同 I/O 會放開佢。Python 3.13 可以 build 成冇 GIL。三隻鑊同時煎；夜班完。"
        ),
      },
    },
  },
}

return maps
