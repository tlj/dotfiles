-- A vim-vinegar like file explorer that lets you edit your filesystem like a 
-- normal Neovim buffer.
--
-- I prefer this to navigating/editing the filesystem through a tree 
-- navigator, and it fits my workflow perfectly.
--
-- https://github.com/stevearc/oil.nvim
plugin("oil", {
	commands = { "Oil" },
	before = { "nvim-web-devicons" },
	setup = function()
		require("oil").setup()
	end,
	keys = {
		["<leader>tt"] = {
			cmd = function()
				require("oil").open_float()
			end,
			desc = "Oil file explorer",
		},
	},
})

