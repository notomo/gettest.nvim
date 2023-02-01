local M = {}

--- Get test nodes.
--- @param opts table|nil: |gettest.nvim-options|
--- @return table: list of |gettest.nvim-test-node|
--- @return string|nil: error message if error
function M.nodes(opts)
  local tests, err = require("gettest.command").nodes(opts)
  if err then
    require("gettest.vendor.misclib.message").error(err)
  end
  return tests
end

return M
