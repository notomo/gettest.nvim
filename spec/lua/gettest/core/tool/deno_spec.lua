local helper = require("gettest.test.helper")
local gettest = helper.require("gettest")

describe("with deno_test,", function()
  before_each(helper.before_each)
  after_each(helper.after_each)

  local language = "typescript"
  it("works gettest.all_leaves()", function()
    helper.install_parser(language)

    helper.set_lines([[
Deno.test("TestMethod1", () => {

});
]])
    vim.bo.filetype = language

    local tests, err = gettest.all_leaves({ tool_name = "deno_test" })
    assert.is_nil(err)

    local want = {
      {
        name = "TestMethod1",
        row = helper.get_row("TestMethod1"),
        is_leaf = true,
      },
    }
    assert.test_values(tests, want)
  end)
end)
