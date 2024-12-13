-- Move seamlessly between vim and tmux panes with C-h,j,k,l.
--
-- This plugins is a must-have when working with neovim inside of tmux to 
-- simplify the movements between neovim and tmux windows.
--
-- https://github.com/alexghergh/nvim-tmux-navigation
return {
	"alexghergh/nvim-tmux-navigation",
	enabled = true,
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
