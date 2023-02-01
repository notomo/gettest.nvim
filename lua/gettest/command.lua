local M = {}

function M.nodes(raw_opts)
  local opts, opts_err = require("gettest.core.option").new(raw_opts)
  if opts_err then
    return nil, opts_err
  end
  local target = opts.target

  local tool, tool_err = require("gettest.core.tool").from(opts.tool_name, target:filetype())
  if tool_err then
    return nil, tool_err
  end

  local raw_tests, err = M._collect(opts.scope, target, tool.language, tool:build_query())
  if err then
    return nil, err
  end

  return require("gettest.view.output").expose(raw_tests, target.source, tool)
end

local scope_filters = {
  all = function(raw_tests, _)
    return raw_tests
  end,
  nearest_ancestor = function(raw_tests, row)
    local test = require("gettest.core.tests").new(raw_tests):get_smallest_by_row(row)
    return { test }
  end,
  largest_ancestor = function(raw_tests, row)
    local test = require("gettest.core.tests").new(raw_tests):get_largest_by_row(row)
    return { test }
  end,
}

function M._collect(scope, target, language, query)
  local root, err = require("gettest.lib.treesitter.node").get_first_tree_root(target.source, language)
  if err then
    return nil, err
  end

  local raw_tests, collect_err = require("gettest.core.tests").collect(root, query, target.source, 0, -1)
  if collect_err then
    return nil, collect_err
  end

  local filter_by_scope = scope_filters[scope]
  if not filter_by_scope then
    return nil, "unexpected scope: " .. scope
  end

  local scoped_raw_tests, scope_err = filter_by_scope(raw_tests, target.row)
  if scope_err then
    return nil, scope_err
  end

  return scoped_raw_tests
end

return M
