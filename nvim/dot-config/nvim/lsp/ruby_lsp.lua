---@type vim.lsp.Config
return {
	cmd = { vim.fn.expand("~/.local/bin/mise"), "x", "--", "ruby-lsp" },
	filetypes = { "ruby", "eruby" },
	root_markers = { ".git", "Gemfile" },
	settings = {
		ruby_lsp = {},
	},
}
