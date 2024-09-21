local helper = require("vusted.helper")
local plugin_name = helper.get_module_root(...)

helper.root = helper.find_plugin_root(plugin_name)
vim.opt.packpath:prepend(vim.fs.joinpath(helper.root, "spec/.shared/packages"))
require("assertlib").register(require("vusted.assert").register)

function helper.before_each()
  vim.cmd.packadd("nvim-treesitter")
  vim.g.loaded_nvim_treesitter = nil
  vim.cmd.runtime([[plugin/nvim-treesitter.lua]])
end

function helper.after_each()
  helper.cleanup()
  helper.cleanup_loaded_modules(plugin_name)
end

function helper.set_lines(str)
  vim.api.nvim_buf_set_lines(0, 0, -1, false, vim.split(str, "\n"))
end

function helper.get_row(pattern)
  local saved = vim.fn.winsaveview()
  local row = vim.fn.search(pattern)
  if row == 0 then
    error(("not found pattern: `%s`"):format(pattern))
  end
  vim.fn.winrestview(saved)
  return row
end

function helper.install_parser(language)
  if not require("gettest.vendor.misclib.treesitter").has_parser(language) then
    vim.cmd.TSInstallSync(language)
  end
end

local asserts = require("vusted.assert").asserts

local function as_value(test)
  local row = test.scope_node:start()
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

asserts.create("test_values"):register_same(function(tests)
  return vim.iter(tests):map(as_value):totable()
end)

function helper.typed_assert(assert)
  local x = require("assertlib").typed(assert)
  ---@cast x +{test_values:fun(tests,want)}
  return x
end

return helper
