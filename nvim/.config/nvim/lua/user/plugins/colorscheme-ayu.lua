local M = {
  "Shatur/neovim-ayu",
  lazy = false,
  priority = 999,
  enabled = true,
  config = function()
    require 'ayu' .setup({})
  end
}

return M
