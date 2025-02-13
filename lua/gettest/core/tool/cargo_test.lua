local M = {}
M.__index = M

local language = "rust"

function M.new()
  local tbl = {
    language = language,
    separator = "::",
  }
  return setmetatable(tbl, M)
end

local literal_types = {
  "string_literal",
  "raw_string_literal",
}
local get_node_text = vim.treesitter.get_node_text
function M.unwrap_string(_, name_node, source)
  local text = get_node_text(name_node, source)
  local typ = name_node:type()
  if not vim.tbl_contains(literal_types, typ) then
    return text
  end
  for child in name_node:iter_children() do
    if child:type() == "string_content" then
      return get_node_text(child, source)
    end
  end
  return text
end

function M.build_full_name(self, names, path)
  local cargo_dir = vim.fs.root(path, { "Cargo.toml" })
  if not cargo_dir then
    return table.concat(names, self.separator)
  end

  local file_name = vim.fn.fnamemodify(vim.fs.basename(path), ":r")
  local relative_path = assert(vim.fs.relpath(cargo_dir, vim.fs.dirname(path)))
  local elements = {}
  vim.list_extend(elements, vim.split(relative_path, "/", { plain = true, trimempty = true }))
  table.insert(elements, file_name)
  vim.list_extend(elements, names)

  if elements[1] == "src" then
    table.remove(elements, 1)
  end
  if elements[1] == "tests" then
    table.remove(elements, 1)
  end
  if elements[1] == "lib" then
    table.remove(elements, 1)
  end

  return table.concat(elements, self.separator)
end

function M.build_query(self)
  return vim.treesitter.query.parse(
    self.language,
    [=[
(mod_item 
  name: (identifier) @test.name (#match? @test.name "^test")
) @test.scope
(
  (attribute_item
    (attribute
      (identifier) @test.attribute (#match? @test.attribute "^test")
    )
  )
  .
  (function_item
    name: (identifier) @test.name
  )
) @test.scope
]=]
  )
end

return M
