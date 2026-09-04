local F = require "tests.framework"

local SUITES = {
  "tests.test_json",
  "tests.test_ease",
  "tests.test_store",
  "tests.test_persist",
  "tests.test_flow",
  "tests.test_conc",
  "tests.test_fx",
  "tests.test_mod",
}

local M = {}

function M.run()
  print("")
  print("CAUSEWAYBAY GO  //  Love2D tests")
  for _, name in ipairs(SUITES) do
    local ok, suite = pcall(require, name)
    if not ok then
      F.describe(name)
      F.it("loads", function()
        error(suite)
      end)
    else
      suite(F)
    end
  end
  return F.report()
end

return M
