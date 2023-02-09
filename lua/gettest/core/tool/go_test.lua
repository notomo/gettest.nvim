local M = {}
M.__index = M

local language = "go"

function M.new()
  local tbl = {
    language = language,
    separator = "/",
  }
  return setmetatable(tbl, M)
end

local literal_types = {
  "interpreted_string_literal",
  "raw_string_literal",
}
local get_node_text = vim.treesitter.query.get_node_text
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
  return vim.treesitter.query.parse_query(
    self.language,
    [=[
(function_declaration
  name: (identifier) @test.name (#match? @test.name "^Test")
) @test.scope

(call_expression
  function: (_
    operand: (identifier)
    field: (field_identifier) @run (#eq? @run "Run")
  )
  arguments: (argument_list
    .
    (_) @test.name
    (func_literal
      parameters: (parameter_list
        (parameter_declaration
          name: (identifier)
          type: (pointer_type
            (qualified_type
              package: (package_identifier) @_testing (#match? @_testing "testing")
            )
          )
        )
      )
    )
  )
) @test.scope
]=]
  )
end

return M
