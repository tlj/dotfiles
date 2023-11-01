-- shows available key commands after a keypress
local M = {
  "folke/which-key.nvim",
  enabled = true,
  config = function()
    require("which-key").setup()
  end
}

return M
