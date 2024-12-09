local M = {
	"echasnovski/mini.icons",
	enabled = require("config.util").is_enabled("echasnovski/mini.icons"),
	version = "*",
	config = function()
		local miniicons = require("mini.icons")
		miniicons.setup({})
	end,

}

return M
