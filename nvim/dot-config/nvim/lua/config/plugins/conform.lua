return {
	events = { "BufReadPre", "BufNewFile" },
	cmds = { "ConformInfo" },
	settings = {
		log_level = vim.log.levels.DEBUG,
		formatters_by_ft = {
			lua = { "stylua" },
			sh = { "shfmt" },
			markdown = { "mdformat" },
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
			cmd = function() require("conform").format({ async = false, lsp_fallback = false }) end,
			desc = "Format file",
		},
	},
}
