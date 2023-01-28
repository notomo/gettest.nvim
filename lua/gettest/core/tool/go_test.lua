local M = {}
M.__index = M

local language = "go"

function M.new()
  local tbl = {
    language = language,
    _string_unwrapper = require("gettest.lib.treesitter.string_unwrapper").new(language),
  }
  return setmetatable(tbl, M)
end

function M.unwrap_string(self, str)
  return self._string_unwrapper:unwrap(str)
end

function M.build_name(_, texts)
  return table.concat(texts, "/")
end

function M.build_query(self)
  return vim.treesitter.parse_query(
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
