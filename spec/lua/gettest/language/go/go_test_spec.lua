local helper = require("gettest.lib.testlib.helper")
local gettest = helper.require("gettest")

local language = "go"

describe("with go_test,", function()
  before_each(helper.before_each)
  after_each(helper.after_each)

  it("works gettest.all_leaves()", function()
    helper.install_parser(language)

    helper.set_lines([[
func TestMethod1(t *testing.T) {
	t.Run("should return 11", func(t *testing.T) {
	})

	t.Run("12", func(t *testing.T) {
		t.Run("should return 121", func(t *testing.T) {
		})

		t.Run("should return 122", func(t *testing.T) {
		})
	})

}

func TestMethod2(t *testing.T) {
	t.Run("should return 21", func(t *testing.T) {
	})
}

func TestMethod3(t *testing.T) {
}
]])
    vim.bo.filetype = language

    local tests, err = gettest.all_leaves()
    assert.is_nil(err)

    local want = {
      {
        name = "TestMethod1/should return 11",
        row = helper.get_row("should return 11"),
        is_leaf = true,
      },
      {
        name = "TestMethod1/12/should return 121",
        row = helper.get_row("should return 121"),
        is_leaf = true,
      },
      {
        name = "TestMethod1/12/should return 122",
        row = helper.get_row("should return 122"),
        is_leaf = true,
      },
      {
        name = "TestMethod2/should return 21",
        row = helper.get_row("should return 21"),
        is_leaf = true,
      },
      {
        name = "TestMethod3",
        row = helper.get_row("TestMethod3"),
        is_leaf = true,
      },
    }
    assert.test_values(tests, want)
  end)
end)
