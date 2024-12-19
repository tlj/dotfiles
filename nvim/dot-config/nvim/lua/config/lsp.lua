vim.lsp.config("*", {
	capabilities = vim.tbl_deep_extend("force", {
		textDocument = {
			semanticTokens = {
				multilineTokenSupport = true,
			},
		},
	}, require("blink.cmp").get_lsp_capabilities()),
	root_markers = { ".git" },
})

-- vim.lsp.enable({ "luals", "gopls", "jsonls", "yamlls", "intelephense" })
vim.lsp.enable({ "luals", "gopls", "yamlls", "jsonls" })

local lspgroup = vim.api.nvim_create_augroup("lsp", { clear = true })
vim.api.nvim_create_autocmd("LspAttach", {
	group = lspgroup,
	callback = function(args)
		-- Get the detaching client
		local bufnr = args.buf

		vim.keymap.set(
			"n",
			"gd",
			"<cmd>FzfLua lsp_definitions<cr>",
			{ buffer = bufnr, desc = "Fzf Jump to definition" }
		)
		vim.keymap.set(
			"n",
			"gD",
			"<cmd>FzfLua lsp_declarations<cr>",
			{ buffer = bufnr, desc = "Fzf Jump to declaration" }
		)
		vim.keymap.set(
			"n",
			"gi",
			"<cmd>FzfLua lsp_implementations<cr>",
			{ buffer = bufnr, desc = "Fzf Implementations" }
		)
		vim.keymap.set("n", "gr", "<cmd>FzfLua lsp_references<cr>", { buffer = bufnr, desc = "Fzf References" })
		vim.keymap.set(
			"n",
			"gl",
			'<cmd>lua vim.diagnostic.open_float(0, { scope = "line" })<cr>',
			{ buffer = bufnr, desc = "Show diagnostics" }
		)
		vim.keymap.set("n", "<leader>rn", "<cmd>lua vim.lsp.buf.rename()<cr>", { buffer = bufnr, desc = "Rename" })

		local signs = require("config.icons").lsp.diagnostic.signs
		local diagnostic_config = {
			virtual_text = true,
			underline = true,
			update_in_insert = false,
			float = {
				border = "single",
			},
			signs = {
				text = {
					[vim.diagnostic.severity.ERROR] = signs.Error,
					[vim.diagnostic.severity.WARN] = signs.Warn,
					[vim.diagnostic.severity.HINT] = signs.Hint,
					[vim.diagnostic.severity.INFO] = signs.Info,
				},
				numhl = {
					[vim.diagnostic.severity.ERROR] = "DiagnosticSignError",
					[vim.diagnostic.severity.WARN] = "DiagnosticSignWarn",
					[vim.diagnostic.severity.HINT] = "DiagnosticSignHint",
					[vim.diagnostic.severity.INFO] = "DiagnosticSignInfo",
				},
				texthl = {
					[vim.diagnostic.severity.ERROR] = "DiagnosticSignError",
					[vim.diagnostic.severity.WARN] = "DiagnosticSignWarn",
					[vim.diagnostic.severity.HINT] = "DiagnosticSignHint",
					[vim.diagnostic.severity.INFO] = "DiagnosticSignInfo",
				},
				linehl = {}, -- No line highlighting
			},
		}

		vim.diagnostic.config(diagnostic_config)
		vim.lsp.handlers["textDocument/publishDiagnostics"] =
			vim.lsp.with(vim.lsp.diagnostic.on_publish_diagnostics, diagnostic_config)
		vim.lsp.handlers["workspace/diagnostic/refresh"] = function(_, _, ctx)
			local ns = vim.lsp.diagnostic.get_namespace(ctx.client_id)
			pcall(vim.diagnostic.reset, ns)
			return true
		end
	end,
})

