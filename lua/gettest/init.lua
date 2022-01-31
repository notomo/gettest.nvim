local M = {}

--- Get all test tree leaves in the buffer.
--- @param opts table|nil: |gettest.nvim-opts|
--- @return table: list of |gettest.nvim-test-leaf|
function M.all_leaves(opts)
  return require("gettest.command").all(opts)
end

--- Get a test node in the buffer.
--- @param row number: the row to specify a test scope (1-index)
--- @param opts table|nil: |gettest.nvim-opts|
--- @return table: |gettest.nvim-test-leaf|
function M.one_node(row, opts)
  return require("gettest.command").one(row, opts)
end

return M
