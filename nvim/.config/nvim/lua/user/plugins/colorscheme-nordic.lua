local M = {
  'AlexvZyl/nordic.nvim',
  lazy = false,
  priority = 999,
  enabled = true,
  config = function()
    require 'nordic' .load()
  end
}

return M
