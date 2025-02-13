local vim = vim

local M = {}

--- @param tests GetTestTest[]
--- @param tool GetTestTool
--- @return GettestNode[]
--- @return GettestInfo
function M.new(tests, source, path, tool)
  local create_names = function(name_nodes)
    local names = {}
    for _, name_node in ipairs(name_nodes) do
      local name = tool:unwrap_string(name_node, source)
      table.insert(names, name)
    end

    local name = names[#names]
    return name, tool:build_full_name(names, path)
  end

  local response_tests = vim
    .iter(tests)
    :map(function(test)
      return M._new_child(test, create_names)
    end)
    :totable()
  local info = M._new_info(source, tool)
  return response_tests, info
end

--- @param test GetTestTest
function M._new_child(test, create_names)
  local name, full_name = create_names(test.name_nodes)
  return {
    name = name,
    full_name = full_name,
    scope_node = test.scope_node,
    name_nodes = test.name_nodes,
    children = vim
      .iter(test.children)
      :map(function(child)
        return M._new_child(child, create_names)
      end)
      :totable(),
  }
end

--- @param tool GetTestTool
function M._new_info(source, tool)
  return {
    source = source,
    tool = {
      name = tool.name,
      language = tool.language,
      separator = tool.separator,
    },
  }
end

return M
