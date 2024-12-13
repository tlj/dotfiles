local M = {
	"luukvbaal/statuscol.nvim",
	enabled = require("config.util").is_enabled("luukvbaal/statuscol.nvim"),
	config = function()
		require("statuscol").setup({
			setopt = true,
			foldfunc = "builtin",
		})
	end,
}

return M
