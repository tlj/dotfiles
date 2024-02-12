local M = {
	"tlj/api-browser.nvim",
	dependencies = {
		"kkharji/sqlite.lua",
	},
	lazy = true,
	cmd = "ApiBrowser",
	version = "*",
	dev = true,
	enabled = require("config.util").is_enabled("tlj/api-browser.nvim"),
	config = function()
		require("api-browser").setup({
			ripgrep = {
				command = "rg -l -g '*.yaml' -g '*.json' -e \"openapi.*3\"",
				no_ignore = true,
			},
		})
	end,
	keys = {
		{
			"<leader>sg",
			"<cmd>ApiBrowser endpoints_with_param<cr>",
			desc = "Open API endpoints valid for replacement text on cursor.",
		},
		{ "<leader>sr", "<cmd>ApiBrowser recents<cr>", desc = "Open list of recently opened API endpoints." },
		{ "<leader>se", "<cmd>ApiBrowser endpoints<cr>", desc = "Open list of endpoints for current API." },
		{ "<leader>sa", "<cmd>ApiBrowser open<cr>", desc = "Select an API." },
		{ "<leader>sd", "<cmd>ApiBrowser select_local_server<cr>", desc = "Select environment." },
		{ "<leader>sx", "<cmd>ApiBrowser select_remote_server<cr>", desc = "Select remote environment." },
	},
}

return M
