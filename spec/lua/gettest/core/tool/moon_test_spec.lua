local ntf = require("ntf")
local describe, it, before_each, after_each = ntf.describe, ntf.it, ntf.before_each, ntf.after_each
local helper = require("gettest.test.helper")
local gettest = require("gettest")
local assert = helper.typed_assert(ntf.assert)

local language = "moonbit"

describe("with moon_test,", function()
  before_each(helper.before_each)
  after_each(helper.after_each)

  it("works gettest.nodes()", function()
    helper.install_parser(language)

    helper.set_lines([=[
test "a" {
}

test "b" {
}

]=])
    vim.bo.filetype = language

    local tests = gettest.nodes({ scope = "all" })

    local want = {
      {
        name = "a",
        full_name = "a",
        row = helper.get_row([["a"]]),
        children = {},
      },
      {
        name = "b",
        full_name = "b",
        row = helper.get_row([["b"]]),
        children = {},
      },
    }
    assert.test_values(tests, want)
  end)
end)
