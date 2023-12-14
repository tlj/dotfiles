local function session_name()
  local session = require('nvim-possession').status()
  return session or ''
end

-- better status line
local M = {
  'nvim-lualine/lualine.nvim',
  dependencies = {
    'Isrothy/lualine-diagnostic-message',
  },
  config = function ()
    require('lualine').setup({
      options = {
        theme = 'catppuccin',
        component_separators = "",
        section_separators = { left = "", right = "" },
      },
      sections = {
        lualine_a = {
          session_name,
        },
        lualine_c = {
          "diagnostic-message",
        }
      }
    })
  end
}

return M
