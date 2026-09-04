-- Find hints that spell out their own answer, in any language:
--
--   luajit tools/hint_leaks.lua src/data_rs.lua [more files]
--
-- The first HINT press is meant to be a nudge, the second the answer. A
-- translation that writes the English answer into the nudge (so a riddle
-- survives the language change) defeats that. Reports every stage whose
-- hint contains its answer as a word while the English hint does not.

package.path = "./?.lua;" .. package.path

local I18n = require "src.i18n"
local files = { ... }
if #files == 0 then
  print("usage: luajit tools/hint_leaks.lua src/data_rs.lua [more]")
  os.exit(2)
end

local function leaks(text, answer)
  text = tostring(text or ""):lower()
  answer = tostring(answer or ""):lower()
  if #answer < 3 or not answer:match("^[%a_:]+$") then
    return false
  end
  local s, e = 1, nil
  while true do
    s, e = text:find(answer, s, true)
    if not s then
      return false
    end
    local before = s > 1 and text:sub(s - 1, s - 1) or " "
    local after = text:sub(e + 1, e + 1)
    if not before:match("[%w_]") and not after:match("[%w_]") then
      return true
    end
    s = e + 1
  end
end

local n = 0
for _, path in ipairs(files) do
  local maps = dofile(path)
  for _, m in ipairs(maps) do
    for si, st in ipairs(m.stages) do
      if not leaks(st.hint.en, st.answer) then
        for _, lang in ipairs(I18n.LANGS) do
          local hint = I18n.pick(st.hint, lang)
          if leaks(hint, st.answer) then
            n = n + 1
            print(string.format("%s %s/%d [%s] answer %q in hint: %s", path, m.id, si, lang, st.answer, hint))
          end
        end
      end
    end
  end
end
print(n .. " leaking hint(s)")
os.exit(n == 0 and 0 or 1)
