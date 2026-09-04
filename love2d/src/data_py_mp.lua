-- Quest P6 PARALLEL: 02:00, after closing. Chef Bo's night batch has to
-- resize forty thousand delivery photos and total a month of receipts
-- before the morning delivery, and threads made it no faster. The GIL,
-- Process, Pool, Queue and Pipe, locks and Value, shared_memory, and
-- ProcessPoolExecutor. Prize: the SCALED stamp.
-- Same shape as src/data_py.lua: the blank ___ is NOT written in the code.

local function L(en, ko, yue)
  return { en = en, ko = ko, yue = yue }
end

local maps = {
  {
    id = "py_gil",
    station = "GIL",
    name = L("Eight cores, one busy", "코어 여덟, 바쁜 건 하나", "八個核，得一個忙"),
    title = L("Why threads do not go faster", "왜 스레드는 빨라지지 않나", "點解 thread 唔會快啲"),
    lesson = L(
      "One CPython process runs bytecode under a global interpreter lock, so eight threads doing arithmetic still use one core. The GIL is released around I/O and inside C extensions, which is why threads help downloads and not sums. multiprocessing sidesteps it: every process has its own interpreter and its own lock.",
      "CPython 프로세스 하나는 전역 인터프리터 락 아래에서 바이트코드를 실행한다. 그래서 계산을 하는 스레드 여덟 개도 코어 하나만 쓴다. GIL은 I/O 주변과 C 확장 안에서는 풀리며, 그래서 스레드는 다운로드에는 도움이 되고 합계에는 되지 않는다. multiprocessing은 이를 비껴간다. 프로세스마다 인터프리터와 락이 따로다.",
      "一個 CPython process 喺 global interpreter lock 之下行 bytecode，所以八條 thread 做加數都係用一個核。GIL 喺 I/O 前後同 C extension 入面會放開，所以 thread 幫到下載，幫唔到計數。multiprocessing 就繞過佢：每個 process 有自己嘅 interpreter 同自己嘅鎖。"
    ),
    bg = "bg_night",
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
          "I gave the photo job eight threads. The fan spun up and the clock did not move.",
          "사진 작업에 스레드 여덟 개를 줬어. 팬만 돌고 시계는 그대로야.",
          "我俾咗八條 thread 去做相。把散熱扇轉晒，個鐘冇郁過。"
        ),
      },
      {
        kind = "hero",
        x = 900,
        facing = -1,
        line = L(
          "Look at the load: one core at 100, seven asleep. That is not a threading bug, that is the design.",
          "부하를 봐. 코어 하나만 100, 일곱은 자고 있어. 스레딩 버그가 아니라 설계야.",
          "睇下個負載：一個核 100%，七個瞓緊。呢個唔係 thread 嘅 bug，係設計。"
        ),
      },
    },
    viz = "python",
    chips = {
      { "import multiprocessing", "cyan" },
      { "cpu_count() -> 8", "gold" },
      { "one core at 100%", "pink" },
      { "released around I/O", "green" },
    },
    note = "GIL  bytecode  released  cpu_count  processes",
    story = L(
      "02:00. The shutters are down and the night batch has forty thousand photos to resize before "
        .. "the morning delivery. Chef Bo threw threads at it and the laptop got hot and no faster. "
        .. "One lock in the interpreter is why, and there is exactly one way around it.",
      "02:00. 셔터는 내려갔고 야간 배치는 아침 배송 전에 사진 사만 장을 줄여야 한다. 보 셰프는 스레드를 "
        .. "던졌지만 노트북은 뜨거워지기만 하고 빨라지지 않았다. 인터프리터 안의 락 하나가 이유이고, "
        .. "그것을 피하는 길은 정확히 하나다.",
      "凌晨兩點。閘落咗，夜更要喺朝早送貨之前縮四萬張相。寶廚掉咗一堆 thread 落去，"
        .. "部機淨係熱，冇快過。原因係 interpreter 入面嗰把鎖，而繞過佢嘅方法得一個。"
    ),
    stages = {
      {
        topic = "LOCK",
        q = L(
          "What is the three-letter name of the lock that lets one thread run bytecode at a time?",
          "한 번에 한 스레드만 바이트코드를 실행하게 하는 락의 세 글자 이름은?",
          "令一次得一條 thread 行 bytecode 嗰把鎖，三個字母叫咩？"
        ),
        code = L(
          [[
# 8 threads, 8 cores, one core busy
# the reason has three letters: the ___
import threading
]],
          [[
# 스레드 8개, 코어 8개, 바쁜 건 하나
# 이유는 세 글자: ___
import threading
]],
          [[
# 8 條 thread、8 個核，得一個核忙
# 原因得三個字母：___
import threading
]]
        ),
        accept = { "GIL" },
        answer = "GIL",
        hint = L(
          "Global Interpreter Lock, said as one word.",
          "Global Interpreter Lock의 머리글자.",
          "Global Interpreter Lock 嘅縮寫。"
        ),
        ok = L(
          "The GIL protects CPython's own memory bookkeeping. It makes single-threaded code fast and multi-threaded arithmetic pointless.",
          "GIL은 CPython 자신의 메모리 장부를 보호한다. 단일 스레드 코드는 빠르게, 다중 스레드 계산은 무의미하게 만든다.",
          "GIL 保護 CPython 自己嗰本記憶體帳。佢令單 thread 快，令多 thread 計數冇意思。"
        ),
      },
      {
        topic = "MODULE",
        q = L(
          "Which standard library module gives real parallelism for CPU work?",
          "CPU 작업에 진짜 병렬성을 주는 표준 라이브러리 모듈은?",
          "邊個標準庫 module 令 CPU 工作真正並行？"
        ),
        code = L(
          [[
import ___

with ___.Pool() as pool:
    pool.map(resize, photos)
]],
          [[
import ___

with ___.Pool() as pool:
    pool.map(resize, photos)
]],
          [[
import ___

with ___.Pool() as pool:
    pool.map(resize, photos)
]]
        ),
        accept = { "multiprocessing" },
        answer = "multiprocessing",
        hint = L(
          "Many of the thing an operating system schedules. Fifteen letters, one word.",
          "운영체제가 스케줄하는 그것의 복수. 한 단어.",
          "作業系統排程嗰樣嘢嘅眾數。一個字。"
        ),
        ok = L(
          "multiprocessing copies the threading API onto processes, so the code looks the same and the cores actually fill up.",
          "multiprocessing은 threading API를 프로세스에 옮겨 놓는다. 코드는 비슷해 보이고 코어는 실제로 찬다.",
          "multiprocessing 將 threading 嘅 API 搬到 process 上面，所以 code 睇落一樣，但啲核真係用得晒。"
        ),
      },
      {
        topic = "COUNT",
        q = L(
          "How many workers? Ask the machine. Which function?",
          "워커는 몇 개? 머신에 물어보자. 어떤 함수?",
          "開幾多個 worker？問部機。用邊個 function？"
        ),
        code = L(
          [[
import multiprocessing as mp

n = mp.___()
print(f"{n} cores, {n} workers")
]],
          [[
import multiprocessing as mp

n = mp.___()
print(f"{n} cores, {n} workers")
]],
          [[
import multiprocessing as mp

n = mp.___()
print(f"{n} cores, {n} workers")
]]
        ),
        accept = { "cpu_count" },
        answer = "cpu_count",
        hint = L(
          "Three letters for the chip, an underscore, then the verb for counting. os has the same one.",
          "칩을 뜻하는 세 글자, 밑줄, 그리고 세다라는 단어. os에도 같은 것이 있다.",
          "晶片嗰三個字母、底線，再加「數」嗰個字。os 都有一個一樣嘅。"
        ),
        ok = L(
          "mp.cpu_count() is Go's runtime.NumCPU(). It counts logical cores, so on a laptop with hyper-threading it is twice the physical ones.",
          "mp.cpu_count()는 Go의 runtime.NumCPU()다. 논리 코어를 세므로 하이퍼스레딩 노트북이면 물리 코어의 두 배다.",
          "mp.cpu_count() 即係 Go 嘅 runtime.NumCPU()。佢數邏輯核，所以有 hyper-threading 嘅機會係實體核嘅兩倍。"
        ),
      },
      {
        topic = "IO",
        q = L(
          "Threads do help downloads. What happens to the GIL around a socket read?",
          "다운로드에는 스레드가 도움이 된다. 소켓 읽기 주변에서 GIL은 어떻게 되나?",
          "下載嘅話 thread 又幫到手。喺 socket 讀嘅時候，GIL 會點？"
        ),
        code = L(
          [[
# 400 URLs, threads are fine here:
# the GIL is ___ while the socket waits
requests.get(url)
]],
          [[
# URL 400개, 여기선 스레드로 충분:
# 소켓이 기다리는 동안 GIL은 ___
requests.get(url)
]],
          [[
# 400 個 URL，用 thread 就得：
# socket 等緊嗰陣 GIL 會俾人 ___
requests.get(url)
]]
        ),
        accept = { "released", "release" },
        answer = "released",
        hint = L(
          "The opposite of held. Past participle, eight letters.",
          "붙잡음의 반대. 과거분사.",
          "同「揸住」相反。過去分詞。"
        ),
        ok = L(
          "Blocking I/O and NumPy's C loops both drop the GIL, so threads overlap waiting perfectly. Pure Python arithmetic never drops it.",
          "블로킹 I/O와 NumPy의 C 루프는 GIL을 놓는다. 그래서 스레드가 기다림을 완벽히 겹친다. 순수 Python 계산은 놓지 않는다.",
          "阻塞式 I/O 同 NumPy 嘅 C loop 都會放開 GIL，所以 thread 可以完美咁疊住等。純 Python 計數就永遠唔放。"
        ),
      },
      {
        topic = "OWN",
        q = L(
          "Why does a second process escape the lock? Each one has its own ___.",
          "왜 두 번째 프로세스는 락을 벗어나나? 각자 자신의 ___를 가지므로.",
          "點解第二個 process 唔受把鎖限制？因為每個都有自己嘅 ___。"
        ),
        code = L(
          [[
# process 1: python3 -> its own GIL
# process 2: python3 -> its own ___
# two cores at 100%
]],
          [[
# 프로세스 1: python3 -> 자기만의 GIL
# 프로세스 2: python3 -> 자기만의 ___
# 코어 두 개가 100%
]],
          [[
# process 1：python3 -> 自己嘅 GIL
# process 2：python3 -> 自己嘅 ___
# 兩個核都 100%
]]
        ),
        accept = { "interpreter" },
        answer = "interpreter",
        hint = L(
          "The I in the middle of GIL, written out: the thing that runs your bytecode.",
          "GIL 가운데 글자 I를 풀어 쓴 것. 바이트코드를 실행하는 그것.",
          "GIL 中間個 I 嘅全寫：行你 bytecode 嗰樣嘢。"
        ),
        ok = L(
          "Separate interpreters mean separate memory: nothing is shared by accident, and everything shared on purpose has to be sent.",
          "인터프리터가 따로면 메모리도 따로다. 실수로 공유되는 것은 없고, 의도적으로 공유하려면 보내야 한다.",
          "唔同 interpreter 即係唔同記憶體：唔會意外共享，想共享就一定要送過去。"
        ),
      },
      {
        topic = "NOGIL",
        q = L(
          "Python 3.13 ships an experimental build without the lock. What is it called?",
          "Python 3.13은 락 없는 실험적 빌드를 낸다. 뭐라고 부르나?",
          "Python 3.13 有個冇把鎖嘅實驗版本。叫做咩？"
        ),
        code = L(
          [[
$ python3.13t -c "import sys; print(sys._is_gil_enabled())"
False
# this is the ___-threaded build (PEP 703)
]],
          [[
$ python3.13t -c "import sys; print(sys._is_gil_enabled())"
False
# 이것이 ___-threaded 빌드 (PEP 703)
]],
          [[
$ python3.13t -c "import sys; print(sys._is_gil_enabled())"
False
# 呢個就係 ___-threaded 版本（PEP 703）
]]
        ),
        accept = { "free" },
        answer = "free",
        hint = L(
          "Four letters: what the threads finally are, and what the build is called.",
          "네 글자. 스레드가 마침내 그렇게 된 상태이자 빌드의 이름.",
          "四個字母：啲 thread 終於變成噉，亦係個版本嘅名。"
        ),
        ok = L(
          "The free-threaded build removes the GIL and pays for it in single-thread speed and C extension support. Until it is the default, processes are the answer.",
          "free-threaded 빌드는 GIL을 없애는 대신 단일 스레드 속도와 C 확장 지원을 내준다. 기본이 되기 전까지 답은 프로세스다.",
          "free-threaded 版本拆走 GIL，代價係單 thread 速度同 C extension 支援。喺佢變成預設之前，答案仲係 process。"
        ),
      },
    },
  },
  {
    id = "py_proc",
    station = "PROCESS",
    name = L(
      "Second python, second core",
      "두 번째 파이썬, 두 번째 코어",
      "第二個 python，第二個核"
    ),
    title = L(
      "Process, start, join, __main__",
      "Process와 start, join, __main__",
      "Process、start、join、__main__"
    ),
    lesson = L(
      "multiprocessing.Process(target=f, args=(x,)) is threading's API on a real process: start() forks or spawns it, join() waits, exitcode says how it went and daemon=True lets it die with the parent. Under the spawn start method the child imports your file again, so everything that runs must sit behind if __name__ == '__main__'.",
      "multiprocessing.Process(target=f, args=(x,))는 threading의 API를 진짜 프로세스에 얹은 것이다. start()가 fork 또는 spawn하고, join()이 기다리고, exitcode가 결과를 말하며, daemon=True면 부모와 함께 죽는다. spawn 방식에서는 자식이 파일을 다시 import하므로, 실행되는 것은 모두 if __name__ == '__main__' 뒤에 있어야 한다.",
      "multiprocessing.Process(target=f, args=(x,)) 就係將 threading 嘅 API 放喺真 process 上面：start() fork 或者 spawn 佢，join() 等佢，exitcode 話你點收科，daemon=True 就會同 parent 一齊死。用 spawn 嘅時候個仔會再 import 你個檔案，所以會執行嘅嘢全部要擺喺 if __name__ == '__main__' 後面。"
    ),
    bg = "bg_lab",
    portrait = "portrait_officer",
    speaker = L("Chef Bo", "보 셰프", "寶廚"),
    ground = 348,
    spawn = 150,
    width = 1600,
    npcs = {
      {
        kind = "cook",
        x = 520,
        facing = 1,
        line = L(
          "I copied the threading code, changed one word, and the script started itself forever.",
          "스레딩 코드를 복사해 단어 하나만 바꿨더니 스크립트가 자기 자신을 무한히 시작했어.",
          "我照抄 threading 嗰段 code，改咗一個字，個 script 就不停開自己。"
        ),
      },
      {
        kind = "hero",
        x = 880,
        facing = -1,
        line = L(
          "Spawn re-imports your file in the child. Anything at top level runs again, including the spawning.",
          "spawn은 자식에서 파일을 다시 import해. 최상위의 모든 게 다시 실행돼. 프로세스 생성까지도.",
          "spawn 會喺個仔度再 import 你個檔案。最外層嘅嘢會再行一次，連開 process 嗰句都係。"
        ),
      },
    },
    viz = "python",
    chips = {
      { "Process(target=grind)", "cyan" },
      { "p.start(); p.join()", "gold" },
      { [[__name__ == "__main__"]], "pink" },
      { "p.exitcode == 0", "green" },
    },
    note = "Process  join  __main__  spawn  exitcode  daemon",
    story = L(
      "02:15. The fix looks like one word: Thread becomes Process. Then the terminal fills with the "
        .. "same log line a hundred times over, because a spawned child imports the script it came "
        .. "from and runs everything that is not tucked behind the main guard.",
      "02:15. 고치는 건 단어 하나처럼 보인다. Thread를 Process로. 그러자 터미널이 같은 로그 줄로 백 번 "
        .. "가득 찬다. spawn된 자식은 자기가 나온 스크립트를 import하고, main 가드 뒤에 숨지 않은 것을 "
        .. "모두 실행하기 때문이다.",
      "02:15. 睇落改一個字就得：Thread 變 Process。跟住個 terminal 打晒同一行 log 一百次，"
        .. "因為 spawn 出嚟嘅仔會 import 返自己嗰個 script，然後行晒所有冇收喺 main guard 後面嘅嘢。"
    ),
    stages = {
      {
        topic = "CLASS",
        q = L(
          "Run grind on its own core. Which multiprocessing class?",
          "grind를 자기 코어에서 실행한다. 어떤 multiprocessing 클래스?",
          "喺自己嗰個核度行 grind。用邊個 multiprocessing class？"
        ),
        code = L(
          [[
import multiprocessing as mp

p = mp.___(target=grind, args=(rows,))
]],
          [[
import multiprocessing as mp

p = mp.___(target=grind, args=(rows,))
]],
          [[
import multiprocessing as mp

p = mp.___(target=grind, args=(rows,))
]]
        ),
        accept = { "Process" },
        answer = "Process",
        hint = L(
          "The same shape as threading.Thread, one word, capitalised. What the operating system schedules.",
          "threading.Thread와 같은 모양, 한 단어, 대문자. 운영체제가 스케줄하는 그것.",
          "同 threading.Thread 一樣嘅形狀，一個字，大楷。作業系統排程嗰樣嘢。"
        ),
        ok = L(
          "mp.Process is a whole python interpreter of its own. It costs milliseconds to start, not microseconds: give it work worth the trip.",
          "mp.Process는 그 자체로 완전한 파이썬 인터프리터다. 시작에 마이크로초가 아니라 밀리초가 든다. 그만한 일을 줘라.",
          "mp.Process 本身就係一個完整嘅 python interpreter。開佢要毫秒，唔係微秒：值得行呢一轉先好用。"
        ),
      },
      {
        topic = "WAIT",
        q = L(
          "The parent must not print the total before the child finishes. Which method?",
          "부모는 자식이 끝나기 전에 합계를 찍으면 안 된다. 어떤 메서드?",
          "個仔未做完，parent 唔可以印個總數。用邊個 method？"
        ),
        code = L(
          [[
p.start()
p.___()
print("child finished")
]],
          [[
p.start()
p.___()
print("child finished")
]],
          [[
p.start()
p.___()
print("child finished")
]]
        ),
        accept = { "join" },
        answer = "join",
        hint = L(
          "Four letters, the same word threading uses. Go spells it wg.Wait().",
          "네 글자, threading이 쓰는 그 단어. Go에선 wg.Wait().",
          "四個字母，同 threading 用嘅字一樣。Go 寫做 wg.Wait()。"
        ),
        ok = L(
          "join() blocks until the child exits. Without it the parent can reach the end of the script and leave orphans behind.",
          "join()은 자식이 끝날 때까지 막는다. 없으면 부모가 스크립트 끝에 닿아 고아 프로세스를 남긴다.",
          "join() 會 block 到個仔行完為止。冇佢，parent 行到 script 尾就會留低啲孤兒 process。"
        ),
      },
      {
        topic = "GUARD",
        q = L(
          "Stop the child from spawning children. Which dunder goes in the guard?",
          "자식이 또 자식을 만들지 못하게 한다. 가드에 들어가는 던더는?",
          "唔好俾個仔再生仔。個 guard 入面擺邊個 dunder？"
        ),
        code = L(
          [[
def grind(rows):
    return sum(rows)

if ___ == "__main__":
    mp.Process(target=grind, args=(rows,)).start()
]],
          [[
def grind(rows):
    return sum(rows)

if ___ == "__main__":
    mp.Process(target=grind, args=(rows,)).start()
]],
          [[
def grind(rows):
    return sum(rows)

if ___ == "__main__":
    mp.Process(target=grind, args=(rows,)).start()
]]
        ),
        accept = { "__name__" },
        answer = "__name__",
        hint = L(
          "The module's own name, in double underscores. It is '__main__' only in the script you ran.",
          "모듈 자신의 이름, 밑줄 두 개로 감싼 것. 직접 실행한 스크립트에서만 '__main__'이다.",
          "module 自己個名，前後兩條底線。淨係你行嗰個 script 先會係 '__main__'。"
        ),
        ok = L(
          "Without the guard, spawn re-imports the file, the import starts another Process, and that is the fork bomb you just wrote by accident.",
          "가드가 없으면 spawn이 파일을 다시 import하고, 그 import가 또 Process를 시작한다. 실수로 쓴 fork 폭탄이다.",
          "冇個 guard，spawn 會再 import 個檔案，個 import 又開多個 Process，你就無意中寫咗個 fork bomb。"
        ),
      },
      {
        topic = "START",
        q = L(
          "macOS and Windows do not fork by default. Name their start method.",
          "macOS와 Windows는 기본으로 fork하지 않는다. 시작 방식의 이름은?",
          "macOS 同 Windows 預設唔係 fork。佢哋個 start method 叫咩？"
        ),
        code = L(
          [[
import multiprocessing as mp

mp.set_start_method("___")
# fresh interpreter, nothing inherited
]],
          [[
import multiprocessing as mp

mp.set_start_method("___")
# 새 인터프리터, 물려받는 것 없음
]],
          [[
import multiprocessing as mp

mp.set_start_method("___")
# 全新 interpreter，冇繼承任何嘢
]]
        ),
        accept = { "spawn" },
        answer = "spawn",
        hint = L(
          "Five letters, what a fish does with eggs. The alternatives are fork and forkserver.",
          "다섯 글자, 물고기가 알을 낳는 그 단어. 다른 선택지는 fork와 forkserver.",
          "五個字母，魚產卵嗰個字。另外兩個選擇係 fork 同 forkserver。"
        ),
        ok = L(
          "spawn starts a clean interpreter and pickles the target across, so nothing is silently inherited. fork is faster and shares everything, including locks held at the wrong moment.",
          "spawn은 깨끗한 인터프리터를 띄우고 타깃을 pickle해서 넘긴다. 조용히 물려받는 것이 없다. fork는 빠르지만 모든 것을 공유한다. 잘못된 순간에 잡힌 락까지.",
          "spawn 開個乾淨嘅 interpreter，將 target pickle 過去，冇嘢會靜靜雞繼承。fork 快啲但乜都共享，包括喺唔啱時候揸住嘅鎖。"
        ),
      },
      {
        topic = "STATUS",
        q = L(
          "Did the child succeed? Which attribute holds its exit status after join?",
          "자식이 성공했나? join 뒤 종료 상태를 담는 속성은?",
          "個仔成唔成功？join 之後邊個 attribute 有佢個結束狀態？"
        ),
        code = L(
          [[
p.join()
if p.___ != 0:
    print("the night batch died")
]],
          [[
p.join()
if p.___ != 0:
    print("야간 배치가 죽었다")
]],
          [[
p.join()
if p.___ != 0:
    print("夜更批次死咗")
]]
        ),
        accept = { "exitcode" },
        answer = "exitcode",
        hint = L(
          "Two words joined, no underscore: how it left, as a number. None until it has.",
          "두 단어를 붙인 것, 밑줄 없음. 어떻게 끝났는지를 숫자로. 끝나기 전엔 None.",
          "兩個字砌埋，冇底線：點樣走，用數字表示。未走就係 None。"
        ),
        ok = L(
          "0 is clean, a positive number is sys.exit(n), and a negative one is the signal that killed it: -9 is the out-of-memory killer.",
          "0이면 정상, 양수면 sys.exit(n), 음수면 죽인 시그널이다. -9는 메모리 부족 킬러.",
          "0 即係正常，正數係 sys.exit(n)，負數係殺死佢嗰個 signal：-9 就係 OOM killer。"
        ),
      },
      {
        topic = "DAEMON",
        q = L(
          "The log tailer must not keep the batch alive. Which flag makes a child die with its parent?",
          "로그 감시자가 배치를 붙잡아 두면 안 된다. 자식을 부모와 함께 죽게 하는 플래그는?",
          "個 log 監視器唔可以拖住成個批次。邊個 flag 令個仔同 parent 一齊死？"
        ),
        code = L(
          [[
p = mp.Process(target=tail_log)
p.___ = True
p.start()
]],
          [[
p = mp.Process(target=tail_log)
p.___ = True
p.start()
]],
          [[
p = mp.Process(target=tail_log)
p.___ = True
p.start()
]]
        ),
        accept = { "daemon" },
        answer = "daemon",
        hint = L(
          "Six letters, the word Unix uses for a background service.",
          "여섯 글자, 유닉스가 백그라운드 서비스를 부르는 말.",
          "六個字母，Unix 叫背景服務嗰個字。"
        ),
        ok = L(
          "A daemon child is terminated when the parent exits, and it may not have children of its own. Use it for watchers, never for work you need finished.",
          "daemon 자식은 부모가 끝나면 종료되고, 자기 자식을 가질 수 없다. 감시자에 쓰고, 끝나야 하는 일에는 쓰지 마라.",
          "daemon 仔喺 parent 走嗰陣會俾人殺，佢自己亦唔可以有仔。用嚟做監視就啱，做要做完嘅工作就唔好。"
        ),
      },
    },
  },
  {
    id = "py_pool",
    station = "POOL",
    name = L("Forty thousand photos", "사진 사만 장", "四萬張相"),
    title = L(
      "Pool: map, imap, starmap, chunks",
      "Pool: map, imap, starmap, 청크",
      "Pool：map、imap、starmap、chunk"
    ),
    lesson = L(
      "A Pool starts N interpreters once and feeds them work. pool.map keeps the order and waits for everything; imap yields results as they land; starmap unpacks tuples into several arguments; apply_async returns a handle whose get() blocks. chunksize decides how many items travel per trip, and for tiny tasks it is the whole game.",
      "Pool은 인터프리터 N개를 한 번 띄우고 일을 먹인다. pool.map은 순서를 지키며 전부 기다리고, imap은 도착하는 대로 내주고, starmap은 튜플을 여러 인자로 풀고, apply_async는 get()이 막히는 핸들을 준다. chunksize는 한 번에 몇 개를 보낼지 정하며, 작은 작업에서는 그것이 전부다.",
      "Pool 一次過開 N 個 interpreter，再餵工作俾佢哋。pool.map 保持次序又等齊；imap 一到就俾你；starmap 將 tuple 拆做幾個參數；apply_async 回一個 handle，佢個 get() 會等。chunksize 決定一轉送幾多件，做細任務嘅時候，勝負就係佢。"
    ),
    bg = "bg_kitchen",
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
          "Do not start a Process per photo. Forty thousand interpreters is not parallelism, it is a fire.",
          "사진마다 Process를 만들지 마. 인터프리터 사만 개는 병렬이 아니라 화재야.",
          "唔好每張相開一個 Process。四萬個 interpreter 唔係並行，係火燭。"
        ),
      },
      {
        kind = "cook",
        x = 920,
        facing = -1,
        line = L(
          "Eight cooks, one order book. That I understand.",
          "요리사 여덟에 주문 장부 하나. 그건 이해했어.",
          "八個廚，一本落單簿。呢個我明。"
        ),
      },
    },
    viz = "python",
    chips = {
      { "with Pool(8) as pool:", "cyan" },
      { "pool.map(resize, jobs)", "gold" },
      { "starmap(f, pairs)", "pink" },
      { "chunksize=200", "green" },
    },
    note = "Pool  map  imap  starmap  get  chunksize",
    story = L(
      "02:30. Forty thousand photos, eight cores, and one lesson: pay for the interpreters once. "
        .. "A Pool is eight cooks reading the same order book, and the only real decision left is "
        .. "how many photos each of them carries across the kitchen at a time.",
      "02:30. 사진 사만 장, 코어 여덟, 그리고 교훈 하나: 인터프리터 값은 한 번만 치른다. "
        .. "Pool은 같은 주문 장부를 읽는 요리사 여덟이고, 남은 진짜 결정은 한 번에 사진 몇 장씩 "
        .. "들고 주방을 건널 것인가뿐이다.",
      "02:30. 四萬張相、八個核，一個教訓：interpreter 嘅錢只俾一次。"
        .. "Pool 就係八個廚睇住同一本落單簿，剩返嘅真正決定，係佢哋一次過捧幾多張相過廚房。"
    ),
    stages = {
      {
        topic = "POOL",
        q = L(
          "Eight workers, started once, reused all night. Which class?",
          "워커 여덟을 한 번 만들어 밤새 재사용. 어떤 클래스?",
          "八個 worker，開一次用成晚。用邊個 class？"
        ),
        code = L(
          [[
import multiprocessing as mp

with mp.___(8) as pool:
    sizes = pool.map(resize, photos)
]],
          [[
import multiprocessing as mp

with mp.___(8) as pool:
    sizes = pool.map(resize, photos)
]],
          [[
import multiprocessing as mp

with mp.___(8) as pool:
    sizes = pool.map(resize, photos)
]]
        ),
        accept = { "Pool" },
        answer = "Pool",
        hint = L(
          "Four letters, the same word Go uses for a set of workers reading one channel.",
          "네 글자. 하나의 채널을 읽는 워커 묶음을 Go도 그렇게 부른다.",
          "四個字母，Go 都係咁叫一班讀同一條 channel 嘅 worker。"
        ),
        ok = L(
          "The with block closes and joins the pool for you. Without it, a forgotten pool keeps eight interpreters resident.",
          "with 블록이 풀을 닫고 join까지 해 준다. 없으면 잊힌 풀이 인터프리터 여덟을 계속 붙잡는다.",
          "with block 會幫你 close 同 join 個 pool。冇佢，唔記得咗嘅 pool 會養住八個 interpreter。"
        ),
      },
      {
        topic = "MAP",
        q = L(
          "Resize every photo and keep the input order. Which method?",
          "모든 사진을 줄이되 입력 순서를 지킨다. 어떤 메서드?",
          "縮晒所有相，仲要保持輸入次序。用邊個 method？"
        ),
        code = L(
          [[
with mp.Pool(8) as pool:
    sizes = pool.___(resize, photos)
# sizes[0] belongs to photos[0]
]],
          [[
with mp.Pool(8) as pool:
    sizes = pool.___(resize, photos)
# sizes[0]은 photos[0]의 것
]],
          [[
with mp.Pool(8) as pool:
    sizes = pool.___(resize, photos)
# sizes[0] 對應 photos[0]
]]
        ),
        accept = { "map" },
        answer = "map",
        hint = L(
          "Three letters, the same name as the builtin it replaces.",
          "세 글자, 대신하는 내장 함수와 같은 이름.",
          "三個字母，同佢取代嗰個內建 function 同名。"
        ),
        ok = L(
          "pool.map blocks until the last worker is done and returns a list in order. The function and its arguments have to be picklable, so no lambdas.",
          "pool.map은 마지막 워커까지 기다린 뒤 순서대로 리스트를 준다. 함수와 인자는 pickle 가능해야 하므로 람다는 안 된다.",
          "pool.map 等到最後一個 worker 做完，再順住次序俾返個 list。個 function 同啲參數要 picklable，所以唔可以用 lambda。"
        ),
      },
      {
        topic = "STREAM",
        q = L(
          "Forty thousand results will not fit in memory. Which method yields them one by one?",
          "결과 사만 개는 메모리에 안 들어간다. 하나씩 내주는 메서드는?",
          "四萬個結果擺唔落記憶體。邊個 method 一個一個 yield？"
        ),
        code = L(
          [[
with mp.Pool(8) as pool:
    for size in pool.___(resize, photos):
        log(size)
]],
          [[
with mp.Pool(8) as pool:
    for size in pool.___(resize, photos):
        log(size)
]],
          [[
with mp.Pool(8) as pool:
    for size in pool.___(resize, photos):
        log(size)
]]
        ),
        accept = { "imap", "imap_unordered" },
        answer = "imap",
        hint = L(
          "map with an i in front, as in iterator. There is an _unordered twin that is faster.",
          "map 앞에 i, iterator의 i. 더 빠른 _unordered 쌍둥이도 있다.",
          "map 前面加個 i，即 iterator。仲有個快啲嘅 _unordered 孖生兄弟。"
        ),
        ok = L(
          "imap gives a lazy iterator in order; imap_unordered gives them as they finish, which keeps every worker busy when the jobs are uneven.",
          "imap은 순서를 지키는 지연 이터레이터를 주고, imap_unordered는 끝나는 대로 준다. 작업 크기가 고르지 않을 때 워커를 놀리지 않는다.",
          "imap 順住次序俾你一個 lazy iterator；imap_unordered 就邊個做完先俾邊個，啲工作大細唔均勻嗰陣可以令每個 worker 都唔停手。"
        ),
      },
      {
        topic = "TUPLES",
        q = L(
          "Now the worker takes two arguments. Which method unpacks each tuple?",
          "이제 워커가 인자를 둘 받는다. 각 튜플을 푸는 메서드는?",
          "而家個 worker 收兩個參數。邊個 method 幫你拆開每個 tuple？"
        ),
        code = L(
          [[
jobs = [(p, 512) for p in photos]
with mp.Pool(8) as pool:
    pool.___(resize, jobs)
]],
          [[
jobs = [(p, 512) for p in photos]
with mp.Pool(8) as pool:
    pool.___(resize, jobs)
]],
          [[
jobs = [(p, 512) for p in photos]
with mp.Pool(8) as pool:
    pool.___(resize, jobs)
]]
        ),
        accept = { "starmap" },
        answer = "starmap",
        hint = L(
          "The * you would write in resize(*job), spelled out, then map.",
          "resize(*job)에 쓰는 * 를 단어로 쓰고 map을 붙인 것.",
          "resize(*job) 嗰個 * 用英文寫出嚟，再加 map。"
        ),
        ok = L(
          "starmap(f, [(a, b), ...]) calls f(a, b). It is the difference between one argument and several, and the reason you rarely need a wrapper function.",
          "starmap(f, [(a, b), ...])은 f(a, b)를 부른다. 인자 하나와 여럿의 차이이며, 래퍼 함수를 거의 쓰지 않아도 되는 이유다.",
          "starmap(f, [(a, b), ...]) 會 call f(a, b)。呢個就係一個參數同幾個參數嘅分別，亦係你好少要寫 wrapper function 嘅原因。"
        ),
      },
      {
        topic = "HANDLE",
        q = L(
          "apply_async returned a handle. Which method waits for the value?",
          "apply_async가 핸들을 돌려줬다. 값을 기다리는 메서드는?",
          "apply_async 回咗個 handle。邊個 method 等個值？"
        ),
        code = L(
          [[
with mp.Pool(8) as pool:
    r = pool.apply_async(total, (rows,))
    do_other_work()
    print(r.___(timeout=60))
]],
          [[
with mp.Pool(8) as pool:
    r = pool.apply_async(total, (rows,))
    do_other_work()
    print(r.___(timeout=60))
]],
          [[
with mp.Pool(8) as pool:
    r = pool.apply_async(total, (rows,))
    do_other_work()
    print(r.___(timeout=60))
]]
        ),
        accept = { "get" },
        answer = "get",
        hint = L(
          "Three letters. This is Python's await: the work started at apply_async.",
          "세 글자. 이것이 Python의 await다. 일은 apply_async에서 이미 시작됐다.",
          "三個字母。呢個就係 Python 嘅 await：工作喺 apply_async 嗰陣已經開始。"
        ),
        ok = L(
          "AsyncResult.get() blocks and re-raises whatever the worker raised. apply_async plus get is exactly go plus <-ch.",
          "AsyncResult.get()은 막히고, 워커가 던진 예외를 다시 던진다. apply_async와 get은 go와 <-ch 그 자체다.",
          "AsyncResult.get() 會等，仲會將 worker 掟出嘅 exception 再掟一次。apply_async 加 get，就係 go 加 <-ch。"
        ),
      },
      {
        topic = "CHUNK",
        q = L(
          "The jobs are tiny and the pool is slower than one core. Which argument fixes it?",
          "작업이 잘아 풀이 코어 하나보다 느리다. 어떤 인자가 고치나?",
          "啲工作太細，個 pool 慢過一個核。改邊個參數？"
        ),
        code = L(
          [[
# 1,000,000 rows, 2 microseconds each
with mp.Pool(8) as pool:
    pool.map(clean, rows, ___=5000)
]],
          [[
# 100만 행, 각 2마이크로초
with mp.Pool(8) as pool:
    pool.map(clean, rows, ___=5000)
]],
          [[
# 一百萬行，每行 2 微秒
with mp.Pool(8) as pool:
    pool.map(clean, rows, ___=5000)
]]
        ),
        accept = { "chunksize" },
        answer = "chunksize",
        hint = L(
          "How big a batch each worker collects per trip. One word, no underscore.",
          "워커가 한 번에 가져가는 묶음의 크기. 한 단어, 밑줄 없음.",
          "每個 worker 一轉攞幾大批。一個字，冇底線。"
        ),
        ok = L(
          "Every item sent to a worker is pickled and shipped down a pipe. Below a few microseconds of work per item, the shipping is the program.",
          "워커로 가는 항목마다 pickle되어 파이프를 탄다. 항목당 작업이 몇 마이크로초 미만이면 운반이 곧 프로그램이다.",
          "每件送去 worker 嘅嘢都要 pickle 再經 pipe 運過去。每件工作唔夠幾微秒嘅話，運輸就係成個程式。"
        ),
      },
    },
  },
  {
    id = "py_ipc",
    station = "QUEUE",
    name = L("The dumbwaiter", "음식용 승강기", "運餐升降機"),
    title = L("Queues, pipes and pickle", "큐, 파이프, pickle", "Queue、Pipe 同 pickle"),
    lesson = L(
      "Processes share nothing, so everything travels: a multiprocessing.Queue is a pipe plus a feeder thread plus pickle at both ends. put and get carry any picklable object; a Pipe is the raw two-ended version. Workers stop on a sentinel, usually None, and a JoinableQueue lets the parent wait with task_done and join.",
      "프로세스는 아무것도 공유하지 않으므로 모든 것이 이동한다. multiprocessing.Queue는 파이프와 공급 스레드, 그리고 양끝의 pickle이다. put과 get은 pickle 가능한 객체를 나르고, Pipe는 양끝이 그대로 드러난 버전이다. 워커는 보통 None인 센티널에서 멈추고, JoinableQueue는 task_done과 join으로 부모가 기다리게 해 준다.",
      "process 之間乜都唔共享，所以樣樣都要運：multiprocessing.Queue 係一條 pipe 加一條餵料 thread 加兩頭嘅 pickle。put 同 get 運得走任何 picklable 嘅 object；Pipe 就係原始嘅兩頭版本。worker 見到 sentinel（通常係 None）就停，JoinableQueue 就俾 parent 用 task_done 同 join 等齊。"
    ),
    bg = "bg_market",
    portrait = "portrait_clerk",
    speaker = L("Siu Ming", "시우밍", "小明"),
    ground = 348,
    spawn = 150,
    width = 1600,
    npcs = {
      {
        kind = "clerk",
        x = 560,
        facing = -1,
        line = L(
          "The worker appended to my list and my list stayed empty. Every single time.",
          "워커가 내 리스트에 append했는데 리스트는 계속 비어 있어. 매번 그래.",
          "個 worker append 咗落我個 list，我個 list 一直都係空。次次都係。"
        ),
      },
      {
        kind = "hero",
        x = 900,
        facing = -1,
        line = L(
          "It appended to its own copy. Nothing crosses a process boundary unless you send it.",
          "자기 사본에 append한 거야. 보내지 않으면 프로세스 경계를 넘는 건 없어.",
          "佢係 append 咗落自己嗰個複本。你唔送過去，冇嘢過得到 process 界線。"
        ),
      },
    },
    viz = "python",
    chips = {
      { "q = mp.Queue()", "cyan" },
      { "q.put(order)", "gold" },
      { "parent, child = Pipe()", "pink" },
      { "q.put(None)  # stop", "green" },
    },
    note = "Queue  get  None  Pipe  picklable  task_done",
    story = L(
      "02:45. The receipts worker fills a list and the parent prints nothing, over and over. There "
        .. "is no bug: the child got a copy of the list at start-up and has been filling that. "
        .. "Between processes there is only the dumbwaiter, and everything on it is pickled.",
      "02:45. 영수증 워커는 리스트를 채우는데 부모는 아무것도 못 찍는다. 몇 번을 해도 같다. "
        .. "버그가 아니다. 자식은 시작할 때 리스트의 사본을 받아 그걸 채워 왔다. 프로세스 사이엔 "
        .. "승강기밖에 없고, 거기 실리는 것은 모두 pickle된다.",
      "02:45. 單據 worker 填住個 list，parent 咩都印唔到，試極都係。唔係 bug："
        .. "個仔開機嗰陣攞咗個 list 嘅複本，一直填緊嗰個。process 之間得部運餐機，"
        .. "上面嘅嘢全部都 pickle 過。"
    ),
    stages = {
      {
        topic = "QUEUE",
        q = L(
          "Send results back to the parent. Which multiprocessing class?",
          "결과를 부모에게 보낸다. 어떤 multiprocessing 클래스?",
          "將結果送返俾 parent。用邊個 multiprocessing class？"
        ),
        code = L(
          [[
import multiprocessing as mp

q = mp.___()
mp.Process(target=worker, args=(q,)).start()
]],
          [[
import multiprocessing as mp

q = mp.___()
mp.Process(target=worker, args=(q,)).start()
]],
          [[
import multiprocessing as mp

q = mp.___()
mp.Process(target=worker, args=(q,)).start()
]]
        ),
        accept = { "Queue" },
        answer = "Queue",
        hint = L(
          "Five letters, the shape of a line at a counter. Go spells it chan.",
          "다섯 글자, 카운터 앞 줄의 모양. Go에선 chan.",
          "五個字母，櫃檯前面排隊嗰個形狀。Go 叫佢做 chan。"
        ),
        ok = L(
          "mp.Queue is safe for many producers and many consumers. It must be created in the parent and passed in as an argument, never made inside the child.",
          "mp.Queue는 생산자와 소비자가 여럿이어도 안전하다. 부모에서 만들어 인자로 넘겨야지, 자식 안에서 만들면 안 된다.",
          "mp.Queue 俾好多生產者同消費者用都安全。要喺 parent 度整，再做參數傳入去，唔好喺個仔入面整。"
        ),
      },
      {
        topic = "TAKE",
        q = L(
          "Take the next result, waiting if the queue is empty. Which method?",
          "다음 결과를 꺼낸다. 비었으면 기다린다. 어떤 메서드?",
          "攞下一個結果，空咗就等。用邊個 method？"
        ),
        code = L(
          [[
while True:
    item = q.___()
    if item is None:
        break
    save(item)
]],
          [[
while True:
    item = q.___()
    if item is None:
        break
    save(item)
]],
          [[
while True:
    item = q.___()
    if item is None:
        break
    save(item)
]]
        ),
        accept = { "get" },
        answer = "get",
        hint = L(
          "Three letters, the partner of put. Pass timeout= if you would rather not wait for ever.",
          "세 글자, put의 짝. 영원히 기다리기 싫으면 timeout=을 넘겨라.",
          "三個字母，put 嘅拍檔。唔想等到天荒地老就俾個 timeout=。"
        ),
        ok = L(
          "q.get() blocks like <-ch in Go. get_nowait() raises queue.Empty instead, which is the select default case.",
          "q.get()은 Go의 <-ch처럼 막힌다. get_nowait()은 대신 queue.Empty를 던지며, 그것이 select의 default에 해당한다.",
          "q.get() 好似 Go 嘅 <-ch 噉會等。get_nowait() 就會掟 queue.Empty，即係 select 嘅 default case。"
        ),
      },
      {
        topic = "SENTINEL",
        q = L(
          "A Queue has no close(). What do you put on it to tell the workers to stop?",
          "Queue엔 close()가 없다. 워커에게 멈추라고 무엇을 넣나?",
          "Queue 冇 close()。你放咩落去話俾 worker 知要停？"
        ),
        code = L(
          [[
for _ in range(8):
    q.put(___)
for p in workers:
    p.join()
]],
          [[
for _ in range(8):
    q.put(___)
for p in workers:
    p.join()
]],
          [[
for _ in range(8):
    q.put(___)
for p in workers:
    p.join()
]]
        ),
        accept = { "None" },
        answer = "None",
        hint = L(
          "Python's nothing, capitalised. One per worker, because each one eats exactly one.",
          "파이썬의 없음, 대문자. 워커마다 하나씩. 각자 정확히 하나를 먹으니까.",
          "Python 嘅「冇嘢」，大楷。每個 worker 一個，因為佢哋一人食一個。"
        ),
        ok = L(
          "The sentinel is the poison pill. Go closes the channel once and every receiver wakes; Python has to send one pill per worker.",
          "센티널은 독약이다. Go는 채널을 한 번 닫으면 모두가 깨어나지만, Python은 워커마다 하나씩 보내야 한다.",
          "sentinel 就係毒藥丸。Go 閂一次 channel 大家就醒晒；Python 就要每個 worker 派一粒。"
        ),
      },
      {
        topic = "PIPE",
        q = L(
          "Two processes, one conversation, no queue machinery. Which function?",
          "프로세스 둘, 대화 하나, 큐 장치는 없이. 어떤 함수?",
          "兩個 process、一段對話、唔要成套 queue。用邊個 function？"
        ),
        code = L(
          [[
parent_conn, child_conn = mp.___()
mp.Process(target=cook, args=(child_conn,)).start()
print(parent_conn.recv())
]],
          [[
parent_conn, child_conn = mp.___()
mp.Process(target=cook, args=(child_conn,)).start()
print(parent_conn.recv())
]],
          [[
parent_conn, child_conn = mp.___()
mp.Process(target=cook, args=(child_conn,)).start()
print(parent_conn.recv())
]]
        ),
        accept = { "Pipe" },
        answer = "Pipe",
        hint = L(
          "Four letters, what a shell puts between two commands. It returns two ends.",
          "네 글자, 셸이 두 명령 사이에 두는 그것. 양쪽 끝을 돌려준다.",
          "四個字母，shell 擺喺兩個指令中間嗰樣嘢。佢回兩頭。"
        ),
        ok = L(
          "Pipe() gives two Connection objects with send and recv. It is faster than a Queue and safe for exactly two processes.",
          "Pipe()는 send와 recv를 가진 Connection 두 개를 준다. Queue보다 빠르고 정확히 두 프로세스에서 안전하다.",
          "Pipe() 俾兩個有 send 同 recv 嘅 Connection。快過 Queue，但淨係啱兩個 process。"
        ),
      },
      {
        topic = "PICKLE",
        q = L(
          "One put crashes with TypeError. What must everything on the queue be?",
          "put 하나가 TypeError로 죽는다. 큐에 실리는 것은 모두 어떠해야 하나?",
          "有個 put 掟 TypeError。放上 queue 嘅嘢一定要係點？"
        ),
        code = L(
          [[
q.put(Order(7, "set"))
q.put(open("menu.txt"))
# TypeError: the file object is not ___
]],
          [[
q.put(Order(7, "set"))
q.put(open("menu.txt"))
# TypeError: 파일 객체는 ___ 하지 않다
]],
          [[
q.put(Order(7, "set"))
q.put(open("menu.txt"))
# TypeError：file object 唔係 ___
]]
        ),
        accept = { "picklable", "pickleable" },
        answer = "picklable",
        hint = L(
          "Able to be turned into bytes by the pickle module. The adjective.",
          "pickle 모듈이 바이트로 바꿀 수 있는. 형용사형.",
          "可以俾 pickle module 變成 bytes。形容詞。"
        ),
        ok = L(
          "Sockets, file handles, locks and lambdas do not travel. Send plain data and let the child open what it needs on its own side.",
          "소켓, 파일 핸들, 락, 람다는 이동하지 않는다. 순수한 데이터를 보내고 필요한 것은 자식이 자기 쪽에서 열게 하라.",
          "socket、file handle、鎖同 lambda 都運唔到。送純數據過去，要開嘅嘢就等個仔喺自己嗰邊開。"
        ),
      },
      {
        topic = "ACK",
        q = L(
          "With a JoinableQueue the parent waits for the work, not the workers. Which call acknowledges one item?",
          "JoinableQueue에선 부모가 워커가 아니라 일을 기다린다. 항목 하나를 확인해 주는 호출은?",
          "用 JoinableQueue，parent 等嘅係啲工作，唔係啲 worker。邊個 call 認咗一件嘢做完？"
        ),
        code = L(
          [[
while True:
    item = q.get()
    save(item)
    q.___()
# parent: q.join() returns at zero
]],
          [[
while True:
    item = q.get()
    save(item)
    q.___()
# 부모: q.join()은 0이 되면 돌아온다
]],
          [[
while True:
    item = q.get()
    save(item)
    q.___()
# parent：q.join() 到零就返嚟
]]
        ),
        accept = { "task_done" },
        answer = "task_done",
        hint = L(
          "Two words with an underscore: the unit of work, then the past tense of finish.",
          "밑줄로 이은 두 단어: 일의 단위, 그리고 끝났다는 말.",
          "兩個字用底線連埋：工作嘅單位，加上「做完」。"
        ),
        ok = L(
          "Every get needs one task_done, or q.join() waits for ever. It is the WaitGroup of the queue world.",
          "get마다 task_done 하나가 필요하다. 없으면 q.join()은 영원히 기다린다. 큐 세계의 WaitGroup이다.",
          "每個 get 都要一個 task_done，否則 q.join() 會等到永遠。佢就係 queue 世界嘅 WaitGroup。"
        ),
      },
    },
  },
  {
    id = "py_lock",
    station = "LOCK",
    name = L("One printer, eight cooks", "프린터 하나, 요리사 여덟", "一部打印機，八個廚"),
    title = L("Locks, Value and Manager", "락, Value, Manager", "鎖、Value 同 Manager"),
    lesson = L(
      "Even with separate memory, processes still share the machine: one printer, one log file, one counter in shared memory. multiprocessing.Lock is the mutex across processes, used as a with block. Value and Array put a number in shared memory and hand you get_lock() for it, and a Manager serves ordinary dicts and lists over a proxy.",
      "메모리가 따로여도 프로세스는 기계를 공유한다. 프린터 하나, 로그 파일 하나, 공유 메모리의 카운터 하나. multiprocessing.Lock은 프로세스 간 뮤텍스이며 with 블록으로 쓴다. Value와 Array는 숫자를 공유 메모리에 두고 get_lock()을 주며, Manager는 평범한 dict와 list를 프록시로 제공한다.",
      "就算記憶體分開，process 之間都仲共享住部機：一部打印機、一個 log 檔、一個喺共享記憶體嘅計數。multiprocessing.Lock 就係跨 process 嘅 mutex，用 with block 嚟用。Value 同 Array 將個數放喺共享記憶體，仲俾埋 get_lock() 你，而 Manager 就用 proxy 提供普通嘅 dict 同 list。"
    ),
    bg = "bg_kitchen",
    portrait = "portrait_officer",
    speaker = L("Chef Bo", "보 셰프", "寶廚"),
    ground = 348,
    spawn = 170,
    width = 1600,
    npcs = {
      {
        kind = "cook",
        x = 540,
        facing = -1,
        line = L(
          "Eight workers, one label printer. The labels came out with two orders on one sticker.",
          "워커 여덟에 라벨 프린터 하나. 스티커 한 장에 주문 둘이 찍혀 나왔어.",
          "八個 worker，一部標籤機。有張貼紙印咗兩張單落去。"
        ),
      },
      {
        kind = "mei",
        x = 920,
        facing = -1,
        line = L(
          "Same lesson as the Go till, one floor up: the resource is shared even when the memory is not.",
          "Go 계산대와 같은 교훈이야, 한 층 위에서. 메모리는 안 나눠도 자원은 공유돼.",
          "同樓上 Go 收銀嗰課一樣：就算記憶體唔共享，資源都係共享。"
        ),
      },
    },
    viz = "python",
    chips = {
      { "lock = mp.Lock()", "cyan" },
      { "with lock:", "gold" },
      { "counter.value += 1", "pink" },
      { "with mp.Manager() as m", "green" },
    },
    note = "Lock  release  Value  get_lock  Manager",
    story = L(
      "03:00. Eight workers, one label printer, and a sticker with two orders printed on top of each "
        .. "other. Separate memory did not make the printer separate. What crosses process lines now "
        .. "is not data but permission: who may write, and when.",
      "03:00. 워커 여덟, 라벨 프린터 하나, 그리고 주문 둘이 겹쳐 찍힌 스티커 한 장. 메모리를 나눴다고 "
        .. "프린터가 나뉘지는 않는다. 이제 프로세스 경계를 넘는 것은 데이터가 아니라 허가다. 누가, 언제 쓸 수 있는가.",
      "03:00. 八個 worker、一部標籤機，同一張印咗兩張單疊埋一齊嘅貼紙。記憶體分開，唔代表部機分開。"
        .. "而家過 process 界線嘅唔係數據，係批准：邊個可以寫，幾時寫。"
    ),
    stages = {
      {
        topic = "MUTEX",
        q = L(
          "One writer at the printer. Which multiprocessing primitive?",
          "프린터 앞엔 한 명만. 어떤 multiprocessing 기본 요소?",
          "打印機前面一次得一個。用邊個 multiprocessing primitive？"
        ),
        code = L(
          [[
import multiprocessing as mp

printer = mp.___()
mp.Process(target=label, args=(printer,)).start()
]],
          [[
import multiprocessing as mp

printer = mp.___()
mp.Process(target=label, args=(printer,)).start()
]],
          [[
import multiprocessing as mp

printer = mp.___()
mp.Process(target=label, args=(printer,)).start()
]]
        ),
        accept = { "Lock" },
        answer = "Lock",
        hint = L(
          "Four letters, capitalised. The same name threading uses, and Go calls it sync.Mutex.",
          "네 글자, 대문자. threading이 쓰는 이름 그대로이고, Go에선 sync.Mutex.",
          "四個字母，大楷。同 threading 用嘅名一樣，Go 就叫 sync.Mutex。"
        ),
        ok = L(
          "It is an operating-system semaphore under the hood, so it works across processes. Like a Queue, it must be created in the parent and passed down.",
          "속은 운영체제 세마포어라 프로세스를 넘어 동작한다. Queue처럼 부모에서 만들어 내려보내야 한다.",
          "底層係作業系統嘅 semaphore，所以跨 process 都用得。同 Queue 一樣，要喺 parent 度整再傳落去。"
        ),
      },
      {
        topic = "FREE",
        q = L(
          "Without a with block, what must always follow acquire()?",
          "with 블록 없이 쓴다면 acquire() 뒤엔 언제나 무엇이 와야 하나?",
          "唔用 with block 嘅話，acquire() 之後一定要跟住咩？"
        ),
        code = L(
          [[
printer.acquire()
try:
    print_label(order)
finally:
    printer.___()
]],
          [[
printer.acquire()
try:
    print_label(order)
finally:
    printer.___()
]],
          [[
printer.acquire()
try:
    print_label(order)
finally:
    printer.___()
]]
        ),
        accept = { "release" },
        answer = "release",
        hint = L(
          "Seven letters, the opposite of acquire. Go writes it defer mu.Unlock().",
          "일곱 글자, acquire의 반대. Go에선 defer mu.Unlock().",
          "七個字母，acquire 嘅相反。Go 寫做 defer mu.Unlock()。"
        ),
        ok = L(
          "with lock: is the same thing with the finally written for you, which is why nobody writes acquire by hand any more.",
          "with lock: 이 finally를 대신 써 준다. 그래서 아무도 acquire를 손으로 쓰지 않는다.",
          "with lock: 就係幫你寫埋個 finally，所以冇人再自己手寫 acquire。"
        ),
      },
      {
        topic = "VALUE",
        q = L(
          "A counter every process can see. Which attribute reads and writes the shared number?",
          "모든 프로세스가 보는 카운터. 공유된 숫자를 읽고 쓰는 속성은?",
          "一個所有 process 都見到嘅計數。邊個 attribute 讀寫嗰個共享數字？"
        ),
        code = L(
          [[
done = mp.Value("i", 0)

with done.get_lock():
    done.___ += 1
]],
          [[
done = mp.Value("i", 0)

with done.get_lock():
    done.___ += 1
]],
          [[
done = mp.Value("i", 0)

with done.get_lock():
    done.___ += 1
]]
        ),
        accept = { "value" },
        answer = "value",
        hint = L(
          "Five letters, lower case: the box has one, and this is how you open it.",
          "다섯 글자, 소문자. 상자 안에 하나 들어 있고, 이것이 여는 방법.",
          "五個字母，細楷：個盒入面有一個，呢個就係打開佢嘅方法。"
        ),
        ok = L(
          "mp.Value('i', 0) is four bytes of shared memory with a type code. The object is shared; the number inside it is what you touch.",
          "mp.Value('i', 0)은 타입 코드가 붙은 4바이트 공유 메모리다. 객체가 공유되고, 만지는 것은 그 안의 숫자다.",
          "mp.Value('i', 0) 係四個 byte 嘅共享記憶體加個 type code。共享嘅係個 object，你掂嘅係入面嗰個數。"
        ),
      },
      {
        topic = "GETLOCK",
        q = L(
          "value += 1 is not atomic across processes either. Which method hands you its own lock?",
          "value += 1도 프로세스 사이에선 원자적이지 않다. 자기 락을 주는 메서드는?",
          "value += 1 跨 process 都唔係原子。邊個 method 俾返自己把鎖你？"
        ),
        code = L(
          [[
done = mp.Value("i", 0)

with done.___():
    done.value += 1
]],
          [[
done = mp.Value("i", 0)

with done.___():
    done.value += 1
]],
          [[
done = mp.Value("i", 0)

with done.___():
    done.value += 1
]]
        ),
        accept = { "get_lock" },
        answer = "get_lock",
        hint = L(
          "Three letters, an underscore, and the four-letter word for a mutex.",
          "세 글자, 밑줄, 그리고 뮤텍스를 뜻하는 네 글자.",
          "三個字母、底線，再加代表 mutex 嗰四個字母。"
        ),
        ok = L(
          "Value ships with a lock so you do not invent one. Read, add, write is three steps here exactly as it was in Go.",
          "Value엔 락이 딸려 있어 따로 만들 필요가 없다. 읽고, 더하고, 쓰는 세 단계인 것은 Go와 똑같다.",
          "Value 本身就配咗把鎖，唔使你再整。讀、加、寫三步，同 Go 果邊一模一樣。"
        ),
      },
      {
        topic = "MANAGER",
        q = L(
          "The workers want a real dict everyone can see. Which class serves one over a proxy?",
          "워커들이 모두가 보는 진짜 dict를 원한다. 프록시로 제공하는 클래스는?",
          "啲 worker 想要個大家都見到嘅真 dict。邊個 class 用 proxy 提供？"
        ),
        code = L(
          [[
with mp.___() as m:
    totals = m.dict()
    pool.map(add_to, [(totals, r) for r in rows])
    print(dict(totals))
]],
          [[
with mp.___() as m:
    totals = m.dict()
    pool.map(add_to, [(totals, r) for r in rows])
    print(dict(totals))
]],
          [[
with mp.___() as m:
    totals = m.dict()
    pool.map(add_to, [(totals, r) for r in rows])
    print(dict(totals))
]]
        ),
        accept = { "Manager" },
        answer = "Manager",
        hint = L(
          "Seven letters: a whole server process that owns the objects and answers questions about them.",
          "일곱 글자. 객체를 소유하고 질문에 답하는 별도의 서버 프로세스.",
          "七個字母：一個專門揸住啲 object、負責答問題嘅 server process。"
        ),
        ok = L(
          "A Manager is convenience, not speed: every read and write is a round trip to another process. Fine for results, wrong for a hot loop.",
          "Manager는 편의이지 속도가 아니다. 읽기와 쓰기마다 다른 프로세스로 왕복한다. 결과엔 좋고 뜨거운 루프엔 나쁘다.",
          "Manager 係方便，唔係快：每次讀寫都要去另一個 process 行一轉。放結果就啱，放喺熱 loop 就錯。"
        ),
      },
      {
        topic = "LIMIT",
        q = L(
          "Only three workers may hit the payments API at once. Which primitive counts?",
          "결제 API는 동시에 워커 셋까지만. 세는 기본 요소는?",
          "同一時間淨係三個 worker 可以撳付款 API。用邊個識數嘅 primitive？"
        ),
        code = L(
          [[
gate = mp.___(3)

with gate:
    charge(order)
]],
          [[
gate = mp.___(3)

with gate:
    charge(order)
]],
          [[
gate = mp.___(3)

with gate:
    charge(order)
]]
        ),
        accept = { "Semaphore", "BoundedSemaphore" },
        answer = "Semaphore",
        hint = L(
          "Nine letters, a railway signal. Go builds the same thing from a buffered channel.",
          "아홉 글자, 철도 신호기. Go는 같은 것을 버퍼 채널로 만든다.",
          "九個字母，鐵路信號機。Go 就用有 buffer 嘅 channel 整同一樣嘢。"
        ),
        ok = L(
          "A Semaphore is a lock that lets n holders through. mp also has Event, Condition and Barrier, all with the threading names.",
          "Semaphore는 n명까지 통과시키는 락이다. mp에는 Event, Condition, Barrier도 threading과 같은 이름으로 있다.",
          "Semaphore 就係俾 n 個人入嘅鎖。mp 仲有 Event、Condition、Barrier，名同 threading 一樣。"
        ),
      },
    },
  },
  {
    id = "py_shm",
    station = "SHARED",
    name = L("The cold room", "냉장고", "冷藏房"),
    title = L("shared_memory: no copy at all", "shared_memory: 복사 없음", "shared_memory：完全唔使複製"),
    lesson = L(
      "Copies are the tax of multiprocessing: a global changed in a child stays in the child. multiprocessing.shared_memory.SharedMemory gives every process the same block of bytes, found by name and read through .buf, which NumPy can wrap without copying. You close() your view and unlink() the block exactly once, or it outlives the program.",
      "복사는 multiprocessing의 세금이다. 자식에서 바꾼 전역은 자식에 남는다. multiprocessing.shared_memory.SharedMemory는 모든 프로세스에 같은 바이트 블록을 주며, 이름으로 찾고 .buf로 읽는다. NumPy는 그것을 복사 없이 감쌀 수 있다. 뷰는 close()하고 블록은 정확히 한 번 unlink()해야 하며, 아니면 프로그램보다 오래 남는다.",
      "複製就係 multiprocessing 嘅稅：喺個仔度改咗個 global，就淨係留喺個仔度。multiprocessing.shared_memory.SharedMemory 俾每個 process 同一嚿 bytes，用名搵，用 .buf 讀，NumPy 仲可以唔複製噉包住佢。你要 close() 自己個 view，再 unlink() 嗰嚿記憶體一次，唔係佢會生存得耐過你個程式。"
    ),
    bg = "bg_flat",
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
          "Your workers each pickled two gigabytes of the same table. That is the whole runtime, right there.",
          "워커마다 같은 표 2기가바이트를 pickle했어. 실행 시간의 전부가 거기 있어.",
          "你每個 worker 都 pickle 咗同一張兩 GB 嘅表。成個執行時間就係喺度。"
        ),
      },
      {
        kind = "hero",
        x = 940,
        facing = -1,
        line = L(
          "So share the bytes and send only the name of the block?",
          "그럼 바이트를 공유하고 블록 이름만 보내면 되는 거야?",
          "咁即係共享啲 bytes，淨係送個名過去？"
        ),
      },
    },
    viz = "python",
    chips = {
      { "SharedMemory(size=1<<20)", "cyan" },
      { "shm.name", "gold" },
      { "np.ndarray(buffer=buf)", "pink" },
      { "shm.close(); unlink()", "green" },
    },
    note = "copy  SharedMemory  name  buf  Array  unlink",
    story = L(
      "03:20. The month's receipts are two gigabytes and every worker got its own pickled copy of "
        .. "them: eight copies, eight seconds of pickling, one machine on its knees. The cold room "
        .. "is the answer. One block of bytes, everybody walks in, nobody carries it.",
      "03:20. 한 달 치 영수증은 2기가바이트인데 워커마다 pickle된 사본을 하나씩 받았다. 사본 여덟, "
        .. "pickle에만 8초, 기계는 주저앉는다. 답은 냉장고다. 바이트 블록 하나에 모두가 들어가고, "
        .. "아무도 그것을 들고 다니지 않는다.",
      "03:20. 一個月嘅單據有兩 GB，而每個 worker 都攞咗自己一份 pickle 複本：八份、八秒 pickle、"
        .. "部機跪低。答案就係個冷藏房：一嚿 bytes，人人行入去，冇人搬。"
    ),
    stages = {
      {
        topic = "COPY",
        q = L(
          "The child adds to a global and the parent still prints 0. What did the child change?",
          "자식이 전역에 더했는데 부모는 여전히 0을 찍는다. 자식이 바꾼 것은?",
          "個仔加咗落個 global，parent 仲係印 0。個仔改咗啲咩？"
        ),
        code = L(
          [[
total = 0

def add(rows):
    global total
    total += sum(rows)
# the child changed its own ___ of total
]],
          [[
total = 0

def add(rows):
    global total
    total += sum(rows)
# 자식은 total의 자기 ___만 바꿨다
]],
          [[
total = 0

def add(rows):
    global total
    total += sum(rows)
# 個仔淨係改咗自己嗰個 total 嘅 ___
]]
        ),
        accept = { "copy" },
        answer = "copy",
        hint = L(
          "Four letters. fork gives one lazily, spawn makes one from the pickle. Either way it is not yours.",
          "네 글자. fork는 게으르게 주고, spawn은 pickle에서 만든다. 어느 쪽이든 네 것이 아니다.",
          "四個字母。fork 係 lazy 噉俾你一個，spawn 就由 pickle 整一個。點都好，都唔係你嗰個。"
        ),
        ok = L(
          "This is the trap every threading programmer walks into once. Processes share nothing implicitly: results come back through a Queue, a return value, or shared memory.",
          "스레딩을 하던 사람이라면 누구나 한 번은 빠지는 함정이다. 프로세스는 암묵적으로 아무것도 공유하지 않는다. 결과는 Queue, 반환값, 공유 메모리로 돌아온다.",
          "呢個係每個寫開 thread 嘅人都會中一次嘅陷阱。process 之間唔會暗中共享任何嘢：結果要靠 Queue、回傳值或者共享記憶體攞返。"
        ),
      },
      {
        topic = "BLOCK",
        q = L(
          "One megabyte every process can map. Which class from multiprocessing.shared_memory?",
          "모든 프로세스가 매핑할 수 있는 1메가바이트. multiprocessing.shared_memory의 어떤 클래스?",
          "一 MB，每個 process 都 map 得到。multiprocessing.shared_memory 邊個 class？"
        ),
        code = L(
          [[
from multiprocessing import shared_memory

shm = shared_memory.___(create=True, size=1 << 20)
]],
          [[
from multiprocessing import shared_memory

shm = shared_memory.___(create=True, size=1 << 20)
]],
          [[
from multiprocessing import shared_memory

shm = shared_memory.___(create=True, size=1 << 20)
]]
        ),
        accept = { "SharedMemory" },
        answer = "SharedMemory",
        hint = L(
          "The module's own name in CamelCase, the two words joined.",
          "모듈 이름을 카멜케이스로, 두 단어를 붙인 것.",
          "個 module 自己個名，用 CamelCase，兩個字砌埋。"
        ),
        ok = L(
          "Since Python 3.8 this is real POSIX shared memory: one block of bytes, mapped into every process that asks for it by name.",
          "Python 3.8부터의 진짜 POSIX 공유 메모리다. 바이트 블록 하나가 이름으로 요청하는 모든 프로세스에 매핑된다.",
          "由 Python 3.8 開始，呢個係真正嘅 POSIX 共享記憶體：一嚿 bytes，邊個用個名嚟攞就 map 落邊個 process。"
        ),
      },
      {
        topic = "FIND",
        q = L(
          "The worker has to attach to the same block. Which attribute do you send it?",
          "워커가 같은 블록에 붙어야 한다. 무엇을 보내나?",
          "個 worker 要接返同一嚿記憶體。你送咩過去？"
        ),
        code = L(
          [[
pool.map(scan, [(shm.___, i) for i in parts])

# inside the worker:
# SharedMemory(key) attaches here
]],
          [[
pool.map(scan, [(shm.___, i) for i in parts])

# 워커 안에서:
# SharedMemory(key) attaches here
]],
          [[
pool.map(scan, [(shm.___, i) for i in parts])

# 喺 worker 入面：
# SharedMemory(key) attaches here
]]
        ),
        accept = { "name" },
        answer = "name",
        hint = L(
          "Four letters. The block gets one from the operating system, like a file in /dev/shm.",
          "네 글자. 운영체제가 붙여 주는 것으로, /dev/shm의 파일 이름 같은 것.",
          "四個字母。作業系統派俾佢，好似 /dev/shm 入面個檔案名噉。"
        ),
        ok = L(
          "The name is a short string, so the argument you pickle is tiny no matter how large the block is. That is the whole trick.",
          "이름은 짧은 문자열이라, 블록이 아무리 커도 pickle하는 인자는 아주 작다. 그것이 요령의 전부다.",
          "個名係一串短字串，所以嗰嚿嘢幾大都好，你 pickle 嘅參數都係好細。個秘訣就係咁。"
        ),
      },
      {
        topic = "VIEW",
        q = L(
          "Wrap the bytes as an array without copying them. Which attribute is the memoryview?",
          "복사 없이 바이트를 배열로 감싼다. memoryview인 속성은?",
          "唔複製噉將啲 bytes 包成 array。邊個 attribute 係 memoryview？"
        ),
        code = L(
          [[
import numpy as np

arr = np.ndarray((1024,), "f8", shm.___)
arr[0] = 42.0
]],
          [[
import numpy as np

arr = np.ndarray((1024,), "f8", shm.___)
arr[0] = 42.0
]],
          [[
import numpy as np

arr = np.ndarray((1024,), "f8", shm.___)
arr[0] = 42.0
]]
        ),
        accept = { "buf" },
        answer = "buf",
        hint = L(
          "Three letters, short for buffer.",
          "세 글자, buffer의 줄임말.",
          "三個字母，buffer 嘅縮寫。"
        ),
        ok = L(
          "arr writes straight into the shared block, so every process sees the change with no send at all. This is how big NumPy jobs go parallel.",
          "arr는 공유 블록에 곧바로 쓴다. 보내는 것 없이 모든 프로세스가 변화를 본다. 큰 NumPy 작업이 병렬로 가는 방법이다.",
          "arr 直接寫入嗰嚿共享記憶體，唔使送任何嘢，每個 process 都見到。大型 NumPy 工作就係咁並行。"
        ),
      },
      {
        topic = "TYPED",
        q = L(
          "Eight shared doubles with a lock and no NumPy. Which multiprocessing class?",
          "락이 딸린 공유 double 여덟 개, NumPy 없이. 어떤 multiprocessing 클래스?",
          "八個有鎖嘅共享 double，唔用 NumPy。用邊個 multiprocessing class？"
        ),
        code = L(
          [[
import multiprocessing as mp

sums = mp.___("d", 8)
sums[3] = 12.5
]],
          [[
import multiprocessing as mp

sums = mp.___("d", 8)
sums[3] = 12.5
]],
          [[
import multiprocessing as mp

sums = mp.___("d", 8)
sums[3] = 12.5
]]
        ),
        accept = { "Array" },
        answer = "Array",
        hint = L(
          "Five letters, capitalised: what Value is, but with a length.",
          "다섯 글자, 대문자. Value에 길이를 더한 것.",
          "五個字母，大楷：即係 Value，但有長度。"
        ),
        ok = L(
          "Value and Array are the small end of shared memory: a type code, a size, and a lock in the box. SharedMemory is the large end.",
          "Value와 Array는 공유 메모리의 작은 쪽이다. 타입 코드, 크기, 그리고 상자 안의 락. SharedMemory는 큰 쪽이다.",
          "Value 同 Array 係共享記憶體嘅細嗰邊：一個 type code、一個大細，同盒入面把鎖。SharedMemory 就係大嗰邊。"
        ),
      },
      {
        topic = "FREEMEM",
        q = L(
          "Every process closes its view. Which call, made once, frees the block itself?",
          "프로세스마다 뷰를 닫는다. 블록 자체를 해제하는, 한 번만 하는 호출은?",
          "每個 process 都閂咗自己個 view。邊個 call 做一次，釋放嗰嚿記憶體本身？"
        ),
        code = L(
          [[
shm.close()

# in the parent only, once:
shm.___()
]],
          [[
shm.close()

# 부모에서만, 한 번:
shm.___()
]],
          [[
shm.close()

# 淨係喺 parent，做一次：
shm.___()
]]
        ),
        accept = { "unlink" },
        answer = "unlink",
        hint = L(
          "Six letters, the same word the C library uses for deleting a file.",
          "여섯 글자, C 라이브러리가 파일을 지울 때 쓰는 그 단어.",
          "六個字母，同 C library 刪檔案嗰個字一樣。"
        ),
        ok = L(
          "close() drops your view, unlink() destroys the block. Skip unlink and the memory is still there after the process ends, with a warning to match.",
          "close()는 뷰를 놓고, unlink()는 블록을 없앤다. unlink를 빠뜨리면 프로세스가 끝난 뒤에도 메모리가 남고 경고가 따라온다.",
          "close() 放低你個 view，unlink() 先真係毀咗嗰嚿嘢。唔 unlink，process 完咗嗰嚿記憶體仲喺度，仲會有段警告。"
        ),
      },
    },
  },
  {
    id = "py_exec",
    station = "FUTURES",
    name = L("Before the morning van", "아침 배송차 전에", "朝早架車嚟之前"),
    title = L("ProcessPoolExecutor and choosing", "ProcessPoolExecutor와 고르기", "ProcessPoolExecutor 同點揀"),
    lesson = L(
      "concurrent.futures is the one API for both: ThreadPoolExecutor for waiting, ProcessPoolExecutor for computing. submit returns a Future whose result() blocks and re-raises; as_completed yields futures as they finish; executor.map keeps the order. asyncio joins in through run_in_executor, so an event loop can hand CPU work to processes without blocking.",
      "concurrent.futures는 둘을 위한 하나의 API다. 기다림엔 ThreadPoolExecutor, 계산엔 ProcessPoolExecutor. submit은 Future를 돌려주고 result()는 막히며 예외를 다시 던진다. as_completed는 끝나는 대로 내주고, executor.map은 순서를 지킨다. asyncio는 run_in_executor로 합류해, 이벤트 루프가 막히지 않고 CPU 작업을 프로세스에 넘긴다.",
      "concurrent.futures 係兩邊共用嘅一套 API：等嘢就 ThreadPoolExecutor，計嘢就 ProcessPoolExecutor。submit 回一個 Future，佢個 result() 會等仲會將 exception 再掟一次；as_completed 邊個做完就俾邊個；executor.map 保持次序。asyncio 就用 run_in_executor 加入，令 event loop 唔使阻塞都可以將 CPU 工作交俾 process。"
    ),
    bg = "bg_mtr",
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
          "Four hundred HTTP calls, and four hundred image resizes. Same code, different executor.",
          "HTTP 호출 400건, 이미지 리사이즈 400건. 같은 코드, 다른 executor.",
          "四百個 HTTP call，四百張相要縮。同一段 code，唔同 executor。"
        ),
      },
      {
        kind = "cook",
        x = 900,
        facing = -1,
        line = L(
          "So I only have to know which one waits and which one computes.",
          "그럼 어느 쪽이 기다리고 어느 쪽이 계산하는지만 알면 되네.",
          "咁我淨係要知邊個係等、邊個係計，就得。"
        ),
      },
    },
    viz = "python",
    chips = {
      { "ProcessPoolExecutor(8)", "cyan" },
      { "fut = ex.submit(f, x)", "gold" },
      { "as_completed(futs)", "pink" },
      { "run_in_executor(ex, f)", "green" },
    },
    note = "Executor  submit  result  as_completed  asyncio",
    story = L(
      "03:50. The van comes at five. What is left is four hundred HTTP calls to the supplier and "
        .. "four hundred images to resize, and Chef Bo wants one way to write both. concurrent.futures "
        .. "is that way: the same six lines, and one word that decides whether it waits or computes.",
      "03:50. 배송차는 다섯 시에 온다. 남은 것은 공급사로 가는 HTTP 호출 400건과 리사이즈할 이미지 400장, "
        .. "그리고 보 셰프는 둘을 한 가지 방법으로 쓰고 싶어 한다. concurrent.futures가 그 방법이다. "
        .. "같은 여섯 줄, 그리고 기다릴지 계산할지를 정하는 단어 하나.",
      "03:50. 架車五點嚟。剩返四百個去供應商嘅 HTTP call 同四百張要縮嘅相，"
        .. "而寶廚想用一種方法寫晒兩樣。concurrent.futures 就係嗰種方法："
        .. "同樣嘅六行，加一個決定佢係等定係計嘅字。"
    ),
    stages = {
      {
        topic = "PICK",
        q = L(
          "Four hundred image resizes, eight cores. Which executor class?",
          "이미지 리사이즈 400건, 코어 여덟. 어떤 executor 클래스?",
          "四百張相要縮，八個核。用邊個 executor class？"
        ),
        code = L(
          [[
from concurrent.futures import ___

with ___(max_workers=8) as ex:
    ex.map(resize, photos)
]],
          [[
from concurrent.futures import ___

with ___(max_workers=8) as ex:
    ex.map(resize, photos)
]],
          [[
from concurrent.futures import ___

with ___(max_workers=8) as ex:
    ex.map(resize, photos)
]]
        ),
        accept = { "ProcessPoolExecutor" },
        answer = "ProcessPoolExecutor",
        hint = L(
          "Three words joined: what the operating system schedules, a pool of them, and the thing that runs your calls.",
          "세 단어를 붙인 것: 운영체제가 스케줄하는 것, 그것들의 풀, 그리고 호출을 실행하는 것.",
          "三個字砌埋：作業系統排程嗰樣嘢、佢哋嘅 pool，加上執行你啲呼叫嗰樣嘢。"
        ),
        ok = L(
          "Swap the first word for Thread and the same block does I/O instead. That is the whole API: one word decides which kind of parallelism you get.",
          "첫 단어를 Thread로 바꾸면 같은 블록이 I/O를 한다. API의 전부다. 단어 하나가 어떤 병렬성인지 정한다.",
          "將第一個字換做 Thread，同一段 code 就變咗做 I/O。成套 API 就係咁：一個字決定你攞到邊種並行。"
        ),
      },
      {
        topic = "SUBMIT",
        q = L(
          "Send one job now and keep the handle. Which method?",
          "지금 작업 하나를 보내고 핸들을 쥔다. 어떤 메서드?",
          "而家送一件工作出去，揸住個 handle。用邊個 method？"
        ),
        code = L(
          [[
with ProcessPoolExecutor(8) as ex:
    fut = ex.___(total, rows)
    log("still free to work")
]],
          [[
with ProcessPoolExecutor(8) as ex:
    fut = ex.___(total, rows)
    log("still free to work")
]],
          [[
with ProcessPoolExecutor(8) as ex:
    fut = ex.___(total, rows)
    log("still free to work")
]]
        ),
        accept = { "submit" },
        answer = "submit",
        hint = L(
          "Six letters, what you do with a form. It returns immediately, with a Future.",
          "여섯 글자, 서류를 낼 때 하는 그것. 즉시 Future를 돌려준다.",
          "六個字母，交表格嗰個動作。佢即刻返，仲俾個 Future 你。"
        ),
        ok = L(
          "submit(f, *args) is go f(args): the call is already running somewhere else and you hold the receipt.",
          "submit(f, *args)는 go f(args)다. 호출은 이미 다른 곳에서 돌고 있고 손엔 영수증이 있다.",
          "submit(f, *args) 就係 go f(args)：個呼叫已經喺第二度行緊，你揸住張收據。"
        ),
      },
      {
        topic = "AWAIT",
        q = L(
          "Now collect the number. Which method of the Future?",
          "이제 숫자를 받는다. Future의 어떤 메서드?",
          "而家收返個數。Future 邊個 method？"
        ),
        code = L(
          [[
fut = ex.submit(total, rows)
print(fut.___(timeout=30))
# raises here if the worker raised
]],
          [[
fut = ex.submit(total, rows)
print(fut.___(timeout=30))
# 워커가 예외를 던졌으면 여기서 다시 난다
]],
          [[
fut = ex.submit(total, rows)
print(fut.___(timeout=30))
# worker 掟過 exception 就喺呢度再掟
]]
        ),
        accept = { "result" },
        answer = "result",
        hint = L(
          "Six letters, the noun for what a function gives back. This one blocks until it exists.",
          "여섯 글자, 함수가 돌려주는 것을 뜻하는 명사. 그것이 생길 때까지 막힌다.",
          "六個字母，指 function 俾返你嗰樣嘢。佢會等到有為止。"
        ),
        ok = L(
          "result() is await, and it re-raises the worker's exception in your process with the child's traceback attached.",
          "result()가 곧 await다. 워커의 예외를 자식의 트레이스백과 함께 내 프로세스에서 다시 던진다.",
          "result() 就係 await，仲會連埋個仔嘅 traceback，喺你個 process 度再掟一次個 exception。"
        ),
      },
      {
        topic = "FIRST",
        q = L(
          "Log each total the moment it lands, in any order. Which helper?",
          "합계가 도착하는 순간 순서 상관없이 찍는다. 어떤 헬퍼?",
          "邊個總數到就即刻寫低，唔理次序。用邊個 helper？"
        ),
        code = L(
          [[
futs = [ex.submit(total, c) for c in chunks]
for fut in concurrent.futures.___(futs):
    log(fut.result())
]],
          [[
futs = [ex.submit(total, c) for c in chunks]
for fut in concurrent.futures.___(futs):
    log(fut.result())
]],
          [[
futs = [ex.submit(total, c) for c in chunks]
for fut in concurrent.futures.___(futs):
    log(fut.result())
]]
        ),
        accept = { "as_completed" },
        answer = "as_completed",
        hint = L(
          "Two words with an underscore: as, then the past participle of complete.",
          "밑줄로 이은 두 단어: as, 그리고 complete의 과거분사.",
          "兩個字用底線連埋：as，加 complete 嘅過去分詞。"
        ),
        ok = L(
          "as_completed is Go's select over many channels: whoever finishes first is served first, and a slow chunk never holds up the log.",
          "as_completed는 여러 채널에 대한 Go의 select다. 먼저 끝난 것이 먼저 처리되고, 느린 청크가 로그를 붙잡지 않는다.",
          "as_completed 就係 Go 對住好多條 channel 嘅 select：邊個做完先服務邊個，慢嘅 chunk 唔會拖住個 log。"
        ),
      },
      {
        topic = "CHOOSE",
        q = L(
          "Waiting on the network or burning the CPU: which word changes for CPU work?",
          "네트워크를 기다리는가, CPU를 태우는가. CPU 작업이면 어떤 단어로 바뀌나?",
          "係等網絡定係燒 CPU？做 CPU 工作嗰陣，邊個字要改？"
        ),
        code = L(
          [[
# 400 supplier calls  -> ThreadPoolExecutor
# 400 image resizes   -> ___PoolExecutor
]],
          [[
# 공급사 호출 400건  -> ThreadPoolExecutor
# 이미지 리사이즈 400건 -> ___PoolExecutor
]],
          [[
# 400 個供應商 call  -> ThreadPoolExecutor
# 400 張相要縮       -> ___PoolExecutor
]]
        ),
        accept = { "Process" },
        answer = "Process",
        hint = L(
          "The seven-letter word from the second street of this quest.",
          "이 퀘스트 두 번째 거리의 그 일곱 글자 단어.",
          "呢個任務第二條街嗰個七個字母嘅字。"
        ),
        ok = L(
          "Waiting overlaps under the GIL; computing does not. That one sentence chooses the executor every time.",
          "기다림은 GIL 아래에서도 겹치고 계산은 겹치지 않는다. 그 한 문장이 매번 executor를 정한다.",
          "等嘢喺 GIL 之下疊得埋，計嘢就疊唔埋。就係呢一句，次次幫你揀 executor。"
        ),
      },
      {
        topic = "ASYNCIO",
        q = L(
          "An asyncio server must not block on a resize. Which loop method hands it to the pool?",
          "asyncio 서버가 리사이즈에서 막히면 안 된다. 풀에 넘기는 루프 메서드는?",
          "asyncio server 唔可以喺縮相度卡住。邊個 loop method 交俾個 pool？"
        ),
        code = L(
          [[
loop = asyncio.get_running_loop()
size = await loop.___(ex, resize, photo)
]],
          [[
loop = asyncio.get_running_loop()
size = await loop.___(ex, resize, photo)
]],
          [[
loop = asyncio.get_running_loop()
size = await loop.___(ex, resize, photo)
]]
        ),
        accept = { "run_in_executor" },
        answer = "run_in_executor",
        hint = L(
          "Three words with underscores: run, in, and the thing you built at the top of this street.",
          "밑줄로 이은 세 단어: run, in, 그리고 이 거리 첫머리에서 만든 그것.",
          "三個字用底線連埋：run、in，加呢條街開頭整嗰樣嘢。"
        ),
        ok = L(
          "asyncio handles the waiting, processes handle the computing, and await joins them. Go does the same thing with one goroutine and no ceremony.",
          "asyncio는 기다림을, 프로세스는 계산을 맡고 await가 둘을 잇는다. Go는 고루틴 하나로 격식 없이 같은 일을 한다.",
          "asyncio 負責等，process 負責計，await 將佢哋駁埋。Go 就用一個 goroutine 做同一件事，唔使咁多儀式。"
        ),
      },
    },
  },
}

return maps
