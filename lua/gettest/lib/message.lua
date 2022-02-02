local M = {}

local plugin_name = vim.split((...):gsub("%.", "/"), "/", true)[1]
local prefix = ("[%s] "):format(plugin_name)

function M.error(err)
  error(M.wrap(err))
end

function M.warn(msg)
  vim.validate({ msg = { msg, "string" } })
  vim.api.nvim_echo({ { M.wrap(msg), "WarningMsg" } }, true, {})
end

function M.wrap(msg)
  return prefix .. msg
end

return M
