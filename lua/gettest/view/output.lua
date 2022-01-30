local M = {}

function M.expose(tests, bufnr, language, separator)
  local name_factory = require("gettest.view.name_factory").new(bufnr, language, separator)
  return tests:map(function(test)
    return {
      name = name_factory:create(test),
      scope_node = test:scope_node(),
    }
  end)
end

return M
