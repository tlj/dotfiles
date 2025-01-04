return {
	repo = "stevearc/oil.nvim",
	settings = {},
	cmds = { "Oil" },
	requires = { "nvim-tree/nvim-web-devicons" },
	setup = function(settings) require("oil").setup(settings) end,
	keys = {
		["<leader>tt"] = {
			cmd = function() require("oil").open_float() end,
			desc = "Oil file explorer",
		},
	},
}
