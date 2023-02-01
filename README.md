# gettest.nvim

WIP

This plugin provides functions to get test structures.

## Requirements

- nvim-treesitter (parser must be in the runtimepath)

## Supported tools

- deno_test
- go_test
- jest
- lua_busted

## Example

```lua
local tests = require("gettest").nodes()
print(vim.inspect(tests))
```