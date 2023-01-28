local M = {
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
}

return M
