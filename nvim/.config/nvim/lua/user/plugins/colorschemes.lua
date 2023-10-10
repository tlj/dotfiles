return {
  {
    "Shatur/neovim-ayu",
    lazy = false,
    priority = 999,
    enabled = true,
    config = function()
      require 'ayu' .setup({})
    end
  },
  {
    "catppuccin/nvim",
    lazy = false,
    priority = 999,
    enabled = true,
    config = function()
      require('catppuccin').setup({
        colorscheme = "macchiato",
        background = {
          light = "latte",
          dark = "macchiato",
        },
        integration = {
          telescope = true,
        },
        transparent_background = false,
        show_end_of_buffer = false,
        term_colors = false,
        dim_inactive = {
          enabled = false,
          shade = "dark",
          percentage = 0.15,
        },
      })
    end
  },
  {
    'ellisonleao/gruvbox.nvim',
    lazy = false,
    priority = 999,
    enabled = true,
    config = function()
      require 'gruvbox' .load()
    end
  },
  {
    "rebelot/kanagawa.nvim",
    lazy = false,
    priority = 999,
    enabled = true,
    config = function()
      require 'kanagawa' .load()
    end
  },
  {
    "savq/melange-nvim",
    lazy = false,
    priority = 999,
    enabled = true,
  },
  {
    "EdenEast/nightfox.nvim",
    lazy = false,
    priority = 999,
    enabled = true,
    config = function()
      require 'nightfox' .load()
    end
  },
  {
    'AlexvZyl/nordic.nvim',
    lazy = false,
    priority = 999,
    enabled = true,
    config = function()
      require 'nordic' .load()
    end
  },
  {
    "folke/tokyonight.nvim",
    lazy = false,
    priority = 999,
    enabled = true,
    config = function()
      require("tokyonight").setup({
        style = "storm",
      })
    end
  },
}


