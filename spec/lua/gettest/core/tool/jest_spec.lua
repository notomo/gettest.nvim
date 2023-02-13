local helper = require("gettest.test.helper")
local gettest = helper.require("gettest")

describe("with jest,", function()
  before_each(helper.before_each)
  after_each(helper.after_each)

  -- HACK
  local languages = { "typescript", "javascript" }
  for _, language in ipairs(languages) do
    it(language .. ", works gettest.nodes()", function()
      helper.install_parser(language)

      helper.set_lines([[
describe("TestMethod1", () => {
  it("should return 11", async () => {
  });

  describe("12", () => {
    it("should return 121", async () => {
    });
    it("should return 122", async () => {
    });
  });
});

describe("TestMethod2", () => {
  it("should return 21", async () => {
  });
});

describe("TestMethod3", () => {
});
]])
      vim.bo.filetype = language

      local tests = gettest.nodes({ scope = "all", tool_name = "jest" })

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
            {
              name = "12",
              full_name = "TestMethod1 12",
              row = helper.get_row("12"),
              children = {
                {
                  name = "should return 121",
                  full_name = "TestMethod1 12 should return 121",
                  row = helper.get_row("should return 121"),
                  children = {},
                },
                {
                  name = "should return 122",
                  full_name = "TestMethod1 12 should return 122",
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
      }
      assert.test_values(tests, want)
    end)
  end

  it("does not raise error even if the buffer does not have filetype", function()
    helper.install_parser("typescript")

    gettest.nodes({ tool_name = "jest" })
  end)
end)
