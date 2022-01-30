local M = {}
M.__index = M

function M.new(bufnr, language, separator)
  vim.validate({
    bufnr = { bufnr, "number" },
    language = { language, "string" },
    separator = { separator, "string" },
  })
  local tbl = {
    _string_unwrapper = require("gettest.lib.treesitter.string_unwrapper").new(language),
    _bufnr = bufnr,
    _separator = separator,
  }
  return setmetatable(tbl, M)
end

local get_node_text = vim.treesitter.query.get_node_text
function M.create(self, test)
  local texts = {}
  for _, layer in test:iter_layers() do
    local text = get_node_text(layer.name_node, self._bufnr)
    table.insert(texts, self._string_unwrapper:unwrap(text))
  end
  return table.concat(texts, self._separator)
end

return M
