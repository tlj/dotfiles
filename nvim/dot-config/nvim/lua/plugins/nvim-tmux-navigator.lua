-- Move seamlessly between vim and tmux panes with C-h,j,k,l.
--
-- This plugins is a must-have when working with neovim inside of tmux to 
-- simplify the movements between neovim and tmux windows.
--
-- https://github.com/alexghergh/nvim-tmux-navigation
require("nvim-tmux-navigation").setup({
	disable_when_zoomed = true,
	keybindings = { left = "<C-h>", down = "<C-j>", up = "<C-k>", right = "<C-l>" },
})

