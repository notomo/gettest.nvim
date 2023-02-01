local vim = vim

local M = {}
M.__index = M

function M.new(name_nodes, scope_node, children)
  vim.validate({
    name_nodes = { name_nodes, "table" },
    scope_node = { scope_node, "userdata" },
    children = { children, "table" },
  })
  local tbl = {
    name_nodes = name_nodes,
    scope_node = scope_node,
    children = children,
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
  local captures = require("gettest.lib.treesitter.node").get_captures(match, query, capture_handlers)
  return M.new({ captures.name_node }, captures.scope_node, {})
end

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

function M.contains(self, test)
  local range = { vim.treesitter.get_node_range(test.scope_node) }
  return vim.treesitter.node_contains(self.scope_node, range)
end

function M.contains_row(self, row)
  return vim.treesitter.node_contains(self.scope_node, { row, 0, row, -1 })
end

return M
