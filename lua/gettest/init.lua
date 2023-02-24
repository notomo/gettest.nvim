local M = {}

--- @class GettestNode
--- @field children GettestNode[] children nodes
--- @field full_name string full name including parent node names
--- @field name string node name
--- @field name_nodes userdata[] test name nodes including parent test nodes. The last node is own name node. |treesitter-node|
--- @field scope_node userdata for example, test function's node. |treesitter-node|

--- @class GettestOption
--- @field scope ("all"|"smallest_ancestor"|"largest_ancestor")?
--- @field target GettestTarget? |GettestTarget|
--- @field tool_name string? test tool name. |gettest.nvim-SUPPORTED-TOOLS|

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
--- @return GettestNode[]: |GettestNode|
--- @return GettestInfo: information used to get tests. |GettestToolInfo|
function M.nodes(opts)
  local tests, info, err = require("gettest.command").nodes(opts)
  if err then
    require("gettest.vendor.misclib.message").error(err)
  end
  return tests, info
end

return M
