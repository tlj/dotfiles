-- Lightweight yet powerful formatter plugin for Neovim
--
-- Formatting through LSP doesn't always work properly, so I use this plugin
-- to define external formatters for various filetypes. Use <Leader>oo to 
-- trigger formatting. I will usually not enable format_on_save, as it causes
-- changes to existing files, which could be confusing in git blame.
--
-- https://github.com/stevearc/conform.nvim
return {
	"stevearc/conform.nvim",
	event = { "BufWritePre" },
	cmd = { "ConformInfo" },
	enabled = true,
	lazy = true,
	keys = {
		{
			-- Customize or remove this keymap to your liking
			"<leader>oo",
			function()
				require("conform").format({ async = true, lsp_fallback = true })
			end,
			mode = "",
			desc = "Format buffer",
		},
	},
	-- Everything in opts will be passed to setup()
	config = function()
		require("conform").setup({
			-- Define your formatters
			formatters_by_ft = {
				lua = { "stylua" },
				sh = { "shfmt" },
			},
			-- Set up format-on-save
			-- format_on_save = { timeout_ms = 500, lsp_fallback = true },
			-- Customize formatters
			formatters = {
				shfmt = {
					prepend_args = { "-i", "2" },
				},
			},
		})
	end,
	init = function()
		-- If you want the formatexpr, here is the place to set it
		vim.o.formatexpr = "v:lua.require'conform'.formatexpr()"
	end,
}
