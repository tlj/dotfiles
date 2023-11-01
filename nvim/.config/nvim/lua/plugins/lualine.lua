-- better status line
local M = {
  'nvim-lualine/lualine.nvim',
  dependencies = {
    'Isrothy/lualine-diagnostic-message',
  },
  config = function ()
    require('lualine').setup({
      options = {
        theme = 'gruvbox-material',
      },
      sections = {
        lualine_c = {
          "diagnostic-message",
        }
      }
    })
  end
}

return M
