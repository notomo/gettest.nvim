local M = {}

M.default = {
  bufnr = 0,
  language = "",
  tool_name = "",
}

function M.new(raw_opts)
  vim.validate({ raw_opts = { raw_opts, "table", true } })
  raw_opts = raw_opts or {}

  local opts = vim.tbl_deep_extend("force", M.default, raw_opts)

  if opts.bufnr == 0 then
    opts.bufnr = vim.api.nvim_get_current_buf()
  end

  if opts.language == "" then
    opts.language = vim.bo[opts.bufnr].filetype
  end

  local tool, err = require("gettest.core.tool").from_name(opts.language, opts.tool_name)
  if err then
    return nil, err
  end
  opts.tool = tool

  return opts
end

return M
