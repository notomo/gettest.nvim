local M = {}
M.__index = M

function M.new(filetype)
  local tbl = {
    language = filetype,
    _string_unwrapper = require("gettest.lib.treesitter.string_unwrapper").new(filetype),
  }
  return setmetatable(tbl, M)
end

function M.unwrap_string(self, str)
  return self._string_unwrapper:unwrap(str)
end

function M.build_full_name(_, names)
  return table.concat(names, " ")
end

function M.build_query(self)
  return vim.treesitter.parse_query(
    self.language,
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
