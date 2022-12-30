local M = {}

--- Get all tree test leaves.
--- @param opts table|nil: |gettest.nvim-opts|
--- @return table|nil: list of |gettest.nvim-test-leaf|
--- @return string|nil: error message if error
function M.all_leaves(opts)
  local v, err = require("gettest.command").all_leaves(opts)
  if err then
    return nil, require("gettest.vendor.misclib.message").wrap(err)
  end
  return v, nil
end

--- Get test leaves in root of the scope from the row.
--- @param row number: the row to specify a test scope (1-index)
--- @param opts table|nil: |gettest.nvim-opts|
--- @return table|nil: list of |gettest.nvim-test-leaf|
--- @return string|nil: error message if error
function M.scope_root_leaves(row, opts)
  local v, err = require("gettest.command").scope_root_leaves(row, opts)
  if err then
    return nil, require("gettest.vendor.misclib.message").wrap(err)
  end
  return v, nil
end

--- Get a test node from the row.
--- @param row number: the row to specify a test scope (1-index)
--- @param opts table|nil: |gettest.nvim-opts|
--- @return table|nil: |gettest.nvim-test-leaf|
--- @return string|nil: error message if error
function M.one_node(row, opts)
  local v, err = require("gettest.command").one_node(row, opts)
  if err then
    return nil, require("gettest.vendor.misclib.message").wrap(err)
  end
  return v, nil
end

--- Get a root test node of the scope from the row.
--- @param row number: the row to specify a test scope (1-index)
--- @param opts table|nil: |gettest.nvim-opts|
--- @return table|nil: |gettest.nvim-test-leaf|
--- @return string|nil: error message if error
function M.scope_root_node(row, opts)
  local v, err = require("gettest.command").scope_root_node(row, opts)
  if err then
    return nil, require("gettest.vendor.misclib.message").wrap(err)
  end
  return v, nil
end

return M
