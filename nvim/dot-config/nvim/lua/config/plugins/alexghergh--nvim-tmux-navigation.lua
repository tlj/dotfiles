return {
	repo = "alexghergh/nvim-tmux-navigation",
	events = { "UIEnter" },
	settings = {
		disable_when_zoomed = true,
		keybindings = { left = "<C-h>", down = "<C-j>", up = "<C-k>", right = "<C-l>" },
	},
}
