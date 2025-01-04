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
	repo = "aaronik/treewalker.nvim",
	events = { "BufReadPre", "BufNewFile" },
	settings = {
		highlight = true,
	},
	setup = function(settings) require("treewalker").setup(settings) end,
	keys = {
		["<Up>"] = { cmd = "<cmd>Treewalker Up<cr>", desc = "Previous node" },
		["<Down>"] = { cmd = "<cmd>:Treewalker Down<cr>", desc = "Next node" },
		["<Left>"] = { cmd = "<cmd>:Treewalker Left<cr>", desc = "Outer node" },
		["<Right>"] = { cmd = "<cmd>:Treewalker Right<cr>", desc = "Inner node" },
		["<S-Up>"] = { cmd = "<cmd>Treewalker SwapUp<cr>", desc = "Swap with previous node" },
		["<S-Down>"] = { cmd = "<cmd>:Treewalker SwapDown<cr>", desc = "Swap with next node" },
		["<S-Left>"] = { cmd = "<cmd>:Treewalker SwapLeft<cr>", desc = "Swap with left node" },
		["<S-Right>"] = { cmd = "<cmd>:Treewalker SwapRight<cr>", desc = "Swap with right node" },
	},
}
