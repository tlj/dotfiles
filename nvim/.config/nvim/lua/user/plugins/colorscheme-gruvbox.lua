local M = {
  'ellisonleao/gruvbox.nvim',
  lazy = false,
  priority = 999,
  enabled = true,
  config = function()
    require 'gruvbox' .load()
  end
}

return M
