local M = {}

M.default = {
  scope = "all",
  tool_name = "",
  target = {},
}

function M.new(raw_opts)
  vim.validate({ raw_opts = { raw_opts, "table", true } })
  local opts = vim.tbl_deep_extend("force", M.default, raw_opts or {})

  local target, err = require("gettest.core.target").new(opts.target)
  if err then
    return nil, err
  end

  local tool, tool_err = require("gettest.core.tool").from(opts.tool_name, target:filetype())
  if tool_err then
    return nil, tool_err
  end

  local filter_by_scope, scope_err = require("gettest.core.scope").new(opts.scope)
  if scope_err then
    return nil, scope_err
  end

  return {
    target = target,
    tool = tool,
    filter_by_scope = filter_by_scope,
  }
end

return M
