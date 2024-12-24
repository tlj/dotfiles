---@type vim.lsp.Config
return {
	cmd = { "yarn", "dlx", "yaml-language-server", "--stdio" },
	filetypes = { "yaml", "yaml.docker-compose", "yaml.gitlab" },
	single_file_support = true,
	settings = {
		yaml = {
			format = { enable = true, singleQuote = true },
			validate = true,
			hover = true,
			completion = true,
			schemaStore = {
				enable = true,
				url = "https://www.schemastore.org/api/json/catalog.json",
			},
			schemas = require("config.plugins.schemas").yamlls,
		},
		redhat = {
			telemetry = {
				enabled = false,
			}
		}
	},
}
