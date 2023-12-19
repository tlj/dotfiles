local M = {
	{
		"zbirenbaum/copilot.lua",
		enabled = true,
		lazy = true,
		event = "InsertEnter",
		config = function()
			require("copilot").setup({
				suggestion = { enabled = false },
				panel = { enabled = false },
			})
		end,
		keys = {
			{ "<leader>cp", '<cmd>lua require"copilot.panel".open()<CR>' },
		},
	},
	{
		"zbirenbaum/copilot-cmp",
		config = function()
			require("copilot_cmp").setup()
		end,
	},
}

return M
