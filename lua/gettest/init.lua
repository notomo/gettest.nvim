local M = {}

--- Get all test tree leaves in the buffer.
--- @param opts table|nil: |gettest.nvim-opts|
--- @return table: list of |gettest.nvim-test-leaf|
function M.all_leaves(opts)
  return require("gettest.command").all(opts)
end

return M
