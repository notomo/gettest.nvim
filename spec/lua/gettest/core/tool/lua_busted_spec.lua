local helper = require("gettest.test.helper")
local gettest = helper.require("gettest")
local assert = helper.typed_assert(assert)

local language = "lua"

describe("with busted,", function()
  before_each(helper.before_each)
  after_each(helper.after_each)

  it("works gettest.nodes() with scope=all", function()
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

    local tests = gettest.nodes({ scope = "all" })

    local want = {
      {
        name = "method1()",
        full_name = "method1()",
        row = helper.get_row("'method1()'"),
        children = {
          {
            name = "should return 11",
            full_name = "method1() should return 11",
            row = helper.get_row("'should return 11'"),
            children = {},
          },
          {
            name = "12",
            full_name = "method1() 12",
            row = helper.get_row("'12'"),
            children = {
              {
                name = "should return 121",
                full_name = "method1() 12 should return 121",
                row = helper.get_row("'should return 121'"),
                children = {},
              },
            },
          },
        },
      },
      {
        name = "method2()",
        full_name = "method2()",
        row = helper.get_row("'method2()'"),
        children = {
          {
            name = "should return 21",
            full_name = "method2() should return 21",
            row = helper.get_row("'should return 21'"),
            children = {},
          },
        },
      },
      {
        name = "method3()",
        full_name = "method3()",
        row = helper.get_row("method3()"),
        children = {},
      },
    }
    assert.test_values(tests, want)
  end)

  it("works gettest.nodes() with scope=smallest_ancestor", function()
    helper.install_parser(language)

    helper.set_lines([[
describe('method1()', function ()
  it('should return 11', function ()
    return 11
  end)

  describe('12', function ()

    print('this')

    it('should return 121', function ()
      return 121
    end)

  end)

  it('should return 13', function ()
    return 13
  end)
end)
]])
    vim.bo.filetype = language

    local row = helper.get_row([['this']])
    local tests = gettest.nodes({
      scope = "smallest_ancestor",
      target = { row = row },
    })

    local want = {
      {
        name = "12",
        full_name = "method1() 12",
        row = helper.get_row("'12'"),
        children = {
          {
            name = "should return 121",
            full_name = "method1() 12 should return 121",
            row = helper.get_row("'should return 121'"),
            children = {},
          },
        },
      },
    }
    assert.test_values(tests, want)
  end)

  it("works gettest.nodes() with scope=largest_ancestor", function()
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
]])
    vim.bo.filetype = language

    local row = helper.get_row([[\v^\s+return 121]])
    local tests = gettest.nodes({
      scope = "largest_ancestor",
      target = { row = row },
    })

    local want = {
      {
        name = "method1()",
        full_name = "method1()",
        row = helper.get_row("'method1()'"),
        children = {
          {
            name = "should return 11",
            full_name = "method1() should return 11",
            row = helper.get_row("'should return 11'"),
            children = {},
          },
          {
            name = "12",
            full_name = "method1() 12",
            row = helper.get_row("'12'"),
            children = {
              {
                children = {},
                full_name = "method1() 12 should return 121",
                name = "should return 121",
                row = helper.get_row("'should return 121'"),
              },
            },
          },
        },
      },
    }
    assert.test_values(tests, want)
  end)
end)
