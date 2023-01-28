local M = {
  "folke/tokyonight.nvim",
  lazy = false,
  priority = 999,
  enabled = false,
  config = function()
    require("tokyonight").setup({
      style = "storm",
    })
  end
}

return M
