local ease = require "src.ease"

return function(t)
  t.describe("ease")

  t.it("cosine is 0 at 0 and 1 at 1", function()
    t.near(ease.cosine(0), 0)
    t.near(ease.cosine(1), 1)
    t.near(ease.cosine(0.5), 0.5)
  end)

  t.it("expInOut is 0 at 0, 1 at 1, 0.5 at 0.5", function()
    t.near(ease.expInOut(0), 0)
    t.near(ease.expInOut(1), 1)
    t.near(ease.expInOut(0.5), 0.5)
  end)

  t.it("lerp", function()
    t.near(ease.lerp(10, 20, 0.5), 15)
  end)

  t.it("clamp", function()
    t.eq(ease.clamp(-1, 0, 1), 0)
    t.eq(ease.clamp(2, 0, 1), 1)
  end)
end
