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
	events = { "BufReadPre", "BufNewFile" },
	settings = {
		highlight = true,
	},
	keys = {
		["<Up>"] = { cmd = "<cmd>Treewalker Up<cr>", desc = "Previous node" },
		["<Down>"] = { cmd = "<cmd>:Treewalker Down<cr>", desc = "Next node" },
		["<Left>"] = { cmd = "<cmd>:Treewalker Left<cr>", desc = "Outer node" },
		["<Right>"] = { cmd = "<cmd>:Treewalker Right<cr>", desc = "Inner node" },
	},
}
