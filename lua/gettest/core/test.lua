local M = {}
M.__index = M

function M.new(layers)
  vim.validate({ layers = { layers, "table" } })
  local tbl = { _layers = layers }
  return setmetatable(tbl, M)
end

function M.zero()
  return M.new({})
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
  local layer = require("gettest.core.test_layer").new(captures.name_node, captures.scope_node)
  return M.new({ layer })
end

function M.join(self, test)
  local first = test._layers[1]
  if not first then
    return nil, false
  end

  local last_layer = self._layers[#self._layers]
  if not last_layer then
    return nil, false
  end

  if last_layer:contains(first) then
    local layers = {}
    vim.list_extend(layers, self._layers)
    vim.list_extend(layers, test._layers)
    return M.new(layers), true
  end

  local others = vim.list_slice(self._layers, 1, #self._layers - 1)
  for i = #others, 1, -1 do
    local layer = others[i]
    if layer:contains(first) then
      local layers = {}
      vim.list_extend(layers, self._layers, 1, i)
      vim.list_extend(layers, test._layers)
      return M.new(layers), false
    end
  end

  return nil, false
end

function M.iter_layers(self)
  return ipairs(self._layers)
end

function M.scope_node(self)
  local last_layer = self._layers[#self._layers]
  if not last_layer then
    return nil
  end
  return last_layer.scope_node
end

return M
