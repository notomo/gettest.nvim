local M = {}
M.__index = M

M.tools = {
  lua = {
    busted = { separator = " ", default = true },
  },
  go = {
    go_test = { separator = "/", default = true, display_name = "go test" },
  },
  typescript = {
    jest = { separator = " ", default = true },
  },
  javascript = {
    jest = { separator = " ", default = true },
  },
}

function M.new(name, setting)
  local tbl = {
    name = name,
    separator = setting.separator,
  }
  return setmetatable(tbl, M)
end

function M.from_name(language, name)
  vim.validate({
    language = { language, "string" },
    name = { name, "string" },
  })

  local tools = M.tools[language]
  if not tools then
    return nil, ("no tools for language: `%s`"):format(language)
  end

  if name == "" then
    return M._default(tools, language)
  end

  local setting = tools[name]
  if not setting then
    return nil, ("no tool for tool_name: `%s`"):format(name)
  end

  return M.new(name, setting)
end

function M._default(tools, language)
  for name, setting in pairs(tools) do
    if setting.default then
      return M.new(name, setting)
    end
  end
  error(("no default tool for language: `%s`"):format(language))
end

return M
