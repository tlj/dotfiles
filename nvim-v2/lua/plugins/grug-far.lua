-- Search and replace plugin
local M = {
	"MagicDuck/grug-far.nvim",
	enabled = true,
	lazy = true,
	cmd = "GrugFar",
	keys = {
		{
			"<leader>rs",
			function()
				local grug = require("grug-far")
				local ext = vim.bo.buftype == "" and vim.fn.expand("%:e")
				grug.grug_far({
					transient = true,
					prefills = {
						filesFilter = ext and ext ~= "" and "*." .. ext or nil,
					}
				})
			end,
			mode = { "n", "v" },
			desc = "Search and replace",
		}
	},
	config = function()
		require("grug-far").setup({
			headerMaxWidth = 80,
		})
	end,
}

return M

