local M = {}

function M.collect_all(bufnr, language, tool_name)
  local root, err = require("gettest.lib.treesitter.node").get_first_tree_root(bufnr, language)
  if err then
    return nil, err
  end
  local query = require("gettest.core.query").new(language, tool_name)
  return require("gettest.core.tests").collect(root, query, bufnr, 0, -1)
end

return M
