local M = {}
M.__index = M

local language = "lua"

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
  return table.concat(texts, " ")
end

function M.build_query(self)
  return vim.treesitter.parse_query(
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
