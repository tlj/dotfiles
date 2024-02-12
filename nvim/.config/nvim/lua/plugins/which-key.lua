-- shows available key commands after a keypress
local M = {
	"folke/which-key.nvim",
	enabled = require("config.util").is_enabled("folke/which-key.nvim"),
	config = function()
		require("which-key").setup()
	end,
}

return M
