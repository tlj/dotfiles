return {
	settings = {
		formatters_by_ft = {
			lua = { "stylua" },
			sh = { "shfmt" },
		},
		formatters = {
			shfmt = { preprend_args = { "-i", "2" } },
		},
	},
	setup = function()
		vim.o.formatexpr = "v:lua.require'conform'.formatexpr()"
	end,
}
