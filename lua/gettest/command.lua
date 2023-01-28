local M = {}

function M.all_leaves(raw_opts)
  local opts, opts_err = require("gettest.core.option").new(raw_opts)
  if opts_err then
    return nil, opts_err
  end
  local tool = opts.tool

  local tests, err = require("gettest.core").collect_all_leaves(opts.bufnr, tool.language, tool:build_query())
  if err then
    return nil, err
  end

  return require("gettest.view.output").expose(tests, opts.bufnr, tool)
end

function M.scope_root_leaves(row, raw_opts)
  local opts, opts_err = require("gettest.core.option").new(raw_opts)
  if opts_err then
    return nil, opts_err
  end
  local tool = opts.tool

  local tests, err =
    require("gettest.core").collect_scope_root_leaves(row, opts.bufnr, tool.language, tool:build_query())
  if err then
    return nil, err
  end

  return require("gettest.view.output").expose(tests, opts.bufnr, tool)
end

function M.one_node(row, raw_opts)
  local opts, opts_err = require("gettest.core.option").new(raw_opts)
  if opts_err then
    return nil, opts_err
  end
  local tool = opts.tool

  local test, err = require("gettest.core").collect_one(row, opts.bufnr, tool.language, tool:build_query())
  if err then
    return nil, err
  end

  return require("gettest.view.output").expose_one(test, opts.bufnr, tool)
end

function M.scope_root_node(row, raw_opts)
  local opts, opts_err = require("gettest.core.option").new(raw_opts)
  if opts_err then
    return nil, opts_err
  end
  local tool = opts.tool

  local test, err = require("gettest.core").collect_scope_root_node(row, opts.bufnr, tool.language, tool:build_query())
  if err then
    return nil, err
  end

  return require("gettest.view.output").expose_one(test, opts.bufnr, tool)
end

return M
