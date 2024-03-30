-- shows available key commands after a keypress
local M = {
	"folke/which-key.nvim",
	enabled = require("config.util").is_enabled("folke/which-key.nvim"),
	config = function()
		require("which-key").setup()

		require("which-key").register({
			["<leader>b"] = { name = "+Buffers" },
			["<leader>c"] = { name = "+Copilot" },
			["<leader>d"] = { name = "+Debug" },
			["<leader>f"] = { name = "+FzF/Float" },
			["<leader>g"] = { name = "+LSP/Diagnostics" },
			["<leader>gw"] = { name = "+Workspace Diagnostics" },
			["<leader>h"] = { name = "+Harpoon/Diffview" },
			["<leader>j"] = { name = "+Session" },
			["<leader>l"] = { name = "+Lazygit" },
			["<leader>n"] = { name = "+NeoTree" },
			["<leader>o"] = { name = "+Conform/Obsidian" },
			["<leader>q"] = { name = "+QuickFix" },
			["<leader>r"] = { name = "+Rename/Resume" },
			["<leader>s"] = { name = "+OpenAPI Browser" },
			["<leader>t"] = { name = "+Tests, Diagnostics" },
			["<leader>u"] = { name = "+Undo" },
			["<leader>w"] = { name = "+Window" },
		})
	end,
}

return M
