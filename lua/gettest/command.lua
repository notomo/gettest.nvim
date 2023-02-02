local M = {}

function M.nodes(raw_opts)
  local opts, opts_err = require("gettest.core.option").new(raw_opts)
  if opts_err then
    return nil, opts_err
  end
  local target = opts.target
  local tool = opts.tool

  local tests, err = require("gettest.core.tests").collect(target.source, tool:build_query(), tool.language)
  if err then
    return nil, err
  end

  local scoped_tests = opts.filter_by_scope(tests, target.row)

  return require("gettest.view.output").expose(scoped_tests, target.source, tool)
end

return M
