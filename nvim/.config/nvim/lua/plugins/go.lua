return {
	"ray-x/go.nvim",
	enabled = true,
	dependencies = { -- optional packages
		"neovim/nvim-lspconfig",
		"nvim-treesitter/nvim-treesitter",
	},
	config = function()
		require("go").setup()
	end,
	lazy = true,
	event = { "BufReadPre" },
	ft = { "go", "gomod" },
	build = ':lua require("go.install").update_all_sync()', -- if you need to install/update all binaries
}
