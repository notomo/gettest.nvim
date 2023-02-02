local M = {}
M.__index = M

local language = "typescript"

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

function M.build_full_name(_, names)
  return table.concat(names, " ")
end

function M.build_query(self)
  return vim.treesitter.parse_query(
    self.language,
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
