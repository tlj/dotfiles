local M = {
  "nvim-telescope/telescope-file-browser.nvim",
  enabled = false,
  dependencies = {
    "nvim-telescope/telescope.nvim",
    "nvim-lua/plenary.nvim",
  },
  keys = {
    {
      "<leader>tt",
      function()
        require("telescope").extensions.file_browser.file_browser()
      end,
      desc = "Explorer NeoTree",
    }
  },
  config =function ()
    require('telescope').load_extension "file_browser"
  end
}

return M
