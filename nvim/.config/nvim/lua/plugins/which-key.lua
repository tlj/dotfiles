-- shows available key commands after a keypress
local M = {
	"folke/which-key.nvim",
	enabled = require("config.util").is_enabled("folke/which-key.nvim"),
	opts = {},
	keys = {
		{ "<leader>b", group = "+Buffers" },
		{ "<leader>c", group = "+Copilot" },
		{ "<leader>d", group = "+Debug" },
		{ "<leader>f", group = "+FzF/Float" },
		{ "<leader>g", group = "+LSP/Diagnostics" },
		{ "<leader>gw", group = "+Workspace Diagnostics" },
		{ "<leader>h", group = "+Harpoon/Diffview" },
		{ "<leader>j", group = "+Session" },
		{ "<leader>l", group = "+Lazygit" },
		{ "<leader>n", group = "+NeoTree" },
		{ "<leader>o", group = "+Conform/Obsidian" },
		{ "<leader>q", group = "+QuickFix" },
		{ "<leader>r", group = "+Rename/Resume" },
		{ "<leader>s", group = "+OpenAPI Browser" },
		{ "<leader>t", group = "+Tests, Diagnostics" },
		{ "<leader>u", group = "+Undo" },
		{ "<leader>w", group = "+Window" },
	},
}

return M
