local vim = vim

local M = {}

local get_node_text = vim.treesitter.query.get_node_text
function M.new(raw_tests, source, tool)
  local create_names = function(name_nodes)
    local names = {}
    for _, name_node in ipairs(name_nodes) do
      local text = get_node_text(name_node, source)
      local name = tool:unwrap_string(text)
      table.insert(names, name)
    end

    local name = names[#names]
    return name, tool:build_name(names)
  end

  return vim.tbl_map(function(test)
    return M._new_child(test, create_names)
  end, raw_tests)
end

function M._new_child(test, create_names)
  local name, full_name = create_names(test.name_nodes)
  return {
    name = name,
    full_name = full_name,
    scope_node = test.scope_node,
    children = vim.tbl_map(function(child)
      return M._new_child(child, create_names)
    end, test.children),
  }
end

return M
