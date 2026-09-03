-- Tiny test harness. No dependencies.

local F = {
  total = 0,
  failed = 0,
  skipped = 0,
  fails = {},
  suite = "",
}

local function fmt(v)
  if type(v) == "string" then
    return string.format("%q", v)
  end
  return tostring(v)
end

function F.describe(name)
  F.suite = name
  print("")
  print("== " .. name .. " ==")
end

function F.it(name, fn)
  F.total = F.total + 1
  local ok, err = pcall(fn)
  if ok then
    print("  ok    " .. name)
  else
    F.failed = F.failed + 1
    F.fails[#F.fails + 1] = string.format("%s / %s\n      %s", F.suite, name, tostring(err))
    print("  FAIL  " .. name)
    print("        " .. tostring(err))
  end
end

function F.ok(v, msg)
  if not v then
    error(msg or "expected a truthy value, got " .. fmt(v), 2)
  end
  return v
end

function F.eq(got, want, msg)
  if got ~= want then
    error(string.format("%s\n      want: %s\n      got:  %s", msg or "values differ", fmt(want), fmt(got)), 2)
  end
end

function F.near(got, want, eps, msg)
  eps = eps or 0.001
  if type(got) ~= "number" or math.abs(got - want) > eps then
    error(
      string.format("%s\n      want: %s +/- %s\n      got:  %s", msg or "numbers differ", fmt(want), fmt(eps), fmt(got)),
      2
    )
  end
end

function F.has(haystack, needle, msg)
  if type(haystack) ~= "string" or not haystack:find(needle, 1, true) then
    error(
      string.format(
        "%s\n      want substring: %s\n      in: %s",
        msg or "substring missing",
        fmt(needle),
        fmt(haystack)
      ),
      2
    )
  end
end

function F.report()
  print("")
  if F.failed > 0 then
    print("FAILURES:")
    for _, f in ipairs(F.fails) do
      print("  - " .. f)
    end
  end
  print(string.format("%d tests, %d failed, %d skipped", F.total, F.failed, F.skipped))
  return F.failed == 0
end

return F
