-- Pre-install the nvim-treesitter parsers the specs need, into the on-runtimepath
-- install dir, before the ntf run. The parser install runs as an async job that
-- does not complete inside ntf's headless worker processes (and `nvim --clean`,
-- which the workers use, drops the user site dir from runtimepath), so the specs
-- cannot install parsers themselves; they only `has_parser`-check and reuse these.
vim.opt.packpath:prepend(vim.fs.joinpath(vim.fn.getcwd(), "spec/.shared/packages"))
vim.opt.runtimepath:prepend(vim.fn.getcwd())

local helper = require("gettest.test.helper")
helper.before_each()

for _, language in ipairs({ "typescript", "javascript", "go", "rust", "moonbit" }) do
  helper.install_parser(language)
end
