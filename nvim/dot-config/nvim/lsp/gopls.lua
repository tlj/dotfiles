---@type vim.lsp.Config
return {
	cmd = { "gopls" },
	filetypes = { "go", "gotempl", "gowork", "gomod" },
	settings = {
		gopls = {
			analyses = {
				unusedparams = true,
				nillness = true,
				unusedwrites = true,
				useany = true,
				unusedvariable = true,
			},
			completeUnimported = true,
			staticcheck = true,
			buildFlags = { "-tags=integration,e2e" },
			linksInHover = true,
			codelenses = {
				generate = true,
				gc_details = true,
				test = true,
				tidy = true,
				run_vulncheck_exp = true,
				upgrade_dependency = true,
			},
			usePlaceholders = true,
			directoryFilters = {
				"-**/node_modules",
				"-/tmp",
			},
			completionDocumentation = true,
			deepCompletion = true,
			semanticTokens = true,
			verboseOutput = false, -- useful for debugging when true.
			matcher = "Fuzzy", -- default
			diagnosticsDelay = "500ms",
			symbolMatcher = "Fuzzy", -- default is FastFuzzy
			templateExtensions = { ".tmpl" },
		},
	},
}

