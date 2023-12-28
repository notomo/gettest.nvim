local M = {}
M.__index = M

function M.new(filetype)
  local tbl = {
    language = vim.treesitter.language.get_lang(filetype or "typescript"),
    separator = " ",
  }
  return setmetatable(tbl, M)
end

local literal_types = {
  "string",
}
local get_node_text = vim.treesitter.get_node_text
function M.unwrap_string(_, name_node, source)
  local text = get_node_text(name_node, source)
  local typ = name_node:type()
  if not vim.tbl_contains(literal_types, typ) then
    return text
  end
  return text:gsub("^.", ""):gsub(".$", "")
end

function M.build_full_name(self, names)
  return table.concat(names, self.separator)
end

function M.build_query(self)
  return vim.treesitter.query.parse(
    self.language,
    [=[
(call_expression
  function: (identifier) @test.keyword1 (#match? @test.keyword1 "test")
  arguments: (arguments
    .
    (_) @test.name
  )
) @test.scope

(call_expression
  function: (member_expression
    object: (identifier) @test.keyword1 (#match? @test.keyword1 "test")
    property: (property_identifier) @test.keyword2 (#match? @test.keyword2 "describe")
  )
  arguments: (arguments
    .
    (_) @test.name
  )
) @test.scope
]=]
  )
end

return M
