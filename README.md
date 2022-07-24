# gettest.nvim

WIP

This plugin provides functions to get test structures.

## Requirements

- nvim-treesitter (parser must be in the runtimepath)

## Supported

- go: `go test`
- javascript: `jest`
- lua: `busted`
- typescript: `deno test`, `jest`

## Example

```lua
local tests = require("gettest").all_leaves()
for _, test in ipairs(tests) do
  print(test.name)
  print(test.scope_node:start() + 1) -- test scope start row (1-index)
end

local test = require("gettest").one_node(vim.fn.line("."))
print(test.name)
print(test.scope_node:start() + 1)
```