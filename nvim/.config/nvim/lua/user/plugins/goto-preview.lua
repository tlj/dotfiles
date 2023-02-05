local M = {
  "rmagatti/goto-preview",
  keys = {
    { "gp", "<cmd>lua require('goto-preview').goto_preview_definition()<CR>" },
  },
  enabled = false,
  config = function()
    require("goto-preview").setup({})
  end
}

return M
