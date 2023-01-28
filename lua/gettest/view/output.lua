local M = {}

function M.expose_one(test, bufnr, tool)
  return {
    name = M._create_name(test, bufnr, tool),
    scope_node = test:scope_node(),
    is_leaf = test.is_leaf,
  }
end

function M.expose(tests, bufnr, tool)
  return tests:map(function(test)
    return M.expose_one(test, bufnr, tool)
  end)
end

local get_node_text = vim.treesitter.query.get_node_text
function M._create_name(test, bufnr, tool)
  local texts = {}
  for _, layer in test:iter_layers() do
    local text = get_node_text(layer.name_node, bufnr)
    table.insert(texts, tool:unwrap_string(text))
  end
  return tool:build_name(texts)
end

return M
