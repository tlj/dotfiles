-- Grug find! Grug replace! Grug happy!
--
-- Great plugin for search and replace across multiple files with live
-- preview. Easy to use, great name.
--
-- https://github.com/MagicDuck/grug-far.nvim
plugin("grug-far", {
	commands = { "GrugFar" },
	keys = {
		["<leader>rs"] = {
			cmd = function()
				local grug = require("grug-far")
				local ext = vim.bo.buftype == "" and vim.fn.expand("%:e")
				grug.grug_far({
					transient = true,
					prefills = {
						filesFilter = ext and ext ~= "" and "*." .. ext or nil,
					},
				})
			end,
			mode = { "n", "v" },
			desc = "Search and replace",
		},
	},
	setup = function()
		require("grug-far").setup({
			headerMaxWidth = 80,
		})
	end,
})
