local tests = require("gettest").nodes({
  target = {
    path = "./lua/gettest/test/example.lua",
    -- or
    -- bufnr = bufnr
  },
})
print(vim.inspect(tests))
