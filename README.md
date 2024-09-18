# gettest.nvim

This plugin provides functions to get test structures.

## Requirements

- nvim-treesitter (parser must be in the runtimepath)

## Supported tools

- deno_test
- go_test
- jest
- lua_busted
- playwright

## Example

### test file

```lua
---@diagnostic disable: undefined-field
describe("test1", function()
  it("1-1", function()
    assert.equal(2, 1 + 1)
  end)
  it("1-2", function()
    assert.equal(2, 1 + 1)
  end)
end)

describe("test2", function()
  it("2-1", function()
    assert.equal(2, 1 + 1)
  end)
end)
```

### usage

```lua
local tests = require("gettest").nodes({
  target = {
    path = "./lua/gettest/test/example.lua",
    -- or
    -- bufnr = bufnr
  },
})
print(vim.inspect(tests))
```

### output

```
{ {
    children = { {
        children = {},
        full_name = "test1 1-1",
        name = "1-1",
        name_nodes = { <userdata 1>, <userdata 2> },
        scope_node = <userdata 3>
      }, {
        children = {},
        full_name = "test1 1-2",
        name = "1-2",
        name_nodes = { <userdata 1>, <userdata 4> },
        scope_node = <userdata 5>
      } },
    full_name = "test1",
    name = "test1",
    name_nodes = { <userdata 1> },
    scope_node = <userdata 6>
  }, {
    children = { {
        children = {},
        full_name = "test2 2-1",
        name = "2-1",
        name_nodes = { <userdata 7>, <userdata 8> },
        scope_node = <userdata 9>
      } },
    full_name = "test2",
    name = "test2",
    name_nodes = { <userdata 7> },
    scope_node = <userdata 10>
  } }
```