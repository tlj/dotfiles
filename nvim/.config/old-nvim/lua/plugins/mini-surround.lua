local M = {
	"echasnovski/mini.surround",
	enabled = require("config.util").is_enabled("echasnovski/mini.surround"),
	version = "*",
	config = function()
		local minisurround = require("mini.surround")
		minisurround.setup({})
	end,
}

return M
