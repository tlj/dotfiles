-- Create key bindings that stick. WhichKey helps you remember your Neovim 
-- keymaps, by showing available keybindings in a popup as you type. 
--
-- https://github.com/folke/which-key.nvim
return {
	"folke/which-key.nvim",
	enabled = true,
	event = "VeryLazy",
	opts = {
		defaults = {},
		spec = {
			{ "<leader>b", group = "+Buffers" },
			{ "<leader>c", group = "+Copilot" },
			{ "<leader>d", group = "+Debug" },
			{ "<leader>f", group = "+FzF/Float" },
			{ "<leader>g", group = "+LSP/Diagnostics" },
			{ "<leader>h", group = "+Gitsigns" },
			{ "<leader>gw", group = "+Workspace Diagnostics" },
			{ "<leader>l", group = "+Lazygit" },
			{ "<leader>o", group = "+Conform" },
			{ "<leader>q", group = "+QuickFix" },
			{ "<leader>r", group = "+Rename/Resume" },
			-- { "<leader>s", group = "+OpenAPI Browser" },
			{ "<leader>t", group = "File explorer" },
			-- { "<leader>u", group = "+Undo" },
			{ "<leader>w", group = "+Window" },
		},
	},
	keys = {
		{
			"<leader>?",
			function()
				require("which-key").show({ global = false })
			end,
			desc = "Buffer Keymaps (which-key)",
		},
		{
			"<c-w><space>",
			function()
				require("which-key").show({ keys = "<c-w>", loop = true })
			end,
			desc = "Window Hydra Mode (which-key)",
		},
	},
}
