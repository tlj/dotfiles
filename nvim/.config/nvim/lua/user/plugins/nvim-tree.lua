local M = {
  "nvim-tree/nvim-tree.lua",
  keys = {
    { "<leader>tt", '<cmd>NvimTreeToggle<cr>', desc = "Nvim-Tree" },
  },
  dependencies = {
    "nvim-tree/nvim-web-devicons",
  },
  config = function()
    require('nvim-tree').setup()
  end
}

return M
