local M = {}

function M.collect_all_leaves(bufnr, language, tool_name)
  local root, err = require("gettest.lib.treesitter.node").get_first_tree_root(bufnr, language)
  if err then
    return nil, err
  end
  local query = require("gettest.core.query").new(language, tool_name)
  return require("gettest.core.tests").collect(root, query, bufnr, 0, -1)
end

function M.collect_scope_root_leaves(row, bufnr, language, tool_name)
  local root, err = require("gettest.lib.treesitter.node").get_first_tree_root(bufnr, language)
  if err then
    return nil, err
  end

  local query = require("gettest.core.query").new(language, tool_name)
  local tests = require("gettest.core.tests").collect(root, query, bufnr, 0, -1)

  local largest_test = tests:get_one_by_row(row)
  if not largest_test then
    return nil, ("row=%d is not in the test scope"):format(row)
  end

  return tests:filter_by_scope(largest_test)
end

function M.collect_one(row, bufnr, language, tool_name)
  local root, err = require("gettest.lib.treesitter.node").get_first_tree_root(bufnr, language)
  if err then
    return nil, err
  end

  local start_row = 0
  local query = require("gettest.core.query").new(language, tool_name)
  local tests = require("gettest.core.tests").collect(root, query, bufnr, start_row, row)

  local last_test = tests:last()
  if not last_test then
    return nil, ("no tests in the row range [%d, %d]"):format(start_row + 1, row)
  end

  local target_test = last_test:smallest(row)
  if not target_test then
    return nil, ("row=%d is not in the test scope"):format(row)
  end

  return require("gettest.core.tests").new({ target_test })
end

function M.collect_scope_root_node(row, bufnr, language, tool_name)
  local root, err = require("gettest.lib.treesitter.node").get_first_tree_root(bufnr, language)
  if err then
    return nil, err
  end

  local start_row = 0
  local query = require("gettest.core.query").new(language, tool_name)
  local tests = require("gettest.core.tests").collect(root, query, bufnr, start_row, row)

  local last_test = tests:last()
  if not last_test then
    return nil, ("no tests in row range [%d, %d]"):format(start_row + 1, row)
  end

  local target_test = last_test:largest(row)
  if not target_test then
    return nil, ("row=%d is not in the test scope"):format(row)
  end

  return require("gettest.core.tests").new({ target_test })
end

return M
