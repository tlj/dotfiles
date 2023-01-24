local M = {
  "catppuccin/nvim",
  lazy = false,
  priority = 999,
  config = function()
    require('catppuccin').setup({
      colorscheme = "mocha",
      background = {
        light = "latte",
        dark = "mocha",
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
