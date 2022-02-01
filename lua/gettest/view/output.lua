local M = {}

function M.expose_one(test, bufnr, language, separator, name_factory)
  name_factory = name_factory or require("gettest.view.name_factory").new(bufnr, language, separator)
  return {
    name = name_factory:create(test),
    scope_node = test:scope_node(),
  }
end

function M.expose(tests, bufnr, language, separator)
  local name_factory = require("gettest.view.name_factory").new(bufnr, language, separator)
  return tests:map(function(test)
    return M.expose_one(test, bufnr, language, separator, name_factory)
  end)
end

return M
