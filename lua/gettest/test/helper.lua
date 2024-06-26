local helper = require("vusted.helper")
local plugin_name = helper.get_module_root(...)

helper.root = helper.find_plugin_root(plugin_name)
local runtimepath = vim.o.runtimepath

function helper.before_each()
  vim.o.runtimepath = runtimepath
  vim.g.loaded_nvim_treesitter = nil
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

function helper.use_parsers()
  vim.o.runtimepath = helper.root .. "/spec/lua/nvim-treesitter," .. vim.o.runtimepath
  vim.cmd.runtime([[plugin/nvim-treesitter.*]])
end

function helper.install_parser(language)
  helper.use_parsers()
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

return helper
