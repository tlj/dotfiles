local M = {
  "tlj/sapi-preview.nvim",
  dependencies = {
    "kkharji/sqlite.lua",
  },
  config = function()
    require("sapi-preview").setup()
  end,
  keys = {
    { "<leader>sg", "<cmd>SapiGoto<cr>", desc = "Open SAPI endpoints valid for URN on cursor." },
    { "<leader>sr", "<cmd>SapiRecents<cr>", desc = "Open list of recently opened SAPI endpoints." },
    { "<leader>se", "<cmd>SapiEndpoints<cr>", desc = "Open list of endpoints for current package." },
    { "<leader>su", "<cmd>SapiRefresh<cr>", desc = "Refresh list of endpoints for current package from selected base URL." },
    { "<leader>sp", "<cmd>SapiPackage<cr>", desc = "Select a SAPI package." },
    { "<leader>sb", "<cmd>SapiBaseUrl<cr>", desc = "Select a SAPI base URL." },
  },
}

return M
