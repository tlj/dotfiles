local M = {
	{
		"zbirenbaum/copilot.lua",
		enabled = true,
		lazy = true,
		event = "InsertEnter",
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
	-- {
	-- 	"zbirenbaum/copilot-cmp",
	-- 	enabled = require("config.util").is_enabled("zbirenbaum/copilot-cmp"),
	-- 	config = function()
	-- 		require("copilot_cmp").setup()
	-- 	end,
	-- },
}

return M
