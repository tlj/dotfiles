local M = {
  "nvim-treesitter/nvim-treesitter",
  build = ":TSUpdate",
  event = { "BufReadPre", "BufReadPost" },
  dependencies = {
    "nvim-treesitter/nvim-treesitter-textobjects",
    "vrischmann/tree-sitter-templ",
  },
  config = function()
    require 'nvim-treesitter.configs'.setup {
      ensure_installed = {
        "bash",
        "gitignore",
        "go",
        "help",
        "html",
        "javascript",
        "json",
        "lua",
        "markdown",
        "markdown_inline",
        "php",
        "sql",
        "yaml",
        "vim",
        "ruby",
      },-- one of "all", "language", or a list of languages
      highlight = {
        enable = true, -- false will disable the whole extension
        disable = {}, -- list of language that will be disabled
      },
      sync_install = false,
      auto_install = false,
      ignore_install = { "help" },
      indent = { enable = true },
      incremental_selection = { 
        enable = true,
        keymaps = {
          init_selection = "<C-space>",
          node_incremental = "<C-space>",
          scope_incremental = false,
          node_decremental = "<bs>",
        },
      },
    }
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
