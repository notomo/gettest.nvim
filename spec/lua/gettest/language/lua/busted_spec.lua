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

    local tests, err = gettest.all_leaves()
    assert.is_nil(err)

    local want = {
      {
        name = "method1() should return 11",
        row = helper.get_row("should return 11"),
        is_leaf = true,
      },
      {
        name = "method1() 12 should return 121",
        row = helper.get_row("should return 121"),
        is_leaf = true,
      },
      {
        name = "method2() should return 21",
        row = helper.get_row("should return 21"),
        is_leaf = true,
      },
      {
        name = "method3()",
        row = helper.get_row("method3()"),
        is_leaf = true,
      },
    }
    assert.test_values(tests, want)
  end)

  it("works gettest.one_node()", function()
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
    local test, err = gettest.one_node(row)
    assert.is_nil(err)

    local want = {
      name = "method1() 12",
      row = helper.get_row("'12'"),
      is_leaf = false,
    }
    assert.test_value(test, want)
  end)

  it("works gettest.scope_root_node()", function()
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
    local test, err = gettest.scope_root_node(row)
    assert.is_nil(err)

    local want = {
      name = "method1()",
      row = helper.get_row("method1"),
      is_leaf = false,
    }
    assert.test_value(test, want)
  end)

  it("works gettest.scope_root_leaves()", function()
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

  it('should return 13', function ()
    return 13
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

    local tests, err = gettest.scope_root_leaves(row)
    assert.is_nil(err)

    local want = {
      {
        name = "method1() should return 11",
        row = helper.get_row("should return 11"),
        is_leaf = true,
      },
      {
        name = "method1() 12 should return 121",
        row = helper.get_row("should return 121"),
        is_leaf = true,
      },
      {
        name = "method1() should return 13",
        row = helper.get_row("should return 13"),
        is_leaf = true,
      },
    }
    assert.test_values(tests, want)
  end)
end)
