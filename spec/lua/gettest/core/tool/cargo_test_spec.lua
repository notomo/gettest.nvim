local helper = require("gettest.test.helper")
local gettest = helper.require("gettest")
local assert = helper.typed_assert(assert)

local language = "rust"

describe("with cargo_test,", function()
  before_each(helper.before_each)
  after_each(helper.after_each)

  it("works gettest.nodes()", function()
    helper.install_parser(language)

    helper.set_lines([=[
#[cfg(test)]
mod tests {
    #[test]
    fn func1() {
    }

    #[test]
    fn func2() {
    }
}

#[test]
fn func3() {
}

]=])
    vim.bo.filetype = language

    local tests = gettest.nodes({ scope = "all" })

    local want = {
      {
        name = "tests",
        full_name = "tests",
        row = helper.get_row("tests"),
        children = {
          {
            name = "func1",
            full_name = "tests::func1",
            row = helper.get_row("func1"),
            children = {},
          },
          {
            name = "func2",
            full_name = "tests::func2",
            row = helper.get_row("func2"),
            children = {},
          },
        },
      },
      {
        name = "func3",
        full_name = "func3",
        row = helper.get_row("func3"),
        children = {},
      },
    }
    assert.test_values(tests, want)
  end)
end)
