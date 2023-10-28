local M = {
  "vrischmann/tree-sitter-templ",
  lazy = true,
  config = function()
    require("tree-sitter-templ").setup()
  end,
}

return M
