return {
	settings = {},
	keys = {
		["<leader>tt"] = {
			cmd = function()
				require("oil").open_float()
			end,
			desc = "Oil file explorer",
		},
	},
}
