local M = {}

--- Get all tree test leaves.
--- @param opts table|nil: |gettest.nvim-opts|
--- @return table: list of |gettest.nvim-test-leaf|
function M.all_leaves(opts)
  return require("gettest.command").all_leaves(opts)
end

--- Get test leaves in root of the scope from the row.
--- @param row number: the row to specify a test scope (1-index)
--- @param opts table|nil: |gettest.nvim-opts|
--- @return table: list of |gettest.nvim-test-leaf|
function M.scope_root_leaves(row, opts)
  return require("gettest.command").scope_root_leaves(row, opts)
end

--- Get a test node from the row.
--- @param row number: the row to specify a test scope (1-index)
--- @param opts table|nil: |gettest.nvim-opts|
--- @return table: |gettest.nvim-test-leaf|
function M.one_node(row, opts)
  return require("gettest.command").one_node(row, opts)
end

--- Get a root test node of the scope from the row.
--- @param row number: the row to specify a test scope (1-index)
--- @param opts table|nil: |gettest.nvim-opts|
--- @return table: |gettest.nvim-test-leaf|
function M.scope_root_node(row, opts)
  return require("gettest.command").scope_root_node(row, opts)
end

return M
