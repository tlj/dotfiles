local M = {
  "folke/tokyonight.nvim",
  lazy = false,
  priority = 999,
  enabled = true,
  config = function()
    require("tokyonight").setup({
      style = "storm",
    })
  end
}

return M
