local M = {}
M.__index = M

--- @param raw_target table
function M.new(raw_target)
  local source
  if raw_target.path then
    local str = require("gettest.lib.file").read_all(raw_target.path)
    if type(str) == "table" then
      local err = str
      return err.message
    end
    source = str
  else
    source = raw_target.bufnr or vim.api.nvim_get_current_buf()
  end

  local tbl = {
    source = source,
    row = raw_target.row or 1,
    _path = raw_target.path,
  }
  return setmetatable(tbl, M)
end

function M.filetype(self)
  if type(self.source) == "number" then
    local filetype = vim.bo[self.source].filetype
    return filetype ~= "" and filetype or nil
  end

  local filetype = vim.filetype.match({
    buf = require("gettest.vendor.misclib.buffer").find(self._path),
    filename = self._path,
  })
  return filetype
end

return M
