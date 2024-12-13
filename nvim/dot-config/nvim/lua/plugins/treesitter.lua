-- Nvim Treesitter configurations and abstraction layer 
--
-- Provides better syntax highlighting and navigation for other plugins.
--
-- https://github.com/nvim-treesitter/nvim-treesitter
return {
	"nvim-treesitter/nvim-treesitter",
	enabled = true,
	build = ":TSUpdate",
	event = { "BufReadPre", "BufNewFile" },
	dependencies = {
		"nvim-treesitter/nvim-treesitter-textobjects",
	},
	cmd = { "TSInstall", "TSUpdate" },
	config = function()
		require("nvim-treesitter.configs").setup({
			ensure_installed = {
				"bash",
				"comment",
				"gitignore",
				"go",
				"gowork",
				"gomod",
				"gosum",
				"gotmpl",
				"help",
				"html",
				"javascript",
				"json",
				"lua",
				"markdown",
				"markdown_inline",
				"php",
				"sql",
				"yaml",
				"vim",
				"ruby",
			}, -- one of "all", "language", or a list of languages
			highlight = {
				enable = true, -- false will disable the whole extension
				disable = {}, -- list of language that will be disabled
			},
			sync_install = false,
			auto_install = false,
			ignore_install = { "help" },
			indent = { enable = true },
			incremental_selection = {
				enable = true,
				keymaps = {
					init_selection = "<C-space>",
					node_incremental = "<C-space>",
					scope_incremental = false,
					node_decremental = "<bs>",
				},
			},
		})
	end,
}
