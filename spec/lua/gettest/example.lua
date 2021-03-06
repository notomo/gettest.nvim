local tests = require("gettest").all_leaves()
for _, test in ipairs(tests) do
  print(test.name)
  print(test.scope_node:start() + 1) -- test scope start row (1-index)
end

local test = require("gettest").one_node(vim.fn.line("."))
print(test.name)
print(test.scope_node:start() + 1)
