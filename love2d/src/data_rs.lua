-- Quest R1 BASIC: RUST SET - the walk. 15:00, after lunch. Mei walks Alex
-- from Lucky Mac to Lucky Mac Express in Times Square; every Rust kiosk on
-- the way is stuck. First contact with Rust for someone who knows a bit of Go.
--
-- Text fields are L(en, ko, yue) tables. Code is the same Rust in every
-- language; only comments are translated. Max 7 lines per code block.

local function L(en, ko, yue)
  return { en = en, ko = ko, yue = yue }
end

local maps = {
  {
    id = "rs_main",
    station = "MAIN",
    name = L("Lucky Mac, table 4", "럭키 맥 4번 테이블", "幸運麥四號枱"),
    title = L("Hello, Rust", "안녕, Rust", "Hello，Rust"),
    lesson = L(
      "fn main is the entry. println! is a macro. use brings a type in. cargo run builds and runs.",
      "fn main이 진입점. println!은 매크로. use로 타입을 가져온다. cargo run은 빌드 후 실행.",
      "fn main 係入口。println! 係 macro。use 帶入 type。cargo run 一次過 build 同行。"
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
          "The Express kiosks run Rust. Finish your coffee, I will show you main.",
          "익스프레스 키오스크는 Rust야. 커피 마저 마셔, main부터 보여줄게.",
          "Express 部機係 Rust。飲完杯咖啡，我先教你 main。"
        ),
      },
      {
        kind = "hero",
        x = 660,
        facing = 1,
        line = L(
          "Rust? I only know Go. Is it far?",
          "Rust? 나 Go밖에 몰라. 멀어?",
          "Rust？我只識 Go。遠唔遠？"
        ),
      },
    },
    viz = "rust",
    chips = {
      { "fn main() {}", "cyan" },
      { 'println!("{}", n);', "gold" },
      { "use std::env;", "pink" },
      { "$ cargo run", "green" },
    },
    note = "fn main  println!  {}  use  cargo run  //",
    story = L(
      "15:00. Lunch is done at Lucky Mac. Mei's laptop shows the Times Square branch: "
        .. "every kiosk of Lucky Mac Express is frozen on a Rust file with no main. "
        .. "Alex knows Go. Mei knows Rust. They start walking.",
      "15:00. 럭키 맥에서 점심을 마쳤다. 메이의 노트북에 타임스퀘어 지점이 뜬다. "
        .. "럭키 맥 익스프레스의 모든 키오스크가 main 없는 Rust 파일에서 멈췄다. "
        .. "알렉스는 Go를 안다. 메이는 Rust를 안다. 둘은 걷기 시작한다.",
      "下晝三點。幸運麥食完晏。阿美部電腦顯示時代廣場分店："
        .. "幸運麥 Express 每部機都卡喺一個冇 main 嘅 Rust 檔。"
        .. "阿力識 Go。阿美識 Rust。兩個人開始行。"
    ),
    stages = {
      {
        topic = "MAIN",
        q = L(
          "Every Rust program starts in which function?",
          "모든 Rust 프로그램은 어떤 함수에서 시작하나요?",
          "每個 Rust 程式由邊個 function 開始？"
        ),
        code = L(
          [[
// The entry point of a binary crate.
fn ___() {
    println!("Lucky Mac Express");
}
]],
          [[
// 바이너리 크레이트의 진입점.
fn ___() {
    println!("Lucky Mac Express");
}
]],
          [[
// binary crate 嘅入口。
fn ___() {
    println!("Lucky Mac Express");
}
]]
        ),
        accept = { "main" },
        answer = "main",
        hint = L(
          "Same name as Go's entry function, but it needs no package line.",
          "Go의 진입 함수와 같은 이름. package 줄은 필요 없다.",
          "同 Go 嘅入口 function 同名，但唔使 package 嗰行。"
        ),
        ok = L(
          "fn main() is the entry. No package, no import needed to start. The screen wakes up.",
          "fn main()이 진입점. 시작에 package도 import도 필요 없다. 화면이 켜진다.",
          "fn main() 係入口。開始唔使 package，唔使 import。個 mon 亮咗。"
        ),
      },
      {
        topic = "COMMENT",
        q = L(
          "Rust ignores the rest of a line after which two characters?",
          "Rust는 어떤 두 글자 뒤의 나머지 줄을 무시하나요?",
          "Rust 會無視邊兩個字元之後嘅成行？"
        ),
        code = L(
          [[
fn main() {
    ___ print one line, then the kiosk unlocks
    println!("open 15:00");
}
]],
          [[
fn main() {
    ___ 한 줄 출력, 그러면 키오스크가 열린다
    println!("open 15:00");
}
]],
          [[
fn main() {
    ___ 印一行，部機就開
    println!("open 15:00");
}
]]
        ),
        accept = { "//" },
        answer = "//",
        hint = L(
          "Two slashes. Same as Go, C and JavaScript.",
          "슬래시 두 개. Go, C, JavaScript와 같다.",
          "兩條斜線。同 Go、C、JavaScript 一樣。"
        ),
        ok = L(
          "// starts a line comment. /// is a doc comment that cargo doc turns into pages.",
          "//는 한 줄 주석. ///는 cargo doc이 문서로 만드는 문서 주석.",
          "// 係單行註解。/// 係 doc 註解，cargo doc 會變成文檔。"
        ),
      },
      {
        topic = "MACRO",
        q = L(
          "println is a macro, not a function. Which character ends its name?",
          "println은 함수가 아니라 매크로. 이름 끝의 문자는?",
          "println 係 macro，唔係 function。名尾邊個字元？"
        ),
        code = L(
          [[
fn main() {
    // a macro expands to code before compiling
    println___("Lucky Mac Express");
}
]],
          [[
fn main() {
    // 매크로는 컴파일 전에 코드로 펼쳐진다
    println___("Lucky Mac Express");
}
]],
          [[
fn main() {
    // macro 喺 compile 之前展開成 code
    println___("Lucky Mac Express");
}
]]
        ),
        accept = { "!" },
        answer = "!",
        hint = L(
          "A bang. vec! and format! end the same way.",
          "느낌표. vec!과 format!도 같은 끝.",
          "感嘆號。vec! 同 format! 都係咁收尾。"
        ),
        ok = L(
          "The ! marks a macro call. Macros can take any number of arguments; functions cannot.",
          "!는 매크로 호출 표시. 매크로는 인자 개수가 자유롭고 함수는 아니다.",
          "! 代表 macro call。macro 可以收任意數量參數，function 唔得。"
        ),
      },
      {
        topic = "FORMAT",
        q = L(
          "Which placeholder inside the string prints the value of n?",
          "문자열 안에서 n의 값을 출력하는 자리표시자는?",
          "字串裏面邊個佔位符會印出 n 嘅值？"
        ),
        code = L(
          [[
fn main() {
    let n = 3;
    // prints: 3 muffins
    println!("___ muffins", n);
}
]],
          [[
fn main() {
    let n = 3;
    // 출력: 3 muffins
    println!("___ muffins", n);
}
]],
          [[
fn main() {
    let n = 3;
    // 印出：3 muffins
    println!("___ muffins", n);
}
]]
        ),
        accept = { "{}" },
        answer = "{}",
        hint = L(
          "Two braces with nothing inside. Not %d, not %v.",
          "안이 빈 중괄호 둘. %d도 %v도 아니다.",
          "兩個中括號，中間冇嘢。唔係 %d，唔係 %v。"
        ),
        ok = L(
          "{} uses Display. {:?} uses Debug. {n} reads a variable by name. Three muffins, printed.",
          "{}는 Display, {:?}는 Debug, {n}은 변수 이름으로 읽는다. 머핀 셋이 출력된다.",
          "{} 用 Display。{:?} 用 Debug。{n} 直接讀變數名。三個鬆餅，印咗。"
        ),
      },
      {
        topic = "USE",
        q = L(
          "Which keyword brings HashMap from the standard library into this file?",
          "표준 라이브러리의 HashMap을 이 파일로 가져오는 키워드는?",
          "邊個 keyword 將標準 library 嘅 HashMap 帶入呢個檔？"
        ),
        code = L(
          [[
___ std::collections::HashMap;

fn main() {
    let mut stock = HashMap::new();
    stock.insert("muffin", 4);
}
]],
          [[
___ std::collections::HashMap;

fn main() {
    let mut stock = HashMap::new();
    stock.insert("muffin", 4);
}
]],
          [[
___ std::collections::HashMap;

fn main() {
    let mut stock = HashMap::new();
    stock.insert("muffin", 4);
}
]]
        ),
        accept = { "use" },
        answer = "use",
        hint = L(
          "Three letters. Rust's word for Go's import, one path at a time.",
          "세 글자. Go의 import에 해당하는 Rust 단어, 경로 하나씩.",
          "三個字母。Rust 版嘅 Go import，一次一條 path。"
        ),
        ok = L(
          "use std::collections::HashMap; The :: walks the path. std is always there, no Cargo.toml line needed.",
          "use std::collections::HashMap; ::가 경로를 따라간다. std는 항상 있어 Cargo.toml 줄이 필요 없다.",
          "use std::collections::HashMap; :: 沿 path 行。std 一直都喺度，唔使加 Cargo.toml。"
        ),
      },
      {
        topic = "CARGO",
        q = L(
          "One cargo command builds the crate and starts it. Which word?",
          "크레이트를 빌드하고 바로 실행하는 cargo 명령 한 단어는?",
          "一句 cargo 指令 build 埋個 crate 再開行。邊個字？"
        ),
        code = L(
          [[
// In the terminal, inside the project folder:
//   $ cargo ___
// Compiles target/debug/express and starts it.
fn main() {
    println!("Lucky Mac Express");
}
]],
          [[
// 터미널, 프로젝트 폴더 안에서:
//   $ cargo ___
// target/debug/express를 컴파일하고 실행한다.
fn main() {
    println!("Lucky Mac Express");
}
]],
          [[
// 終端機，喺 project 資料夾入面：
//   $ cargo ___
// compile 出 target/debug/express 然後開行。
fn main() {
    println!("Lucky Mac Express");
}
]]
        ),
        accept = { "run" },
        answer = "run",
        hint = L(
          "Same verb as go run. cargo build only compiles.",
          "go run과 같은 동사. cargo build는 컴파일만 한다.",
          "同 go run 同一個動詞。cargo build 只係 compile。"
        ),
        ok = L(
          "cargo run. cargo new makes a project, cargo build compiles, cargo test runs tests. The kiosk boots.",
          "cargo run. cargo new는 프로젝트 생성, cargo build는 컴파일, cargo test는 테스트. 키오스크가 켜진다.",
          "cargo run。cargo new 開 project，cargo build compile，cargo test 行測試。部機開機咗。"
        ),
      },
    },
  },

  {
    id = "rs_let",
    station = "LET",
    name = L("Percival Street tram stop", "퍼시벌 스트리트 전차역", "波斯富街電車站"),
    title = L("Bindings, mutability and types", "바인딩, 가변성, 타입", "binding、可變同 type"),
    lesson = L(
      "let binds. mut allows change. const needs a type. as converts. A new let can shadow an old name.",
      "let은 바인딩, mut은 변경 허용, const는 타입 필수, as는 변환. 새 let은 옛 이름을 가릴 수 있다.",
      "let 綁定。mut 先可以改。const 一定要寫 type。as 轉換。新 let 可以遮住舊名。"
    ),
    bg = "bg_street",
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
          "Everything is immutable until you say mut. The tram sign forgot that.",
          "mut이라고 말하기 전까진 전부 불변이야. 전차 표지판이 그걸 잊었어.",
          "你唔講 mut，樣樣都係不可變。電車牌忘記咗呢件事。"
        ),
      },
    },
    viz = "rust",
    chips = {
      { "let mut n = 0;", "cyan" },
      { "const OPEN: u8 = 7;", "gold" },
      { "let x: i32 = 28;", "pink" },
      { "n as f64", "green" },
    },
    note = "let  mut  const  i32 f64 u8 usize  as  shadow",
    story = L(
      "15:08. The tram stop on Percival Street. The next-tram sign runs a tiny Rust program "
        .. "and it will not compile: someone tried to change a value that was never marked mut. "
        .. "Mei fixes it while Alex reads the error messages out loud.",
      "15:08. 퍼시벌 스트리트 전차역. 다음 전차 표지판은 작은 Rust 프로그램인데 컴파일이 안 된다. "
        .. "누가 mut 표시가 없는 값을 바꾸려 했다. 알렉스가 에러를 소리 내어 읽는 동안 메이가 고친다.",
      "下晝三點零八分。波斯富街電車站。下班電車嘅牌係一個好細嘅 Rust 程式，但 compile 唔到："
        .. "有人想改一個從來冇標 mut 嘅值。阿力大聲讀 error，阿美一路修。"
    ),
    stages = {
      {
        topic = "LET",
        q = L(
          "Which keyword binds a name to a value in Rust?",
          "Rust에서 이름을 값에 바인딩하는 키워드는?",
          "Rust 用邊個 keyword 將名綁到值？"
        ),
        code = L(
          [[
fn main() {
    ___ price = 28;      // a binding, fixed from now on
    println!("{}", price);
}
]],
          [[
fn main() {
    ___ price = 28;      // 바인딩, 이제부터 고정
    println!("{}", price);
}
]],
          [[
fn main() {
    ___ price = 28;      // binding，由而家開始固定
    println!("{}", price);
}
]]
        ),
        accept = { "let" },
        answer = "let",
        hint = L(
          "Three letters. Go has var and :=; Rust has one word for both.",
          "세 글자. Go의 var와 :=를 Rust는 한 단어로 쓴다.",
          "三個字母。Go 有 var 同 :=，Rust 一個字搞掂。"
        ),
        ok = L(
          "let price = 28; The type is inferred as i32. Without mut it can never change.",
          "let price = 28; 타입은 i32로 추론된다. mut이 없으면 절대 못 바꾼다.",
          "let price = 28; type 推斷成 i32。冇 mut 就永遠改唔到。"
        ),
      },
      {
        topic = "MUT",
        q = L(
          "count must go up. Which word after let allows the change?",
          "count가 올라가야 한다. let 뒤에 변경을 허용하는 단어는?",
          "count 要加。let 後面邊個字先容許改？"
        ),
        code = L(
          [[
fn main() {
    let ___ count = 0;
    count += 1;          // error without that word
    println!("{}", count);
}
]],
          [[
fn main() {
    let ___ count = 0;
    count += 1;          // 그 단어가 없으면 에러
    println!("{}", count);
}
]],
          [[
fn main() {
    let ___ count = 0;
    count += 1;          // 冇咗個字就 error
    println!("{}", count);
}
]]
        ),
        accept = { "mut" },
        answer = "mut",
        hint = L(
          "Three letters. Short for mutable, the opposite of the default.",
          "세 글자. mutable의 줄임말, 기본값의 반대.",
          "三個字母。mutable 嘅縮寫，同預設相反。"
        ),
        ok = L(
          "let mut count = 0; Immutable by default is Rust's first safety rule. The sign counts again.",
          "let mut count = 0; 기본 불변이 Rust의 첫 안전 규칙. 표지판이 다시 센다.",
          "let mut count = 0; 預設不可變係 Rust 第一條安全規則。個牌又數得返。"
        ),
      },
      {
        topic = "CONST",
        q = L(
          "A compile-time value with an UPPER_CASE name and a required type. Which keyword?",
          "대문자 이름과 필수 타입을 가진 컴파일 타임 값. 키워드는?",
          "大寫名、一定要寫 type 嘅 compile-time 值。邊個 keyword？"
        ),
        code = L(
          [[
___ OPEN: u8 = 7;        // hour the Express opens

fn main() {
    println!("opens at {}", OPEN);
}
]],
          [[
___ OPEN: u8 = 7;        // 익스프레스 여는 시각

fn main() {
    println!("opens at {}", OPEN);
}
]],
          [[
___ OPEN: u8 = 7;        // Express 開門嘅鐘數

fn main() {
    println!("opens at {}", OPEN);
}
]]
        ),
        accept = { "const" },
        answer = "const",
        hint = L(
          "Five letters, same as Go, but Rust insists on the : u8 part.",
          "다섯 글자, Go와 같다. 다만 Rust는 : u8 부분을 요구한다.",
          "五個字母，同 Go 一樣，但 Rust 一定要你寫 : u8。"
        ),
        ok = L(
          "const OPEN: u8 = 7; A const always has a type, never mut. u8 holds 0 to 255.",
          "const OPEN: u8 = 7; const는 항상 타입이 있고 mut은 없다. u8은 0부터 255.",
          "const OPEN: u8 = 7; const 一定有 type，永遠唔會 mut。u8 裝 0 到 255。"
        ),
      },
      {
        topic = "I32",
        q = L(
          "Signed, 32 bits, the default integer type. Write the annotation.",
          "부호 있는 32비트, 기본 정수 타입. 애너테이션을 쓰세요.",
          "有符號、32 bit、預設整數 type。寫個 annotation。"
        ),
        code = L(
          [[
fn main() {
    let seats: ___ = 40;     // type after the colon
    let price: f64 = 28.5;   // 64-bit float
    println!("{} {}", seats, price);
}
]],
          [[
fn main() {
    let seats: ___ = 40;     // 콜론 뒤에 타입
    let price: f64 = 28.5;   // 64비트 실수
    println!("{} {}", seats, price);
}
]],
          [[
fn main() {
    let seats: ___ = 40;     // 冒號後面明寫 type
    let price: f64 = 28.5;   // 64-bit 浮點
    println!("{} {}", seats, price);
}
]]
        ),
        accept = { "i32" },
        answer = "i32",
        hint = L(
          "i for integer (signed), then the bit width. u32 is the unsigned twin.",
          "i는 부호 있는 정수, 그다음 비트 수. u32는 부호 없는 쌍.",
          "i 係 signed integer，後面係 bit 數。u32 係無符號嘅孿生兄弟。"
        ),
        ok = L(
          "i8 i16 i32 i64 i128, u8 to u128, f32 f64, bool, char. Number types are spelled by size.",
          "i8 i16 i32 i64 i128, u8부터 u128, f32 f64, bool, char. 숫자 타입은 크기로 적는다.",
          "i8 i16 i32 i64 i128，u8 到 u128，f32 f64，bool，char。數字 type 用大細嚟串。"
        ),
      },
      {
        topic = "AS",
        q = L(
          "seats is an i32 but the division needs a float. Which keyword converts it?",
          "seats는 i32인데 나눗셈에 실수가 필요하다. 변환 키워드는?",
          "seats 係 i32，但除法要浮點。邊個 keyword 轉換？"
        ),
        code = L(
          [[
fn main() {
    let seats: i32 = 40;
    let per_row = seats ___ f64 / 3.0;   // 13.333
    println!("{}", per_row);
}
]],
          [[
fn main() {
    let seats: i32 = 40;
    let per_row = seats ___ f64 / 3.0;   // 13.333
    println!("{}", per_row);
}
]],
          [[
fn main() {
    let seats: i32 = 40;
    let per_row = seats ___ f64 / 3.0;   // 13.333
    println!("{}", per_row);
}
]]
        ),
        accept = { "as" },
        answer = "as",
        hint = L(
          "Two letters. Rust never converts numbers silently; you write the cast.",
          "두 글자. Rust는 숫자를 몰래 바꾸지 않는다. 캐스트를 직접 쓴다.",
          "兩個字母。Rust 唔會偷偷轉數字，你要自己寫 cast。"
        ),
        ok = L(
          "seats as f64. i32 / f64 does not compile in Rust; as makes the intent explicit.",
          "seats as f64. Rust에서 i32 / f64는 컴파일되지 않는다. as가 의도를 드러낸다.",
          "seats as f64。Rust 入面 i32 / f64 compile 唔到，as 令意圖清楚。"
        ),
      },
      {
        topic = "USIZE",
        q = L(
          "The length of any collection has which unsigned, pointer-sized type?",
          "모든 컬렉션의 길이는 어떤 부호 없는 포인터 크기 타입인가요?",
          "任何 collection 嘅長度係邊個無符號、pointer 咁大嘅 type？"
        ),
        code = L(
          [[
fn main() {
    let name = "muffin";
    let n: ___ = name.len();   // 6
    let n = n + 1;             // shadowing: a new n
    println!("{}", n);
}
]],
          [[
fn main() {
    let name = "muffin";
    let n: ___ = name.len();   // 6
    let n = n + 1;             // 섀도잉: 새로운 n
    println!("{}", n);
}
]],
          [[
fn main() {
    let name = "muffin";
    let n: ___ = name.len();   // 6
    let n = n + 1;             // shadowing：一個新嘅 n
    println!("{}", n);
}
]]
        ),
        accept = { "usize" },
        answer = "usize",
        hint = L(
          "u for unsigned, then the word size. It is also the type used to index a Vec.",
          "u는 부호 없음, 그다음 size라는 단어. Vec의 인덱스 타입도 이것.",
          "u 係無符號，後面係 size 呢個字。Vec 用嚟索引嘅 type 都係佢。"
        ),
        ok = L(
          "len() returns usize. The second let shadows n with a new binding; the old one is gone. Next tram in 7.",
          "len()은 usize를 반환. 두 번째 let은 n을 새 바인딩으로 가리고 옛것은 사라진다. 다음 전차 7분 후.",
          "len() 回傳 usize。第二個 let 用新 binding 遮住 n，舊嘅冇咗。下班電車七分鐘。"
        ),
      },
    },
  },

  {
    id = "rs_flow",
    station = "FLOW",
    name = L("MTR exit A, the underpass", "MTR A출구 지하통로", "地鐵 A 出口隧道"),
    title = L("if, loops and match", "if, 반복문, match", "if、loop 同 match"),
    lesson = L(
      "if is an expression. loop can break with a value. for walks a range. match must cover every case.",
      "if는 표현식. loop는 값을 들고 break할 수 있다. for는 범위를 돈다. match는 모든 경우를 덮어야 한다.",
      "if 係 expression。loop 可以帶住值 break。for 行 range。match 一定要包齊所有情況。"
    ),
    bg = "bg_mtr",
    portrait = "portrait_friends",
    speaker = L("Mei", "메이", "阿美"),
    ground = 348,
    spawn = 180,
    width = 1600,
    npcs = {
      {
        kind = "mei",
        x = 540,
        facing = -1,
        line = L(
          "In Rust, if gives back a value. No ternary needed. The gate forgot its else.",
          "Rust에선 if가 값을 돌려줘. 삼항 연산자 필요 없어. 게이트가 else를 빼먹었어.",
          "Rust 嘅 if 會俾返一個值。唔使三元運算。閘機漏咗個 else。"
        ),
      },
      {
        kind = "hero",
        x = 700,
        facing = 1,
        line = L(
          "A loop that returns a value? Go cannot do that.",
          "값을 반환하는 loop? Go는 못 해.",
          "loop 會回傳值？Go 做唔到。"
        ),
      },
    },
    viz = "rust",
    chips = {
      { "let n = if a > b {a}", "cyan" },
      { "for i in 0..3 {}", "gold" },
      { "break tries * 10;", "pink" },
      { '_ => "set",', "green" },
    },
    note = "if  loop break  while  for ..  ..=  match => _",
    story = L(
      "15:15. The underpass at Causeway Bay MTR exit A. The Lucky Mac Express ad gate should show "
        .. "muffin, coffee or set as people walk past, but its match has a hole and the loop never ends. "
        .. "Mei counts the cases on her fingers.",
      "15:15. 코즈웨이베이 MTR A출구 지하통로. 럭키 맥 익스프레스 광고 게이트는 지나가는 사람에게 "
        .. "머핀, 커피, 세트를 보여줘야 하는데 match에 빈 구멍이 있고 loop는 끝나지 않는다. "
        .. "메이가 손가락으로 경우를 센다.",
      "下晝三點十五分。銅鑼灣地鐵 A 出口隧道。幸運麥 Express 嘅廣告閘應該喺人行過嗰陣顯示"
        .. "鬆餅、咖啡或者套餐，但個 match 有個窿，個 loop 永遠唔停。阿美用手指數情況。"
    ),
    stages = {
      {
        topic = "IF",
        q = L(
          "Pick the bigger of a and b in one line. Which keyword starts the expression?",
          "a와 b 중 큰 값을 한 줄로 고른다. 표현식을 시작하는 키워드는?",
          "一行揀 a 同 b 邊個大。邊個 keyword 開始呢個 expression？"
        ),
        code = L(
          [[
fn main() {
    let (a, b) = (18, 22);
    // no parentheses, no ternary: the value is the block
    let n = ___ a > b { a } else { b };
    println!("{}", n);
}
]],
          [[
fn main() {
    let (a, b) = (18, 22);
    // 삼항 연산자 없음: 블록이 곧 값
    let n = ___ a > b { a } else { b };
    println!("{}", n);
}
]],
          [[
fn main() {
    let (a, b) = (18, 22);
    // 冇括號，冇三元運算：個 block 就係值
    let n = ___ a > b { a } else { b };
    println!("{}", n);
}
]]
        ),
        accept = { "if" },
        answer = "if",
        hint = L(
          "Two letters. In Rust it is an expression, so it can sit after =.",
          "두 글자. Rust에선 표현식이라 = 뒤에 올 수 있다.",
          "兩個字母。Rust 入面係 expression，所以可以放喺 = 後面。"
        ),
        ok = L(
          "let n = if a > b { a } else { b }; Both branches must have the same type. n is 22.",
          "let n = if a > b { a } else { b }; 두 분기의 타입이 같아야 한다. n은 22.",
          "let n = if a > b { a } else { b }; 兩邊 type 要一樣。n 係 22。"
        ),
      },
      {
        topic = "LOOP",
        q = L(
          "Repeat forever until break hands back a value. Which keyword?",
          "break가 값을 돌려줄 때까지 무한 반복. 키워드는?",
          "無限重複，直到 break 交返個值。邊個 keyword？"
        ),
        code = L(
          [[
let mut tries = 0;
let code = ___ {
    tries += 1;
    if tries == 3 { break tries * 10; }
};
println!("{}", code);   // 30
]],
          [[
let mut tries = 0;
let code = ___ {
    tries += 1;
    if tries == 3 { break tries * 10; }
};
println!("{}", code);   // 30
]],
          [[
let mut tries = 0;
let code = ___ {
    tries += 1;
    if tries == 3 { break tries * 10; }
};
println!("{}", code);   // 30
]]
        ),
        accept = { "loop" },
        answer = "loop",
        hint = L(
          "Four letters. Go writes for { } with no condition; Rust has a word for it.",
          "네 글자. Go는 조건 없는 for { }를 쓰고 Rust는 전용 단어가 있다.",
          "四個字母。Go 寫冇條件嘅 for { }，Rust 有專用嘅字。"
        ),
        ok = L(
          "loop { ... break value; } is an expression. code becomes 30. The gate stops spinning.",
          "loop { ... break 값; }은 표현식. code는 30이 된다. 게이트가 멈춘다.",
          "loop { ... break 值; } 係 expression。code 變成 30。閘機唔再轉。"
        ),
      },
      {
        topic = "WHILE",
        q = L(
          "Repeat while a condition holds. Which keyword?",
          "조건이 참인 동안 반복. 키워드는?",
          "條件成立就一直重複。邊個 keyword？"
        ),
        code = L(
          [[
let mut left = 3;
___ left > 0 {
    left -= 1;
    if left == 1 { continue; }   // skip this round
    println!("{}", left);
}
]],
          [[
let mut left = 3;
___ left > 0 {
    left -= 1;
    if left == 1 { continue; }   // 이번 회차 건너뜀
    println!("{}", left);
}
]],
          [[
let mut left = 3;
___ left > 0 {
    left -= 1;
    if left == 1 { continue; }   // 跳過呢一轉
    println!("{}", left);
}
]]
        ),
        accept = { "while" },
        answer = "while",
        hint = L(
          "Five letters. The same word as in C and Python; Go spells it for.",
          "다섯 글자. C와 Python과 같은 단어. Go는 for라고 쓴다.",
          "五個字母。同 C 同 Python 一樣嘅字，Go 寫做 for。"
        ),
        ok = L(
          "while left > 0 { } Prints 2 then 0. continue jumps to the next check, break leaves.",
          "while left > 0 { } 2 다음 0을 출력. continue는 다음 검사로, break는 밖으로.",
          "while left > 0 { } 印 2 再印 0。continue 跳去下一次檢查，break 走人。"
        ),
      },
      {
        topic = "RANGE",
        q = L(
          "0..3 stops before 3. Which range operator includes the last number?",
          "0..3은 3 앞에서 멈춘다. 마지막 숫자를 포함하는 범위 연산자는?",
          "0..3 去到 3 之前停。邊個 range 運算符包埋最後一個數？"
        ),
        code = L(
          [[
fn main() {
    for i in 0..3 { print!("{} ", i); }    // 0 1 2
    for i in 1___3 { print!("{} ", i); }    // 1 2 3
    println!();
}
]],
          [[
fn main() {
    for i in 0..3 { print!("{} ", i); }    // 0 1 2
    for i in 1___3 { print!("{} ", i); }    // 1 2 3
    println!();
}
]],
          [[
fn main() {
    for i in 0..3 { print!("{} ", i); }    // 0 1 2
    for i in 1___3 { print!("{} ", i); }    // 1 2 3
    println!();
}
]]
        ),
        accept = { "..=" },
        answer = "..=",
        hint = L(
          "Two dots, then the sign that says equal too.",
          "점 두 개, 그다음 같음도 뜻하는 기호.",
          "兩點，再加一個表示等於埋嘅符號。"
        ),
        ok = L(
          "1..=3 is 1, 2, 3. for in Rust walks anything iterable: ranges, Vec, iterators.",
          "1..=3은 1, 2, 3. Rust의 for는 범위, Vec, 이터레이터 등 반복 가능한 모든 것을 돈다.",
          "1..=3 係 1、2、3。Rust 嘅 for 行任何 iterable：range、Vec、iterator。"
        ),
      },
      {
        topic = "MATCH",
        q = L(
          "Compare code against several patterns and pick one arm. Which keyword?",
          "code를 여러 패턴과 비교해 한 팔을 고른다. 키워드는?",
          "將 code 同幾個 pattern 比較，揀一條 arm。邊個 keyword？"
        ),
        code = L(
          [[
fn main() {
    let code = 2;
    let item = ___ code {
        1 => "muffin",
        2 => "coffee",
        _ => "set",
    };
]],
          [[
fn main() {
    let code = 2;
    let item = ___ code {
        1 => "muffin",
        2 => "coffee",
        _ => "set",
    };
]],
          [[
fn main() {
    let code = 2;
    let item = ___ code {
        1 => "muffin",
        2 => "coffee",
        _ => "set",
    };
]]
        ),
        accept = { "match" },
        answer = "match",
        hint = L(
          "Five letters. Go's switch, but exhaustive and it returns a value.",
          "다섯 글자. Go의 switch지만 빠짐없이 다뤄야 하고 값을 반환한다.",
          "五個字母。Go 嘅 switch，但要包齊，仲會回傳值。"
        ),
        ok = L(
          "match code { 1 => ..., _ => ... } Each arm is pattern => value. The compiler checks every case is covered.",
          "match code { 1 => ..., _ => ... } 각 팔은 패턴 => 값. 컴파일러가 모든 경우를 덮었는지 확인한다.",
          "match code { 1 => ..., _ => ... } 每條 arm 係 pattern => 值。compiler 會檢查有冇包齊。"
        ),
      },
      {
        topic = "WILDCARD",
        q = L(
          "The last arm must catch every other number. Which pattern matches anything?",
          "마지막 팔은 나머지 모든 숫자를 잡아야 한다. 무엇이든 맞는 패턴은?",
          "最後一條 arm 要接住其他所有數。邊個 pattern 乜都 match？"
        ),
        code = L(
          [[
fn main() {
    let code = 9;
    let item = match code {
        1 => "muffin",
        2 => "coffee",
        ___ => "set",        // 3, 4, 9, anything else
    };
]],
          [[
fn main() {
    let code = 9;
    let item = match code {
        1 => "muffin",
        2 => "coffee",
        ___ => "set",        // 3, 4, 9, 그 외 전부
    };
]],
          [[
fn main() {
    let code = 9;
    let item = match code {
        1 => "muffin",
        2 => "coffee",
        ___ => "set",        // 3、4、9，其他全部
    };
]]
        ),
        accept = { "_" },
        answer = "_",
        hint = L(
          "One character. The same underscore Go uses to throw a value away.",
          "한 글자. Go가 값을 버릴 때 쓰는 그 밑줄.",
          "一個字元。Go 用嚟丟值嘅嗰條底線。"
        ),
        ok = L(
          "_ matches anything and binds nothing. Without it the match is not exhaustive and will not compile. The gate shows set.",
          "_는 무엇이든 맞고 아무것도 묶지 않는다. 없으면 match가 빠짐없지 않아 컴파일되지 않는다. 게이트에 세트가 뜬다.",
          "_ 乜都 match，但唔綁任何嘢。冇佢個 match 唔完整，compile 唔到。閘機顯示套餐。"
        ),
      },
    },
  },

  {
    id = "rs_fn",
    station = "FN",
    name = L("The footbridge to Times Square", "타임스퀘어 육교", "去時代廣場嘅天橋"),
    title = L("Functions and Option", "함수와 Option", "function 同 Option"),
    lesson = L(
      "fn name(x: T) -> U. The last expression is the return value. Option<T> is Some(value) or None.",
      "fn 이름(x: T) -> U. 마지막 표현식이 반환값. Option<T>는 Some(값) 아니면 None.",
      "fn 名(x: T) -> U。最後一個 expression 就係回傳值。Option<T> 係 Some(值) 或者 None。"
    ),
    bg = "bg_times",
    portrait = "portrait_hero",
    speaker = L("Alex", "알렉스", "阿力"),
    ground = 348,
    spawn = 180,
    width = 1600,
    npcs = {
      {
        kind = "mei",
        x = 580,
        facing = -1,
        line = L(
          "No nil in Rust. If a value may be missing, the type says Option.",
          "Rust엔 nil이 없어. 값이 없을 수 있으면 타입이 Option이라고 말해.",
          "Rust 冇 nil。值可能冇嘅話，type 會寫明 Option。"
        ),
      },
      {
        kind = "hero",
        x = 740,
        facing = 1,
        line = L(
          "func becomes fn, and the arrow points at the return type. I can do this.",
          "func가 fn이 되고 화살표가 반환 타입을 가리킨다. 할 수 있겠어.",
          "func 變 fn，箭嘴指住回傳 type。我做得到。"
        ),
      },
    },
    viz = "rust",
    chips = {
      { "fn price(n: u32) -> u32", "cyan" },
      { "return 0;", "gold" },
      { "Option<u32>", "pink" },
      { "Some(12)  None", "green" },
    },
    note = "fn  ->  tail expr  return  Option Some None  ()",
    story = L(
      "15:20. The footbridge over Canal Road, Times Square's clock ahead. The Express delivery board "
        .. "on the bridge shows the price of every set, but the pricing function returns nothing and "
        .. "the seat finder crashes on an empty table. Alex tries the Rust himself for the first time.",
      "15:20. 캐널 로드 위 육교, 앞에 타임스퀘어 시계. 육교의 익스프레스 배달 안내판은 모든 세트의 "
        .. "가격을 보여줘야 하는데 가격 함수가 아무것도 반환하지 않고 자리 찾기는 빈 테이블에서 죽는다. "
        .. "알렉스가 처음으로 직접 Rust를 써 본다.",
      "下晝三點二十分。堅拿道上面嘅天橋，前面係時代廣場個大鐘。天橋上嘅 Express 外送板應該"
        .. "顯示每個套餐嘅價錢，但計價 function 乜都唔回傳，搵位功能遇到空枱就死機。"
        .. "阿力第一次自己試寫 Rust。"
    ),
    stages = {
      {
        topic = "FN",
        q = L(
          "Which keyword declares a function in Rust?",
          "Rust에서 함수를 선언하는 키워드는?",
          "Rust 用邊個 keyword 宣告 function？"
        ),
        code = L(
          [[
___ greet() {
    println!("welcome to Lucky Mac Express");
}
// no arrow: this one returns the unit type ()
]],
          [[
___ greet() {
    println!("welcome to Lucky Mac Express");
}
// 화살표 없음: 유닛 타입 ()을 반환
]],
          [[
___ greet() {
    println!("welcome to Lucky Mac Express");
}
// 冇箭嘴：呢個回傳 unit type ()
]]
        ),
        accept = { "fn" },
        answer = "fn",
        hint = L(
          "Two letters. Go's func with the middle taken out.",
          "두 글자. Go의 func에서 가운데를 뺀 것.",
          "兩個字母。Go 嘅 func 抽走中間。"
        ),
        ok = L(
          "fn greet() { } With no return type the function returns (), the empty tuple called unit.",
          "fn greet() { } 반환 타입이 없으면 유닛이라 부르는 빈 튜플 ()을 반환한다.",
          "fn greet() { } 冇寫回傳 type 就回傳 ()，叫 unit 嘅空 tuple。"
        ),
      },
      {
        topic = "ARROW",
        q = L(
          "What goes between the parameter list and the return type u32?",
          "매개변수 목록과 반환 타입 u32 사이에 오는 것은?",
          "參數列表同回傳 type u32 之間放咩？"
        ),
        code = L(
          [[
fn price(n: u32) ___ u32 {
    n * 18
}
// price(2) is 36
]],
          [[
fn price(n: u32) ___ u32 {
    n * 18
}
// price(2)는 36
]],
          [[
fn price(n: u32) ___ u32 {
    n * 18
}
// price(2) 係 36
]]
        ),
        accept = { "->" },
        answer = "->",
        hint = L(
          "A thin arrow, minus then greater-than. Go writes nothing there.",
          "가느다란 화살표, 빼기 다음 부등호. Go는 거기에 아무것도 안 쓴다.",
          "一支幼箭嘴，減號加大於。Go 嗰度乜都唔寫。"
        ),
        ok = L(
          "fn price(n: u32) -> u32. Every parameter needs a type; Rust never infers them in a signature.",
          "fn price(n: u32) -> u32. 모든 매개변수는 타입이 필요하고 시그니처에선 추론하지 않는다.",
          "fn price(n: u32) -> u32。每個參數都要 type，signature 裏面 Rust 唔會幫你推斷。"
        ),
      },
      {
        topic = "TAIL",
        q = L(
          "Return a plus b without the return keyword. What is the last line of the body?",
          "return 키워드 없이 a 더하기 b를 반환. 본문 마지막 줄은?",
          "唔用 return keyword 回傳 a 加 b。function 最後一行係咩？"
        ),
        code = L(
          [[
fn total(a: u32, b: u32) -> u32 {
    ___       // last expression, no semicolon
}
// total(18, 22) is 40
]],
          [[
fn total(a: u32, b: u32) -> u32 {
    ___       // 마지막 표현식, 세미콜론 없음
}
// total(18, 22)는 40
]],
          [[
fn total(a: u32, b: u32) -> u32 {
    ___       // 最後一個 expression，冇分號
}
// total(18, 22) 係 40
]]
        ),
        accept = { "a + b", "a+b", "b + a", "b+a" },
        answer = "a + b",
        hint = L(
          "Just the sum. Adding a semicolon would turn it into a statement and return ().",
          "합만 쓰면 된다. 세미콜론을 붙이면 문장이 되어 ()를 반환한다.",
          "寫個和就得。加分號就變 statement，會回傳 ()。"
        ),
        ok = L(
          "a + b with no semicolon is the value of the block. Go coders write return; Rust coders usually do not.",
          "세미콜론 없는 a + b가 블록의 값. Go 코더는 return을 쓰고 Rust 코더는 보통 안 쓴다.",
          "冇分號嘅 a + b 就係個 block 嘅值。寫 Go 嘅人會寫 return，寫 Rust 嘅通常唔寫。"
        ),
      },
      {
        topic = "RETURN",
        q = L(
          "Leave the function early when n is 0. Which keyword?",
          "n이 0이면 함수를 일찍 떠난다. 키워드는?",
          "n 係 0 就提早離開 function。邊個 keyword？"
        ),
        code = L(
          [[
fn discount(n: u32) -> u32 {
    if n == 0 {
        ___ 0;        // early exit, with a semicolon
    }
    n * 18 - 5
}
]],
          [[
fn discount(n: u32) -> u32 {
    if n == 0 {
        ___ 0;        // 조기 종료, 세미콜론 있음
    }
    n * 18 - 5
}
]],
          [[
fn discount(n: u32) -> u32 {
    if n == 0 {
        ___ 0;        // 提早退出，有分號
    }
    n * 18 - 5
}
]]
        ),
        accept = { "return" },
        answer = "return",
        hint = L(
          "Same six letters as Go. Use it for early exits, not for the last line.",
          "Go와 같은 여섯 글자. 마지막 줄 말고 조기 종료에 쓴다.",
          "同 Go 一樣嘅六個字母。用喺提早退出，唔係最後一行。"
        ),
        ok = L(
          "return 0; exits at once. The tail expression n * 18 - 5 handles every other case.",
          "return 0;은 즉시 종료. 꼬리 표현식 n * 18 - 5가 나머지를 처리한다.",
          "return 0; 即刻走。尾部 expression n * 18 - 5 處理其他情況。"
        ),
      },
      {
        topic = "OPTION",
        q = L(
          "A seat number that may not exist. Which type wraps a value that can be missing?",
          "없을 수도 있는 자리 번호. 없을 수 있는 값을 감싸는 타입은?",
          "一個可能唔存在嘅座位號。邊個 type 包住可能冇嘅值？"
        ),
        code = L(
          [[
fn seat(table: u32) -> ___<u32> {
    if table == 7 { Some(12) } else { None }
}
]],
          [[
fn seat(table: u32) -> ___<u32> {
    if table == 7 { Some(12) } else { None }
}
]],
          [[
fn seat(table: u32) -> ___<u32> {
    if table == 7 { Some(12) } else { None }
}
]]
        ),
        accept = { "Option" },
        answer = "Option",
        hint = L(
          "Six letters, capital O. Rust's answer to nil: the type itself says maybe.",
          "여섯 글자, 대문자 O. nil에 대한 Rust의 답. 타입 자체가 '없을 수도'라고 말한다.",
          "六個字母，大寫 O。Rust 對 nil 嘅答案：type 本身話你知可能冇。"
        ),
        ok = L(
          "Option<u32> is an enum: Some(12) or None. The caller must handle both, so no nil crash.",
          "Option<u32>는 열거형: Some(12) 아니면 None. 호출자가 둘 다 처리해야 하니 nil 크래시가 없다.",
          "Option<u32> 係 enum：Some(12) 或者 None。call 嘅人兩邊都要處理，所以冇 nil 死機。"
        ),
      },
      {
        topic = "NONE",
        q = L(
          "Table 7 has a seat. Every other table has nothing. What does the last line return?",
          "7번 테이블엔 자리가 있다. 다른 테이블은 없다. 마지막 줄은 무엇을 반환하나요?",
          "七號枱有位。其他枱乜都冇。最後一行回傳咩？"
        ),
        code = L(
          [[
fn seat(table: u32) -> Option<u32> {
    if table == 7 {
        return Some(12);
    }
    ___
}
]],
          [[
fn seat(table: u32) -> Option<u32> {
    if table == 7 {
        return Some(12);
    }
    ___
}
]],
          [[
fn seat(table: u32) -> Option<u32> {
    if table == 7 {
        return Some(12);
    }
    ___
}
]]
        ),
        accept = { "None" },
        answer = "None",
        hint = L(
          "The other variant of Option. Capital N, no parentheses.",
          "Option의 다른 변형. 대문자 N, 괄호 없음.",
          "Option 另一個 variant。大寫 N，冇括號。"
        ),
        ok = L(
          "None is a value, not a null pointer. Read it with match or if let Some(s) = seat(t). The board lights up.",
          "None은 null 포인터가 아닌 값. match나 if let Some(s) = seat(t)로 읽는다. 안내판이 켜진다.",
          "None 係一個值，唔係 null pointer。用 match 或者 if let Some(s) = seat(t) 讀。個板亮咗。"
        ),
      },
    },
  },

  {
    id = "rs_owner",
    station = "OWNER",
    name = L("Times Square atrium", "타임스퀘어 아트리움", "時代廣場中庭"),
    title = L("Ownership and borrowing", "소유권과 빌림", "ownership 同 borrow"),
    lesson = L(
      "A String has one owner. Assigning moves it. & borrows, &mut borrows exclusively. Values drop at the end of their scope.",
      "String의 소유자는 하나. 대입하면 이동한다. &는 빌림, &mut은 독점 빌림. 값은 스코프 끝에서 해제된다.",
      "一個 String 只有一個 owner。賦值就 move。& 係借，&mut 係獨家借。值喺 scope 完結嗰陣 drop。"
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
          "One tray, one owner. Hand it over and it is gone. Lend it with & and you keep it.",
          "트레이 하나, 주인 하나. 넘기면 사라져. &로 빌려주면 네가 계속 갖고 있어.",
          "一個托盤，一個主人。交咗出去就冇咗。用 & 借出去，托盤仍然係你嘅。"
        ),
      },
      {
        kind = "hero",
        x = 720,
        facing = 1,
        line = L(
          "No garbage collector, and it still knows when to free the tray?",
          "가비지 컬렉터도 없는데 트레이를 언제 치울지 안다고?",
          "冇 garbage collector，佢都知幾時要收托盤？"
        ),
      },
    },
    viz = "rust",
    chips = {
      { "let b = a; // moved", "cyan" },
      { "let c = a.clone();", "gold" },
      { "&s   &mut s", "pink" },
      { "drop(tray);", "green" },
    },
    note = "move  clone  &  &mut  drop scope  &str String",
    story = L(
      "15:25. The atrium of Times Square, the crab sticker on the Express order kiosk. The kiosk "
        .. "prints a receipt, then tries to read the same String again and the compiler says: value used "
        .. "after move. Mei explains who owns the tray.",
      "15:25. 타임스퀘어 아트리움, 익스프레스 주문 키오스크의 게 스티커. 키오스크는 영수증을 출력한 뒤 "
        .. "같은 String을 다시 읽으려 하고 컴파일러는 말한다: 이동 후 사용된 값. 메이가 트레이 주인을 설명한다.",
      "下晝三點二十五分。時代廣場中庭，Express 落單機上面貼住隻蟹。部機印咗收據，"
        .. "再想讀同一個 String，compiler 就話：value used after move。阿美解釋個托盤係邊個嘅。"
    ),
    stages = {
      {
        topic = "MOVE",
        q = L(
          "After let b = a; the name a is invalid. What did the String do?",
          "let b = a; 뒤에 이름 a는 쓸 수 없다. String은 무엇을 했나요?",
          "let b = a; 之後個名 a 用唔到。個 String 做咗咩？"
        ),
        code = L(
          [[
fn main() {
    let a = String::from("muffin");
    let b = a;      // ownership ___d from a to b
    println!("{}", b);
    // println!("{}", a);   would not compile
}
]],
          [[
fn main() {
    let a = String::from("muffin");
    let b = a;      // 소유권이 a에서 b로 ___d
    println!("{}", b);
    // println!("{}", a);   컴파일되지 않음
}
]],
          [[
fn main() {
    let a = String::from("muffin");
    let b = a;      // ownership 由 a ___d 去 b
    println!("{}", b);
    // println!("{}", a);   compile 唔到
}
]]
        ),
        accept = { "move", "moved" },
        answer = "move",
        hint = L(
          "Four letters. Not copied: the heap buffer changed hands.",
          "네 글자. 복사가 아니다. 힙 버퍼의 주인이 바뀌었다.",
          "四個字母。唔係 copy，係 heap buffer 換咗主人。"
        ),
        ok = L(
          "A move. Integers are Copy and stay valid; a String is moved and the old name dies. No double free, ever.",
          "이동. 정수는 Copy라서 유효하지만 String은 이동되고 옛 이름은 죽는다. 이중 해제는 절대 없다.",
          "係 move。整數係 Copy，仍然有效；String 就 move 咗，舊名死咗。永遠唔會 double free。"
        ),
      },
      {
        topic = "CLONE",
        q = L(
          "Keep a AND give b its own copy of the text. Which method?",
          "a도 유지하고 b에도 텍스트 사본을 준다. 메서드는?",
          "a 要留住，b 又要有自己一份文字。邊個 method？"
        ),
        code = L(
          [[
fn main() {
    let a = String::from("muffin");
    let b = a.___();    // deep copy of the heap data
    println!("{} {}", a, b);
}
]],
          [[
fn main() {
    let a = String::from("muffin");
    let b = a.___();    // 힙 데이터의 깊은 복사
    println!("{} {}", a, b);
}
]],
          [[
fn main() {
    let a = String::from("muffin");
    let b = a.___();    // heap data 深度複製
    println!("{} {}", a, b);
}
]]
        ),
        accept = { "clone" },
        answer = "clone",
        hint = L(
          "Five letters. Explicit, so you always see where the copying cost is.",
          "다섯 글자. 명시적이라 복사 비용이 어디서 드는지 항상 보인다.",
          "五個字母。要明寫，所以你一定見到 copy 嘅成本喺邊。"
        ),
        ok = L(
          "a.clone() allocates a second buffer. Cheap types derive Copy instead and never need it.",
          "a.clone()은 두 번째 버퍼를 할당한다. 값싼 타입은 대신 Copy를 derive해서 필요가 없다.",
          "a.clone() 會開第二個 buffer。平嘅 type 改用 derive Copy，唔使 clone。"
        ),
      },
      {
        topic = "BORROW",
        q = L(
          "Let count() read the String without taking it. Which symbol goes before the type?",
          "count()가 String을 가져가지 않고 읽게 한다. 타입 앞에 오는 기호는?",
          "俾 count() 讀 String 但唔攞走佢。type 前面放邊個符號？"
        ),
        code = L(
          [[
fn count(s: ___String) -> usize {
    s.len()
}
let a = String::from("coffee");
let n = count(&a);
println!("{} {}", a, n);   // a still alive
]],
          [[
fn count(s: ___String) -> usize {
    s.len()
}
let a = String::from("coffee");
let n = count(&a);
println!("{} {}", a, n);   // a는 아직 살아 있다
]],
          [[
fn count(s: ___String) -> usize {
    s.len()
}
let a = String::from("coffee");
let n = count(&a);
println!("{} {}", a, n);   // a 仍然生存
]]
        ),
        accept = { "&" },
        answer = "&",
        hint = L(
          "One character, the ampersand. The call site already uses it.",
          "한 글자, 앰퍼샌드. 호출하는 쪽에서 이미 쓰고 있다.",
          "一個字元，& 號。call 嗰邊已經用咗。"
        ),
        ok = L(
          "&String is a shared borrow: read only, any number at once, the owner keeps the value.",
          "&String은 공유 빌림. 읽기만, 동시에 여러 개 가능, 소유자는 값을 유지한다.",
          "&String 係共享借用：只可以讀，幾多個都得，owner 保留個值。"
        ),
      },
      {
        topic = "MUTREF",
        q = L(
          "r must be allowed to change a. Which two-part borrow gives write access?",
          "r이 a를 바꿀 수 있어야 한다. 쓰기 권한을 주는 두 부분 빌림은?",
          "r 要可以改 a。邊個兩部分嘅 borrow 俾寫入權？"
        ),
        code = L(
          [[
fn main() {
    let mut a = String::from("set");
    let r = ___ a;      // exclusive: one at a time
    r.push_str("!");
    println!("{}", a);      // set!
}
]],
          [[
fn main() {
    let mut a = String::from("set");
    let r = ___ a;      // 독점: 한 번에 하나만
    r.push_str("!");
    println!("{}", a);      // set!
}
]],
          [[
fn main() {
    let mut a = String::from("set");
    let r = ___ a;      // 獨家：一次一個
    r.push_str("!");
    println!("{}", a);      // set!
}
]]
        ),
        accept = { "&mut", "& mut" },
        answer = "&mut",
        hint = L(
          "The ampersand, then the same word that made a changeable.",
          "앰퍼샌드, 그다음 a를 바꿀 수 있게 만든 그 단어.",
          "& 號，跟住令 a 變得可改嘅同一個字。"
        ),
        ok = L(
          "&mut a. While r lives, no other borrow of a may exist: exactly 1 &mut, or many &, never both.",
          "&mut a. r이 사는 동안 a의 다른 빌림은 없다. &mut 정확히 1개, 아니면 & 여러 개, 둘 다는 안 된다.",
          "&mut a。r 未死之前 a 唔可以有其他 borrow：剛好 1 個 &mut，或者好多個 &，唔可以兩樣都有。"
        ),
      },
      {
        topic = "DROP",
        q = L(
          "Free the tray right now, before the end of the block. Which function?",
          "블록이 끝나기 전에 지금 바로 트레이를 해제. 함수는?",
          "唔等 block 完，即刻釋放個托盤。邊個 function？"
        ),
        code = L(
          [[
fn main() {
    let tray = String::from("muffin");
    ___(tray);    // freed now, not at the brace
    // println!("{}", tray);   would not compile
}
]],
          [[
fn main() {
    let tray = String::from("muffin");
    ___(tray);    // 중괄호가 아니라 지금 해제
    // println!("{}", tray);   컴파일되지 않음
}
]],
          [[
fn main() {
    let tray = String::from("muffin");
    ___(tray);    // 而家釋放，唔係等閂括號
    // println!("{}", tray);   compile 唔到
}
]]
        ),
        accept = { "drop" },
        answer = "drop",
        hint = L(
          "Four letters. What Rust does for you at the end of every scope, called by hand.",
          "네 글자. Rust가 스코프 끝마다 해 주는 일을 손으로 부르는 것.",
          "四個字母。Rust 每個 scope 完結會自動做嘅嘢，你親手 call 一次。"
        ),
        ok = L(
          "drop(tray) takes ownership and frees it. Normally the closing brace of the scope does this. No GC needed.",
          "drop(tray)는 소유권을 받아 해제한다. 보통은 스코프의 닫는 중괄호가 이 일을 한다. GC가 필요 없다.",
          "drop(tray) 攞走 ownership 然後釋放。平時係 scope 嘅閂括號做呢件事。唔使 GC。"
        ),
      },
      {
        topic = "STR",
        q = L(
          "greet takes a borrowed text: a literal or a borrowed String both fit. Which parameter type?",
          "greet는 빌린 텍스트를 받는다. 리터럴도 빌린 String도 맞는다. 매개변수 타입은?",
          "greet 收借嚟嘅文字：literal 同借嚟嘅 String 都夾。參數 type 係咩？"
        ),
        code = L(
          [[
fn greet(name: ___) {
    println!("hi {}", name);
}
let owned = String::from("Alex");
greet("Mei");           // a literal
greet(&owned);          // a borrowed String also works
]],
          [[
fn greet(name: ___) {
    println!("hi {}", name);
}
let owned = String::from("Alex");
greet("Mei");           // 리터럴
greet(&owned);          // 빌린 String도 된다
]],
          [[
fn greet(name: ___) {
    println!("hi {}", name);
}
let owned = String::from("Alex");
greet("Mei");           // literal
greet(&owned);          // 借嚟嘅 String 都得
]]
        ),
        accept = { "&str", "& str" },
        answer = "&str",
        hint = L(
          "An ampersand and three letters: the borrowed string slice.",
          "앰퍼샌드와 세 글자. 빌린 문자열 슬라이스.",
          "& 號加三個字母：借嚟嘅 string slice。"
        ),
        ok = L(
          "&str is a view into text; String owns it. Take &str in parameters, return String when you build new text. The receipt prints once.",
          "&str은 텍스트를 보는 창, String은 소유한다. 매개변수는 &str로 받고 새 텍스트를 만들면 String을 반환. 영수증이 한 번 출력된다.",
          "&str 係文字嘅一個 view，String 就擁有佢。參數收 &str，砌新文字就回傳 String。收據印咗一次。"
        ),
      },
    },
  },

  {
    id = "rs_vec",
    station = "VEC",
    name = L("The queue at Lucky Mac Express", "럭키 맥 익스프레스 줄", "幸運麥 Express 條隊"),
    title = L("Vec, arrays and HashMap", "Vec, 배열, HashMap", "Vec、array 同 HashMap"),
    lesson = L(
      "Vec grows with push. Arrays have a fixed length in the type. HashMap stores key to value; get returns Option.",
      "Vec은 push로 자란다. 배열은 타입에 길이가 고정. HashMap은 키에서 값으로, get은 Option을 반환.",
      "Vec 用 push 加長。array 嘅長度寫死喺 type。HashMap 由 key 對去 value，get 回傳 Option。"
    ),
    bg = "bg_queue",
    portrait = "portrait_friends",
    speaker = L("Mei", "메이", "阿美"),
    ground = 348,
    spawn = 180,
    width = 1600,
    npcs = {
      {
        kind = "mei",
        x = 540,
        facing = -1,
        line = L(
          "A Vec is your Go slice. An array knows its length at compile time.",
          "Vec은 Go 슬라이스야. 배열은 컴파일 시점에 길이를 알아.",
          "Vec 就係你 Go 嘅 slice。array 喺 compile 嗰陣已經知長度。"
        ),
      },
      {
        kind = "clerk",
        x = 760,
        facing = -1,
        line = L(
          "Queue board is stuck at zero. Nobody can order until it counts.",
          "대기 보드가 0에서 멈췄어요. 셀 때까지 아무도 주문 못 해요.",
          "排隊板卡喺零。佢數唔到，冇人落到單。"
        ),
      },
    },
    viz = "rust",
    chips = {
      { "vec![18, 22, 25]", "cyan" },
      { "orders.push(18);", "gold" },
      { "&prices[1..3]", "pink" },
      { ".entry(k).or_insert(0)", "green" },
    },
    note = "vec! push len [1..3] [i32; 3] sum entry get",
    story = L(
      "15:30. The queue outside Lucky Mac Express, twelve people and a crab sticker on the board. "
        .. "The board should list every order's price and count the muffins per table, but the Vec "
        .. "is never pushed to and the HashMap panics on a missing key. Siu Ming waves them to the front.",
      "15:30. 럭키 맥 익스프레스 앞 줄, 열두 명과 보드 위 게 스티커. 보드는 모든 주문의 가격을 나열하고 "
        .. "테이블별 머핀을 세야 하는데 Vec에 push가 없고 HashMap은 없는 키에서 패닉한다. "
        .. "시우밍이 둘을 맨 앞으로 부른다.",
      "下晝三點半。幸運麥 Express 門口條隊，十二個人，塊板貼住隻蟹。塊板應該列出每張單嘅價錢，"
        .. "再數每張枱幾多個鬆餅，但個 Vec 從來冇 push 過，HashMap 遇到冇嘅 key 就 panic。"
        .. "小明招手叫佢哋去最前。"
    ),
    stages = {
      {
        topic = "VECMACRO",
        q = L(
          "Build a growable list from three literal prices. Which macro?",
          "리터럴 가격 셋으로 늘어날 수 있는 목록을 만든다. 매크로는?",
          "用三個 literal 價錢砌一個可以加長嘅 list。邊個 macro？"
        ),
        code = L(
          [[
fn main() {
    let prices = ___[18, 22, 25];   // Vec<i32> on the heap
    println!("{}", prices[0]);
}
]],
          [[
fn main() {
    let prices = ___[18, 22, 25];   // Vec<i32>, 힙에
    println!("{}", prices[0]);
}
]],
          [[
fn main() {
    let prices = ___[18, 22, 25];   // Vec<i32>，喺 heap
    println!("{}", prices[0]);
}
]]
        ),
        accept = { "vec!" },
        answer = "vec!",
        hint = L(
          "Lowercase, three letters, and a bang because it is a macro.",
          "소문자 세 글자, 그리고 매크로라서 느낌표.",
          "細楷三個字母，加個感嘆號，因為係 macro。"
        ),
        ok = L(
          "vec![18, 22, 25] is the literal form. Vec::new() makes an empty one. Index with [0] like Go.",
          "vec![18, 22, 25]가 리터럴 형태. Vec::new()는 빈 것을 만든다. Go처럼 [0]으로 인덱스.",
          "vec![18, 22, 25] 係 literal 寫法。Vec::new() 開一個空嘅。同 Go 一樣用 [0] 索引。"
        ),
      },
      {
        topic = "PUSH",
        q = L(
          "Add 18 to the end of the orders list. Which method?",
          "orders 목록 끝에 18을 추가. 메서드는?",
          "喺 orders 個 list 尾加 18。邊個 method？"
        ),
        code = L(
          [[
fn main() {
    let mut orders = Vec::new();   // type inferred below
    orders.___(18);
    orders.___(22);
    println!("{:?}", orders);      // [18, 22]
}
]],
          [[
fn main() {
    let mut orders = Vec::new();   // 타입 추론됨
    orders.___(18);
    orders.___(22);
    println!("{:?}", orders);      // [18, 22]
}
]],
          [[
fn main() {
    let mut orders = Vec::new();   // type 由下面推斷
    orders.___(18);
    orders.___(22);
    println!("{:?}", orders);      // [18, 22]
}
]]
        ),
        accept = { "push" },
        answer = "push",
        hint = L(
          "Four letters. Go's append, but it changes the Vec in place, so it needs mut.",
          "네 글자. Go의 append지만 Vec을 제자리에서 바꾸니 mut이 필요하다.",
          "四個字母。Go 嘅 append，但係原地改 Vec，所以要 mut。"
        ),
        ok = L(
          "orders.push(18). pop() takes the last one back. The Vec reallocates when it runs out of room.",
          "orders.push(18). pop()은 마지막 것을 꺼낸다. 자리가 없으면 Vec이 재할당한다.",
          "orders.push(18)。pop() 攞返最後一個。冇位就會重新分配。"
        ),
      },
      {
        topic = "LEN",
        q = L(
          "How many items are in prices? Which method returns a usize?",
          "prices에 항목이 몇 개? usize를 반환하는 메서드는?",
          "prices 有幾多個？邊個 method 回傳 usize？"
        ),
        code = L(
          [[
fn main() {
    let prices = vec![18, 22, 25];
    let n = prices.___();          // 3
    println!("{} orders in the queue", n);
}
]],
          [[
fn main() {
    let prices = vec![18, 22, 25];
    let n = prices.___();          // 3
    println!("{} orders in the queue", n);
}
]],
          [[
fn main() {
    let prices = vec![18, 22, 25];
    let n = prices.___();          // 3
    println!("{} orders in the queue", n);
}
]]
        ),
        accept = { "len" },
        answer = "len",
        hint = L(
          "Three letters, a method with parentheses. Go has the same word as a builtin.",
          "세 글자, 괄호가 있는 메서드. Go에는 같은 단어가 내장 함수로 있다.",
          "三個字母，帶括號嘅 method。Go 有同一個字做 builtin。"
        ),
        ok = L(
          "prices.len() is 3. is_empty() is the idiomatic way to ask for zero. The board counts to twelve.",
          "prices.len()은 3. 0인지 물을 땐 is_empty()가 관용적. 보드가 열둘까지 센다.",
          "prices.len() 係 3。問係唔係零，慣用 is_empty()。塊板數到十二。"
        ),
      },
      {
        topic = "SLICE",
        q = L(
          "Borrow only the second and third price, indices 1 and 2. What goes in the brackets?",
          "두 번째와 세 번째 가격만 빌린다, 인덱스 1과 2. 괄호 안에 오는 것은?",
          "只借第二同第三個價錢，index 1 同 2。中括號入面寫咩？"
        ),
        code = L(
          [[
fn main() {
    let prices = vec![18, 22, 25];
    let mid = &prices[___];    // end excluded
    println!("{:?}", mid);         // [22, 25]
}
]],
          [[
fn main() {
    let prices = vec![18, 22, 25];
    let mid = &prices[___];    // 끝은 제외
    println!("{:?}", mid);         // [22, 25]
}
]],
          [[
fn main() {
    let prices = vec![18, 22, 25];
    let mid = &prices[___];    // 唔包終點
    println!("{:?}", mid);         // [22, 25]
}
]]
        ),
        accept = { "1..3", "1..=2" },
        answer = "1..3",
        hint = L(
          "A range with two dots, like Go's [1:3].",
          "점 두 개짜리 범위, Go의 [1:3]처럼.",
          "兩點嘅 range，好似 Go 嘅 [1:3]。"
        ),
        ok = L(
          "&prices[1..3] is a slice of type &[i32]: a borrowed window, no copy. [1..] and [..2] also work.",
          "&prices[1..3]은 &[i32] 타입의 슬라이스. 빌린 창이며 복사 없음. [1..]과 [..2]도 된다.",
          "&prices[1..3] 係 &[i32] type 嘅 slice：借嚟嘅一個窗，唔 copy。[1..] 同 [..2] 都得。"
        ),
      },
      {
        topic = "ARRAY",
        q = L(
          "A fixed tray of three prices. The array type spells out its length. Which number?",
          "가격 세 개의 고정 트레이. 배열 타입은 길이를 적는다. 숫자는?",
          "固定三個價錢嘅托盤。array type 要寫明長度。邊個數？"
        ),
        code = L(
          [[
fn main() {
    let tray: [i32; ___] = [18, 22, 25];
    println!("{}", tray[2]);       // 25
}
]],
          [[
fn main() {
    let tray: [i32; ___] = [18, 22, 25];
    println!("{}", tray[2]);       // 25
}
]],
          [[
fn main() {
    let tray: [i32; ___] = [18, 22, 25];
    println!("{}", tray[2]);       // 25
}
]]
        ),
        accept = { "3" },
        answer = "3",
        hint = L(
          "Count the values. The length is part of the type, so [i32; 4] would be a different type.",
          "값을 세세요. 길이가 타입의 일부라 [i32; 4]는 다른 타입이다.",
          "數一數有幾多個值。長度係 type 一部分，[i32; 4] 就係另一個 type。"
        ),
        ok = L(
          "[i32; 3] lives on the stack and never grows. Vec is for lists that change size.",
          "[i32; 3]은 스택에 있고 절대 자라지 않는다. 크기가 바뀌는 목록은 Vec.",
          "[i32; 3] 放喺 stack，永遠唔會加長。會變大細嘅 list 用 Vec。"
        ),
      },
      {
        topic = "SUM",
        q = L(
          "Add every price together through an iterator. Which method finishes the chain?",
          "이터레이터로 모든 가격을 더한다. 체인을 끝내는 메서드는?",
          "用 iterator 加埋所有價錢。邊個 method 收尾？"
        ),
        code = L(
          [[
fn main() {
    let prices = vec![18, 22, 25];
    let total: i32 = prices.iter().___();   // 65
    println!("{}", total);
}
]],
          [[
fn main() {
    let prices = vec![18, 22, 25];
    let total: i32 = prices.iter().___();   // 65
    println!("{}", total);
}
]],
          [[
fn main() {
    let prices = vec![18, 22, 25];
    let total: i32 = prices.iter().___();   // 65
    println!("{}", total);
}
]]
        ),
        accept = { "sum" },
        answer = "sum",
        hint = L(
          "Three letters. The type on the left, : i32, tells it what to produce.",
          "세 글자. 왼쪽의 타입 : i32가 무엇을 만들지 알려준다.",
          "三個字母。左邊嘅 type : i32 話佢知要出咩。"
        ),
        ok = L(
          "iter().sum() needs the result type written down. map, filter, count and collect live on the same chain.",
          "iter().sum()은 결과 타입을 적어야 한다. map, filter, count, collect도 같은 체인에 있다.",
          "iter().sum() 要寫明結果 type。map、filter、count、collect 都喺同一條 chain。"
        ),
      },
      {
        topic = "ENTRY",
        q = L(
          "Count muffins per table: insert 0 if the key is new, then add 1. Which HashMap method starts that?",
          "테이블별 머핀 세기: 키가 새로우면 0을 넣고 1을 더한다. 그걸 시작하는 HashMap 메서드는?",
          "數每張枱幾多個鬆餅：key 係新嘅就放 0，再加 1。邊個 HashMap method 開頭？"
        ),
        code = L(
          [[
use std::collections::HashMap;
fn main() {
    let mut count = HashMap::new();
    count.insert("t7", 2);
    *count.___("t4").or_insert(0) += 1;   // t4 is 1
    println!("{:?}", count.get("t9"));    // None
}
]],
          [[
use std::collections::HashMap;
fn main() {
    let mut count = HashMap::new();
    count.insert("t7", 2);
    *count.___("t4").or_insert(0) += 1;   // t4는 1
    println!("{:?}", count.get("t9"));    // None
}
]],
          [[
use std::collections::HashMap;
fn main() {
    let mut count = HashMap::new();
    count.insert("t7", 2);
    *count.___("t4").or_insert(0) += 1;   // t4 係 1
    println!("{:?}", count.get("t9"));    // None
}
]]
        ),
        accept = { "entry" },
        answer = "entry",
        hint = L(
          "Five letters. A slot for one key, whether it exists yet or not.",
          "다섯 글자. 있든 없든 키 하나의 자리.",
          "五個字母。一個 key 嘅位，唔理佢存在未。"
        ),
        ok = L(
          "entry(k).or_insert(0) returns &mut to the value; * dereferences it. get(k) returns Option, so a missing key is None, not a panic.",
          "entry(k).or_insert(0)은 값의 &mut을 반환하고 *로 역참조한다. get(k)은 Option을 반환해 없는 키는 패닉이 아닌 None.",
          "entry(k).or_insert(0) 回傳值嘅 &mut，用 * 解引用。get(k) 回傳 Option，冇嘅 key 係 None，唔會 panic。"
        ),
      },
    },
  },

  {
    id = "rs_struct",
    station = "STRUCT",
    name = L("The Express counter", "익스프레스 카운터", "Express 收銀櫃位"),
    title = L("struct, impl and enum", "struct, impl, enum", "struct、impl 同 enum"),
    lesson = L(
      "struct groups fields. impl adds methods that take &self or &mut self. enum lists variants; match handles them all.",
      "struct는 필드를 묶는다. impl은 &self나 &mut self를 받는 메서드를 더한다. enum은 변형을 나열하고 match가 전부 처리한다.",
      "struct 集合 field。impl 加 method，收 &self 或者 &mut self。enum 列出 variant，match 逐個處理。"
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
        facing = 1,
        line = L(
          "The till thinks every order is a tuple. Give it a struct with names.",
          "계산대가 모든 주문을 튜플로 여겨요. 이름 있는 struct를 주세요.",
          "收銀機當每張單係 tuple。俾佢一個有名嘅 struct。"
        ),
      },
      {
        kind = "mei",
        x = 720,
        facing = -1,
        line = L(
          "And the size is an enum. Small or Large, nothing in between, the compiler makes sure.",
          "그리고 사이즈는 enum. Small 아니면 Large, 그 사이는 없어, 컴파일러가 보장해.",
          "而且 size 係 enum。Small 或者 Large，冇中間，compiler 會確保。"
        ),
      },
    },
    viz = "rust",
    chips = {
      { "struct Order {qty: u32}", "cyan" },
      { "impl Order { fn ... }", "gold" },
      { "fn total(&self)", "pink" },
      { "#[derive(Debug)]", "green" },
    },
    note = "struct impl &self &mut self enum derive {:?}",
    story = L(
      "15:35. The counter of Lucky Mac Express at last, the crab sticker smiling on the till. The till "
        .. "keeps orders as loose tuples and cannot print them, and a size of Medium sneaks in that the "
        .. "kitchen does not know. Siu Ming needs an Order type before the afternoon set can be sold.",
      "15:35. 드디어 럭키 맥 익스프레스 카운터, 계산대 위 게 스티커가 웃는다. 계산대는 주문을 느슨한 튜플로 "
        .. "두어 출력도 못 하고, 주방이 모르는 Medium 사이즈가 끼어든다. 오후 세트를 팔려면 시우밍에게 "
        .. "Order 타입이 필요하다.",
      "下晝三點三十五分。終於到幸運麥 Express 櫃位，收銀機上面隻蟹笑住。收銀機將訂單存做散嘅 tuple，"
        .. "印都印唔到，仲有個廚房唔識嘅 Medium size 偷偷入咗嚟。小明要一個 Order type 先賣得下晝套餐。"
    ),
    stages = {
      {
        topic = "STRUCT",
        q = L(
          "Group an item name and a quantity under one named type. Which keyword?",
          "품목 이름과 수량을 이름 있는 타입 하나로 묶는다. 키워드는?",
          "將貨品名同數量集合成一個有名嘅 type。邊個 keyword？"
        ),
        code = L(
          [[
___ Order {
    item: String,
    qty: u32,
}
let o = Order { item: "muffin".to_string(), qty: 2 };
]],
          [[
___ Order {
    item: String,
    qty: u32,
}
let o = Order { item: "muffin".to_string(), qty: 2 };
]],
          [[
___ Order {
    item: String,
    qty: u32,
}
let o = Order { item: "muffin".to_string(), qty: 2 };
]]
        ),
        accept = { "struct" },
        answer = "struct",
        hint = L(
          "Six letters, same word as Go, but there is no type keyword in front.",
          "여섯 글자, Go와 같은 단어. 다만 앞에 type 키워드가 없다.",
          "六個字母，同 Go 一樣嘅字，但前面冇 type keyword。"
        ),
        ok = L(
          "struct Order { item: String, qty: u32 } Fields are private to the module unless marked pub.",
          "struct Order { item: String, qty: u32 } 필드는 pub 표시가 없으면 모듈 안에서만 보인다.",
          "struct Order { item: String, qty: u32 } field 唔標 pub 就只有 module 入面見得到。"
        ),
      },
      {
        topic = "IMPL",
        q = L(
          "Methods are written in a separate block. Which keyword opens it?",
          "메서드는 별도 블록에 쓴다. 그 블록을 여는 키워드는?",
          "method 寫喺另一個 block。邊個 keyword 打開佢？"
        ),
        code = L(
          [[
struct Order { qty: u32 }

___ Order {
    fn total(&self) -> u32 {
        self.qty * 18
    }
}
]],
          [[
struct Order { qty: u32 }

___ Order {
    fn total(&self) -> u32 {
        self.qty * 18
    }
}
]],
          [[
struct Order { qty: u32 }

___ Order {
    fn total(&self) -> u32 {
        self.qty * 18
    }
}
]]
        ),
        accept = { "impl" },
        answer = "impl",
        hint = L(
          "Four letters, short for implementation. Go attaches methods one by one; Rust groups them.",
          "네 글자, implementation의 줄임말. Go는 메서드를 하나씩 붙이고 Rust는 묶는다.",
          "四個字母，implementation 嘅縮寫。Go 逐個掛 method，Rust 一 block 放埋。"
        ),
        ok = L(
          "impl Order { } holds the methods. Data and behaviour stay in two blocks. o.total() is 36.",
          "impl Order { }에 메서드가 있다. 데이터와 동작은 두 블록에 나뉜다. o.total()은 36.",
          "impl Order { } 裝住 method。data 同行為分開兩個 block。o.total() 係 36。"
        ),
      },
      {
        topic = "SELF",
        q = L(
          "total only reads the order. Which receiver borrows it without change?",
          "total은 주문을 읽기만 한다. 변경 없이 빌리는 리시버는?",
          "total 只係讀張單。邊個 receiver 借佢但唔改？"
        ),
        code = L(
          [[
impl Order {
    fn total(___) -> u32 {
        self.qty * 18       // read only
    }
}
]],
          [[
impl Order {
    fn total(___) -> u32 {
        self.qty * 18       // 읽기만
    }
}
]],
          [[
impl Order {
    fn total(___) -> u32 {
        self.qty * 18       // 只讀
    }
}
]]
        ),
        accept = { "&self" },
        answer = "&self",
        hint = L(
          "An ampersand and the word the body already uses to reach qty.",
          "앰퍼샌드와 본문이 qty에 닿을 때 이미 쓰는 그 단어.",
          "& 號加上 body 已經用嚟拎 qty 嘅嗰個字。"
        ),
        ok = L(
          "fn total(&self) borrows the Order. Plain self would move it and o could not be used afterwards.",
          "fn total(&self)는 Order를 빌린다. self만 쓰면 이동해서 이후 o를 쓸 수 없다.",
          "fn total(&self) 借個 Order。淨係寫 self 就會 move，之後 o 用唔到。"
        ),
      },
      {
        topic = "MUTSELF",
        q = L(
          "add changes qty. Which receiver borrows the order with write access?",
          "add는 qty를 바꾼다. 쓰기 권한으로 주문을 빌리는 리시버는?",
          "add 會改 qty。邊個 receiver 借張單兼有寫入權？"
        ),
        code = L(
          [[
impl Order {
    fn add(___, n: u32) {
        self.qty += n;
    }
}
let mut o = Order { qty: 1 };
o.add(2);                   // qty is 3
]],
          [[
impl Order {
    fn add(___, n: u32) {
        self.qty += n;
    }
}
let mut o = Order { qty: 1 };
o.add(2);                   // qty는 3
]],
          [[
impl Order {
    fn add(___, n: u32) {
        self.qty += n;
    }
}
let mut o = Order { qty: 1 };
o.add(2);                   // qty 係 3
]]
        ),
        accept = { "&mut self", "&mutself", "& mut self" },
        answer = "&mut self",
        hint = L(
          "Three parts: ampersand, the mutability word, the receiver. o must be let mut to call it.",
          "세 부분: 앰퍼샌드, 가변성 단어, 리시버. 호출하려면 o가 let mut이어야 한다.",
          "三部分：& 號、可變嗰個字、receiver。要 call 佢，o 一定要 let mut。"
        ),
        ok = L(
          "fn add(&mut self, n: u32). Self with a capital S names the type itself, handy in fn new() -> Self.",
          "fn add(&mut self, n: u32). 대문자 S의 Self는 타입 자체를 가리켜 fn new() -> Self에 편하다.",
          "fn add(&mut self, n: u32)。大寫 S 嘅 Self 代表個 type 本身，寫 fn new() -> Self 好方便。"
        ),
      },
      {
        topic = "ENUM",
        q = L(
          "A size is Small or Large and nothing else. Which keyword lists the variants?",
          "사이즈는 Small 아니면 Large, 그 외는 없다. 변형을 나열하는 키워드는?",
          "size 只有 Small 或者 Large。邊個 keyword 列出 variant？"
        ),
        code = L(
          [[
___ Size { Small, Large }

let size = Size::Large;
let extra = match size {
    Size::Small => 0,
    Size::Large => 5,       // every variant handled
};
]],
          [[
___ Size { Small, Large }

let size = Size::Large;
let extra = match size {
    Size::Small => 0,
    Size::Large => 5,       // 모든 변형 처리
};
]],
          [[
___ Size { Small, Large }

let size = Size::Large;
let extra = match size {
    Size::Small => 0,
    Size::Large => 5,       // 每個 variant 都處理咗
};
]]
        ),
        accept = { "enum" },
        answer = "enum",
        hint = L(
          "Four letters. Go fakes it with const and iota; Rust has the real thing.",
          "네 글자. Go는 const와 iota로 흉내 내고 Rust는 진짜가 있다.",
          "四個字母。Go 用 const 同 iota 扮，Rust 有真嘅。"
        ),
        ok = L(
          "enum Size { Small, Large } Variants can carry data too, like Some(12). match without a Medium arm is a compile error, not a bug at the till.",
          "enum Size { Small, Large } 변형은 Some(12)처럼 데이터도 담을 수 있다. Medium 팔이 없는 match는 계산대 버그가 아닌 컴파일 에러.",
          "enum Size { Small, Large } variant 都可以帶 data，好似 Some(12)。match 漏咗 Medium 係 compile error，唔係收銀機 bug。"
        ),
      },
      {
        topic = "DERIVE",
        q = L(
          "Let println! print the whole struct with {:?}. Which attribute word generates Debug?",
          "println!이 {:?}로 struct 전체를 출력하게 한다. Debug를 생성하는 속성 단어는?",
          "俾 println! 用 {:?} 印成個 struct。邊個 attribute 字生成 Debug？"
        ),
        code = L(
          [[
#[___(Debug)]
struct Order { qty: u32 }

let o = Order { qty: 2 };
println!("{:?}", o);        // Order { qty: 2 }
]],
          [[
#[___(Debug)]
struct Order { qty: u32 }

let o = Order { qty: 2 };
println!("{:?}", o);        // Order { qty: 2 }
]],
          [[
#[___(Debug)]
struct Order { qty: u32 }

let o = Order { qty: 2 };
println!("{:?}", o);        // Order { qty: 2 }
]]
        ),
        accept = { "derive" },
        answer = "derive",
        hint = L(
          "Six letters. The compiler writes the trait implementation for you.",
          "여섯 글자. 컴파일러가 트레이트 구현을 대신 써 준다.",
          "六個字母。compiler 幫你寫 trait implementation。"
        ),
        ok = L(
          "#[derive(Debug, Clone, PartialEq)] generates common traits. {:?} needs Debug. The till prints the order and the afternoon set is sold.",
          "#[derive(Debug, Clone, PartialEq)]가 흔한 트레이트를 생성한다. {:?}에는 Debug가 필요. 계산대가 주문을 출력하고 오후 세트가 팔린다.",
          "#[derive(Debug, Clone, PartialEq)] 生成常用 trait。{:?} 要 Debug。收銀機印出訂單，下晝套餐賣出咗。"
        ),
      },
    },
  },
}

return maps
