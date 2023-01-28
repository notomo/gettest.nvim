local util = require("genvdoc.util")
local plugin_name = vim.env.PLUGIN_NAME
local full_plugin_name = plugin_name .. ".nvim"

local example_path = ("./spec/lua/%s/example.lua"):format(plugin_name)
vim.o.runtimepath = vim.fn.getcwd() .. "," .. vim.o.runtimepath

local tool_names_text
do
  local tool_names = vim.tbl_map(function(name)
    return ("- %s"):format(name)
  end, require("gettest.core.tool").all_names())
  tool_names_text = table.concat(tool_names, "\n")
end

require("genvdoc").generate(full_plugin_name, {
  source = { patterns = { ("lua/%s/init.lua"):format(plugin_name) } },
  chapters = {
    {
      name = function(group)
        return "Lua module: " .. group
      end,
      group = function(node)
        if not node.declaration then
          return nil
        end
        return node.declaration.module
      end,
    },
    {
      name = "TYPES",
      body = function(ctx)
        local opts_text
        do
          local descriptions = {
            bufnr = [[(number | nil): target buffer number.
    default: %s]],
            language = [[(string | nil): treesitter parser language.
    default: filetype]],
            tool_name = [[(string | nil): test framework name.]],
          }
          local default = require("gettest.core.option").default
          local keys = vim.tbl_keys(default)
          local lines = util.each_keys_description(keys, descriptions, default)
          opts_text = table.concat(lines, "\n")
        end

        local test_leaf_text
        do
          local descriptions = {
            name = [[(string): test name]],
            is_leaf = [[(boolean): this node is a leaf.]],
            scope_node = [[(userdata):  for example test function's node.
    |lua-treesitter-node|]],
          }
          local keys = vim.tbl_keys(descriptions)
          local lines = util.each_keys_description(keys, descriptions)
          test_leaf_text = table.concat(lines, "\n")
        end

        return util.sections(ctx, {
          { name = "options for get methods", tag_name = "opts", text = opts_text },
          { name = "test leaf", tag_name = "test-leaf", text = test_leaf_text },
        })
      end,
    },
    {
      name = "SUPPORTED TOOLS",
      body = function()
        return tool_names_text
      end,
    },
    {
      name = "EXAMPLES",
      body = function()
        return util.help_code_block_from_file(example_path, { language = "lua" })
      end,
    },
  },
})

local gen_readme = function()
  local f = io.open(example_path, "r")
  local exmaple = f:read("*a")
  f:close()

  local content = ([[
# %s

WIP

This plugin provides functions to get test structures.

## Requirements

- nvim-treesitter (parser must be in the runtimepath)

## Supported tools

%s

## Example

```lua
%s```]]):format(full_plugin_name, tool_names_text, exmaple)

  local readme = io.open("README.md", "w")
  readme:write(content)
  readme:close()
end
gen_readme()
