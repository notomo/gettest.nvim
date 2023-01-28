local M = {
  separator = " ",
}

function M.build_query()
  return vim.treesitter.parse_query(
    "typescript",
    [=[
(call_expression
  function: (member_expression
    object: (identifier) @test.keyword1 (#match? @test.keyword1 "Deno")
    property: (property_identifier) @test.keyword2 (#match? @test.keyword2 "test")
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
