local M = {}

M.default = {
  scope = "all",
  tool_name = "",
  target = {},
}

function M.new(raw_opts)
  local opts = vim.tbl_deep_extend("force", M.default, raw_opts or {})

  local target = require("gettest.core.target").new(opts.target)
  if type(target) == "string" then
    local err = target
    return err
  end

  local tool = require("gettest.core.tool").from(opts.tool_name, target:filetype())
  if type(tool) == "string" then
    local err = tool
    return err
  end

  local filter_by_scope = require("gettest.core.scope").new(opts.scope)
  if type(filter_by_scope) == "string" then
    local err = filter_by_scope
    return err
  end

  return {
    target = target,
    tool = tool,
    filter_by_scope = filter_by_scope,
  }
end

return M
