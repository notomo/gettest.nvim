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
  return require("gettest.lib.treesitter.node").contains(self.scope_node, layer.scope_node)
end

function M.contains_row(self, row)
  return require("gettest.lib.treesitter.node").contains_row(self.scope_node, row)
end

return M
