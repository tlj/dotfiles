return {
	events = { "BufReadPre", "BufNewFile" },
	cmd = { "ConformInfo" },
	settings = {
		formatters_by_ft = {
			lua = { "stylua" },
			sh = { "shfmt" },
		},
		formatters = {
			shfmt = { preprend_args = { "-i", "2" } },
		},
	},
	setup = function(opts)
		require("conform").setup(opts)
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
}
