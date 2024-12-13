-- Treewalker is a plugin that gives you the ability to move around
-- your code in a syntax tree aware manner. It uses Treesitter under
-- the hood for syntax tree awareness. It offers four subcommands:
-- Up, Down, Right, and Left. Each command moves through the syntax 
-- tree in an intuitive way.
--
-- This is extremely useful for navigating code, but I added it mostly
-- to more easily navigate in JSON files, by moving through nodes quickly.
-- 
-- https://github.com/aaronik/treewalker.nvim
return {
	"aaronik/treewalker.nvim",
	enabled = true,
	lazy = true,
	event = { "BufReadPost" },
	cmd = "Treewalker",
	opts = {
		highlight = true,
	},
	keys = {
		{ "<Up>", ":Treewalker Up<CR>", desc = "Previous node" },
		{ "<Down>", ":Treewalker Down<CR>", desc = "Next node" },
		{ "<Left>", ":Treewalker Left<CR>", desc = "Outer node" },
		{ "<Right>", ":Treewalker Right<CR>", desc = "Inner node" },
	},
}
