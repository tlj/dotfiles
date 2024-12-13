local M = {
	"echasnovski/mini.cursorword",
	enabled = require("config.util").is_enabled("echasnovski/mini.cursorword"),
	version = "*",
	config = function()
		local minicword = require("mini.cursorword")
		minicword.setup({})
	end,
}

return M
