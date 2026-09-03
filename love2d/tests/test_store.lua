local Store = require "src.store"

return function(t)
  t.describe("store")

  local scratch = (os.getenv("TMPDIR") or "/tmp"):gsub("/+$", "") .. "/goset-store-test"

  t.it("GOSET_HOME or ~/.causewaybaygo", function()
    Store.use(nil)
    local root = Store.root()
    local home = os.getenv("GOSET_HOME")
    if home and home ~= "" then
      t.has(root, home)
    else
      t.has(root, ".causewaybaygo")
    end
  end)

  t.it("writes and reads a jsonl file", function()
    Store.use(scratch)
    t.ok(Store.write("setup.jsonl", '{"event":"setup"}\n'))
    t.eq(Store.read("setup.jsonl"), '{"event":"setup"}\n')
    t.eq(#Store.lines("setup.jsonl"), 1)
  end)

  t.it("appends lines", function()
    Store.use(scratch)
    Store.write("setup.jsonl", '{"event":"setup"}\n')
    Store.append("setup.jsonl", '{"event":"boot"}\n')
    t.eq(#Store.lines("setup.jsonl"), 2)
  end)

  t.it("restores the default root", function()
    Store.use(nil)
    local root = Store.root()
    t.ok(root:find("causewaybaygo", 1, true) or os.getenv("GOSET_HOME"))
  end)
end
