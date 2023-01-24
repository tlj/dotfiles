local M = {
  'nvim-lualine/lualine.nvim',
  dependencies = {
    'Isrothy/lualine-diagnostic-message',
  },
  config = function ()
    require('lualine').setup({
      sections = {
        lualine_c = {
          "diagnostic-message",
        }
      }
    })
  end
}

return M
