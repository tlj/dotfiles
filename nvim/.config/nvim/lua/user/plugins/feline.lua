local M = {
  "feline-nvim/feline.nvim",
  dependencies = {
    {
      "lewis6991/gitsigns.nvim",
      config = function()
        require("gitsigns").setup()
      end,
    },
  },
  config = function()
    require('feline').setup()
    require('feline').winbar.setup()
  end
}

return M
