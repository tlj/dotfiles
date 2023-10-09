local M = {
  "zbirenbaum/copilot.lua",
  enabled = true,
  lazy = true,
  event = "InsertEnter",
  config = function()
    require('copilot').setup()
  end,
  keys = {
    { '<leader>cp', '<cmd>lua require"copilot.panel".open()<CR>' },
  }
}

return M
