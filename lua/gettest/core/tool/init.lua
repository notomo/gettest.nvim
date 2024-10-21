local M = {}

M.default_tools = {
  lua = "lua_busted",
  go = "go_test",
  typescript = "jest",
  typescriptreact = "jest",
  javascript = "jest",
}

--- @class GetTestTool
--- @field name string
--- @field build_query fun(self:GetTestTool):TSQuery
--- @field unwrap_string fun(self:GetTestTool,name_node:TSNode,source:integer|string):string
--- @field build_full_name fun(self:GetTestTool,names:string[]):string
--- @field language string
--- @field separator string

--- @return GetTestTool|string
function M.new(name, filetype)
  local tool_module = require("gettest.vendor.misclib.module").find("gettest.core.tool." .. name)
  if not tool_module then
    return ("no tool for tool_name: `%s`"):format(name)
  end

  local tool = tool_module.new(filetype)
  tool.name = name
  return tool
end

--- @param name string
--- @param filetype string?
function M.from(name, filetype)
  if name ~= "" then
    return M.new(name, filetype)
  end

  filetype = filetype or ""

  local default_tool_name = M.default_tools[filetype]
  if default_tool_name then
    return M.new(default_tool_name, filetype)
  end

  return ("no tools for language: `%s`"):format(filetype)
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
