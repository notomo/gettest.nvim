local Test = require("gettest.core.test")

local M = {}

function M.collect(source, query, language)
  local root_node = require("gettest.vendor.misclib.treesitter").get_first_tree_root(source, language)
  if type(root_node) == "string" then
    local err = root_node
    return err
  end

  local root = Test.new(root_node)
  for _, match in query:iter_matches(root_node, source, 0, -1) do
    local test = Test.from_match(match, query)
    root:add(test)
  end
  return root.children
end

--- @param tests GetTestTest[]
function M.get_largest_from(tests, row)
  for _, test in ipairs(tests) do
    if test:contains_row(row) then
      return test
    end
  end
end

--- @param tests GetTestTest[]
function M.get_smallest_from(tests, row)
  for _, test in ipairs(tests) do
    if test:contains_row(row) then
      local child = M.get_smallest_from(test.children, row)
      return child or test
    end
  end
end

return M
