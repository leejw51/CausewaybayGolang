-- Quest Q8 MODULES: 15:30, after the callback. The delivery app has grown
-- past one main.go, and the Times Square shop wants to import Alex's menu
-- code straight from GitHub. Module paths, one directory per package,
-- go get and go.sum, internal/ and cmd/, replace and go.work, semver tags
-- and the /v2 suffix, the proxy and private repos. Prize: the v1.0.0 tag.
-- Same shape as src/data.lua: the blank ___ is NOT written in the code.

local function L(en, ko, yue)
  return { en = en, ko = ko, yue = yue }
end

local maps = {
  {
    id = "gomod",
    station = "MODULE",
    name = L("One go.mod at the root", "루트의 go.mod 하나", "根目錄嗰個 go.mod"),
    title = L(
      "The module path is the import path",
      "모듈 경로가 곧 import 경로",
      "module path 就係 import path"
    ),
    lesson = L(
      "A module is a tree of packages with one go.mod at its root. go mod init names it, and that name is the prefix of every import path inside it, so name it after the repo: github.com/you/project. The go directive is the minimum toolchain. Modules have been the only mode since Go 1.16; GOPATH is history.",
      "모듈은 루트에 go.mod 하나를 둔 패키지 트리다. go mod init이 이름을 정하고, 그 이름이 안의 모든 import 경로의 접두사가 되므로 저장소 이름을 따라 짓는다: github.com/you/project. go 지시어는 최소 툴체인. Go 1.16부터 모듈이 유일한 모드이고 GOPATH는 과거다.",
      "module 係一棵 package 樹，根目錄得一個 go.mod。go mod init 幫佢改名，嗰個名就係入面所有 import path 嘅前綴，所以跟 repo 嚟改：github.com/you/project。go 指令係最低工具鏈版本。Go 1.16 開始 module 係唯一模式，GOPATH 已經係歷史。"
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
        x = 540,
        facing = 1,
        line = L(
          "One main.go with nine hundred lines. Time to split it into packages, and the first question is what to call the module.",
          "900줄짜리 main.go 하나. 패키지로 나눌 때가 됐고, 첫 질문은 모듈 이름을 뭘로 하느냐야.",
          "一個九百行嘅 main.go。係時候拆做 package，第一條問題係個 module 叫咩名。"
        ),
      },
      {
        kind = "mei",
        x = 900,
        facing = -1,
        line = L(
          "Call it what its GitHub URL will be. Every import inside starts with that string.",
          "GitHub URL이 될 이름으로 지어. 안의 모든 import가 그 문자열로 시작해.",
          "叫佢將來 GitHub 嗰個 URL。入面每個 import 都用嗰串字開頭。"
        ),
      },
    },
    viz = "chips",
    chips = {
      { "go mod init", "cyan" },
      { "module github.com/...", "gold" },
      { "go 1.23", "pink" },
      { "go env GOMOD", "green" },
    },
    note = "init  module path  go directive  GOMOD  on",
    story = L(
      "15:30. The delivery app is one file and the Times Square shop wants to import the menu code "
        .. "from GitHub. Before there is a package to import there has to be a module to hold it, "
        .. "and the module's name is not a label: it is the first half of every import path.",
      "15:30. 배달 앱은 파일 하나이고 타임스퀘어 매장은 GitHub에서 메뉴 코드를 import하고 싶어 한다. "
        .. "import할 패키지가 있기 전에 그것을 담을 모듈이 있어야 하고, 모듈 이름은 라벨이 아니다. "
        .. "모든 import 경로의 앞부분이다.",
      "15:30. 外賣 App 得一個檔案，而時代廣場嗰間舖想由 GitHub import 個餐牌 code。"
        .. "有 package 可以 import 之前，要先有個 module 裝住佢，而 module 個名唔係標籤："
        .. "佢係每個 import path 嘅前半截。"
    ),
    stages = {
      {
        topic = "PATH",
        q = L(
          "Name the module after the repo it will live in. Fill the path.",
          "모듈 이름을 앞으로 살게 될 저장소 이름으로. 경로를 채우기.",
          "用將來擺喺邊個 repo 嚟改 module 個名。填個 path。"
        ),
        code = L(
          [[
$ git remote -v
origin  git@github.com:alex/luckymac.git (push)
$ go mod init ___
go: creating new go.mod
]],
          [[
$ git remote -v
origin  git@github.com:alex/luckymac.git (push)
$ go mod init ___
go: creating new go.mod
]],
          [[
$ git remote -v
origin  git@github.com:alex/luckymac.git (push)
$ go mod init ___
go: creating new go.mod
]]
        ),
        accept = { "github.com/alex/luckymac" },
        answer = "github.com/alex/luckymac",
        hint = L(
          "The host, the user, the repo, joined with slashes, no https://. The tool echoes it back on the next line.",
          "호스트, 사용자, 저장소를 슬래시로 이어서, https:// 없이. 다음 줄에 도구가 그대로 되돌려 준다.",
          "host、user、repo，用斜線駁埋，冇 https://。工具喺下一行照樣印返出嚟。"
        ),
        ok = L(
          "The module path is a name, not a URL: nothing is fetched when you init. It only has to match the repo later, when somebody else runs go get on it.",
          "모듈 경로는 URL이 아니라 이름이다. init할 때 아무것도 받아오지 않는다. 나중에 남이 go get할 때 저장소와 일치하기만 하면 된다.",
          "module path 係個名，唔係 URL：init 嗰陣咩都唔會下載。淨係之後有人 go get 嘅時候要對得上個 repo。"
        ),
      },
      {
        topic = "DIRS",
        q = L(
          "Module path plus directory is the import path. Fill the path of the menu package.",
          "모듈 경로 더하기 디렉터리가 import 경로. menu 패키지의 경로를 채우기.",
          "module path 加資料夾就係 import path。填 menu package 個 path。"
        ),
        code = L(
          [[
luckymac/           module github.com/alex/luckymac
  menu/price.go     import "github.com/alex/luckymac/___"
  rider/eta.go      import "github.com/alex/luckymac/rider"
]],
          [[
luckymac/           module github.com/alex/luckymac
  menu/price.go     import "github.com/alex/luckymac/___"
  rider/eta.go      import "github.com/alex/luckymac/rider"
]],
          [[
luckymac/           module github.com/alex/luckymac
  menu/price.go     import "github.com/alex/luckymac/___"
  rider/eta.go      import "github.com/alex/luckymac/rider"
]]
        ),
        accept = { "menu" },
        answer = "menu",
        hint = L(
          "The directory the file sits in, nothing more. Look at how rider is done on the next line.",
          "파일이 들어 있는 디렉터리, 그뿐. 다음 줄의 rider가 어떻게 됐는지 보라.",
          "個檔案所在嘅資料夾，冇其他。睇下下一行 rider 係點做。"
        ),
        ok = L(
          "Module path plus directory equals import path. That is the whole rule, and it is why a module named after its repo just works from anywhere.",
          "모듈 경로 더하기 디렉터리가 import 경로. 규칙은 그게 전부이고, 저장소 이름을 딴 모듈이 어디서든 그냥 동작하는 이유다.",
          "module path 加資料夾就係 import path。規矩就係咁，亦係點解跟 repo 改名嘅 module 喺邊度都用得。"
        ),
      },
      {
        topic = "GOVERS",
        q = L(
          "go.mod's second line pins the minimum Go. Fill the directive's value.",
          "go.mod 둘째 줄은 최소 Go 버전을 고정한다. 지시어의 값을 채우기.",
          "go.mod 第二行釘住最低 Go 版本。填個指令嘅值。"
        ),
        code = L(
          [[
module github.com/alex/luckymac

go ___
]],
          [[
module github.com/alex/luckymac

go ___
]],
          [[
module github.com/alex/luckymac

go ___
]]
        ),
        accept = { "1.23", "1.22", "1.24", "1.25" },
        answer = "1.23",
        hint = L(
          "A major.minor like 1.23. Since Go 1.21 it is a real floor: an older toolchain will fetch a newer one.",
          "1.23 같은 major.minor. Go 1.21부터는 진짜 하한선이라 오래된 툴체인이면 새것을 받아온다.",
          "好似 1.23 噉嘅 major.minor。Go 1.21 開始係真嘅下限：舊工具鏈會自己去攞新嘅。"
        ),
        ok = L(
          "The go directive also picks language semantics: for-loop variables became per-iteration only for modules that say go 1.22 or later.",
          "go 지시어는 언어 의미도 고른다. for 루프 변수가 반복마다 새로 만들어지는 것은 go 1.22 이상을 선언한 모듈에서만이다.",
          "go 指令仲會揀語言語義：for loop 變數變成每一轉獨立，淨係對寫住 go 1.22 或以上嘅 module 先生效。"
        ),
      },
      {
        topic = "WHERE",
        q = L(
          "Which go.mod is in charge here? Ask the tool for the file it found.",
          "여기서 어느 go.mod가 적용되나? 도구에 찾은 파일을 물어보기.",
          "而家邊個 go.mod 話事？問工具佢搵到邊個檔案。"
        ),
        code = L(
          [[
$ cd luckymac/menu
$ go env ___
/Users/alex/luckymac/go.mod
]],
          [[
$ cd luckymac/menu
$ go env ___
/Users/alex/luckymac/go.mod
]],
          [[
$ cd luckymac/menu
$ go env ___
/Users/alex/luckymac/go.mod
]]
        ),
        accept = { "GOMOD" },
        answer = "GOMOD",
        hint = L(
          "GO, then the three letters of the file, all capitals. It walks up from the current directory.",
          "GO 다음에 파일 이름 세 글자, 전부 대문자. 현재 디렉터리에서 위로 올라가며 찾는다.",
          "GO 再加個檔案嗰三個字母，全大楷。佢會由而家嘅資料夾一路向上搵。"
        ),
        ok = L(
          "Go finds the nearest go.mod above you. A second go.mod in a subdirectory starts a different module, which is almost never what you meant.",
          "Go는 위쪽에서 가장 가까운 go.mod를 찾는다. 하위 디렉터리에 go.mod가 또 있으면 다른 모듈이 시작되는데, 거의 언제나 의도한 바가 아니다.",
          "Go 會搵你上面最近嗰個 go.mod。子資料夾入面再有一個 go.mod 就等於開多個 module，通常都唔係你想要嘅。"
        ),
      },
      {
        topic = "MODE",
        q = L(
          "Old tutorials talk about GOPATH. What is GO111MODULE since Go 1.16?",
          "옛 튜토리얼은 GOPATH를 말한다. Go 1.16부터 GO111MODULE의 값은?",
          "舊教學成日講 GOPATH。Go 1.16 開始 GO111MODULE 係咩？"
        ),
        code = L(
          [[
$ go env GO111MODULE
___
# modules everywhere, go.mod or not
]],
          [[
$ go env GO111MODULE
___
# 어디서나 모듈 모드, go.mod가 있든 없든
]],
          [[
$ go env GO111MODULE
___
# 周圍都係 module 模式，有冇 go.mod 都係
]]
        ),
        accept = { "on", "" },
        answer = "on",
        hint = L(
          "Two letters, the opposite of off. The empty default means the same thing now.",
          "두 글자, off의 반대. 이제는 비어 있는 기본값도 같은 뜻.",
          "兩個字母，off 嘅相反。而家空嘅預設值都係同一個意思。"
        ),
        ok = L(
          "GOPATH still exists as the download cache ($GOPATH/pkg/mod) and the go install bin dir, but your code lives wherever you like.",
          "GOPATH는 다운로드 캐시($GOPATH/pkg/mod)와 go install의 bin 디렉터리로만 남아 있고, 코드는 어디에 두어도 된다.",
          "GOPATH 仲喺度，但淨係做下載 cache（$GOPATH/pkg/mod）同 go install 嘅 bin 資料夾，你嘅 code 想擺邊都得。"
        ),
      },
    },
  },
  {
    id = "pkgdir",
    station = "PACKAGE",
    name = L("A folder is a package", "폴더가 곧 패키지", "一個資料夾就係一個 package"),
    title = L(
      "Directory, package name, exported names",
      "디렉터리, 패키지 이름, 내보낸 이름",
      "資料夾、package 名、export 出去嘅名"
    ),
    lesson = L(
      "One directory is one package: every .go file in it says the same package name, normally the directory's. Only identifiers that start with a capital letter are visible from outside. You import a package by its full path, module path plus directory, never by a relative path, and an import you do not use is a compile error.",
      "디렉터리 하나가 패키지 하나. 안의 모든 .go 파일은 같은 패키지 이름을 쓰며, 보통 디렉터리 이름이다. 대문자로 시작하는 식별자만 밖에서 보인다. 패키지는 모듈 경로 더하기 디렉터리인 전체 경로로 import하며 상대 경로는 절대 안 되고, 쓰지 않는 import는 컴파일 에러다.",
      "一個資料夾就係一個 package：入面每個 .go 檔都寫同一個 package 名，通常同資料夾一樣。淨係大楷開頭嘅識別字先可以俾外面見到。import 一個 package 要用全 path，即 module path 加資料夾，永遠唔可以用相對路徑，而 import 咗唔用就係 compile error。"
    ),
    bg = "bg_flat",
    portrait = "portrait_friends",
    speaker = L("Mei", "메이", "阿美"),
    ground = 348,
    spawn = 150,
    width = 1600,
    npcs = {
      {
        kind = "mei",
        x = 560,
        facing = 1,
        line = L(
          "You made a menu folder and wrote package pricing inside it. Go accepts it. Every reader will hate it.",
          "menu 폴더를 만들고 안에 package pricing이라고 썼네. Go는 받아 주지만 읽는 사람은 다 싫어할 거야.",
          "你開咗個 menu 資料夾，入面寫 package pricing。Go 收貨，但每個睇嘅人都會憎你。"
        ),
      },
      {
        kind = "hero",
        x = 940,
        facing = -1,
        line = L(
          "And the compiler says my price function does not exist, even though it is right there.",
          "그리고 컴파일러는 내 price 함수가 없다고 해. 바로 저기 있는데.",
          "而且 compiler 話我個 price function 唔存在，明明就喺度。"
        ),
      },
    },
    viz = "chips",
    chips = {
      { "menu/price.go", "cyan" },
      { "package menu", "gold" },
      { "func Price(...)", "pink" },
      { "imported and not used", "green" },
    },
    note = "dir = package  Capital  full path  used",
    story = L(
      "15:45. The menu code moves into its own folder and immediately breaks in three ways: the "
        .. "package is named after nothing, main cannot see the price function, and the import "
        .. "written as ./menu will not build. All three are the same lesson about what a path means.",
      "15:45. 메뉴 코드를 자기 폴더로 옮기자마자 세 가지가 망가진다. 패키지 이름이 아무것도 따르지 않았고, "
        .. "main은 price 함수를 볼 수 없고, ./menu라고 쓴 import는 빌드되지 않는다. "
        .. "셋 다 경로가 뜻하는 바에 관한 같은 교훈이다.",
      "15:45. 餐牌 code 搬入自己嘅資料夾，即刻壞咗三樣嘢：package 個名冇跟任何嘢、"
        .. "main 見唔到個 price function、寫成 ./menu 嘅 import build 唔到。"
        .. "三樣都係同一課：一個 path 代表咩。"
    ),
    stages = {
      {
        topic = "DIR",
        q = L(
          "The file is menu/price.go. What does its first line say?",
          "파일은 menu/price.go. 첫 줄은?",
          "個檔案係 menu/price.go。第一行寫咩？"
        ),
        code = L(
          [[
// menu/price.go
package ___

func price(item string) int { return 42 }
]],
          [[
// menu/price.go
package ___

func price(item string) int { return 42 }
]],
          [[
// menu/price.go
package ___

func price(item string) int { return 42 }
]]
        ),
        accept = { "menu" },
        answer = "menu",
        hint = L(
          "The directory's name. It could legally be anything, and it should be this.",
          "디렉터리 이름. 법적으로는 아무거나 가능하지만 이것이어야 한다.",
          "個資料夾嘅名。法律上寫咩都得，但應該寫呢個。"
        ),
        ok = L(
          "Package name and directory name are separate things that everyone keeps identical. Short, lowercase, no underscores: menu, not menuUtils.",
          "패키지 이름과 디렉터리 이름은 별개지만 모두가 같게 둔다. 짧고 소문자, 밑줄 없이: menuUtils가 아니라 menu.",
          "package 名同資料夾名係兩樣嘢，但人人都keep佢哋一樣。短、細楷、冇底線：係 menu，唔係 menuUtils。"
        ),
      },
      {
        topic = "EXPORT",
        q = L(
          "main calls menu.Price and the compiler says undefined. Fix the name.",
          "main이 menu.Price를 부르는데 컴파일러는 undefined라 한다. 이름을 고치기.",
          "main call menu.Price，compiler 話 undefined。改個名。"
        ),
        code = L(
          [[
// menu/price.go
package menu

func ___(item string) int { return 42 }
]],
          [[
// menu/price.go
package menu

func ___(item string) int { return 42 }
]],
          [[
// menu/price.go
package menu

func ___(item string) int { return 42 }
]]
        ),
        accept = { "Price" },
        answer = "Price",
        hint = L(
          "Same word, one letter changed. Go has no public keyword; the first letter is the keyword.",
          "같은 단어, 글자 하나만 바꾼다. Go엔 public 키워드가 없고 첫 글자가 곧 키워드다.",
          "同一個字，改一個字母。Go 冇 public keyword，第一個字母就係 keyword。"
        ),
        ok = L(
          "Capital means exported, and that goes for types, fields, methods and constants too. A struct with lowercase fields cannot even be filled in from another package.",
          "대문자면 내보낸 것. 타입, 필드, 메서드, 상수 모두 마찬가지다. 소문자 필드를 가진 구조체는 다른 패키지에서 채울 수조차 없다.",
          "大楷就係 export，type、field、method、constant 都係咁。細楷 field 嘅 struct，喺另一個 package 連填都填唔到。"
        ),
      },
      {
        topic = "FULL",
        q = L(
          "Import the package from main.go. Write the whole path.",
          "main.go에서 패키지를 import한다. 전체 경로를 쓰기.",
          "喺 main.go import 個 package。寫成個 path。"
        ),
        code = L(
          [[
// main.go, module github.com/alex/luckymac
import "___"

fmt.Println(menu.Price("set"))
]],
          [[
// main.go, 모듈 github.com/alex/luckymac
import "___"

fmt.Println(menu.Price("set"))
]],
          [[
// main.go，module github.com/alex/luckymac
import "___"

fmt.Println(menu.Price("set"))
]]
        ),
        accept = { "github.com/alex/luckymac/menu" },
        answer = "github.com/alex/luckymac/menu",
        hint = L(
          "The module path from the comment, a slash, the directory. Not menu on its own, not ./menu.",
          "주석의 모듈 경로, 슬래시, 디렉터리. menu만도 아니고 ./menu도 아니다.",
          "註解嗰個 module path、一條斜線、個資料夾。唔係淨係 menu，亦唔係 ./menu。"
        ),
        ok = L(
          "The path is long but unambiguous: two modules can both have a menu directory and never collide. The name you use in code is the package's own name, menu.",
          "경로는 길지만 모호하지 않다. 두 모듈이 모두 menu 디렉터리를 가져도 충돌하지 않는다. 코드에서 쓰는 이름은 패키지 자신의 이름 menu다.",
          "個 path 長，但唔會歧義：兩個 module 都可以有 menu 資料夾，永遠唔會撞。code 入面用嘅名係 package 自己個名 menu。"
        ),
      },
      {
        topic = "RELATIVE",
        q = L(
          'import "./menu" fails. Which word does the error use for that kind of path?',
          'import "./menu"가 실패한다. 에러가 그런 경로를 부르는 단어는?',
          'import "./menu" 失敗。個 error 叫呢種 path 做咩？'
        ),
        code = L(
          [[
import "./menu"
// main.go:4:8: "./menu" is ___, but
// ___ import paths are not supported in module mode
]],
          [[
import "./menu"
// main.go:4:8: "./menu" is ___, but
// ___ import paths are not supported in module mode
]],
          [[
import "./menu"
// main.go:4:8: "./menu" is ___, but
// ___ import paths are not supported in module mode
]]
        ),
        accept = { "relative" },
        answer = "relative",
        hint = L(
          "The opposite of absolute. Paths that start with ./ or ../ are it.",
          "절대의 반대. ./나 ../로 시작하는 경로가 그것.",
          "absolute 嘅相反。用 ./ 或者 ../ 開頭嘅 path 就係。"
        ),
        ok = L(
          "There are no relative imports in Go, ever. An import path is always the full name of a package, so it means the same thing from every file in the world.",
          "Go에는 상대 import가 절대 없다. import 경로는 언제나 패키지의 전체 이름이라 세상 어느 파일에서든 같은 뜻이다.",
          "Go 從來冇相對 import。import path 永遠係 package 嘅全名，所以喺世界任何一個檔案入面意思都一樣。"
        ),
      },
      {
        topic = "UNUSED",
        q = L(
          "You imported rider and then deleted the call. Finish the error.",
          "rider를 import했다가 호출을 지웠다. 에러를 완성하기.",
          "你 import 咗 rider 然後刪咗個 call。填完個 error。"
        ),
        code = L(
          [[
import "github.com/alex/luckymac/rider"
// main.go:5:2: "github.com/alex/luckymac/rider"
//     imported and not ___
]],
          [[
import "github.com/alex/luckymac/rider"
// main.go:5:2: "github.com/alex/luckymac/rider"
//     imported and not ___
]],
          [[
import "github.com/alex/luckymac/rider"
// main.go:5:2: "github.com/alex/luckymac/rider"
//     imported and not ___
]]
        ),
        accept = { "used" },
        answer = "used",
        hint = L(
          "Four letters. The same rule Go applies to a local variable you never read.",
          "네 글자. 한 번도 읽지 않는 지역 변수에 Go가 적용하는 규칙과 같다.",
          "四個字母。同 Go 對冇讀過嘅 local 變數用嘅規矩一樣。"
        ),
        ok = L(
          'It is an error, not a warning, so dead imports never pile up. goimports adds and removes them for you; _ "pkg" keeps one only for its init side effect.',
          '경고가 아니라 에러라 죽은 import가 쌓이지 않는다. goimports가 대신 넣고 빼 주고, _ "pkg"는 init 부작용만을 위해 남긴다.',
          '係 error 唔係 warning，所以死咗嘅 import 永遠唔會堆積。goimports 幫你加同刪；_ "pkg" 就係淨係為咗 init 副作用而留低。'
        ),
      },
    },
  },
  {
    id = "getpkg",
    station = "GO GET",
    name = L("Import from GitHub", "GitHub에서 import", "由 GitHub import"),
    title = L("go get, require, go.sum", "go get과 require, go.sum", "go get、require、go.sum"),
    lesson = L(
      "An import path that starts with a host is fetched from that host: go get github.com/x/y@v1.2.3 downloads the tagged commit into the module cache, adds a require line to go.mod and a hash to go.sum. // indirect marks a dependency of a dependency. Nothing is copied into your repo; everything is reproducible from the two files.",
      "호스트로 시작하는 import 경로는 그 호스트에서 받아온다. go get github.com/x/y@v1.2.3은 태그된 커밋을 모듈 캐시에 내려받고, go.mod에 require 줄을, go.sum에 해시를 추가한다. // indirect는 의존성의 의존성 표시. 저장소에 복사되는 것은 없고, 두 파일만으로 모두 재현된다.",
      "以 host 開頭嘅 import path 就由嗰個 host 下載：go get github.com/x/y@v1.2.3 將打咗 tag 嘅 commit 落到 module cache，喺 go.mod 加一行 require，喺 go.sum 加一個 hash。// indirect 標記依賴嘅依賴。冇嘢會複製入你個 repo；兩個檔案就可以完整重現。"
    ),
    bg = "bg_times",
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
          "My cousin's shop wants your menu package. He typed the GitHub path into an import and it just downloaded.",
          "사촌 가게에서 네 menu 패키지를 원해. import에 GitHub 경로를 쳤더니 그냥 받아지더래.",
          "我表哥間舖想要你個 menu package。佢喺 import 打咗個 GitHub path，就咁下載咗。"
        ),
      },
      {
        kind = "hero",
        x = 900,
        facing = -1,
        line = L(
          "That is the module path doing its job. Now he needs it pinned, or tomorrow's build is a different program.",
          "모듈 경로가 제 몫을 한 거야. 이제 고정해야지, 아니면 내일 빌드는 다른 프로그램이 돼.",
          "即係 module path 做緊佢嘅嘢。而家佢要釘住個版本，唔係聽日 build 出嚟就係另一個程式。"
        ),
      },
    },
    viz = "chips",
    chips = {
      { "go get pkg@v1.2.3", "cyan" },
      { "require ... v1.2.3", "gold" },
      { "go.sum", "pink" },
      { "// indirect", "green" },
    },
    note = "get  require  sum  indirect  pkg/mod",
    story = L(
      "16:00. The cousin's shop imports github.com/alex/luckymac/menu and the go tool fetches it "
        .. "from GitHub without being told where GitHub is: the host is in the path. What it writes "
        .. "down afterwards, in go.mod and go.sum, is what makes next month's build the same build.",
      "16:00. 사촌 가게가 github.com/alex/luckymac/menu를 import하자 go 도구는 GitHub가 어딘지 듣지도 않고 "
        .. "받아온다. 호스트가 경로 안에 있으니까. 그 뒤 go.mod와 go.sum에 적어 두는 것이 다음 달 빌드를 "
        .. "같은 빌드로 만든다.",
      "16:00. 表哥間舖 import github.com/alex/luckymac/menu，go 工具唔使人話佢 GitHub 喺邊就自己去攞："
        .. "個 host 就喺 path 入面。之後佢寫落 go.mod 同 go.sum 嘅嘢，就係令下個月 build 出嚟一模一樣嘅原因。"
    ),
    stages = {
      {
        topic = "GET",
        q = L(
          "Add a dependency at an exact version. Which subcommand?",
          "정확한 버전으로 의존성을 추가한다. 어떤 하위 명령?",
          "用指定版本加一個依賴。邊個子指令？"
        ),
        code = L(
          [[
$ go ___ github.com/alex/luckymac@v1.2.0
go: downloading github.com/alex/luckymac v1.2.0
go: added github.com/alex/luckymac v1.2.0
]],
          [[
$ go ___ github.com/alex/luckymac@v1.2.0
go: downloading github.com/alex/luckymac v1.2.0
go: added github.com/alex/luckymac v1.2.0
]],
          [[
$ go ___ github.com/alex/luckymac@v1.2.0
go: downloading github.com/alex/luckymac v1.2.0
go: added github.com/alex/luckymac v1.2.0
]]
        ),
        accept = { "get" },
        answer = "get",
        hint = L(
          "Three letters, what you do to fetch something. The @ picks the version; without it, latest.",
          "세 글자, 무언가를 가져올 때 하는 일. @가 버전을 고르고, 없으면 latest.",
          "三個字母，攞嘢嗰個動作。@ 揀版本；冇 @ 就係 latest。"
        ),
        ok = L(
          "go get resolves the host from the path itself: github.com means a git clone over HTTPS, through the proxy by default. No registry, no publish step.",
          "go get은 경로 자체에서 호스트를 알아낸다. github.com이면 HTTPS로 git clone하며, 기본은 프록시를 거친다. 레지스트리도, publish 단계도 없다.",
          "go get 由個 path 本身就知道 host：github.com 即係經 HTTPS git clone，預設經 proxy。冇 registry，冇 publish 呢步。"
        ),
      },
      {
        topic = "REQUIRE",
        q = L(
          "go get wrote the pin into go.mod. Which directive?",
          "go get이 고정 버전을 go.mod에 적었다. 어떤 지시어?",
          "go get 將個版本寫咗入 go.mod。邊個指令？"
        ),
        code = L(
          [[
module github.com/siuming/cousinshop

go 1.23

___ github.com/alex/luckymac v1.2.0
]],
          [[
module github.com/siuming/cousinshop

go 1.23

___ github.com/alex/luckymac v1.2.0
]],
          [[
module github.com/siuming/cousinshop

go 1.23

___ github.com/alex/luckymac v1.2.0
]]
        ),
        accept = { "require" },
        answer = "require",
        hint = L(
          "Seven letters: to need. Several of them go in one parenthesised block.",
          "일곱 글자: 필요로 하다. 여러 개면 괄호 블록 하나에 들어간다.",
          "七個字母：需要。有幾個嘅話會放喺一個括號 block 入面。"
        ),
        ok = L(
          "require is a minimum, not an exact pin: if another dependency needs v1.3.0, the build uses v1.3.0. Minimal version selection, no lock file solver.",
          "require는 정확한 고정이 아니라 최소 버전이다. 다른 의존성이 v1.3.0을 요구하면 빌드는 v1.3.0을 쓴다. 최소 버전 선택, 락 파일 솔버 없음.",
          "require 係最低版本，唔係釘死：如果另一個依賴要 v1.3.0，build 就用 v1.3.0。最小版本選擇，冇 lock file solver。"
        ),
      },
      {
        topic = "HASH",
        q = L(
          "The second file guards against a tampered download. Name it.",
          "두 번째 파일은 변조된 다운로드를 막는다. 이름은?",
          "第二個檔案防止下載俾人改過。叫咩名？"
        ),
        code = L(
          [[
$ cat go.___
github.com/alex/luckymac v1.2.0 h1:9fK2...Qw=
github.com/alex/luckymac v1.2.0/go.mod h1:Lm0...c8=
]],
          [[
$ cat go.___
github.com/alex/luckymac v1.2.0 h1:9fK2...Qw=
github.com/alex/luckymac v1.2.0/go.mod h1:Lm0...c8=
]],
          [[
$ cat go.___
github.com/alex/luckymac v1.2.0 h1:9fK2...Qw=
github.com/alex/luckymac v1.2.0/go.mod h1:Lm0...c8=
]]
        ),
        accept = { "sum" },
        answer = "sum",
        hint = L(
          "Three letters, as in checksum. Commit it next to go.mod, always.",
          "세 글자, checksum의 그것. 언제나 go.mod 옆에 함께 커밋한다.",
          "三個字母，checksum 個尾嗰三個字母。永遠同 go.mod 一齊 commit。"
        ),
        ok = L(
          "go.sum is not a lock file, it is a list of hashes: if GitHub ever served different bytes for v1.2.0, the build fails instead of running them.",
          "go.sum은 락 파일이 아니라 해시 목록이다. GitHub가 v1.2.0에 다른 바이트를 준다면 빌드는 그것을 실행하지 않고 실패한다.",
          "go.sum 唔係 lock file，係一堆 hash：如果 GitHub 有日俾 v1.2.0 送啲唔同嘅 bytes，build 會直接失敗，唔會執行佢。"
        ),
      },
      {
        topic = "INDIRECT",
        q = L(
          "luckymac itself needs a JSON library you never import. How does go.mod mark it?",
          "luckymac 자체가 네가 import하지 않는 JSON 라이브러리를 필요로 한다. go.mod는 어떻게 표시하나?",
          "luckymac 自己要用一個你從來冇 import 嘅 JSON library。go.mod 點樣標記佢？"
        ),
        code = L(
          [[
require (
    github.com/alex/luckymac v1.2.0
    github.com/goccy/go-json v0.10.3 // ___
)
]],
          [[
require (
    github.com/alex/luckymac v1.2.0
    github.com/goccy/go-json v0.10.3 // ___
)
]],
          [[
require (
    github.com/alex/luckymac v1.2.0
    github.com/goccy/go-json v0.10.3 // ___
)
]]
        ),
        accept = { "indirect" },
        answer = "indirect",
        hint = L(
          "The opposite of direct. Your code never names it; something you require does.",
          "direct의 반대. 네 코드는 그것을 부르지 않지만 네가 require한 것이 부른다.",
          "direct 嘅相反。你嘅 code 從來冇提過佢；係你 require 嗰樣嘢要佢。"
        ),
        ok = L(
          "Since Go 1.17 go.mod lists every module the build needs, direct or not, so one file describes the whole graph. go mod tidy keeps the comments honest.",
          "Go 1.17부터 go.mod는 빌드에 필요한 모든 모듈을 직간접 가리지 않고 나열한다. 파일 하나가 그래프 전체를 설명한다. go mod tidy가 주석을 정직하게 유지한다.",
          "Go 1.17 開始 go.mod 會列晒 build 需要嘅每一個 module，直接定間接都有，一個檔案講晒成個 graph。go mod tidy 令啲註解保持誠實。"
        ),
      },
      {
        topic = "CACHE",
        q = L(
          "Where did the download actually land? Fill the last directory of the cache.",
          "다운로드는 실제로 어디에 놓였나? 캐시의 마지막 디렉터리를 채우기.",
          "個下載實際落咗喺邊？填 cache 最後嗰個資料夾。"
        ),
        code = L(
          [[
$ ls $(go env GOMODCACHE)
cache/  github.com/
$ go env GOMODCACHE
/Users/siuming/go/pkg/___
]],
          [[
$ ls $(go env GOMODCACHE)
cache/  github.com/
$ go env GOMODCACHE
/Users/siuming/go/pkg/___
]],
          [[
$ ls $(go env GOMODCACHE)
cache/  github.com/
$ go env GOMODCACHE
/Users/siuming/go/pkg/___
]]
        ),
        accept = { "mod" },
        answer = "mod",
        hint = L(
          "Three letters, short for module. Under GOPATH, read-only, shared by every project on the machine.",
          "세 글자, module의 줄임. GOPATH 아래, 읽기 전용, 이 머신의 모든 프로젝트가 공유한다.",
          "三個字母，module 嘅縮寫。喺 GOPATH 下面，唯讀，部機所有 project 共用。"
        ),
        ok = L(
          "Each version is unpacked once into pkg/mod/github.com/alex/luckymac@v1.2.0 and never touched again. go clean -modcache wipes it when the disk fills up.",
          "각 버전은 pkg/mod/github.com/alex/luckymac@v1.2.0에 한 번 풀리고 다시는 건드리지 않는다. 디스크가 차면 go clean -modcache로 지운다.",
          "每個版本淨係解壓一次去 pkg/mod/github.com/alex/luckymac@v1.2.0，之後唔會再掂。個碟滿咗就 go clean -modcache 清走。"
        ),
      },
    },
  },
  {
    id = "layout",
    station = "INTERNAL",
    name = L("cmd, internal, _test", "cmd, internal, _test", "cmd、internal、_test"),
    title = L("Laying out a repo", "저장소 배치하기", "點樣排一個 repo"),
    lesson = L(
      "A repo grows a shape: cmd/<name>/main.go per binary, internal/ for packages the compiler refuses to let outsiders import, a doc comment on every package, and menu_test.go in package menu_test so the tests use the package the way a caller would.",
      "저장소에는 모양이 생긴다. 바이너리마다 cmd/<name>/main.go, 컴파일러가 외부 import를 거부하는 패키지는 internal/, 패키지마다 문서 주석, 그리고 호출자처럼 패키지를 쓰도록 package menu_test로 된 menu_test.go.",
      "一個 repo 會慢慢有個形狀：每個 binary 一個 cmd/<name>/main.go，compiler 唔俾外人 import 嘅 package 放 internal/，每個 package 有 doc comment，同埋用 package menu_test 寫嘅 menu_test.go，令 test 好似 caller 噉用個 package。"
    ),
    bg = "bg_street",
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
          "The cousin's shop imported my rider package and now they call the function I wanted to delete.",
          "사촌 가게가 내 rider 패키지를 import했는데, 지우려던 함수를 부르고 있어.",
          "表哥間舖 import 咗我個 rider package，而家佢哋 call 緊我本來想刪嗰個 function。"
        ),
      },
      {
        kind = "clerk",
        x = 900,
        facing = -1,
        line = L(
          "So put it somewhere they cannot reach. Go has a folder name for exactly that.",
          "그럼 닿을 수 없는 곳에 둬. Go엔 딱 그걸 위한 폴더 이름이 있어.",
          "咁就擺喺佢哋掂唔到嘅地方。Go 有個資料夾名專門做呢樣嘢。"
        ),
      },
    },
    viz = "chips",
    chips = {
      { "cmd/luckymac/main.go", "cyan" },
      { "internal/rider", "gold" },
      { "// Package menu ...", "pink" },
      { "package menu_test", "green" },
    },
    note = "internal  cmd  main  doc  _test",
    story = L(
      "16:15. Exporting a name is a promise, and the cousin's shop just took Alex up on one he "
        .. "never meant to make. The fix is not a comment asking people to be nice: it is a "
        .. "directory name the compiler enforces, and a layout that says which packages are the API.",
      "16:15. 이름을 내보내는 것은 약속이고, 사촌 가게는 알렉스가 할 생각도 없던 약속을 받아들였다. "
        .. "해법은 착하게 굴어 달라는 주석이 아니다. 컴파일러가 강제하는 디렉터리 이름, "
        .. "그리고 어느 패키지가 API인지 말해 주는 배치다.",
      "16:15. export 一個名就係一個承諾，而表哥間舖啱啱接受咗一個阿力從來冇打算許嘅承諾。"
        .. "解法唔係寫個註解求人哋守規矩：係一個 compiler 會強制嘅資料夾名，"
        .. "同埋一個講明邊啲 package 係 API 嘅排法。"
    ),
    stages = {
      {
        topic = "INTERNAL",
        q = L(
          "Which directory name makes a package importable only from inside this module?",
          "어떤 디렉터리 이름이 패키지를 이 모듈 안에서만 import되게 하나?",
          "邊個資料夾名令一個 package 淨係可以喺呢個 module 入面 import？"
        ),
        code = L(
          [[
luckymac/
  ___/rider/rider.go     <- only luckymac/... may import
  menu/price.go          <- anyone may import
]],
          [[
luckymac/
  ___/rider/rider.go     <- luckymac/... 만 import 가능
  menu/price.go          <- 누구나 import 가능
]],
          [[
luckymac/
  ___/rider/rider.go     <- 淨係 luckymac/...
  menu/price.go          <- 邊個都得
]]
        ),
        accept = { "internal" },
        answer = "internal",
        hint = L(
          "Eight letters, the opposite of external. The rule is in the compiler, not in a linter.",
          "여덟 글자, external의 반대. 규칙은 린터가 아니라 컴파일러에 있다.",
          "八個字母，external 嘅相反。呢條規矩喺 compiler 入面，唔係 linter。"
        ),
        ok = L(
          "Anything under internal/ can be imported only by code rooted at internal's parent. The cousin's shop gets a compile error, and you keep the right to delete.",
          "internal/ 아래는 internal의 부모를 루트로 하는 코드만 import할 수 있다. 사촌 가게는 컴파일 에러를 받고, 너는 지울 권리를 지킨다.",
          "internal/ 下面嘅嘢，淨係以 internal 嘅上一層做根嘅 code 先 import 到。表哥間舖會收到 compile error，而你保住刪嘢嘅權利。"
        ),
      },
      {
        topic = "CMD",
        q = L(
          "Two binaries, one repo. Which directory holds one main package per binary?",
          "바이너리 둘, 저장소 하나. 바이너리마다 main 패키지를 하나씩 담는 디렉터리는?",
          "兩個 binary，一個 repo。邊個資料夾每個 binary 放一個 main package？"
        ),
        code = L(
          [[
luckymac/
  ___/luckymac/main.go   # go build ./___/luckymac
  ___/kiosk/main.go      # go build ./___/kiosk
  menu/  internal/
]],
          [[
luckymac/
  ___/luckymac/main.go   # go build ./___/luckymac
  ___/kiosk/main.go      # go build ./___/kiosk
  menu/  internal/
]],
          [[
luckymac/
  ___/luckymac/main.go   # go build ./___/luckymac
  ___/kiosk/main.go      # go build ./___/kiosk
  menu/  internal/
]]
        ),
        accept = { "cmd" },
        answer = "cmd",
        hint = L(
          "Three letters, short for command. A convention, not a rule, but one every Go repo follows.",
          "세 글자, command의 줄임. 규칙은 아니지만 모든 Go 저장소가 따르는 관례.",
          "三個字母，command 嘅縮寫。係慣例唔係規則，但每個 Go repo 都咁做。"
        ),
        ok = L(
          "go install github.com/alex/luckymac/cmd/kiosk@latest builds a binary named kiosk: the last path element becomes the program name.",
          "go install github.com/alex/luckymac/cmd/kiosk@latest는 kiosk라는 바이너리를 만든다. 경로의 마지막 요소가 프로그램 이름이 된다.",
          "go install github.com/alex/luckymac/cmd/kiosk@latest 會 build 一個叫 kiosk 嘅 binary：path 最後一截就係程式名。"
        ),
      },
      {
        topic = "MAIN",
        q = L(
          "A directory that builds into a program declares which package?",
          "프로그램으로 빌드되는 디렉터리는 어떤 패키지를 선언하나?",
          "會 build 成程式嘅資料夾，宣告邊個 package？"
        ),
        code = L(
          [[
// cmd/kiosk/main.go
package ___

func main() { kiosk.Run() }
]],
          [[
// cmd/kiosk/main.go
package ___

func main() { kiosk.Run() }
]],
          [[
// cmd/kiosk/main.go
package ___

func main() { kiosk.Run() }
]]
        ),
        accept = { "main" },
        answer = "main",
        hint = L(
          "The one package name that does not follow its directory. The same word as the function.",
          "디렉터리 이름을 따르지 않는 유일한 패키지 이름. 함수와 같은 단어.",
          "唯一一個唔跟資料夾名嘅 package 名。同個 function 同一個字。"
        ),
        ok = L(
          "package main plus func main is a program; anything else is a library. Nobody can import a main package, so keep it thin and put the logic in a package others can test.",
          "package main과 func main이면 프로그램, 그 외는 라이브러리. main 패키지는 아무도 import할 수 없으니 얇게 두고 로직은 남이 테스트할 수 있는 패키지에 둔다.",
          "package main 加 func main 就係程式；其他都係 library。冇人可以 import 一個 main package，所以佢要薄，邏輯擺入其他人 test 到嘅 package。"
        ),
      },
      {
        topic = "DOC",
        q = L(
          "pkg.go.dev shows the first sentence of the package comment. Start it properly.",
          "pkg.go.dev는 패키지 주석의 첫 문장을 보여 준다. 제대로 시작하기.",
          "pkg.go.dev 會顯示 package comment 嘅第一句。正確噉開頭。"
        ),
        code = L(
          [[
// ___ menu prices the morning set and the tea set.
package menu
]],
          [[
// ___ menu prices the morning set and the tea set.
package menu
]],
          [[
// ___ menu prices the morning set and the tea set.
package menu
]]
        ),
        accept = { "Package" },
        answer = "Package",
        hint = L(
          "The word package, capitalised, followed by the package's name. One comment per package, in one file.",
          "package라는 단어를 대문자로, 그다음 패키지 이름. 패키지당 주석 하나, 파일 하나에.",
          "package 呢個字大楷，跟住 package 個名。每個 package 一個 comment，寫喺一個檔案。"
        ),
        ok = L(
          "Doc comments are the API reference: go doc, gopls hover and pkg.go.dev all read them. Start each with the name it documents so it reads as a sentence.",
          "문서 주석이 곧 API 레퍼런스다. go doc, gopls 호버, pkg.go.dev가 모두 그것을 읽는다. 문장이 되도록 설명하는 이름으로 시작한다.",
          "doc comment 就係 API 參考：go doc、gopls hover、pkg.go.dev 全部讀佢。每個都用佢描述嗰個名開頭，先讀落係一句句子。"
        ),
      },
      {
        topic = "EXTTEST",
        q = L(
          "Test the package the way a caller sees it. Fill the suffix of the test package name.",
          "호출자가 보는 대로 패키지를 테스트한다. 테스트 패키지 이름의 접미사를 채우기.",
          "用 caller 嘅角度 test 個 package。填 test package 名嘅後綴。"
        ),
        code = L(
          [[
// menu/price_test.go
package menu___

import "github.com/alex/luckymac/menu"
]],
          [[
// menu/price_test.go
package menu___

import "github.com/alex/luckymac/menu"
]],
          [[
// menu/price_test.go
package menu___

import "github.com/alex/luckymac/menu"
]]
        ),
        accept = { "_test", "test" },
        answer = "_test",
        hint = L(
          "An underscore and four letters, the same suffix the file name carries. The only case of two packages in one directory.",
          "밑줄과 네 글자, 파일 이름이 가진 그 접미사. 한 디렉터리에 두 패키지가 있는 유일한 경우.",
          "一條底線加四個字母，同檔案名嗰個後綴一樣。唯一一個一個資料夾兩個 package 嘅情況。"
        ),
        ok = L(
          "package menu_test can only use the exported API, so the tests prove what callers can do. Plain package menu tests reach the unexported parts.",
          "package menu_test는 내보낸 API만 쓸 수 있어, 호출자가 할 수 있는 것을 테스트가 증명한다. 그냥 package menu 테스트는 비공개 부분에 닿는다.",
          "package menu_test 淨係用到 export 咗嘅 API，所以啲 test 證明到 caller 做到啲乜。普通 package menu 嘅 test 就掂到冇 export 嘅部分。"
        ),
      },
    },
  },
  {
    id = "gowork",
    station = "REPLACE",
    name = L("Two repos, one laptop", "저장소 둘, 노트북 하나", "兩個 repo，一部機"),
    title = L("replace, go.work, vendor", "replace와 go.work, vendor", "replace、go.work、vendor"),
    lesson = L(
      "When you edit a library and its caller at the same time, replace points a module path at a folder on disk, and go.work does it for a whole workspace without touching any go.mod. cannot find module means the import path and go.mod disagree; go mod tidy repairs go.mod from the imports. go mod vendor copies every dependency into the repo for builds with no network.",
      "라이브러리와 호출자를 동시에 고칠 때, replace는 모듈 경로를 디스크의 폴더로 돌리고, go.work는 어떤 go.mod도 건드리지 않고 작업 공간 전체에 그렇게 한다. cannot find module은 import 경로와 go.mod가 어긋났다는 뜻이며, go mod tidy가 import를 기준으로 go.mod를 고친다. go mod vendor는 네트워크 없는 빌드를 위해 모든 의존성을 저장소에 복사한다.",
      "同時改 library 同佢個 caller 嘅時候，replace 將一個 module path 指去碟上面嘅資料夾，go.work 就唔使掂任何 go.mod 幫成個 workspace 做呢件事。cannot find module 即係 import path 同 go.mod 唔夾；go mod tidy 會跟住啲 import 修好 go.mod。go mod vendor 將所有依賴複製入 repo，等冇網絡都 build 到。"
    ),
    bg = "bg_flat",
    portrait = "portrait_friends",
    speaker = L("Mei", "메이", "阿美"),
    ground = 348,
    spawn = 150,
    width = 1600,
    npcs = {
      {
        kind = "mei",
        x = 560,
        facing = 1,
        line = L(
          "You fixed Price in luckymac, but the cousin's shop still builds against v1.2.0 from the cache. Of course it does.",
          "luckymac의 Price를 고쳤지만 사촌 가게는 여전히 캐시의 v1.2.0으로 빌드해. 당연하지.",
          "你喺 luckymac 改好咗 Price，但表哥間舖仲係用 cache 入面嘅 v1.2.0 build。梗係啦。"
        ),
      },
      {
        kind = "hero",
        x = 940,
        facing = -1,
        line = L(
          "I do not want to tag a release every time I change a line. Point it at my folder.",
          "줄 하나 바꿀 때마다 릴리스 태그를 달고 싶진 않아. 내 폴더를 가리키게 하자.",
          "我唔想改一行就要打個 release tag。指住我個資料夾得唔得。"
        ),
      },
    },
    viz = "chips",
    chips = {
      { "replace x => ../x", "cyan" },
      { "go work init", "gold" },
      { "go mod tidy", "pink" },
      { "vendor/", "green" },
    },
    note = "replace  work  use  tidy  vendor",
    story = L(
      "16:30. The path problem in the flesh: the library on disk is newer than the library in the "
        .. "cache, and the import path points at the cache. Two lines of go.mod, or one go.work "
        .. "file, redirect a path to a folder while you work, and tidy puts go.mod back in step.",
      "16:30. 경로 문제의 실체: 디스크의 라이브러리는 캐시의 것보다 새것인데 import 경로는 캐시를 가리킨다. "
        .. "go.mod 두 줄, 또는 go.work 파일 하나가 작업하는 동안 경로를 폴더로 돌리고, "
        .. "tidy가 go.mod를 다시 맞춘다.",
      "16:30. path 問題真身：碟上面個 library 新過 cache 入面嗰個，而 import path 指住 cache。"
        .. "go.mod 兩行，或者一個 go.work 檔，喺你做嘢期間將 path 轉去資料夾，tidy 再幫 go.mod 對返。"
    ),
    stages = {
      {
        topic = "REPLACE",
        q = L(
          "Point the import path at the folder next door while you work. Which directive?",
          "작업하는 동안 import 경로를 옆 폴더로 돌린다. 어떤 지시어?",
          "做嘢期間將 import path 指去隔籬個資料夾。用邊個指令？"
        ),
        code = L(
          [[
require github.com/alex/luckymac v1.2.0

___ github.com/alex/luckymac => ../luckymac
]],
          [[
require github.com/alex/luckymac v1.2.0

___ github.com/alex/luckymac => ../luckymac
]],
          [[
require github.com/alex/luckymac v1.2.0

___ github.com/alex/luckymac => ../luckymac
]]
        ),
        accept = { "replace" },
        answer = "replace",
        hint = L(
          "Seven letters: swap one thing for another. The arrow reads 'with'.",
          "일곱 글자: 하나를 다른 것으로 바꾸다. 화살표는 '으로'라고 읽는다.",
          "七個字母：用一樣嘢換另一樣。個箭頭讀做「換成」。"
        ),
        ok = L(
          "replace applies only in the main module: the cousin's users never see it. Keep the require line, and take the replace out before you commit.",
          "replace는 메인 모듈에서만 적용된다. 사촌 가게의 사용자는 볼 일이 없다. require 줄은 두고, 커밋 전에 replace를 빼라.",
          "replace 淨係喺 main module 生效：表哥間舖嘅用戶永遠見唔到。require 行留低，commit 之前記得拎走個 replace。"
        ),
      },
      {
        topic = "WORK",
        q = L(
          "Same thing for both repos at once, with no edit to either go.mod. Which subcommand?",
          "두 저장소 모두에, 어느 go.mod도 고치지 않고 한 번에. 어떤 하위 명령?",
          "兩個 repo 一齊，唔使改任何一個 go.mod。邊個子指令？"
        ),
        code = L(
          [[
$ ls
cousinshop/  luckymac/
$ go ___ init ./cousinshop ./luckymac
]],
          [[
$ ls
cousinshop/  luckymac/
$ go ___ init ./cousinshop ./luckymac
]],
          [[
$ ls
cousinshop/  luckymac/
$ go ___ init ./cousinshop ./luckymac
]]
        ),
        accept = { "work" },
        answer = "work",
        hint = L(
          "Four letters, as in workspace. Go 1.18. It writes a go.work file beside the two folders.",
          "네 글자, workspace의 앞부분. Go 1.18. 두 폴더 옆에 go.work 파일을 쓴다.",
          "四個字母，workspace 嘅頭四個。Go 1.18。佢會喺兩個資料夾旁邊寫一個 go.work。"
        ),
        ok = L(
          "Inside a workspace every listed module is built from disk, so a change in luckymac is seen by cousinshop on the next build. go.work is for your machine; do not commit it.",
          "작업 공간 안에서는 나열된 모든 모듈이 디스크에서 빌드되어, luckymac을 바꾸면 다음 빌드에서 cousinshop이 본다. go.work는 내 머신용이니 커밋하지 않는다.",
          "喺 workspace 入面，列咗嘅每個 module 都由碟 build，所以 luckymac 一改，cousinshop 下次 build 就見到。go.work 係你部機用嘅，唔好 commit。"
        ),
      },
      {
        topic = "USE",
        q = L(
          "Add a third module to the workspace by hand. Which go.work directive lists a folder?",
          "작업 공간에 세 번째 모듈을 손으로 추가한다. 폴더를 나열하는 go.work 지시어는?",
          "手動加第三個 module 入 workspace。go.work 邊個指令列出資料夾？"
        ),
        code = L(
          [[
go 1.23

___ (
    ./cousinshop
    ./luckymac
    ./kiosk
)
]],
          [[
go 1.23

___ (
    ./cousinshop
    ./luckymac
    ./kiosk
)
]],
          [[
go 1.23

___ (
    ./cousinshop
    ./luckymac
    ./kiosk
)
]]
        ),
        accept = { "use" },
        answer = "use",
        hint = L(
          "Three letters, the plainest verb there is. go work use ./kiosk writes the same line.",
          "세 글자, 가장 평범한 동사. go work use ./kiosk가 같은 줄을 쓴다.",
          "三個字母，最普通嗰個動詞。go work use ./kiosk 寫出嚟都係同一行。"
        ),
        ok = L(
          "A go.work is a list of use directories and optional replaces. It never lists versions: those still come from each module's own go.mod.",
          "go.work는 use 디렉터리 목록과 선택적 replace다. 버전은 절대 나열하지 않는다. 그것은 여전히 각 모듈의 go.mod에서 온다.",
          "go.work 就係一堆 use 資料夾加可有可無嘅 replace。佢從來唔列版本：版本仍然由每個 module 自己嘅 go.mod 嚟。"
        ),
      },
      {
        topic = "TIDY",
        q = L(
          "cannot find module providing package. Which subcommand rebuilds go.mod from the imports?",
          "cannot find module providing package. import를 기준으로 go.mod를 다시 만드는 하위 명령은?",
          "cannot find module providing package。邊個子指令跟住啲 import 重建 go.mod？"
        ),
        code = L(
          [[
$ go build ./...
main.go:6:2: no required module provides package
    github.com/alex/luckymac/menu; to add it:
    go mod ___
]],
          [[
$ go build ./...
main.go:6:2: no required module provides package
    github.com/alex/luckymac/menu; to add it:
    go mod ___
]],
          [[
$ go build ./...
main.go:6:2: no required module provides package
    github.com/alex/luckymac/menu; to add it:
    go mod ___
]]
        ),
        accept = { "tidy" },
        answer = "tidy",
        hint = L(
          "Four letters: to clean up. The error message itself tells you the command.",
          "네 글자: 정리하다. 에러 메시지가 명령을 직접 알려 준다.",
          "四個字母：執拾。個 error message 自己會話你知邊個指令。"
        ),
        ok = L(
          "tidy walks every import in the module, adds what is missing to go.mod and go.sum and drops what nothing uses. Run it before every commit.",
          "tidy는 모듈의 모든 import를 훑어 빠진 것을 go.mod와 go.sum에 넣고 아무도 안 쓰는 것을 뺀다. 커밋 전마다 실행하라.",
          "tidy 行勻 module 入面每個 import，將欠嘅加入 go.mod 同 go.sum，將冇人用嘅拎走。每次 commit 之前都跑一次。"
        ),
      },
      {
        topic = "VENDOR",
        q = L(
          "The kitchen build box has no internet. Copy every dependency into the repo. Fill the subcommand.",
          "주방 빌드 머신은 인터넷이 없다. 모든 의존성을 저장소에 복사한다. 하위 명령을 채우기.",
          "廚房嗰部 build 機冇網。將所有依賴複製入 repo。填個子指令。"
        ),
        code = L(
          [[
$ go mod ___
$ ls
go.mod  go.sum  main.go  menu/  ___/
$ go build ./...      # reads ___/ automatically
]],
          [[
$ go mod ___
$ ls
go.mod  go.sum  main.go  menu/  ___/
$ go build ./...      # ___/ 를 자동으로 읽는다
]],
          [[
$ go mod ___
$ ls
go.mod  go.sum  main.go  menu/  ___/
$ go build ./...      # 自動讀 ___/
]]
        ),
        accept = { "vendor" },
        answer = "vendor",
        hint = L(
          "Six letters, the word for a supplier. The folder it makes has the same name.",
          "여섯 글자, 공급자를 뜻하는 단어. 만들어지는 폴더도 같은 이름.",
          "六個字母，供應商嗰個字。佢整出嚟嘅資料夾都係同一個名。"
        ),
        ok = L(
          "With a vendor directory present, go build uses it and never touches the network or the cache. It is the whole dependency set, checked in, reviewable in a diff.",
          "vendor 디렉터리가 있으면 go build는 그것을 쓰고 네트워크나 캐시를 건드리지 않는다. 의존성 전체가 체크인되어 diff로 리뷰할 수 있다.",
          "有 vendor 資料夾，go build 就用佢，唔會掂網絡或者 cache。成套依賴 check in 咗，diff 都 review 到。"
        ),
      },
    },
  },
  {
    id = "semver",
    station = "VERSION",
    name = L("Tag it v1.0.0", "v1.0.0 태그", "打個 v1.0.0 tag"),
    title = L("Semver tags and the /v2 rule", "semver 태그와 /v2 규칙", "semver tag 同 /v2 規矩"),
    lesson = L(
      "A Go release is a git tag: v1.0.0, pushed. go get pkg@latest picks the highest tag; no tag means a pseudo-version built from the commit. A breaking change is a new major, and a new major is a new import path: module github.com/you/x/v2. retract in go.mod tells everyone a tag was a mistake.",
      "Go의 릴리스는 git 태그다. v1.0.0을 push한다. go get pkg@latest는 가장 높은 태그를 고르고, 태그가 없으면 커밋으로 만든 의사 버전을 쓴다. 호환성을 깨는 변경은 새 메이저이고, 새 메이저는 새 import 경로다: module github.com/you/x/v2. go.mod의 retract는 어떤 태그가 실수였음을 모두에게 알린다.",
      "Go 嘅 release 就係一個 git tag：v1.0.0，push 上去。go get pkg@latest 揀最高嗰個 tag；冇 tag 就用由 commit 砌出嚟嘅 pseudo-version。破壞相容嘅改動係新 major，而新 major 就係新 import path：module github.com/you/x/v2。go.mod 入面嘅 retract 話俾所有人知某個 tag 打錯咗。"
    ),
    bg = "bg_mall",
    portrait = "portrait_clerk",
    speaker = L("Siu Ming", "시우밍", "小明"),
    ground = 348,
    spawn = 170,
    width = 1600,
    npcs = {
      {
        kind = "clerk",
        x = 540,
        facing = -1,
        line = L(
          "The cousin asks which version is safe. Right now the answer is 'whichever commit was on main when he ran go get'.",
          "사촌이 어느 버전이 안전한지 물어. 지금 답은 'go get 돌릴 때 main에 있던 아무 커밋'이야.",
          "表哥問邊個版本先安全。而家個答案係「佢跑 go get 嗰陣 main 上面嗰個 commit」。"
        ),
      },
      {
        kind = "hero",
        x = 900,
        facing = -1,
        line = L(
          "Then I owe him a tag. And a promise about what the number means.",
          "그럼 태그를 달아 줘야지. 그리고 그 숫자가 뜻하는 바에 대한 약속도.",
          "咁我欠佢一個 tag。仲有一個關於個數字代表咩嘅承諾。"
        ),
      },
    },
    viz = "chips",
    chips = {
      { "git tag v1.0.0", "cyan" },
      { "@latest", "gold" },
      { "module .../v2", "pink" },
      { "retract v1.0.1", "green" },
    },
    note = "tag  push  latest  /v2  retract",
    story = L(
      "16:45. There is no publish button. A Go module is released by pushing a git tag, and the "
        .. "number on the tag is a contract: patch and minor never break a caller, and a major "
        .. "that does gets a new import path so old and new can live side by side.",
      "16:45. publish 버튼은 없다. Go 모듈은 git 태그를 push해서 릴리스되고, 태그의 숫자는 계약이다. "
        .. "패치와 마이너는 호출자를 깨지 않고, 깨는 메이저는 새 import 경로를 받아 옛것과 새것이 나란히 산다.",
      "16:45. 冇 publish 掣。Go module 係靠 push 一個 git tag 嚟 release，而 tag 上面個數字係一份合約："
        .. "patch 同 minor 永遠唔會整爛 caller，會整爛嘅 major 就攞一個新 import path，新舊可以並存。"
    ),
    stages = {
      {
        topic = "TAG",
        q = L(
          "Release the module. Which git command names the commit?",
          "모듈을 릴리스한다. 커밋에 이름을 붙이는 git 명령은?",
          "release 個 module。邊個 git 指令幫個 commit 改名？"
        ),
        code = L(
          [[
$ git ___ v1.0.0
$ git push origin v1.0.0
]],
          [[
$ git ___ v1.0.0
$ git push origin v1.0.0
]],
          [[
$ git ___ v1.0.0
$ git push origin v1.0.0
]]
        ),
        accept = { "tag" },
        answer = "tag",
        hint = L(
          "Three letters, a label on a commit. The v in front is not optional for Go.",
          "세 글자, 커밋에 붙이는 라벨. 앞의 v는 Go에서 선택이 아니다.",
          "三個字母，貼喺 commit 上面嘅標籤。前面個 v 對 Go 嚟講唔係可有可無。"
        ),
        ok = L(
          "That push is the release. The proxy notices the tag the first time anyone asks for it; there is nothing else to upload.",
          "그 push가 곧 릴리스다. 프록시는 누군가 처음 요청할 때 태그를 알아챈다. 따로 올릴 것은 없다.",
          "嗰下 push 就係 release。第一次有人問嗰陣 proxy 就會留意到個 tag；冇其他嘢要上載。"
        ),
      },
      {
        topic = "LATEST",
        q = L(
          "The cousin wants the newest tag, whatever it is. Fill the version query.",
          "사촌은 무엇이든 가장 새 태그를 원한다. 버전 질의를 채우기.",
          "表哥想要最新嗰個 tag，係咩都好。填個版本查詢。"
        ),
        code = L(
          [[
$ go get github.com/alex/luckymac@___
go: upgraded github.com/alex/luckymac v0.3.0 => v1.0.0
]],
          [[
$ go get github.com/alex/luckymac@___
go: upgraded github.com/alex/luckymac v0.3.0 => v1.0.0
]],
          [[
$ go get github.com/alex/luckymac@___
go: upgraded github.com/alex/luckymac v0.3.0 => v1.0.0
]]
        ),
        accept = { "latest" },
        answer = "latest",
        hint = L(
          "Six letters, the most recent. @v1 or @main work too: a major, a branch, a commit hash.",
          "여섯 글자, 가장 최근. @v1이나 @main도 된다. 메이저, 브랜치, 커밋 해시.",
          "六個字母，最近嗰個。@v1 或者 @main 都得：一個 major、一個 branch、一個 commit hash。"
        ),
        ok = L(
          "latest means the highest tagged release, never a pre-release and never main. Without any tag at all you get a pseudo-version like v0.0.0-20260904164500-abc123def456.",
          "latest는 가장 높은 태그 릴리스를 뜻한다. 프리릴리스도 main도 아니다. 태그가 하나도 없으면 v0.0.0-20260904164500-abc123def456 같은 의사 버전을 받는다.",
          "latest 即係最高嗰個打咗 tag 嘅 release，永遠唔係 pre-release，亦唔係 main。完全冇 tag 嘅話，你會攞到好似 v0.0.0-20260904164500-abc123def456 噉嘅 pseudo-version。"
        ),
      },
      {
        topic = "MAJOR",
        q = L(
          "Price now returns cents, not dollars: a breaking change. What does the module path gain?",
          "Price가 이제 달러가 아니라 센트를 돌려준다. 깨지는 변경. 모듈 경로에 무엇이 붙나?",
          "Price 而家回 cents 唔係 dollars：破壞性改動。module path 要加啲咩？"
        ),
        code = L(
          [[
module github.com/alex/luckymac/___

// callers: import "github.com/alex/luckymac/___/menu"
]],
          [[
module github.com/alex/luckymac/___

// 호출자: import "github.com/alex/luckymac/___/menu"
]],
          [[
module github.com/alex/luckymac/___

// caller：import "github.com/alex/luckymac/___/menu"
]]
        ),
        accept = { "v2" },
        answer = "v2",
        hint = L(
          "The letter v and the new major number, as the last element of the path. Tag it v2.0.0.",
          "글자 v와 새 메이저 번호를 경로의 마지막 요소로. 태그는 v2.0.0.",
          "字母 v 加新嘅 major 數字，做 path 最後一截。tag 打 v2.0.0。"
        ),
        ok = L(
          "Semantic import versioning: v1 and v2 are different packages with different paths, so one binary can depend on both and nothing breaks by surprise.",
          "시맨틱 import 버저닝. v1과 v2는 경로가 다른 별개의 패키지라 한 바이너리가 둘 다 의존할 수 있고 갑자기 깨지는 일이 없다.",
          "semantic import versioning：v1 同 v2 係唔同 path 嘅唔同 package，一個 binary 可以同時依賴兩個，冇嘢會突然爛。"
        ),
      },
      {
        topic = "RETRACT",
        q = L(
          "v1.0.1 shipped with a wrong price. Warn everyone off it without deleting the tag.",
          "v1.0.1이 잘못된 가격으로 나갔다. 태그를 지우지 않고 모두에게 피하라고 알리기.",
          "v1.0.1 出咗個錯價。唔刪 tag 之下警告所有人唔好用。"
        ),
        code = L(
          [[
module github.com/alex/luckymac

go 1.23

___ v1.0.1 // wrong price for the tea set
]],
          [[
module github.com/alex/luckymac

go 1.23

___ v1.0.1 // 티세트 가격 오류
]],
          [[
module github.com/alex/luckymac

go 1.23

___ v1.0.1 // 下午茶套餐個價錯咗
]]
        ),
        accept = { "retract" },
        answer = "retract",
        hint = L(
          "Seven letters, to take back a statement. Go 1.16. The tag stays; go get stops choosing it.",
          "일곱 글자, 한 말을 거두다. Go 1.16. 태그는 남고 go get이 그것을 고르지 않게 된다.",
          "七個字母，收回講過嘅嘢。Go 1.16。個 tag 仲喺度；go get 唔會再揀佢。"
        ),
        ok = L(
          "Tags are immutable in Go's world: moving one breaks every go.sum that saw it. retract, then tag v1.0.2, is the only honest fix.",
          "Go 세계에서 태그는 불변이다. 태그를 옮기면 그것을 본 모든 go.sum이 깨진다. retract하고 v1.0.2를 태그하는 것이 유일하게 정직한 수정이다.",
          "喺 Go 嘅世界 tag 係不可變嘅：郁一個 tag 會整爛所有見過佢嘅 go.sum。retract，再 tag v1.0.2，先係唯一誠實嘅修法。"
        ),
      },
      {
        topic = "LIST",
        q = L(
          "What versions of everything is this build using? Fill the subcommand.",
          "이 빌드는 모든 것의 어떤 버전을 쓰고 있나? 하위 명령을 채우기.",
          "呢個 build 用緊所有嘢嘅邊個版本？填個子指令。"
        ),
        code = L(
          [[
$ go ___ -m all
github.com/siuming/cousinshop
github.com/alex/luckymac v1.0.0
github.com/goccy/go-json v0.10.3
]],
          [[
$ go ___ -m all
github.com/siuming/cousinshop
github.com/alex/luckymac v1.0.0
github.com/goccy/go-json v0.10.3
]],
          [[
$ go ___ -m all
github.com/siuming/cousinshop
github.com/alex/luckymac v1.0.0
github.com/goccy/go-json v0.10.3
]]
        ),
        accept = { "list" },
        answer = "list",
        hint = L(
          "Four letters, to enumerate. -m means modules rather than packages; -u adds available upgrades.",
          "네 글자, 나열하다. -m은 패키지가 아니라 모듈, -u를 붙이면 가능한 업그레이드까지.",
          "四個字母，列出嚟。-m 係 module 唔係 package；加 -u 就會顯示可以升級嘅版本。"
        ),
        ok = L(
          "go list -m -u all is the upgrade report; go get -u ./... takes them all. go mod why tells you which import dragged a module in.",
          "go list -m -u all은 업그레이드 보고서, go get -u ./...는 전부 올린다. go mod why는 어떤 import가 모듈을 끌어왔는지 알려 준다.",
          "go list -m -u all 係升級報告；go get -u ./... 一次過全部升。go mod why 就話你知邊個 import 拖咗個 module 入嚟。"
        ),
      },
    },
  },
  {
    id = "proxy",
    station = "PROXY",
    name = L("The proxy and the private repo", "프록시와 비공개 저장소", "proxy 同 private repo"),
    title = L("GOPROXY, GOPRIVATE, ssh", "GOPROXY와 GOPRIVATE, ssh", "GOPROXY、GOPRIVATE、ssh"),
    lesson = L(
      "By default go get asks proxy.golang.org, which caches every public module for ever and checks its hash against sum.golang.org. A private GitHub repo is invisible to the proxy: set GOPRIVATE=github.com/yourorg/* so the tool goes straight to git, and teach git to use ssh for github.com so the clone authenticates. When the cache turns stale or the disk fills, go clean -modcache.",
      "기본으로 go get은 proxy.golang.org에 묻는다. 모든 공개 모듈을 영구히 캐시하고 sum.golang.org와 해시를 대조한다. 비공개 GitHub 저장소는 프록시에 보이지 않으니 GOPRIVATE=github.com/yourorg/*를 설정해 도구가 git으로 직접 가게 하고, github.com에 ssh를 쓰도록 git에 가르쳐 clone이 인증되게 한다. 캐시가 상하거나 디스크가 차면 go clean -modcache.",
      "預設 go get 會問 proxy.golang.org，佢永久 cache 住所有公開 module，仲會同 sum.golang.org 對 hash。private GitHub repo 對 proxy 嚟講係隱形嘅：set GOPRIVATE=github.com/yourorg/* 令工具直接行 git，再教 git 對 github.com 用 ssh，個 clone 先可以認證。cache 壞咗或者碟滿咗，就 go clean -modcache。"
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
          "I made the repo private and go get says 404, even though I can clone it fine.",
          "저장소를 비공개로 바꿨더니 go get이 404를 내. clone은 잘 되는데.",
          "我將個 repo set 做 private，go get 就話 404，明明我 clone 就冇問題。"
        ),
      },
      {
        kind = "mei",
        x = 900,
        facing = -1,
        line = L(
          "You can clone it. The proxy cannot. Tell the tool which paths to fetch itself.",
          "너는 clone할 수 있지. 프록시는 못 해. 어떤 경로는 직접 받아오라고 도구에 알려 줘.",
          "你 clone 到，proxy 就唔得。話俾工具知邊啲 path 要自己去攞。"
        ),
      },
    },
    viz = "chips",
    chips = {
      { "GOPROXY=...,direct", "cyan" },
      { "GOPRIVATE=github.com/x/*", "gold" },
      { "insteadOf https://", "pink" },
      { "go clean -modcache", "green" },
    },
    note = "direct  GOPRIVATE  ssh  sumdb  modcache",
    story = L(
      "17:00. The last path problem is not on disk: it is between the go tool, a public proxy that "
        .. "mirrors the whole ecosystem, and a repo that only Alex's ssh key can open. Two environment "
        .. "variables and one git setting route the private path around the proxy.",
      "17:00. 마지막 경로 문제는 디스크가 아니라 go 도구와 생태계 전체를 미러링하는 공개 프록시, "
        .. "그리고 알렉스의 ssh 키로만 열리는 저장소 사이에 있다. 환경 변수 둘과 git 설정 하나가 "
        .. "비공개 경로를 프록시 옆으로 돌린다.",
      "17:00. 最後一個 path 問題唔喺碟上面：係喺 go 工具、一個 mirror 晒成個生態嘅公開 proxy，"
        .. "同一個淨係阿力嘅 ssh key 開得到嘅 repo 之間。兩個環境變數加一個 git 設定，就將 private path 繞過 proxy。"
    ),
    stages = {
      {
        topic = "PROXY",
        q = L(
          "Where does go get look first, and what does it fall back to? Fill the fallback.",
          "go get은 먼저 어디를 보고, 무엇으로 대체하나? 대체 값을 채우기.",
          "go get 先睇邊度，搵唔到就點？填個 fallback。"
        ),
        code = L(
          [[
$ go env GOPROXY
https://proxy.golang.org,___
]],
          [[
$ go env GOPROXY
https://proxy.golang.org,___
]],
          [[
$ go env GOPROXY
https://proxy.golang.org,___
]]
        ),
        accept = { "direct" },
        answer = "direct",
        hint = L(
          "Six letters: straight to the source, no proxy in between.",
          "여섯 글자: 중간에 프록시 없이 원본으로 바로.",
          "六個字母：直接去源頭，中間冇 proxy。"
        ),
        ok = L(
          "The proxy is why go get is fast and why a deleted GitHub repo does not break the world: it keeps every version it ever served.",
          "프록시 덕에 go get이 빠르고, 삭제된 GitHub 저장소가 세상을 깨뜨리지 않는다. 한 번 제공한 모든 버전을 보관한다.",
          "有 proxy 所以 go get 快，亦所以一個俾人刪咗嘅 GitHub repo 唔會搞爛全世界：佢派過嘅每個版本都會留住。"
        ),
      },
      {
        topic = "PRIVATE",
        q = L(
          "The repo is private and the proxy answers 404. Which variable sends those paths straight to git?",
          "저장소가 비공개라 프록시가 404를 낸다. 그 경로들을 git으로 바로 보내는 변수는?",
          "個 repo 係 private，proxy 回 404。邊個變數將嗰啲 path 直接送去 git？"
        ),
        code = L(
          [[
$ go env -w ___=github.com/luckymac-hk/*
$ go get github.com/luckymac-hk/kitchen@latest
]],
          [[
$ go env -w ___=github.com/luckymac-hk/*
$ go get github.com/luckymac-hk/kitchen@latest
]],
          [[
$ go env -w ___=github.com/luckymac-hk/*
$ go get github.com/luckymac-hk/kitchen@latest
]]
        ),
        accept = { "GOPRIVATE" },
        answer = "GOPRIVATE",
        hint = L(
          "GO plus the word for not public, all capitals. A comma-separated list of path globs.",
          "GO에 비공개를 뜻하는 단어, 전부 대문자. 쉼표로 이은 경로 글롭 목록.",
          "GO 加「唔公開」嗰個字，全大楷。用逗號分隔嘅 path glob 清單。"
        ),
        ok = L(
          "GOPRIVATE sets GONOPROXY and GONOSUMDB together: those modules skip the proxy and the checksum database, and their hashes go only in your go.sum.",
          "GOPRIVATE는 GONOPROXY와 GONOSUMDB를 함께 설정한다. 그 모듈들은 프록시와 체크섬 데이터베이스를 건너뛰고, 해시는 네 go.sum에만 들어간다.",
          "GOPRIVATE 一次過 set 埋 GONOPROXY 同 GONOSUMDB：嗰啲 module 跳過 proxy 同 checksum database，佢哋嘅 hash 淨係入你個 go.sum。"
        ),
      },
      {
        topic = "SSH",
        q = L(
          "git clones over https and asks for a password. Make it use your ssh key. Fill the git config key.",
          "git이 https로 clone하며 비밀번호를 묻는다. ssh 키를 쓰게 하기. git config 키를 채우기.",
          "git 用 https clone，要你打密碼。改用你嘅 ssh key。填個 git config key。"
        ),
        code = L(
          [[
$ git config --global \
    url."git@github.com:".___ "https://github.com/"
]],
          [[
$ git config --global \
    url."git@github.com:".___ "https://github.com/"
]],
          [[
$ git config --global \
    url."git@github.com:".___ "https://github.com/"
]]
        ),
        accept = { "insteadOf", "insteadof" },
        answer = "insteadOf",
        hint = L(
          "Two words as one, camelCase: use this, instead of that. The ssh form replaces the https prefix.",
          "두 단어를 하나로, 카멜케이스: 저것 대신 이것을. ssh 형식이 https 접두사를 대신한다.",
          "兩個字合埋一個，camelCase：用呢個，代替嗰個。ssh 形式取代 https 前綴。"
        ),
        ok = L(
          "go get always shells out to git for a direct fetch, so git's own config decides the transport. The tool never sees your key; git does.",
          "go get은 직접 받아올 때 언제나 git을 호출하므로 git 자신의 설정이 전송 방식을 정한다. 도구는 키를 보지 않고 git이 본다.",
          "go get 直接攞嘢嗰陣永遠係叫 git 做，所以係 git 自己嘅設定決定用咩傳輸。工具從來見唔到你嘅 key，git 先見到。"
        ),
      },
      {
        topic = "SUMDB",
        q = L(
          "Every public download is checked against a transparency log. Name its host.",
          "모든 공개 다운로드는 투명성 로그와 대조된다. 그 호스트 이름은?",
          "每個公開下載都會同一個 transparency log 對。個 host 叫咩？"
        ),
        code = L(
          [[
$ go env GOSUMDB
___.golang.org
]],
          [[
$ go env GOSUMDB
___.golang.org
]],
          [[
$ go env GOSUMDB
___.golang.org
]]
        ),
        accept = { "sum" },
        answer = "sum",
        hint = L(
          "The same three letters as the file next to go.mod. The proxy's sibling.",
          "go.mod 옆 파일과 같은 세 글자. 프록시의 형제.",
          "同 go.mod 隔籬個檔案一樣嗰三個字母。proxy 嘅兄弟。"
        ),
        ok = L(
          "sum.golang.org records the hash of every public version once, so two people who go get the same tag either get identical bytes or an error.",
          "sum.golang.org는 모든 공개 버전의 해시를 한 번 기록한다. 같은 태그를 go get한 두 사람은 똑같은 바이트를 받거나 에러를 받는다.",
          "sum.golang.org 將每個公開版本嘅 hash 記錄一次，所以兩個人 go get 同一個 tag，要麼攞到一模一樣嘅 bytes，要麼就 error。"
        ),
      },
      {
        topic = "CLEAN",
        q = L(
          "The cache is 9 GB and one entry is corrupt. Wipe it. Fill the flag.",
          "캐시가 9GB이고 항목 하나가 깨졌다. 지우기. 플래그를 채우기.",
          "cache 有 9 GB，有一個 entry 壞咗。清走佢。填個 flag。"
        ),
        code = L(
          [[
$ go clean -___
$ go build ./...     # everything downloads again, once
]],
          [[
$ go clean -___
$ go build ./...     # 전부 다시 받는다, 한 번만
]],
          [[
$ go clean -___
$ go build ./...     # 全部再下載一次，得一次
]]
        ),
        accept = { "modcache" },
        answer = "modcache",
        hint = L(
          "Two words joined: the mod folder, and what kind of folder it is. Eight letters.",
          "두 단어를 붙인 것: mod 폴더와 그 폴더의 종류. 여덟 글자.",
          "兩個字砌埋：mod 資料夾，同佢係邊種資料夾。八個字母。"
        ),
        ok = L(
          "The cache is read-only on purpose, so a corrupt entry cannot be edited, only removed. go.sum makes the re-download provably the same code.",
          "캐시는 일부러 읽기 전용이라 깨진 항목은 고칠 수 없고 지울 수만 있다. go.sum이 다시 받은 것이 같은 코드임을 증명한다.",
          "cache 係特登唯讀嘅，所以壞咗嘅 entry 改唔到，淨係可以刪。go.sum 令再下載嘅嘢證明到係同一份 code。"
        ),
      },
    },
  },
}

return maps
