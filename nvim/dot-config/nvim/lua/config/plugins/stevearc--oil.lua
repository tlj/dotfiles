return {
	repo = "stevearc/oil.nvim",
	settings = {
		float = {
			max_width = 90,
			max_height = 30,
		},
	},
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
