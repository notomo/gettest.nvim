local helper = require("ntf.helper")
local plugin_name = helper.get_module_root(...)

helper.root = helper.find_plugin_root(plugin_name)
vim.opt.packpath:prepend(vim.fs.joinpath(helper.root, "spec/.shared/packages"))
require("assertlib").register(require("ntf.assert").register)

function helper.before_each()
  vim.cmd.packadd("nvim-treesitter")
  require("nvim-treesitter").setup({
    install_dir = vim.fs.joinpath(helper.root, "spec/.shared/packages/pack/testpack/opt/nvim-treesitter"),
  })
  vim.api.nvim_create_autocmd("User", {
    pattern = "TSUpdate",
    callback = function()
      require("nvim-treesitter.parsers").moonbit = {
        tier = 3,
        install_info = {
          revision = "a5a7e0b9cb2db740cfcc4232b2f16493b42a0c82",
          url = "https://github.com/moonbitlang/tree-sitter-moonbit",
          queries = "queries",
        },
      }
    end,
  })
end

function helper.after_each() end

function helper.set_lines(str)
  vim.api.nvim_buf_set_lines(0, 0, -1, false, vim.split(str, "\n"))
end

function helper.get_row(pattern)
  local row = vim.fn.search(pattern, "n")
  if row == 0 then
    error(("not found pattern: `%s`"):format(pattern))
  end
  return row
end

function helper.install_parser(language)
  if not require("gettest.vendor.misclib.treesitter").has_parser(language) then
    require("nvim-treesitter").install({ language }, { summary = true }):wait(300000)
  end
end

local assert = require("ntf.assert")

local function as_value(test)
  local name_node = test.name_nodes[#test.name_nodes]
  local row = name_node:start()
  return {
    name = test.name,
    full_name = test.full_name,
    row = row + 1,
    children = vim
      .iter(test.children)
      :map(function(child)
        return as_value(child)
      end)
      :totable(),
  }
end

assert.register_same("test_values", function(tests)
  return vim.iter(tests):map(as_value):totable()
end)

function helper.typed_assert(assert)
  local x = require("assertlib").typed(assert)
  ---@cast x +{test_values:fun(tests,want)}
  return x
end

return helper
