local M = {
  "rebelot/kanagawa.nvim",
  lazy = false,
  priority = 999,
  enabled = true,
  config = function()
    require 'kanagawa' .load()
  end
}

return M
