local Test = require("gettest.core.test")

local M = {}
M.__index = M

function M.new(raw_tests)
  vim.validate({ raw_tests = { raw_tests, "table" } })
  local tbl = { _tests = raw_tests }
  return setmetatable(tbl, M)
end

function M.collect(root, query, source, start_row, end_row)
  local test_root = Test.new({}, root)
  for _, match in query:iter_matches(root, source, start_row, end_row) do
    local test = Test.from_match(match, query)
    test_root:add(test)
  end
  return test_root.children
end

function M.get_largest_by_row(self, row)
  for _, test in ipairs(self._tests) do
    if test:contains_row(row) then
      return test
    end
  end
end

function M.get_smallest_by_row(self, row)
  for _, test in ipairs(self._tests) do
    if test:contains_row(row) then
      local child = M.new(test.children):get_smallest_by_row(row)
      return child or test
    end
  end
  return nil
end

return M
