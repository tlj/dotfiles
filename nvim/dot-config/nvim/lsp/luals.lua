vim.lsp.config.luals = {
	cmd = { "lua-language-server" },
	filetypes = { "lua" },
	root_markers = { '.luarc.json', '.luarc.jsonc', '.git' },
	settings = {
		Lua = {
			runtime = {
				version = "LuaJit",
			},
			diagnostics = {
				globals = { "vim" },
			},
			workspace = {
				library = vim.api.nvim_get_runtime_file("", true),
			},
			telemetry = {
				enable = false
			}
		},
	},
}
