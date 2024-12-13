local M = {
	"echasnovski/mini.ai",
	enabled = require("config.util").is_enabled("echasnovski/mini.ai"),
	version = "*",
	config = function()
		local miniai = require("mini.ai")
		miniai.setup({})
	end,
}

return M
