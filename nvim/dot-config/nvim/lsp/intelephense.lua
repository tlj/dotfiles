---@type vim.lsp.Config
return {
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
