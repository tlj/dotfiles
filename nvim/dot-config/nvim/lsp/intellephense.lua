vim.lsp.config.intelephense = {
	cmd = { "intelephense", "--stdio" },
	filetypes = { "php" },
	settings = {
		intelephense = {
			telemetry = {
				enabled = false,
			},
		},
	},
}
