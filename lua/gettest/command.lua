local ReturnValue = require("gettest.lib.error_handler").ErrorHandler.for_return_value()

function ReturnValue.all_leaves(raw_opts)
  local opts, opts_err = require("gettest.core.option").new(raw_opts)
  if opts_err then
    return nil, opts_err
  end

  local tests, err = require("gettest.core").collect_all_leaves(opts.bufnr, opts.language, opts.tool.name)
  if err then
    return nil, err
  end

  return require("gettest.view.output").expose(tests, opts.bufnr, opts.language, opts.tool.separator)
end

function ReturnValue.scope_root_leaves(row, raw_opts)
  local opts, opts_err = require("gettest.core.option").new(raw_opts)
  if opts_err then
    return nil, opts_err
  end

  local tests, err = require("gettest.core").collect_scope_root_leaves(row, opts.bufnr, opts.language, opts.tool.name)
  if err then
    return nil, err
  end

  return require("gettest.view.output").expose(tests, opts.bufnr, opts.language, opts.tool.separator)
end

function ReturnValue.one_node(row, raw_opts)
  local opts, opts_err = require("gettest.core.option").new(raw_opts)
  if opts_err then
    return nil, opts_err
  end

  local test, err = require("gettest.core").collect_one(row, opts.bufnr, opts.language, opts.tool.name)
  if err then
    return nil, err
  end

  return require("gettest.view.output").expose_one(test, opts.bufnr, opts.language, opts.tool.separator)
end

function ReturnValue.scope_root_node(row, raw_opts)
  local opts, opts_err = require("gettest.core.option").new(raw_opts)
  if opts_err then
    return nil, opts_err
  end

  local test, err = require("gettest.core").collect_scope_root_node(row, opts.bufnr, opts.language, opts.tool.name)
  if err then
    return nil, err
  end

  return require("gettest.view.output").expose_one(test, opts.bufnr, opts.language, opts.tool.separator)
end

return ReturnValue:methods()
