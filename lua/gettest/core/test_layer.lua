local M = {}
M.__index = M

function M.new(name_node, scope_node)
  local tbl = {
    name_node = name_node,
    scope_node = scope_node,
  }
  return setmetatable(tbl, M)
end

function M.contains(self, layer)
  local range = { vim.treesitter.get_node_range(layer.scope_node) }
  return vim.treesitter.node_contains(self.scope_node, range)
end

function M.contains_row(self, row)
  return vim.treesitter.node_contains(self.scope_node, { row, 0, row, -1 })
end

return M
