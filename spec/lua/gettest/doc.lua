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
            target = {
              text = [[(table | nil)]],
              children = {
                bufnr = [[(number | nil): Buffer number that is used if path is nil.]],
                path = [[(string | nil): file path]],
                row = [[(string | nil): use to calculate ancestor (1-based index)]],
              },
            },
            tool_name = [[(string | nil): test tool name. |gettest.nvim-SUPPORTED-TOOLS|]],
            scope = [[(string | nil): one of the following.
  - all : returns all test nodes (default)
  - nearest_ancestor : returns a nearest ancestor test node from target.row
  - largest_ancestor : returns a largest ancestor test node from target.row]],
          }
          local default = require("gettest.core.option").default
          local keys = vim.tbl_keys(default)
          local lines = util.each_keys_description(keys, descriptions, default)
          opts_text = table.concat(lines, "\n")
        end

        local test_node_text
        do
          local descriptions = {
            name = [[(string): node name]],
            full_name = [[(string): full name including parent node names]],
            children = [[(table): children nodes. list of |gettest.nvim-test-node|]],
            scope_node = [[(userdata): for example test function's node.
    See |treesitter-node|.]],
          }
          local keys = vim.tbl_keys(descriptions)
          local lines = util.each_keys_description(keys, descriptions)
          test_node_text = table.concat(lines, "\n")
        end

        return util.sections(ctx, {
          { name = "options", tag_name = "options", text = opts_text },
          { name = "test node", tag_name = "test-node", text = test_node_text },
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
