-- remove buffers
local M = {
	"echasnovski/mini.bufremove",
	enabled = require("config.util").is_enabled("echasnovski/mini.bufremove"),
	keys = {
		{
			"<leader>bd",
			function()
				require("mini.bufremove").delete(0, false)
			end,
			desc = "Delete Buffer",
		},
		{
			"<leader>bD",
			function()
				require("mini.bufremove").delete(0, true)
			end,
			desc = "Delete Buffer (Force)",
		},
	},
}

return M
