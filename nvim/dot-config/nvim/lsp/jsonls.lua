vim.lsp.config.jsonls = {
	cmd = { "vscode-json-language-server", "--stdio" },
	filetypes = { "json", "jsonc" },
	single_file_support = true,
	init_options = {
		provideFormatter = true,
	},
	settings = {
		json = {
			schemas = require("plugins.config.schemas").jsonls,
			validate = { enable = true },
		},
	},
}
