local helper = require("gettest.test.helper")
local gettest = helper.require("gettest")

describe("gettest.nodes()", function()
  before_each(function()
    helper.test_data = require("gettest.vendor.misclib.test.data_dir").setup(helper.root)
    helper.before_each()
  end)
  after_each(function()
    helper.test_data:teardown()
    helper.after_each()
  end)

  it("raises error if there is no tools", function()
    local ok, err = pcall(function()
      gettest.nodes()
    end)
    assert.is_false(ok)
    assert.match("%[gettest%] no tools for language: ``", err)
  end)

  it("raises error if there is no specified tools", function()
    vim.bo.filetype = "lua"

    local ok, err = pcall(function()
      gettest.nodes({ tool_name = "invalid" })
    end)
    assert.is_false(ok)
    assert.match("%[gettest%] no tool for tool_name: `invalid`", err)
  end)

  it("raises error if there is no scope", function()
    vim.bo.filetype = "lua"

    local ok, err = pcall(function()
      gettest.nodes({ scope = "not_found" })
    end)
    assert.is_false(ok)
    assert.match("%[gettest%] scope must be all|largest_ancestor|smallest_ancestor, but actual: not_found", err)
  end)

  it("can return file content tests", function()
    local file_path = helper.test_data:create_file(
      "test.lua",
      [[
describe('test', function ()
end)
]]
    )

    local tests = gettest.nodes({ target = { path = file_path } })
    assert.equal(1, #tests)
  end)

  it("returns name_nodes", function()
    helper.set_lines([[
describe('test', function ()
  it('test', function ()
  end)
end)
]])
    vim.bo.filetype = "lua"

    local test = gettest.nodes()[1].children[1]
    assert.equal(2, #test.name_nodes)

    local row, column = test.name_nodes[#test.name_nodes]:start()
    assert.same({ 1, 5 }, { row, column })
  end)

  it("returns result infomation", function()
    vim.bo.filetype = "lua"

    local _, info = gettest.nodes()

    assert.same({
      source = vim.api.nvim_get_current_buf(),
      tool = {
        language = "lua",
        name = "lua_busted",
        separator = " ",
      },
    }, info)
  end)
end)
