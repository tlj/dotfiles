local M = {
  "tlj/endpoint-previewer.nvim",
  dependencies = {
    "kkharji/sqlite.lua",
  },
  dev = true,
  enabled = function ()
    return os.getenv("ENDPOINT_PREVIEWER_URLS") ~= ""
  end,
  config = function()
    require("endpoint-previewer").setup()
  end,
  keys = {
    { "<leader>sg", "<cmd>EndpointGoto<cr>", desc = "Open API endpoints valid for replacement text on cursor." },
    { "<leader>sr", "<cmd>EndpointRecents<cr>", desc = "Open list of recently opened API endpoints." },
    { "<leader>se", "<cmd>EndpointEndpoints<cr>", desc = "Open list of endpoints for current API." },
    { "<leader>su", "<cmd>EndpointRefresh<cr>", desc = "Refresh list of APIs and Endpoints." },
    { "<leader>sa", "<cmd>EndpointAPI<cr>", desc = "Select an API." },
    { "<leader>sd", "<cmd>EndpointSelectEnv<cr>", desc = "Select environment." },
    { "<leader>sx", "<cmd>EndpointSelectRemoteEnv<cr>", desc = "Select remote environment." },
  },
}

return M
