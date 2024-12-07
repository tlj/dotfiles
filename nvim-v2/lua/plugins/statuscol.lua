local M = {
	"luukvbaal/statuscol.nvim",
	enabled = true,
	config = function()
		require("statuscol").setup({
			setopt = true,
			foldfunc = "builtin",
		})
	end,
}

return M

