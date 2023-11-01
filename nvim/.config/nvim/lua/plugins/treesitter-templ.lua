-- treesitter for the templ go templating engine
local M = {
  "vrischmann/tree-sitter-templ",
  lazy = true,
  ft = { "templ" },
  dependencies = {
    "nvim-treesitter/nvim-treesitter",
  },
  config = function()
    require("tree-sitter-templ").setup()

    local treesitter_parser_configs = require 'nvim-treesitter.parsers'.get_parser_configs()
    treesitter_parser_configs.templ = {
      install_info = {
        url = "https://github.com/vrischmann/tree-sitter-templ.git",
        files = { "src/parser.c", "src/scanner.c" },
        branch = "master",
      },
    }
    vim.treesitter.language.register('templ', 'templ')
  end
}

return M
