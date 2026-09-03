local Json = require "src.json"

return function(t)
  t.describe("json")

  t.it("round-trips an object", function()
    local src = { event = "setup", version = 1, fullscreen = false }
    local rec = Json.decode(Json.encode(src))
    t.eq(rec.event, "setup")
    t.eq(rec.version, 1)
    t.eq(rec.fullscreen, false)
  end)

  t.it("round-trips a jsonl line", function()
    local line = Json.encode({ event = "display", mode = "portrait" }) .. "\n"
    local rec = Json.decode(line)
    t.eq(rec.event, "display")
    t.eq(rec.mode, "portrait")
  end)

  t.it("rejects garbage", function()
    local v, err = Json.decode("{nope")
    t.eq(v, nil)
    t.ok(err)
  end)
end
