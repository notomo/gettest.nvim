local M = {}
M.__index = M

M.default_tools = {
  lua = "lua_busted",
  go = "go_test",
  typescript = "deno_test",
  javascript = "jest",
}

function M.new(name)
  local tool = require("gettest.vendor.misclib.module").find("gettest.core.tool." .. name)
  if not tool then
    return nil, ("no tool for tool_name: `%s`"):format(name)
  end
  local tbl = {
    name = name,
    separator = tool.separator,
    build_query = tool.build_query,
  }
  return setmetatable(tbl, M)
end

function M.from_name(language, name)
  vim.validate({
    language = { language, "string" },
    name = { name, "string" },
  })

  if name ~= "" then
    return M.new(name)
  end

  local default_tool_name = M.default_tools[language]
  if not default_tool_name then
    return nil, ("no tools for language: `%s`"):format(language)
  end
  return M.new(default_tool_name)
end

function M.all_names()
  local paths = vim.api.nvim_get_runtime_file("lua/gettest/core/tool/**/*.lua", true)
  local names = {}
  for _, path in ipairs(paths) do
    local tool_file = vim.split(vim.fs.normalize(path), "lua/gettest/core/tool/", { plain = true })[2]
    local name = tool_file:sub(1, #tool_file - 4)
    if name ~= "init" then
      table.insert(names, name)
    end
  end
  table.sort(names, function(a, b)
    return a < b
  end)
  return names
end

return M
