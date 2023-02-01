local M = {}

M.default = {
  scope = "all",
  tool_name = "",
  target = {},
}

function M.new(raw_opts)
  vim.validate({ raw_opts = { raw_opts, "table", true } })
  raw_opts = raw_opts or {}

  local opts = vim.tbl_deep_extend("force", M.default, raw_opts)

  local target, err = require("gettest.core.target").new(raw_opts.target)
  if err then
    return nil, err
  end
  opts.target = target

  return opts
end

return M
