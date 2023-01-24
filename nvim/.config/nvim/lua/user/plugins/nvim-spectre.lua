local M = {
  "windwp/nvim-spectre",
  keys = {
    { "<leader>fr", function() require("spectre").open() end, desc = "Find/Replace in files (Spectre)"}
  },
  enabled = false,
}

return M
