-- Quest 1 BASIC: the walk from the flat to Lucky Mac.
-- Alex is a Go coder in Causeway Bay. Mei wants the morning set.
-- Each stage is a real quiz: the blank ___ is NOT written in the code.
-- HINT gives a nudge, a second HINT the answer.
--
-- Text fields are L(en, ko, yue) tables. Code is the same Go in every
-- language; only comments are translated. Max 7 lines per code block.

local function L(en, ko, yue)
  return { en = en, ko = ko, yue = yue }
end

local maps = {
  {
    id = "flat",
    station = "PACKAGE",
    name = L("The flat", "아파트", "屋企"),
    title = L("Packages and imports", "패키지와 import", "package 同 import"),
    lesson = L(
      "Every Go file starts with package. import brings other packages in.",
      "모든 Go 파일은 package로 시작한다. import로 다른 패키지를 가져온다.",
      "每個 Go 檔都由 package 開始。import 帶入其他 package。"
    ),
    bg = "bg_flat",
    portrait = "portrait_hero",
    speaker = L("Alex", "알렉스", "阿力"),
    ground = 348,
    spawn = 160,
    width = 1600,
    npcs = {
      {
        kind = "mei",
        x = 520,
        facing = -1,
        line = L(
          "Morning set. Lucky Mac. The kiosk on the door is stuck on a Go bug.",
          "모닝세트. 럭키 맥. 문 키오스크가 Go 버그에 걸렸어.",
          "早餐套餐。幸運麥。門口部機卡咗個 Go bug。"
        ),
      },
    },
    viz = "flat",
    story = L(
      "06:40. Causeway Bay. Alex wants a muffin, a hash brown and coffee. "
        .. "The flat's door kiosk will not unlock until the Go file compiles.",
      "06:40. 코즈웨이베이. 알렉스는 머핀, 해시브라운, 커피가 필요하다. "
        .. "집 문 키오스크는 Go 파일이 컴파일돼야 열린다.",
      "朝早六點四十。銅鑼灣。阿力想要鬆餅、薯餅同咖啡。"
        .. "屋企門口部機要 Go 檔 compile 到先開得。"
    ),
    stages = {
      {
        topic = "PACKAGE",
        q = L(
          "Every runnable Go program lives in which package?",
          "실행 가능한 Go 프로그램은 어떤 패키지에 속하나요?",
          "可以執行嘅 Go 程式屬於邊個 package？"
        ),
        code = L(
          [[
// The first line of a Go file.
package ___
func hello() {}
]],
          [[
// Go 파일의 첫 줄.
package ___
func hello() {}
]],
          [[
// Go 檔第一行。
package ___
func hello() {}
]]
        ),
        accept = { "main" },
        answer = "main",
        hint = L(
          "The package the Go tool looks for when you type go run.",
          "go run을 칠 때 Go 도구가 찾는 패키지입니다.",
          "你打 go run 嗰陣，Go 工具搵嘅 package。"
        ),
        ok = L(
          "package main is the entry. Other folders are libraries.",
          "package main이 진입점. 다른 폴더는 라이브러리.",
          "package main 係入口。其他資料夾係 library。"
        ),
      },
      {
        topic = "IMPORT",
        q = L(
          "Which standard package prints to the terminal?",
          "터미널에 출력하는 표준 패키지는?",
          "邊個標準 library 負責印去終端機？"
        ),
        code = L(
          [[
package main
import "___"
func main() {
    Println("hash brown")
}
]],
          [[
package main
import "___"
func main() {
    Println("hash brown")
}
]],
          [[
package main
import "___"
func main() {
    Println("hash brown")
}
]]
        ),
        accept = { "fmt" },
        answer = "fmt",
        hint = L(
          "Short for format. Println lives there.",
          "format의 줄임말. Println이 거기 있습니다.",
          "format 嘅縮寫。Println 喺嗰度。"
        ),
        ok = L(
          'import "fmt" then fmt.Println. The kiosk beeps.',
          'import "fmt" 다음에 fmt.Println. 키오스크가 삐 한다.',
          'import "fmt" 然後 fmt.Println。部機嗶一聲。'
        ),
      },
      {
        topic = "IMPORT",
        q = L(
          "Two packages in one file. What keyword opens the grouped list?",
          "한 파일에 패키지 둘. 묶음 목록을 여는 키워드는?",
          "一個檔兩個 package。邊個 keyword 打開括號列表？"
        ),
        code = L(
          [[
package main
___ (
    "fmt"
    "os"
)
]],
          [[
package main
___ (
    "fmt"
    "os"
)
]],
          [[
package main
___ (
    "fmt"
    "os"
)
]]
        ),
        accept = { "import" },
        answer = "import",
        hint = L(
          "Same word as a single import, then parentheses.",
          "한 줄 import와 같은 단어, 그다음 괄호.",
          "同單行 import 同一個字，然後括號。"
        ),
        ok = L(
          "import ( ... ) groups them. The door unlocks.",
          "import ( ... )로 묶는다. 문이 열린다.",
          "import ( ... ) 一齊寫。門開咗。"
        ),
      },
      {
        topic = "EXPORT",
        q = L(
          "Only names that start with a capital letter leave their package. Which fmt function prints a line?",
          "대문자로 시작하는 이름만 패키지 밖으로 나간다. 한 줄을 출력하는 fmt 함수는?",
          "只有大寫開頭嘅名先出得到 package 外面。印一行嘅 fmt function 係邊個？"
        ),
        code = L(
          [[
package main
import "fmt"
func main() {
    fmt.___("morning set")   // capital P: exported
}
]],
          [[
package main
import "fmt"
func main() {
    fmt.___("morning set")   // 대문자 P: 공개됨
}
]],
          [[
package main
import "fmt"
func main() {
    fmt.___("morning set")   // 大寫 P：export 咗
}
]]
        ),
        answer = "Println",
        accept = { "Println" },
        hint = L(
          "Print then ln. fmt.println with a small p does not exist outside fmt.",
          "Print 다음 ln. 소문자 p의 fmt.println은 fmt 밖에 없다.",
          "Print 然後 ln。細楷 p 嘅 fmt.println 喺 fmt 外面唔存在。"
        ),
        ok = L(
          "Capital = exported. Small = private to the package. Same rule for types and fields.",
          "대문자 = 공개. 소문자 = 패키지 내부. 타입과 필드도 같은 규칙.",
          "大寫 = export。細楷 = package 內部。type 同 field 都係咁。"
        ),
      },
      {
        topic = "INIT",
        q = L(
          "A function that runs once before main, and nobody calls it. Its name?",
          "main보다 먼저 한 번 실행되고 아무도 호출하지 않는 함수. 이름은?",
          "main 之前行一次，冇人 call 佢嘅 function。叫咩名？"
        ),
        code = L(
          [[
package main
var menu map[string]int
func ___() {                // before main
    menu = map[string]int{"muffin": 18}
}
func main() {}
]],
          [[
package main
var menu map[string]int
func ___() {                // main보다 먼저
    menu = map[string]int{"muffin": 18}
}
func main() {}
]],
          [[
package main
var menu map[string]int
func ___() {                // main 之前
    menu = map[string]int{"muffin": 18}
}
func main() {}
]]
        ),
        answer = "init",
        accept = { "init" },
        hint = L(
          "Four letters. Every file may have one; the runtime calls it for you.",
          "네 글자. 파일마다 하나 둘 수 있고 런타임이 대신 호출한다.",
          "四個字母。每個檔案可以有一個；runtime 幫你 call。"
        ),
        ok = L(
          "init runs after package variables are set and before main. Keep it small.",
          "init은 패키지 변수 초기화 후, main 전에 실행. 작게 유지할 것.",
          "init 喺 package 變數設定之後、main 之前行。要保持細。"
        ),
      },
    },
  },

  {
    id = "lift",
    station = "VARS",
    name = L("The lift", "엘리베이터", "升降機"),
    title = L("Variables, types, const", "변수, 타입, const", "變數、類型、const"),
    lesson = L(
      ":= infers the type. var names it. const never changes. int starts at 0.",
      ":=는 타입을 추론한다. var는 이름을 붙인다. const는 안 바뀐다. int는 0에서 시작.",
      ":= 會推類型。var 改名。const 永遠唔變。int 由 0 開始。"
    ),
    bg = "bg_flat",
    portrait = "portrait_hero",
    speaker = L("Alex", "알렉스", "阿力"),
    ground = 348,
    spawn = 180,
    width = 1600,
    npcs = {
      {
        kind = "mei",
        x = 480,
        facing = -1,
        line = L(
          "Floor 8. Type the floor. Don't hard-code magic.",
          "8층. 층을 변수로. 매직 넘버 넣지 마.",
          "8樓。用變數。唔好寫死數字。"
        ),
      },
    },
    viz = "lift",
    story = L(
      "The lift panel is a tiny Go program. Floor, name, and a constant for "
        .. "Lucky Mac's opening hour. Zero values matter: an unset int is not blank.",
      "엘리베이터 패널은 작은 Go 프로그램. 층, 이름, 럭키 맥 오픈 시각 상수. "
        .. "제로 값이 중요하다: 설정 안 한 int는 빈칸이 아니다.",
      "升降機面板係細細嘅 Go 程式。樓層、名、幸運麥開門時間常數。"
        .. "零值好緊要：未設定嘅 int 唔係空白。"
    ),
    stages = {
      {
        topic = "SHORT",
        q = L(
          "Short declaration. Fill the operator: floor ___ 8",
          "짧은 선언. 연산자를 채우세요: floor ___ 8",
          "短宣告。填運算符：floor ___ 8"
        ),
        code = L(
          [[
package main
func main() {
    floor ___ 8      // type inferred as int
}
]],
          [[
package main
func main() {
    floor ___ 8      // int로 추론
}
]],
          [[
package main
func main() {
    floor ___ 8      // 推成 int
}
]]
        ),
        accept = { ":=", ":=" },
        answer = ":=",
        hint = L(
          "Colon then equals. Only inside a function.",
          "콜론 다음에 등호. 함수 안에서만.",
          "冒號然後等號。只可以喺 function 入面。"
        ),
        ok = L(
          ":= declares and assigns. Type comes from the right-hand side.",
          ":=는 선언과 대입. 타입은 오른쪽에서 온다.",
          ":= 宣告兼賦值。類型由右邊嚟。"
        ),
      },
      {
        topic = "CONST",
        q = L(
          "A name that cannot be assigned later. Which keyword?",
          "나중에 대입할 수 없는 이름. 키워드는?",
          "之後唔可以再賦值嘅名。邊個 keyword？"
        ),
        code = L(
          [[
package main
___ opens = 6          // Lucky Mac hour, never changes
]],
          [[
package main
___ opens = 6          // 럭키 맥 시각, 안 바뀜
]],
          [[
package main
___ opens = 6          // 幸運麥時間，永遠唔變
]]
        ),
        accept = { "const" },
        answer = "const",
        hint = L(
          "Opposite of var. Compile error if you try to change it.",
          "var의 반대. 바꾸려 하면 컴파일 에러.",
          "var 嘅相反。改就 compile error。"
        ),
        ok = L(
          "const opens = 6. The lift knows when breakfast starts.",
          "const opens = 6. 엘리베이터가 아침 시작을 안다.",
          "const opens = 6。升降機知早餐幾時開始。"
        ),
      },
      {
        topic = "ZERO",
        q = L(
          "var n int with no assignment. What is n?",
          "대입 없는 var n int. n의 값은?",
          "冇賦值嘅 var n int。n 係幾多？"
        ),
        code = L(
          [[
var n int              // zero value
fmt.Println(n)         // prints ___
]],
          [[
var n int              // 제로 값
fmt.Println(n)         // ___ 출력
]],
          [[
var n int              // 零值
fmt.Println(n)         // 印 ___
]]
        ),
        accept = { "0" },
        answer = "0",
        hint = L(
          "Go never leaves a variable uninitialized. Numbers start here.",
          "Go는 변수를 초기화 없이 두지 않습니다. 숫자는 여기서 시작.",
          "Go 唔會留未初始化嘅變數。數字由呢度開始。"
        ),
        ok = L(
          'int is 0, string is "", bool is false, pointer is nil.',
          'int는 0, string은 "", bool은 false, pointer는 nil.',
          'int 係 0，string 係 ""，bool 係 false，pointer 係 nil。'
        ),
      },
      {
        topic = "VAR",
        q = L(
          "Declare with an explicit type, outside any function. Which keyword?",
          "함수 밖에서 타입을 명시해 선언한다. 어떤 키워드?",
          "喺 function 外面，寫明 type 去宣告。咩關鍵字？"
        ),
        code = L(
          [[
package main
___ shop string = "Lucky Mac"   // package level: no :=
func main() {
    fmt.Println(shop)
}
]],
          [[
package main
___ shop string = "Lucky Mac"   // 패키지 레벨: := 불가
func main() {
    fmt.Println(shop)
}
]],
          [[
package main
___ shop string = "Lucky Mac"   // package level：唔可以用 :=
func main() {
    fmt.Println(shop)
}
]]
        ),
        answer = "var",
        accept = { "var" },
        hint = L(
          "Three letters. Works anywhere; := only works inside a function.",
          "세 글자. 어디서나 되지만 :=는 함수 안에서만.",
          "三個字母。邊度都用得；:= 淨係 function 入面得。"
        ),
        ok = L(
          "var name type = value. Outside a function := is a compile error.",
          "var 이름 타입 = 값. 함수 밖의 :=는 컴파일 에러.",
          "var 名 type = 值。喺 function 外面用 := 會 compile error。"
        ),
      },
      {
        topic = "IOTA",
        q = L(
          "Number the constants 0, 1, 2 automatically. Which identifier?",
          "상수에 0, 1, 2를 자동으로 매긴다. 어떤 식별자?",
          "自動將 constant 編做 0、1、2。咩 identifier？"
        ),
        code = L(
          [[
const (
    Muffin = ___       // 0
    Hash               // 1
    Coffee             // 2
)
]],
          [[
const (
    Muffin = ___       // 0
    Hash               // 1
    Coffee             // 2
)
]],
          [[
const (
    Muffin = ___       // 0
    Hash               // 1
    Coffee             // 2
)
]]
        ),
        answer = "iota",
        accept = { "iota" },
        hint = L(
          "Four letters, a Greek one. Resets to 0 in every const block, +1 per line.",
          "네 글자, 그리스 문자. const 블록마다 0에서 시작, 줄마다 +1.",
          "四個字母，希臘字。每個 const block 由 0 開始，每行 +1。"
        ),
        ok = L(
          "iota is Go's enum counter. Lines without a value repeat the one above.",
          "iota는 Go의 enum 카운터. 값 없는 줄은 윗줄을 반복한다.",
          "iota 係 Go 嘅 enum counter。冇寫值嘅行會重複上面嗰行。"
        ),
      },
      {
        topic = "CONVERT",
        q = L(
          "n is an int. Divide it as a floating point number. Fill: half := ___(n) / 2",
          "n은 int. 부동소수점으로 나눈다: half := ___(n) / 2",
          "n 係 int。用浮點數去除：half := ___(n) / 2"
        ),
        code = L(
          [[
n := 7
half := ___(n) / 2      // 3.5, not 3
]],
          [[
n := 7
half := ___(n) / 2      // 3이 아니라 3.5
]],
          [[
n := 7
half := ___(n) / 2      // 3.5，唔係 3
]]
        ),
        answer = "float64",
        accept = { "float64" },
        hint = L(
          "Go never converts numbers silently. Type name, then parentheses. 64-bit float.",
          "Go는 숫자를 조용히 변환하지 않는다. 타입 이름 다음 괄호. 64비트 float.",
          "Go 唔會靜靜雞轉數字。type 名，然後括號。64-bit float。"
        ),
        ok = L(
          "Conversion is T(x). int and float64 never mix without it.",
          "변환은 T(x). int와 float64는 변환 없이 섞이지 않는다.",
          "轉換係 T(x)。int 同 float64 冇佢就唔可以溝。"
        ),
      },
    },
  },

  {
    id = "street",
    station = "LOOPS",
    name = L("Percival Street", "퍼시벌 스트리트", "波斯富街"),
    title = L("if, for, switch, range", "if, for, switch, range", "if、for、switch、range"),
    lesson = L(
      "Go has one loop: for. if needs no parentheses. range walks a slice.",
      "Go의 루프는 for 하나. if에 괄호는 없다. range는 슬라이스를 걷는다.",
      "Go 得一個 loop：for。if 唔使括號。range 行 slice。"
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
        x = 540,
        facing = -1,
        line = L(
          "Tram or walk? if the light is green, we go.",
          "트램이냐 걸으냐. 불이 초록이면 간다.",
          "電車定行路？燈綠就行。"
        ),
      },
    },
    viz = "street",
    story = L(
      "Percival Street at dawn. Walk if the crossing is clear, else wait. "
        .. "Go has no while: a for with a condition is the while.",
      "새벽의 퍼시벌 스트리트. 횡단보도가 비면 걷고, 아니면 기다린다. "
        .. "Go에는 while이 없다: 조건만 있는 for가 while이다.",
      "朝早嘅波斯富街。過路線空就行，唔係就等。"
        .. "Go 冇 while：得條件嘅 for 就係 while。"
    ),
    stages = {
      {
        topic = "FOR",
        q = L(
          "Go has no while. Which keyword loops while i < 8?",
          "Go에는 while이 없다. i < 8일 때 도는 키워드는?",
          "Go 冇 while。i < 8 就繼續轉嘅 keyword？"
        ),
        code = L(
          [[
i := 0
___ i < 8 {            // the only loop
    i++
}
]],
          [[
i := 0
___ i < 8 {            // 유일한 루프
    i++
}
]],
          [[
i := 0
___ i < 8 {            // 唯一 loop
    i++
}
]]
        ),
        accept = { "for" },
        answer = "for",
        hint = L(
          "The same word as a C-style counted loop.",
          "C 스타일 카운트 루프와 같은 단어.",
          "同 C 風格計數 loop 同一個字。"
        ),
        ok = L(
          "for i < 8 is a while. for { } is forever. for i := 0; i < n; i++ counts.",
          "for i < 8은 while. for { }는 무한. for i := 0; i < n; i++는 카운트.",
          "for i < 8 係 while。for { } 永遠。for i := 0; i < n; i++ 計數。"
        ),
      },
      {
        topic = "RANGE",
        q = L(
          "Walk every shop name in a slice. Fill: for _, name := ___ shops",
          "슬라이스의 가게 이름을 모두 걷기. 채우세요: for _, name := ___ shops",
          "行晒 slice 入面每個舖名。填：for _, name := ___ shops"
        ),
        code = L(
          [[
shops := []string{"Lucky Mac", "Sogo"}
for _, name := ___ shops {
    fmt.Println(name)
}
]],
          [[
shops := []string{"Lucky Mac", "Sogo"}
for _, name := ___ shops {
    fmt.Println(name)
}
]],
          [[
shops := []string{"Lucky Mac", "Sogo"}
for _, name := ___ shops {
    fmt.Println(name)
}
]]
        ),
        accept = { "range" },
        answer = "range",
        hint = L(
          "Gives index and value. The blank _ throws the index away.",
          "인덱스와 값을 줍니다. 빈칸 _는 인덱스를 버립니다.",
          "畀 index 同 value。空白 _ 掉咗 index。"
        ),
        ok = L(
          "for i, v := range s. Use _ when you do not need the index.",
          "for i, v := range s. 인덱스가 필요 없으면 _.",
          "for i, v := range s。唔使 index 就用 _。"
        ),
      },
      {
        topic = "SWITCH",
        q = L(
          "Pick a branch by value without a chain of ifs. Which keyword?",
          "if 사슬 없이 값으로 분기를 고른다. 키워드는?",
          "唔使一串 if，用值揀分支。邊個 keyword？"
        ),
        code = L(
          [[
light := "green"
___ light {
case "green":
    walk()
}
]],
          [[
light := "green"
___ light {
case "green":
    walk()
}
]],
          [[
light := "green"
___ light {
case "green":
    walk()
}
]]
        ),
        accept = { "switch" },
        answer = "switch",
        hint = L(
          "Followed by the value, then case labels. No break needed.",
          "값 다음에 case 라벨. break는 필요 없다.",
          "後面係值，然後 case。唔使 break。"
        ),
        ok = L(
          'switch light { case "green": walk() }. No break: cases do not fall through.',
          'switch light { case "green": walk() }. break 없음: 통과하지 않는다.',
          'switch light { case "green": walk() }。唔使 break：唔會跌落下一格。'
        ),
      },
      {
        topic = "IF",
        q = L(
          "Run cross(), then test its error in the same if. Fill the operator: err ___ nil",
          "cross()를 실행하고 같은 if에서 에러를 검사. 연산자: err ___ nil",
          "行 cross()，然後喺同一個 if 入面測佢嘅 error。operator：err ___ nil"
        ),
        code = L(
          [[
if err := cross(); err ___ nil {   // init; condition
    return err
}
]],
          [[
if err := cross(); err ___ nil {   // 초기화; 조건
    return err
}
]],
          [[
if err := cross(); err ___ nil {   // init; condition
    return err
}
]]
        ),
        answer = "!=",
        accept = { "!=" },
        hint = L(
          "Not equal. The statement before ; runs first, and err lives only inside the if.",
          "같지 않다. ; 앞의 문장이 먼저 실행되고 err는 if 안에서만 산다.",
          "唔等於。; 前面嗰句先行，err 淨係喺 if 入面存在。"
        ),
        ok = L(
          "if init; cond scopes err to one block. The most common line in Go.",
          "if 초기화; 조건은 err를 블록 하나로 가둔다. Go에서 가장 흔한 줄.",
          "if init; cond 將 err 困喺一個 block。Go 入面最常見嘅一行。"
        ),
      },
      {
        topic = "CONTINUE",
        q = L(
          "Skip a closed shop and go on to the next one. Which keyword?",
          "닫힌 가게는 건너뛰고 다음으로. 어떤 키워드?",
          "跳過閂咗嘅舖，去下一間。咩關鍵字？"
        ),
        code = L(
          [[
for _, s := range shops {
    if s.closed {
        ___                // next shop
    }
    fmt.Println(s.name)
}
]],
          [[
for _, s := range shops {
    if s.closed {
        ___                // 다음 가게
    }
    fmt.Println(s.name)
}
]],
          [[
for _, s := range shops {
    if s.closed {
        ___                // 下一間
    }
    fmt.Println(s.name)
}
]]
        ),
        answer = "continue",
        accept = { "continue" },
        hint = L(
          "Jumps to the next iteration. break would leave the loop entirely.",
          "다음 반복으로 건너뛴다. break는 루프를 아예 나간다.",
          "跳去下一次 iteration。break 就會成個 loop 走出去。"
        ),
        ok = L(
          "continue skips one round; break ends the loop.",
          "continue는 한 번 건너뛰고, break는 루프를 끝낸다.",
          "continue 跳一次；break 結束個 loop。"
        ),
      },
      {
        topic = "BREAK",
        q = L(
          "Lucky Mac is found. Leave the loop right now. Which keyword?",
          "럭키 맥을 찾았다. 지금 바로 루프를 나간다. 어떤 키워드?",
          "搵到幸運麥。即刻離開個 loop。咩關鍵字？"
        ),
        code = L(
          [[
for _, s := range shops {
    if s.name == "Lucky Mac" {
        found = s
        ___
    }
}
]],
          [[
for _, s := range shops {
    if s.name == "Lucky Mac" {
        found = s
        ___
    }
}
]],
          [[
for _, s := range shops {
    if s.name == "Lucky Mac" {
        found = s
        ___
    }
}
]]
        ),
        answer = "break",
        accept = { "break" },
        hint = L(
          "Five letters. Also ends a switch or select case early.",
          "다섯 글자. switch나 select의 case도 일찍 끝낸다.",
          "五個字母。都可以提早結束 switch 或者 select 嘅 case。"
        ),
        ok = L(
          "break leaves the innermost for, switch or select. A label breaks an outer one.",
          "break는 가장 안쪽 for, switch, select를 나간다. 레이블로 바깥 것도 가능.",
          "break 離開最入面嘅 for、switch 或 select。加 label 可以離開外面嗰個。"
        ),
      },
    },
  },

  {
    id = "mtr",
    station = "FUNCS",
    name = L("Causeway Bay station", "코즈웨이베이 역", "銅鑼灣站"),
    title = L("Functions and returns", "함수와 반환", "函數同回傳"),
    lesson = L(
      "func names a function. Multiple returns are normal. _ discards a value.",
      "func가 함수 이름. 다중 반환이 보통이다. _는 값을 버린다.",
      "func 命名函數。多個回傳好平常。_ 丟掉一個值。"
    ),
    bg = "bg_mtr",
    portrait = "portrait_hero",
    speaker = L("Alex", "알렉스", "阿力"),
    ground = 348,
    spawn = 180,
    width = 1680,
    npcs = {
      {
        kind = "mei",
        x = 620,
        facing = -1,
        line = L(
          "Octopus tap. The gate function returns ok, err.",
          "옥토퍼스 찍기. 게이트 함수는 ok, err를 반환.",
          "八達通拍卡。閘口 function 回傳 ok, err。"
        ),
      },
    },
    viz = "mtr",
    story = L(
      "The MTR gate is a function: tap(card) (ok bool, err error). "
        .. "Go functions can return more than one value. That is how errors travel.",
      "MTR 게이트는 함수: tap(card) (ok bool, err error). "
        .. "Go 함수는 값을 둘 이상 반환할 수 있다. 그렇게 에러가 이동한다.",
      "港鐵閘口係一個 function：tap(card) (ok bool, err error)。"
        .. "Go function 可以回傳多過一個值。error 就係咁行。"
    ),
    stages = {
      {
        topic = "FUNC",
        q = L(
          "Declare a function. Which keyword starts the line?",
          "함수를 선언. 줄을 시작하는 키워드는?",
          "宣告一個 function。邊個 keyword 開頭？"
        ),
        code = L(
          [[
___ tap(card string) bool {
    return true
}
]],
          [[
package main
___ tap(card string) bool {
    return true
}
]],
          [[
package main
___ tap(card string) bool {
    return true
}
]]
        ),
        accept = { "func" },
        answer = "func",
        hint = L(
          "Short for function. Then the name, then arguments in parentheses.",
          "function의 줄임. 그다음 이름, 그다음 괄호 안 인자.",
          "function 嘅縮寫。然後名，然後括號入面嘅參數。"
        ),
        ok = L(
          "func tap(card string) bool. Name, args, result type.",
          "func tap(card string) bool. 이름, 인자, 결과 타입.",
          "func tap(card string) bool。名、參數、結果類型。"
        ),
      },
      {
        topic = "RETURN",
        q = L(
          "A function that can fail returns a value and an ___.",
          "실패할 수 있는 함수는 값과 ___를 반환한다.",
          "可能失敗嘅 function 回傳一個值同埋一個 ___。"
        ),
        code = L(
          [[
func tap(card string) (bool, ___) {
    return true, nil
}
]],
          [[
func tap(card string) (bool, ___) {
    return true, nil
}
]],
          [[
func tap(card string) (bool, ___) {
    return true, nil
}
]]
        ),
        accept = { "error" },
        answer = "error",
        hint = L(
          "The built-in interface for failure. Last return value by convention.",
          "실패를 나타내는 내장 인터페이스. 관례상 마지막 반환값.",
          "表示失敗嘅內建 interface。慣例放最後一個回傳值。"
        ),
        ok = L(
          "(ok, err). Check err before using ok. The gate opens.",
          "(ok, err). ok를 쓰기 전에 err를 본다. 게이트가 열린다.",
          "(ok, err)。用 ok 之前先睇 err。閘口開咗。"
        ),
      },
      {
        topic = "BLANK",
        q = L(
          "Throw away the bool, keep the error. What character discards?",
          "bool은 버리고 에러만 남긴다. 버리는 문자는?",
          "掉咗 bool，留 error。邊個字元丟掉？"
        ),
        code = L(
          [[
___, err := tap("octopus")
]],
          [[
___, err := tap("octopus")
]],
          [[
___, err := tap("octopus")
]]
        ),
        accept = { "_" },
        answer = "_",
        hint = L(
          "The blank identifier. Compile error if you name a value you never use.",
          "빈 식별자. 쓰지 않는 값에 이름을 붙이면 컴파일 에러.",
          "空白識別符。命名咗又唔用就 compile error。"
        ),
        ok = L(
          "_ means I know this exists and I am ignoring it on purpose.",
          "_는 있는 줄 알고 일부러 무시한다는 뜻.",
          "_ 代表我知佢存在，刻意唔理。"
        ),
      },
      {
        topic = "RETURN",
        q = L(
          "Hand both values back to the caller. Which keyword?",
          "두 값을 호출자에게 돌려준다. 어떤 키워드?",
          "將兩個值交返畀 caller。咩關鍵字？"
        ),
        code = L(
          [[
func tap(card string) (bool, error) {
    if card == "" {
        ___ false, errors.New("no card")
    }
    ___ true, nil
}
]],
          [[
func tap(card string) (bool, error) {
    if card == "" {
        ___ false, errors.New("no card")
    }
    ___ true, nil
}
]],
          [[
func tap(card string) (bool, error) {
    if card == "" {
        ___ false, errors.New("no card")
    }
    ___ true, nil
}
]]
        ),
        answer = "return",
        accept = { "return" },
        hint = L(
          "Six letters. Every result, in order, comma separated.",
          "여섯 글자. 모든 결과를 순서대로, 쉼표로.",
          "六個字母。每個結果，順住次序，逗號分開。"
        ),
        ok = L(
          "return sends every result at once. The bool and the error travel together.",
          "return은 모든 결과를 한 번에 보낸다. bool과 error가 함께 간다.",
          "return 一次過送出所有結果。bool 同 error 一齊行。"
        ),
      },
      {
        topic = "VARIADIC",
        q = L(
          "sum takes any number of fares. Fill the parameter type: fares ___",
          "sum은 요금을 몇 개든 받는다. 매개변수 타입: fares ___",
          "sum 收任意數量嘅車費。parameter type：fares ___"
        ),
        code = L(
          [[
func sum(fares ___) int {     // sum(3, 5, 8)
    t := 0
    for _, f := range fares {
        t += f
    }
    return t
}
]],
          [[
func sum(fares ___) int {     // sum(3, 5, 8)
    t := 0
    for _, f := range fares {
        t += f
    }
    return t
}
]],
          [[
func sum(fares ___) int {     // sum(3, 5, 8)
    t := 0
    for _, f := range fares {
        t += f
    }
    return t
}
]]
        ),
        answer = "...int",
        accept = { "...int" },
        hint = L(
          "Three dots then the element type. Inside the function fares is a []int.",
          "점 세 개 다음 원소 타입. 함수 안에서 fares는 []int.",
          "三粒點然後係元素 type。喺 function 入面 fares 係 []int。"
        ),
        ok = L(
          "...int is variadic. Call it with sum(a, b, c) or spread a slice: sum(fares...).",
          "...int는 가변 인자. sum(a, b, c)로 호출하거나 슬라이스를 펼친다: sum(fares...).",
          "...int 係 variadic。可以 sum(a, b, c) 或者攤開 slice：sum(fares...)。"
        ),
      },
    },
  },

  {
    id = "times",
    station = "SLICES",
    name = L("Times Square", "타임스 스퀘어", "時代廣場"),
    title = L("Arrays, slices, append", "배열, 슬라이스, append", "陣列、slice、append"),
    lesson = L(
      "A slice is a view: pointer, len, cap. append may grow it. len is the length.",
      "슬라이스는 뷰: 포인터, len, cap. append가 키울 수 있다. len이 길이다.",
      "slice 係一個 view：pointer、len、cap。append 可以長大。len 係長度。"
    ),
    bg = "bg_times",
    portrait = "portrait_friends",
    speaker = L("Mei", "메이", "阿美"),
    ground = 348,
    spawn = 180,
    width = 1680,
    npcs = {
      {
        kind = "mei",
        x = 700,
        facing = -1,
        line = L(
          "The cube is a slice of ads. append one more.",
          "큐브는 광고 슬라이스. 하나 더 append.",
          "個立方係廣告 slice。再 append 一個。"
        ),
      },
    },
    viz = "times",
    story = L(
      "Times Square's LED cube is a slice of frames. An array has a fixed size "
        .. "in the type. A slice does not. append returns a (maybe new) slice.",
      "타임스 스퀘어 LED 큐브는 프레임 슬라이스. 배열은 타입에 크기가 고정. "
        .. "슬라이스는 아니다. append는 (새) 슬라이스를 반환한다.",
      "時代廣場 LED 立方係 frame 嘅 slice。array 嘅大細寫死喺類型。"
        .. "slice 唔係。append 回傳（可能新嘅）slice。"
    ),
    stages = {
      {
        topic = "SLICE",
        q = L(
          "A slice of int, not a fixed array. Fill the type: s := ___{1, 2, 3}",
          "고정 배열이 아닌 int 슬라이스. 타입을 채우세요: s := ___{1, 2, 3}",
          "int 嘅 slice，唔係固定 array。填類型：s := ___{1, 2, 3}"
        ),
        code = L(
          [[
s := ___{1, 2, 3}     // slice, length 3
]],
          [[
s := ___{1, 2, 3}     // 슬라이스, 길이 3
]],
          [[
s := ___{1, 2, 3}     // slice，長度 3
]]
        ),
        accept = { "[]int" },
        answer = "[]int",
        hint = L(
          "Empty brackets then the element type. [3]int would be an array.",
          "빈 대괄호 다음에 원소 타입. [3]int는 배열.",
          "空括號然後元素類型。[3]int 就係 array。"
        ),
        ok = L(
          "[]int is a slice. [3]int is an array of three. Slices are what you use.",
          "[]int는 슬라이스. [3]int는 원소 셋 배열. 쓰는 건 슬라이스.",
          "[]int 係 slice。[3]int 係三個嘅 array。平時用 slice。"
        ),
      },
      {
        topic = "APPEND",
        q = L(
          "Grow a slice by one hash brown. Which built-in?",
          "해시브라운 하나로 슬라이스를 키운다. 내장 함수는?",
          "加塊薯餅令 slice 長大。邊個內建函數？"
        ),
        code = L(
          [[
tray := []string{"muffin"}
tray = ___(tray, "hashbrown")
]],
          [[
tray := []string{"muffin"}
tray = ___(tray, "hashbrown")
]],
          [[
tray := []string{"muffin"}
tray = ___(tray, "hashbrown")
]]
        ),
        accept = { "append" },
        answer = "append",
        hint = L(
          "Always assign the result back. It may allocate a new backing array.",
          "항상 결과를 다시 대입. 새 백킹 배열을 할당할 수 있다.",
          "一定要將結果賦返。可能會配新 backing array。"
        ),
        ok = L(
          "tray = append(tray, x). Never ignore the return.",
          "tray = append(tray, x). 반환값을 무시하지 마라.",
          "tray = append(tray, x)。唔好忽略回傳值。"
        ),
      },
      {
        topic = "LEN",
        q = L(
          "How many items are in the slice right now? Which built-in?",
          "지금 슬라이스에 몇 개가 있나? 내장 함수는?",
          "而家 slice 有幾多件？邊個內建函數？"
        ),
        code = L(
          [[
tray := []string{"muffin", "hashbrown"}
n := ___(tray)         // 2
]],
          [[
tray := []string{"muffin", "hashbrown"}
n := ___(tray)         // 2
]],
          [[
tray := []string{"muffin", "hashbrown"}
n := ___(tray)         // 2
]]
        ),
        accept = { "len" },
        answer = "len",
        hint = L(
          "Works on slices, strings, maps, channels. cap is the capacity.",
          "슬라이스, 문자열, 맵, 채널에 동작. cap은 용량.",
          "對 slice、string、map、channel 都得。cap 係容量。"
        ),
        ok = L(
          "len is how many you can see. cap is how many fit before a new array.",
          "len은 보이는 개수. cap은 새 배열 전까지 들어가는 수.",
          "len 係見到幾多。cap 係換新 array 之前仲放得幾多。"
        ),
      },
      {
        topic = "ARRAY",
        q = L(
          "A fixed array of exactly 3 frames, size in the type. Fill: var frames ___",
          "정확히 3개 프레임의 고정 배열, 크기가 타입에 포함: var frames ___",
          "啱啱三格嘅固定 array，大小寫喺 type 入面：var frames ___"
        ),
        code = L(
          [[
var frames ___          // length is part of the type
frames[0] = "muffin"
]],
          [[
var frames ___          // 길이가 타입의 일부
frames[0] = "muffin"
]],
          [[
var frames ___          // 長度係 type 嘅一部分
frames[0] = "muffin"
]]
        ),
        answer = "[3]string",
        accept = { "[3]string" },
        hint = L(
          "Number in the brackets, then the element type. It cannot grow.",
          "대괄호 안에 숫자, 그 다음 원소 타입. 늘어날 수 없다.",
          "方括號入面寫數字，然後係元素 type。唔可以變大。"
        ),
        ok = L(
          "[3]string is an array: a value, fixed length, copied on assignment. []string is a slice.",
          "[3]string은 배열: 값이고, 길이 고정, 대입 시 복사. []string은 슬라이스.",
          "[3]string 係 array：係值，長度固定，assign 會 copy。[]string 係 slice。"
        ),
      },
      {
        topic = "SLICING",
        q = L(
          "A view of the 2nd and 3rd items only (index 1 and 2). Fill: two := tray[___]",
          "2번째와 3번째만 보는 뷰 (인덱스 1, 2): two := tray[___]",
          "淨係睇第二同第三個（index 1 同 2）：two := tray[___]"
        ),
        code = L(
          [[
tray := []string{"muffin", "hash", "coffee", "tea"}
two := tray[___]         // {"hash", "coffee"}
]],
          [[
tray := []string{"muffin", "hash", "coffee", "tea"}
two := tray[___]         // {"hash", "coffee"}
]],
          [[
tray := []string{"muffin", "hash", "coffee", "tea"}
two := tray[___]         // {"hash", "coffee"}
]]
        ),
        answer = "1:3",
        accept = { "1:3" },
        hint = L(
          "low:high. Includes low, excludes high. Same backing array, no copy.",
          "low:high. low 포함, high 제외. 같은 배열을 공유, 복사 없음.",
          "low:high。包 low，唔包 high。共用同一個底層 array，冇 copy。"
        ),
        ok = L(
          "s[1:3] is a slice of a slice. Changing two[0] changes tray[1] too.",
          "s[1:3]은 슬라이스의 슬라이스. two[0]을 바꾸면 tray[1]도 바뀐다.",
          "s[1:3] 係 slice 嘅 slice。改 two[0] 都會改埋 tray[1]。"
        ),
      },
      {
        topic = "ALIAS",
        q = L(
          "b shares a's array. After b[0] = 9, what does a[0] print?",
          "b는 a의 배열을 공유. b[0] = 9 다음 a[0]은 뭘 출력?",
          "b 同 a 共用個 array。b[0] = 9 之後，a[0] 印咩？"
        ),
        code = L(
          [[
a := []int{1, 2, 3}
b := a[:2]
b[0] = 9
fmt.Println(a[0])       // prints ___
]],
          [[
a := []int{1, 2, 3}
b := a[:2]
b[0] = 9
fmt.Println(a[0])       // 출력: ___
]],
          [[
a := []int{1, 2, 3}
b := a[:2]
b[0] = 9
fmt.Println(a[0])       // 印出 ___
]]
        ),
        answer = "9",
        accept = { "9" },
        hint = L(
          "A slice is a window, not a copy. Both look at the same memory.",
          "슬라이스는 복사가 아니라 창. 둘 다 같은 메모리를 본다.",
          "slice 係一個窗，唔係 copy。兩個都望住同一塊 memory。"
        ),
        ok = L(
          "Slices alias. Use copy() or append([]int(nil), a...) when you need your own.",
          "슬라이스는 공유된다. 독립 복사가 필요하면 copy()나 append([]int(nil), a...).",
          "slice 係共用嘅。要自己一份就用 copy() 或者 append([]int(nil), a...)。"
        ),
      },
      {
        topic = "CAP",
        q = L(
          "How many items fit before append must reallocate? Which built-in?",
          "append가 재할당하기 전까지 몇 개 들어가나? 어떤 내장 함수?",
          "append 要重新分配之前裝得幾多個？咩內置 function？"
        ),
        code = L(
          [[
tray := make([]string, 2, 8)
fmt.Println(len(tray), ___(tray))   // 2 8
]],
          [[
tray := make([]string, 2, 8)
fmt.Println(len(tray), ___(tray))   // 2 8
]],
          [[
tray := make([]string, 2, 8)
fmt.Println(len(tray), ___(tray))   // 2 8
]]
        ),
        answer = "cap",
        accept = { "cap" },
        hint = L(
          "Three letters. Capacity, not length.",
          "세 글자. 길이가 아니라 용량.",
          "三個字母。容量，唔係長度。"
        ),
        ok = L(
          "cap is the room in the backing array. append doubles it when len reaches cap.",
          "cap은 기반 배열의 여유. len이 cap에 닿으면 append가 두 배로 늘린다.",
          "cap 係底層 array 嘅空位。len 到咗 cap，append 就加大一倍。"
        ),
      },
      {
        topic = "MAKE",
        q = L(
          "Allocate a slice with length 0 and room for 8. Which built-in?",
          "길이 0, 여유 8인 슬라이스 할당. 어떤 내장 함수?",
          "分配一個長度 0、可以裝 8 個嘅 slice。咩內置 function？"
        ),
        code = L(
          [[
tray := ___([]string, 0, 8)   // len 0, cap 8
tray = append(tray, "muffin")
]],
          [[
tray := ___([]string, 0, 8)   // len 0, cap 8
tray = append(tray, "muffin")
]],
          [[
tray := ___([]string, 0, 8)   // len 0, cap 8
tray = append(tray, "muffin")
]]
        ),
        answer = "make",
        accept = { "make" },
        hint = L(
          "Four letters. It also builds maps and channels.",
          "네 글자. 맵과 채널도 만든다.",
          "四個字母。都可以整 map 同 channel。"
        ),
        ok = L(
          "make(T, len, cap) for slices, maps, channels. new(T) only gives a zeroed pointer.",
          "슬라이스, 맵, 채널은 make(T, len, cap). new(T)는 0으로 채운 포인터만.",
          "slice、map、channel 用 make(T, len, cap)。new(T) 淨係畀個零值 pointer。"
        ),
      },
    },
  },

  {
    id = "sogo",
    station = "MAPS",
    name = L("Sogo", "소고", "崇光"),
    title = L("Maps", "맵", "map"),
    lesson = L(
      "A map is a hash table. comma-ok tells you if the key was there. delete removes it.",
      "맵은 해시 테이블. comma-ok는 키가 있었는지 알려준다. delete가 지운다.",
      "map 係 hash table。comma-ok 話你知個 key 在唔在。delete 刪走。"
    ),
    bg = "bg_mall",
    portrait = "portrait_hero",
    speaker = L("Alex", "알렉스", "阿力"),
    ground = 348,
    spawn = 180,
    width = 1600,
    npcs = {
      {
        kind = "mei",
        x = 560,
        facing = -1,
        line = L(
          "Price list is a map. Hash brown: 8 dollars.",
          "가격표는 맵. 해시브라운: 8달러.",
          "價目表係 map。薯餅：8 蚊。"
        ),
      },
    },
    viz = "sogo",
    story = L(
      "Sogo's directory is a map from shop name to floor. Missing keys return "
        .. "the zero value, so you must ask comma-ok before you trust the number.",
      "소고 안내도는 가게 이름에서 층으로 가는 맵. 없는 키는 제로 값을 주므로 "
        .. "숫자를 믿기 전에 comma-ok를 물어야 한다.",
      "崇光目錄係舖名到樓層嘅 map。唔存在嘅 key 會回零值，"
        .. "所以信個數字之前要問 comma-ok。"
    ),
    stages = {
      {
        topic = "MAP",
        q = L(
          'A map from string to int. Fill the type: prices := ___{"muffin": 18}',
          'string에서 int로 가는 맵. 타입을 채우세요: prices := ___{"muffin": 18}',
          'string 到 int 嘅 map。填類型：prices := ___{"muffin": 18}'
        ),
        code = L(
          [[
prices := ___{
    "muffin": 18,
}
]],
          [[
prices := ___{
    "muffin": 18,
}
]],
          [[
prices := ___{
    "muffin": 18,
}
]]
        ),
        accept = { "map[string]int" },
        answer = "map[string]int",
        hint = L(
          "map, then [key type], then value type.",
          "map, 그다음 [키 타입], 그다음 값 타입.",
          "map，然後 [key 類型]，然後 value 類型。"
        ),
        ok = L(
          "map[string]int. make(map[string]int) if you start empty.",
          "map[string]int. 빈 채로 시작하려면 make(map[string]int).",
          "map[string]int。由空開始就 make(map[string]int)。"
        ),
      },
      {
        topic = "OK",
        q = L(
          "Was the key there? The second result is a bool named ___.",
          "키가 있었나? 두 번째 결과는 bool이고 이름은 ___.",
          "個 key 在唔在？第二個結果係 bool，名叫 ___。"
        ),
        code = L(
          [[
n, ___ := prices["hashbrown"]
if !___ {
    // missing
}
]],
          [[
n, ___ := prices["hashbrown"]
if !___ {
    // 없음
}
]],
          [[
n, ___ := prices["hashbrown"]
if !___ {
    // 冇
}
]]
        ),
        accept = { "ok" },
        answer = "ok",
        hint = L(
          "The comma-ok idiom. Same word twice on those two lines.",
          "comma-ok 관용구. 두 줄에 같은 단어.",
          "comma-ok 慣用語。嗰兩行同一個字。"
        ),
        ok = L(
          "v, ok := m[k]. If ok is false, v is the zero value and the key was missing.",
          "v, ok := m[k]. ok가 false면 v는 제로 값이고 키는 없었다.",
          "v, ok := m[k]。ok 係 false，v 係零值，key 唔在。"
        ),
      },
      {
        topic = "DELETE",
        q = L(
          "Remove a key from a map. Which built-in?",
          "맵에서 키를 지운다. 내장 함수는?",
          "由 map 刪走一個 key。邊個內建函數？"
        ),
        code = L(
          [[
___(prices, "closed")
]],
          [[
___(prices, "closed")
]],
          [[
___(prices, "closed")
]]
        ),
        accept = { "delete" },
        answer = "delete",
        hint = L(
          "delete(m, key). Safe if the key is already gone.",
          "delete(m, key). 키가 없어도 안전.",
          "delete(m, key)。key 已經冇都安全。"
        ),
        ok = L(
          "delete(m, k) removes it. Maps grow by assignment, shrink by this.",
          "delete(m, k)가 지운다. 맵은 대입으로 크고 이걸로 줄어든다.",
          "delete(m, k) 刪走。map 用賦值長大，用呢個縮小。"
        ),
      },
      {
        topic = "MAKE",
        q = L(
          "A nil map panics when you write to it. Allocate one: floors = ___(map[string]int)",
          "nil 맵에 쓰면 panic. 하나 할당: floors = ___(map[string]int)",
          "nil map 一寫入就 panic。分配一個：floors = ___(map[string]int)"
        ),
        code = L(
          [[
var floors map[string]int      // nil: read ok, write panics
floors = ___(map[string]int)
floors["Sogo"] = 1
]],
          [[
var floors map[string]int      // nil: 읽기 OK, 쓰기 panic
floors = ___(map[string]int)
floors["Sogo"] = 1
]],
          [[
var floors map[string]int      // nil：讀得，寫會 panic
floors = ___(map[string]int)
floors["Sogo"] = 1
]]
        ),
        answer = "make",
        accept = { "make" },
        hint = L(
          "Same built-in as for slices. A literal map[string]int{} also works.",
          "슬라이스와 같은 내장 함수. 리터럴 map[string]int{}도 된다.",
          "同 slice 一樣嘅內置 function。寫 map[string]int{} literal 都得。"
        ),
        ok = L(
          "make (or a {} literal) before the first write. Reading a nil map is safe.",
          "첫 쓰기 전에 make (또는 {} 리터럴). nil 맵 읽기는 안전.",
          "第一次寫入之前要 make（或者 {} literal）。讀 nil map 係安全嘅。"
        ),
      },
      {
        topic = "CLEAR",
        q = L(
          "Empty the whole map in one call (Go 1.21). Which built-in?",
          "맵 전체를 한 번에 비운다 (Go 1.21). 어떤 내장 함수?",
          "一次過清空成個 map（Go 1.21）。咩內置 function？"
        ),
        code = L(
          [[
___(floors)                  // len(floors) == 0 after
]],
          [[
___(floors)                  // 이후 len(floors) == 0
]],
          [[
___(floors)                  // 之後 len(floors) == 0
]]
        ),
        answer = "clear",
        accept = { "clear" },
        hint = L(
          "Five letters. On a slice it zeroes every element instead.",
          "다섯 글자. 슬라이스에 쓰면 모든 원소를 0으로.",
          "五個字母。用喺 slice 就會將每個元素歸零。"
        ),
        ok = L(
          "clear(m) deletes every key. Before 1.21 you looped with delete.",
          "clear(m)은 모든 키를 지운다. 1.21 전에는 delete로 루프를 돌렸다.",
          "clear(m) 刪晒所有 key。1.21 之前要用 delete 逐個 loop。"
        ),
      },
    },
  },

  {
    id = "queue",
    station = "STRUCTS",
    name = L("Lucky Mac queue", "럭키 맥 줄", "幸運麥排隊"),
    title = L(
      "Structs, pointers, methods, interfaces",
      "구조체, 포인터, 메서드, 인터페이스",
      "struct、pointer、method、interface"
    ),
    lesson = L(
      "struct groups fields. *T is a pointer. Methods have a receiver. interface is a set of methods.",
      "struct는 필드를 묶는다. *T는 포인터. 메서드는 리시버가 있다. interface는 메서드 집합.",
      "struct 綁欄位。*T 係 pointer。method 有 receiver。interface 係一組 method。"
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
        facing = 1,
        line = L(
          "Order is a struct. Point at it. The till talks through an interface.",
          "주문은 struct. 그걸 가리켜. 계산대는 interface로 말한다.",
          "訂單係 struct。指住佢。收銀用 interface 傾偈。"
        ),
      },
      {
        kind = "mei",
        x = 280,
        facing = 1,
        line = L(
          "Morning set. Don't show him your laptop bugs.",
          "모닝세트. 노트북 버그는 보여주지 마.",
          "早餐套餐。唔好畀佢睇你部電腦嘅 bug。"
        ),
      },
    },
    viz = "queue",
    story = L(
      "The queue is a struct of orders. A method with a pointer receiver can change "
        .. "the order. The till only knows the Pay() interface, not the card type.",
      "줄은 주문 struct의 모임. 포인터 리시버 메서드는 주문을 바꿀 수 있다. "
        .. "계산대는 Pay() 인터페이스만 알지 카드 종류는 모른다.",
      "隊伍係訂單 struct。用 pointer receiver 嘅 method 可以改訂單。"
        .. "收銀只識 Pay() interface，唔識卡種類。"
    ),
    stages = {
      {
        topic = "STRUCT",
        q = L(
          "Group name and price in one type. Which keyword?",
          "이름과 가격을 한 타입으로. 키워드는?",
          "將名同價錢綁成一個類型。邊個 keyword？"
        ),
        code = L(
          [[
type Order ___ {
    Item  string
    Price int
}
]],
          [[
type Order ___ {
    Item  string
    Price int
}
]],
          [[
type Order ___ {
    Item  string
    Price int
}
]]
        ),
        accept = { "struct" },
        answer = "struct",
        hint = L(
          "type Name ___, then curly braces with fields.",
          "type 이름 ___, 그다음 필드가 있는 중괄호.",
          "type 名 ___，然後大括號入面欄位。"
        ),
        ok = L(
          "type Order struct { Item string; Price int }. A value type.",
          "type Order struct { Item string; Price int }. 값 타입.",
          "type Order struct { Item string; Price int }。值類型。"
        ),
      },
      {
        topic = "POINTER",
        q = L(
          "A pointer to Order. Fill the type of p: var p ___Order",
          "Order를 가리키는 포인터. p의 타입: var p ___Order",
          "指住 Order 嘅 pointer。p 嘅類型：var p ___Order"
        ),
        code = L(
          [[
var p ___Order         // address of an Order
p = &Order{Item: "set"}
]],
          [[
var p ___Order         // Order의 주소
p = &Order{Item: "set"}
]],
          [[
var p ___Order         // Order 嘅地址
p = &Order{Item: "set"}
]]
        ),
        accept = { "*" },
        answer = "*",
        hint = L(
          "Star before the type. & takes the address. *p reads through it.",
          "타입 앞의 별표. &는 주소를 취한다. *p는 따라 읽는다.",
          "類型前面嘅星號。& 攞地址。*p 跟住讀。"
        ),
        ok = L(
          "*Order is a pointer. Methods that change the struct use a *T receiver.",
          "*Order는 포인터. struct를 바꾸는 메서드는 *T 리시버.",
          "*Order 係 pointer。會改 struct 嘅 method 用 *T receiver。"
        ),
      },
      {
        topic = "INTERFACE",
        q = L(
          "A set of methods, no fields. Which keyword?",
          "필드 없이 메서드만 모은 것. 키워드는?",
          "一組 method，冇欄位。邊個 keyword？"
        ),
        code = L(
          [[
type Payer ___ {
    Pay(int) error
}
]],
          [[
type Payer ___ {
    Pay(int) error
}
]],
          [[
type Payer ___ {
    Pay(int) error
}
]]
        ),
        accept = { "interface" },
        answer = "interface",
        hint = L(
          "Satisfied implicitly: any type with those methods implements it.",
          "암시적으로 만족: 그 메서드가 있는 타입은 구현한 것.",
          "隱式滿足：有嗰啲 method 嘅類型就算實現咗。"
        ),
        ok = L(
          "interface { Pay(int) error }. The till does not care if it is Octopus or cash.",
          "interface { Pay(int) error }. 계산대는 옥토퍼스인지 현금인지 모른다.",
          "interface { Pay(int) error }。收銀唔理係八達通定現金。"
        ),
      },
      {
        topic = "ADDRESS",
        q = L(
          'Take the address of a new Order so p is a *Order. Fill: p := ___Order{Item: "set"}',
          '새 Order의 주소를 취해 p를 *Order로: p := ___Order{Item: "set"}',
          '攞新 Order 嘅地址，令 p 係 *Order：p := ___Order{Item: "set"}'
        ),
        code = L(
          [[
p := ___Order{Item: "set"}   // p is *Order
p.Price = 25                  // Go dereferences for you
]],
          [[
p := ___Order{Item: "set"}   // p는 *Order
p.Price = 25                  // Go가 알아서 역참조
]],
          [[
p := ___Order{Item: "set"}   // p 係 *Order
p.Price = 25                  // Go 幫你 dereference
]]
        ),
        answer = "&",
        accept = { "&" },
        hint = L(
          "Ampersand. & takes an address, * reads through one.",
          "앰퍼샌드. &는 주소를 취하고 *는 주소를 통해 읽는다.",
          "& 號。& 攞地址，* 透過地址去讀。"
        ),
        ok = L(
          "&T{} is the usual way to make a pointer to a struct. p.Field works without (*p).",
          "&T{}가 구조체 포인터를 만드는 보통 방법. (*p) 없이 p.Field가 된다.",
          "&T{} 係整 struct pointer 嘅慣常寫法。p.Field 唔使寫 (*p)。"
        ),
      },
      {
        topic = "METHOD",
        q = L(
          "A method that changes the order needs a pointer receiver. Fill: func (o ___) Add(p int)",
          "주문을 바꾸는 메서드는 포인터 리시버가 필요: func (o ___) Add(p int)",
          "改 order 嘅 method 要 pointer receiver：func (o ___) Add(p int)"
        ),
        code = L(
          [[
func (o ___) Add(p int) {   // pointer receiver
    o.Price += p            // changes the caller's Order
}
]],
          [[
func (o ___) Add(p int) {   // 포인터 리시버
    o.Price += p            // 호출자의 Order를 바꿈
}
]],
          [[
func (o ___) Add(p int) {   // pointer receiver
    o.Price += p            // 改 caller 個 Order
}
]]
        ),
        answer = "*Order",
        accept = { "*Order" },
        hint = L(
          "Star then the type name. A value receiver (o Order) would change a copy.",
          "별표 다음 타입 이름. 값 리시버 (o Order)는 복사본을 바꾼다.",
          "星然後 type 名。value receiver (o Order) 改嘅係 copy。"
        ),
        ok = L(
          "Pointer receiver to mutate or for big structs; value receiver for small read-only types.",
          "변경하거나 큰 구조체면 포인터 리시버; 작고 읽기 전용이면 값 리시버.",
          "要改或者大 struct 用 pointer receiver；細而且唔改嘅用 value receiver。"
        ),
      },
      {
        topic = "STRINGER",
        q = L(
          "fmt prints a type your way if it has one method. Fill: func (o Order) ___() string",
          "메서드 하나만 있으면 fmt가 원하는 대로 출력: func (o Order) ___() string",
          "有一個 method，fmt 就會照你嘅方式印：func (o Order) ___() string"
        ),
        code = L(
          [[
func (o Order) ___() string {
    return o.Item + " $" + strconv.Itoa(o.Price)
}
fmt.Println(o)          // set $25
]],
          [[
func (o Order) ___() string {
    return o.Item + " $" + strconv.Itoa(o.Price)
}
fmt.Println(o)          // set $25
]],
          [[
func (o Order) ___() string {
    return o.Item + " $" + strconv.Itoa(o.Price)
}
fmt.Println(o)          // set $25
]]
        ),
        answer = "String",
        accept = { "String" },
        hint = L(
          "Capital S. The fmt.Stringer interface has exactly this one method.",
          "대문자 S. fmt.Stringer 인터페이스의 유일한 메서드.",
          "大寫 S。fmt.Stringer interface 就係得呢一個 method。"
        ),
        ok = L(
          "String() string satisfies fmt.Stringer. Println and %v call it automatically.",
          "String() string이 fmt.Stringer를 만족. Println과 %v가 자동으로 호출.",
          "String() string 滿足 fmt.Stringer。Println 同 %v 會自動 call。"
        ),
      },
      {
        topic = "NILIFACE",
        q = L(
          "A nil *Order stored in an interface. Is the interface == nil? It prints ___",
          "nil *Order를 인터페이스에 넣었다. 인터페이스 == nil? 출력은 ___",
          "將 nil *Order 放入 interface。個 interface == nil？印出 ___"
        ),
        code = L(
          [[
var p *Order = nil
var i any = p
fmt.Println(i == nil)   // prints ___
]],
          [[
var p *Order = nil
var i any = p
fmt.Println(i == nil)   // 출력: ___
]],
          [[
var p *Order = nil
var i any = p
fmt.Println(i == nil)   // 印出 ___
]]
        ),
        answer = "false",
        accept = { "false" },
        hint = L(
          "An interface is (type, value). The type *Order is set, so it is not the nil interface.",
          "인터페이스는 (타입, 값). 타입 *Order가 있으니 nil 인터페이스가 아니다.",
          "interface 係 (type, value)。type *Order 已經有，所以唔係 nil interface。"
        ),
        ok = L(
          "The typed-nil trap: return a plain nil error, never a nil *MyError.",
          "타입 있는 nil 함정: nil *MyError 말고 그냥 nil error를 반환할 것.",
          "typed nil 陷阱：要回傳純 nil error，唔好回傳 nil *MyError。"
        ),
      },
    },
  },
}

return maps
