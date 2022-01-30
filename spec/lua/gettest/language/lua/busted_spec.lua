local helper = require("gettest.lib.testlib.helper")
local gettest = helper.require("gettest")

local language = "lua"

describe("with busted,", function()
  before_each(helper.before_each)
  after_each(helper.after_each)

  it("works gettest.all_leaves()", function()
    helper.install_parser(language)

    helper.set_lines([[
describe('method1()', function ()
  it('should return 11', function ()
    return 11
  end)

  describe('12', function ()
    it('should return 121', function ()
      return 121
    end)
  end)
end)

describe('method2()', function ()
  it('should return 21', function ()
    return 21
  end)
end)

it('method3()', function ()
  return "3"
end)
]])
    vim.bo.filetype = language

    local tests = gettest.all_leaves()
    local want = {
      {
        name = "method1() should return 11",
        row = helper.get_row("should return 11"),
      },
      {
        name = "method1() 12 should return 121",
        row = helper.get_row("should return 121"),
      },
      {
        name = "method2() should return 21",
        row = helper.get_row("should return 21"),
      },
      {
        name = "method3()",
        row = helper.get_row("method3()"),
      },
    }
    assert.test_values(tests, want)
  end)
end)
