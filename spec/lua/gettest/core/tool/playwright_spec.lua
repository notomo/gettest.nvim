local helper = require("gettest.test.helper")
local gettest = helper.require("gettest")

describe("with playwright,", function()
  before_each(helper.before_each)
  after_each(helper.after_each)

  it("works gettest.nodes()", function()
    helper.install_parser("typescript")

    helper.set_lines([[
test.describe("TestMethod1", () => {
  test("should return 11", async ({ page }) => {
  });
});

test.describe("TestMethod2", () => {
  test("should return 21", async ({ page }) => {
  });
});

test.describe("TestMethod3", () => {
});

test.skip("TestSkipped", () => {
});

test.describe("TestStepped", async () => {
    await test.step("step1", () => {
    })

    await test.step("step2", () => {
    })
});
]])
    vim.bo.filetype = "typescript"

    local tests = gettest.nodes({ scope = "all", tool_name = "playwright" })

    local want = {
      {
        name = "TestMethod1",
        full_name = "TestMethod1",
        row = helper.get_row("TestMethod1"),
        children = {
          {
            name = "should return 11",
            full_name = "TestMethod1 should return 11",
            row = helper.get_row("should return 11"),
            children = {},
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
            full_name = "TestMethod2 should return 21",
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
      {
        name = "TestSkipped",
        full_name = "TestSkipped",
        row = helper.get_row("TestSkipped"),
        children = {},
      },
      {
        name = "TestStepped",
        full_name = "TestStepped",
        row = helper.get_row("TestStepped"),
        children = {
          {
            name = "step1",
            full_name = "TestStepped step1",
            row = helper.get_row("step1"),
            children = {},
          },
          {
            name = "step2",
            full_name = "TestStepped step2",
            row = helper.get_row("step2"),
            children = {},
          },
        },
      },
    }
    assert.test_values(tests, want)
  end)
end)
