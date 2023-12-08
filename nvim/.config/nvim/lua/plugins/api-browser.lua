local M = {
  "tlj/api-browser.nvim",
  dependencies = {
    "kkharji/sqlite.lua",
  },
  version = "*",
  dev = true,
  enabled = function ()
    return true
    -- return os.getenv("NVIM_API_BROWSER_URLS") ~= ""
  end,
  config = function()
    require("api-browser").setup()
  end,
  keys = {
    { "<leader>sg", "<cmd>ApiBrowserGoto<cr>", desc = "Open API endpoints valid for replacement text on cursor." },
    { "<leader>sr", "<cmd>ApiBrowserRecents<cr>", desc = "Open list of recently opened API endpoints." },
    { "<leader>se", "<cmd>ApiBrowserEndpoints<cr>", desc = "Open list of endpoints for current API." },
    { "<leader>su", "<cmd>ApiBrowserRefresh<cr>", desc = "Refresh list of APIs and Endpoints." },
    { "<leader>sa", "<cmd>ApiBrowserAPI<cr>", desc = "Select an API." },
    { "<leader>sd", "<cmd>ApiBrowserSelectEnv<cr>", desc = "Select environment." },
    { "<leader>sx", "<cmd>ApiBrowserSelectRemoteEnv<cr>", desc = "Select remote environment." },
  },
}

return M
