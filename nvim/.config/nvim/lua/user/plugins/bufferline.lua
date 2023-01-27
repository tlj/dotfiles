local M = {
  'akinsho/bufferline.nvim',
  event = "VeryLazy",
  dependencies = {
    'nvim-tree/nvim-web-devicons'
  },
  enabled = false,
  config = function ()
    require('bufferline').setup({
      options = {
        diagnostics = "nvim_lsp",
        separator_style = "slant",
        always_show_bufferline = false,
        diagnostics_indicator = function(count, level, _, _)
          local icon = level:match("error") and " " or " "
          return " " .. icon .. count
        end,
        offsets = {
          {
            filetype = "neo-tree",
            text = "Neo-tree",
            highlight = "Directory",
            text_align = "left",
          },
        },
      }
    })
  end
}

return M
