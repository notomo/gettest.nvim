local M = {
  separator = " ",
}

function M.build_query()
  return vim.treesitter.parse_query(
    "lua",
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
