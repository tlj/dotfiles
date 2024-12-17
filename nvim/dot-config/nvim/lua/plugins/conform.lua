-- Lightweight yet powerful formatter plugin for Neovim
--
-- Formatting through LSP doesn't always work properly, so I use this plugin
-- to define external formatters for various filetypes. Use <Leader>oo to 
-- trigger formatting. I will usually not enable format_on_save, as it causes
-- changes to existing files, which could be confusing in git blame.
--
-- https://github.com/stevearc/conform.nvim
plugin("conform", {
	commands = { "ConformInfo" },
	events = { "BufWritePre", "BufWritePost" },
	setup = function()
		require("conform").setup({
			formatters_by_ft = {
				lua = { "stylua" },
				sh = { "shfmt" },
			},
			formatters = {
				shfmt = { preprend_args = { "-i", "2" } },
			},
		})
		vim.o.formatexpr = "v:lua.require'conform'.formatexpr()"
	end,
	keys = {
		["<leader>oo"] = {
			cmd = function()
				require("conform").format({ async = true, lsp_fallback = true })
			end,
			desc = "Format file",
		},
	},
})

