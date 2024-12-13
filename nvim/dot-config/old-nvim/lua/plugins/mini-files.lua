local M = {
	"echasnovski/mini.files",
	enabled = require("config.util").is_enabled("echasnovski/mini.files"),
	version = "*",
	keys = {
		{
			"<leader>tt",
			function()
				require("mini.files").open()
			end,
			desc = "Mini files",
		},
	},
	config = function()
		local minifiles = require("mini.files")
		minifiles.setup({
			windows = {
				preview = true
			}
		})
	end,
}

return M
