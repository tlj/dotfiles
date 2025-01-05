-- Nvim Treesitter configurations and abstraction layer
--
-- Provides better syntax highlighting and navigation for other plugins.
--
-- https://github.com/nvim-treesitter/nvim-treesitter
return {
	repo = "nvim-treesitter/nvim-treesitter",
	build = ":TSUpdate",
	setup = function(settings)
		require("nvim-treesitter.configs").setup(settings)
	end,
	settings = {
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
		auto_install = true,
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
	},
}
