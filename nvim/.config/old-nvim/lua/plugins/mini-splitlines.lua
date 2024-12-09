local M = {
	"echasnovski/mini.splitjoin",
	enabled = require("config.util").is_enabled("echasnovski/mini.splitjoin"),
	version = "*",
	opts = {},
	config = function(_, opts)
		require("mini.splitjoin").setup(opts)
	end,
}

return M
