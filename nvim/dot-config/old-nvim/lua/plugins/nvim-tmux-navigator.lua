-- use C-hjkl to navigate between nvim and tmux windows
local M = {
	"alexghergh/nvim-tmux-navigation",
	enabled = require("config.util").is_enabled("alexghergh/nvim-tmux-navigation"),
	event = "VeryLazy",
	config = function()
		local nvim_tmux_navigator = require("nvim-tmux-navigation")
		nvim_tmux_navigator.setup({
			disable_when_zoomed = true,
			keybindings = {
				left = "<C-h>",
				down = "<C-j>",
				up = "<C-k>",
				right = "<C-l>",
			},
		})
	end,
	keys = {
		{ "<C-h>", mode = { "n" }, "<cmd>NvimTmuxNavigateLeft<cr>", desc = "TMux navigate left" },
		{ "<C-j>", mode = { "n" }, "<cmd>NvimTmuxNavigateDown<cr>", desc = "TMux navigate down" },
		{ "<C-k>", mode = { "n" }, "<cmd>NvimTmuxNavigateUp<cr>", desc = "TMux navigate up" },
		{ "<C-l>", mode = { "n" }, "<cmd>NvimTmuxNavigateRight<cr>", desc = "TMux navigate right" },
	},
}

return M
