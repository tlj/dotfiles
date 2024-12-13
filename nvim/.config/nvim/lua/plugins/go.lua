-- A modern go neovim plugin based on treesitter, nvim-lsp and dap debugger.
-- It is written in Lua and async as much as possible.
--
-- Provides a lot of functionality for Go programming. To be honest I am not
-- sure if I actually use any of it at the moment, as I use the LSP for most
-- things. Will have to look more into this one.
--
-- https://github.com/ray-x/go.nvim
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
