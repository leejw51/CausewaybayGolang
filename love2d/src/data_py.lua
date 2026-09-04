-- Quest P1 BASIC: NIGHT SHIFT - the kitchen. 21:00. Lucky Mac closes at
-- 23:00 and the night shift runs on Chef Bo's Python scripts: stock count,
-- the order robot, the receipts. Tonight every station's script is stuck.
-- Alex knows Go and a little Rust; Chef Bo teaches Python with Monty, the
-- python on the laptop sticker, watching.
--
-- Text fields are L(en, ko, yue) tables. Code is the same Python in every
-- language; only comments are translated. Max 7 lines per code block.

local function L(en, ko, yue)
  return { en = en, ko = ko, yue = yue }
end

local maps = {
  {
    id = "py_print",
    station = "PRINT",
    name = L("The pass, 21:00", "패스, 21:00", "出餐口，晚上九點"),
    title = L("Hello, Python", "안녕, Python", "Hello，Python"),
    lesson = L(
      "print writes a line. # starts a comment. f-strings put values in text. import brings a module in.",
      "print는 한 줄을 출력. #은 주석 시작. f-string은 텍스트에 값을 넣는다. import는 모듈을 가져온다.",
      "print 印一行。# 開始註解。f-string 將值放入文字。import 帶入 module。"
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
          "Night shift. Every station runs a Python script I wrote. Tonight none of them start.",
          "야간 근무야. 모든 스테이션이 내가 쓴 Python 스크립트로 돌아가. 오늘 밤엔 하나도 안 켜져.",
          "夜班。每個崗位都跑我寫嘅 Python script。今晚一個都開唔到。"
        ),
      },
      {
        kind = "mei",
        x = 700,
        facing = -1,
        line = L(
          "Python has no braces, Alex. The indentation is the block.",
          "Python엔 중괄호가 없어, 알렉스. 들여쓰기가 블록이야.",
          "Python 冇大括號，阿力。縮排就係 block。"
        ),
      },
    },
    viz = "python",
    chips = {
      { 'print("open")', "cyan" },
      { 'f"{n} tables"', "gold" },
      { "import time", "pink" },
      { '__name__ == "__main__"', "green" },
    },
    note = "print  #  f-string  import  input  __main__",
    story = L(
      "21:00. The morning set is long gone and the Rust afternoon is over. Lucky Mac's night shift "
        .. "runs on Python scripts Chef Bo wrote years ago. Tonight the pass screen is blank. "
        .. "Bo hands Alex the laptop; a blue and yellow snake sticker on the lid seems to grin.",
      "21:00. 모닝세트는 오래전 이야기고 Rust의 오후도 끝났다. 럭키 맥의 야간 근무는 "
        .. "보 셰프가 몇 년 전에 쓴 Python 스크립트로 돌아간다. 오늘 밤 패스 화면이 비어 있다. "
        .. "보가 알렉스에게 노트북을 건넨다. 뚜껑의 파랑 노랑 뱀 스티커가 웃는 것 같다.",
      "晚上九點。早餐套餐早已過去，Rust 嘅下晝亦完咗。幸運麥嘅夜班"
        .. "靠寶廚幾年前寫嘅 Python script 運作。今晚出餐口個 mon 係黑嘅。"
        .. "寶廚將部電腦交畀阿力；蓋上面隻藍黃色蛇貼紙好似喺笑。"
    ),
    stages = {
      {
        topic = "PRINT",
        q = L(
          "Which built-in writes a line to the terminal?",
          "터미널에 한 줄을 출력하는 내장 함수는?",
          "邊個內建 function 將一行印去終端機？"
        ),
        code = L(
          [[
___("Lucky Mac night shift")
]],
          [[
___("Lucky Mac night shift")
]],
          [[
___("Lucky Mac night shift")
]]
        ),
        accept = { "print" },
        answer = "print",
        hint = L(
          "Five letters, lowercase, no package in front of it. Go needs fmt for this; Python does not.",
          "다섯 글자, 소문자, 앞에 패키지 없음. Go는 fmt가 필요하지만 Python은 아니다.",
          "五個字母，細楷，前面冇 package。Go 要 fmt，Python 唔使。"
        ),
        ok = L(
          "print() is a built-in: no import, no package. Python 3 needs the parentheses. The pass screen lights up.",
          "print()는 내장 함수: import도 패키지도 없다. Python 3는 괄호가 필요하다. 패스 화면이 켜진다.",
          "print() 係內建：唔使 import，唔使 package。Python 3 要括號。出餐口個 mon 亮咗。"
        ),
      },
      {
        topic = "COMMENT",
        q = L(
          "Python ignores the rest of a line after which character?",
          "Python은 어떤 문자 뒤의 나머지 줄을 무시하나요?",
          "Python 會無視邊個字元之後嘅成行？"
        ),
        code = L(
          [[
___ night shift starts at 21:00
print("open")
]],
          [[
___ 야간 근무는 21:00에 시작
print("open")
]],
          [[
___ 夜班晚上九點開始
print("open")
]]
        ),
        accept = { "#" },
        answer = "#",
        hint = L(
          "One character. Go and Rust use two slashes; Python uses the hash sign.",
          "한 글자. Go와 Rust는 슬래시 두 개, Python은 해시 기호.",
          "一個字元。Go 同 Rust 用兩條斜線；Python 用井號。"
        ),
        ok = L(
          "# starts a comment. There is no block comment; a triple-quoted string at the top of a def is a docstring.",
          "#은 주석 시작. 블록 주석은 없다. def 맨 위의 삼중 따옴표 문자열은 docstring.",
          "# 開始註解。冇 block 註解；def 頂部嘅三重引號字串係 docstring。"
        ),
      },
      {
        topic = "FSTRING",
        q = L(
          "Which letter before the quote lets {n} be replaced by the value of n?",
          "따옴표 앞의 어떤 글자가 {n}을 n의 값으로 바꾸나요?",
          "引號前面邊個字母令 {n} 變成 n 嘅值？"
        ),
        code = L(
          [[
n = 4
print(___"tables open: {n}")
]],
          [[
n = 4
print(___"tables open: {n}")
]],
          [[
n = 4
print(___"tables open: {n}")
]]
        ),
        accept = { "f" },
        answer = "f",
        hint = L(
          "The first letter of format. Since Python 3.6.",
          "format의 첫 글자. Python 3.6부터.",
          "format 嘅第一個字母。Python 3.6 開始有。"
        ),
        ok = L(
          'f"..." is an f-string: any expression inside {} is evaluated. {n:>4} pads, {price:.2f} rounds.',
          'f"..."는 f-string: {} 안의 어떤 식이든 평가된다. {n:>4}는 패딩, {price:.2f}는 반올림.',
          'f"..." 係 f-string：{} 裏面任何 expression 都會計。{n:>4} 補位，{price:.2f} 四捨五入。'
        ),
      },
      {
        topic = "IMPORT",
        q = L(
          "Which keyword brings the time module in?",
          "time 모듈을 가져오는 키워드는?",
          "邊個 keyword 帶入 time module？"
        ),
        code = L(
          [[
___ time
time.sleep(1)     # let the wok heat
print("ready")
]],
          [[
___ time
time.sleep(1)     # 웍이 달궈지길 기다린다
print("ready")
]],
          [[
___ time
time.sleep(1)     # 等鑊熱
print("ready")
]]
        ),
        accept = { "import" },
        answer = "import",
        hint = L(
          "Same word as Go, no quotes, no parentheses. from x import y picks one name out.",
          "Go와 같은 단어, 따옴표도 괄호도 없이. from x import y는 이름 하나만 꺼낸다.",
          "同 Go 同一個字，冇引號冇括號。from x import y 只攞一個名。"
        ),
        ok = L(
          "import time binds the module; time.sleep reaches into it. from time import sleep would bind just sleep.",
          "import time은 모듈을 바인딩. time.sleep으로 안에 접근. from time import sleep은 sleep만 바인딩.",
          "import time 綁定個 module；time.sleep 伸入去攞。from time import sleep 只會綁定 sleep。"
        ),
      },
      {
        topic = "INPUT",
        q = L(
          "Which built-in reads a line typed at the terminal?",
          "터미널에 입력된 한 줄을 읽는 내장 함수는?",
          "邊個內建 function 讀終端機打入嘅一行？"
        ),
        code = L(
          [[
name = ___("Order for: ")
print(f"one bowl for {name}")
]],
          [[
name = ___("Order for: ")
print(f"one bowl for {name}")
]],
          [[
name = ___("Order for: ")
print(f"one bowl for {name}")
]]
        ),
        accept = { "input" },
        answer = "input",
        hint = L(
          "The opposite of output. It shows the prompt and returns a str, always a str.",
          "output의 반대. 프롬프트를 보이고 str을 반환한다, 항상 str.",
          "output 嘅相反。顯示提示，回傳 str，永遠係 str。"
        ),
        ok = L(
          "input() returns text. int(input()) if you need a number. The robot takes its first order.",
          "input()은 텍스트를 반환. 숫자가 필요하면 int(input()). 로봇이 첫 주문을 받는다.",
          "input() 回傳文字。要數字就 int(input())。機械人接到第一張單。"
        ),
      },
      {
        topic = "MAIN",
        q = L(
          "What is __name__ equal to when the file is run directly, not imported?",
          "파일이 import되지 않고 직접 실행될 때 __name__의 값은?",
          "檔案直接執行而唔係被 import 嗰陣，__name__ 等於咩？"
        ),
        code = L(
          [[
def main():
    print("night shift")

if __name__ == "___":
    main()
]],
          [[
def main():
    print("night shift")

if __name__ == "___":
    main()
]],
          [[
def main():
    print("night shift")

if __name__ == "___":
    main()
]]
        ),
        accept = { "__main__", "main" },
        answer = "__main__",
        hint = L(
          "Two underscores, the name of the function above, two underscores. As a module the value would be the file name.",
          "밑줄 둘, 위 함수의 이름, 밑줄 둘. 모듈로 쓰이면 값은 파일 이름이 된다.",
          "兩條底線、上面個 function 嘅名、兩條底線。作為 module 嗰陣值會係檔名。"
        ),
        ok = L(
          "The __name__ guard: the script runs main() when executed, stays quiet when imported. The shift begins.",
          "__name__ 가드: 실행되면 main()을 돌리고, import되면 조용히 있다. 근무 시작.",
          "__name__ guard：執行嗰陣跑 main()，被 import 就靜靜地。夜班開始。"
        ),
      },
    },
  },
  {
    id = "py_vars",
    station = "VARS",
    name = L("The stock room", "재고실", "貨倉"),
    title = L("Numbers, strings, None", "숫자, 문자열, None", "數字、字串、None"),
    lesson = L(
      "Variables need no type. int() and str() convert. // divides down, ** is power. None is no value.",
      "변수엔 타입이 필요 없다. int()와 str()로 변환. //는 내림 나눗셈, **는 거듭제곱. None은 값 없음.",
      "變數唔使寫 type。int() 同 str() 轉換。// 向下除，** 係次方。None 係冇值。"
    ),
    bg = "bg_till",
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
          "The stock script counts trays. It says we have 4.1666 trays of eggs. We do not.",
          "재고 스크립트가 트레이를 세는데 계란 트레이가 4.1666개래. 그럴 리가.",
          "存貨 script 數盤數，話我哋有 4.1666 盤蛋。點會呀。"
        ),
      },
    },
    viz = "python",
    chips = {
      { 'qty = int("12")', "cyan" },
      { "25 // 6  ->  4", "gold" },
      { "2 ** 10", "pink" },
      { "note = None", "green" },
    },
    note = "int  str  //  **  type  None",
    story = L(
      "The stock room. A script counts eggs, trays and coffee beans, and it has been "
        .. "dividing with the wrong slash all year. Alex has typed := ten thousand times; "
        .. "here a plain = will do, and there is no type to write.",
      "재고실. 스크립트가 계란, 트레이, 커피콩을 세는데 일 년 내내 잘못된 슬래시로 나누고 있었다. "
        .. "알렉스는 :=를 만 번쯤 쳤다. 여기선 그냥 =면 되고 쓸 타입도 없다.",
      "貨倉。有個 script 數蛋、盤同咖啡豆，成年都用錯咗條斜線嚟除。"
        .. "阿力打過一萬次 :=；呢度一個 = 就夠，亦冇 type 要寫。"
    ),
    stages = {
      {
        topic = "INT",
        q = L(
          'The till sends "12" as text. Which built-in turns it into a whole number?',
          '계산대가 "12"를 텍스트로 보낸다. 정수로 바꾸는 내장 함수는?',
          '收銀機送 "12" 過嚟係文字。邊個內建 function 變佢做整數？'
        ),
        code = L(
          [[
raw = "12"
qty = ___(raw)
print(qty + 1)     # 13, not "121"
]],
          [[
raw = "12"
qty = ___(raw)
print(qty + 1)     # 13, "121"이 아니라
]],
          [[
raw = "12"
qty = ___(raw)
print(qty + 1)     # 13，唔係 "121"
]]
        ),
        accept = { "int" },
        answer = "int",
        hint = L(
          "Three letters, the name of the type itself. float() is its cousin.",
          "세 글자, 타입의 이름 그대로. float()이 그 사촌.",
          "三個字母，就係個 type 嘅名。float() 係佢表親。"
        ),
        ok = L(
          'int("12") is 12. int("12.5") raises ValueError; float first if the text has a dot.',
          'int("12")는 12. int("12.5")는 ValueError. 점이 있으면 float 먼저.',
          'int("12") 係 12。int("12.5") 會拋 ValueError；有小數點就先 float。'
        ),
      },
      {
        topic = "NONE",
        q = L(
          "No note on the order yet. Which value means 'nothing here'?",
          "주문에 아직 메모가 없다. '여기엔 아무것도 없다'를 뜻하는 값은?",
          "張單暫時冇備註。邊個值代表「呢度冇嘢」？"
        ),
        code = L(
          [[
note = ___          # nothing yet
if not note:
    print("no note")
]],
          [[
note = ___          # 아직 없음
if not note:
    print("no note")
]],
          [[
note = ___          # 暫時冇
if not note:
    print("no note")
]]
        ),
        accept = { "None" },
        answer = "None",
        hint = L(
          "Capital N. Go's nil, Rust's Option::None. Compare it with is, not ==.",
          "대문자 N. Go의 nil, Rust의 Option::None. ==가 아니라 is로 비교.",
          "大楷 N。Go 嘅 nil，Rust 嘅 Option::None。用 is 比較，唔係 ==。"
        ),
        ok = L(
          "None is the one value of NoneType. A function with no return gives None too.",
          "None은 NoneType의 유일한 값. return 없는 함수도 None을 준다.",
          "None 係 NoneType 唯一嘅值。冇 return 嘅 function 都會畀 None。"
        ),
      },
      {
        topic = "FLOOR",
        q = L(
          "25 eggs, 6 per tray: how many whole trays? Which operator divides and rounds down?",
          "계란 25개, 트레이당 6개: 온전한 트레이는 몇 개? 나눈 뒤 내림하는 연산자는?",
          "25 隻蛋，每盤 6 隻：有幾多個完整嘅盤？邊個運算符除完向下取整？"
        ),
        code = L(
          [[
eggs = 25
trays = eggs ___ 6      # whole trays
left = eggs % 6         # 1 egg over
print(trays, left)
]],
          [[
eggs = 25
trays = eggs ___ 6      # 온전한 트레이
left = eggs % 6         # 계란 1개 남음
print(trays, left)
]],
          [[
eggs = 25
trays = eggs ___ 6      # 完整嘅盤
left = eggs % 6         # 剩 1 隻蛋
print(trays, left)
]]
        ),
        accept = { "//" },
        answer = "//",
        hint = L(
          "Two of the same character. One of them alone gives 4.1666, a float, every time.",
          "같은 문자 두 개. 하나만 쓰면 언제나 4.1666, float.",
          "兩個同樣嘅字元。只用一個永遠畀你 4.1666，係 float。"
        ),
        ok = L(
          "25 // 6 is 4, 25 / 6 is 4.1666. In Python 3 a single slash always makes a float.",
          "25 // 6은 4, 25 / 6은 4.1666. Python 3에서 슬래시 하나는 항상 float.",
          "25 // 6 係 4，25 / 6 係 4.1666。Python 3 一條斜線永遠出 float。"
        ),
      },
      {
        topic = "POWER",
        q = L(
          "Which operator raises 2 to the tenth power?",
          "2의 10제곱을 구하는 연산자는?",
          "邊個運算符計 2 嘅 10 次方？"
        ),
        code = L(
          [[
kb = 2 ___ 10
print(kb)          # 1024
]],
          [[
kb = 2 ___ 10
print(kb)          # 1024
]],
          [[
kb = 2 ___ 10
print(kb)          # 1024
]]
        ),
        accept = { "**" },
        answer = "**",
        hint = L(
          "Two stars. Go has no operator for this; Python and Rust's pow() do.",
          "별표 두 개. Go엔 이 연산자가 없다. Python은 있고 Rust는 pow().",
          "兩個星號。Go 冇呢個運算符；Python 有，Rust 用 pow()。"
        ),
        ok = L(
          "2 ** 10 is 1024. 2 ** 0.5 is a square root. Ints never overflow in Python; they just grow.",
          "2 ** 10은 1024. 2 ** 0.5는 제곱근. Python의 int는 오버플로 없이 그냥 커진다.",
          "2 ** 10 係 1024。2 ** 0.5 係開方。Python 嘅 int 永遠唔會 overflow，只會愈來愈大。"
        ),
      },
      {
        topic = "TYPE",
        q = L(
          "Which built-in tells you what kind of value price is?",
          "price가 어떤 종류의 값인지 알려주는 내장 함수는?",
          "邊個內建 function 話你知 price 係咩類型嘅值？"
        ),
        code = L(
          [[
price = 18.5
print(___(price))    # <class 'float'>
]],
          [[
price = 18.5
print(___(price))    # <class 'float'>
]],
          [[
price = 18.5
print(___(price))    # <class 'float'>
]]
        ),
        accept = { "type" },
        answer = "type",
        hint = L(
          "Four letters. It answers the question 'what type is this'. isinstance(x, float) is the check you use in code.",
          "네 글자. '이건 무슨 타입이지'에 답한다. 코드에선 isinstance(x, float)로 검사.",
          "四個字母。答「呢個係咩 type」。寫 code 檢查就用 isinstance(x, float)。"
        ),
        ok = L(
          "type(price) is float. Python is dynamically typed: the value carries the type, the name does not.",
          "type(price)는 float. Python은 동적 타입: 타입은 값이 가지고 이름은 갖지 않는다.",
          "type(price) 係 float。Python 係動態型別：type 跟值走，唔跟名走。"
        ),
      },
      {
        topic = "STR",
        q = L(
          "Text plus a number fails. Which built-in turns 4 into text first?",
          "텍스트 더하기 숫자는 실패. 4를 먼저 텍스트로 바꾸는 내장 함수는?",
          "文字加數字會出錯。邊個內建 function 先將 4 變成文字？"
        ),
        code = L(
          [[
table = 4
label = "Table " + ___(table)
print(label)       # Table 4
]],
          [[
table = 4
label = "Table " + ___(table)
print(label)       # Table 4
]],
          [[
table = 4
label = "Table " + ___(table)
print(label)       # Table 4
]]
        ),
        accept = { "str" },
        answer = "str",
        hint = L(
          "Three letters, the text type's own name. An f-string would do the same without the call.",
          "세 글자, 텍스트 타입 자신의 이름. f-string이면 호출 없이 같은 일을 한다.",
          "三個字母，文字 type 自己嘅名。用 f-string 就唔使 call 都得。"
        ),
        ok = L(
          'str(4) is "4". "Table " + 4 raises TypeError: Python never converts silently. The stock count comes out whole.',
          'str(4)는 "4". "Table " + 4는 TypeError: Python은 조용히 변환하지 않는다. 재고 수가 정수로 나온다.',
          'str(4) 係 "4"。"Table " + 4 會拋 TypeError：Python 從來唔會靜靜地幫你轉。存貨數目終於係整數。'
        ),
      },
    },
  },
  {
    id = "py_flow",
    station = "FLOW",
    name = L("The shutter queue", "셔터 앞 줄", "閘門前嘅隊"),
    title = L("if, for, while", "if, for, while의 흐름", "if、for、while"),
    lesson = L(
      "Blocks are indented, no braces. elif chains ifs. for walks anything iterable; range counts. while loops on a condition.",
      "블록은 들여쓰기, 중괄호 없음. elif로 if를 잇는다. for는 반복 가능한 무엇이든 순회, range는 카운트. while은 조건 반복.",
      "block 靠縮排，冇大括號。elif 串起 if。for 行任何 iterable；range 數數。while 靠條件循環。"
    ),
    bg = "bg_night",
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
          "Last customers before the shutter. The queue script decides who gets a bowl.",
          "셔터 내리기 전 마지막 손님들. 줄 스크립트가 누가 국수를 받을지 정해.",
          "落閘前最後幾個客。排隊 script 決定邊個有碗麵。"
        ),
      },
      {
        kind = "clerk",
        x = 900,
        facing = -1,
        line = L(
          "Three bowls left. If it says zero, we close.",
          "세 그릇 남았어요. 0이라고 나오면 문 닫습니다.",
          "剩三碗。佢話零就收工。"
        ),
      },
    },
    viz = "python",
    chips = {
      { "if n == 0: ...", "cyan" },
      { "elif n < 3:", "gold" },
      { "for i in range(3):", "pink" },
      { "while queue:", "green" },
    },
    note = "if  elif  else  for  range  while  break  in",
    story = L(
      "22:15. The shutter is half down and a small queue waits outside. Chef Bo's queue "
        .. "script counts bowls and people. It is missing every keyword that makes a decision. "
        .. "Mei reads Python like a recipe: colon, then indent.",
      "22:15. 셔터가 반쯤 내려왔고 밖에 짧은 줄이 기다린다. 보 셰프의 줄 스크립트는 "
        .. "그릇과 사람을 센다. 결정을 내리는 키워드가 전부 빠져 있다. 메이는 Python을 레시피처럼 읽는다: 콜론, 그다음 들여쓰기.",
      "晚上十點十五分。閘門落咗一半，外面有條短隊等住。寶廚嘅排隊 script "
        .. "數碗數人。所有做決定嘅 keyword 都冇咗。阿美讀 Python 好似讀食譜：冒號，然後縮排。"
    ),
    stages = {
      {
        topic = "ELIF",
        q = L(
          "A second test after an if. Which keyword is Python's 'else if'?",
          "if 다음의 두 번째 검사. Python의 'else if'는 어떤 키워드?",
          "if 之後第二個測試。Python 嘅「else if」係邊個 keyword？"
        ),
        code = L(
          [[
if bowls == 0:
    print("closed")
___ bowls < 3:
    print("almost out")
else:
    print("open")
]],
          [[
if bowls == 0:
    print("closed")
___ bowls < 3:
    print("almost out")
else:
    print("open")
]],
          [[
if bowls == 0:
    print("closed")
___ bowls < 3:
    print("almost out")
else:
    print("open")
]]
        ),
        accept = { "elif" },
        answer = "elif",
        hint = L(
          "Four letters: else and if squeezed into one word.",
          "네 글자: else와 if를 한 단어로 눌러 붙인 것.",
          "四個字母：else 同 if 夾埋一個字。"
        ),
        ok = L(
          "elif chains tests top to bottom; the first true branch runs, the rest are skipped. No switch in Python before match.",
          "elif는 검사를 위에서 아래로 잇는다. 첫 참 분기만 실행, 나머지는 건너뜀. match 이전의 Python엔 switch가 없다.",
          "elif 由上到下串起測試；第一個 true 嘅 branch 執行，其餘跳過。match 之前 Python 冇 switch。"
        ),
      },
      {
        topic = "RANGE",
        q = L(
          "Serve three bowls, numbered 0, 1, 2. Which built-in counts for the for loop?",
          "그릇 셋을 0, 1, 2번으로 내놓기. for 루프에 숫자를 세어주는 내장 함수는?",
          "出三碗，編號 0、1、2。邊個內建 function 幫 for loop 數數？"
        ),
        code = L(
          [[
for i in ___(3):
    print("bowl", i)
]],
          [[
for i in ___(3):
    print("bowl", i)
]],
          [[
for i in ___(3):
    print("bowl", i)
]]
        ),
        accept = { "range" },
        answer = "range",
        hint = L(
          "Five letters. Go 1.22 borrowed the idea as for i := range 3.",
          "다섯 글자. Go 1.22가 for i := range 3으로 이 아이디어를 빌려갔다.",
          "五個字母。Go 1.22 借咗呢個概念，寫成 for i := range 3。"
        ),
        ok = L(
          "range(3) yields 0, 1, 2. range(1, 4) starts at 1; range(0, 10, 2) steps by two. It is lazy: nothing is built.",
          "range(3)은 0, 1, 2. range(1, 4)는 1부터. range(0, 10, 2)는 둘씩. 지연 평가: 리스트를 만들지 않는다.",
          "range(3) 畀 0、1、2。range(1, 4) 由 1 開始；range(0, 10, 2) 每次跳兩格。佢係 lazy 嘅：唔會真係整個 list。"
        ),
      },
      {
        topic = "WHILE",
        q = L(
          "Keep serving as long as the queue is not empty. Which keyword loops on a condition?",
          "줄이 비지 않은 동안 계속 내놓기. 조건으로 반복하는 키워드는?",
          "只要條隊唔係空就繼續出餐。邊個 keyword 靠條件循環？"
        ),
        code = L(
          [[
___ queue:
    person = queue.pop(0)
    print("bowl for", person)
]],
          [[
___ queue:
    person = queue.pop(0)
    print("bowl for", person)
]],
          [[
___ queue:
    person = queue.pop(0)
    print("bowl for", person)
]]
        ),
        accept = { "while" },
        answer = "while",
        hint = L(
          "Go spells every loop for; Python has this second word for the condition-only loop.",
          "Go는 모든 루프를 for로 쓴다. Python은 조건만 보는 루프에 두 번째 단어가 있다.",
          "Go 所有 loop 都寫 for；Python 有第二個字專門畀只看條件嘅 loop。"
        ),
        ok = L(
          'while queue: runs while the list is truthy, i.e. not empty. An empty list, 0, None and "" are all False.',
          'while queue:는 리스트가 참인 동안, 즉 비지 않은 동안 실행. 빈 리스트, 0, None, ""는 모두 False.',
          'while queue: 喺個 list 係 truthy（即係唔空）嗰陣行。空 list、0、None 同 "" 全部係 False。'
        ),
      },
      {
        topic = "BREAK",
        q = L(
          "The pot is empty mid-loop. Which keyword leaves the loop at once?",
          "루프 도중 솥이 비었다. 루프를 즉시 벗어나는 키워드는?",
          "loop 中途個煲空咗。邊個 keyword 即刻離開 loop？"
        ),
        code = L(
          [[
for person in queue:
    if bowls == 0:
        ___
    bowls -= 1
    print("bowl for", person)
]],
          [[
for person in queue:
    if bowls == 0:
        ___
    bowls -= 1
    print("bowl for", person)
]],
          [[
for person in queue:
    if bowls == 0:
        ___
    bowls -= 1
    print("bowl for", person)
]]
        ),
        accept = { "break" },
        answer = "break",
        hint = L(
          "Same word as Go and Rust. Its sibling skips to the next turn instead.",
          "Go, Rust와 같은 단어. 형제 키워드는 대신 다음 차례로 건너뛴다.",
          "同 Go、Rust 同一個字。佢兄弟係跳去下一輪。"
        ),
        ok = L(
          "break ends the loop; continue skips to the next item. A for loop may have an else: that runs only if no break happened.",
          "break는 루프 종료, continue는 다음 항목으로. for 루프엔 else를 붙일 수 있다: break가 없었을 때만 실행.",
          "break 結束 loop；continue 跳去下一個。for loop 可以有 else：只有冇 break 過先會行。"
        ),
      },
      {
        topic = "IN",
        q = L(
          "Does the order contain egg? Which keyword tests membership?",
          "주문에 egg가 있나? 포함 여부를 검사하는 키워드는?",
          "張單有冇 egg？邊個 keyword 測試有冇包含？"
        ),
        code = L(
          [[
order = ["noodles", "egg", "tea"]
if "egg" ___ order:
    print("fry one")
]],
          [[
order = ["noodles", "egg", "tea"]
if "egg" ___ order:
    print("fry one")
]],
          [[
order = ["noodles", "egg", "tea"]
if "egg" ___ order:
    print("fry one")
]]
        ),
        accept = { "in" },
        answer = "in",
        hint = L(
          "Two letters, the same word the for loop uses between the name and the list.",
          "두 글자, for 루프가 이름과 리스트 사이에 쓰는 바로 그 단어.",
          "兩個字母，for loop 喺名同 list 之間用嘅同一個字。"
        ),
        ok = L(
          'x in list is O(n); x in set or dict is O(1). not in is the negative. Works on strings too: "eg" in "egg".',
          'x in list는 O(n), x in set이나 dict는 O(1). not in은 부정. 문자열에도 된다: "eg" in "egg".',
          'x in list 係 O(n)；x in set 或 dict 係 O(1)。not in 係否定。字串都得："eg" in "egg"。'
        ),
      },
      {
        topic = "TERNARY",
        q = L(
          "One line: 'open' when bowls remain, otherwise 'closed'. Which keyword completes the conditional expression?",
          "한 줄: 그릇이 남으면 'open', 아니면 'closed'. 조건식을 완성하는 키워드는?",
          "一行：有碗就「open」，否則「closed」。邊個 keyword 完成呢個條件式？"
        ),
        code = L(
          [[
sign = "open" if bowls > 0 ___ "closed"
print(sign)
]],
          [[
sign = "open" if bowls > 0 ___ "closed"
print(sign)
]],
          [[
sign = "open" if bowls > 0 ___ "closed"
print(sign)
]]
        ),
        accept = { "else" },
        answer = "else",
        hint = L(
          "The word that follows an if block, here in the middle of one line. Python has no ? : operator.",
          "if 블록 뒤에 오는 단어, 여기선 한 줄 가운데. Python엔 ? : 연산자가 없다.",
          "跟喺 if block 後面嘅字，呢度放喺一行中間。Python 冇 ? : 運算符。"
        ),
        ok = L(
          "a if cond else b reads left to right like English. The shutter sign flips to 'closed' at the last bowl.",
          "a if cond else b는 영어처럼 왼쪽에서 오른쪽으로 읽힌다. 마지막 그릇에 셔터 간판이 'closed'로 바뀐다.",
          "a if cond else b 由左至右好似英文咁讀。最後一碗出完，閘門個牌轉做「closed」。"
        ),
      },
    },
  },
  {
    id = "py_funcs",
    station = "FUNCS",
    name = L("The pass window", "패스 창", "出餐窗口"),
    title = L("def, return, *args, lambda", "def와 return, *args, lambda", "def、return、*args、lambda"),
    lesson = L(
      "def names a function. return hands a value back; without it you get None. *items packs positional args, **opts keyword args. lambda is a one-line function.",
      "def가 함수를 이름 짓는다. return이 값을 돌려준다, 없으면 None. *items는 위치 인자, **opts는 키워드 인자를 묶는다. lambda는 한 줄 함수.",
      "def 為 function 命名。return 交返個值；冇就係 None。*items 包起位置參數，**opts 包起 keyword 參數。lambda 係一行 function。"
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
        x = 560,
        facing = -1,
        line = L(
          "Every dish is a function. fry(egg), brew(tea). Someone deleted the word that starts them.",
          "모든 요리가 함수야. fry(egg), brew(tea). 누가 함수를 시작하는 단어를 지워버렸어.",
          "每道菜都係一個 function。fry(egg)、brew(tea)。有人刪咗開頭嗰個字。"
        ),
      },
    },
    viz = "python",
    chips = {
      { "def fry(item):", "cyan" },
      { "return total", "gold" },
      { "def total(*items):", "pink" },
      { "key=lambda o: o.price", "green" },
    },
    note = "def  return  *items  **opts  lambda  None",
    story = L(
      "The pass window, 22:30. Chef Bo's recipe file is a list of functions: fry, brew, plate. "
        .. "Alex knows func; here it is three letters and a colon, and the body is whatever is indented under it.",
      "패스 창, 22:30. 보 셰프의 레시피 파일은 함수 목록이다: fry, brew, plate. "
        .. "알렉스는 func를 안다. 여기선 세 글자와 콜론, 본문은 그 아래 들여쓴 전부.",
      "出餐窗口，晚上十點半。寶廚嘅食譜檔係一個 function list：fry、brew、plate。"
        .. "阿力識 func；呢度係三個字母加一個冒號，body 就係下面縮排嘅所有嘢。"
    ),
    stages = {
      {
        topic = "DEF",
        q = L(
          "Which keyword starts a function definition?",
          "함수 정의를 시작하는 키워드는?",
          "邊個 keyword 開始一個 function 定義？"
        ),
        code = L(
          [[
___ fry(item):
    print("frying", item)

fry("egg")
]],
          [[
___ fry(item):
    print("frying", item)

fry("egg")
]],
          [[
___ fry(item):
    print("frying", item)

fry("egg")
]]
        ),
        accept = { "def" },
        answer = "def",
        hint = L(
          "Three letters, the start of 'define'. Go's func, Rust's fn.",
          "세 글자, 'define'의 앞부분. Go의 func, Rust의 fn.",
          "三個字母，「define」嘅開頭。Go 嘅 func，Rust 嘅 fn。"
        ),
        ok = L(
          "def fry(item): then an indented body. No types required, no braces. The wok script compiles, well, runs.",
          "def fry(item): 다음 들여쓴 본문. 타입도 중괄호도 필요 없다. 웍 스크립트가 컴파일, 아니 실행된다.",
          "def fry(item): 然後縮排嘅 body。唔使 type，唔使大括號。鑊 script compile 到，唔，係跑得到。"
        ),
      },
      {
        topic = "RETURN",
        q = L(
          "Hand the total back to the caller. Which keyword?",
          "합계를 호출자에게 돌려주기. 어떤 키워드?",
          "將總數交返畀 caller。邊個 keyword？"
        ),
        code = L(
          [[
def total(prices):
    s = 0
    for p in prices:
        s += p
    ___ s
]],
          [[
def total(prices):
    s = 0
    for p in prices:
        s += p
    ___ s
]],
          [[
def total(prices):
    s = 0
    for p in prices:
        s += p
    ___ s
]]
        ),
        accept = { "return" },
        answer = "return",
        hint = L(
          "Same word as Go. Rust can drop it on the last line; Python cannot.",
          "Go와 같은 단어. Rust는 마지막 줄에서 생략 가능, Python은 안 된다.",
          "同 Go 同一個字。Rust 最後一行可以慳返；Python 唔得。"
        ),
        ok = L(
          "return s. A function that falls off the end returns None. return a, b hands back a tuple.",
          "return s. 끝까지 떨어지는 함수는 None을 반환. return a, b는 튜플을 돌려준다.",
          "return s。行到尾冇 return 嘅 function 回傳 None。return a, b 交返一個 tuple。"
        ),
      },
      {
        topic = "ARGS",
        q = L(
          "total(3, 5) and total(3, 5, 8) should both work. How is the parameter written to take any number of items?",
          "total(3, 5)도 total(3, 5, 8)도 되어야 한다. 몇 개든 받도록 매개변수를 어떻게 쓰나?",
          "total(3, 5) 同 total(3, 5, 8) 都要得。參數點寫先收到任意數量？"
        ),
        code = L(
          [[
def total(___):
    return sum(items)

print(total(3, 5))
print(total(3, 5, 8))
]],
          [[
def total(___):
    return sum(items)

print(total(3, 5))
print(total(3, 5, 8))
]],
          [[
def total(___):
    return sum(items)

print(total(3, 5))
print(total(3, 5, 8))
]]
        ),
        accept = { "*items", "*args" },
        answer = "*items",
        hint = L(
          "A star, then the name the body uses. Inside, it is a tuple.",
          "별표 하나, 그다음 본문이 쓰는 이름. 안에서는 튜플.",
          "一個星號，然後係 body 用嘅個名。裏面係一個 tuple。"
        ),
        ok = L(
          "*items packs extra positional arguments into a tuple. Go's ...int. Calling total(*prices) unpacks a list the other way.",
          "*items는 남는 위치 인자를 튜플로 묶는다. Go의 ...int. total(*prices)는 반대로 리스트를 풀어 넣는다.",
          "*items 將多出嚟嘅位置參數包成 tuple。Go 嘅 ...int。call total(*prices) 就反過來將 list 拆開。"
        ),
      },
      {
        topic = "KWARGS",
        q = L(
          "order('noodles', spicy=True, egg=2): how is the parameter written to collect any keyword options?",
          "order('noodles', spicy=True, egg=2): 어떤 키워드 옵션이든 모으는 매개변수는 어떻게 쓰나?",
          "order('noodles', spicy=True, egg=2)：參數點寫先收齊任何 keyword 選項？"
        ),
        code = L(
          [[
def order(item, ___):
    for k, v in opts.items():
        print(item, k, v)

order("noodles", spicy=True, egg=2)
]],
          [[
def order(item, ___):
    for k, v in opts.items():
        print(item, k, v)

order("noodles", spicy=True, egg=2)
]],
          [[
def order(item, ___):
    for k, v in opts.items():
        print(item, k, v)

order("noodles", spicy=True, egg=2)
]]
        ),
        accept = { "**opts", "**kwargs" },
        answer = "**opts",
        hint = L(
          "Two stars, then the name the body reads .items() from. Inside, it is a dict.",
          "별표 두 개, 그다음 본문이 .items()를 읽는 이름. 안에서는 dict.",
          "兩個星號，然後係 body 讀 .items() 嘅個名。裏面係一個 dict。"
        ),
        ok = L(
          "**opts packs keyword arguments into a dict. The usual names are *args and **kwargs; any name works.",
          "**opts는 키워드 인자를 dict로 묶는다. 흔한 이름은 *args와 **kwargs, 어떤 이름이든 된다.",
          "**opts 將 keyword 參數包成 dict。慣用名係 *args 同 **kwargs；用咩名都得。"
        ),
      },
      {
        topic = "LAMBDA",
        q = L(
          "Sort orders by price with a one-line function. Which keyword makes it?",
          "한 줄 함수로 주문을 가격순 정렬. 어떤 키워드로 만드나?",
          "用一行 function 按價錢排序訂單。邊個 keyword 造出佢？"
        ),
        code = L(
          [[
orders = [("tea", 12), ("noodles", 38), ("egg", 6)]
cheap = sorted(orders, key=___ o: o[1])
print(cheap[0])     # ('egg', 6)
]],
          [[
orders = [("tea", 12), ("noodles", 38), ("egg", 6)]
cheap = sorted(orders, key=___ o: o[1])
print(cheap[0])     # ('egg', 6)
]],
          [[
orders = [("tea", 12), ("noodles", 38), ("egg", 6)]
cheap = sorted(orders, key=___ o: o[1])
print(cheap[0])     # ('egg', 6)
]]
        ),
        accept = { "lambda" },
        answer = "lambda",
        hint = L(
          "A Greek letter. Rust writes |o| o.1 for the same thing.",
          "그리스 문자 이름. Rust는 같은 것을 |o| o.1로 쓴다.",
          "一個希臘字母。Rust 寫 |o| o.1 做同一件事。"
        ),
        ok = L(
          "lambda o: o[1] is an anonymous one-expression function. For anything longer, use def.",
          "lambda o: o[1]은 식 하나짜리 익명 함수. 더 길면 def를 쓴다.",
          "lambda o: o[1] 係一個只有一個 expression 嘅匿名 function。長過呢個就用 def。"
        ),
      },
      {
        topic = "NONE",
        q = L(
          "log() prints but never returns. What does print(log('x')) show on its second line?",
          "log()는 출력만 하고 반환하지 않는다. print(log('x'))의 둘째 줄엔 무엇이 나오나?",
          "log() 只印唔回傳。print(log('x')) 第二行會顯示咩？"
        ),
        code = L(
          [[
def log(msg):
    print("[night]", msg)

print(log("shutter down"))
# [night] shutter down
# ___
]],
          [[
def log(msg):
    print("[night]", msg)

print(log("shutter down"))
# [night] shutter down
# ___
]],
          [[
def log(msg):
    print("[night]", msg)

print(log("shutter down"))
# [night] shutter down
# ___
]]
        ),
        accept = { "None" },
        answer = "None",
        hint = L(
          "The value of nothing, capital letter. Every function without a return statement gives it back.",
          "아무것도 없음의 값, 대문자로 시작. return 문이 없는 모든 함수가 이걸 돌려준다.",
          "「冇」嘅值，大楷開頭。所有冇 return 嘅 function 都會交返佢。"
        ),
        ok = L(
          "A def with no return evaluates to None. Printing that is a classic beginner surprise. The pass window is done.",
          "return 없는 def는 None으로 평가된다. 그걸 출력하는 건 초보의 고전적 놀람. 패스 창 완료.",
          "冇 return 嘅 def 值係 None。印出嚟係初學者經典嘅驚訝。出餐窗口搞掂。"
        ),
      },
    },
  },
  {
    id = "py_lists",
    station = "LISTS",
    name = L("The tray rack", "트레이 선반", "盤架"),
    title = L("Lists and slices", "리스트와 슬라이스", "list 同 slice"),
    lesson = L(
      "A list grows with append and shrinks with pop. len counts. a[1:3] slices, a[-1] is the last item. [f(x) for x in a] builds a new list. sorted returns a new list.",
      "리스트는 append로 늘고 pop으로 준다. len이 센다. a[1:3]은 슬라이스, a[-1]은 마지막. [f(x) for x in a]는 새 리스트. sorted는 새 리스트를 반환.",
      "list 用 append 增長，pop 縮短。len 數數。a[1:3] 係 slice，a[-1] 係最後一個。[f(x) for x in a] 造新 list。sorted 回傳新 list。"
    ),
    bg = "bg_set",
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
          "A Python list is your Go slice, minus the type. It just grows.",
          "Python 리스트는 타입 뺀 Go 슬라이스야. 그냥 자라.",
          "Python list 就係你嘅 Go slice，冇咗 type。佢自己會大。"
        ),
      },
      {
        kind = "cook",
        x = 880,
        facing = -1,
        line = L(
          "The rack script lists trays. It drops the last one every time.",
          "선반 스크립트가 트레이를 나열하는데 매번 마지막 걸 빼먹어.",
          "盤架 script 列出所有盤，每次都漏咗最後一個。"
        ),
      },
    },
    viz = "python",
    chips = {
      { 'trays.append("egg")', "cyan" },
      { "trays[1:3]", "gold" },
      { "trays[-1]", "pink" },
      { "[p * 2 for p in prices]", "green" },
    },
    note = "append  len  [1:3]  [-1]  for  sorted",
    story = L(
      "The tray rack. Bo's rack script keeps trays in a list and reads the last one with index "
        .. "len minus one, off by one, every night. Python has a shorter way to say 'last'.",
      "트레이 선반. 보의 선반 스크립트는 트레이를 리스트에 넣고 마지막 것을 len 빼기 1 인덱스로 읽는다. "
        .. "매일 밤 하나씩 어긋난다. Python엔 '마지막'을 말하는 더 짧은 방법이 있다.",
      "盤架。寶廚嘅盤架 script 將盤放喺 list，用 len 減一嘅 index 讀最後一個，"
        .. "夜夜都差一。Python 有更短嘅講法講「最後」。"
    ),
    stages = {
      {
        topic = "APPEND",
        q = L(
          "Add a tray to the end of the list. Which method?",
          "리스트 끝에 트레이 추가. 어떤 메서드?",
          "喺 list 尾加一個盤。邊個 method？"
        ),
        code = L(
          [[
trays = ["egg", "tea"]
trays.___("toast")
print(trays)     # ['egg', 'tea', 'toast']
]],
          [[
trays = ["egg", "tea"]
trays.___("toast")
print(trays)     # ['egg', 'tea', 'toast']
]],
          [[
trays = ["egg", "tea"]
trays.___("toast")
print(trays)     # ['egg', 'tea', 'toast']
]]
        ),
        accept = { "append" },
        answer = "append",
        hint = L(
          "Same word as Go, but a method that changes the list in place and returns None.",
          "Go와 같은 단어지만 리스트를 제자리에서 바꾸고 None을 반환하는 메서드.",
          "同 Go 同一個字，但係 method，就地改個 list，回傳 None。"
        ),
        ok = L(
          "trays.append(x) is amortized O(1). trays = trays.append(x) is the classic bug: it sets trays to None.",
          "trays.append(x)는 분할 상환 O(1). trays = trays.append(x)는 고전 버그: trays가 None이 된다.",
          "trays.append(x) 係 amortized O(1)。trays = trays.append(x) 係經典 bug：會將 trays 變成 None。"
        ),
      },
      {
        topic = "LEN",
        q = L(
          "How many trays? Which built-in counts a list?",
          "트레이가 몇 개? 리스트를 세는 내장 함수는?",
          "有幾多個盤？邊個內建 function 數 list？"
        ),
        code = L(
          [[
trays = ["egg", "tea", "toast"]
print(___(trays))     # 3
]],
          [[
trays = ["egg", "tea", "toast"]
print(___(trays))     # 3
]],
          [[
trays = ["egg", "tea", "toast"]
print(___(trays))     # 3
]]
        ),
        accept = { "len" },
        answer = "len",
        hint = L(
          "Three letters, the same as Go. Not a method: it is a function that takes the list.",
          "세 글자, Go와 같다. 메서드가 아니라 리스트를 받는 함수.",
          "三個字母，同 Go 一樣。唔係 method：係一個收 list 嘅 function。"
        ),
        ok = L(
          "len works on lists, strings, dicts, sets, anything with __len__. It is O(1): the length is stored.",
          "len은 리스트, 문자열, dict, set, __len__이 있는 무엇에든 된다. O(1): 길이가 저장돼 있다.",
          "len 對 list、string、dict、set，任何有 __len__ 嘅嘢都得。O(1)：長度係存起嘅。"
        ),
      },
      {
        topic = "SLICE",
        q = L(
          "Take the second and third tray, items 1 and 2. What goes in the brackets?",
          "두 번째와 세 번째 트레이, 1번과 2번 항목. 대괄호 안엔 뭐가 들어가나?",
          "攞第二同第三個盤，即 1 號同 2 號。方括號裏面填咩？"
        ),
        code = L(
          [[
trays = ["egg", "tea", "toast", "rice"]
print(trays[___])     # ['tea', 'toast']
]],
          [[
trays = ["egg", "tea", "toast", "rice"]
print(trays[___])     # ['tea', 'toast']
]],
          [[
trays = ["egg", "tea", "toast", "rice"]
print(trays[___])     # ['tea', 'toast']
]]
        ),
        accept = { "1:3" },
        answer = "1:3",
        hint = L(
          "start:stop, the stop is not included. Same rule as Go's a[1:3].",
          "start:stop, stop은 포함되지 않는다. Go의 a[1:3]과 같은 규칙.",
          "start:stop，stop 唔包括在內。同 Go 嘅 a[1:3] 一樣規則。"
        ),
        ok = L(
          "a[1:3] copies items 1 and 2 into a new list. a[:2], a[2:], a[::2] and a[::-1] (reversed) all work.",
          "a[1:3]은 1번과 2번을 새 리스트로 복사. a[:2], a[2:], a[::2], a[::-1](역순) 모두 된다.",
          "a[1:3] 將 1 號同 2 號 copy 入新 list。a[:2]、a[2:]、a[::2] 同 a[::-1]（倒轉）全部得。"
        ),
      },
      {
        topic = "LAST",
        q = L(
          "The last tray, without len. Which index?",
          "len 없이 마지막 트레이. 어떤 인덱스?",
          "唔用 len 攞最後一個盤。邊個 index？"
        ),
        code = L(
          [[
trays = ["egg", "tea", "toast", "rice"]
print(trays[___])     # rice
]],
          [[
trays = ["egg", "tea", "toast", "rice"]
print(trays[___])     # rice
]],
          [[
trays = ["egg", "tea", "toast", "rice"]
print(trays[___])     # rice
]]
        ),
        accept = { "-1" },
        answer = "-1",
        hint = L(
          "Negative indexes count from the end. Go would panic on this.",
          "음수 인덱스는 끝에서부터 센다. Go라면 패닉.",
          "負數 index 由尾數起。Go 會 panic。"
        ),
        ok = L(
          "a[-1] is the last item, a[-2] the one before. Bo's off-by-one is gone.",
          "a[-1]은 마지막, a[-2]는 그 앞. 보의 하나 차이 버그가 사라진다.",
          "a[-1] 係最後一個，a[-2] 係再前一個。寶廚差一嘅 bug 冇咗。"
        ),
      },
      {
        topic = "COMP",
        q = L(
          "Double every price into a new list, in one line. Which keyword sits in the middle of the comprehension?",
          "모든 가격을 두 배로 한 새 리스트를 한 줄로. 컴프리헨션 가운데 오는 키워드는?",
          "一行將每個價錢乘二做新 list。comprehension 中間係邊個 keyword？"
        ),
        code = L(
          [[
prices = [6, 12, 38]
doubled = [p * 2 ___ p in prices]
print(doubled)     # [12, 24, 76]
]],
          [[
prices = [6, 12, 38]
doubled = [p * 2 ___ p in prices]
print(doubled)     # [12, 24, 76]
]],
          [[
prices = [6, 12, 38]
doubled = [p * 2 ___ p in prices]
print(doubled)     # [12, 24, 76]
]]
        ),
        accept = { "for" },
        answer = "for",
        hint = L(
          "The loop keyword, inside the brackets, after the expression.",
          "루프 키워드, 대괄호 안, 식 뒤에.",
          "loop 嘅 keyword，放喺方括號裏面、expression 後面。"
        ),
        ok = L(
          "[expr for x in xs if cond] is a list comprehension. Rust's iter().map().collect(), in one readable line.",
          "[expr for x in xs if cond]는 리스트 컴프리헨션. Rust의 iter().map().collect()를 읽기 좋은 한 줄로.",
          "[expr for x in xs if cond] 係 list comprehension。Rust 嘅 iter().map().collect()，一行讀得明。"
        ),
      },
      {
        topic = "SORTED",
        q = L(
          "A sorted copy of the prices, leaving the original as it is. Which built-in?",
          "원본은 그대로 두고 정렬된 복사본. 어떤 내장 함수?",
          "價錢排好序嘅副本，原本不變。邊個內建 function？"
        ),
        code = L(
          [[
prices = [38, 6, 12]
cheap = ___(prices)
print(cheap, prices)   # [6, 12, 38] [38, 6, 12]
]],
          [[
prices = [38, 6, 12]
cheap = ___(prices)
print(cheap, prices)   # [6, 12, 38] [38, 6, 12]
]],
          [[
prices = [38, 6, 12]
cheap = ___(prices)
print(cheap, prices)   # [6, 12, 38] [38, 6, 12]
]]
        ),
        accept = { "sorted" },
        answer = "sorted",
        hint = L(
          "A function, past tense. The method prices.sort() would change the list in place and return None.",
          "함수, 과거형. 메서드 prices.sort()는 리스트를 제자리에서 바꾸고 None을 반환.",
          "一個 function，過去式。method prices.sort() 會就地改個 list，回傳 None。"
        ),
        ok = L(
          "sorted(xs) returns a new list, xs.sort() sorts in place. Both take key= and reverse=True. The rack is in order.",
          "sorted(xs)는 새 리스트, xs.sort()는 제자리 정렬. 둘 다 key=와 reverse=True를 받는다. 선반이 정리된다.",
          "sorted(xs) 回傳新 list，xs.sort() 就地排序。兩個都收 key= 同 reverse=True。盤架整齊咗。"
        ),
      },
    },
  },
  {
    id = "py_dicts",
    station = "DICTS",
    name = L("The menu board", "메뉴판", "餐牌"),
    title = L("Dicts and sets", "딕셔너리와 집합", "dict 同 set"),
    lesson = L(
      "A dict maps keys to values: {} makes one, d[k] reads, d.get(k, default) reads safely, .items() walks pairs, del removes. set() keeps unique items.",
      "dict는 키를 값에 매핑: {}로 만들고, d[k]로 읽고, d.get(k, default)로 안전하게 읽고, .items()로 쌍을 순회, del로 제거. set()은 고유 항목만 남긴다.",
      "dict 將 key 對應 value：{} 造一個，d[k] 讀，d.get(k, default) 安全地讀，.items() 行每對，del 刪走。set() 只留獨一無二嘅項目。"
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
          "The menu board reads prices from a dict. Ask for a dish we do not have and it crashes.",
          "메뉴판은 dict에서 가격을 읽어요. 없는 요리를 물으면 그냥 죽어요.",
          "餐牌由一個 dict 讀價錢。問一個我哋冇嘅菜就 crash。"
        ),
      },
    },
    viz = "python",
    chips = {
      { 'menu = {"tea": 12}', "cyan" },
      { 'menu.get("x", 0)', "gold" },
      { "for k, v in menu.items()", "pink" },
      { "set(names)", "green" },
    },
    note = "{}  get  items  del  set  keys",
    story = L(
      "The menu board at the shutter. Prices live in a dict, dish to dollars. It is Go's map "
        .. "with braces instead of make, and a KeyError instead of a zero value when the dish is missing.",
      "셔터 옆 메뉴판. 가격은 dict에 있다, 요리에서 달러로. make 대신 중괄호, 요리가 없을 땐 제로 값 대신 KeyError인 Go의 map이다.",
      "閘門旁邊嘅餐牌。價錢住喺一個 dict，菜對應銀碼。佢係 Go 嘅 map，"
        .. "用大括號代替 make，冇嗰道菜嗰陣拋 KeyError 而唔係零值。"
    ),
    stages = {
      {
        topic = "DICT",
        q = L(
          "Start with an empty dict. What literal is it?",
          "빈 dict로 시작. 리터럴은?",
          "由一個空 dict 開始。literal 係咩？"
        ),
        code = L(
          [[
menu = ___
menu["tea"] = 12
menu["noodles"] = 38
print(menu["tea"])     # 12
]],
          [[
menu = ___
menu["tea"] = 12
menu["noodles"] = 38
print(menu["tea"])     # 12
]],
          [[
menu = ___
menu["tea"] = 12
menu["noodles"] = 38
print(menu["tea"])     # 12
]]
        ),
        accept = { "{}", "dict()" },
        answer = "{}",
        hint = L(
          "Two braces with nothing between. Note: this makes a dict, not a set; set() is spelled out.",
          "사이에 아무것도 없는 중괄호 둘. 주의: set이 아니라 dict를 만든다. set은 set()으로 쓴다.",
          "兩個大括號，中間冇嘢。注意：呢個造 dict，唔係 set；set 要寫 set()。"
        ),
        ok = L(
          '{} or dict(). {"tea": 12} with items. Keys must be hashable: strings, numbers, tuples, not lists.',
          '{} 또는 dict(). 항목이 있으면 {"tea": 12}. 키는 해시 가능해야 한다: 문자열, 숫자, 튜플. 리스트는 안 됨.',
          '{} 或 dict()。有項目就 {"tea": 12}。key 必須 hashable：string、數字、tuple，list 唔得。'
        ),
      },
      {
        topic = "GET",
        q = L(
          "Read a price that may not exist, with 0 as the fallback, without a crash. Which method?",
          "없을 수도 있는 가격을 0을 기본값으로, 충돌 없이 읽기. 어떤 메서드?",
          "讀一個可能唔存在嘅價錢，以 0 做後備，唔 crash。邊個 method？"
        ),
        code = L(
          [[
menu = {"tea": 12, "noodles": 38}
print(menu.___("congee", 0))   # 0, no KeyError
]],
          [[
menu = {"tea": 12, "noodles": 38}
print(menu.___("congee", 0))   # 0, KeyError 없음
]],
          [[
menu = {"tea": 12, "noodles": 38}
print(menu.___("congee", 0))   # 0，冇 KeyError
]]
        ),
        accept = { "get" },
        answer = "get",
        hint = L(
          "Three letters. menu[k] raises when k is missing; this one returns the default instead.",
          "세 글자. menu[k]는 k가 없으면 예외, 이건 대신 기본값을 반환.",
          "三個字母。menu[k] 冇 k 嗰陣會拋錯；呢個改為回傳預設值。"
        ),
        ok = L(
          "d.get(k, default) never raises. Go's comma-ok, in one call. The board shows 0 instead of dying.",
          "d.get(k, default)는 절대 예외를 내지 않는다. Go의 comma-ok를 한 호출로. 메뉴판이 죽는 대신 0을 보인다.",
          "d.get(k, default) 永遠唔會拋錯。Go 嘅 comma-ok，一個 call 搞掂。餐牌顯示 0 而唔係死機。"
        ),
      },
      {
        topic = "ITEMS",
        q = L(
          "Print every dish with its price. Which method walks the key-value pairs?",
          "모든 요리를 가격과 함께 출력. 키-값 쌍을 순회하는 메서드는?",
          "印出每道菜同佢嘅價錢。邊個 method 行 key-value 對？"
        ),
        code = L(
          [[
for dish, price in menu.___():
    print(dish, price)
]],
          [[
for dish, price in menu.___():
    print(dish, price)
]],
          [[
for dish, price in menu.___():
    print(dish, price)
]]
        ),
        accept = { "items" },
        answer = "items",
        hint = L(
          "Five letters, plural. for k in menu alone gives only the keys.",
          "다섯 글자, 복수형. for k in menu만 쓰면 키만 나온다.",
          "五個字母，眾數。單單 for k in menu 只會畀 key。"
        ),
        ok = L(
          "d.items() yields (key, value) tuples; d.keys() and d.values() the halves. Since 3.7 the order is insertion order.",
          "d.items()는 (key, value) 튜플을 낸다. d.keys()와 d.values()는 각 절반. 3.7부터 순서는 삽입 순서.",
          "d.items() 畀 (key, value) tuple；d.keys() 同 d.values() 係兩半。3.7 起次序係插入次序。"
        ),
      },
      {
        topic = "DEL",
        q = L(
          "Toast is off the menu tonight. Which statement removes the key?",
          "오늘 밤 토스트는 메뉴에서 빠진다. 키를 제거하는 문장은?",
          "今晚多士唔賣。邊個 statement 刪走個 key？"
        ),
        code = L(
          [[
menu = {"tea": 12, "toast": 18}
___ menu["toast"]
print(menu)     # {'tea': 12}
]],
          [[
menu = {"tea": 12, "toast": 18}
___ menu["toast"]
print(menu)     # {'tea': 12}
]],
          [[
menu = {"tea": 12, "toast": 18}
___ menu["toast"]
print(menu)     # {'tea': 12}
]]
        ),
        accept = { "del" },
        answer = "del",
        hint = L(
          "Three letters, a statement not a method. Go's delete(m, k), shortened.",
          "세 글자, 메서드가 아닌 문장. Go의 delete(m, k)를 줄인 것.",
          "三個字母，係 statement 唔係 method。Go 嘅 delete(m, k) 縮短版。"
        ),
        ok = L(
          "del menu[k] raises if k is missing; menu.pop(k, None) removes quietly and returns the value.",
          "del menu[k]는 k가 없으면 예외. menu.pop(k, None)은 조용히 제거하고 값을 반환.",
          "del menu[k] 冇 k 嗰陣會拋錯；menu.pop(k, None) 靜靜地刪走並回傳個值。"
        ),
      },
      {
        topic = "SET",
        q = L(
          "The same customer is in the queue list twice. Which built-in keeps each name once?",
          "같은 손님이 줄 리스트에 두 번 있다. 이름을 한 번씩만 남기는 내장 함수는?",
          "同一個客喺排隊 list 出現兩次。邊個內建 function 每個名只留一次？"
        ),
        code = L(
          [[
names = ["Mei", "Alex", "Mei", "Ken"]
unique = ___(names)
print(len(unique))     # 3
]],
          [[
names = ["Mei", "Alex", "Mei", "Ken"]
unique = ___(names)
print(len(unique))     # 3
]],
          [[
names = ["Mei", "Alex", "Mei", "Ken"]
unique = ___(names)
print(len(unique))     # 3
]]
        ),
        accept = { "set" },
        answer = "set",
        hint = L(
          "Three letters, the math word for a collection with no duplicates. Go has no built-in one; map[T]bool stands in.",
          "세 글자, 중복 없는 모음을 뜻하는 수학 용어. Go엔 내장이 없어 map[T]bool로 대신한다.",
          "三個字母，數學上冇重複嘅集合。Go 冇內建，用 map[T]bool 頂住。"
        ),
        ok = L(
          "set(names) drops duplicates; x in s is O(1). {1, 2} is a set literal, but {} is a dict. Sets have no order.",
          "set(names)는 중복 제거. x in s는 O(1). {1, 2}는 set 리터럴이지만 {}는 dict. set엔 순서가 없다.",
          "set(names) 去重；x in s 係 O(1)。{1, 2} 係 set literal，但 {} 係 dict。set 冇次序。"
        ),
      },
      {
        topic = "KEYS",
        q = L(
          "A list of the dishes on the board, just the names. Which method?",
          "메뉴판의 요리 목록, 이름만. 어떤 메서드?",
          "餐牌上嘅菜名 list，只要名。邊個 method？"
        ),
        code = L(
          [[
menu = {"tea": 12, "noodles": 38}
dishes = list(menu.___())
print(dishes)     # ['tea', 'noodles']
]],
          [[
menu = {"tea": 12, "noodles": 38}
dishes = list(menu.___())
print(dishes)     # ['tea', 'noodles']
]],
          [[
menu = {"tea": 12, "noodles": 38}
dishes = list(menu.___())
print(dishes)     # ['tea', 'noodles']
]]
        ),
        accept = { "keys" },
        answer = "keys",
        hint = L(
          "Four letters, plural of what you look a value up by.",
          "네 글자, 값을 찾을 때 쓰는 것의 복수형.",
          "四個字母，你用嚟查值嘅嘢，眾數。"
        ),
        ok = L(
          "d.keys() is a live view; wrap it in list() for a copy. Go 1.21 gives you the same with maps.Keys. The board is fixed.",
          "d.keys()는 라이브 뷰. 복사본이 필요하면 list()로 감싼다. Go 1.21의 maps.Keys와 같다. 메뉴판 수리 완료.",
          "d.keys() 係即時 view；要副本就用 list() 包住。Go 1.21 嘅 maps.Keys 係同一樣嘢。餐牌修好。"
        ),
      },
    },
  },
  {
    id = "py_class",
    station = "CLASSES",
    name = L("The order robot", "주문 로봇", "落單機械人"),
    title = L("class, __init__, self", "class와 __init__, self", "class、__init__、self"),
    lesson = L(
      "class defines a type. __init__ runs on creation; self is the object, written explicitly. __str__ is the print form. super() reaches the parent. @dataclass writes the boilerplate.",
      "class가 타입을 정의. __init__은 생성 시 실행, self는 객체이며 명시적으로 쓴다. __str__은 출력 형태. super()는 부모에 닿는다. @dataclass가 상용구를 대신 쓴다.",
      "class 定義一個 type。__init__ 建立嗰陣執行；self 係個 object，要明寫。__str__ 係 print 出嚟嘅樣。super() 掂到 parent。@dataclass 幫你寫晒 boilerplate。"
    ),
    bg = "bg_market",
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
          "The robot is a class. One Order per bowl. It forgot how to make itself.",
          "로봇은 클래스야. 그릇 하나에 Order 하나. 자기를 만드는 법을 잊어버렸어.",
          "機械人係一個 class。一碗一個 Order。佢唔記得點樣造自己。"
        ),
      },
      {
        kind = "hero",
        x = 900,
        facing = -1,
        line = L(
          "Go has structs and methods. Here the method gets self by hand?",
          "Go엔 구조체와 메서드가 있어. 여기선 메서드가 self를 직접 받아?",
          "Go 有 struct 同 method。呢度 method 要自己攞 self？"
        ),
      },
    },
    viz = "python",
    chips = {
      { "class Order:", "cyan" },
      { "def __init__(self):", "gold" },
      { "super().__init__(item)", "pink" },
      { "@dataclass", "green" },
    },
    note = "class  __init__  self  __str__  super  dataclass",
    story = L(
      "23:00. The last order robot at the market stall runs on a class called Order. "
        .. "Its constructor is gone, its methods lost their first parameter, and the receipt prints "
        .. "<__main__.Order object at 0x7f...>. Bo fixes it with Alex; Monty the sticker watches from the lid.",
      "23:00. 노점의 마지막 주문 로봇은 Order라는 클래스로 돌아간다. 생성자는 사라졌고, 메서드는 첫 매개변수를 잃었고, "
        .. "영수증엔 <__main__.Order object at 0x7f...>가 찍힌다. 보가 알렉스와 고친다. 뚜껑의 스티커 몬티가 지켜본다.",
      "晚上十一點。夜市檔口最後一部落單機械人靠一個叫 Order 嘅 class 運作。"
        .. "constructor 冇咗，method 冇咗第一個參數，收據印出 <__main__.Order object at 0x7f...>。"
        .. "寶廚同阿力一齊修；蓋上面嘅貼紙 Monty 望住。"
    ),
    stages = {
      {
        topic = "CLASS",
        q = L(
          "Which keyword defines a new type?",
          "새 타입을 정의하는 키워드는?",
          "邊個 keyword 定義一個新 type？"
        ),
        code = L(
          [[
___ Order:
    pass

o = Order()
]],
          [[
___ Order:
    pass

o = Order()
]],
          [[
___ Order:
    pass

o = Order()
]]
        ),
        accept = { "class" },
        answer = "class",
        hint = L(
          "Five letters. Go has struct plus methods; Python puts both under one word. Names are CapWords.",
          "다섯 글자. Go는 struct와 메서드, Python은 둘을 한 단어 아래에 둔다. 이름은 CapWords.",
          "五個字母。Go 係 struct 加 method；Python 兩樣放埋一個字下面。命名用 CapWords。"
        ),
        ok = L(
          "class Order: then the body. Order() calls it to make an instance. pass is the empty statement.",
          "class Order: 다음 본문. Order()를 호출하면 인스턴스가 생긴다. pass는 빈 문장.",
          "class Order: 然後 body。Order() call 佢造一個 instance。pass 係空 statement。"
        ),
      },
      {
        topic = "INIT",
        q = L(
          "Which special method runs when Order('noodles') is created?",
          "Order('noodles')가 만들어질 때 실행되는 특수 메서드는?",
          "Order('noodles') 建立嗰陣執行邊個特殊 method？"
        ),
        code = L(
          [[
class Order:
    def ___(self, item):
        self.item = item

o = Order("noodles")
print(o.item)
]],
          [[
class Order:
    def ___(self, item):
        self.item = item

o = Order("noodles")
print(o.item)
]],
          [[
class Order:
    def ___(self, item):
        self.item = item

o = Order("noodles")
print(o.item)
]]
        ),
        accept = { "__init__", "init" },
        answer = "__init__",
        hint = L(
          "Two underscores, the start of initialize, two underscores. Dunder methods all look like this.",
          "밑줄 둘, initialize의 앞부분, 밑줄 둘. 던더 메서드는 모두 이렇게 생겼다.",
          "兩條底線、initialize 嘅開頭、兩條底線。dunder method 全部都係咁樣。"
        ),
        ok = L(
          "__init__ is the constructor body; self.item = item makes an attribute. __new__ exists too, rarely needed.",
          "__init__은 생성자 본문. self.item = item이 속성을 만든다. __new__도 있지만 거의 필요 없다.",
          "__init__ 係 constructor 嘅 body；self.item = item 造一個 attribute。__new__ 都有，但好少用。"
        ),
      },
      {
        topic = "SELF",
        q = L(
          "The method reads its own item. What is the first parameter of every method?",
          "메서드가 자기 item을 읽는다. 모든 메서드의 첫 매개변수는?",
          "method 讀自己嘅 item。每個 method 嘅第一個參數係咩？"
        ),
        code = L(
          [[
class Order:
    def __init__(self, item):
        self.item = item

    def label(___):
        return f"1 x {___.item}"
]],
          [[
class Order:
    def __init__(self, item):
        self.item = item

    def label(___):
        return f"1 x {___.item}"
]],
          [[
class Order:
    def __init__(self, item):
        self.item = item

    def label(___):
        return f"1 x {___.item}"
]]
        ),
        accept = { "self" },
        answer = "self",
        hint = L(
          "Four letters. Go's receiver (o *Order), Rust's &self, but here it is an ordinary parameter by convention.",
          "네 글자. Go의 리시버 (o *Order), Rust의 &self. 여기선 관례상 그냥 첫 매개변수.",
          "四個字母。Go 嘅 receiver (o *Order)，Rust 嘅 &self，但呢度係一個普通參數，靠慣例。"
        ),
        ok = L(
          "o.label() passes o as self automatically. Forgetting self is the most common TypeError in a beginner's class.",
          "o.label()은 o를 self로 자동 전달. self를 빼먹는 건 초보 클래스에서 가장 흔한 TypeError.",
          "o.label() 自動將 o 傳做 self。漏寫 self 係初學者 class 最常見嘅 TypeError。"
        ),
      },
      {
        topic = "STR",
        q = L(
          "print(o) shows <Order object at 0x...>. Which special method gives it a readable form?",
          "print(o)가 <Order object at 0x...>를 보인다. 읽기 좋은 형태를 주는 특수 메서드는?",
          "print(o) 顯示 <Order object at 0x...>。邊個特殊 method 畀佢一個讀得明嘅樣？"
        ),
        code = L(
          [[
class Order:
    def __init__(self, item):
        self.item = item

    def ___(self):
        return f"Order({self.item})"
]],
          [[
class Order:
    def __init__(self, item):
        self.item = item

    def ___(self):
        return f"Order({self.item})"
]],
          [[
class Order:
    def __init__(self, item):
        self.item = item

    def ___(self):
        return f"Order({self.item})"
]]
        ),
        accept = { "__str__", "str", "__repr__", "repr" },
        answer = "__str__",
        hint = L(
          "Dunder around the text type's name. Its sibling __repr__ is for the debugger.",
          "텍스트 타입 이름을 던더로 감싼 것. 형제 __repr__은 디버거용.",
          "文字 type 個名，前後加 dunder。佢兄弟 __repr__ 係畀 debugger 用。"
        ),
        ok = L(
          "__str__ is what print and str() use; __repr__ is the unambiguous form, used when __str__ is missing. Go's String().",
          "__str__은 print와 str()이 쓴다. __repr__은 명확한 형태, __str__이 없을 때 쓰인다. Go의 String().",
          "__str__ 係 print 同 str() 用嘅；__repr__ 係無歧義嘅形式，冇 __str__ 嗰陣用。Go 嘅 String()。"
        ),
      },
      {
        topic = "SUPER",
        q = L(
          "SetMeal extends Order and must run Order's __init__ first. Which built-in reaches the parent?",
          "SetMeal은 Order를 확장하고 Order의 __init__을 먼저 실행해야 한다. 부모에 닿는 내장 함수는?",
          "SetMeal 繼承 Order，要先執行 Order 嘅 __init__。邊個內建 function 掂到 parent？"
        ),
        code = L(
          [[
class SetMeal(Order):
    def __init__(self, item, drink):
        ___().__init__(item)
        self.drink = drink
]],
          [[
class SetMeal(Order):
    def __init__(self, item, drink):
        ___().__init__(item)
        self.drink = drink
]],
          [[
class SetMeal(Order):
    def __init__(self, item, drink):
        ___().__init__(item)
        self.drink = drink
]]
        ),
        accept = { "super" },
        answer = "super",
        hint = L(
          "Five letters, the word for 'above'. It returns a proxy to the parent class.",
          "다섯 글자, '위'를 뜻하는 단어. 부모 클래스로의 프록시를 반환.",
          "五個字母，意思係「上面」。回傳一個去 parent class 嘅 proxy。"
        ),
        ok = L(
          "super().__init__(item) runs the parent constructor. class SetMeal(Order) is inheritance; Go embeds instead.",
          "super().__init__(item)이 부모 생성자를 실행. class SetMeal(Order)는 상속. Go는 대신 임베딩.",
          "super().__init__(item) 執行 parent 嘅 constructor。class SetMeal(Order) 係繼承；Go 用 embedding 代替。"
        ),
      },
      {
        topic = "DATACLASS",
        q = L(
          "Skip writing __init__, __repr__ and __eq__ by hand. Which decorator generates them from the fields?",
          "__init__, __repr__, __eq__를 손으로 쓰지 않기. 필드에서 생성해주는 데코레이터는?",
          "唔想手寫 __init__、__repr__ 同 __eq__。邊個 decorator 由 field 生成佢們？"
        ),
        code = L(
          [[
import dataclasses

@dataclasses.___
class Order:
    item: str
    qty: int = 1
]],
          [[
import dataclasses

@dataclasses.___
class Order:
    item: str
    qty: int = 1
]],
          [[
import dataclasses

@dataclasses.___
class Order:
    item: str
    qty: int = 1
]]
        ),
        accept = { "dataclass" },
        answer = "dataclass",
        hint = L(
          "The module's name, singular, after the dot. It is a decorator, so it sits on the line above the class.",
          "모듈 이름의 단수형, 점 뒤에. 데코레이터라서 class 바로 윗줄에 앉는다.",
          "個 module 嘅名，單數，放喺點後面。佢係 decorator，所以坐喺 class 上面一行。"
        ),
        ok = L(
          "@dataclass reads the annotated fields and writes the boilerplate. Order('tea', 2) just works. The shutter comes down; the night shift is closed.",
          "@dataclass는 주석 달린 필드를 읽고 상용구를 써준다. Order('tea', 2)가 그냥 된다. 셔터가 내려오고 야간 근무가 마감된다.",
          "@dataclass 讀有 annotation 嘅 field，幫你寫晒 boilerplate。Order('tea', 2) 直接得。閘門落下；夜班收工。"
        ),
      },
    },
  },
}

return maps
