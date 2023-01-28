local M = {
  separator = "/",
}

function M.build_query()
  return vim.treesitter.parse_query(
    "go",
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
