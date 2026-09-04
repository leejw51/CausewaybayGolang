-- Rust quest 3 DELIVERY: "DELIVERY - the app".
-- 17:00 at Lucky Mac Express, Times Square. The owner wants the delivery
-- backend rewritten in Rust before the dinner rush. Seven tickets:
-- strings, errors, iterators, serde, async, cargo, modern Rust.
-- Mei leads, Alex ships, Siu Ming reports bugs from the counter.
-- Prize: the service goes live (SHIPPED).

local function L(en, ko, yue)
  return { en = en, ko = ko, yue = yue }
end

local maps = {
  {
    id = "rs_string",
    station = "STRINGS",
    name = L("The kiosk row", "키오스크 줄", "部機一排"),
    title = L("String and &str", "String과 &str", "String 同 &str"),
    lesson = L(
      "String owns, &str borrows. len() counts bytes, chars().count() counts characters.",
      "String은 소유, &str은 빌림. len()은 바이트 수, chars().count()는 글자 수.",
      "String 係自己擁有，&str 係借嘅。len() 數 byte，chars().count() 數字元。"
    ),
    bg = "bg_times",
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
          "Ticket one. The receipt cuts the shop name in half. Bytes, not characters.",
          "첫 티켓. 영수증이 가게 이름을 반으로 자르고 있어. 글자가 아니라 바이트야.",
          "第一張 ticket。收據將舖名斬開一半。係 byte，唔係字元。"
        ),
      },
    },
    viz = "rust",
    chips = {
      { 'String::from("HK")', "cyan" },
      { "s.chars().count()", "gold" },
      { 'format!("{a} {b}")', "pink" },
      { '"18".parse::<i32>()', "green" },
    },
    note = "String  &str  len  chars  format!  parse",
    story = L(
      "17:00. Lucky Mac Express, Times Square. The receipt printer writes the shop name as "
        .. "銅鑼 and a broken square. Someone sliced a String by byte count. Mei opens ticket one.",
      "17:00. 타임스퀘어 럭키 맥 익스프레스. 영수증 프린터가 가게 이름을 銅鑼 와 깨진 네모로 찍는다. "
        .. "누가 String을 바이트 수로 잘랐다. 메이가 첫 티켓을 연다.",
      "五點正。時代廣場幸運麥 Express。收據機印舖名印成 銅鑼 加一個爛格仔。"
        .. "有人用 byte 數去切 String。阿美開第一張 ticket。"
    ),
    stages = {
      {
        topic = "STRING",
        q = L(
          "Make an owned String out of a string literal. Which constructor?",
          "문자열 리터럴로 소유하는 String을 만든다. 어떤 생성자?",
          "由 string literal 造一個自己擁有嘅 String。用邊個 constructor？"
        ),
        code = L(
          [[
// a literal is a &str; the kiosk needs its own copy
let shop = String::___("Lucky Mac Express");
let label: &str = &shop;
]],
          [[
// 리터럴은 &str; 자기 복사본이 필요
let shop = String::___("Lucky Mac Express");
let label: &str = &shop;
]],
          [[
// literal 係 &str；部機要自己嗰份
let shop = String::___("Lucky Mac Express");
let label: &str = &shop;
]]
        ),
        accept = { "from", "String::from" },
        answer = "from",
        hint = L(
          "Four letters. The From trait gives it to you. to_string() does the same job.",
          "네 글자. From 트레이트가 준다. to_string()도 같은 일을 한다.",
          "四個字母。From trait 送俾你嘅。to_string() 做同一件事。"
        ),
        ok = L(
          'String::from("..") or "..".to_string(). &str borrows, String owns and can grow.',
          'String::from("..") 또는 "..".to_string(). &str은 빌리고 String은 소유하며 자랄 수 있다.',
          'String::from("..") 或者 "..".to_string()。&str 係借，String 係自己有，仲可以變長。'
        ),
      },
      {
        topic = "BYTES",
        q = L(
          "Which method returns 9 for the three characters of 銅鑼灣?",
          "銅鑼灣 세 글자에 대해 9를 돌려주는 메서드는?",
          "銅鑼灣 三個字，邊個 method 會俾你 9？"
        ),
        code = L(
          [[
// three characters, three bytes each in UTF-8
let district = "銅鑼灣";
let n = district.___();
assert_eq!(n, 9);
]],
          [[
// 세 글자, UTF-8에서는 글자마다 3바이트
let district = "銅鑼灣";
let n = district.___();
assert_eq!(n, 9);
]],
          [[
// 三個字，UTF-8 每個字三個 byte
let district = "銅鑼灣";
let n = district.___();
assert_eq!(n, 9);
]]
        ),
        accept = { "len" },
        answer = "len",
        hint = L(
          "Three letters, same name as on a Vec. It counts bytes, never characters.",
          "세 글자, Vec에 있는 것과 같은 이름. 글자가 아니라 바이트를 센다.",
          "三個字母，同 Vec 上面嗰個一樣名。數 byte，唔係數字。"
        ),
        ok = L(
          "len() is bytes. Slicing &s[0..4] in the middle of 鑼 panics: not a char boundary.",
          "len()은 바이트. 鑼 중간을 &s[0..4]로 자르면 패닉: 글자 경계가 아니다.",
          "len() 係 byte。&s[0..4] 切喺 鑼 中間會 panic：唔係 char boundary。"
        ),
      },
      {
        topic = "CHARS",
        q = L(
          "Count characters, not bytes. Which iterator do you count?",
          "바이트가 아니라 글자를 센다. 어떤 이터레이터를 세나?",
          "數字元，唔係數 byte。數邊個 iterator？"
        ),
        code = L(
          [[
let district = "銅鑼灣";
let n = district.___().count();
assert_eq!(n, 3);
// the receipt now cuts at whole characters
]],
          [[
let district = "銅鑼灣";
let n = district.___().count();
assert_eq!(n, 3);
// 이제 영수증은 글자 단위로 자른다
]],
          [[
let district = "銅鑼灣";
let n = district.___().count();
assert_eq!(n, 3);
// 收據而家係一個一個字咁切
]]
        ),
        accept = { "chars", "chars()" },
        answer = "chars",
        hint = L(
          "Plural of the type a single Unicode scalar has in Rust.",
          "러스트에서 유니코드 스칼라 하나가 갖는 타입의 복수형.",
          "Rust 裏面一個 Unicode scalar 嘅 type，變成眾數。"
        ),
        ok = L(
          "chars().count() walks the string and counts. The receipt prints 銅鑼灣 in full.",
          "chars().count()는 문자열을 훑으며 센다. 영수증에 銅鑼灣 이 다 찍힌다.",
          "chars().count() 行勻成條 string 去數。收據印齊 銅鑼灣。"
        ),
      },
      {
        topic = "FORMAT",
        q = L(
          "Build a String from pieces without printing it. Which macro?",
          "출력하지 않고 조각들로 String을 만든다. 어떤 매크로?",
          "唔印出嚟，用幾塊砌一個 String。邊個 macro？"
        ),
        code = L(
          [[
let dish = "curry rice";
let qty = 2;
// like println! but it returns the String
let line = ___!("{qty} x {dish}");
]],
          [[
let dish = "curry rice";
let qty = 2;
// println! 같지만 String을 반환한다
let line = ___!("{qty} x {dish}");
]],
          [[
let dish = "curry rice";
let qty = 2;
// 好似 println! 但係會回傳個 String
let line = ___!("{qty} x {dish}");
]]
        ),
        accept = { "format", "format!" },
        answer = "format",
        hint = L(
          "Six letters. The word in fmt spelled out. Variables can go straight inside the braces.",
          "여섯 글자. fmt를 풀어 쓴 단어. 변수는 중괄호 안에 바로 넣을 수 있다.",
          "六個字母。fmt 寫全寫。變數可以直接放入大括號。"
        ),
        ok = L(
          'format!("{qty} x {dish}") gives "2 x curry rice". Inline names since Rust 1.58.',
          'format!("{qty} x {dish}")는 "2 x curry rice". 러스트 1.58부터 이름을 바로 넣는다.',
          'format!("{qty} x {dish}") 得出 "2 x curry rice"。Rust 1.58 開始可以直接寫名。'
        ),
      },
      {
        topic = "GROW",
        q = L(
          "Append a &str to the end of a mutable String. Which method?",
          "가변 String 끝에 &str을 붙인다. 어떤 메서드?",
          "喺可變嘅 String 尾加一段 &str。邊個 method？"
        ),
        code = L(
          [[
let mut order = String::new();
order.___("curry rice");
order.___(" + hash brown");
let loud = order.to_uppercase();
]],
          [[
let mut order = String::new();
order.___("curry rice");
order.___(" + hash brown");
let loud = order.to_uppercase();
]],
          [[
let mut order = String::new();
order.___("curry rice");
order.___(" + hash brown");
let loud = order.to_uppercase();
]]
        ),
        accept = { "push_str", "pushstr" },
        answer = "push_str",
        hint = L(
          "push adds one char. This one adds a whole str. Two words, underscore.",
          "push는 char 하나. 이건 str 전체를 붙인다. 두 단어, 밑줄.",
          "push 加一個 char。呢個加成段 str。兩個字，底線。"
        ),
        ok = L(
          "push_str borrows the &str and copies it in. to_uppercase() makes a new String.",
          "push_str는 &str을 빌려 복사해 넣는다. to_uppercase()는 새 String을 만든다.",
          "push_str 借個 &str 然後 copy 入去。to_uppercase() 造一個新 String。"
        ),
      },
      {
        topic = "PARSE",
        q = L(
          'The kiosk reads "18" from the keypad. Turn it into an i32. Which method?',
          '키오스크가 키패드에서 "18"을 읽었다. i32로 바꾼다. 어떤 메서드?',
          '部機由鍵盤讀到 "18"。變做 i32。邊個 method？'
        ),
        code = L(
          [[
let typed = "18";
// FromStr does the work; the turbofish picks the type
let qty = typed.___::<i32>()?;
println!("{qty} sets");
]],
          [[
let typed = "18";
// FromStr가 일한다; 터보피시가 타입 지정
let qty = typed.___::<i32>()?;
println!("{qty} sets");
]],
          [[
let typed = "18";
// FromStr 做嘢；turbofish 揀 type
let qty = typed.___::<i32>()?;
println!("{qty} sets");
]]
        ),
        accept = { "parse" },
        answer = "parse",
        hint = L(
          'Five letters. It returns a Result because "1x8" is not a number.',
          '다섯 글자. "1x8"은 숫자가 아니니 Result를 돌려준다.',
          '五個字母。因為 "1x8" 唔係數字，所以回傳 Result。'
        ),
        ok = L(
          '"18".parse::<i32>() is Ok(18). "1x8" is Err(ParseIntError). Ticket one closed.',
          '"18".parse::<i32>()는 Ok(18). "1x8"은 Err(ParseIntError). 첫 티켓 닫힘.',
          '"18".parse::<i32>() 係 Ok(18)。"1x8" 係 Err(ParseIntError)。第一張 ticket 閂咗。'
        ),
      },
    },
  },

  {
    id = "rs_error",
    station = "ERRORS",
    name = L("The Express till", "익스프레스 계산대", "Express 收銀"),
    title = L("Custom errors and ?", "커스텀 에러와 ?", "自訂 error 同 ?"),
    lesson = L(
      "Make an enum, impl Display and Error, impl From so ? converts. Box<dyn Error> catches the rest.",
      "enum을 만들고 Display와 Error를 impl, From을 impl하면 ?가 변환한다. 나머지는 Box<dyn Error>.",
      "整個 enum，impl Display 同 Error，impl From 令 ? 自動轉。其餘用 Box<dyn Error> 接住。"
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
          "A customer typed 1x8 sets and the till printed a page of panic. Ticket two.",
          "손님이 1x8 세트를 입력했더니 계산대가 패닉을 한 장 찍었어. 두 번째 티켓.",
          "有客打咗 1x8 份，收銀機印咗一版 panic。第二張 ticket。"
        ),
      },
    },
    viz = "rust",
    chips = {
      { "enum OrderError", "cyan" },
      { "impl fmt::Display", "gold" },
      { "Box<dyn Error>", "pink" },
      { '#[error("..")]', "green" },
    },
    note = "enum  Display  Error  From  ?  thiserror",
    story = L(
      "17:10. The till at Lucky Mac Express unwraps every parse. One bad keypad entry and the "
        .. "drawer prints a stack trace instead of a receipt. Siu Ming wants a real error type.",
      "17:10. 익스프레스 계산대는 모든 parse를 unwrap한다. 키패드 입력 하나만 틀려도 "
        .. "서랍이 영수증 대신 스택 트레이스를 찍는다. 시우밍은 진짜 에러 타입을 원한다.",
      "五點十分。Express 收銀機每個 parse 都 unwrap。鍵盤打錯一次，"
        .. "櫃桶就印 stack trace 唔印收據。小明想要一個真正嘅 error type。"
    ),
    stages = {
      {
        topic = "ENUM",
        q = L(
          "One type, several ways an order can fail. Which keyword declares it?",
          "타입 하나에 주문이 실패하는 여러 경우. 어떤 키워드로 선언?",
          "一個 type，幾種落單失敗嘅情況。用邊個 keyword 宣告？"
        ),
        code = L(
          [[
use std::num::ParseIntError;

#[derive(Debug)]
___ OrderError {
    Empty,
    BadQty(ParseIntError),
}
]],
          [[
use std::num::ParseIntError;

#[derive(Debug)]
___ OrderError {
    Empty,
    BadQty(ParseIntError),
}
]],
          [[
use std::num::ParseIntError;

#[derive(Debug)]
___ OrderError {
    Empty,
    BadQty(ParseIntError),
}
]]
        ),
        accept = { "enum" },
        answer = "enum",
        hint = L(
          "Not struct. Variants, one of which carries the ParseIntError inside.",
          "struct가 아니다. 변형들, 그중 하나가 ParseIntError를 안에 든다.",
          "唔係 struct。有幾個 variant，其中一個裝住 ParseIntError。"
        ),
        ok = L(
          "enum OrderError lists every failure. Debug is required by the Error trait later.",
          "enum OrderError가 모든 실패를 나열. Debug는 나중에 Error 트레이트가 요구한다.",
          "enum OrderError 列齊所有失敗。之後 Error trait 要求有 Debug。"
        ),
      },
      {
        topic = "DISPLAY",
        q = L(
          "Give the error a human message for {}. Which fmt trait?",
          "에러에 {}용 사람 메시지를 준다. fmt의 어떤 트레이트?",
          "俾個 error 一句人睇嘅訊息，畀 {} 用。fmt 邊個 trait？"
        ),
        code = L(
          [[
use std::fmt;
impl fmt::___ for OrderError {
    fn fmt(&self, f: &mut fmt::Formatter) -> fmt::Result {
        write!(f, "order failed")
    }
}
]],
          [[
use std::fmt;
impl fmt::___ for OrderError {
    fn fmt(&self, f: &mut fmt::Formatter) -> fmt::Result {
        write!(f, "order failed")
    }
}
]],
          [[
use std::fmt;
impl fmt::___ for OrderError {
    fn fmt(&self, f: &mut fmt::Formatter) -> fmt::Result {
        write!(f, "order failed")
    }
}
]]
        ),
        accept = { "Display", "fmt::Display" },
        answer = "Display",
        hint = L(
          "The trait behind {}. Debug is behind {:?}. You cannot derive this one.",
          "{} 뒤에 있는 트레이트. {:?} 뒤에는 Debug. 이건 derive할 수 없다.",
          "{} 背後嘅 trait。{:?} 背後係 Debug。呢個 derive 唔到。"
        ),
        ok = L(
          "impl fmt::Display gives to_string() and {} for free. The till prints one clean line.",
          "impl fmt::Display로 to_string()과 {}가 공짜. 계산대가 깔끔한 한 줄을 찍는다.",
          "impl fmt::Display 送埋 to_string() 同 {}。收銀機印一行乾淨嘅字。"
        ),
      },
      {
        topic = "TRAIT",
        q = L(
          "Which std trait, with an empty body, makes OrderError a real error?",
          "빈 본문으로 OrderError를 진짜 에러로 만드는 std 트레이트는?",
          "邊個 std trait，空身體 impl 一下，就令 OrderError 變成真正嘅 error？"
        ),
        code = L(
          [[
// Debug + Display are done, so the body can stay empty
impl ___ for OrderError {}
]],
          [[
// Debug + Display 완료; 본문은 비워도 됨
impl ___ for OrderError {}
]],
          [[
// Debug + Display 搞掂咗，所以身體可以留空
impl ___ for OrderError {}
]]
        ),
        accept = { "std::error::Error", "error::Error", "Error" },
        answer = "std::error::Error",
        hint = L(
          "Module error, trait of the same name with a capital. Every method has a default.",
          "error 모듈, 대문자로 시작하는 같은 이름의 트레이트. 모든 메서드에 기본값이 있다.",
          "error 呢個 module，同名大寫嘅 trait。每個 method 都有預設。"
        ),
        ok = L(
          "impl std::error::Error for OrderError {} - now it fits in Box<dyn Error> and ? chains.",
          "impl std::error::Error for OrderError {} - 이제 Box<dyn Error>와 ? 체인에 들어간다.",
          "impl std::error::Error for OrderError {} - 而家可以放入 Box<dyn Error>，? 亦串得起。"
        ),
      },
      {
        topic = "FROM",
        q = L(
          "Let ? turn a ParseIntError into OrderError by itself. Which trait do you implement?",
          "?가 ParseIntError를 알아서 OrderError로 바꾸게 한다. 어떤 트레이트를 구현?",
          "令 ? 自己將 ParseIntError 變成 OrderError。implement 邊個 trait？"
        ),
        code = L(
          [[
impl ___<ParseIntError> for OrderError {
    fn from(e: ParseIntError) -> Self {
        OrderError::BadQty(e)
    }
}
// "1x8".parse::<i32>()? now becomes BadQty
]],
          [[
impl ___<ParseIntError> for OrderError {
    fn from(e: ParseIntError) -> Self {
        OrderError::BadQty(e)
    }
}
// 이제 "1x8".parse::<i32>()? 는 BadQty가 된다
]],
          [[
impl ___<ParseIntError> for OrderError {
    fn from(e: ParseIntError) -> Self {
        OrderError::BadQty(e)
    }
}
// "1x8".parse::<i32>()? 而家會變成 BadQty
]]
        ),
        accept = { "From" },
        answer = "From",
        hint = L(
          "The same trait String::from comes from. Capital F, one generic parameter.",
          "String::from이 나오는 그 트레이트. 대문자 F, 제네릭 파라미터 하나.",
          "String::from 出自嘅同一個 trait。大寫 F，一個 generic 參數。"
        ),
        ok = L(
          "? calls From::from on the error. Without the impl, use .map_err(OrderError::BadQty) by hand.",
          "?는 에러에 From::from을 부른다. impl이 없으면 .map_err(OrderError::BadQty)를 직접 쓴다.",
          "? 會對個 error call From::from。冇呢個 impl 就要自己寫 .map_err(OrderError::BadQty)。"
        ),
      },
      {
        topic = "DYN",
        q = L(
          "main can fail in many ways. Which pointer type wraps any dyn Error?",
          "main은 여러 방식으로 실패할 수 있다. 어떤 dyn Error든 감싸는 포인터 타입은?",
          "main 可以有好多種失敗。邊個 pointer type 包得住任何 dyn Error？"
        ),
        code = L(
          [[
use std::error::Error;
fn main() -> Result<(), ___<dyn Error>> {
    let qty: i32 = "18".parse()?;   // ParseIntError fits
    let text = std::fs::read_to_string("menu.txt")?;
    println!("{qty} sets, {} bytes of menu", text.len());
    Ok(())
}
]],
          [[
use std::error::Error;
fn main() -> Result<(), ___<dyn Error>> {
    let qty: i32 = "18".parse()?;   // ParseIntError도 OK
    let text = std::fs::read_to_string("menu.txt")?;
    println!("{qty} sets, {} bytes of menu", text.len());
    Ok(())
}
]],
          [[
use std::error::Error;
fn main() -> Result<(), ___<dyn Error>> {
    let qty: i32 = "18".parse()?;   // ParseIntError 都得
    let text = std::fs::read_to_string("menu.txt")?;
    println!("{qty} sets, {} bytes of menu", text.len());
    Ok(())
}
]]
        ),
        accept = { "Box" },
        answer = "Box",
        hint = L(
          "Three letters. Heap pointer. dyn has no known size, so it must live behind one.",
          "세 글자. 힙 포인터. dyn은 크기를 모르니 포인터 뒤에 있어야 한다.",
          "三個字母。heap pointer。dyn 唔知幾大，所以要擺喺 pointer 後面。"
        ),
        ok = L(
          "Box<dyn Error> accepts any error type via From. Good for main and prototypes, not libraries.",
          "Box<dyn Error>는 From으로 어떤 에러 타입이든 받는다. main과 프로토타입에 좋고 라이브러리엔 아님.",
          "Box<dyn Error> 經 From 收任何 error type。適合 main 同 prototype，唔適合 library。"
        ),
      },
      {
        topic = "CRATE",
        q = L(
          'A crate writes Display and Error for you from #[error("..")]. Its name?',
          '#[error("..")]로 Display와 Error를 대신 써 주는 크레이트. 이름은?',
          '有個 crate 會由 #[error("..")] 幫你寫 Display 同 Error。叫咩名？'
        ),
        code = L(
          [[
// Cargo.toml: [dependencies] has this crate at version 1
use ___::Error;
#[derive(Debug, Error)]
enum OrderError {
    #[error("order is empty")]
    Empty,
}
]],
          [[
// Cargo.toml [dependencies] 에 버전 1로 추가
use ___::Error;
#[derive(Debug, Error)]
enum OrderError {
    #[error("order is empty")]
    Empty,
}
]],
          [[
// Cargo.toml: [dependencies] 有呢個 crate，版本 1
use ___::Error;
#[derive(Debug, Error)]
enum OrderError {
    #[error("order is empty")]
    Empty,
}
]]
        ),
        accept = { "thiserror" },
        answer = "thiserror",
        hint = L(
          "Two English words glued together: this and the thing you are deriving. Not anyhow.",
          "영어 단어 둘을 붙인 것: this와 지금 derive하는 그것. anyhow는 아니다.",
          "兩個英文字黐埋：this 加你而家 derive 嘅嘢。唔係 anyhow。"
        ),
        ok = L(
          "thiserror derives Display + Error; #[from] even writes the From impl. Ticket two closed.",
          "thiserror가 Display + Error를 derive; #[from]은 From impl까지 써 준다. 두 번째 티켓 닫힘.",
          "thiserror derive Display + Error；#[from] 連 From impl 都幫你寫。第二張 ticket 閂咗。"
        ),
      },
    },
  },

  {
    id = "rs_iter",
    station = "ITER",
    name = L("The Express kitchen", "익스프레스 주방", "Express 廚房"),
    title = L("Iterators and closures", "이터레이터와 클로저", "iterator 同 closure"),
    lesson = L(
      "iter() borrows, into_iter() consumes. map, filter, collect, sum, fold: no index bugs.",
      "iter()는 빌리고 into_iter()는 소비한다. map, filter, collect, sum, fold: 인덱스 버그 없음.",
      "iter() 係借，into_iter() 係食咗。map、filter、collect、sum、fold：冇 index bug。"
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
        x = 600,
        facing = -1,
        line = L(
          "The ticket printer skips dish zero and prints dish five twice. Fix the loop.",
          "티켓 프린터가 0번 요리를 건너뛰고 5번을 두 번 찍어. 루프를 고쳐.",
          "出單機跳過第零碟，第五碟印兩次。整好個 loop。"
        ),
      },
    },
    viz = "rust",
    chips = {
      { "dishes.iter()", "cyan" },
      { ".map(|x| x * 2)", "gold" },
      { ".collect::<Vec<_>>()", "pink" },
      { ".fold(0, |a, x| a + x)", "green" },
    },
    note = "iter  map  filter  collect  sum  fold",
    story = L(
      "17:20. The kitchen printer at Lucky Mac Express runs a hand-written index loop. It skips "
        .. "the first dish and prints the last one twice. Chef Bo hands Alex ticket three: iterators.",
      "17:20. 익스프레스 주방 프린터가 손으로 짠 인덱스 루프를 돈다. 첫 요리를 건너뛰고 "
        .. "마지막 요리를 두 번 찍는다. 보 셰프가 알렉스에게 세 번째 티켓을 건넨다: 이터레이터.",
      "五點二十。Express 廚房出單機行一個手寫嘅 index loop。跳過第一碟，"
        .. "最後一碟印兩次。波師傅將第三張 ticket 交俾阿力：iterator。"
    ),
    stages = {
      {
        topic = "ITER",
        q = L(
          "Walk over a Vec by reference, no index. Which method starts the iterator?",
          "인덱스 없이 Vec을 참조로 훑는다. 이터레이터를 시작하는 메서드는?",
          "唔用 index，用 reference 行勻個 Vec。邊個 method 開始個 iterator？"
        ),
        code = L(
          [[
let dishes = vec!["curry rice", "noodles", "toast"];
// borrows every element as &&str; dishes stays usable
for d in dishes.___() {
    println!("ticket: {d}");
}
]],
          [[
let dishes = vec!["curry rice", "noodles", "toast"];
// &&str로 빌림; dishes는 그대로 남는다
for d in dishes.___() {
    println!("ticket: {d}");
}
]],
          [[
let dishes = vec!["curry rice", "noodles", "toast"];
// 每個元素借做 &&str；dishes 之後仲用得
for d in dishes.___() {
    println!("ticket: {d}");
}
]]
        ),
        accept = { "iter", "iter()" },
        answer = "iter",
        hint = L(
          "Four letters. The borrowing one. into_ in front of it would consume the Vec.",
          "네 글자. 빌리는 쪽. 앞에 into_를 붙이면 Vec을 소비한다.",
          "四個字母。借嘅嗰個。前面加 into_ 就會食咗個 Vec。"
        ),
        ok = L(
          "iter() yields &T. into_iter() yields T and eats the Vec. Dish zero prints again.",
          "iter()는 &T를 낸다. into_iter()는 T를 내고 Vec을 먹는다. 0번 요리가 다시 찍힌다.",
          "iter() 出 &T。into_iter() 出 T，仲食咗個 Vec。第零碟又印得返。"
        ),
      },
      {
        topic = "CLOSURE",
        q = L(
          "Double every quantity. How does a closure name its one parameter?",
          "모든 수량을 두 배로. 클로저는 파라미터 하나를 어떻게 이름 붙이나?",
          "每個數量乘二。closure 點樣寫佢唯一嘅參數？"
        ),
        code = L(
          [[
let qty = vec![1, 2, 3];
// a closure: the parameter sits between two pipes
let doubled: Vec<i32> = qty.iter().map(___ x * 2).collect();
assert_eq!(doubled, vec![2, 4, 6]);
]],
          [[
let qty = vec![1, 2, 3];
// 클로저: 파라미터는 두 파이프 사이에 있다
let doubled: Vec<i32> = qty.iter().map(___ x * 2).collect();
assert_eq!(doubled, vec![2, 4, 6]);
]],
          [[
let qty = vec![1, 2, 3];
// closure：參數放喺兩條直線中間
let doubled: Vec<i32> = qty.iter().map(___ x * 2).collect();
assert_eq!(doubled, vec![2, 4, 6]);
]]
        ),
        accept = { "|x|", "| x |" },
        answer = "|x|",
        hint = L(
          "The name x, wrapped in the vertical bar character on both sides.",
          "이름 x를 양쪽에서 세로 막대 문자로 감싼다.",
          "個名 x，兩邊用直線符號包住。"
        ),
        ok = L(
          "|x| x * 2 is a closure. It captures nothing here; map calls it for every &i32.",
          "|x| x * 2는 클로저. 여기선 아무것도 캡처하지 않는다; map이 &i32마다 부른다.",
          "|x| x * 2 係 closure。呢度冇 capture 任何嘢；map 對每個 &i32 call 一次。"
        ),
      },
      {
        topic = "FILTER",
        q = L(
          "Keep only paid orders. Which adapter takes a bool closure?",
          "결제된 주문만 남긴다. bool 클로저를 받는 어댑터는?",
          "只留低已付款嘅單。邊個 adapter 收一個回傳 bool 嘅 closure？"
        ),
        code = L(
          [[
let bill = vec![18, 0, 42, 0, 25];
// into_iter gives i32; the closure sees &i32
let ok: Vec<_> = bill.into_iter().___(|p| *p > 0).collect();
assert_eq!(ok, vec![18, 42, 25]);
]],
          [[
let bill = vec![18, 0, 42, 0, 25];
// into_iter는 i32를 낸다; 클로저는 &i32를 본다
let ok: Vec<_> = bill.into_iter().___(|p| *p > 0).collect();
assert_eq!(ok, vec![18, 42, 25]);
]],
          [[
let bill = vec![18, 0, 42, 0, 25];
// into_iter 出 i32；closure 見到 &i32
let ok: Vec<_> = bill.into_iter().___(|p| *p > 0).collect();
assert_eq!(ok, vec![18, 42, 25]);
]]
        ),
        accept = { "filter" },
        answer = "filter",
        hint = L(
          "Six letters. Like a coffee one: only what passes the test comes through.",
          "여섯 글자. 커피 거르는 것처럼: 검사를 통과한 것만 지나간다.",
          "六個字母。好似沖咖啡嗰個：過到關嘅先落得到。"
        ),
        ok = L(
          "filter keeps items where the closure is true. It is lazy until collect pulls.",
          "filter는 클로저가 true인 항목을 남긴다. collect가 끌어당길 때까지 게으르다.",
          "filter 留低 closure 回傳 true 嘅項目。collect 拉之前佢係 lazy 嘅。"
        ),
      },
      {
        topic = "COLLECT",
        q = L(
          "Turn the lazy chain back into a Vec. Which method finishes it?",
          "게으른 체인을 다시 Vec으로. 마무리하는 메서드는?",
          "將個 lazy chain 變返做 Vec。邊個 method 收尾？"
        ),
        code = L(
          [[
let dishes = ["curry rice", "noodles", "toast"];
// nothing runs before this call; turbofish names the type
let lens = dishes.iter().map(|d| d.len()).___::<Vec<_>>();
assert_eq!(lens, vec![10, 7, 5]);
]],
          [[
let dishes = ["curry rice", "noodles", "toast"];
// 여기까지 게으름; 터보피시가 타입 지정
let lens = dishes.iter().map(|d| d.len()).___::<Vec<_>>();
assert_eq!(lens, vec![10, 7, 5]);
]],
          [[
let dishes = ["curry rice", "noodles", "toast"];
// 呢個 call 之前咩都未行；turbofish 講明目標
let lens = dishes.iter().map(|d| d.len()).___::<Vec<_>>();
assert_eq!(lens, vec![10, 7, 5]);
]]
        ),
        accept = { "collect" },
        answer = "collect",
        hint = L(
          "Seven letters. Gather everything into a container: Vec, String, HashMap, even Result.",
          "일곱 글자. 모두 컨테이너로 모은다: Vec, String, HashMap, Result까지.",
          "七個字母。將所有嘢收集入一個容器：Vec、String、HashMap，連 Result 都得。"
        ),
        ok = L(
          "collect::<Vec<_>>() or let v: Vec<_> = ...collect(). Iterators are lazy until then.",
          "collect::<Vec<_>>() 또는 let v: Vec<_> = ...collect(). 그때까지 이터레이터는 게으르다.",
          "collect::<Vec<_>>() 或者 let v: Vec<_> = ...collect()。之前 iterator 一直係 lazy。"
        ),
      },
      {
        topic = "SUM",
        q = L(
          "Add up the bill in one call. Which method?",
          "한 번의 호출로 계산서를 합산. 어떤 메서드?",
          "一個 call 加埋成張單。邊個 method？"
        ),
        code = L(
          [[
let prices = vec![18, 42, 25];
// the turbofish tells it which number type to add into
let total = prices.iter().___::<i32>();
assert_eq!(total, 85);
]],
          [[
let prices = vec![18, 42, 25];
// 터보피시가 더할 숫자 타입을 정한다
let total = prices.iter().___::<i32>();
assert_eq!(total, 85);
]],
          [[
let prices = vec![18, 42, 25];
// turbofish 話俾佢知加入邊種數字 type
let total = prices.iter().___::<i32>();
assert_eq!(total, 85);
]]
        ),
        accept = { "sum" },
        answer = "sum",
        hint = L(
          "Three letters. The maths word for adding up. product() is its cousin.",
          "세 글자. 더하기의 수학 용어. product()가 사촌이다.",
          "三個字母。數學上加埋嘅意思。product() 係佢表親。"
        ),
        ok = L(
          "sum::<i32>() adds &i32 into an i32. Without the turbofish Rust cannot pick the type.",
          "sum::<i32>()는 &i32를 i32로 더한다. 터보피시가 없으면 러스트가 타입을 못 고른다.",
          "sum::<i32>() 將 &i32 加做一個 i32。冇 turbofish，Rust 揀唔到 type。"
        ),
      },
      {
        topic = "INDEX",
        q = L(
          "You still want the position of every dish on the ticket. Which adapter adds it?",
          "티켓에 요리마다 순번이 필요하다. 순번을 붙이는 어댑터는?",
          "你仲想要每碟菜喺單上面嘅位置。邊個 adapter 加埋佢？"
        ),
        code = L(
          [[
let dishes = ["curry rice", "noodles", "toast"];
// yields (usize, &&str) pairs, starting from 0
for (i, d) in dishes.iter().___() {
    println!("{}. {d}", i + 1);
}
]],
          [[
let dishes = ["curry rice", "noodles", "toast"];
// (usize, &&str) 쌍을 0부터 낸다
for (i, d) in dishes.iter().___() {
    println!("{}. {d}", i + 1);
}
]],
          [[
let dishes = ["curry rice", "noodles", "toast"];
// 出 (usize, &&str) 一對對，由 0 開始
for (i, d) in dishes.iter().___() {
    println!("{}. {d}", i + 1);
}
]]
        ),
        accept = { "enumerate" },
        answer = "enumerate",
        hint = L(
          "Nine letters. To number things one by one. zip() pairs two iterators instead.",
          "아홉 글자. 하나씩 번호를 매기다. zip()은 대신 이터레이터 둘을 짝짓는다.",
          "九個字母。一個一個咁編號。zip() 就係將兩個 iterator 配對。"
        ),
        ok = L(
          "enumerate() gives (index, item). zip(prices) would give (dish, price). No off-by-one.",
          "enumerate()는 (인덱스, 항목). zip(prices)는 (요리, 가격). 하나 어긋남 없음.",
          "enumerate() 出 (index, item)。zip(prices) 就出 (dish, price)。唔會差一。"
        ),
      },
      {
        topic = "FOLD",
        q = L(
          "Reduce with your own start value and closure. Which method?",
          "시작값과 클로저를 직접 주고 줄인다. 어떤 메서드?",
          "自己俾初始值同 closure 去縮減。邊個 method？"
        ),
        code = L(
          [[
let prices = vec![18, 42, 25];
// acc starts at 0; the closure returns the next acc
let total = prices.iter().___(0, |acc, p| acc + p);
assert_eq!(total, 85);
]],
          [[
let prices = vec![18, 42, 25];
// acc는 0에서 시작; 클로저가 다음 acc를 반환
let total = prices.iter().___(0, |acc, p| acc + p);
assert_eq!(total, 85);
]],
          [[
let prices = vec![18, 42, 25];
// acc 由 0 開始；closure 回傳下一個 acc
let total = prices.iter().___(0, |acc, p| acc + p);
assert_eq!(total, 85);
]]
        ),
        accept = { "fold" },
        answer = "fold",
        hint = L(
          "Four letters. What you do to a paper napkin, over and over, into one small square.",
          "네 글자. 종이 냅킨을 접고 또 접어 작은 네모 하나로 만드는 것.",
          "四個字母。你對紙巾做嘅動作，摺完再摺，變一個細方塊。"
        ),
        ok = L(
          "fold(init, |acc, x| ..) is the general reduce; sum is fold(0, +). Ticket three closed.",
          "fold(init, |acc, x| ..)가 일반 reduce; sum은 fold(0, +). 세 번째 티켓 닫힘.",
          "fold(init, |acc, x| ..) 係通用嘅 reduce；sum 就係 fold(0, +)。第三張 ticket 閂咗。"
        ),
      },
    },
  },

  {
    id = "rs_serde",
    station = "SERDE",
    name = L("The mall atrium", "쇼핑몰 아트리움", "商場中庭"),
    title = L("serde and JSON", "serde와 JSON", "serde 同 JSON"),
    lesson = L(
      "derive Serialize and Deserialize, then serde_json::to_string and from_str. Attributes shape the JSON.",
      "Serialize와 Deserialize를 derive하고 serde_json::to_string과 from_str. 속성이 JSON 모양을 정한다.",
      "derive Serialize 同 Deserialize，然後 serde_json::to_string 同 from_str。attribute 決定 JSON 個樣。"
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
        x = 520,
        facing = -1,
        line = L(
          'The rider app sends JSON with "dish", our struct says "name". serde can bridge it.',
          '라이더 앱은 "dish"로 JSON을 보내고 우리 struct는 "name"이래. serde가 이어 줄 수 있어.',
          '車手 app 送 JSON 用 "dish"，我哋個 struct 叫 "name"。serde 可以駁通。'
        ),
      },
      {
        kind = "hero",
        x = 660,
        facing = -1,
        line = L(
          "In Go I would write a json tag. Show me the Rust way.",
          "Go라면 json 태그를 쓸 텐데. 러스트 방식을 보여 줘.",
          "Go 我會寫 json tag。俾我睇 Rust 點做。"
        ),
      },
    },
    viz = "rust",
    chips = {
      { "#[derive(Serialize)]", "cyan" },
      { "serde_json::to_string", "gold" },
      { "#[serde(rename = ..)]", "pink" },
      { "serde_json::Value", "green" },
    },
    note = "Serialize  to_string  from_str  rename  Value",
    story = L(
      "17:30. Under the mall atrium screens, the rider app and the kitchen disagree on field names, "
        .. 'and every order arrives as "name": null. Ticket four: teach the structs to speak JSON with serde.',
      "17:30. 쇼핑몰 아트리움 화면 아래, 라이더 앱과 주방이 필드 이름에서 어긋나 "
        .. '모든 주문이 "name": null로 들어온다. 네 번째 티켓: serde로 struct에 JSON을 가르친다.',
      "五點半。商場中庭大屏幕下面，車手 app 同廚房嘅 field 名唔對，"
        .. '每張單都變成 "name": null 送到。第四張 ticket：用 serde 教 struct 講 JSON。'
    ),
    stages = {
      {
        topic = "DERIVE",
        q = L(
          "Let serde write the JSON code for the struct. Which trait goes with Deserialize?",
          "serde가 struct의 JSON 코드를 대신 쓰게 한다. Deserialize와 짝인 트레이트는?",
          "俾 serde 幫個 struct 寫 JSON 代碼。同 Deserialize 一齊嘅 trait 係邊個？"
        ),
        code = L(
          [[
use serde::{Deserialize, ___};
// Cargo.toml: serde = {version="1", features=["derive"]}
#[derive(Debug, ___, Deserialize)]
struct Order {
    name: String,
    qty: u32,
}
]],
          [[
use serde::{Deserialize, ___};
// Cargo.toml: serde = {version="1", features=["derive"]}
#[derive(Debug, ___, Deserialize)]
struct Order {
    name: String,
    qty: u32,
}
]],
          [[
use serde::{Deserialize, ___};
// Cargo.toml: serde = {version="1", features=["derive"]}
#[derive(Debug, ___, Deserialize)]
struct Order {
    name: String,
    qty: u32,
}
]]
        ),
        accept = { "Serialize" },
        answer = "Serialize",
        hint = L(
          "The other direction: struct to bytes. Same word without the De in front.",
          "반대 방향: struct에서 바이트로. 앞의 De를 뺀 같은 단어.",
          "反方向：struct 變 byte。同一個字，冇咗前面嘅 De。"
        ),
        ok = L(
          "derive(Serialize, Deserialize) needs the derive feature in Cargo.toml. serde_json does the format.",
          "derive(Serialize, Deserialize)는 Cargo.toml의 derive 기능이 필요. 포맷은 serde_json이 한다.",
          "derive(Serialize, Deserialize) 要 Cargo.toml 開 derive feature。格式由 serde_json 負責。"
        ),
      },
      {
        topic = "ENCODE",
        q = L(
          "Turn the Order into a JSON String. Which serde_json function?",
          "Order를 JSON String으로. serde_json의 어떤 함수?",
          "將 Order 變成 JSON String。serde_json 邊個 function？"
        ),
        code = L(
          [[
let order = Order { name: "toast".into(), qty: 2 };
// takes a reference; returns Result<String, Error>
let text = serde_json::___(&order)?;
assert_eq!(text, r#"{"name":"toast","qty":2}"#);
]],
          [[
let order = Order { name: "toast".into(), qty: 2 };
// 참조를 받는다; Result<String, Error> 반환
let text = serde_json::___(&order)?;
assert_eq!(text, r#"{"name":"toast","qty":2}"#);
]],
          [[
let order = Order { name: "toast".into(), qty: 2 };
// 收 reference；回傳 Result<String, Error>
let text = serde_json::___(&order)?;
assert_eq!(text, r#"{"name":"toast","qty":2}"#);
]]
        ),
        accept = { "to_string", "tostring", "serde_json::to_string" },
        answer = "to_string",
        hint = L(
          "Same name as the Display helper on any value. to_string_pretty adds newlines.",
          "아무 값에나 있는 Display 헬퍼와 같은 이름. to_string_pretty는 줄바꿈을 넣는다.",
          "同任何值上面嘅 Display helper 一樣名。to_string_pretty 會加換行。"
        ),
        ok = L(
          "serde_json::to_string(&order) -> compact JSON. to_vec gives bytes, to_writer streams.",
          "serde_json::to_string(&order) -> 압축 JSON. to_vec은 바이트, to_writer는 스트림.",
          "serde_json::to_string(&order) -> 壓縮 JSON。to_vec 出 byte，to_writer 就串流。"
        ),
      },
      {
        topic = "DECODE",
        q = L(
          "The rider app sends text. Parse it back into an Order. Which function?",
          "라이더 앱이 텍스트를 보낸다. 다시 Order로 파싱. 어떤 함수?",
          "車手 app 送嚟文字。解析返做 Order。邊個 function？"
        ),
        code = L(
          [[
let text = r#"{"name":"noodles","qty":1}"#;
// the type annotation tells serde what to build
let order: Order = serde_json::___(text)?;
assert_eq!(order.qty, 1);
]],
          [[
let text = r#"{"name":"noodles","qty":1}"#;
// 타입 표기가 serde에 목표를 알려준다
let order: Order = serde_json::___(text)?;
assert_eq!(order.qty, 1);
]],
          [[
let text = r#"{"name":"noodles","qty":1}"#;
// type 註明話俾 serde 知要砌咩
let order: Order = serde_json::___(text)?;
assert_eq!(order.qty, 1);
]]
        ),
        accept = { "from_str", "fromstr", "serde_json::from_str" },
        answer = "from_str",
        hint = L(
          "From a str. Two words with an underscore, like the FromStr trait in lowercase.",
          "str에서. 밑줄 있는 두 단어, FromStr 트레이트를 소문자로 쓴 것처럼.",
          "由 str 嚟。兩個字加底線，好似 FromStr trait 寫成細楷。"
        ),
        ok = L(
          "serde_json::from_str::<Order>(text). from_slice for bytes, from_reader for files.",
          "serde_json::from_str::<Order>(text). 바이트는 from_slice, 파일은 from_reader.",
          "serde_json::from_str::<Order>(text)。byte 用 from_slice，檔案用 from_reader。"
        ),
      },
      {
        topic = "RENAME",
        q = L(
          'The JSON says "dish" but the field is name. Which serde attribute maps them?',
          'JSON은 "dish"인데 필드는 name. 둘을 잇는 serde 속성은?',
          'JSON 寫 "dish" 但 field 叫 name。邊個 serde attribute 對返佢哋？'
        ),
        code = L(
          [[
#[derive(Serialize, Deserialize)]
struct Order {
    #[serde(___ = "dish")]
    name: String,
    qty: u32,
}
// {"dish":"toast","qty":2} now fills name
]],
          [[
#[derive(Serialize, Deserialize)]
struct Order {
    #[serde(___ = "dish")]
    name: String,
    qty: u32,
}
// 이제 {"dish":"toast","qty":2} 가 name을 채운다
]],
          [[
#[derive(Serialize, Deserialize)]
struct Order {
    #[serde(___ = "dish")]
    name: String,
    qty: u32,
}
// {"dish":"toast","qty":2} 而家會填入 name
]]
        ),
        accept = { "rename" },
        answer = "rename",
        hint = L(
          "Six letters. Give the field a different name on the wire. rename_all does a whole struct.",
          "여섯 글자. 전송 시 필드에 다른 이름을 준다. rename_all은 struct 전체에.",
          "六個字母。喺線上俾個 field 另一個名。rename_all 就成個 struct 一齊改。"
        ),
        ok = L(
          '#[serde(rename = "dish")] is the Go json tag. rename_all = "camelCase" on the struct is common.',
          '#[serde(rename = "dish")]가 Go의 json 태그. struct에 rename_all = "camelCase"도 흔하다.',
          '#[serde(rename = "dish")] 就係 Go 嘅 json tag。struct 上面寫 rename_all = "camelCase" 好常見。'
        ),
      },
      {
        topic = "SKIP",
        q = L(
          "Leave the note out of the JSON when it is None. Which attribute?",
          "note가 None이면 JSON에서 빼고 싶다. 어떤 속성?",
          "note 係 None 嗰陣唔想出現喺 JSON。邊個 attribute？"
        ),
        code = L(
          [[
#[derive(Serialize, Deserialize)]
struct Order {
    name: String,
    #[serde(___ = "Option::is_none")]
    note: Option<String>,
}
// None -> {"name":"toast"}   Some -> {"name":..,"note":..}
]],
          [[
#[derive(Serialize, Deserialize)]
struct Order {
    name: String,
    #[serde(___ = "Option::is_none")]
    note: Option<String>,
}
// None -> {"name":"toast"}   Some -> {"name":..,"note":..}
]],
          [[
#[derive(Serialize, Deserialize)]
struct Order {
    name: String,
    #[serde(___ = "Option::is_none")]
    note: Option<String>,
}
// None -> {"name":"toast"}   Some -> {"name":..,"note":..}
]]
        ),
        accept = { "skip_serializing_if", "skipserializingif" },
        answer = "skip_serializing_if",
        hint = L(
          "Three words, two underscores: skip, the verb for writing out, if. It names a predicate.",
          "세 단어, 밑줄 둘: skip, 써 내보내는 동사, if. 조건 함수를 이름으로 가리킨다.",
          "三個字，兩條底線：skip、寫出去嗰個動詞、if。佢指向一個判斷 function。"
        ),
        ok = L(
          'skip_serializing_if = "Option::is_none" drops empty fields. default fills them on the way in.',
          'skip_serializing_if = "Option::is_none"은 빈 필드를 뺀다. 들어올 땐 default가 채운다.',
          'skip_serializing_if = "Option::is_none" 會跳過空 field。入嚟嗰陣就用 default 填。'
        ),
      },
      {
        topic = "DYNAMIC",
        q = L(
          "Unknown shape from the rider app. Which serde_json type holds any JSON?",
          "라이더 앱에서 모양을 모르는 JSON. 어떤 JSON이든 담는 serde_json 타입은?",
          "車手 app 送嚟唔知咩形狀。serde_json 邊個 type 裝得任何 JSON？"
        ),
        code = L(
          [[
let text = r#"{"dish":"toast","tags":["hot","new"]}"#;
// an enum: Null, Bool, Number, String, Array, Object
let v: serde_json::___ = serde_json::from_str(text)?;
println!("{}", v["tags"][0]);   // "hot"
]],
          [[
let text = r#"{"dish":"toast","tags":["hot","new"]}"#;
// enum: Null, Bool, Number, String, Array, Object
let v: serde_json::___ = serde_json::from_str(text)?;
println!("{}", v["tags"][0]);   // "hot"
]],
          [[
let text = r#"{"dish":"toast","tags":["hot","new"]}"#;
// enum：Null、Bool、Number、String、Array、Object
let v: serde_json::___ = serde_json::from_str(text)?;
println!("{}", v["tags"][0]);   // "hot"
]]
        ),
        accept = { "Value", "serde_json::Value" },
        answer = "Value",
        hint = L(
          "Five letters. What a key maps to. The json! macro builds one.",
          "다섯 글자. 키가 가리키는 그것. json! 매크로가 하나 만든다.",
          "五個字母。key 對應嘅嗰樣嘢。json! macro 造一個出嚟。"
        ),
        ok = L(
          "serde_json::Value indexes with [] and returns Null when missing. Ticket four closed.",
          "serde_json::Value는 []로 인덱싱하고 없으면 Null. 네 번째 티켓 닫힘.",
          "serde_json::Value 用 [] 索引，冇嘅話回傳 Null。第四張 ticket 閂咗。"
        ),
      },
    },
  },

  {
    id = "rs_async",
    station = "ASYNC",
    name = L("Russell Street", "러셀 스트리트", "羅素街"),
    title = L("async and tokio", "async와 tokio", "async 同 tokio"),
    lesson = L(
      "async fn returns a Future; .await drives it. tokio runs them; spawn and join! run them at once.",
      "async fn은 Future를 반환; .await가 돌린다. tokio가 실행하고 spawn과 join!이 동시에 돌린다.",
      "async fn 回傳 Future；.await 推佢行。tokio 負責跑；spawn 同 join! 一齊跑。"
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
        x = 580,
        facing = -1,
        line = L(
          "Six riders wait on the kerb because the backend asks the map API one address at a time.",
          "백엔드가 지도 API에 주소를 하나씩 물어봐서 라이더 여섯이 길가에서 기다려.",
          "六個車手喺路邊等，因為 backend 一個地址一個地址咁問地圖 API。"
        ),
      },
    },
    viz = "rust",
    chips = {
      { "async fn eta()", "cyan" },
      { "eta().await", "gold" },
      { "#[tokio::main]", "pink" },
      { "tokio::join!(a, b)", "green" },
    },
    note = "async  .await  tokio  spawn  join!  reqwest",
    story = L(
      "17:40. Russell Street. Riders idle by the tram stop while the delivery backend fetches ETAs "
        .. "one by one, blocking on each. Ticket five: make the calls async and run them together on tokio.",
      "17:40. 러셀 스트리트. 배달 백엔드가 ETA를 하나씩, 매번 막히면서 받아오는 동안 "
        .. "라이더들이 전차 정류장 옆에서 논다. 다섯 번째 티켓: 호출을 async로 바꿔 tokio에서 동시에 돌린다.",
      "五點四十。羅素街。外賣 backend 逐個逐個攞 ETA，每次都塞住，"
        .. "車手就喺電車站旁邊等。第五張 ticket：將 call 變 async，喺 tokio 上面一齊跑。"
    ),
    stages = {
      {
        topic = "ASYNC",
        q = L(
          "Mark a function so calling it returns a Future instead of running. Which keyword?",
          "호출하면 실행 대신 Future를 돌려주도록 함수를 표시. 어떤 키워드?",
          "標記一個 function，call 佢會回傳 Future 而唔係即刻行。邊個 keyword？"
        ),
        code = L(
          [[
// calling this does nothing yet; it hands back a Future
___ fn fetch_eta(order_id: u32) -> u32 {
    tokio::time::sleep(Duration::from_millis(200)).await;
    order_id % 10 + 5
}
]],
          [[
// 호출만으론 안 돈다; Future를 돌려준다
___ fn fetch_eta(order_id: u32) -> u32 {
    tokio::time::sleep(Duration::from_millis(200)).await;
    order_id % 10 + 5
}
]],
          [[
// call 佢暫時咩都唔做；交返一個 Future 俾你
___ fn fetch_eta(order_id: u32) -> u32 {
    tokio::time::sleep(Duration::from_millis(200)).await;
    order_id % 10 + 5
}
]]
        ),
        accept = { "async" },
        answer = "async",
        hint = L(
          "Five letters, goes before fn. The opposite of sync.",
          "다섯 글자, fn 앞에 온다. sync의 반대.",
          "五個字母，放喺 fn 前面。sync 嘅相反。"
        ),
        ok = L(
          "async fn fetch_eta(..) -> u32 really returns impl Future<Output = u32>. Nothing runs until polled.",
          "async fn fetch_eta(..) -> u32는 실제로 impl Future<Output = u32>를 반환. 폴링 전엔 아무것도 안 돈다.",
          "async fn fetch_eta(..) -> u32 其實回傳 impl Future<Output = u32>。未 poll 之前咩都唔行。"
        ),
      },
      {
        topic = "AWAIT",
        q = L(
          "Actually run the Future and get the u32 out. What goes after the call?",
          "Future를 실제로 돌려 u32를 꺼낸다. 호출 뒤에 무엇이 오나?",
          "真係行個 Future，攞返個 u32。call 後面加咩？"
        ),
        code = L(
          [[
async fn plan() {
    // suspends here; other tasks run while we wait
    let eta = fetch_eta(7)___;
    println!("rider back in {eta} min");
}
]],
          [[
async fn plan() {
    // 여기서 멈춤; 다른 태스크가 돈다
    let eta = fetch_eta(7)___;
    println!("rider back in {eta} min");
}
]],
          [[
async fn plan() {
    // 喺呢度停一停；等嘅時候其他 task 照行
    let eta = fetch_eta(7)___;
    println!("rider back in {eta} min");
}
]]
        ),
        accept = { ".await", "await" },
        answer = ".await",
        hint = L(
          "A dot, then the word for waiting. Only allowed inside an async block or fn.",
          "점 다음에 기다린다는 단어. async 블록이나 fn 안에서만 허용.",
          "一個點，然後係等待嘅英文字。只可以喺 async block 或 fn 裏面用。"
        ),
        ok = L(
          ".await yields to the runtime until the Future is ready. Forget it and nothing runs.",
          ".await는 Future가 준비될 때까지 런타임에 양보한다. 잊으면 아무것도 안 돈다.",
          ".await 會讓返俾 runtime，直到 Future 準備好。漏咗佢就咩都唔會行。"
        ),
      },
      {
        topic = "RUNTIME",
        q = L(
          "Futures need a runtime. Which attribute makes main async on tokio?",
          "Future에는 런타임이 필요하다. main을 tokio 위에서 async로 만드는 속성은?",
          "Future 要有 runtime。邊個 attribute 令 main 喺 tokio 上面變 async？"
        ),
        code = L(
          [[
// Cargo.toml: tokio = {version="1", features=["full"]}
#[___]
async fn main() {
    let eta = fetch_eta(7).await;
    println!("{eta} min");
}
]],
          [[
// Cargo.toml: tokio = {version="1", features=["full"]}
#[___]
async fn main() {
    let eta = fetch_eta(7).await;
    println!("{eta} min");
}
]],
          [[
// Cargo.toml: tokio = {version="1", features=["full"]}
#[___]
async fn main() {
    let eta = fetch_eta(7).await;
    println!("{eta} min");
}
]]
        ),
        accept = { "tokio::main", "tokio main" },
        answer = "tokio::main",
        hint = L(
          "Crate name, two colons, the function it sits on.",
          "크레이트 이름, 콜론 둘, 그 아래 함수 이름.",
          "crate 名，兩個冒號，佢下面嗰個 function 嘅名。"
        ),
        ok = L(
          "#[tokio::main] builds the runtime and block_on(main()). Use #[tokio::test] in tests.",
          "#[tokio::main]은 런타임을 만들고 block_on(main()). 테스트에는 #[tokio::test].",
          "#[tokio::main] 起個 runtime 然後 block_on(main())。test 就用 #[tokio::test]。"
        ),
      },
      {
        topic = "SPAWN",
        q = L(
          "Start a task in the background and keep going. Which tokio function?",
          "백그라운드에서 태스크를 시작하고 계속 진행. tokio의 어떤 함수?",
          "喺背景開一個 task，自己繼續行。tokio 邊個 function？"
        ),
        code = L(
          [[
// returns a JoinHandle; the task runs on the pool now
let handle = tokio::___(async { fetch_eta(3).await });
print_menu().await;
let eta = handle.await?;
]],
          [[
// JoinHandle 반환; 태스크는 풀에서 돈다
let handle = tokio::___(async { fetch_eta(3).await });
print_menu().await;
let eta = handle.await?;
]],
          [[
// 回傳 JoinHandle；個 task 而家喺 pool 上面行
let handle = tokio::___(async { fetch_eta(3).await });
print_menu().await;
let eta = handle.await?;
]]
        ),
        accept = { "spawn", "tokio::spawn" },
        answer = "spawn",
        hint = L(
          "Five letters. Same verb as std::thread uses to start a new thread.",
          "다섯 글자. std::thread가 새 스레드를 시작할 때 쓰는 동사와 같다.",
          "五個字母。同 std::thread 開新 thread 用嘅動詞一樣。"
        ),
        ok = L(
          "tokio::spawn needs a 'static + Send future. handle.await gives Result<T, JoinError>.",
          "tokio::spawn은 'static + Send인 future가 필요. handle.await는 Result<T, JoinError>.",
          "tokio::spawn 要個 future 係 'static + Send。handle.await 出 Result<T, JoinError>。"
        ),
      },
      {
        topic = "JOIN",
        q = L(
          "Two ETAs at the same time, both results in one tuple. Which tokio macro?",
          "ETA 둘을 동시에, 결과 둘을 튜플 하나로. tokio의 어떤 매크로?",
          "兩個 ETA 同時攞，兩個結果放一個 tuple。tokio 邊個 macro？"
        ),
        code = L(
          [[
// both futures make progress on this task at once
let (a, b) = tokio::___!(fetch_eta(1), fetch_eta(2));
println!("rider A {a} min, rider B {b} min");
]],
          [[
// 두 future가 이 태스크에서 동시에 진행된다
let (a, b) = tokio::___!(fetch_eta(1), fetch_eta(2));
println!("rider A {a} min, rider B {b} min");
]],
          [[
// 兩個 future 喺呢個 task 上面同時前進
let (a, b) = tokio::___!(fetch_eta(1), fetch_eta(2));
println!("rider A {a} min, rider B {b} min");
]]
        ),
        accept = { "join", "join!", "tokio::join" },
        answer = "join",
        hint = L(
          "Four letters. Threads use the same word to wait for each other.",
          "네 글자. 스레드도 서로 기다릴 때 같은 단어를 쓴다.",
          "四個字母。thread 等對方嗰陣都用呢個字。"
        ),
        ok = L(
          "join! waits for all; select! returns on the first. 200 ms total instead of 400.",
          "join!은 모두 기다리고 select!는 첫 것에서 반환. 400 대신 총 200 ms.",
          "join! 等齊所有；select! 第一個完就返。總共 200 ms，唔係 400。"
        ),
      },
      {
        topic = "HTTP",
        q = L(
          "Call the map API over HTTP with one line. Which popular async client crate?",
          "지도 API를 HTTP로 한 줄에 호출. 인기 있는 async 클라이언트 크레이트는?",
          "一行用 HTTP call 地圖 API。邊個流行嘅 async client crate？"
        ),
        code = L(
          [[
async fn eta(url: &str) -> Result<String, Box<dyn Error>> {
    // GET, wait for headers, then wait for the body
    let body = ___::get(url).await?.text().await?;
    Ok(body)
}
]],
          [[
async fn eta(url: &str) -> Result<String, Box<dyn Error>> {
    // GET 후 헤더, 그다음 본문을 기다린다
    let body = ___::get(url).await?.text().await?;
    Ok(body)
}
]],
          [[
async fn eta(url: &str) -> Result<String, Box<dyn Error>> {
    // GET，等 header，再等 body
    let body = ___::get(url).await?.text().await?;
    Ok(body)
}
]]
        ),
        accept = { "reqwest" },
        answer = "reqwest",
        hint = L(
          "Sounds like request, spelled with a w. Built on hyper and tokio.",
          "request처럼 들리지만 w로 쓴다. hyper와 tokio 위에 만들어졌다.",
          "讀起嚟似 request，但係用 w 串。喺 hyper 同 tokio 上面起嘅。"
        ),
        ok = L(
          "reqwest::get(url).await?.text().await? - two awaits, two places it can fail. Riders roll out.",
          "reqwest::get(url).await?.text().await? - await 둘, 실패 지점 둘. 라이더들이 출발한다.",
          "reqwest::get(url).await?.text().await? - 兩個 await，兩個可能失敗嘅位。車手出發。"
        ),
      },
    },
  },

  {
    id = "rs_cargo",
    station = "CARGO",
    name = L("The pickup queue", "픽업 줄", "取餐排隊"),
    title = L("Cargo, the build tool", "빌드 도구 Cargo", "Cargo 建置工具"),
    lesson = L(
      "cargo new, add, build --release, test, clippy, fmt. Cargo.toml asks, Cargo.lock pins.",
      "cargo new, add, build --release, test, clippy, fmt. Cargo.toml은 요청하고 Cargo.lock은 고정한다.",
      "cargo new、add、build --release、test、clippy、fmt。Cargo.toml 開口要，Cargo.lock 釘死版本。"
    ),
    bg = "bg_queue",
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
          "Code is done. Now build it like a Rustacean: one tool for everything. Ticket six.",
          "코드는 끝. 이제 러스타시안처럼 빌드해: 도구 하나로 전부. 여섯 번째 티켓.",
          "code 寫完。而家學 Rustacean 咁 build：一個工具做齊。第六張 ticket。"
        ),
      },
    },
    viz = "rust",
    chips = {
      { "cargo new delivery", "cyan" },
      { "[dependencies]", "gold" },
      { "cargo build --release", "pink" },
      { "cargo clippy", "green" },
    },
    note = "new  add  build  test  clippy  fmt  Cargo.lock",
    story = L(
      "17:50. The pickup queue at Lucky Mac Express is out the door and the new backend is still a "
        .. "folder of .rs files. Alex has go build in his fingers. Mei: in Rust it is all cargo.",
      "17:50. 익스프레스 픽업 줄이 문밖까지 늘어섰는데 새 백엔드는 아직 .rs 파일 폴더일 뿐. "
        .. "알렉스 손가락은 go build에 익숙하다. 메이: 러스트는 전부 cargo야.",
      "五點五十。Express 取餐條隊排到出門口，新 backend 仲只係一個 .rs 檔資料夾。"
        .. "阿力手指習慣咗 go build。阿美：Rust 全部都係 cargo。"
    ),
    stages = {
      {
        topic = "NEW",
        q = L(
          "Create a fresh binary project called delivery. Which cargo subcommand?",
          "delivery라는 새 바이너리 프로젝트를 만든다. cargo의 어떤 서브커맨드?",
          "開一個叫 delivery 嘅新 binary 項目。cargo 邊個 subcommand？"
        ),
        code = L(
          [[
$ cargo ___ delivery
     Created binary (application) `delivery` package
$ ls delivery
Cargo.toml  src/main.rs
]],
          [[
$ cargo ___ delivery
     Created binary (application) `delivery` package
$ ls delivery
Cargo.toml  src/main.rs
]],
          [[
$ cargo ___ delivery
     Created binary (application) `delivery` package
$ ls delivery
Cargo.toml  src/main.rs
]]
        ),
        accept = { "new" },
        answer = "new",
        hint = L(
          "Three letters. Same word as Vec::new. Add --lib for a library instead.",
          "세 글자. Vec::new의 그 단어. 라이브러리면 --lib을 붙인다.",
          "三個字母。同 Vec::new 同一個字。想要 library 就加 --lib。"
        ),
        ok = L(
          "cargo new makes Cargo.toml, src/main.rs and a git repo. cargo init does it in an existing folder.",
          "cargo new는 Cargo.toml, src/main.rs, git 저장소를 만든다. 기존 폴더에는 cargo init.",
          "cargo new 造 Cargo.toml、src/main.rs 同 git repo。已有資料夾就用 cargo init。"
        ),
      },
      {
        topic = "TOML",
        q = L(
          "Which Cargo.toml section lists the crates the project uses?",
          "프로젝트가 쓰는 크레이트를 나열하는 Cargo.toml 섹션은?",
          "Cargo.toml 邊一節列出項目用嘅 crate？"
        ),
        code = L(
          [[
[package]
name = "delivery"
edition = "2021"

[___]
serde = { version = "1", features = ["derive"] }
tokio = { version = "1", features = ["full"] }
]],
          [[
[package]
name = "delivery"
edition = "2021"

[___]
serde = { version = "1", features = ["derive"] }
tokio = { version = "1", features = ["full"] }
]],
          [[
[package]
name = "delivery"
edition = "2021"

[___]
serde = { version = "1", features = ["derive"] }
tokio = { version = "1", features = ["full"] }
]]
        ),
        accept = { "dependencies", "[dependencies]" },
        answer = "dependencies",
        hint = L(
          "Twelve letters. Things the project depends on. dev-... is the variant for tests only.",
          "열두 글자. 프로젝트가 의존하는 것들. dev-...는 테스트 전용 변형.",
          "十二個字母。項目依賴嘅嘢。dev-... 係只俾 test 用嘅版本。"
        ),
        ok = L(
          "[dependencies] asks for versions; Cargo.lock records the exact ones. Commit the lock for binaries.",
          "[dependencies]는 버전을 요청하고 Cargo.lock은 정확한 버전을 기록. 바이너리는 lock을 커밋한다.",
          "[dependencies] 要求版本；Cargo.lock 記低準確版本。binary 項目要 commit 個 lock。"
        ),
      },
      {
        topic = "ADD",
        q = L(
          "Pull a crate in from the terminal without editing the file by hand. Which subcommand?",
          "파일을 손으로 고치지 않고 터미널에서 크레이트를 추가. 어떤 서브커맨드?",
          "唔想手改檔案，直接喺終端機加一個 crate。邊個 subcommand？"
        ),
        code = L(
          [[
$ cargo ___ reqwest --features json
    Updating crates.io index
      Adding reqwest v0.12 to dependencies
]],
          [[
$ cargo ___ reqwest --features json
    Updating crates.io index
      Adding reqwest v0.12 to dependencies
]],
          [[
$ cargo ___ reqwest --features json
    Updating crates.io index
      Adding reqwest v0.12 to dependencies
]]
        ),
        accept = { "add" },
        answer = "add",
        hint = L(
          "Three letters. Plus. Built into cargo since 1.62; remove is its opposite.",
          "세 글자. 더하기. cargo 1.62부터 내장; 반대는 remove.",
          "三個字母。加。cargo 1.62 開始內置；相反係 remove。"
        ),
        ok = L(
          "cargo add serde --features derive writes the line for you and picks the newest version.",
          "cargo add serde --features derive가 줄을 대신 써 주고 최신 버전을 고른다.",
          "cargo add serde --features derive 幫你寫好嗰行，仲揀最新版本。"
        ),
      },
      {
        topic = "BUILD",
        q = L(
          "Compile with optimisations for the live server. Which flag?",
          "실서버용으로 최적화해서 컴파일. 어떤 플래그?",
          "為正式 server 開優化去 compile。邊個 flag？"
        ),
        code = L(
          [[
$ cargo build --___
   Compiling delivery v0.1.0
    Finished [optimized] target(s) in 41.2s
]],
          [[
$ cargo build --___
   Compiling delivery v0.1.0
    Finished [optimized] target(s) in 41.2s
]],
          [[
$ cargo build --___
   Compiling delivery v0.1.0
    Finished [optimized] target(s) in 41.2s
]]
        ),
        accept = { "release", "--release" },
        answer = "release",
        hint = L(
          "Seven letters. The opposite of a debug build. The binary lands in target/ under that name.",
          "일곱 글자. 디버그 빌드의 반대. 바이너리가 target/ 아래 그 이름으로 들어간다.",
          "七個字母。debug build 嘅相反。binary 會落喺 target/ 下面同名嘅資料夾。"
        ),
        ok = L(
          "--release turns on opt-level 3 and drops debug checks. Plain cargo build is for development.",
          "--release는 opt-level 3을 켜고 디버그 검사를 뺀다. 그냥 cargo build는 개발용.",
          "--release 開 opt-level 3，去掉 debug 檢查。普通 cargo build 係開發用。"
        ),
      },
      {
        topic = "TEST",
        q = L(
          "Run every function marked with the #[...] attribute for checks. Which subcommand?",
          "검사용 #[...] 속성이 붙은 함수를 모두 실행. 어떤 서브커맨드?",
          "行勻所有標咗檢查用 #[...] attribute 嘅 function。邊個 subcommand？"
        ),
        code = L(
          [[
$ cargo ___
   Compiling delivery v0.1.0
running 2 checks
qty_parses ....... ok
eta_is_positive .. ok
result: ok. 2 passed; 0 failed
]],
          [[
$ cargo ___
   Compiling delivery v0.1.0
running 2 checks
qty_parses ....... ok
eta_is_positive .. ok
result: ok. 2 passed; 0 failed
]],
          [[
$ cargo ___
   Compiling delivery v0.1.0
running 2 checks
qty_parses ....... ok
eta_is_positive .. ok
result: ok. 2 passed; 0 failed
]]
        ),
        accept = { "test" },
        answer = "test",
        hint = L(
          "Four letters. The same word you put in the attribute over the function.",
          "네 글자. 함수 위 속성에 쓰는 바로 그 단어.",
          "四個字母。同你放喺 function 上面嗰個 attribute 一樣嘅字。"
        ),
        ok = L(
          "cargo test builds a test binary and runs #[test] fns in parallel. cargo test name filters.",
          "cargo test는 테스트 바이너리를 만들어 #[test] 함수를 병렬 실행. cargo test 이름 으로 걸러낸다.",
          "cargo test 起一個 test binary，平行行 #[test] fn。cargo test 名 可以篩選。"
        ),
      },
      {
        topic = "LINT",
        q = L(
          "Ask for warnings about non-idiomatic code. Which subcommand?",
          "관용적이지 않은 코드에 대한 경고를 받는다. 어떤 서브커맨드?",
          "叫佢對唔地道嘅 code 出警告。邊個 subcommand？"
        ),
        code = L(
          [[
$ cargo ___
warning: this `.into_iter()` call is equivalent to `.iter()`
  --> src/main.rs:12:24
   = help: consider using `.iter()`
]],
          [[
$ cargo ___
warning: this `.into_iter()` call is equivalent to `.iter()`
  --> src/main.rs:12:24
   = help: consider using `.iter()`
]],
          [[
$ cargo ___
warning: this `.into_iter()` call is equivalent to `.iter()`
  --> src/main.rs:12:24
   = help: consider using `.iter()`
]]
        ),
        accept = { "clippy" },
        answer = "clippy",
        hint = L(
          "Named after a paperclip assistant from old office software. Six letters, double p.",
          "옛 오피스 소프트웨어의 클립 도우미 이름을 땄다. 여섯 글자, p 두 개.",
          "跟舊 office 軟件嗰個萬字夾助手改名。六個字母，兩個 p。"
        ),
        ok = L(
          "cargo clippy is the linter; -- -D warnings makes CI fail on any lint. The crab approves.",
          "cargo clippy가 린터; -- -D warnings를 주면 CI가 린트 하나에도 실패한다. 게가 끄덕인다.",
          "cargo clippy 係 linter；加 -- -D warnings，CI 見到任何 lint 都會 fail。隻蟹點頭。"
        ),
      },
      {
        topic = "STYLE",
        q = L(
          "Reformat every file to the standard style before the commit. Which subcommand?",
          "커밋 전에 모든 파일을 표준 스타일로 다시 정렬. 어떤 서브커맨드?",
          "commit 之前將所有檔案排返標準格式。邊個 subcommand？"
        ),
        code = L(
          [[
$ cargo ___
$ git diff --stat
 src/main.rs | 14 ++++++-------
$ cargo ___ --check && echo "clean"
]],
          [[
$ cargo ___
$ git diff --stat
 src/main.rs | 14 ++++++-------
$ cargo ___ --check && echo "clean"
]],
          [[
$ cargo ___
$ git diff --stat
 src/main.rs | 14 ++++++-------
$ cargo ___ --check && echo "clean"
]]
        ),
        accept = { "fmt" },
        answer = "fmt",
        hint = L(
          "Three letters, same as the module behind println!. Runs rustfmt.",
          "세 글자, println! 뒤의 모듈과 같다. rustfmt를 실행한다.",
          "三個字母，同 println! 背後嗰個 module 一樣。佢會行 rustfmt。"
        ),
        ok = L(
          "cargo fmt rewrites in place; --check only reports. Build green, lint clean. Ticket six closed.",
          "cargo fmt는 제자리에서 고치고 --check는 보고만 한다. 빌드 초록, 린트 깨끗. 여섯 번째 티켓 닫힘.",
          "cargo fmt 直接改檔；--check 只係報告。build 綠色，lint 乾淨。第六張 ticket 閂咗。"
        ),
      },
    },
  },

  {
    id = "rs_modern",
    station = "MODERN",
    name = L("The Express set", "익스프레스 세트", "Express 套餐"),
    title = L("Modern Rust idioms", "모던 러스트 관용구", "現代 Rust 慣用寫法"),
    lesson = L(
      "let else, matches!, impl Trait, ..=, ? on Option, is_some_and: less nesting, same safety.",
      "let else, matches!, impl Trait, ..=, Option의 ?, is_some_and: 중첩은 줄고 안전은 그대로.",
      "let else、matches!、impl Trait、..=、Option 上面用 ?、is_some_and：少啲嵌套，一樣安全。"
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
        x = 540,
        facing = -1,
        line = L(
          "Last ticket. Code review. Every match with one arm and an early return gets a modern spelling.",
          "마지막 티켓. 코드 리뷰. 팔 하나에 얼리 리턴인 match는 전부 모던 문법으로.",
          "最後一張 ticket。code review。凡係一隻 arm 加 early return 嘅 match，全部改成現代寫法。"
        ),
      },
      {
        kind = "clerk",
        x = 700,
        facing = -1,
        line = L(
          "Owner says: ship before 18:00 and the dinner set is on the house.",
          "사장님 말: 18:00 전에 배포하면 저녁 세트는 공짜.",
          "老闆話：六點前上線，晚餐套餐請你食。"
        ),
      },
    },
    viz = "rust",
    chips = {
      { "let Some(x) = o else {", "cyan" },
      { "matches!(v, Some(_))", "gold" },
      { "-> impl Iterator", "pink" },
      { "opt.is_some_and(..)", "green" },
    },
    note = "let else  if let  matches!  impl Trait  ..=  ?",
    story = L(
      "17:55. Lucky Mac Express, the set counter. The backend compiles, but Mei's review has six "
        .. "comments: this is 2015 Rust. Alex rewrites each one the modern way. Then it ships. SHIPPED.",
      "17:55. 익스프레스 세트 카운터. 백엔드는 컴파일되지만 메이의 리뷰에 코멘트 여섯 개: "
        .. "이건 2015년 러스트야. 알렉스가 하나씩 모던하게 고친다. 그리고 배포. SHIPPED.",
      "五點五十五。Express 套餐櫃位。backend compile 到，但阿美嘅 review 有六個 comment："
        .. "呢啲係 2015 年嘅 Rust。阿力逐個改做現代寫法。然後上線。SHIPPED。"
    ),
    stages = {
      {
        topic = "LET ELSE",
        q = L(
          "Unpack the Some or leave the function, no match block. Which keyword completes it?",
          "Some을 풀거나 함수를 떠난다, match 블록 없이. 완성하는 키워드는?",
          "解開 Some，唔得就離開 function，唔用 match block。邊個 keyword 補完佢？"
        ),
        code = L(
          [[
fn assign(order: &Order) {
    // Rust 1.65: a refutable pattern with a fallback block
    let Some(rider) = pick_rider(order) ___ { return };
    println!("{rider} takes order {}", order.id);
}
]],
          [[
fn assign(order: &Order) {
    // 러스트 1.65: 패턴 실패 시 대비 블록
    let Some(rider) = pick_rider(order) ___ { return };
    println!("{rider} takes order {}", order.id);
}
]],
          [[
fn assign(order: &Order) {
    // Rust 1.65：唔中就行後備 block
    let Some(rider) = pick_rider(order) ___ { return };
    println!("{rider} takes order {}", order.id);
}
]]
        ),
        accept = { "else" },
        answer = "else",
        hint = L(
          "Four letters. The word that follows if. The block must diverge: return, break, panic.",
          "네 글자. if 다음에 오는 단어. 블록은 반드시 벗어나야 한다: return, break, panic.",
          "四個字母。跟喺 if 後面嗰個字。個 block 一定要走人：return、break、panic。"
        ),
        ok = L(
          "let Some(x) = opt else { return }; binds x for the rest of the function. No nesting.",
          "let Some(x) = opt else { return }; 는 함수 나머지에서 x를 묶는다. 중첩 없음.",
          "let Some(x) = opt else { return }; 之後成個 function 都用得 x。零嵌套。"
        ),
      },
      {
        topic = "MATCHES",
        q = L(
          "You only need a bool: is the order in one of two states? Which macro?",
          "bool만 필요하다: 주문이 두 상태 중 하나인가? 어떤 매크로?",
          "你只需要一個 bool：張單係唔係兩個狀態之一？邊個 macro？"
        ),
        code = L(
          [[
enum State { Queued, Cooking, Riding, Done }
// a pattern test that returns true or false
let busy = ___!(state, State::Cooking | State::Riding);
if busy { println!("not yet"); }
]],
          [[
enum State { Queued, Cooking, Riding, Done }
// true 또는 false를 돌려주는 패턴 검사
let busy = ___!(state, State::Cooking | State::Riding);
if busy { println!("not yet"); }
]],
          [[
enum State { Queued, Cooking, Riding, Done }
// 一個回傳 true 或 false 嘅 pattern 測試
let busy = ___!(state, State::Cooking | State::Riding);
if busy { println!("not yet"); }
]]
        ),
        accept = { "matches", "matches!" },
        answer = "matches",
        hint = L(
          "Seven letters. Does the value ... this pattern? Same verb, plural form.",
          "일곱 글자. 값이 이 패턴에 ...하는가? 같은 동사의 3인칭 형태.",
          "七個字母。個值有冇 ... 呢個 pattern？同一個動詞，第三身形式。"
        ),
        ok = L(
          "matches!(v, Pat) expands to match v { Pat => true, _ => false }. Guards allowed: Some(n) if n > 3.",
          "matches!(v, Pat)은 match v { Pat => true, _ => false }로 펼쳐진다. 가드도 가능: Some(n) if n > 3.",
          "matches!(v, Pat) 展開成 match v { Pat => true, _ => false }。可以加 guard：Some(n) if n > 3。"
        ),
      },
      {
        topic = "IMPL",
        q = L(
          "Return an iterator without naming its long type. Which keyword in the return position?",
          "긴 타입 이름 없이 이터레이터를 반환. 반환 자리의 어떤 키워드?",
          "唔寫出佢個長長嘅 type 就回傳 iterator。回傳位置用邊個 keyword？"
        ),
        code = L(
          [[
// the caller only learns: it is some Iterator of &str
fn free_riders() -> ___ Iterator<Item = &'static str> {
    ["Wing", "Fai"].into_iter().filter(|r| *r != "Fai")
}
]],
          [[
// 호출자가 아는 건: &str의 어떤 Iterator
fn free_riders() -> ___ Iterator<Item = &'static str> {
    ["Wing", "Fai"].into_iter().filter(|r| *r != "Fai")
}
]],
          [[
// call 嘅人只知道：係某種 &str 嘅 Iterator
fn free_riders() -> ___ Iterator<Item = &'static str> {
    ["Wing", "Fai"].into_iter().filter(|r| *r != "Fai")
}
]]
        ),
        accept = { "impl" },
        answer = "impl",
        hint = L(
          "Four letters. The same keyword that opens a block of methods, used as a type.",
          "네 글자. 메서드 블록을 여는 그 키워드를 타입 자리에 쓴다.",
          "四個字母。開 method block 嗰個 keyword，攞嚟做 type 用。"
        ),
        ok = L(
          "impl Trait in return position: static dispatch, no Box, closures stay unnamed.",
          "반환 위치의 impl Trait: 정적 디스패치, Box 없음, 클로저는 이름 없이 그대로.",
          "回傳位置嘅 impl Trait：static dispatch，唔使 Box，closure 唔使有名。"
        ),
      },
      {
        topic = "RANGE",
        q = L(
          "Floors 1 to 5, and 5 must be included. Which range operator?",
          "1층부터 5층까지, 5층 포함. 어떤 범위 연산자?",
          "一樓到五樓，五樓要包埋。邊個 range 運算子？"
        ),
        code = L(
          [[
// the mall has five floors of pickup lockers
for floor in 1___5 {
    println!("checking locker on floor {floor}");
}
// prints 1, 2, 3, 4, 5
]],
          [[
// 쇼핑몰에 픽업 락커가 5층까지 있다
for floor in 1___5 {
    println!("checking locker on floor {floor}");
}
// 1, 2, 3, 4, 5 를 출력
]],
          [[
// 商場有五層取餐櫃
for floor in 1___5 {
    println!("checking locker on floor {floor}");
}
// 印 1、2、3、4、5
]]
        ),
        accept = { "..=" },
        answer = "..=",
        hint = L(
          "Two dots and one more character that says the end counts too.",
          "점 둘, 그리고 끝도 포함한다는 뜻의 문자 하나 더.",
          "兩粒點，再加一個表示連尾都計埋嘅符號。"
        ),
        ok = L(
          '1..=5 is RangeInclusive; 1..5 stops at 4. Also in patterns: 1..=5 => "low".',
          '1..=5는 RangeInclusive; 1..5는 4에서 멈춘다. 패턴에도 쓴다: 1..=5 => "low".',
          '1..=5 係 RangeInclusive；1..5 去到 4 就停。pattern 都用得：1..=5 => "low"。'
        ),
      },
      {
        topic = "OPTION",
        q = L(
          "first() gives an Option. Return None early if the order is empty. Which operator?",
          "first()는 Option을 준다. 주문이 비었으면 일찍 None을 반환. 어떤 연산자?",
          "first() 出 Option。張單係空就早啲回傳 None。邊個運算子？"
        ),
        code = L(
          [[
fn first_dish(order: &Order) -> Option<&str> {
    // works on Option too, not only on Result
    let dish = order.items.first()___;
    Some(dish.as_str())
}
]],
          [[
fn first_dish(order: &Order) -> Option<&str> {
    // Result만이 아니라 Option에도 쓸 수 있다
    let dish = order.items.first()___;
    Some(dish.as_str())
}
]],
          [[
fn first_dish(order: &Order) -> Option<&str> {
    // 唔只 Result，Option 都用得
    let dish = order.items.first()___;
    Some(dish.as_str())
}
]]
        ),
        accept = { "?" },
        answer = "?",
        hint = L(
          "One character. The same one that returns Err early in a Result function.",
          "한 글자. Result 함수에서 Err를 일찍 반환하는 바로 그것.",
          "一個符號。喺 Result function 裏面早啲回傳 Err 嘅同一個。"
        ),
        ok = L(
          "? on Option returns None when it sees None. The function type must be Option as well.",
          "Option에 ?를 쓰면 None을 보고 None을 반환. 함수 타입도 Option이어야 한다.",
          "Option 上面用 ?，見到 None 就回傳 None。個 function type 都要係 Option。"
        ),
      },
      {
        topic = "PREDICATE",
        q = L(
          "Is the ETA Some and under 10 minutes, in one call, no unwrap? Which Option method?",
          "ETA가 Some이고 10분 미만인가, 호출 하나로, unwrap 없이? Option의 어떤 메서드?",
          "ETA 係 Some 而且少過十分鐘，一個 call，唔用 unwrap？Option 邊個 method？"
        ),
        code = L(
          [[
let eta: Option<u32> = fetch_eta_cached(order.id);
// Rust 1.70: None -> false, Some(e) -> the closure result
let fast = eta.___(|e| e < 10);
if fast { println!("promise the customer 10 minutes"); }
]],
          [[
let eta: Option<u32> = fetch_eta_cached(order.id);
// 1.70: None -> false, Some(e) -> 클로저 결과
let fast = eta.___(|e| e < 10);
if fast { println!("promise the customer 10 minutes"); }
]],
          [[
let eta: Option<u32> = fetch_eta_cached(order.id);
// Rust 1.70：None -> false，Some(e) -> closure 嘅結果
let fast = eta.___(|e| e < 10);
if fast { println!("promise the customer 10 minutes"); }
]]
        ),
        accept = { "is_some_and", "issomeand" },
        answer = "is_some_and",
        hint = L(
          "Starts like is_some(), then one more word joining a condition. Three words, two underscores.",
          "is_some()처럼 시작하고 조건을 잇는 단어 하나 더. 세 단어, 밑줄 둘.",
          "開頭同 is_some() 一樣，再加一個連接條件嘅字。三個字，兩條底線。"
        ),
        ok = L(
          "is_some_and(|e| e < 10) beats map(..).unwrap_or(false). Review clean at 17:59. SHIPPED.",
          "is_some_and(|e| e < 10)가 map(..).unwrap_or(false)보다 낫다. 17:59 리뷰 통과. SHIPPED.",
          "is_some_and(|e| e < 10) 好過 map(..).unwrap_or(false)。五點五十九 review 過關。SHIPPED。"
        ),
      },
    },
  },
}

return maps
