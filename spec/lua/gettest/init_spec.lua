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
    helper.test_data:create_file(
      "test.lua",
      [[
describe('test', function ()
end)
]]
    )

    local tests = gettest.nodes({ target = { path = helper.test_data.full_path .. "test.lua" } })
    assert.equal(1, #tests)
  end)
end)
