local ntf = require("ntf")
local describe, it, before_each, after_each = ntf.describe, ntf.it, ntf.before_each, ntf.after_each
local helper = require("gettest.test.helper")
local gettest = require("gettest")
local assert = helper.typed_assert(ntf.assert)

describe("with deno_test,", function()
  before_each(helper.before_each)
  after_each(helper.after_each)

  local language = "typescript"
  it("works gettest.nodes()", function()
    helper.install_parser(language)

    helper.set_lines([[
Deno.test("TestMethod1", () => {

});
]])

    local tests = gettest.nodes({ scope = "all", tool_name = "deno_test" })

    local want = {
      {
        name = "TestMethod1",
        full_name = "TestMethod1",
        row = helper.get_row("TestMethod1"),
        children = {},
      },
    }
    assert.test_values(tests, want)
  end)
end)
