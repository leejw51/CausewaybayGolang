-- Quest 3 DELIVERY: after breakfast, Lucky Mac wants a delivery app by the
-- lunch rush. Seven tickets: strings, errors, types, JSON, HTTP, the go
-- tool, and the newest standard library.
-- Same shape as src/data.lua: the blank ___ is NOT written in the code.

local function L(en, ko, yue)
  return { en = en, ko = ko, yue = yue }
end

local maps = {
  {
    id = "runes",
    station = "STRINGS",
    name = L("The signboard", "간판", "招牌"),
    title = L("Strings, runes, bytes", "문자열, 룬, 바이트", "string、rune、byte"),
    lesson = L(
      "string is bytes, rune is a code point. utf8 counts characters, strconv converts.",
      "string은 바이트다. rune은 유니코드 코드 포인트 하나. utf8과 []rune이 글자를 센다. strconv가 변환한다.",
      "string 係 byte。rune 係一個 Unicode code point。utf8 同 []rune 數字元。strconv 做轉換。"
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
        x = 620,
        facing = -1,
        line = L(
          "The new sign says 銅鑼灣. The app counts it as nine letters.",
          "새 간판은 銅鑼灣. 앱은 아홉 글자라고 센다.",
          "新招牌寫住銅鑼灣。App 數到九個字。"
        ),
      },
    },
    viz = "runes",
    story = L(
      "08:10. Breakfast done. The owner wants a delivery app before the lunch rush. "
        .. "First ticket: the signboard shows 銅鑼灣 wrong, because a Go string is bytes, not characters.",
      "08:10. 아침 끝. 사장님은 점심 전에 배달 앱을 원한다. "
        .. "첫 티켓: 간판의 銅鑼灣이 깨진다. Go 문자열은 글자가 아니라 바이트이기 때문.",
      "朝早八點十分。食完早餐。老闆想午市前有個外賣 App。"
        .. "第一張單：招牌嘅銅鑼灣顯示錯咗，因為 Go 嘅 string 係 byte，唔係字元。"
    ),
    stages = {
      {
        topic = "RUNE",
        q = L(
          "One Unicode character in single quotes. Which type?",
          "작은따옴표 안의 유니코드 글자 하나. 어떤 타입?",
          "單引號入面一個 Unicode 字元。咩 type？"
        ),
        code = L(
          [[
var r ___ = '灣'        // one code point
fmt.Println(r)          // 28771
]],
          [[
var r ___ = '灣'        // 코드 포인트 하나
fmt.Println(r)          // 28771
]],
          [[
var r ___ = '灣'        // 一個 code point
fmt.Println(r)          // 28771
]]
        ),
        answer = "rune",
        accept = { "rune", "int32" },
        hint = L(
          "Four letters. An alias of int32. byte is the alias of uint8.",
          "네 글자. int32의 별칭. byte는 uint8의 별칭.",
          "四個字母。int32 嘅別名。byte 係 uint8 嘅別名。"
        ),
        ok = L(
          "rune is one code point. 'x' literals are runes, \"x\" literals are strings.",
          "rune은 코드 포인트 하나. 'x'는 rune, \"x\"는 string.",
          "rune 係一個 code point。'x' 係 rune，\"x\" 係 string。"
        ),
      },
      {
        topic = "BYTES",
        q = L(
          "len counts bytes. 灣 is one character. In UTF-8, how many bytes?",
          "len은 바이트를 센다. 灣은 한 글자. UTF-8로 몇 바이트?",
          "len 數 byte。灣 係一個字。UTF-8 入面係幾多 byte？"
        ),
        code = L(
          [[
s := "灣"
fmt.Println(len(s))     // prints ___
]],
          [[
s := "灣"
fmt.Println(len(s))     // 출력: ___
]],
          [[
s := "灣"
fmt.Println(len(s))     // 印出 ___
]]
        ),
        answer = "3",
        accept = { "3" },
        hint = L(
          "ASCII letters take one byte; CJK characters take three.",
          "ASCII 글자는 1바이트, 한중일 글자는 3바이트.",
          "ASCII 字母一個 byte；中日韓字三個 byte。"
        ),
        ok = L(
          "len(s) is bytes, not characters. That is why the sign counted nine.",
          "len(s)는 글자가 아니라 바이트 수. 그래서 간판이 아홉으로 셌다.",
          "len(s) 係 byte 數，唔係字數。所以招牌數到九。"
        ),
      },
      {
        topic = "COUNT",
        q = L(
          "Count characters, not bytes. Which unicode/utf8 function?",
          "바이트가 아니라 글자를 센다. unicode/utf8의 어떤 함수?",
          "數字元唔係數 byte。unicode/utf8 邊個 function？"
        ),
        code = L(
          [[
import "unicode/utf8"
n := utf8.___("銅鑼灣")   // 3
]],
          [[
import "unicode/utf8"
n := utf8.___("銅鑼灣")   // 3
]],
          [[
import "unicode/utf8"
n := utf8.___("銅鑼灣")   // 3
]]
        ),
        answer = "RuneCountInString",
        accept = { "RuneCountInString" },
        hint = L(
          "Rune, Count, In, String: one long name. Or len([]rune(s)).",
          "Rune, Count, In, String: 긴 이름 하나. 또는 len([]rune(s)).",
          "Rune、Count、In、String：一個長名。或者 len([]rune(s))。"
        ),
        ok = L(
          "utf8.RuneCountInString counts code points. []rune(s) makes them indexable.",
          "utf8.RuneCountInString이 코드 포인트를 센다. []rune(s)로 인덱싱 가능.",
          "utf8.RuneCountInString 數 code point。[]rune(s) 就可以用 index。"
        ),
      },
      {
        topic = "RANGE",
        q = L(
          "range over a string gives runes. Print each one as text: fill ___(r)",
          "문자열을 range하면 rune이 나온다. 각각을 글자로 출력: ___(r)",
          "range 一個 string 會攞到 rune。將每個印做文字：___(r)"
        ),
        code = L(
          [[
for i, r := range "銅鑼灣" {
    fmt.Println(i, ___(r))   // 0 銅, 3 鑼, 6 灣
}
]],
          [[
for i, r := range "銅鑼灣" {
    fmt.Println(i, ___(r))   // 0 銅, 3 鑼, 6 灣
}
]],
          [[
for i, r := range "銅鑼灣" {
    fmt.Println(i, ___(r))   // 0 銅, 3 鑼, 6 灣
}
]]
        ),
        answer = "string",
        accept = { "string" },
        hint = L(
          "Convert the rune back to a string. The index i is a byte offset.",
          "rune을 다시 문자열로 변환. 인덱스 i는 바이트 오프셋.",
          "將 rune 轉返做 string。index i 係 byte 位置。"
        ),
        ok = L(
          "range decodes UTF-8 for you: byte index plus rune. string(r) turns it back.",
          "range가 UTF-8을 풀어준다: 바이트 인덱스와 rune. string(r)로 되돌린다.",
          "range 幫你解 UTF-8：byte index 加 rune。string(r) 轉返去。"
        ),
      },
      {
        topic = "STRINGS",
        q = L(
          "Shout the shop name. Which strings function upper-cases?",
          "가게 이름을 크게. strings의 어떤 함수가 대문자로 바꾸나?",
          "大聲叫舖名。strings 邊個 function 變大寫？"
        ),
        code = L(
          [[
import "strings"
sign := strings.___("lucky mac")   // "LUCKY MAC"
]],
          [[
import "strings"
sign := strings.___("lucky mac")   // "LUCKY MAC"
]],
          [[
import "strings"
sign := strings.___("lucky mac")   // "LUCKY MAC"
]]
        ),
        answer = "ToUpper",
        accept = { "ToUpper" },
        hint = L(
          "To then Upper. Strings are immutable, so it returns a new one.",
          "To 다음 Upper. 문자열은 불변이라 새 문자열을 돌려준다.",
          "To 然後 Upper。string 唔可以改，所以會回傳新嘅。"
        ),
        ok = L(
          "strings has Split, Join, Contains, TrimSpace, ToUpper... all return new strings.",
          "strings에는 Split, Join, Contains, TrimSpace, ToUpper... 모두 새 문자열 반환.",
          "strings 有 Split、Join、Contains、TrimSpace、ToUpper……全部回傳新 string。"
        ),
      },
      {
        topic = "STRCONV",
        q = L(
          'The phone sends the price as text. Parse "18" into an int. Which strconv function?',
          '폰이 가격을 문자로 보낸다. "18"을 int로. strconv의 어떤 함수?',
          '電話將價錢當文字送嚟。將 "18" 變 int。strconv 邊個 function？'
        ),
        code = L(
          [[
import "strconv"
n, err := strconv.___("18")   // 18, nil
s := strconv.Itoa(n)          // back to "18"
]],
          [[
import "strconv"
n, err := strconv.___("18")   // 18, nil
s := strconv.Itoa(n)          // 다시 "18"
]],
          [[
import "strconv"
n, err := strconv.___("18")   // 18, nil
s := strconv.Itoa(n)          // 轉返 "18"
]]
        ),
        answer = "Atoi",
        accept = { "Atoi" },
        hint = L(
          "ASCII to integer. The line below goes the other way.",
          "ASCII를 integer로. 아랫줄은 반대 방향.",
          "ASCII 變 integer。下面嗰行係反方向。"
        ),
        ok = L(
          "strconv.Atoi / Itoa for ints, ParseFloat and FormatFloat for floats.",
          "int는 strconv.Atoi / Itoa, float는 ParseFloat / FormatFloat.",
          "int 用 strconv.Atoi / Itoa，float 用 ParseFloat / FormatFloat。"
        ),
      },
    },
  },
  {
    id = "errs",
    station = "ERRORS",
    name = L("The refund desk", "환불 창구", "退款櫃位"),
    title = L("Errors: New, wrap, Is, As", "에러: New, 감싸기, Is, As", "Error：New、包裝、Is、As"),
    lesson = L(
      "errors.New makes one. %w wraps one. errors.Is and errors.As search the chain.",
      "errors.New로 만든다. fmt.Errorf의 %w로 감싼다. errors.Is와 errors.As가 체인을 따라 찾는다.",
      "errors.New 整一個。fmt.Errorf 用 %w 包住一個。errors.Is 同 errors.As 沿住 chain 搵。"
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
        x = 560,
        facing = -1,
        line = L(
          "A cold coffee came back. The app says 'error' and nothing else.",
          "식은 커피가 돌아왔어. 앱은 'error'라고만 해.",
          "杯凍咖啡退返嚟。App 淨係話 'error'。"
        ),
      },
    },
    viz = "errs",
    story = L(
      "Ticket two: refunds. An error must say what went wrong, keep its cause, "
        .. "and let the caller ask which kind it was. All of that is in package errors.",
      "두 번째 티켓: 환불. 에러는 무엇이 잘못됐는지 말하고, 원인을 지니고, "
        .. "호출자가 어떤 종류인지 물을 수 있어야 한다. 전부 errors 패키지에 있다.",
      "第二張單：退款。Error 要講出邊度錯，保留原因，"
        .. "同埋畀 caller 問係邊一種。呢啲全部喺 errors package。"
    ),
    stages = {
      {
        topic = "NEW",
        q = L(
          "A sentinel error value the whole package can compare against. Fill: errors.___",
          "패키지 전체가 비교할 수 있는 센티널 에러 값. errors.___",
          "成個 package 都可以攞嚟比較嘅 sentinel error。errors.___"
        ),
        code = L(
          [[
import "errors"
var ErrCold = errors.___("coffee is cold")
]],
          [[
import "errors"
var ErrCold = errors.___("coffee is cold")
]],
          [[
import "errors"
var ErrCold = errors.___("coffee is cold")
]]
        ),
        answer = "New",
        accept = { "New" },
        hint = L(
          "Three letters, capital N. Takes the message, returns an error.",
          "세 글자, 대문자 N. 메시지를 받아 error를 돌려준다.",
          "三個字母，大寫 N。攞 message，回傳 error。"
        ),
        ok = L(
          "errors.New for fixed messages; name them ErrSomething at package level.",
          "고정 메시지는 errors.New. 패키지 레벨에서 ErrSomething으로 이름 짓기.",
          "固定 message 用 errors.New；喺 package level 叫做 ErrSomething。"
        ),
      },
      {
        topic = "WRAP",
        q = L(
          "Add the order number but keep the cause inside. Which verb wraps?",
          "주문 번호를 붙이되 원인은 안에 남긴다. 어떤 verb가 감싸나?",
          "加個 order number 但係保留原因。邊個 verb 做包裝？"
        ),
        code = L(
          [[
if err := brew(); err != nil {
    return fmt.Errorf("order %d: ___", id, err)
}
]],
          [[
if err := brew(); err != nil {
    return fmt.Errorf("order %d: ___", id, err)
}
]],
          [[
if err := brew(); err != nil {
    return fmt.Errorf("order %d: ___", id, err)
}
]]
        ),
        answer = "%w",
        accept = { "%w" },
        hint = L(
          "Like %v, but with w for wrap. errors.Unwrap gets the inner error back.",
          "%v와 비슷하지만 wrap의 w. errors.Unwrap으로 안쪽 에러를 꺼낸다.",
          "似 %v，但係 wrap 嘅 w。errors.Unwrap 可以攞返入面嘅 error。"
        ),
        ok = L(
          "%w builds a chain. %v would flatten it to text and lose the cause.",
          "%w는 체인을 만든다. %v는 텍스트로 납작하게 만들어 원인을 잃는다.",
          "%w 砌出一條 chain。%v 會壓成文字，原因就冇咗。"
        ),
      },
      {
        topic = "IS",
        q = L(
          "Is ErrCold anywhere in that chain? Fill: errors.___(err, ErrCold)",
          "체인 어딘가에 ErrCold가 있나? errors.___(err, ErrCold)",
          "條 chain 入面有冇 ErrCold？errors.___(err, ErrCold)"
        ),
        code = L(
          [[
if errors.___(err, ErrCold) {   // walks the chain
    refund(order)
}
]],
          [[
if errors.___(err, ErrCold) {   // 체인을 따라감
    refund(order)
}
]],
          [[
if errors.___(err, ErrCold) {   // 沿住 chain 搵
    refund(order)
}
]]
        ),
        answer = "Is",
        accept = { "Is" },
        hint = L(
          "Two letters. == only checks the outer error; this unwraps.",
          "두 글자. ==는 바깥 에러만 보지만 이건 풀어서 본다.",
          "兩個字母。== 淨係睇最外面；呢個會拆開睇。"
        ),
        ok = L(
          "errors.Is compares values down the chain. Use it instead of ==.",
          "errors.Is는 체인 아래까지 값을 비교한다. == 대신 이걸 쓴다.",
          "errors.Is 沿住 chain 比較值。用佢代替 ==。"
        ),
      },
      {
        topic = "AS",
        q = L(
          "Pull a *RefundError out of the chain to read its fields. Fill: errors.___(err, &re)",
          "체인에서 *RefundError를 꺼내 필드를 읽는다. errors.___(err, &re)",
          "由 chain 入面攞出 *RefundError 睇佢嘅 field。errors.___(err, &re)"
        ),
        code = L(
          [[
var re *RefundError
if errors.___(err, &re) {      // typed match
    pay(re.Amount)
}
]],
          [[
var re *RefundError
if errors.___(err, &re) {      // 타입으로 찾기
    pay(re.Amount)
}
]],
          [[
var re *RefundError
if errors.___(err, &re) {      // 按 type 搵
    pay(re.Amount)
}
]]
        ),
        answer = "As",
        accept = { "As" },
        hint = L(
          "Two letters. Is matches a value; this matches a type and fills the pointer.",
          "두 글자. Is는 값을, 이건 타입을 맞추고 포인터를 채운다.",
          "兩個字母。Is 對值；呢個對 type 而且會填個 pointer。"
        ),
        ok = L(
          "errors.As finds the first error of that type and stores it in re.",
          "errors.As는 그 타입의 첫 에러를 찾아 re에 넣는다.",
          "errors.As 搵到第一個嗰種 type 嘅 error，放入 re。"
        ),
      },
      {
        topic = "ERROR",
        q = L(
          "Any type with one method is an error. Which method?",
          "메서드 하나만 있으면 어떤 타입이든 error. 어떤 메서드?",
          "任何 type 有一個 method 就係 error。邊個 method？"
        ),
        code = L(
          [[
type RefundError struct{ Amount int }

func (e *RefundError) ___() string {
    return "refund " + strconv.Itoa(e.Amount)
}
]],
          [[
type RefundError struct{ Amount int }

func (e *RefundError) ___() string {
    return "refund " + strconv.Itoa(e.Amount)
}
]],
          [[
type RefundError struct{ Amount int }

func (e *RefundError) ___() string {
    return "refund " + strconv.Itoa(e.Amount)
}
]]
        ),
        answer = "Error",
        accept = { "Error" },
        hint = L(
          "Capital E, returns string. That one method is the whole error interface.",
          "대문자 E, string 반환. 그 메서드 하나가 error 인터페이스 전부.",
          "大寫 E，回傳 string。嗰一個 method 就係成個 error interface。"
        ),
        ok = L(
          "error is interface{ Error() string }. Your own types can carry data.",
          "error는 interface{ Error() string }. 직접 만든 타입은 데이터를 담을 수 있다.",
          "error 就係 interface{ Error() string }。自己嘅 type 可以帶埋資料。"
        ),
      },
    },
  },
  {
    id = "types",
    station = "TYPES",
    name = L("The menu board", "메뉴판", "餐牌"),
    title = L(
      "Named types, assertions, type switch",
      "이름 있는 타입, 단언, 타입 switch",
      "命名 type、assertion、type switch"
    ),
    lesson = L(
      "type names a type. v.(T) asserts, switch v.(type) branches. Sprintf formats.",
      "type이 이름 있는 타입을 만든다. v.(T)로 단언. switch v.(type)은 동적 타입으로 분기. Sprintf는 문자열로 포맷.",
      "type 整一個命名 type。v.(T) 做 assertion。switch v.(type) 按動態 type 分支。Sprintf 格式化做 string。"
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
          "The board mixes prices, names and a sold-out flag. What is v today?",
          "메뉴판에 가격, 이름, 품절 표시가 섞여 있어. 오늘 v는 뭐야?",
          "餐牌溝埋價錢、名同售罄。今日 v 係咩？"
        ),
      },
    },
    viz = "types",
    story = L(
      "Ticket three: the menu board takes any. Before the app can print a price it must "
        .. "ask what is inside. Go asks with an assertion or a type switch.",
      "세 번째 티켓: 메뉴판은 any를 받는다. 가격을 출력하기 전에 "
        .. "안에 뭐가 들었는지 물어야 한다. Go는 단언이나 타입 switch로 묻는다.",
      "第三張單：餐牌收 any。印價錢之前"
        .. "要先問入面係咩。Go 用 assertion 或者 type switch 去問。"
    ),
    stages = {
      {
        topic = "NAMED",
        q = L(
          "Floor is a named type over int. Convert the int 3 into a Floor. Fill: f := ___(3)",
          "Floor는 int 기반의 이름 있는 타입. int 3을 Floor로 변환: f := ___(3)",
          "Floor 係 int 之上嘅命名 type。將 int 3 轉做 Floor：f := ___(3)"
        ),
        code = L(
          [[
type Floor int             // new type, underlying int

f := ___(3)                // int -> Floor
]],
          [[
type Floor int             // 새 타입, 기반은 int

f := ___(3)                // int -> Floor
]],
          [[
type Floor int             // 新 type，底層係 int

f := ___(3)                // int -> Floor
]]
        ),
        answer = "Floor",
        accept = { "Floor" },
        hint = L(
          "The type name works as the conversion. Floor and int never mix silently.",
          "타입 이름이 변환 함수. Floor와 int는 조용히 섞이지 않는다.",
          "type 個名就係轉換。Floor 同 int 唔會靜靜雞溝埋。"
        ),
        ok = L(
          "type Floor int is a new type: its own methods, no accidental mixing with int.",
          "type Floor int는 새 타입: 자기 메서드를 갖고 int와 실수로 섞이지 않는다.",
          "type Floor int 係新 type：有自己 method，唔會同 int 撈亂。"
        ),
      },
      {
        topic = "ASSERT",
        q = L(
          "v is an any that holds a string. Take it out: s := v.(___)",
          "v는 string이 든 any. 꺼낸다: s := v.(___)",
          "v 係一個裝住 string 嘅 any。攞出嚟：s := v.(___)"
        ),
        code = L(
          [[
var v any = "muffin"
s := v.(___)              // panics if v is not one
s2, ok := v.(string)      // safe form
]],
          [[
var v any = "muffin"
s := v.(___)              // v가 아니면 panic
s2, ok := v.(string)      // 안전한 형태
]],
          [[
var v any = "muffin"
s := v.(___)              // v 唔係嘅話會 panic
s2, ok := v.(string)      // 安全寫法
]]
        ),
        answer = "string",
        accept = { "string" },
        hint = L(
          "The type name, inside the parentheses. The second line shows the safe two-value form.",
          "괄호 안에 타입 이름. 둘째 줄이 안전한 두 값 형태.",
          "括號入面寫 type 名。第二行係安全嘅兩個值寫法。"
        ),
        ok = L(
          "v.(T) is a type assertion. s, ok := v.(T) never panics.",
          "v.(T)는 타입 단언. s, ok := v.(T)는 절대 panic하지 않는다.",
          "v.(T) 係 type assertion。s, ok := v.(T) 永遠唔會 panic。"
        ),
      },
      {
        topic = "SWITCH",
        q = L(
          "Branch on what v really is. Fill: switch x := v.(___)",
          "v가 실제로 무엇인지로 분기: switch x := v.(___)",
          "按 v 真正係咩去分支：switch x := v.(___)"
        ),
        code = L(
          [[
switch x := v.(___) {
case int:
    fmt.Println(x + 1)      // x is an int here
case string:
    fmt.Println(x + "!")    // and a string here
}
]],
          [[
switch x := v.(___) {
case int:
    fmt.Println(x + 1)      // 여기서 x는 int
case string:
    fmt.Println(x + "!")    // 여기서는 string
}
]],
          [[
switch x := v.(___) {
case int:
    fmt.Println(x + 1)      // 呢度 x 係 int
case string:
    fmt.Println(x + "!")    // 呢度係 string
}
]]
        ),
        answer = "type",
        accept = { "type" },
        hint = L(
          "The keyword type, where a type name would go. Only inside a switch.",
          "타입 이름 자리에 키워드 type. switch 안에서만.",
          "喺 type 名嘅位置寫關鍵字 type。淨係 switch 入面可以。"
        ),
        ok = L(
          "switch v.(type) gives x the concrete type in every case.",
          "switch v.(type)은 각 case에서 x에 구체 타입을 준다.",
          "switch v.(type) 喺每個 case 畀 x 具體嘅 type。"
        ),
      },
      {
        topic = "SPRINTF",
        q = L(
          "Build the label as a string, without printing. Which fmt function?",
          "출력하지 않고 라벨을 문자열로 만든다. fmt의 어떤 함수?",
          "唔印出嚟，只係砌個 label string。fmt 邊個 function？"
        ),
        code = L(
          [[
label := fmt.___("%s $%d", item, price)   // "set $25"
]],
          [[
label := fmt.___("%s $%d", item, price)   // "set $25"
]],
          [[
label := fmt.___("%s $%d", item, price)   // "set $25"
]]
        ),
        answer = "Sprintf",
        accept = { "Sprintf" },
        hint = L(
          "S for string, then printf. Fprintf writes to a writer, Printf to stdout.",
          "string의 S 다음 printf. Fprintf는 writer에, Printf는 stdout에.",
          "S 代表 string，然後 printf。Fprintf 寫去 writer，Printf 寫去 stdout。"
        ),
        ok = L(
          "Sprintf returns the text. %s string, %d int, %v anything.",
          "Sprintf는 텍스트를 반환. %s 문자열, %d 정수, %v 아무거나.",
          "Sprintf 回傳文字。%s string，%d int，%v 咩都得。"
        ),
      },
      {
        topic = "VERB",
        q = L(
          "Print the struct with its field names. Which verb?",
          "구조체를 필드 이름과 함께 출력. 어떤 verb?",
          "印 struct 連 field 名。邊個 verb？"
        ),
        code = L(
          [[
o := Order{Item: "set", Price: 25}
fmt.Printf("___\n", o)    // {Item:set Price:25}
]],
          [[
o := Order{Item: "set", Price: 25}
fmt.Printf("___\n", o)    // {Item:set Price:25}
]],
          [[
o := Order{Item: "set", Price: 25}
fmt.Printf("___\n", o)    // {Item:set Price:25}
]]
        ),
        answer = "%+v",
        accept = { "%+v" },
        hint = L(
          "%v with a plus. %#v adds the type name too; %T prints only the type.",
          "%v에 플러스. %#v는 타입 이름까지, %T는 타입만 출력.",
          "%v 加個 plus。%#v 連 type 名都印；%T 淨係印 type。"
        ),
        ok = L(
          "%v value, %+v with names, %#v as Go syntax, %T the type.",
          "%v 값, %+v 이름 포함, %#v Go 문법, %T 타입.",
          "%v 值，%+v 連名，%#v Go 語法，%T type。"
        ),
      },
    },
  },
  {
    id = "json",
    station = "JSON",
    name = L("The order app", "주문 앱", "落單 App"),
    title = L("Struct tags and encoding/json", "구조체 태그와 encoding/json", "struct tag 同 encoding/json"),
    lesson = L(
      "json sees exported fields only. Tags pick the key. Marshal out, Unmarshal in.",
      "encoding/json은 공개 필드만 본다. 구조체 태그가 키를 정한다. Marshal은 인코딩, Unmarshal은 포인터로 디코딩.",
      "encoding/json 淨係睇 exported field。struct tag 揀 key。Marshal 編碼；Unmarshal 解碼入 pointer。"
    ),
    bg = "bg_queue",
    portrait = "portrait_hero",
    speaker = L("Alex", "알렉스", "阿力"),
    ground = 348,
    spawn = 180,
    width = 1680,
    npcs = {
      {
        kind = "clerk",
        x = 640,
        facing = -1,
        line = L(
          'The phone sends {"dish":"set"}. Our struct says Item. Nothing arrives.',
          '폰은 {"dish":"set"}을 보내. 우리 구조체는 Item. 아무것도 안 와.',
          '電話送 {"dish":"set"}。我哋個 struct 寫 Item。咩都收唔到。'
        ),
      },
    },
    viz = "json",
    story = L(
      "Ticket four: orders arrive as JSON. The decoder only sees exported fields, "
        .. "and a tag on the field tells it which key to read.",
      "네 번째 티켓: 주문이 JSON으로 온다. 디코더는 공개 필드만 보고, "
        .. "필드의 태그가 어떤 키를 읽을지 알려준다.",
      "第四張單：訂單用 JSON 送到。Decoder 淨係睇 exported field，"
        .. "field 上面嘅 tag 話畀佢知讀邊個 key。"
    ),
    stages = {
      {
        topic = "EXPORT",
        q = L(
          "json only sees exported fields. Name the item field: Item or item?",
          "json은 공개 필드만 본다. 아이템 필드 이름은 Item? item?",
          "json 淨係睇 exported field。個 item field 叫 Item 定 item？"
        ),
        code = L(
          [[
type Order struct {
    ___  string           // json needs a capital
    Price int
}
]],
          [[
type Order struct {
    ___  string           // json은 대문자가 필요
    Price int
}
]],
          [[
type Order struct {
    ___  string           // json 要大寫
    Price int
}
]]
        ),
        answer = "Item",
        accept = { "Item" },
        hint = L(
          "Capital first letter. Lower-case fields are invisible outside the package, json included.",
          "첫 글자 대문자. 소문자 필드는 패키지 밖에서 안 보인다, json도 마찬가지.",
          "第一個字母大寫。細楷 field 喺 package 外面睇唔到，json 都係。"
        ),
        ok = L(
          "Unexported fields are skipped silently. Capital letters or nothing.",
          "비공개 필드는 조용히 건너뛴다. 대문자 아니면 아무것도 없다.",
          "冇 export 嘅 field 會靜靜雞跳過。大寫先得。"
        ),
      },
      {
        topic = "TAG",
        q = L(
          "The phone calls the field dish, not Item. Fill the tag so json reads that key.",
          "폰은 필드를 Item이 아니라 dish라고 부른다. json이 그 키를 읽도록 태그를 채워라.",
          "電話將個 field 叫做 dish，唔係 Item。填個 tag 令 json 讀嗰個 key。"
        ),
        code = L(
          [[
type Order struct {
    Item string `json:"___"`
}
]],
          [[
type Order struct {
    Item string `json:"___"`
}
]],
          [[
type Order struct {
    Item string `json:"___"`
}
]]
        ),
        answer = "dish",
        accept = { "dish" },
        hint = L(
          "The key exactly as the phone spells it, inside the quotes.",
          "폰이 쓰는 그대로의 키를 따옴표 안에.",
          "引號入面寫電話用嘅 key，一模一樣。"
        ),
        ok = L(
          "Struct tags are strings after the type. json, xml, db... each package reads its own.",
          "구조체 태그는 타입 뒤의 문자열. json, xml, db... 각 패키지가 자기 것을 읽는다.",
          "struct tag 係 type 後面嘅 string。json、xml、db……各個 package 讀自己嗰份。"
        ),
      },
      {
        topic = "MARSHAL",
        q = L(
          "Turn the Order into JSON bytes. Fill: json.___(order)",
          "Order를 JSON 바이트로: json.___(order)",
          "將 Order 變做 JSON byte：json.___(order)"
        ),
        code = L(
          [[
b, err := json.___(order)   // []byte
fmt.Println(string(b))      // {"dish":"set"}
]],
          [[
b, err := json.___(order)   // []byte
fmt.Println(string(b))      // {"dish":"set"}
]],
          [[
b, err := json.___(order)   // []byte
fmt.Println(string(b))      // {"dish":"set"}
]]
        ),
        answer = "Marshal",
        accept = { "Marshal" },
        hint = L(
          "Capital M. MarshalIndent pretty-prints. The opposite is on the next blank.",
          "대문자 M. MarshalIndent는 보기 좋게. 반대는 다음 빈칸.",
          "大寫 M。MarshalIndent 會排靚啲。相反嗰個喺下一個空格。"
        ),
        ok = L(
          "Marshal returns []byte and an error. Never ignore the error.",
          "Marshal은 []byte와 error를 반환. 에러를 무시하지 말 것.",
          "Marshal 回傳 []byte 同 error。唔好唔理個 error。"
        ),
      },
      {
        topic = "UNMARSHAL",
        q = L(
          "Read JSON bytes into the struct. Fill: json.___(b, &order)",
          "JSON 바이트를 구조체로 읽는다: json.___(b, &order)",
          "將 JSON byte 讀入 struct：json.___(b, &order)"
        ),
        code = L(
          [[
var order Order
err := json.___(b, &order)   // pointer!
]],
          [[
var order Order
err := json.___(b, &order)   // 포인터!
]],
          [[
var order Order
err := json.___(b, &order)   // 要 pointer！
]]
        ),
        answer = "Unmarshal",
        accept = { "Unmarshal" },
        hint = L(
          "Un + Marshal. It needs a pointer so it can fill your variable.",
          "Un + Marshal. 변수를 채워야 해서 포인터가 필요.",
          "Un + Marshal。要 pointer 先可以填你嘅變數。"
        ),
        ok = L(
          "Unmarshal(data, &v). Without & it decodes into a copy and you see nothing.",
          "Unmarshal(data, &v). & 없이는 복사본에 디코딩돼 아무것도 안 보인다.",
          "Unmarshal(data, &v)。冇 & 就會解入一個 copy，你咩都見唔到。"
        ),
      },
      {
        topic = "OMIT",
        q = L(
          "Leave note out of the JSON when it is empty. Fill the tag option.",
          "note가 비어 있으면 JSON에서 뺀다. 태그 옵션을 채워라.",
          "note 空嘅時候唔放入 JSON。填個 tag option。"
        ),
        code = L(
          [[
type Order struct {
    Item string `json:"dish"`
    Note string `json:"note,___"`   // skip when empty
}
]],
          [[
type Order struct {
    Item string `json:"dish"`
    Note string `json:"note,___"`   // 비어 있으면 생략
}
]],
          [[
type Order struct {
    Item string `json:"dish"`
    Note string `json:"note,___"`   // 空就跳過
}
]]
        ),
        answer = "omitempty",
        accept = { "omitempty" },
        hint = L(
          'omit + empty, one word, after the comma. json:"-" hides a field entirely.',
          'omit + empty, 한 단어, 쉼표 뒤. json:"-"는 필드를 아예 숨긴다.',
          'omit + empty，一個字，逗號後面。json:"-" 完全收埋個 field。'
        ),
        ok = L(
          'omitempty drops zero values. "-" drops the field always.',
          'omitempty는 제로 값을 뺀다. "-"는 항상 뺀다.',
          'omitempty 唔要零值。"-" 永遠唔要個 field。'
        ),
      },
    },
  },
  {
    id = "http",
    station = "HTTP",
    name = L("The web counter", "웹 카운터", "網上櫃位"),
    title = L("net/http: handlers and a server", "net/http: 핸들러와 서버", "net/http：handler 同 server"),
    lesson = L(
      "HandleFunc maps a path to func(w, r). Fprintf(w) replies. ListenAndServe runs.",
      "http.HandleFunc은 경로를 func(w ResponseWriter, r *Request)에 연결. Fprintf가 응답을 쓴다. ListenAndServe가 서버를 돌린다.",
      "http.HandleFunc 將 path 對應 func(w ResponseWriter, r *Request)。Fprintf 寫回覆。ListenAndServe 開 server。"
    ),
    bg = "bg_street",
    portrait = "portrait_officer",
    speaker = L("Chef Bo", "보 셰프", "寶廚"),
    ground = 348,
    spawn = 160,
    width = 1680,
    npcs = {
      {
        kind = "cook",
        x = 600,
        facing = -1,
        line = L(
          "Orders come through the web now. Put a handler on /order.",
          "이제 주문은 웹으로 와. /order에 핸들러를 달아.",
          "而家啲單由網上嚟。喺 /order 放個 handler。"
        ),
      },
    },
    viz = "http",
    story = L(
      "Ticket five: the app needs a server. net/http is in the standard library: "
        .. "a handler is a function, a route is a string, the server is one call.",
      "다섯 번째 티켓: 앱에 서버가 필요하다. net/http는 표준 라이브러리에 있다: "
        .. "핸들러는 함수, 라우트는 문자열, 서버는 호출 하나.",
      "第五張單：App 要一個 server。net/http 就喺標準庫入面："
        .. "handler 係一個 function，route 係一個 string，server 係一個 call。"
    ),
    stages = {
      {
        topic = "ROUTE",
        q = L(
          'Serve /order with the function serve. Fill: http.___("/order", serve)',
          '/order를 serve 함수로 처리: http.___("/order", serve)',
          '用 serve 呢個 function 處理 /order：http.___("/order", serve)'
        ),
        code = L(
          [[
import "net/http"

http.___("/order", serve)   // path -> function
]],
          [[
import "net/http"

http.___("/order", serve)   // 경로 -> 함수
]],
          [[
import "net/http"

http.___("/order", serve)   // path -> function
]]
        ),
        answer = "HandleFunc",
        accept = { "HandleFunc" },
        hint = L(
          "Handle + Func. Plain Handle takes an http.Handler value instead.",
          "Handle + Func. 그냥 Handle은 http.Handler 값을 받는다.",
          "Handle + Func。淨係 Handle 嘅話收 http.Handler 值。"
        ),
        ok = L(
          'HandleFunc registers on the default mux. Go 1.22 routes can say "GET /order/{id}".',
          'HandleFunc은 기본 mux에 등록. Go 1.22 라우트는 "GET /order/{id}"도 된다.',
          'HandleFunc 登記喺 default mux。Go 1.22 嘅 route 可以寫 "GET /order/{id}"。'
        ),
      },
      {
        topic = "WRITER",
        q = L(
          "The first handler argument is where the reply goes. Fill its type: w http.___",
          "핸들러 첫 인자는 응답이 나가는 곳. 타입: w http.___",
          "handler 第一個 argument 係回覆去嘅地方。type：w http.___"
        ),
        code = L(
          [[
func serve(w http.___, r *http.Request) {
    w.WriteHeader(200)
}
]],
          [[
func serve(w http.___, r *http.Request) {
    w.WriteHeader(200)
}
]],
          [[
func serve(w http.___, r *http.Request) {
    w.WriteHeader(200)
}
]]
        ),
        answer = "ResponseWriter",
        accept = { "ResponseWriter" },
        hint = L(
          "Response + Writer. An interface, so no star. It is also an io.Writer.",
          "Response + Writer. 인터페이스라 별표 없음. io.Writer이기도 하다.",
          "Response + Writer。係 interface，所以冇星。佢都係 io.Writer。"
        ),
        ok = L(
          "ResponseWriter: headers, status, body. Write the status before the body.",
          "ResponseWriter: 헤더, 상태, 본문. 상태를 본문보다 먼저 쓴다.",
          "ResponseWriter：header、status、body。status 要喺 body 之前寫。"
        ),
      },
      {
        topic = "REQUEST",
        q = L(
          "The second argument holds the URL, method and body. Fill its type: r *http.___",
          "둘째 인자에 URL, 메서드, 본문이 있다. 타입: r *http.___",
          "第二個 argument 有 URL、method 同 body。type：r *http.___"
        ),
        code = L(
          [[
func serve(w http.ResponseWriter, r *http.___) {
    item := r.URL.Query().Get("item")
}
]],
          [[
func serve(w http.ResponseWriter, r *http.___) {
    item := r.URL.Query().Get("item")
}
]],
          [[
func serve(w http.ResponseWriter, r *http.___) {
    item := r.URL.Query().Get("item")
}
]]
        ),
        answer = "Request",
        accept = { "Request" },
        hint = L(
          "A struct, so it comes as a pointer. r.Method, r.URL, r.Body.",
          "구조체라 포인터로 온다. r.Method, r.URL, r.Body.",
          "係 struct，所以用 pointer。r.Method、r.URL、r.Body。"
        ),
        ok = L(
          "*http.Request is everything the client sent. Query().Get reads ?item=.",
          "*http.Request는 클라이언트가 보낸 전부. Query().Get이 ?item=을 읽는다.",
          "*http.Request 係 client 送嚟嘅所有嘢。Query().Get 讀 ?item=。"
        ),
      },
      {
        topic = "FPRINTF",
        q = L(
          "Write the reply into w, not the terminal. Which fmt function?",
          "터미널이 아니라 w에 응답을 쓴다. fmt의 어떤 함수?",
          "將回覆寫入 w，唔係寫去 terminal。fmt 邊個 function？"
        ),
        code = L(
          [[
fmt.___(w, "served %s", item)   // w is an io.Writer
]],
          [[
fmt.___(w, "served %s", item)   // w는 io.Writer
]],
          [[
fmt.___(w, "served %s", item)   // w 係 io.Writer
]]
        ),
        answer = "Fprintf",
        accept = { "Fprintf" },
        hint = L(
          "F for a file or writer, then printf. The writer is the first argument.",
          "파일/writer의 F 다음 printf. writer가 첫 인자.",
          "F 代表 file 或者 writer，然後 printf。writer 係第一個 argument。"
        ),
        ok = L(
          "Fprintf writes to any io.Writer: files, buffers, network, ResponseWriter.",
          "Fprintf는 어떤 io.Writer에도 쓴다: 파일, 버퍼, 네트워크, ResponseWriter.",
          "Fprintf 寫去任何 io.Writer：file、buffer、network、ResponseWriter。"
        ),
      },
      {
        topic = "SERVE",
        q = L(
          'Start the server on port 8080 and block. Fill: http.___(":8080", nil)',
          '8080 포트로 서버를 띄우고 블록: http.___(":8080", nil)',
          '喺 8080 port 開 server 然後 block：http.___(":8080", nil)'
        ),
        code = L(
          [[
log.Fatal(http.___(":8080", nil))   // nil = default mux
]],
          [[
log.Fatal(http.___(":8080", nil))   // nil = 기본 mux
]],
          [[
log.Fatal(http.___(":8080", nil))   // nil = default mux
]]
        ),
        answer = "ListenAndServe",
        accept = { "ListenAndServe" },
        hint = L(
          "Listen, And, Serve. Returns only on error, hence log.Fatal.",
          "Listen, And, Serve. 에러일 때만 반환하니 log.Fatal.",
          "Listen、And、Serve。淨係出錯先會 return，所以用 log.Fatal。"
        ),
        ok = L(
          "ListenAndServe blocks forever. Every request runs in its own goroutine.",
          "ListenAndServe는 계속 블록. 요청마다 고루틴 하나에서 돈다.",
          "ListenAndServe 永遠 block。每個 request 喺自己嘅 goroutine 入面行。"
        ),
      },
    },
  },
  {
    id = "tools",
    station = "TOOLS",
    name = L("The workshop", "작업실", "工場"),
    title = L("Modules and the go tool", "모듈과 go 도구", "module 同 go tool"),
    lesson = L(
      "go mod init, tidy, vet, build: one static binary. //go:embed bundles files.",
      "go mod init이 go.mod를 쓴다. tidy는 의존성 정리. vet은 버그 찾기. build는 바이너리 하나. //go:embed는 파일을 묶는다.",
      "go mod init 寫 go.mod。tidy 整理 dependency。vet 搵 bug。build 出一個 binary。//go:embed 打包檔案。"
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
        x = 560,
        facing = -1,
        line = L(
          "It runs on your laptop. Make it build on the shop's machine.",
          "네 노트북에선 돌아가지. 가게 컴퓨터에서도 빌드되게 해.",
          "喺你部 laptop 行到。整到喺舖頭部機都 build 到。"
        ),
      },
    },
    viz = "tools",
    story = L(
      "Ticket six: ship it. A module names the project, go.mod pins the dependencies, "
        .. "and the go tool formats, checks and builds. No Makefile needed.",
      "여섯 번째 티켓: 배포. 모듈이 프로젝트 이름을 정하고, go.mod가 의존성을 고정하고, "
        .. "go 도구가 포맷하고 검사하고 빌드한다. Makefile은 필요 없다.",
      "第六張單：出貨。module 幫 project 改名，go.mod 釘實 dependency，"
        .. "go tool 負責格式化、檢查同 build。唔使 Makefile。"
    ),
    stages = {
      {
        topic = "MOD",
        q = L(
          "Start a new module for the project. Fill the subcommand: go ___ init",
          "프로젝트의 새 모듈 시작. 서브커맨드: go ___ init",
          "為個 project 開一個新 module。subcommand：go ___ init"
        ),
        code = L(
          [[
$ go ___ init luckymac/delivery
go: creating new go.mod: module luckymac/delivery
]],
          [[
$ go ___ init luckymac/delivery
go: creating new go.mod: module luckymac/delivery
]],
          [[
$ go ___ init luckymac/delivery
go: creating new go.mod: module luckymac/delivery
]]
        ),
        answer = "mod",
        accept = { "mod" },
        hint = L(
          "Three letters, short for module. The same word as in go.mod.",
          "세 글자, module의 줄임. go.mod의 그 단어.",
          "三個字母，module 嘅簡寫。同 go.mod 入面嗰個字一樣。"
        ),
        ok = L(
          "go mod init makes go.mod. The module path is how others import you.",
          "go mod init이 go.mod를 만든다. 모듈 경로가 남들이 import하는 이름.",
          "go mod init 整 go.mod。module path 就係其他人 import 你嘅名。"
        ),
      },
      {
        topic = "GOMOD",
        q = L(
          "The first line of go.mod names the module. Which keyword?",
          "go.mod 첫 줄이 모듈 이름을 정한다. 어떤 키워드?",
          "go.mod 第一行寫 module 名。咩關鍵字？"
        ),
        code = L(
          [[
___ luckymac/delivery

go 1.22

require github.com/lib/pq v1.10.9
]],
          [[
___ luckymac/delivery

go 1.22

require github.com/lib/pq v1.10.9
]],
          [[
___ luckymac/delivery

go 1.22

require github.com/lib/pq v1.10.9
]]
        ),
        answer = "module",
        accept = { "module" },
        hint = L(
          "The full word this time. Then the go version, then require lines.",
          "이번엔 전체 단어. 그 다음 go 버전, 그 다음 require 줄들.",
          "今次寫全個字。然後係 go 版本，再係 require 行。"
        ),
        ok = L(
          "module, go, require. go.sum next to it holds the checksums.",
          "module, go, require. 옆의 go.sum이 체크섬을 담는다.",
          "module、go、require。旁邊嘅 go.sum 放 checksum。"
        ),
      },
      {
        topic = "TIDY",
        q = L(
          "Add missing dependencies and drop unused ones. Fill: go mod ___",
          "빠진 의존성은 추가하고 안 쓰는 건 제거: go mod ___",
          "加返漏咗嘅 dependency，刪走冇用嘅：go mod ___"
        ),
        code = L(
          [[
$ go mod ___    # sync go.mod with the imports
]],
          [[
$ go mod ___    # go.mod를 import와 맞춤
]],
          [[
$ go mod ___    # 將 go.mod 同 import 對齊
]]
        ),
        answer = "tidy",
        accept = { "tidy" },
        hint = L(
          "Four letters: make it neat. Run it before every commit.",
          "네 글자: 깔끔하게. 커밋 전마다 실행.",
          "四個字母：執整齊。每次 commit 之前行一次。"
        ),
        ok = L(
          "go mod tidy is the only dependency command most projects need.",
          "대부분의 프로젝트에 필요한 의존성 명령은 go mod tidy뿐.",
          "大部分 project 淨係需要 go mod tidy 呢個 dependency 指令。"
        ),
      },
      {
        topic = "VET",
        q = L(
          "Find suspicious code the compiler allows: wrong Printf verbs, copied locks. Fill: go ___ ./...",
          "컴파일러가 허용하는 수상한 코드 찾기: 잘못된 Printf verb, 복사된 락. go ___ ./...",
          "搵 compiler 放行但可疑嘅 code：錯嘅 Printf verb、copy 咗嘅 lock。go ___ ./..."
        ),
        code = L(
          [[
$ go ___ ./...    # static checks, no run
$ go fmt ./...    # and gofmt every file
]],
          [[
$ go ___ ./...    # 정적 검사, 실행 안 함
$ go fmt ./...    # 그리고 모든 파일 gofmt
]],
          [[
$ go ___ ./...    # 靜態檢查，唔會行
$ go fmt ./...    # 仲有每個檔案都 gofmt
]]
        ),
        answer = "vet",
        accept = { "vet" },
        hint = L(
          "Three letters: to examine. ./... means this package and everything under it.",
          "세 글자: 검사하다. ./...는 이 패키지와 그 아래 전부.",
          "三個字母：檢查。./... 即係呢個 package 同下面所有嘢。"
        ),
        ok = L(
          "go vet and go fmt run in CI on every Go project. staticcheck goes further.",
          "go vet과 go fmt는 모든 Go 프로젝트의 CI에서 돈다. staticcheck은 더 깊이.",
          "go vet 同 go fmt 每個 Go project 嘅 CI 都會行。staticcheck 更深入。"
        ),
      },
      {
        topic = "BUILD",
        q = L(
          "Compile everything into one binary called delivery. Fill: go ___ -o delivery .",
          "전부 컴파일해 delivery라는 바이너리 하나로: go ___ -o delivery .",
          "全部 compile 做一個叫 delivery 嘅 binary：go ___ -o delivery ."
        ),
        code = L(
          [[
$ go ___ -o delivery .    # one static file
$ ./delivery
]],
          [[
$ go ___ -o delivery .    # 정적 파일 하나
$ ./delivery
]],
          [[
$ go ___ -o delivery .    # 一個 static 檔案
$ ./delivery
]]
        ),
        answer = "build",
        accept = { "build" },
        hint = L(
          "Five letters. go run compiles and runs; this one only compiles.",
          "다섯 글자. go run은 컴파일하고 실행; 이건 컴파일만.",
          "五個字母。go run 係 compile 加行；呢個淨係 compile。"
        ),
        ok = L(
          "go build makes a single binary with no runtime to install. GOOS=linux cross-compiles.",
          "go build는 런타임 설치가 필요 없는 바이너리 하나를 만든다. GOOS=linux로 크로스 컴파일.",
          "go build 出一個唔使裝 runtime 嘅 binary。GOOS=linux 可以 cross-compile。"
        ),
      },
      {
        topic = "EMBED",
        q = L(
          "Bake menu.json into the binary at compile time. Fill the directive: //go:___",
          "menu.json을 컴파일 시점에 바이너리에 넣는다. 지시어: //go:___",
          "compile 嘅時候將 menu.json 焗入 binary。directive：//go:___"
        ),
        code = L(
          [[
import _ "embed"

//go:___ menu.json
var menu []byte
]],
          [[
import _ "embed"

//go:___ menu.json
var menu []byte
]],
          [[
import _ "embed"

//go:___ menu.json
var menu []byte
]]
        ),
        answer = "embed",
        accept = { "embed" },
        hint = L(
          "The same word as the blank import above. Go 1.16.",
          "위의 빈 import와 같은 단어. Go 1.16.",
          "同上面嗰個 blank import 一樣嘅字。Go 1.16。"
        ),
        ok = L(
          "//go:embed puts files in the binary: string, []byte or embed.FS.",
          "//go:embed는 파일을 바이너리에 넣는다: string, []byte, embed.FS.",
          "//go:embed 將檔案放入 binary：string、[]byte 或者 embed.FS。"
        ),
      },
    },
  },
  {
    id = "modern",
    station = "MODERN",
    name = L("The rooftop", "옥상", "天台"),
    title = L(
      "Go 1.21-1.23: slices, maps, min, iterators",
      "Go 1.21-1.23: slices, maps, min, 이터레이터",
      "Go 1.21-1.23：slices、maps、min、iterator"
    ),
    lesson = L(
      "range over an int, min and max, slices and maps packages, iter.Seq for range.",
      "int에 range, min/max 내장, slices와 maps 패키지, 직접 만드는 range 루프용 iter.Seq.",
      "range 一個 int、min 同 max 內置、slices 同 maps package，仲有自己寫 range loop 用嘅 iter.Seq。"
    ),
    bg = "bg_set",
    portrait = "portrait_friends",
    speaker = L("Mei", "메이", "阿美"),
    ground = 348,
    spawn = 200,
    width = 1680,
    npcs = {
      {
        kind = "mei",
        x = 520,
        facing = -1,
        line = L(
          "Shipped. One more: the code still sorts by hand.",
          "배포 완료. 하나 더: 코드가 아직 손으로 정렬해.",
          "出咗貨。仲有一樣：段 code 仲係人手排序。"
        ),
      },
      {
        kind = "cook",
        x = 960,
        facing = -1,
        line = L(
          "Newer Go has helpers for that. Lunch is on the house.",
          "새 Go에는 그걸 위한 도우미가 있어. 점심은 내가 쏜다.",
          "新啲嘅 Go 有現成嘅 helper。午餐我請。"
        ),
      },
    },
    viz = "modern",
    story = L(
      "Ticket seven, the rooftop. The app is live. Newer Go has generic helpers so the "
        .. "old hand-written loops can go: slices, maps, min, and iterators you can range over.",
      "일곱 번째 티켓, 옥상. 앱이 돌아간다. 새 Go에는 제네릭 도우미가 있어 "
        .. "손으로 짠 옛 루프를 치울 수 있다: slices, maps, min, 그리고 range할 수 있는 이터레이터.",
      "第七張單，天台。App 上線咗。新啲嘅 Go 有 generic helper，"
        .. "舊嘅手寫 loop 可以走人：slices、maps、min，仲有可以 range 嘅 iterator。"
    ),
    stages = {
      {
        topic = "RANGE",
        q = L(
          "Go 1.22 loops over a plain number. Fill: for i := ___ 3",
          "Go 1.22는 숫자 자체를 순회한다: for i := ___ 3",
          "Go 1.22 可以直接 loop 一個數字：for i := ___ 3"
        ),
        code = L(
          [[
for i := ___ 3 {        // 0, 1, 2
    fmt.Println(i)
}
]],
          [[
for i := ___ 3 {        // 0, 1, 2
    fmt.Println(i)
}
]],
          [[
for i := ___ 3 {        // 0, 1, 2
    fmt.Println(i)
}
]]
        ),
        answer = "range",
        accept = { "range" },
        hint = L(
          "The same keyword as for slices, now on an int. No i := 0; i < 3; i++.",
          "슬라이스에 쓰던 그 키워드를 int에. i := 0; i < 3; i++가 필요 없다.",
          "同 slice 用嗰個關鍵字，而家用喺 int 上面。唔使 i := 0; i < 3; i++。"
        ),
        ok = L(
          "range 3 counts 0..2. Since 1.22 each iteration also gets its own i.",
          "range 3은 0..2. 1.22부터 반복마다 i가 새로 만들어진다.",
          "range 3 數 0..2。由 1.22 開始每次 iteration 都有自己嘅 i。"
        ),
      },
      {
        topic = "MIN",
        q = L(
          "The cheapest of three prices, no loop, no import. Which built-in (Go 1.21)?",
          "세 가격 중 최저, 루프도 import도 없이. 어떤 내장 함수 (Go 1.21)?",
          "三個價錢入面最平嗰個，唔使 loop 唔使 import。邊個內置 function（Go 1.21）？"
        ),
        code = L(
          [[
cheapest := ___(muffin, hash, coffee)   // built-in
]],
          [[
cheapest := ___(muffin, hash, coffee)   // 내장
]],
          [[
cheapest := ___(muffin, hash, coffee)   // 內置
]]
        ),
        answer = "min",
        accept = { "min" },
        hint = L(
          "Three letters. max is its twin. Both take any number of ordered values.",
          "세 글자. max가 쌍둥이. 둘 다 정렬 가능한 값을 몇 개든 받는다.",
          "三個字母。max 係佢孖生。兩個都收任意數量嘅可排序值。"
        ),
        ok = L(
          "min, max and clear joined len, cap, append in Go 1.21.",
          "Go 1.21에서 min, max, clear가 len, cap, append 옆에 들어왔다.",
          "Go 1.21 加咗 min、max 同 clear，同 len、cap、append 一齊。"
        ),
      },
      {
        topic = "SORT",
        q = L(
          "Sort the names in place. Fill: slices.___(names)",
          "이름을 제자리에서 정렬: slices.___(names)",
          "就地排序啲名：slices.___(names)"
        ),
        code = L(
          [[
import "slices"

slices.___(names)          // in place, any ordered type
]],
          [[
import "slices"

slices.___(names)          // 제자리에서, 정렬 가능한 아무 타입
]],
          [[
import "slices"

slices.___(names)          // 就地，任何可排序 type
]]
        ),
        answer = "Sort",
        accept = { "Sort" },
        hint = L(
          "Four letters, capital S. SortFunc takes a compare function.",
          "네 글자, 대문자 S. SortFunc는 비교 함수를 받는다.",
          "四個字母，大寫 S。SortFunc 收一個比較 function。"
        ),
        ok = L(
          "slices.Sort is generic: no sort.Strings / sort.Ints per type any more.",
          "slices.Sort는 제네릭: 타입마다 sort.Strings / sort.Ints가 필요 없다.",
          "slices.Sort 係 generic：唔使再每個 type 一個 sort.Strings / sort.Ints。"
        ),
      },
      {
        topic = "CONTAINS",
        q = L(
          'Is muffin on the list? Fill: slices.___(names, "muffin")',
          '머핀이 목록에 있나? slices.___(names, "muffin")',
          '個 list 有冇鬆餅？slices.___(names, "muffin")'
        ),
        code = L(
          [[
if slices.___(names, "muffin") {
    serve("muffin")
}
]],
          [[
if slices.___(names, "muffin") {
    serve("muffin")
}
]],
          [[
if slices.___(names, "muffin") {
    serve("muffin")
}
]]
        ),
        answer = "Contains",
        accept = { "Contains" },
        hint = L(
          "Same name as strings.Contains. Index returns the position or -1.",
          "strings.Contains와 같은 이름. Index는 위치 아니면 -1.",
          "同 strings.Contains 一樣嘅名。Index 回傳位置或者 -1。"
        ),
        ok = L(
          "slices.Contains, Index, Reverse, Max: the loops you used to write by hand.",
          "slices.Contains, Index, Reverse, Max: 예전에 손으로 쓰던 루프들.",
          "slices.Contains、Index、Reverse、Max：以前你手寫嘅 loop。"
        ),
      },
      {
        topic = "KEYS",
        q = L(
          "Every key of the price map, as an iterator (Go 1.23). Fill: maps.___(prices)",
          "가격 맵의 모든 키를 이터레이터로 (Go 1.23): maps.___(prices)",
          "價錢 map 嘅所有 key，做 iterator（Go 1.23）：maps.___(prices)"
        ),
        code = L(
          [[
import "maps"

for k := range maps.___(prices) {   // iterator
    fmt.Println(k)
}
]],
          [[
import "maps"

for k := range maps.___(prices) {   // 이터레이터
    fmt.Println(k)
}
]],
          [[
import "maps"

for k := range maps.___(prices) {   // iterator
    fmt.Println(k)
}
]]
        ),
        answer = "Keys",
        accept = { "Keys" },
        hint = L(
          "Four letters, capital K. slices.Sorted(maps.Keys(m)) gives a sorted slice.",
          "네 글자, 대문자 K. slices.Sorted(maps.Keys(m))이 정렬된 슬라이스를 준다.",
          "四個字母，大寫 K。slices.Sorted(maps.Keys(m)) 畀你一個排好序嘅 slice。"
        ),
        ok = L(
          "maps.Keys and maps.Values return iter.Seq, so range works on them directly.",
          "maps.Keys와 maps.Values는 iter.Seq를 반환해 바로 range할 수 있다.",
          "maps.Keys 同 maps.Values 回傳 iter.Seq，所以可以直接 range。"
        ),
      },
      {
        topic = "ITER",
        q = L(
          "Make the menu rangeable. Fill the return type: iter.___[string]",
          "메뉴를 range 가능하게. 반환 타입: iter.___[string]",
          "整到個 menu 可以 range。return type：iter.___[string]"
        ),
        code = L(
          [[
func Items() iter.___[string] {     // Go 1.23
    return func(yield func(string) bool) {
        for _, it := range menu {
            if !yield(it) { return }
        }
    }
}
]],
          [[
func Items() iter.___[string] {     // Go 1.23
    return func(yield func(string) bool) {
        for _, it := range menu {
            if !yield(it) { return }
        }
    }
}
]],
          [[
func Items() iter.___[string] {     // Go 1.23
    return func(yield func(string) bool) {
        for _, it := range menu {
            if !yield(it) { return }
        }
    }
}
]]
        ),
        answer = "Seq",
        accept = { "Seq" },
        hint = L(
          "Three letters, short for sequence. Seq2 yields pairs, like index and value.",
          "세 글자, sequence의 줄임. Seq2는 인덱스와 값처럼 쌍을 낸다.",
          "三個字母，sequence 嘅簡寫。Seq2 出一對，好似 index 同 value。"
        ),
        ok = L(
          "iter.Seq[T] is func(yield func(T) bool). for x := range Items() just works.",
          "iter.Seq[T]는 func(yield func(T) bool). for x := range Items()가 그냥 된다.",
          "iter.Seq[T] 即係 func(yield func(T) bool)。for x := range Items() 直接得。"
        ),
      },
    },
  },
}

return maps
