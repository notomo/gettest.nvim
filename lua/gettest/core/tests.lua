local Test = require("gettest.core.test")

local M = {}
M.__index = M

function M.new(raw_tests)
  vim.validate({ raw_tests = { raw_tests, "table" } })
  local tbl = { _tests = raw_tests }
  return setmetatable(tbl, M)
end

function M.collect(root, query, bufnr, start_row, end_row)
  local raw_tests = {}

  local last_test = Test.zero()
  for _, match in query:iter_matches(root, bufnr, start_row, end_row) do
    local test = Test.from_match(match, query)

    local new_test, joined = last_test:join(test)
    if new_test and joined then
      raw_tests[#raw_tests] = new_test
    elseif new_test then
      table.insert(raw_tests, new_test)
    else
      table.insert(raw_tests, test)
    end

    last_test = raw_tests[#raw_tests]
  end

  return M.new(raw_tests)
end

function M.map(self, f)
  vim.validate({ f = { f, "function" } })
  return vim.tbl_map(function(test)
    return f(test)
  end, self._tests)
end

function M.filter_by_scope(self, scope_test)
  local raw_tests = {}
  for _, test in ipairs(self._tests) do
    if scope_test:contains(test) then
      table.insert(raw_tests, test)
    end
  end
  return M.new(raw_tests)
end

function M.get_one_by_row(self, row)
  for _, test in ipairs(self._tests) do
    local target = test:largest(row)
    if target then
      return target
    end
  end
end

function M.last(self)
  return self._tests[#self._tests]
end

return M
