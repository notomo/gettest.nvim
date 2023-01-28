local M = {}

M.default = {
  bufnr = 0,
  tool_name = "",
}

function M.new(raw_opts)
  vim.validate({ raw_opts = { raw_opts, "table", true } })
  raw_opts = raw_opts or {}

  local opts = vim.tbl_deep_extend("force", M.default, raw_opts)

  if opts.bufnr == 0 then
    opts.bufnr = vim.api.nvim_get_current_buf()
  end

  local filetype = vim.bo[opts.bufnr].filetype
  local tool, err = require("gettest.core.tool").from_name(opts.tool_name, filetype)
  if err then
    return nil, err
  end
  opts.tool = tool

  return opts
end

return M
