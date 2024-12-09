local M = {
	{
		"zbirenbaum/copilot.lua",
		enabled = true,
		lazy = true,
		event = "InsertEnter",
		cmd = "Copilot",
		config = function()
			require("copilot").setup({
				suggestion = {
					enabled = false,
					auto_trigger = true,
				},
				panel = { enabled = false },
			})
		end,
		keys = {
			{ "<leader>cp", '<cmd>lua require"copilot.panel".open()<CR>', desc = "Open Copilot" },
		},
	},
}

return M
