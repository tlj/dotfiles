local M = {
  "tlj/endpoint-previewer.nvim",
  dependencies = {
    "kkharji/sqlite.lua",
  },
  config = function()
    require("endpoint-previewer").setup()
  end,
  keys = {
    { "<leader>sg", "<cmd>EndpointGoto<cr>", desc = "Open SAPI endpoints valid for URN on cursor." },
    { "<leader>sr", "<cmd>EndpointRecents<cr>", desc = "Open list of recently opened SAPI endpoints." },
    { "<leader>se", "<cmd>EndpointEndpoints<cr>", desc = "Open list of endpoints for current package." },
    { "<leader>su", "<cmd>EndpointRefresh<cr>", desc = "Refresh list of endpoints for current package from selected base URL." },
    { "<leader>sp", "<cmd>EndpointAPI<cr>", desc = "Select an API." },
    { "<leader>sb", "<cmd>EndpointBaseUrl<cr>", desc = "Select a SAPI base URL." },
  },
}

return M
