local ReturnValue = require("gettest.lib.error_handler").ErrorHandler.for_return_value()

function ReturnValue.all(raw_opts)
  local opts, opts_err = require("gettest.core.option").new(raw_opts)
  if opts_err then
    return nil, opts_err
  end

  local tests, err = require("gettest.core").collect_all(opts.bufnr, opts.language, opts.tool.name)
  if err then
    return nil, err
  end

  return require("gettest.view.output").expose(tests, opts.bufnr, opts.language, opts.tool.separator)
end

return ReturnValue:methods()
