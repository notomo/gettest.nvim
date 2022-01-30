local M = {}

function M.new(language, tool_name)
  vim.validate({
    language = { language, "string" },
    tool_name = { tool_name, "string" },
  })
  local name = "gettest/" .. tool_name
  return vim.treesitter.get_query(language, name)
end

return M
