local M = {}

--- Get test nodes.
--- @param opts table|nil: |gettest.nvim-options|
--- @return table: list of |gettest.nvim-test-node|
--- @return table: information used to get tests: {
---   tool = {
---     name = (string)
---     language = (string)
---     separator = (string)
---   }
--- }
function M.nodes(opts)
  local tests, info, err = require("gettest.command").nodes(opts)
  if err then
    require("gettest.vendor.misclib.message").error(err)
  end
  return tests, info
end

return M
