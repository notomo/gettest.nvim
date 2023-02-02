local helper = require("gettest.test.helper")
local gettest = helper.require("gettest")

describe("gettest.nodes()", function()
  before_each(helper.before_each)
  after_each(helper.after_each)

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
    assert.match("%[gettest%] scope must be all|largest_ancestor|nearest_ancestor, but actual: not_found", err)
  end)
end)
