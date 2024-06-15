local M = {}

function M.nodes(raw_opts)
  local opts = require("gettest.core.option").new(raw_opts)
  if type(opts) == "string" then
    local err = opts
    return nil, nil, err
  end

  local target = opts.target
  local tool = opts.tool

  local tests = require("gettest.core.tests").collect(target.source, tool:build_query(), tool.language)
  if type(tests) == "string" then
    local err = tests
    return nil, nil, err
  end

  local scoped_tests = opts.filter_by_scope(tests, target.row)

  return require("gettest.core.response").new(scoped_tests, target.source, tool)
end

return M
