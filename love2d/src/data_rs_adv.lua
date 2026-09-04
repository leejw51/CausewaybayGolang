-- Rust quest 2 ADVANCED: the kitchen of Lucky Mac Express, 16:00.
-- Result, traits, generics, lifetimes, threads, channels, Arc/Mutex.
-- Prize: the afternoon tea set (milk tea + pineapple bun).
-- Each stage is a real quiz: the blank ___ is NOT written in the code.

local function L(en, ko, yue)
  return { en = en, ko = ko, yue = yue }
end

local maps = {
  {
    id = "rs_result",
    station = "RESULT",
    name = L("The till", "계산대", "收銀"),
    title = L("Result and the ? operator", "Result와 ? 연산자", "Result 同 ? 運算子"),
    lesson = L(
      "A call that can fail returns Result. Handle Err, or pass it up with ?.",
      "실패할 수 있는 호출은 Result를 반환한다. Err를 처리하거나 ?로 위로 넘긴다.",
      "可能失敗嘅呼叫回傳 Result。處理 Err，或者用 ? 交上去。"
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
        facing = -1,
        line = L(
          "The till says Err and then just stops. Mei, does Rust not have nil?",
          "계산대가 Err라고 하고 멈춰. 메이, Rust엔 nil이 없어?",
          "收銀話 Err 就停咗。阿美，Rust 冇 nil 咩？"
        ),
      },
      {
        kind = "mei",
        x = 700,
        facing = -1,
        line = L(
          "No nil. Every failure is a value you must look at.",
          "nil 없어. 모든 실패는 반드시 봐야 하는 값이야.",
          "冇 nil。每個失敗都係一個你一定要睇嘅值。"
        ),
      },
    },
    viz = "rust",
    chips = {
      { "Result<u32, String>", "cyan" },
      { "s.parse()?", "gold" },
      { ".unwrap_or(0)", "green" },
      { '.ok_or("msg")', "pink" },
    },
    note = "Result  Ok  Err  ?  unwrap_or  ok_or  expect",
    story = L(
      "16:00. Lucky Mac Express, Times Square. The till took a coin it could not parse "
        .. "and froze on a red Err. Siu Ming has a queue; Alex has to learn how Rust hands errors back.",
      "16:00. 타임스퀘어 럭키 맥 익스프레스. 계산대가 파싱 못 하는 동전을 받고 빨간 Err에 멈췄다. "
        .. "시우밍 앞엔 줄이 있고, 알렉스는 Rust가 에러를 돌려주는 법을 배워야 한다.",
      "下晝四點。時代廣場幸運麥 Express。收銀收到一個 parse 唔到嘅硬幣，卡喺紅色 Err。"
        .. "小明前面排住隊，阿力要學 Rust 點樣交返 error。"
    ),
    stages = {
      {
        topic = "RESULT",
        q = L(
          "A function that can fail returns which type?",
          "실패할 수 있는 함수는 어떤 타입을 반환하나요?",
          "可能失敗嘅 function 回傳邊個 type？"
        ),
        code = L(
          [[
// The till gives change back, or a message.
fn pay(cash: u32, price: u32) -> ___<u32, String> {
    if cash < price {
        return Err("not enough cash".to_string());
    }
    Ok(cash - price)
}
]],
          [[
// 거스름돈 아니면 메시지를 돌려준다.
fn pay(cash: u32, price: u32) -> ___<u32, String> {
    if cash < price {
        return Err("not enough cash".to_string());
    }
    Ok(cash - price)
}
]],
          [[
// 退返零錢，或者一句訊息。
fn pay(cash: u32, price: u32) -> ___<u32, String> {
    if cash < price {
        return Err("not enough cash".to_string());
    }
    Ok(cash - price)
}
]]
        ),
        accept = { "Result" },
        answer = "Result",
        hint = L(
          "Six letters. Two arms: Ok(T) and Err(E).",
          "여섯 글자. 두 갈래: Ok(T)와 Err(E).",
          "六個字母。兩邊：Ok(T) 同 Err(E)。"
        ),
        ok = L(
          "Result<T, E> is either Ok(value) or Err(error). The compiler makes you check. The till lights up.",
          "Result<T, E>는 Ok(값) 아니면 Err(에러). 컴파일러가 확인을 강제한다. 계산대에 불이 켜진다.",
          "Result<T, E> 係 Ok(值) 或者 Err(錯誤)。compiler 逼你檢查。收銀亮燈。"
        ),
      },
      {
        topic = "IF LET",
        q = L(
          "pop returns an Option. Which arm holds a value?",
          "pop은 Option을 반환한다. 값이 들어 있는 쪽은?",
          "pop 回傳 Option。有值嗰邊係邊個？"
        ),
        code = L(
          [[
let mut tray = vec![7, 8];
// pop returns an Option: a value, or None if empty.
if let ___(id) = tray.pop() {
    println!("serving order {id}");
}
]],
          [[
let mut tray = vec![7, 8];
// pop은 Option: 값, 비었으면 None.
if let ___(id) = tray.pop() {
    println!("serving order {id}");
}
]],
          [[
let mut tray = vec![7, 8];
// pop 回傳 Option：有值，空咗就 None。
if let ___(id) = tray.pop() {
    println!("serving order {id}");
}
]]
        ),
        accept = { "Some" },
        answer = "Some",
        hint = L(
          "Four letters. The opposite of None.",
          "네 글자. None의 반대.",
          "四個字母。None 嘅相反。"
        ),
        ok = L(
          "if let Some(id) = ... runs only when there is a value. No unwrap, no panic. Order 8 goes out.",
          "if let Some(id) = ...는 값이 있을 때만 실행. unwrap도 panic도 없다. 8번 주문이 나간다.",
          "if let Some(id) = ... 有值先行。冇 unwrap，冇 panic。8 號單出咗去。"
        ),
      },
      {
        topic = "UNWRAP_OR",
        q = L(
          "The parse fails. Which method gives a fallback value instead of a panic?",
          "파싱이 실패한다. panic 대신 대체 값을 주는 메서드는?",
          "parse 失敗。邊個 method 俾一個後備值，唔係 panic？"
        ),
        code = L(
          [[
// "abc" is not a number: fall back to zero coins.
let coins: u32 = "abc".parse().___(0);
]],
          [[
// "abc"는 숫자가 아님: 동전 0개로 대체.
let coins: u32 = "abc".parse().___(0);
]],
          [[
// "abc" 唔係數字：退返用 0 個硬幣。
let coins: u32 = "abc".parse().___(0);
]]
        ),
        accept = { "unwrap_or" },
        answer = "unwrap_or",
        hint = L(
          "unwrap, then an underscore, then a two-letter word.",
          "unwrap, 밑줄, 그리고 두 글자 단어.",
          "unwrap，然後底線，然後一個兩個字母嘅字。"
        ),
        ok = L(
          "unwrap_or(default) returns the Ok value or your default. Sibling: unwrap_or_else(|e| ...). Zero coins, but no crash.",
          "unwrap_or(기본값)은 Ok 값 아니면 기본값을 반환. 형제: unwrap_or_else(|e| ...). 동전 0개지만 멈추진 않는다.",
          "unwrap_or(預設值) 回傳 Ok 嘅值或者你嘅預設值。兄弟：unwrap_or_else(|e| ...)。0 個硬幣，但冇死機。"
        ),
      },
      {
        topic = "TRY",
        q = L(
          "One character passes the error straight back to the caller. Which?",
          "한 글자로 에러를 호출자에게 바로 넘긴다. 무엇?",
          "一個字元就將 error 直接交返俾 caller。係邊個？"
        ),
        code = L(
          [[
use std::num::ParseIntError;
// Hand any parse error straight back to the caller.
fn cents(s: &str) -> Result<u32, ParseIntError> {
    let n: u32 = s.parse()___;
    Ok(n * 100)
}
]],
          [[
use std::num::ParseIntError;
// 파싱 에러는 그대로 호출자에게 돌려준다.
fn cents(s: &str) -> Result<u32, ParseIntError> {
    let n: u32 = s.parse()___;
    Ok(n * 100)
}
]],
          [[
use std::num::ParseIntError;
// parse 有 error 就直接交返俾 caller。
fn cents(s: &str) -> Result<u32, ParseIntError> {
    let n: u32 = s.parse()___;
    Ok(n * 100)
}
]]
        ),
        accept = { "?" },
        answer = "?",
        hint = L(
          "The same mark that ends a question.",
          "질문을 끝내는 그 기호.",
          "問問題尾嗰個符號。"
        ),
        ok = L(
          "? unwraps Ok, or returns Err early from the function. Only works where the return type is Result or Option.",
          "?는 Ok를 풀거나 함수에서 Err를 일찍 반환한다. 반환 타입이 Result나 Option일 때만 된다.",
          "? 打開 Ok，或者即刻由 function return Err。只有回傳 type 係 Result 或 Option 先用得。"
        ),
      },
      {
        topic = "OK_OR",
        q = L(
          "Turn an Option into a Result, with this message as the Err. Which method?",
          "Option을 Result로 바꾸고 이 메시지를 Err로. 메서드는?",
          "將 Option 變 Result，用呢句做 Err。邊個 method？"
        ),
        code = L(
          [[
// position gives an Option; the till wants a Result.
fn find(menu: &[&str], w: &str) -> Result<usize, String> {
    menu.iter()
        .position(|m| *m == w)
        .___("not on the menu".to_string())
}
]],
          [[
// position은 Option; 계산대는 Result를 원한다.
fn find(menu: &[&str], w: &str) -> Result<usize, String> {
    menu.iter()
        .position(|m| *m == w)
        .___("not on the menu".to_string())
}
]],
          [[
// position 俾 Option；收銀想要 Result。
fn find(menu: &[&str], w: &str) -> Result<usize, String> {
    menu.iter()
        .position(|m| *m == w)
        .___("not on the menu".to_string())
}
]]
        ),
        accept = { "ok_or" },
        answer = "ok_or",
        hint = L(
          "ok, an underscore, then the word you use to offer an alternative.",
          "ok, 밑줄, 그리고 대안을 제시할 때 쓰는 단어.",
          "ok，底線，然後係「或者」嗰個英文字。"
        ),
        ok = L(
          "ok_or(err) maps Some(v) to Ok(v) and None to Err(err). Now ? works on it too.",
          "ok_or(err)는 Some(v)를 Ok(v)로, None을 Err(err)로. 이제 ?도 쓸 수 있다.",
          "ok_or(err) 將 Some(v) 變 Ok(v)，None 變 Err(err)。而家 ? 都用得。"
        ),
      },
      {
        topic = "EXPECT",
        q = L(
          "Like unwrap, but with your own panic message. Which method?",
          "unwrap 같지만 직접 쓴 panic 메시지가 붙는다. 메서드는?",
          "似 unwrap，但係帶自己寫嘅 panic 訊息。邊個 method？"
        ),
        code = L(
          [[
use std::fs;
// A missing menu file is a bug: stop with a message.
let menu = fs::read_to_string("menu.txt")
    .___("menu.txt must exist");
]],
          [[
use std::fs;
// 메뉴 파일 없음은 버그: 메시지와 멈춘다.
let menu = fs::read_to_string("menu.txt")
    .___("menu.txt must exist");
]],
          [[
use std::fs;
// 冇 menu 檔就係 bug：帶訊息停低。
let menu = fs::read_to_string("menu.txt")
    .___("menu.txt must exist");
]]
        ),
        accept = { "expect" },
        answer = "expect",
        hint = L(
          "Six letters. What you do when you are sure it is there.",
          "여섯 글자. 분명히 있다고 확신할 때 하는 것.",
          "六個字母。你好肯定佢一定喺度嗰陣做嘅事。"
        ),
        ok = L(
          "expect(msg) panics with msg on Err. Use it for real bugs, not for user input. The till is back; Siu Ming exhales.",
          "expect(msg)는 Err일 때 msg와 함께 panic. 진짜 버그에만, 사용자 입력엔 쓰지 말 것. 계산대가 돌아왔다; 시우밍이 숨을 내쉰다.",
          "expect(msg) 遇到 Err 就帶 msg panic。真 bug 先用，用戶輸入唔好用。收銀返嚟咗；小明鬆一口氣。"
        ),
      },
    },
  },

  {
    id = "rs_trait",
    station = "TRAIT",
    name = L("The kitchen", "주방", "廚房"),
    title = L("Traits", "트레이트", "trait"),
    lesson = L(
      "A trait is a set of methods. impl Trait for Type promises them; dyn Trait picks at run time.",
      "트레이트는 메서드 묶음. impl Trait for Type이 약속하고, dyn Trait은 실행 중에 고른다.",
      "trait 係一堆 method。impl Trait for Type 承諾做到；dyn Trait 喺 run time 揀。"
    ),
    bg = "bg_kitchen",
    portrait = "portrait_officer",
    speaker = L("Chef Bo", "보 셰프", "波師傅"),
    ground = 348,
    spawn = 180,
    width = 1600,
    npcs = {
      {
        kind = "cook",
        x = 520,
        facing = 1,
        line = L(
          "Grill, wok, steamer. Every station must answer name() and greet().",
          "그릴, 웍, 찜기. 모든 스테이션은 name()과 greet()에 답해야 해.",
          "燒烤、鑊、蒸籠。每個崗位都要答到 name() 同 greet()。"
        ),
      },
      {
        kind = "mei",
        x = 760,
        facing = -1,
        line = L(
          "That is a trait. Go had interfaces; Rust makes you say impl.",
          "그게 트레이트야. Go엔 인터페이스가 있었지; Rust는 impl을 쓰라고 해.",
          "呢個就係 trait。Go 有 interface；Rust 要你寫 impl。"
        ),
      },
    },
    viz = "rust",
    chips = {
      { "trait Cook {}", "cyan" },
      { "impl Cook for Grill", "gold" },
      { "&dyn Cook", "pink" },
      { "#[derive(Clone)]", "green" },
    },
    note = "trait  impl for  dyn  derive  Display  Default",
    story = L(
      "16:10. The Express kitchen. Chef Bo's pass runs every station through one Rust program, "
        .. "but the grill and the wok speak different types and the order board shows nothing. "
        .. "A trait gives them one shared voice.",
      "16:10. 익스프레스 주방. 보 셰프의 패스는 모든 스테이션을 하나의 Rust 프로그램으로 돌리는데, "
        .. "그릴과 웍은 타입이 달라 주문판에 아무것도 안 뜬다. 트레이트가 하나의 공통 목소리를 준다.",
      "下晝四點十分。Express 廚房。波師傅嘅出餐台用一個 Rust 程式管全部崗位，"
        .. "但係燒烤同鑊係唔同 type，單板咩都冇顯示。trait 俾佢哋一個共同嘅聲音。"
    ),
    stages = {
      {
        topic = "TRAIT",
        q = L(
          "Which keyword declares a set of methods that types can promise?",
          "타입이 약속할 수 있는 메서드 묶음을 선언하는 키워드는?",
          "邊個 keyword 宣告一堆俾 type 承諾嘅 method？"
        ),
        code = L(
          [[
// Any cook must give a name; greet comes for free.
___ Cook {
    fn name(&self) -> String;
    fn greet(&self) -> String {
        format!("{} at the pass", self.name())
    }
}
]],
          [[
// 요리사는 name을 줘야 한다; greet은 공짜.
___ Cook {
    fn name(&self) -> String;
    fn greet(&self) -> String {
        format!("{} at the pass", self.name())
    }
}
]],
          [[
// 每個 cook 都要俾 name；greet 免費送。
___ Cook {
    fn name(&self) -> String;
    fn greet(&self) -> String {
        format!("{} at the pass", self.name())
    }
}
]]
        ),
        accept = { "trait" },
        answer = "trait",
        hint = L(
          "Five letters. Go called it an interface.",
          "다섯 글자. Go에선 인터페이스라고 했다.",
          "五個字母。Go 叫佢 interface。"
        ),
        ok = L(
          "trait Cook lists methods. One with a body is a default; implementors may keep it or override it.",
          "trait Cook은 메서드를 나열. 본문이 있는 건 기본 구현; 구현체는 그대로 쓰거나 덮어쓸 수 있다.",
          "trait Cook 列出 method。有 body 嗰個係預設；實作可以照用或者覆寫。"
        ),
      },
      {
        topic = "IMPL FOR",
        q = L(
          "Grill promises to be a Cook. Complete the header.",
          "Grill이 Cook임을 약속한다. 헤더를 완성하세요.",
          "Grill 承諾做 Cook。完成個 header。"
        ),
        code = L(
          [[
struct Grill;
// Grill promises every method of Cook.
impl Cook ___ Grill {
    fn name(&self) -> String {
        "grill".to_string()
    }
}
]],
          [[
struct Grill;
// Grill은 Cook의 모든 메서드를 약속한다.
impl Cook ___ Grill {
    fn name(&self) -> String {
        "grill".to_string()
    }
}
]],
          [[
struct Grill;
// Grill 承諾 Cook 嘅每個 method。
impl Cook ___ Grill {
    fn name(&self) -> String {
        "grill".to_string()
    }
}
]]
        ),
        accept = { "for" },
        answer = "for",
        hint = L(
          "Three letters. impl Trait ___ Type.",
          "세 글자. impl Trait ___ Type.",
          "三個字母。impl Trait ___ Type。"
        ),
        ok = L(
          "impl Cook for Grill. Rust is explicit: no implicit interfaces like Go. The grill station lights up.",
          "impl Cook for Grill. Rust는 명시적: Go 같은 암묵적 인터페이스가 없다. 그릴 스테이션에 불이 켜진다.",
          "impl Cook for Grill。Rust 好明確：冇 Go 嗰種隱含 interface。燒烤崗位亮燈。"
        ),
      },
      {
        topic = "DYN",
        q = L(
          "Any Cook, chosen at run time, behind a reference. Which keyword?",
          "실행 중에 정해지는 임의의 Cook을 참조로. 키워드는?",
          "run time 先決定係邊個 Cook，用 reference 指住。邊個 keyword？"
        ),
        code = L(
          [[
struct Wok;
impl Cook for Wok {
    fn name(&self) -> String { "wok".to_string() }
}
// Any Cook, decided at run time, behind a reference.
fn call(c: &___ Cook) { println!("{}", c.greet()); }
call(&Grill); call(&Wok);
]],
          [[
struct Wok;
impl Cook for Wok {
    fn name(&self) -> String { "wok".to_string() }
}
// 실행 중에 정해지는 Cook, 참조 뒤에.
fn call(c: &___ Cook) { println!("{}", c.greet()); }
call(&Grill); call(&Wok);
]],
          [[
struct Wok;
impl Cook for Wok {
    fn name(&self) -> String { "wok".to_string() }
}
// 任何 Cook，run time 決定，喺 reference 後面。
fn call(c: &___ Cook) { println!("{}", c.greet()); }
call(&Grill); call(&Wok);
]]
        ),
        accept = { "dyn" },
        answer = "dyn",
        hint = L(
          "Three letters, short for dynamic.",
          "세 글자, dynamic의 줄임말.",
          "三個字母，dynamic 嘅縮寫。"
        ),
        ok = L(
          "&dyn Cook is a trait object: a pointer plus a vtable. Go interfaces work the same way underneath.",
          "&dyn Cook은 트레이트 객체: 포인터 더하기 vtable. Go 인터페이스도 속은 같은 방식.",
          "&dyn Cook 係 trait object：一個 pointer 加一個 vtable。Go 嘅 interface 底層都係咁。"
        ),
      },
      {
        topic = "DERIVE",
        q = L(
          "Ask the compiler to write Clone and Debug for Order. Which attribute?",
          "컴파일러에게 Order의 Clone과 Debug를 써 달라고. 어떤 속성?",
          "叫 compiler 幫 Order 寫 Clone 同 Debug。邊個 attribute？"
        ),
        code = L(
          [[
// Ask the compiler to write .clone() for Order.
#[___(Clone, Debug)]
struct Order {
    bun: String,
    qty: u32,
}
]],
          [[
// 컴파일러에게 Order의 .clone()을 써 달라고.
#[___(Clone, Debug)]
struct Order {
    bun: String,
    qty: u32,
}
]],
          [[
// 叫 compiler 幫 Order 寫 .clone()。
#[___(Clone, Debug)]
struct Order {
    bun: String,
    qty: u32,
}
]]
        ),
        accept = { "derive" },
        answer = "derive",
        hint = L(
          "Six letters. To obtain from a source.",
          "여섯 글자. 근원에서 얻어내다.",
          "六個字母。由來源得出。"
        ),
        ok = L(
          "#[derive(Clone, Debug)] generates the impls. Also common: PartialEq, Default, Copy for small types.",
          "#[derive(Clone, Debug)]가 impl을 생성. 자주 쓰는 것: PartialEq, Default, 작은 타입엔 Copy.",
          "#[derive(Clone, Debug)] 自動生成 impl。常見仲有：PartialEq、Default，細 type 用 Copy。"
        ),
      },
      {
        topic = "DISPLAY",
        q = L(
          'Teach println!("{}") to print an Order. Which fmt trait?',
          'println!("{}")로 Order를 찍게 하려면. 어떤 fmt 트레이트?',
          '教 println!("{}") 印 Order。邊個 fmt trait？'
        ),
        code = L(
          [[
use std::fmt;
// Teach println!("{}") how to print an Order.
impl fmt::___ for Order {
    fn fmt(&self, f: &mut fmt::Formatter) -> fmt::Result {
        write!(f, "{} x{}", self.bun, self.qty)
    }
}
]],
          [[
use std::fmt;
// println!("{}")에게 Order 찍는 법을 가르친다.
impl fmt::___ for Order {
    fn fmt(&self, f: &mut fmt::Formatter) -> fmt::Result {
        write!(f, "{} x{}", self.bun, self.qty)
    }
}
]],
          [[
use std::fmt;
// 教 println!("{}") 點印 Order。
impl fmt::___ for Order {
    fn fmt(&self, f: &mut fmt::Formatter) -> fmt::Result {
        write!(f, "{} x{}", self.bun, self.qty)
    }
}
]]
        ),
        accept = { "Display", "fmt::Display", "std::fmt::Display" },
        answer = "Display",
        hint = L(
          "Seven letters. For humans; Debug is for {:?}.",
          "일곱 글자. 사람용; Debug는 {:?}용.",
          "七個字母。俾人睇嘅；Debug 係俾 {:?}。"
        ),
        ok = L(
          "impl fmt::Display gives {} and .to_string() for free. The order board reads: pineapple bun x2.",
          "impl fmt::Display로 {}와 .to_string()이 공짜로 생긴다. 주문판: pineapple bun x2.",
          "impl fmt::Display 送你 {} 同 .to_string()。單板顯示：pineapple bun x2。"
        ),
      },
      {
        topic = "DEFAULT",
        q = L(
          "An empty tray, all fields zero, without typing them. Which call?",
          "필드가 전부 0인 빈 트레이, 직접 안 치고. 어떤 호출?",
          "一個全部 field 係零嘅空 tray，唔使逐個打。邊個呼叫？"
        ),
        code = L(
          [[
#[derive(Default, Debug)]
struct Tray { buns: u32, teas: u32 }
// An empty tray, all zeros, without typing them.
let empty = Tray::___();
println!("{empty:?}");
]],
          [[
#[derive(Default, Debug)]
struct Tray { buns: u32, teas: u32 }
// 빈 트레이, 전부 0, 직접 치지 않고.
let empty = Tray::___();
println!("{empty:?}");
]],
          [[
#[derive(Default, Debug)]
struct Tray { buns: u32, teas: u32 }
// 空 tray，全部零，唔使逐個打。
let empty = Tray::___();
println!("{empty:?}");
]]
        ),
        accept = { "default" },
        answer = "default",
        hint = L(
          "Same name as the derived trait, in lowercase.",
          "derive한 트레이트와 같은 이름, 소문자로.",
          "同 derive 嗰個 trait 一樣嘅名，細楷。"
        ),
        ok = L(
          "Tray::default() comes from the Default trait: 0 for numbers, empty String, empty Vec. Also ..Default::default() in struct literals.",
          "Tray::default()는 Default 트레이트에서 온다: 숫자는 0, 빈 String, 빈 Vec. 구조체 리터럴에선 ..Default::default().",
          "Tray::default() 來自 Default trait：數字係 0，空 String，空 Vec。struct literal 仲可以寫 ..Default::default()。"
        ),
      },
    },
  },

  {
    id = "rs_generic",
    station = "GENERIC",
    name = L("The kiosk", "키오스크", "點餐機"),
    title = L("Generics and trait bounds", "제네릭과 트레이트 바운드", "generic 同 trait bound"),
    lesson = L(
      "fn f<T: Bound> is checked at compile time. dyn Trait in a Box decides at run time.",
      "fn f<T: Bound>는 컴파일 때 검사된다. Box 안의 dyn Trait은 실행 중에 정한다.",
      "fn f<T: Bound> 喺 compile 時檢查。Box 入面嘅 dyn Trait 喺 run time 決定。"
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
        x = 560,
        facing = 1,
        line = L(
          "The kiosk wants one function for prices and for weights. Go had any; what now?",
          "키오스크가 가격용과 무게용으로 함수 하나를 원해. Go엔 any가 있었는데, 이젠?",
          "點餐機想要一個 function 同時處理價錢同重量。Go 有 any，而家點？"
        ),
      },
      {
        kind = "mei",
        x = 720,
        facing = -1,
        line = L(
          "Generics. Say <T> and tell the compiler what T can do.",
          "제네릭. <T>라고 쓰고 T가 뭘 할 수 있는지 컴파일러에게 말해.",
          "generic。寫 <T>，然後話俾 compiler 知 T 做得咩。"
        ),
      },
    },
    viz = "rust",
    chips = {
      { "fn largest<T: Ord>", "cyan" },
      { "where T: Display", "gold" },
      { "parse::<i32>()", "green" },
      { "Box<dyn Cook>", "pink" },
    },
    note = "<T: Bound>  where  impl Trait  ::<T>  Box<dyn>",
    story = L(
      "16:20. The kiosk in the mall corridor has one price list in u32 and one weight list in f64, "
        .. "and two copies of every function. The crab on the screen sulks. Generics fold them into one.",
      "16:20. 몰 통로의 키오스크는 u32 가격 목록과 f64 무게 목록, 그리고 모든 함수가 두 벌씩 있다. "
        .. "화면의 크랩이 뾰로통하다. 제네릭이 하나로 합친다.",
      "下晝四點二十。商場走廊嘅點餐機有一個 u32 價錢表、一個 f64 重量表，每個 function 都有兩份。"
        .. "畫面上嘅蟹仔黑面。generic 將佢哋合埋做一個。"
    ),
    stages = {
      {
        topic = "BOUND",
        q = L(
          "largest compares with >. Which trait must T promise?",
          "largest는 >로 비교한다. T가 약속해야 할 트레이트는?",
          "largest 用 > 比較。T 要承諾邊個 trait？"
        ),
        code = L(
          [[
fn largest<T: ___ + Copy>(items: &[T]) -> T {
    let mut best = items[0];
    for &it in items {
        if it > best { best = it; }   // needs > on T
    }
    best
}
]],
          [[
fn largest<T: ___ + Copy>(items: &[T]) -> T {
    let mut best = items[0];
    for &it in items {
        if it > best { best = it; }   // T에 >가 필요
    }
    best
}
]],
          [[
fn largest<T: ___ + Copy>(items: &[T]) -> T {
    let mut best = items[0];
    for &it in items {
        if it > best { best = it; }   // T 要有 >
    }
    best
}
]]
        ),
        accept = { "PartialOrd", "std::cmp::PartialOrd", "cmp::PartialOrd" },
        answer = "PartialOrd",
        hint = L(
          "Partial, then the word for ordering. Ord alone is too strict for f64.",
          "Partial 다음 순서를 뜻하는 단어. Ord만으론 f64에 너무 엄격.",
          "Partial 然後係排序嗰個字。只用 Ord 對 f64 太嚴。"
        ),
        ok = L(
          "T: PartialOrd + Copy. Bounds are checked at compile time, so largest(&[1.5, 2.5]) and largest(&[18, 22]) both work.",
          "T: PartialOrd + Copy. 바운드는 컴파일 때 검사되어 largest(&[1.5, 2.5])와 largest(&[18, 22]) 둘 다 된다.",
          "T: PartialOrd + Copy。bound 喺 compile 時檢查，所以 largest(&[1.5, 2.5]) 同 largest(&[18, 22]) 都得。"
        ),
      },
      {
        topic = "WHERE",
        q = L(
          "Long bounds go under the signature. Which keyword starts that clause?",
          "긴 바운드는 시그니처 아래로. 그 절을 시작하는 키워드는?",
          "長 bound 寫喺 signature 下面。開頭嗰個 keyword 係？"
        ),
        code = L(
          [[
// Same bound, written under the signature for long lists.
fn show_all<T>(items: &[T])
___
    T: std::fmt::Display,
{
    for it in items { println!("{it}"); }
}
]],
          [[
// 같은 바운드, 길어지면 시그니처 아래에.
fn show_all<T>(items: &[T])
___
    T: std::fmt::Display,
{
    for it in items { println!("{it}"); }
}
]],
          [[
// 同一個 bound，長就寫喺 signature 下面。
fn show_all<T>(items: &[T])
___
    T: std::fmt::Display,
{
    for it in items { println!("{it}"); }
}
]]
        ),
        accept = { "where" },
        answer = "where",
        hint = L(
          "Five letters. Also asks for a location.",
          "다섯 글자. 장소를 묻는 말이기도 하다.",
          "五個字母。問「邊度」嗰個英文字。"
        ),
        ok = L(
          "where T: Display, reads the same as <T: Display> but stays legible with many bounds.",
          "where T: Display,는 <T: Display>와 같지만 바운드가 많아도 읽기 좋다.",
          "where T: Display, 同 <T: Display> 一樣，但係 bound 多都易讀。"
        ),
      },
      {
        topic = "IMPL ARG",
        q = L(
          "Take any Cook without naming a type parameter. Which keyword goes before the trait?",
          "타입 매개변수 없이 임의의 Cook을 받는다. 트레이트 앞에 오는 키워드는?",
          "唔寫 type parameter 就收任何 Cook。trait 前面放邊個 keyword？"
        ),
        code = L(
          [[
// Take any Cook at all; the caller picks the concrete type.
fn fire(c: ___ Cook) -> String {
    c.greet()
}
]],
          [[
// 어떤 Cook이든; 타입은 호출자가 정한다.
fn fire(c: ___ Cook) -> String {
    c.greet()
}
]],
          [[
// 任何 Cook 都收；具體 type 由 caller 揀。
fn fire(c: ___ Cook) -> String {
    c.greet()
}
]]
        ),
        accept = { "impl" },
        answer = "impl",
        hint = L(
          "Four letters. The same word that starts an implementation block.",
          "네 글자. 구현 블록을 시작하는 그 단어.",
          "四個字母。開 implementation block 嗰個字。"
        ),
        ok = L(
          "impl Cook in argument position is sugar for a generic <C: Cook>. Static dispatch, no Box.",
          "인자 위치의 impl Cook은 제네릭 <C: Cook>의 설탕 문법. 정적 디스패치, Box 없음.",
          "參數位置嘅 impl Cook 係 generic <C: Cook> 嘅糖衣寫法。static dispatch，唔使 Box。"
        ),
      },
      {
        topic = "OPTION",
        q = L(
          "Maybe a String, maybe nothing. Which return type?",
          "String일 수도, 없을 수도. 반환 타입은?",
          "可能有 String，可能冇。回傳 type 係？"
        ),
        code = L(
          [[
// Not every table has an order yet.
fn find(orders: &[(u32, &str)], t: u32) -> ___<String> {
    for (n, item) in orders {
        if *n == t { return Some(item.to_string()); }
    }
    None
}
]],
          [[
// 모든 테이블에 주문이 있는 건 아니다.
fn find(orders: &[(u32, &str)], t: u32) -> ___<String> {
    for (n, item) in orders {
        if *n == t { return Some(item.to_string()); }
    }
    None
}
]],
          [[
// 唔係每張枱都有單。
fn find(orders: &[(u32, &str)], t: u32) -> ___<String> {
    for (n, item) in orders {
        if *n == t { return Some(item.to_string()); }
    }
    None
}
]]
        ),
        accept = { "Option" },
        answer = "Option",
        hint = L(
          "Six letters. Generic over T: Some(T) or None.",
          "여섯 글자. T에 대한 제네릭: Some(T) 아니면 None.",
          "六個字母。對 T 做 generic：Some(T) 或者 None。"
        ),
        ok = L(
          "Option<T> is an enum in the standard library, generic like your own types. No null anywhere in Rust.",
          "Option<T>는 표준 라이브러리의 enum, 내가 만든 타입처럼 제네릭. Rust엔 null이 어디에도 없다.",
          "Option<T> 係標準庫嘅 enum，同你自己嘅 type 一樣係 generic。Rust 冇 null。"
        ),
      },
      {
        topic = "TURBOFISH",
        q = L(
          "Nothing tells parse which type to build. Say i32 with the turbofish.",
          "무엇도 parse에 타입을 알려주지 않는다. 터보피시로 i32라고 쓰세요.",
          "冇任何嘢話俾 parse 知要做邊個 type。用 turbofish 寫 i32。"
        ),
        code = L(
          [[
// Nothing here tells parse which number type to build.
let qty = "12".parse___().unwrap();
let total = qty * 18;
]],
          [[
// parse에 숫자 타입을 알려주는 게 없다.
let qty = "12".parse___().unwrap();
let total = qty * 18;
]],
          [[
// 呢度冇嘢話俾 parse 知要做邊種數字。
let qty = "12".parse___().unwrap();
let total = qty * 18;
]]
        ),
        accept = { "::<i32>", "::< i32 >" },
        answer = "::<i32>",
        hint = L(
          "Two colons, then the type in angle brackets. It looks like a fish.",
          "콜론 둘, 그다음 꺾쇠 안에 타입. 물고기처럼 보인다.",
          "兩個冒號，然後尖括號入面放 type。個樣似條魚。"
        ),
        ok = L(
          "parse::<i32>() names the generic explicitly. Same trick: collect::<Vec<_>>(). 12 x 18 = 216.",
          "parse::<i32>()는 제네릭을 명시한다. 같은 요령: collect::<Vec<_>>(). 12 x 18 = 216.",
          "parse::<i32>() 明確寫出 generic。同一招：collect::<Vec<_>>()。12 x 18 = 216。"
        ),
      },
      {
        topic = "BOX DYN",
        q = L(
          "Grill and Wok are different sizes. What element type lets one Vec hold both?",
          "Grill과 Wok은 크기가 다르다. 한 Vec에 둘을 담는 원소 타입은?",
          "Grill 同 Wok 大細唔同。邊個元素 type 令一個 Vec 裝得兩樣？"
        ),
        code = L(
          [[
// Grill and Wok in one Vec: each boxed as a trait object.
let crew: Vec<___> = vec![Box::new(Grill), Box::new(Wok)];
for c in &crew { println!("{}", c.greet()); }
]],
          [[
// Grill과 Wok을 한 Vec에: 각각 박싱.
let crew: Vec<___> = vec![Box::new(Grill), Box::new(Wok)];
for c in &crew { println!("{}", c.greet()); }
]],
          [[
// Grill 同 Wok 放喺一個 Vec：每個都 box 咗。
let crew: Vec<___> = vec![Box::new(Grill), Box::new(Wok)];
for c in &crew { println!("{}", c.greet()); }
]]
        ),
        accept = { "Box<dyn Cook>", "std::boxed::Box<dyn Cook>" },
        answer = "Box<dyn Cook>",
        hint = L(
          "A heap pointer to a dyn trait: Box, angle brackets, dyn, the trait.",
          "dyn 트레이트를 가리키는 힙 포인터: Box, 꺾쇠, dyn, 트레이트.",
          "指住 dyn trait 嘅 heap pointer：Box、尖括號、dyn、個 trait。"
        ),
        ok = L(
          "Vec<Box<dyn Cook>>: every Box is one pointer wide, so the Vec is happy. Dispatch happens at run time. The kiosk shows one list.",
          "Vec<Box<dyn Cook>>: 모든 Box는 포인터 하나 크기라 Vec이 만족한다. 디스패치는 실행 중에. 키오스크에 목록 하나가 뜬다.",
          "Vec<Box<dyn Cook>>：每個 Box 都係一個 pointer 咁大，Vec 就開心。dispatch 喺 run time 做。點餐機顯示一張表。"
        ),
      },
    },
  },

  {
    id = "rs_life",
    station = "LIFETIME",
    name = L("The tea table", "티 테이블", "茶枱"),
    title = L("Lifetimes", "라이프타임", "lifetime"),
    lesson = L(
      "A reference must not outlive what it points at. 'a names how long; 'static means the whole program.",
      "참조는 가리키는 것보다 오래 살 수 없다. 'a는 그 길이의 이름; 'static은 프로그램 전체.",
      "reference 唔可以活得長過佢指住嘅嘢。'a 係嗰段時間嘅名；'static 即係成個程式。"
    ),
    bg = "bg_set",
    portrait = "portrait_hero",
    speaker = L("Alex", "알렉스", "阿力"),
    ground = 348,
    spawn = 180,
    width = 1600,
    npcs = {
      {
        kind = "mei",
        x = 540,
        facing = 1,
        line = L(
          "The receipt borrows your name. It must not outlive you. That is all a lifetime says.",
          "영수증은 네 이름을 빌려. 너보다 오래 살면 안 돼. 라이프타임은 그 말이 다야.",
          "收據借咗你個名。佢唔可以活得長過你。lifetime 講嘅就係咁多。"
        ),
      },
      {
        kind = "cook",
        x = 760,
        facing = -1,
        line = L(
          "Tea first, lifetimes second. The set is almost ready.",
          "차 먼저, 라이프타임은 그다음. 세트가 거의 다 됐어.",
          "先飲茶，lifetime 遲啲。套餐差唔多得。"
        ),
      },
    },
    viz = "rust",
    chips = {
      { "fn f<'a>(s: &'a str)", "cyan" },
      { "&'static str", "gold" },
      { "struct Receipt<'a>", "pink" },
      { "impl Receipt<'_>", "green" },
    },
    note = "'a  &'static str  struct<'a>  elision  '_",
    story = L(
      "16:30. The set table by the window. The receipt printer holds a reference to a name that was "
        .. "freed one line earlier and Rust refuses to build. Alex learns to say how long a borrow lives.",
      "16:30. 창가의 세트 테이블. 영수증 프린터가 한 줄 전에 해제된 이름의 참조를 들고 있어 "
        .. "Rust가 빌드를 거부한다. 알렉스는 빌림이 얼마나 사는지 말하는 법을 배운다.",
      "下晝四點半。窗邊嘅套餐枱。收據機揸住一個上一行已經釋放咗嘅名嘅 reference，"
        .. "Rust 唔肯 build。阿力學點樣講一個借用活幾長。"
    ),
    stages = {
      {
        topic = "LIFETIME",
        q = L(
          "longest returns one of its inputs. Which lifetime does the return value carry?",
          "longest는 입력 중 하나를 반환한다. 반환값은 어떤 라이프타임을 가지나요?",
          "longest 回傳其中一個輸入。回傳值帶邊個 lifetime？"
        ),
        code = L(
          [[
// Two buns from one tray: the winner lives as long as both.
fn longest<'a>(a: &'a str, b: &'a str) -> &___ str {
    if a.len() >= b.len() { a } else { b }
}
]],
          [[
// 한 트레이의 빵 둘: 이긴 쪽도 둘만큼 산다.
fn longest<'a>(a: &'a str, b: &'a str) -> &___ str {
    if a.len() >= b.len() { a } else { b }
}
]],
          [[
// 同一盤兩個包：贏嗰個活得同兩個一樣長。
fn longest<'a>(a: &'a str, b: &'a str) -> &___ str {
    if a.len() >= b.len() { a } else { b }
}
]]
        ),
        accept = { "'a", "a" },
        answer = "'a",
        hint = L(
          "A tick and one letter, the same as both inputs.",
          "틱 하나와 글자 하나, 두 입력과 같은 것.",
          "一個撇號加一個字母，同兩個輸入一樣。"
        ),
        ok = L(
          "&'a str: the output lives at least as long as the shorter of a and b. Lifetimes describe; they never extend anything.",
          "&'a str: 출력은 a와 b 중 짧은 쪽만큼은 산다. 라이프타임은 설명일 뿐, 무엇도 늘려주지 않는다.",
          "&'a str：輸出至少活得同 a 同 b 較短嗰個一樣長。lifetime 只係描述；佢唔會延長任何嘢。"
        ),
      },
      {
        topic = "STATIC",
        q = L(
          "No input reference to borrow from. Which lifetime does a literal string have?",
          "빌려올 입력 참조가 없다. 문자열 리터럴의 라이프타임은?",
          "冇輸入 reference 可以借。字串 literal 係邊個 lifetime？"
        ),
        code = L(
          [[
// The banner is baked into the binary for the whole run.
fn banner() -> &___ str {
    "Lucky Mac Express"
}
]],
          [[
// 배너는 바이너리에 박혀 내내 산다.
fn banner() -> &___ str {
    "Lucky Mac Express"
}
]],
          [[
// 橫額寫死喺 binary 入面，成個程式都喺度。
fn banner() -> &___ str {
    "Lucky Mac Express"
}
]]
        ),
        accept = { "'static", "static" },
        answer = "'static",
        hint = L(
          "A tick and the word for something that never moves.",
          "틱 하나와 움직이지 않는 것을 뜻하는 단어.",
          "一個撇號加「唔郁」嗰個英文字。"
        ),
        ok = L(
          "&'static str lives for the whole program. String literals are 'static; a returned reference with no input to borrow from must be too.",
          "&'static str은 프로그램 내내 산다. 문자열 리터럴은 'static; 빌려올 입력이 없는 반환 참조도 그래야 한다.",
          "&'static str 活成個程式咁長。字串 literal 係 'static；冇輸入可借嘅回傳 reference 都一定要係。"
        ),
      },
      {
        topic = "STRUCT",
        q = L(
          "Receipt holds a &'a str. What must the struct declare after its name?",
          "Receipt가 &'a str을 가진다. 구조체 이름 뒤에 무엇을 선언해야 하나요?",
          "Receipt 有一個 &'a str。struct 名後面要宣告咩？"
        ),
        code = L(
          [[
// The receipt only borrows the name: say so on the struct.
struct Receipt___ {
    name: &'a str,
    total: u32,
}
]],
          [[
// 이름을 빌릴 뿐: 구조체에 적는다.
struct Receipt___ {
    name: &'a str,
    total: u32,
}
]],
          [[
// 收據只係借個名：喺 struct 上面講明。
struct Receipt___ {
    name: &'a str,
    total: u32,
}
]]
        ),
        accept = { "<'a>", "<a>" },
        answer = "<'a>",
        hint = L(
          "Angle brackets around the lifetime, like a generic parameter.",
          "제네릭 매개변수처럼 라이프타임을 꺾쇠로 감싼다.",
          "用尖括號包住 lifetime，好似 generic parameter。"
        ),
        ok = L(
          "struct Receipt<'a> { name: &'a str }: a Receipt cannot outlive the name it borrows. The compiler now checks it for you.",
          "struct Receipt<'a> { name: &'a str }: Receipt는 빌린 이름보다 오래 못 산다. 이제 컴파일러가 대신 확인한다.",
          "struct Receipt<'a> { name: &'a str }：Receipt 唔可以活得長過佢借嘅名。而家 compiler 幫你檢查。"
        ),
      },
      {
        topic = "ANON",
        q = L(
          "Display does not care which lifetime Receipt has. Which placeholder says so?",
          "Display는 Receipt의 라이프타임이 무엇이든 상관없다. 그걸 말하는 자리표시자는?",
          "Display 唔在乎 Receipt 係邊個 lifetime。邊個 placeholder 咁講？"
        ),
        code = L(
          [[
use std::fmt;
// Receipt carries a lifetime; fmt does not need its name.
impl fmt::Display for Receipt<___> {
    fn fmt(&self, f: &mut fmt::Formatter) -> fmt::Result {
        write!(f, "{} paid {}", self.name, self.total)
    }
}
]],
          [[
use std::fmt;
// Receipt의 라이프타임 이름은 fmt엔 불필요.
impl fmt::Display for Receipt<___> {
    fn fmt(&self, f: &mut fmt::Formatter) -> fmt::Result {
        write!(f, "{} paid {}", self.name, self.total)
    }
}
]],
          [[
use std::fmt;
// Receipt 帶住 lifetime；fmt 唔需要知佢個名。
impl fmt::Display for Receipt<___> {
    fn fmt(&self, f: &mut fmt::Formatter) -> fmt::Result {
        write!(f, "{} paid {}", self.name, self.total)
    }
}
]]
        ),
        accept = { "'_", "_" },
        answer = "'_",
        hint = L(
          "A tick and an underscore: the anonymous lifetime.",
          "틱 하나와 밑줄 하나: 익명 라이프타임.",
          "一個撇號加一個底線：匿名 lifetime。"
        ),
        ok = L(
          "Receipt<'_> means some lifetime, I do not need to name it. Clearer than impl<'a> Display for Receipt<'a> when 'a is never used.",
          "Receipt<'_>는 어떤 라이프타임이든, 이름은 필요 없다는 뜻. 'a를 쓰지 않을 땐 impl<'a> Display for Receipt<'a>보다 명확하다.",
          "Receipt<'_> 即係「有個 lifetime，但我唔需要叫佢名」。'a 用唔到嗰陣，比 impl<'a> Display for Receipt<'a> 清楚。"
        ),
      },
      {
        topic = "ELISION",
        q = L(
          "who returns a borrow of self. Write the return type with no lifetime at all.",
          "who는 self에서 빌린 것을 반환한다. 라이프타임 없이 반환 타입을 쓰세요.",
          "who 回傳由 self 借出嚟嘅嘢。寫個完全冇 lifetime 嘅回傳 type。"
        ),
        code = L(
          [[
impl Receipt<'_> {
    // Self in, one reference out: no lifetime name needed.
    fn who(&self) -> ___ {
        self.name
    }
}
]],
          [[
impl Receipt<'_> {
    // self 입력, 참조 하나 출력: 이름 불필요.
    fn who(&self) -> ___ {
        self.name
    }
}
]],
          [[
impl Receipt<'_> {
    // self 入，一個 reference 出：唔使寫名。
    fn who(&self) -> ___ {
        self.name
    }
}
]]
        ),
        accept = { "&str", "& str", "&'_ str" },
        answer = "&str",
        hint = L(
          "Ampersand and the string slice type. Elision fills in the rest.",
          "앰퍼샌드와 문자열 슬라이스 타입. 나머지는 생략 규칙이 채운다.",
          "& 加字串切片 type。其餘由 elision 規則填。"
        ),
        ok = L(
          "Elision: one input reference (here &self) means the output borrows from it. Most signatures need no 'a at all. The receipt prints.",
          "생략: 입력 참조가 하나(여기선 &self)면 출력은 거기서 빌린다. 대부분의 시그니처엔 'a가 전혀 필요 없다. 영수증이 나온다.",
          "elision：只有一個輸入 reference（呢度係 &self），輸出就由佢借。大部分 signature 根本唔使寫 'a。收據印出嚟。"
        ),
      },
    },
  },

  {
    id = "rs_thread",
    station = "THREAD",
    name = L("The grill line", "그릴 라인", "燒烤線"),
    title = L("Threads", "스레드", "thread"),
    lesson = L(
      "thread::spawn starts a thread; move gives it its data; join waits. thread::scope may borrow.",
      "thread::spawn이 스레드를 시작; move로 데이터를 넘기고; join으로 기다린다. thread::scope는 빌릴 수 있다.",
      "thread::spawn 開一條 thread；move 將資料交俾佢；join 等佢。thread::scope 可以借。"
    ),
    bg = "bg_kitchen",
    portrait = "portrait_officer",
    speaker = L("Chef Bo", "보 셰프", "波師傅"),
    ground = 348,
    spawn = 180,
    width = 1600,
    npcs = {
      {
        kind = "cook",
        x = 520,
        facing = 1,
        line = L(
          "One cook, one thread. The grill must not wait for the kettle.",
          "요리사 하나, 스레드 하나. 그릴이 주전자를 기다리면 안 돼.",
          "一個 cook 一條 thread。燒烤唔可以等水煲。"
        ),
      },
      {
        kind = "hero",
        x = 740,
        facing = -1,
        line = L(
          "Go had goroutines. Where is the go keyword?",
          "Go엔 고루틴이 있었는데. go 키워드는 어디 갔어?",
          "Go 有 goroutine。go 呢個 keyword 去咗邊？"
        ),
      },
    },
    viz = "rust",
    chips = {
      { "thread::spawn(move ||", "cyan" },
      { "h.join().unwrap()", "gold" },
      { "Duration::from_millis", "green" },
      { "thread::scope(|s|", "pink" },
    },
    note = "spawn  move  join  sleep  JoinHandle  scope",
    story = L(
      "16:40. Three orders, one cook, one thread: the pineapple buns wait while the kettle boils. "
        .. "Chef Bo wants the grill, the kettle and the pass to run at the same time. "
        .. "Rust threads are real OS threads; no go keyword here.",
      "16:40. 주문 셋, 요리사 하나, 스레드 하나: 주전자가 끓는 동안 파인애플 번이 기다린다. "
        .. "보 셰프는 그릴, 주전자, 패스가 동시에 돌길 원한다. Rust 스레드는 진짜 OS 스레드; go 키워드는 없다.",
      "下晝四點四十。三張單，一個 cook，一條 thread：水煲滾嗰陣菠蘿包就等。"
        .. "波師傅想燒烤、水煲同出餐台同時行。Rust thread 係真 OS thread；呢度冇 go keyword。"
    ),
    stages = {
      {
        topic = "SPAWN",
        q = L(
          "Start a new thread that runs this closure. Which function?",
          "이 클로저를 돌리는 새 스레드를 시작. 어떤 함수?",
          "開一條新 thread 行呢個 closure。邊個 function？"
        ),
        code = L(
          [[
use std::thread;
// The grill gets its own thread; the till keeps serving.
let grill = thread::___(|| {
    println!("bun is toasting");
});
grill.join().unwrap();
]],
          [[
use std::thread;
// 그릴은 자기 스레드로; 계산대는 계속.
let grill = thread::___(|| {
    println!("bun is toasting");
});
grill.join().unwrap();
]],
          [[
use std::thread;
// 燒烤有自己嘅 thread；收銀繼續做。
let grill = thread::___(|| {
    println!("bun is toasting");
});
grill.join().unwrap();
]]
        ),
        accept = { "spawn", "thread::spawn", "std::thread::spawn" },
        answer = "spawn",
        hint = L(
          "Five letters. What fish and goroutines do.",
          "다섯 글자. 물고기와 고루틴이 하는 것.",
          "五個字母。魚同 goroutine 都會做嘅事。"
        ),
        ok = L(
          "thread::spawn(closure) returns a JoinHandle and runs at once on an OS thread. Rust has no green threads built in.",
          "thread::spawn(클로저)는 JoinHandle을 반환하고 OS 스레드에서 바로 실행된다. Rust엔 내장 그린 스레드가 없다.",
          "thread::spawn(closure) 回傳 JoinHandle，即刻喺 OS thread 上行。Rust 冇內置 green thread。"
        ),
      },
      {
        topic = "MOVE",
        q = L(
          "The thread may outlive this scope. Which keyword gives the closure ownership of order?",
          "스레드가 이 스코프보다 오래 살 수 있다. 클로저에 order의 소유권을 주는 키워드는?",
          "條 thread 可能活得長過呢個 scope。邊個 keyword 將 order 嘅 ownership 交俾 closure？"
        ),
        code = L(
          [[
let order = String::from("pineapple bun");
// The thread may outlive this block: give it the String.
let h = thread::spawn(___ || {
    println!("toasting {order}");
});
h.join().unwrap();
]],
          [[
let order = String::from("pineapple bun");
// 스레드가 더 오래 살 수 있다: String을 준다.
let h = thread::spawn(___ || {
    println!("toasting {order}");
});
h.join().unwrap();
]],
          [[
let order = String::from("pineapple bun");
// 條 thread 可能活得更長：將 String 交俾佢。
let h = thread::spawn(___ || {
    println!("toasting {order}");
});
h.join().unwrap();
]]
        ),
        accept = { "move" },
        answer = "move",
        hint = L(
          "Four letters. Take it, do not borrow it.",
          "네 글자. 빌리지 말고 가져가라.",
          "四個字母。攞走，唔係借。"
        ),
        ok = L(
          "move || captures by value. Without it the closure would borrow order, and a borrow cannot be proven to outlive the thread.",
          "move ||는 값으로 캡처한다. 없으면 클로저가 order를 빌리는데, 빌림이 스레드보다 오래 산다고 증명할 수 없다.",
          "move || 用 value 捕捉。冇佢 closure 就會借 order，而借用冇辦法證明活得長過條 thread。"
        ),
      },
      {
        topic = "JOIN",
        q = L(
          "Wait for the tea thread and take its result. Which method?",
          "차 스레드를 기다리고 결과를 가져온다. 메서드는?",
          "等茶嗰條 thread，攞佢個結果。邊個 method？"
        ),
        code = L(
          [[
// The tea thread hands back a number when it is done.
let tea = thread::spawn(|| 3 * 60);
// Wait for it and take the result out of the handle.
let secs: u32 = tea.___().unwrap();
]],
          [[
// 차 스레드는 끝나면 숫자를 돌려준다.
let tea = thread::spawn(|| 3 * 60);
// 기다렸다가 핸들에서 결과를 꺼낸다.
let secs: u32 = tea.___().unwrap();
]],
          [[
// 茶嗰條 thread 做完會交返一個數。
let tea = thread::spawn(|| 3 * 60);
// 等佢，然後由 handle 攞結果出嚟。
let secs: u32 = tea.___().unwrap();
]]
        ),
        accept = { "join" },
        answer = "join",
        hint = L(
          "Four letters. Where two roads meet again.",
          "네 글자. 두 길이 다시 만나는 것.",
          "四個字母。兩條路重新匹埋。"
        ),
        ok = L(
          "join() blocks until the thread ends and returns Result<T>; Err means the thread panicked. 180 seconds to steep.",
          "join()은 스레드가 끝날 때까지 막고 Result<T>를 반환; Err는 스레드가 panic했다는 뜻. 우리는 180초.",
          "join() 阻塞到條 thread 完，回傳 Result<T>；Err 即係條 thread panic 咗。焗 180 秒。"
        ),
      },
      {
        topic = "SLEEP",
        q = L(
          "Pause this thread for 300 ms. Which function?",
          "이 스레드를 300 ms 멈춘다. 어떤 함수?",
          "呢條 thread 停 300 ms。邊個 function？"
        ),
        code = L(
          [[
use std::time::Duration;
// Steep the tea for 300 ms before pouring.
thread::___(Duration::from_millis(300));
println!("pour");
]],
          [[
use std::time::Duration;
// 붓기 전에 차를 300 ms 우린다.
thread::___(Duration::from_millis(300));
println!("pour");
]],
          [[
use std::time::Duration;
// 沖之前焗茶 300 ms。
thread::___(Duration::from_millis(300));
println!("pour");
]]
        ),
        accept = { "sleep", "thread::sleep" },
        answer = "sleep",
        hint = L(
          "Five letters. What the kettle does between orders.",
          "다섯 글자. 주문 사이에 주전자가 하는 것.",
          "五個字母。水煲喺兩張單之間做嘅事。"
        ),
        ok = L(
          "thread::sleep(Duration) takes a Duration, never a bare number. Duration::from_secs and from_millis build one.",
          "thread::sleep(Duration)은 Duration을 받고 맨 숫자는 안 받는다. Duration::from_secs, from_millis로 만든다.",
          "thread::sleep(Duration) 收 Duration，唔收裸數字。Duration::from_secs 同 from_millis 造一個。"
        ),
      },
      {
        topic = "HANDLE",
        q = L(
          "spawn returns a handle you can wait on. What is its type?",
          "spawn은 기다릴 수 있는 핸들을 반환한다. 그 타입은?",
          "spawn 回傳一個可以等嘅 handle。佢係邊個 type？"
        ),
        code = L(
          [[
// Keep every handle so the pass can wait for every cook.
let mut hs: Vec<___<()>> = Vec::new();
for id in 0..3 {
    hs.push(thread::spawn(move || println!("cook {id}")));
}
for h in hs { h.join().unwrap(); }
]],
          [[
// 패스가 모두를 기다리게 핸들을 전부 보관.
let mut hs: Vec<___<()>> = Vec::new();
for id in 0..3 {
    hs.push(thread::spawn(move || println!("cook {id}")));
}
for h in hs { h.join().unwrap(); }
]],
          [[
// 留住每個 handle，出餐台先等得齊每個 cook。
let mut hs: Vec<___<()>> = Vec::new();
for id in 0..3 {
    hs.push(thread::spawn(move || println!("cook {id}")));
}
for h in hs { h.join().unwrap(); }
]]
        ),
        accept = { "JoinHandle", "thread::JoinHandle", "std::thread::JoinHandle" },
        answer = "JoinHandle",
        hint = L(
          "Two words glued: the verb you call to wait, and a thing you hold.",
          "두 단어를 붙임: 기다릴 때 부르는 동사, 그리고 손에 쥐는 것.",
          "兩個字黏埋：等嗰陣 call 嘅動詞，加你揸住嘅嘢。"
        ),
        ok = L(
          "JoinHandle<T>: T is what the closure returns, here (). Drop the handle and the thread is detached, still running.",
          "JoinHandle<T>: T는 클로저의 반환값, 여기선 (). 핸들을 버리면 스레드는 분리되어 계속 돈다.",
          "JoinHandle<T>：T 係 closure 回傳嘅嘢，呢度係 ()。掉咗 handle，條 thread 就脫離，仍然行住。"
        ),
      },
      {
        topic = "SCOPE",
        q = L(
          "Threads that borrow menu and are all joined before the block ends. Which function?",
          "menu를 빌리고 블록이 끝나기 전에 모두 join되는 스레드들. 어떤 함수?",
          "借 menu 而且 block 完之前全部 join 嘅 thread。邊個 function？"
        ),
        code = L(
          [[
let menu = vec!["bun", "egg tart", "milk tea"];
// Borrow menu from threads; all end before the block does.
thread::___(|s| {
    s.spawn(|| println!("{}", menu[0]));
    s.spawn(|| println!("{}", menu[1]));
});
]],
          [[
let menu = vec!["bun", "egg tart", "milk tea"];
// menu를 빌린다; 블록 끝 전에 모두 끝난다.
thread::___(|s| {
    s.spawn(|| println!("{}", menu[0]));
    s.spawn(|| println!("{}", menu[1]));
});
]],
          [[
let menu = vec!["bun", "egg tart", "milk tea"];
// 由 thread 借 menu；block 完之前全部完。
thread::___(|s| {
    s.spawn(|| println!("{}", menu[0]));
    s.spawn(|| println!("{}", menu[1]));
});
]]
        ),
        accept = { "scope", "thread::scope" },
        answer = "scope",
        hint = L(
          "Five letters. A region with a clear start and end.",
          "다섯 글자. 시작과 끝이 뚜렷한 영역.",
          "五個字母。有清楚開頭同結尾嘅範圍。"
        ),
        ok = L(
          "thread::scope(|s| ...) joins every s.spawn before returning, so the closures may borrow without move. Three cooks, one menu.",
          "thread::scope(|s| ...)는 반환 전에 모든 s.spawn을 join하므로 클로저가 move 없이 빌릴 수 있다. 요리사 셋, 메뉴 하나.",
          "thread::scope(|s| ...) 回傳前會 join 每個 s.spawn，所以 closure 唔使 move 都借得。三個 cook，一份 menu。"
        ),
      },
    },
  },

  {
    id = "rs_chan",
    station = "CHANNEL",
    name = L("The order queue", "주문 대기줄", "排單隊"),
    title = L("Channels", "채널", "channel"),
    lesson = L(
      "mpsc::channel gives a Sender and a Receiver. Clone the Sender for many producers; the loop ends when all are dropped.",
      "mpsc::channel은 Sender와 Receiver를 준다. 생산자가 많으면 Sender를 clone; 전부 drop되면 루프가 끝난다.",
      "mpsc::channel 俾一個 Sender 同一個 Receiver。多個生產者就 clone Sender；全部 drop 咗 loop 就完。"
    ),
    bg = "bg_queue",
    portrait = "portrait_friends",
    speaker = L("Mei", "메이", "阿美"),
    ground = 348,
    spawn = 180,
    width = 1600,
    npcs = {
      {
        kind = "clerk",
        x = 520,
        facing = 1,
        line = L(
          "Two tills, one kitchen. Orders pile up on my side and never arrive.",
          "계산대 둘, 주방 하나. 주문이 내 쪽에 쌓이고 도착하질 않아.",
          "兩個收銀，一個廚房。單堆喺我呢邊，永遠去唔到。"
        ),
      },
      {
        kind = "cook",
        x = 760,
        facing = -1,
        line = L(
          "Give me a pipe. Send on one end, I receive on the other.",
          "파이프를 줘. 한쪽에서 보내면 내가 반대쪽에서 받을게.",
          "俾條管我。一邊 send，我喺另一邊 recv。"
        ),
      },
    },
    viz = "rust",
    chips = {
      { "mpsc::channel()", "cyan" },
      { "tx.send(x).unwrap()", "gold" },
      { "for msg in rx {}", "green" },
      { "sync_channel(3)", "pink" },
    },
    note = "channel  send  recv  clone  drop  try_recv",
    story = L(
      "16:50. Two tills at Lucky Mac Express and one kitchen. Orders sit in a shared Vec that both tills "
        .. "scribble on and the kitchen never sees. Mei replaces the Vec with a channel: many senders, one receiver.",
      "16:50. 럭키 맥 익스프레스의 계산대 둘, 주방 하나. 주문이 두 계산대가 같이 긁적이는 공유 Vec에 앉아 있고 "
        .. "주방은 그걸 못 본다. 메이가 Vec을 채널로 바꾼다: 보내는 쪽 여럿, 받는 쪽 하나.",
      "下晝四點五十。幸運麥 Express 兩個收銀一個廚房。單擺喺一個兩邊收銀都亂寫嘅共用 Vec，"
        .. "廚房永遠見唔到。阿美將 Vec 換成 channel：多個 sender，一個 receiver。"
    ),
    stages = {
      {
        topic = "CHANNEL",
        q = L(
          "Make a pipe with a sending end and a receiving end. Which function?",
          "보내는 끝과 받는 끝이 있는 파이프를 만든다. 어떤 함수?",
          "造一條有 send 端同 recv 端嘅管。邊個 function？"
        ),
        code = L(
          [[
use std::sync::mpsc;
// One pipe from till to kitchen: a sender and a receiver.
let (tx, rx) = mpsc::___();
tx.send("egg tart").unwrap();
]],
          [[
use std::sync::mpsc;
// 계산대에서 주방으로 파이프 하나: 양 끝.
let (tx, rx) = mpsc::___();
tx.send("egg tart").unwrap();
]],
          [[
use std::sync::mpsc;
// 收銀去廚房一條管：一個 tx 一個 rx。
let (tx, rx) = mpsc::___();
tx.send("egg tart").unwrap();
]]
        ),
        accept = { "channel", "mpsc::channel" },
        answer = "channel",
        hint = L(
          "Seven letters. Go spelled it chan.",
          "일곱 글자. Go에선 chan이라고 썼다.",
          "七個字母。Go 寫做 chan。"
        ),
        ok = L(
          "mpsc::channel() returns (Sender<T>, Receiver<T>). mpsc: multi-producer, single-consumer. The pipe is unbounded.",
          "mpsc::channel()은 (Sender<T>, Receiver<T>)를 반환. mpsc: 다중 생산자, 단일 소비자. 파이프는 무한.",
          "mpsc::channel() 回傳 (Sender<T>, Receiver<T>)。mpsc：多生產者，單消費者。條管冇上限。"
        ),
      },
      {
        topic = "RECV",
        q = L(
          "The kitchen waits until an order arrives. Which method blocks and takes one?",
          "주방은 주문이 올 때까지 기다린다. 막고서 하나 꺼내는 메서드는?",
          "廚房等到有單先郁。邊個 method 會阻塞然後攞一張？"
        ),
        code = L(
          [[
let (tx, rx) = mpsc::channel();
tx.send(7).unwrap();
// The kitchen waits here until an order arrives.
let order: u32 = rx.___().unwrap();
]],
          [[
let (tx, rx) = mpsc::channel();
tx.send(7).unwrap();
// 주방은 주문이 올 때까지 여기서 기다린다.
let order: u32 = rx.___().unwrap();
]],
          [[
let (tx, rx) = mpsc::channel();
tx.send(7).unwrap();
// 廚房喺呢度等到有單為止。
let order: u32 = rx.___().unwrap();
]]
        ),
        accept = { "recv" },
        answer = "recv",
        hint = L(
          "Four letters, the opposite of send, cut short.",
          "네 글자, send의 반대말을 줄인 것.",
          "四個字母，send 嘅相反，縮短咗。"
        ),
        ok = L(
          "rx.recv() blocks until a value arrives; Err when every Sender is gone. Order 7 hits the pass.",
          "rx.recv()는 값이 올 때까지 막는다; Sender가 전부 사라지면 Err. 7번 주문이 패스에 도착.",
          "rx.recv() 阻塞到有值嚟；Sender 全部冇咗就 Err。7 號單到出餐台。"
        ),
      },
      {
        topic = "CLONE",
        q = L(
          "Two tills need two senders into the same pipe. Which method makes the second?",
          "계산대 둘엔 같은 파이프로 보내는 Sender 둘이 필요. 두 번째를 만드는 메서드는?",
          "兩個收銀要兩個 sender 入同一條管。邊個 method 造第二個？"
        ),
        code = L(
          [[
let (tx, rx) = mpsc::channel();
// Two tills, one kitchen: each till needs its own sender.
let tx2 = tx.___();
thread::spawn(move || tx.send("till 1").unwrap());
thread::spawn(move || tx2.send("till 2").unwrap());
for msg in rx { println!("{msg}"); }
]],
          [[
let (tx, rx) = mpsc::channel();
// 계산대 둘, 주방 하나: 각자 Sender 필요.
let tx2 = tx.___();
thread::spawn(move || tx.send("till 1").unwrap());
thread::spawn(move || tx2.send("till 2").unwrap());
for msg in rx { println!("{msg}"); }
]],
          [[
let (tx, rx) = mpsc::channel();
// 兩個收銀一個廚房：每個要自己嘅 sender。
let tx2 = tx.___();
thread::spawn(move || tx.send("till 1").unwrap());
thread::spawn(move || tx2.send("till 2").unwrap());
for msg in rx { println!("{msg}"); }
]]
        ),
        accept = { "clone" },
        answer = "clone",
        hint = L(
          "Five letters. Sender has it; Receiver does not.",
          "다섯 글자. Sender엔 있고 Receiver엔 없다.",
          "五個字母。Sender 有，Receiver 冇。"
        ),
        ok = L(
          "Sender is Clone, Receiver is not: that is the mp and the sc in mpsc. Both tills feed one kitchen.",
          "Sender는 Clone, Receiver는 아님: 그게 mpsc의 mp와 sc. 두 계산대가 한 주방으로.",
          "Sender 係 Clone，Receiver 唔係：呢個就係 mpsc 嘅 mp 同 sc。兩個收銀餵一個廚房。"
        ),
      },
      {
        topic = "DROP",
        q = L(
          "for msg in rx ends only when every Sender is gone. How do you end tx early?",
          "for msg in rx는 Sender가 전부 사라져야 끝난다. tx를 일찍 끝내는 방법은?",
          "for msg in rx 要 Sender 全部冇咗先完。點樣早啲結束 tx？"
        ),
        code = L(
          [[
let (tx, rx) = mpsc::channel();
let tx2 = tx.clone();
thread::spawn(move || tx2.send("bun").unwrap());
___(tx);   // otherwise the loop below never ends
for msg in rx { println!("{msg}"); }
]],
          [[
let (tx, rx) = mpsc::channel();
let tx2 = tx.clone();
thread::spawn(move || tx2.send("bun").unwrap());
___(tx);   // 아니면 아래 루프가 끝나지 않는다
for msg in rx { println!("{msg}"); }
]],
          [[
let (tx, rx) = mpsc::channel();
let tx2 = tx.clone();
thread::spawn(move || tx2.send("bun").unwrap());
___(tx);   // 唔係下面個 loop 永遠唔完
for msg in rx { println!("{msg}"); }
]]
        ),
        accept = { "drop", "std::mem::drop", "mem::drop" },
        answer = "drop",
        hint = L(
          "Four letters. Let go of it now instead of at the end of scope.",
          "네 글자. 스코프 끝이 아니라 지금 놓아버린다.",
          "四個字母。而家就放手，唔等 scope 完。"
        ),
        ok = L(
          "drop(tx) runs Drop now. tx2 is dropped when its thread ends; with both gone, rx sees the end and the for loop stops.",
          "drop(tx)는 Drop을 지금 실행. tx2는 스레드가 끝날 때 drop; 둘 다 없어지면 rx가 끝을 보고 for 루프가 멈춘다.",
          "drop(tx) 即刻行 Drop。tx2 喺條 thread 完嗰陣 drop；兩個都冇咗，rx 見到尾，for loop 就停。"
        ),
      },
      {
        topic = "TRY_RECV",
        q = L(
          "Check for an order without waiting; the till must keep beeping. Which method?",
          "기다리지 않고 주문을 확인; 계산대는 계속 삐 해야 한다. 메서드는?",
          "唔等就 check 有冇單；收銀要繼續嗶。邊個 method？"
        ),
        code = L(
          [[
// Peek without waiting: the till must keep beeping.
match rx.___() {
    Ok(order) => println!("got {order}"),
    Err(_) => println!("nothing yet"),
}
]],
          [[
// 안 기다리고 살핀다: 계산대는 계속 삐.
match rx.___() {
    Ok(order) => println!("got {order}"),
    Err(_) => println!("nothing yet"),
}
]],
          [[
// 唔等就望一眼：收銀要繼續嗶。
match rx.___() {
    Ok(order) => println!("got {order}"),
    Err(_) => println!("nothing yet"),
}
]]
        ),
        accept = { "try_recv" },
        answer = "try_recv",
        hint = L(
          "try, underscore, then the blocking method's name.",
          "try, 밑줄, 그다음 막는 메서드의 이름.",
          "try，底線，然後係會阻塞嗰個 method 嘅名。"
        ),
        ok = L(
          "try_recv() returns at once: Ok(v), Err(Empty) or Err(Disconnected). Good for polling loops; recv_timeout is the middle road.",
          "try_recv()는 바로 반환: Ok(v), Err(Empty), Err(Disconnected). 폴링 루프에 좋다; recv_timeout은 중간 길.",
          "try_recv() 即刻回傳：Ok(v)、Err(Empty) 或 Err(Disconnected)。適合 polling loop；recv_timeout 係中間路線。"
        ),
      },
      {
        topic = "BOUNDED",
        q = L(
          "The pass holds three trays; a fourth send should wait. Which constructor?",
          "패스엔 트레이 셋; 네 번째 send는 기다려야 한다. 어떤 생성자?",
          "出餐台放得三個盤；第四個 send 要等。邊個 constructor？"
        ),
        code = L(
          [[
// The pass holds three trays: send blocks when full.
let (tx, rx) = mpsc::___(3);
tx.send("tray").unwrap();
]],
          [[
// 패스는 트레이 셋까지: 꽉 차면 send 막힘.
let (tx, rx) = mpsc::___(3);
tx.send("tray").unwrap();
]],
          [[
// 出餐台最多放三個盤：滿咗 send 就阻塞。
let (tx, rx) = mpsc::___(3);
tx.send("tray").unwrap();
]]
        ),
        accept = { "sync_channel", "mpsc::sync_channel" },
        answer = "sync_channel",
        hint = L(
          "sync, underscore, then the word for the pipe itself.",
          "sync, 밑줄, 그다음 파이프 자체를 뜻하는 단어.",
          "sync，底線，然後係條管本身嗰個字。"
        ),
        ok = L(
          "sync_channel(n) is bounded: send blocks when n values wait. Backpressure, like a buffered Go channel. The queue moves.",
          "sync_channel(n)은 유계: 값 n개가 대기 중이면 send가 막힌다. 배압, Go의 버퍼 채널처럼. 줄이 움직인다.",
          "sync_channel(n) 有上限：n 個值等住嗰陣 send 會阻塞。backpressure，好似 Go 有 buffer 嘅 channel。條隊郁咗。"
        ),
      },
    },
  },

  {
    id = "rs_sync",
    station = "SYNC",
    name = L("The shared till", "공유 계산대", "共用收銀"),
    title = L("Arc, Mutex and atomics", "Arc, Mutex, 아토믹", "Arc、Mutex 同 atomic"),
    lesson = L(
      "Arc shares ownership across threads; Mutex guards changes; atomics count without a lock.",
      "Arc는 스레드 사이에 소유권을 공유; Mutex는 변경을 지킨다; 아토믹은 락 없이 센다.",
      "Arc 跨 thread 共享 ownership；Mutex 守住修改；atomic 唔使 lock 都數得。"
    ),
    bg = "bg_till",
    portrait = "portrait_friends",
    speaker = L("Mei", "메이", "阿美"),
    ground = 348,
    spawn = 180,
    width = 1600,
    npcs = {
      {
        kind = "clerk",
        x = 520,
        facing = 1,
        line = L(
          "Both tills add to one sold counter and the number is wrong every time.",
          "두 계산대가 판매 카운터 하나에 더하는데 숫자가 매번 틀려.",
          "兩個收銀都加同一個 sold counter，個數次次都錯。"
        ),
      },
      {
        kind = "mei",
        x = 760,
        facing = -1,
        line = L(
          "Shared and mutable across threads: wrap it, then lock it.",
          "스레드 사이에 공유되고 변하는 것: 감싸고, 잠가.",
          "跨 thread 又共享又會改：包住佢，再 lock。"
        ),
      },
    },
    viz = "rust",
    chips = {
      { "Arc::new(Mutex::new(0))", "cyan" },
      { "x.lock().unwrap()", "gold" },
      { "RwLock .read()", "green" },
      { "fetch_add(1, SeqCst)", "pink" },
    },
    note = "Arc  Mutex  lock  RwLock  Atomic  Send  Sync",
    story = L(
      "17:00. Last hour before the tea set. Both tills bump one sold counter from two threads and the total drifts. "
        .. "Rc will not even compile across threads; Mei reaches for Arc, Mutex and one atomic. "
        .. "Get it right and the afternoon tea set is yours.",
      "17:00. 티 세트까지 마지막 한 시간. 두 계산대가 스레드 둘에서 판매 카운터 하나를 올리는데 합계가 어긋난다. "
        .. "Rc는 스레드를 넘으면 컴파일도 안 된다; 메이가 Arc, Mutex, 아토믹 하나를 꺼낸다. 맞히면 애프터눈 티 세트는 네 것.",
      "下晝五點。茶餐套餐前最後一個鐘。兩個收銀由兩條 thread 加同一個 sold counter，總數走晒樣。"
        .. "Rc 跨 thread 連 compile 都唔過；阿美攞出 Arc、Mutex 同一個 atomic。做得對，下午茶套餐就係你嘅。"
    ),
    stages = {
      {
        topic = "ARC",
        q = L(
          "Rc counts on one thread only. Which shared pointer may cross threads?",
          "Rc는 한 스레드에서만 센다. 스레드를 넘을 수 있는 공유 포인터는?",
          "Rc 只喺一條 thread 上數。邊個共享 pointer 可以跨 thread？"
        ),
        code = L(
          [[
// Rc counts on one thread only; this one crosses threads.
let menu = ___::new(vec!["bun", "egg tart"]);
let m2 = menu.clone();
thread::spawn(move || println!("{}", m2[0]));
]],
          [[
// Rc는 한 스레드용; 이건 스레드를 넘는다.
let menu = ___::new(vec!["bun", "egg tart"]);
let m2 = menu.clone();
thread::spawn(move || println!("{}", m2[0]));
]],
          [[
// Rc 只喺一條 thread 上數；呢個可以跨 thread。
let menu = ___::new(vec!["bun", "egg tart"]);
let m2 = menu.clone();
thread::spawn(move || println!("{}", m2[0]));
]]
        ),
        accept = { "Arc", "std::sync::Arc", "sync::Arc" },
        answer = "Arc",
        hint = L(
          "Three letters: Atomic Reference Counted.",
          "세 글자: Atomic Reference Counted.",
          "三個字母：Atomic Reference Counted。"
        ),
        ok = L(
          "Arc<T> counts references atomically, so clones may live on different threads. Rc is cheaper but not Send.",
          "Arc<T>는 참조를 원자적으로 세므로 clone이 다른 스레드에 있어도 된다. Rc는 더 싸지만 Send가 아니다.",
          "Arc<T> 用 atomic 方式數 reference，所以 clone 可以喺唔同 thread。Rc 平啲但唔係 Send。"
        ),
      },
      {
        topic = "MUTEX",
        q = L(
          "One counter, changed by many threads. Which wrapper allows only one writer at a time?",
          "카운터 하나를 여러 스레드가 바꾼다. 한 번에 한 쓰기만 허용하는 래퍼는?",
          "一個 counter，好多 thread 改。邊個 wrapper 一次只准一個寫？"
        ),
        code = L(
          [[
// One counter, many cooks: one writer at a time.
let sold = Arc::new(___::new(0u32));
]],
          [[
// 카운터 하나, 요리사 여럿: 한 번에 한 명.
let sold = Arc::new(___::new(0u32));
]],
          [[
// 一個 counter，好多 cook：一次一個寫。
let sold = Arc::new(___::new(0u32));
]]
        ),
        accept = { "Mutex", "std::sync::Mutex", "sync::Mutex" },
        answer = "Mutex",
        hint = L(
          "Five letters, short for mutual exclusion.",
          "다섯 글자, mutual exclusion의 줄임말.",
          "五個字母，mutual exclusion 嘅縮寫。"
        ),
        ok = L(
          "Arc<Mutex<T>> is the shared-and-mutable idiom. Arc shares, Mutex guards; neither alone is enough.",
          "Arc<Mutex<T>>가 공유하며 변경하는 관용구. Arc는 공유, Mutex는 보호; 하나만으론 부족.",
          "Arc<Mutex<T>> 係「共享又可改」嘅慣用寫法。Arc 共享，Mutex 守住；單靠一個都唔夠。"
        ),
      },
      {
        topic = "LOCK",
        q = L(
          "Get the guard so you can change the counter. Which method?",
          "카운터를 바꾸려면 가드를 얻어야 한다. 메서드는?",
          "要改 counter 就要攞 guard。邊個 method？"
        ),
        code = L(
          [[
let sold = Arc::new(Mutex::new(0u32));
// Take the guard; it opens again when it goes out of scope.
let mut n = sold.___().unwrap();
*n += 1;
]],
          [[
let sold = Arc::new(Mutex::new(0u32));
// 가드를 잡는다; 스코프 끝에 다시 열린다.
let mut n = sold.___().unwrap();
*n += 1;
]],
          [[
let sold = Arc::new(Mutex::new(0u32));
// 攞 guard；出咗 scope 就自動打開。
let mut n = sold.___().unwrap();
*n += 1;
]]
        ),
        accept = { "lock" },
        answer = "lock",
        hint = L(
          "Four letters. What you do to the drawer at closing time.",
          "네 글자. 마감 때 서랍에 하는 것.",
          "四個字母。收工嗰陣對櫃桶做嘅事。"
        ),
        ok = L(
          "lock() returns a MutexGuard; unwrap fails only if another thread panicked while holding it. The guard unlocks on drop.",
          "lock()은 MutexGuard를 반환; unwrap은 다른 스레드가 잡은 채 panic했을 때만 실패. 가드는 drop될 때 풀린다.",
          "lock() 回傳 MutexGuard；只有另一條 thread 揸住佢 panic 咗 unwrap 先會失敗。guard drop 嗰陣自動解鎖。"
        ),
      },
      {
        topic = "ARC CLONE",
        q = L(
          "Each thread needs its own handle to the same counter. Which call makes one from &sold?",
          "각 스레드엔 같은 카운터를 가리키는 자기 핸들이 필요. &sold에서 하나 만드는 호출은?",
          "每條 thread 都要有自己嘅 handle 指住同一個 counter。邊個呼叫由 &sold 造一個？"
        ),
        code = L(
          [[
let sold = Arc::new(Mutex::new(0u32));
// Each thread needs its own handle to the same counter.
let mine = ___(&sold);
thread::spawn(move || { *mine.lock().unwrap() += 1; });
]],
          [[
let sold = Arc::new(Mutex::new(0u32));
// 스레드마다 같은 카운터의 핸들이 필요.
let mine = ___(&sold);
thread::spawn(move || { *mine.lock().unwrap() += 1; });
]],
          [[
let sold = Arc::new(Mutex::new(0u32));
// 每條 thread 要自己嘅 handle 指住同一個數。
let mine = ___(&sold);
thread::spawn(move || { *mine.lock().unwrap() += 1; });
]]
        ),
        accept = { "Arc::clone", "Arc :: clone" },
        answer = "Arc::clone",
        hint = L(
          "Type name, two colons, the method that copies a handle.",
          "타입 이름, 콜론 둘, 핸들을 복사하는 메서드.",
          "type 名，兩個冒號，複製 handle 嗰個 method。"
        ),
        ok = L(
          "Arc::clone(&sold) bumps the count, never copies the data. Same as sold.clone(), but the full path shows it is cheap.",
          "Arc::clone(&sold)는 카운트만 올리고 데이터는 복사하지 않는다. sold.clone()과 같지만 전체 경로가 싸다는 걸 보여준다.",
          "Arc::clone(&sold) 只加個數，唔會複製資料。同 sold.clone() 一樣，但寫全名顯示佢好平。"
        ),
      },
      {
        topic = "RWLOCK",
        q = L(
          "The menu is read often, written rarely. Which method takes a shared read guard?",
          "메뉴는 자주 읽고 드물게 쓴다. 공유 읽기 가드를 얻는 메서드는?",
          "menu 成日睇，好少改。邊個 method 攞一個共享嘅讀 guard？"
        ),
        code = L(
          [[
use std::sync::RwLock;
let menu = RwLock::new(vec!["bun", "egg tart"]);
// Many may look at once; only .write() has to wait.
let first = menu.___().unwrap()[0];
]],
          [[
use std::sync::RwLock;
let menu = RwLock::new(vec!["bun", "egg tart"]);
// 여럿이 동시에 본다; .write()만 기다린다.
let first = menu.___().unwrap()[0];
]],
          [[
use std::sync::RwLock;
let menu = RwLock::new(vec!["bun", "egg tart"]);
// 好多人可以同時睇；只有 .write() 要等。
let first = menu.___().unwrap()[0];
]]
        ),
        accept = { "read" },
        answer = "read",
        hint = L(
          "Four letters. What you do to a menu.",
          "네 글자. 메뉴에 하는 것.",
          "四個字母。你對 menu 做嘅事。"
        ),
        ok = L(
          "RwLock: many .read() guards at once, or one .write(). Use it when reads far outnumber writes; Mutex is simpler otherwise.",
          "RwLock: .read() 가드는 동시에 여럿, .write()는 하나. 읽기가 쓰기보다 훨씬 많을 때; 아니면 Mutex가 단순하다.",
          "RwLock：.read() guard 可以同時好多個，.write() 只得一個。讀遠多過寫嗰陣用；否則 Mutex 簡單啲。"
        ),
      },
      {
        topic = "ATOMIC",
        q = L(
          "Add one to the served count with no lock at all. Which atomic method?",
          "락 없이 served 카운트에 1을 더한다. 어떤 아토믹 메서드?",
          "完全唔用 lock 就加一去 served count。邊個 atomic method？"
        ),
        code = L(
          [[
use std::sync::atomic::{AtomicUsize, Ordering};
static SERVED: AtomicUsize = AtomicUsize::new(0);
// No lock needed: add one in a single hardware step.
SERVED.___(1, Ordering::SeqCst);
]],
          [[
use std::sync::atomic::{AtomicUsize, Ordering};
static SERVED: AtomicUsize = AtomicUsize::new(0);
// 락 불필요: 하드웨어 한 단계로 1을 더한다.
SERVED.___(1, Ordering::SeqCst);
]],
          [[
use std::sync::atomic::{AtomicUsize, Ordering};
static SERVED: AtomicUsize = AtomicUsize::new(0);
// 唔使 lock：一步硬件操作加一。
SERVED.___(1, Ordering::SeqCst);
]]
        ),
        accept = { "fetch_add" },
        answer = "fetch_add",
        hint = L(
          "fetch, underscore, then the arithmetic you want.",
          "fetch, 밑줄, 그다음 원하는 연산.",
          "fetch，底線，然後係你想做嘅算術。"
        ),
        ok = L(
          "fetch_add(1, Ordering::SeqCst) adds and returns the old value atomically. SeqCst is the strictest, simplest ordering.",
          "fetch_add(1, Ordering::SeqCst)는 원자적으로 더하고 이전 값을 반환. SeqCst는 가장 엄격하고 단순한 순서.",
          "fetch_add(1, Ordering::SeqCst) 用 atomic 方式加數並回傳舊值。SeqCst 係最嚴、最簡單嘅 ordering。"
        ),
      },
      {
        topic = "SEND",
        q = L(
          "Only types with this marker trait may move to another thread. Which one?",
          "이 마커 트레이트가 있는 타입만 다른 스레드로 옮겨진다. 무엇?",
          "只有帶呢個 marker trait 嘅 type 先可以搬去另一條 thread。係邊個？"
        ),
        code = L(
          [[
// Only types with this marker may move to another thread.
fn ship<T: ___ + 'static>(t: T) {
    thread::spawn(move || drop(t));
}
ship(Arc::new(5));    // ok: Arc is thread-safe
// ship(Rc::new(5));  // error: Rc is not
]],
          [[
// 이 마커가 있는 타입만 스레드를 넘는다.
fn ship<T: ___ + 'static>(t: T) {
    thread::spawn(move || drop(t));
}
ship(Arc::new(5));    // 됨: Arc는 스레드 안전
// ship(Rc::new(5));  // 에러: Rc는 아님
]],
          [[
// 有呢個 marker 嘅 type 先搬得去另一條 thread。
fn ship<T: ___ + 'static>(t: T) {
    thread::spawn(move || drop(t));
}
ship(Arc::new(5));    // 得：Arc 係 thread-safe
// ship(Rc::new(5));  // error：Rc 唔係
]]
        ),
        accept = { "Send" },
        answer = "Send",
        hint = L(
          "Four letters. What you do with a parcel.",
          "네 글자. 소포에 하는 것.",
          "四個字母。對包裹做嘅事。"
        ),
        ok = L(
          "Send: safe to move to another thread. Sync: safe to share by &T. Rc has neither, Arc<T> has both when T does. The count is right. Milk tea and a pineapple bun: the afternoon tea set is yours.",
          "Send: 다른 스레드로 옮겨도 안전. Sync: &T로 공유해도 안전. Rc는 둘 다 없고, Arc<T>는 T가 되면 둘 다 된다. 숫자가 맞는다. 밀크티와 파인애플 번: 애프터눈 티 세트는 네 것.",
          "Send：搬去另一條 thread 安全。Sync：用 &T 共享安全。Rc 兩樣都冇，Arc<T> 喺 T 有嗰陣兩樣都有。個數對咗。奶茶加菠蘿包：下午茶套餐係你嘅。"
        ),
      },
    },
  },
}

return maps
