local M = {
  "nvim-treesitter/nvim-treesitter",
  build = ":TSUpdate",
  event = "BufReadPost",
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
      indent = { enable = false },
    }
  end
}

return M
