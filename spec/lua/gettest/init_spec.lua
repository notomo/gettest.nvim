local helper = require("gettest.test.helper")
local gettest = helper.require("gettest")

describe("all_leaves()", function()
  before_each(helper.before_each)
  after_each(helper.after_each)

  it("returns error if there is no tools", function()
    local test, err = gettest.all_leaves()
    assert.is_nil(test)
    assert.equals("[gettest] no tools for language: ``", err)
  end)

  it("returns error if there is no specified tools", function()
    vim.bo.filetype = "lua"
    local test, err = gettest.all_leaves({ tool_name = "invalid" })
    assert.is_nil(test)
    assert.equals("[gettest] no tool for tool_name: `invalid`", err)
  end)
end)
