return {
	settings = {},
	requires = { "nvim-tree/nvim-web-devicons" },
	keys = {
		["<leader>tt"] = {
			cmd = function() require("oil").open_float() end,
			desc = "Oil file explorer",
		},
	},
}
