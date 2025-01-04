return {
	repo = "alexghergh/nvim-tmux-navigation",
	events = { "UIEnter" },
	settings = {
		disable_when_zoomed = true,
		keybindings = { left = "<C-h>", down = "<C-j>", up = "<C-k>", right = "<C-l>" },
	},
	setup = function(settings) require("nvim-tmux-navigation").setup(settings) end,
}
