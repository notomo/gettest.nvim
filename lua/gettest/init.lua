local M = {}

--- @class GettestNode
--- @field children GettestNode[] children nodes
--- @field full_name string full name including parent node names
--- @field name string node name
--- @field name_nodes userdata[] test name nodes including parent test nodes. The last node is own name node. |treesitter-node|
--- @field scope_node userdata for example, test function's node. |treesitter-node|

--- @class GettestOption
--- @field scope GettestScope? |GettestScope|
--- @field target GettestTarget? |GettestTarget|
--- @field tool_name string? test tool name. |gettest.nvim-SUPPORTED-TOOLS|

--- @alias GettestScope
--- | '"all"' # returns all test nodes
--- | '"smallest_ancestor"' # returns a smallest ancestor test node from target.row
--- | '"largest_ancestor"' # returns a largest ancestor test node from target.row

--- @class GettestTarget
--- @field bufnr integer? buffer number that is used if path is nil
--- @field path string? file path
--- @field row integer? use to calculate ancestor (1-based index)

--- @class GettestInfo
--- @field source integer|string buffer number or specified path's file content
--- @field tool GettestToolInfo |GettestToolInfo|

--- @class GettestToolInfo
--- @field name string used test tool name
--- @field language string used language name
--- @field separator string tool name separator

--- Get test nodes.
--- @param opts GettestOption?: |GettestOption|
--- @return GettestNode[] # |GettestNode|
--- @return GettestInfo # information used to get tests. |GettestToolInfo|
function M.nodes(opts)
  local response = require("gettest.command").nodes(opts)
  if type(response) == "string" then
    local err = response
    require("gettest.vendor.misclib.message").error(err)
  end
  return response.tests, response.info
end

return M
