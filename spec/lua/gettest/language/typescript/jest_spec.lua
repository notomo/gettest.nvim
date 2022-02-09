local helper = require("gettest.lib.testlib.helper")
local gettest = helper.require("gettest")

local language = "typescript"

describe("with jest,", function()
  before_each(helper.before_each)
  after_each(helper.after_each)

  it("works gettest.all_leaves()", function()
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

    local tests, err = gettest.all_leaves()
    assert.is_nil(err)

    local want = {
      {
        name = "TestMethod1 should return 11",
        row = helper.get_row("should return 11"),
      },
      {
        name = "TestMethod1 12 should return 121",
        row = helper.get_row("should return 121"),
      },
      {
        name = "TestMethod1 12 should return 122",
        row = helper.get_row("should return 122"),
      },
      {
        name = "TestMethod2 should return 21",
        row = helper.get_row("should return 21"),
      },
      {
        name = "TestMethod3",
        row = helper.get_row("TestMethod3"),
      },
    }
    assert.test_values(tests, want)
  end)
end)
