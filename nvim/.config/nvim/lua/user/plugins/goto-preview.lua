local M = {
  "rmagatti/goto-preview",
  keys = {
    { "<leader>gp", "<cmd>lua require('goto-preview').goto_preview_definition()<CR>" },
  },
  enabled = true,
  config = function()
    require("goto-preview").setup({})
  end
}

return M
