local M = {
  separator = " ",
}

function M.build_query()
  return vim.treesitter.parse_query(
    vim.bo.filetype,
    [=[
(call_expression
  function: (identifier) @test (#any-of? @test "describe" "it")
  arguments: (arguments
    .
    (_) @test.name
  )
) @test.scope
]=]
  )
end

return M
