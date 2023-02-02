local M = {}

local filters = {
  all = function(tests, _)
    return tests
  end,
  nearest_ancestor = function(tests, row)
    local test = require("gettest.core.tests").get_smallest_from(tests, row)
    return { test }
  end,
  largest_ancestor = function(tests, row)
    local test = require("gettest.core.tests").get_largest_from(tests, row)
    return { test }
  end,
}

function M.new(scope)
  vim.validate({ scope = { scope, "string" } })

  local filter_by_scope = filters[scope]
  if filter_by_scope then
    return filter_by_scope, nil
  end

  local names = table.concat(M.all_names(), "|")
  return nil, ("scope must be %s, but actual: %s"):format(names, scope)
end

function M.all_names()
  local names = vim.tbl_keys(filters)
  table.sort(names, function(a, b)
    return a < b
  end)
  return names
end

return M