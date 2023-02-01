local M = {}
M.__index = M

function M.new(raw_target)
  vim.validate({ raw_target = { raw_target, "table", true } })
  raw_target = raw_target or {}

  local source
  if raw_target.path then
    local str, err = require("gettest.lib.file").read_all(raw_target.path)
    if err then
      return nil, err
    end
    source = str
  elseif raw_target.bufnr == 0 then
    source = vim.api.nvim_get_current_buf()
  else
    source = raw_target.bufnr or vim.api.nvim_get_current_buf()
  end
  vim.validate({ source = { source, { "number", "string" } } })

  local tbl = {
    source = source,
    row = raw_target.row or 1,
    _path = raw_target.path,
  }
  return setmetatable(tbl, M)
end

function M.filetype(self)
  if type(self.source) == "number" then
    return vim.bo[self.source].filetype
  end

  local filetype = vim.filetype.match({ filename = self._path })
  return filetype
end

return M
