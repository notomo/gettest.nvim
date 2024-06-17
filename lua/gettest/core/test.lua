local vim = vim

--- @class GetTestTest
--- @field scope_node TSNode
--- @field name_nodes TSNode[]
--- @field children GetTestTest[]
local M = {}
M.__index = M

function M.new(scope_node, name_nodes)
  vim.validate({
    scope_node = { scope_node, "userdata" },
    name_nodes = { name_nodes, "table", true },
  })
  local tbl = {
    scope_node = scope_node,
    name_nodes = name_nodes or {},
    children = {},
  }
  return setmetatable(tbl, M)
end

local capture_handlers = {
  ["test.name"] = function(tbl, node)
    tbl.name_node = node
  end,
  ["test.scope"] = function(tbl, node)
    tbl.scope_node = node
  end,
}
function M.from_match(match, query)
  local captures = require("gettest.vendor.misclib.treesitter").get_captures(match, query, capture_handlers)
  return M.new(captures.scope_node, { captures.name_node })
end

--- @param test GetTestTest
function M.add(self, test)
  if not self:contains(test) then
    return false
  end

  for _, child in ipairs(self.children) do
    local added = child:add(test)
    if added then
      return true
    end
  end

  local name_nodes = {}
  vim.list_extend(name_nodes, self.name_nodes)
  vim.list_extend(name_nodes, test.name_nodes)
  test.name_nodes = name_nodes

  table.insert(self.children, test)

  return true
end

--- @param test GetTestTest
function M.contains(self, test)
  local range = { vim.treesitter.get_node_range(test.scope_node) }
  return vim.treesitter.node_contains(self.scope_node, range)
end

function M.contains_row(self, row)
  return vim.treesitter.node_contains(self.scope_node, { row, 0, row, -1 })
end

return M
