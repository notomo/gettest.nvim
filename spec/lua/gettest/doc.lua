local util = require("genvdoc.util")
local plugin_name = vim.env.PLUGIN_NAME
local full_plugin_name = plugin_name .. ".nvim"

local example_target
local example_target_path = "./lua/gettest/test/example.lua"
do
  local f = io.open(example_target_path, "r")
  example_target = f:read("a")
end

local example_path = ("./spec/lua/%s/example.lua"):format(plugin_name)

local example_output = vim.api.nvim_exec2("luafile " .. example_path, { output = true }).output

local tool_names_text
do
  local tool_names = vim
    .iter(require("gettest.core.tool").all_names())
    :map(function(name)
      return ("- %s"):format(name)
    end)
    :totable()
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
        if node.declaration == nil or node.declaration.type ~= "function" then
          return nil
        end
        return node.declaration.module
      end,
    },
    {
      name = "STRUCTURE",
      group = function(node)
        if node.declaration == nil or not vim.tbl_contains({ "class", "alias" }, node.declaration.type) then
          return nil
        end
        return "STRUCTURE"
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
        local target = util.help_code_block_from_file(example_target_path, { language = "lua" })
        local usage = util.help_code_block_from_file(example_path, { language = "lua" })
        return ([[
test file
%s

usage
%s

output
%s]]):format(target, usage, util.help_code_block(example_output))
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

This plugin provides functions to get test structures.

## Requirements

- nvim-treesitter (parser must be in the runtimepath)

## Supported tools

%s

## Example

### test file

```lua
%s```

### usage

```lua
%s```

### output

```
%s
```]]):format(full_plugin_name, tool_names_text, example_target, exmaple, example_output)

  local readme = io.open("README.md", "w")
  readme:write(content)
  readme:close()
end
gen_readme()
