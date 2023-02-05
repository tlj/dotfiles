local M = {
  "windwp/nvim-spectre",
  keys = {
    { "<leader>fr", function() require("spectre").open() end, desc = "Find/Replace in files (Spectre)" },
    { "<leader>fw", '<cmd>lua require("spectre").open_visual({select_word=true})<cr>', desc = "Find/Replace current word in files." },
    { "<leader>fc", 'viw:lua require("spectre").open_file_search()<cr>', desc = 'Search in current file.' },
  },
  enabled = true,
}

return M
