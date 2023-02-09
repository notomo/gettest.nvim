local M = {}
M.__index = M

local language = "lua"

function M.new()
  local tbl = {
    language = language,
    separator = " ",
  }
  return setmetatable(tbl, M)
end

local literal_types = {
  "string",
}
local get_node_text = vim.treesitter.query.get_node_text
function M.unwrap_string(_, name_node, source)
  local text = get_node_text(name_node, source)
  local typ = name_node:type()
  if not vim.tbl_contains(literal_types, typ) then
    return text
  end
  for child in name_node:iter_children() do
    if child:type() == "string_content" then
      return get_node_text(child, source)
    end
  end
  return text
end

function M.build_full_name(self, names)
  return table.concat(names, self.separator)
end

function M.build_query(self)
  return vim.treesitter.query.parse_query(
    self.language,
    [=[
(function_call
  (identifier) @test (#any-of? @test "describe" "it")
  (arguments
    .
    (_) @test.name
  )
) @test.scope
]=]
  )
end

return M
