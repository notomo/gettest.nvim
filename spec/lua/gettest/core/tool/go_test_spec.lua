local helper = require("gettest.test.helper")
local gettest = helper.require("gettest")

local language = "go"

describe("with go_test,", function()
  before_each(helper.before_each)
  after_each(helper.after_each)

  it("works gettest.nodes()", function()
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

    local tests = gettest.nodes({ scope = "all" })

    local want = {
      {
        name = "TestMethod1",
        full_name = "TestMethod1",
        row = helper.get_row("TestMethod1"),
        children = {
          {
            name = "should return 11",
            full_name = "TestMethod1/should return 11",
            row = helper.get_row("should return 11"),
            children = {},
          },
          {
            name = "12",
            full_name = "TestMethod1/12",
            row = helper.get_row("12"),
            children = {
              {
                name = "should return 121",
                full_name = "TestMethod1/12/should return 121",
                row = helper.get_row("should return 121"),
                children = {},
              },
              {
                name = "should return 122",
                full_name = "TestMethod1/12/should return 122",
                row = helper.get_row("should return 122"),
                children = {},
              },
            },
          },
        },
      },
      {
        name = "TestMethod2",
        full_name = "TestMethod2",
        row = helper.get_row("TestMethod2"),
        children = {
          {
            name = "should return 21",
            full_name = "TestMethod2/should return 21",
            row = helper.get_row("should return 21"),
            children = {},
          },
        },
      },
      {
        name = "TestMethod3",
        full_name = "TestMethod3",
        row = helper.get_row("TestMethod3"),
        children = {},
      },
    }
    assert.test_values(tests, want)
  end)
end)
