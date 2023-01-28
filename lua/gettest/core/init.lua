local M = {}

function M.collect_all_leaves(bufnr, language, query)
  local root, err = require("gettest.lib.treesitter.node").get_first_tree_root(bufnr, language)
  if err then
    return nil, err
  end
  return require("gettest.core.tests").collect(root, query, bufnr, 0, -1)
end

function M.collect_scope_root_leaves(row, bufnr, language, query)
  vim.validate({ row = { row, "number" } })

  local root, err = require("gettest.lib.treesitter.node").get_first_tree_root(bufnr, language)
  if err then
    return nil, err
  end

  local tests = require("gettest.core.tests").collect(root, query, bufnr, 0, -1)

  local largest_test = tests:get_largest_by_row(row)
  if not largest_test then
    return nil, ("row=%d is not in the test scope"):format(row)
  end

  return tests:filter_by_scope(largest_test)
end

function M.collect_one(row, bufnr, language, query)
  vim.validate({ row = { row, "number" } })

  local root, err = require("gettest.lib.treesitter.node").get_first_tree_root(bufnr, language)
  if err then
    return nil, err
  end

  local tests = require("gettest.core.tests").collect(root, query, bufnr, 0, -1)

  local target_test = tests:get_smallest_by_row(row)
  if not target_test then
    return nil, ("row=%d is not in the test scope"):format(row)
  end

  return target_test
end

function M.collect_scope_root_node(row, bufnr, language, query)
  vim.validate({ row = { row, "number" } })

  local root, err = require("gettest.lib.treesitter.node").get_first_tree_root(bufnr, language)
  if err then
    return nil, err
  end

  local tests = require("gettest.core.tests").collect(root, query, bufnr, 0, -1)

  local target_test = tests:get_largest_by_row(row)
  if not target_test then
    return nil, ("row=%d is not in the test scope"):format(row)
  end

  return target_test
end

return M
