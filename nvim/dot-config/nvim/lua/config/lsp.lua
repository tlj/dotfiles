-- Enable a list of LSPs  which we have pre-installed on the system
-- and have configuration for in the lsp/ folder.
if vim.fn.has("nvim-0.11") == 1 then
	vim.lsp.enable({ "luals", "gopls", "yamlls", "jsonls", "intelephense" })

	-- Set global LSP configuration defaults for all language servers (* matches
	-- all)
	-- This only works in Neovim v0.11.0+
	local have_cmp, cmp_nvim_lsp = pcall(require, "cmp_nvim_lsp")
	if have_cmp then
		vim.lsp.config("*", {
			-- Merge capabilities with the default ones from nvim-cmp LSP
			capabilities = vim.tbl_deep_extend("force", {
				textDocument = {
					semanticTokens = {
						multilineTokenSupport = true,
					},
				},
			}, require("cmp_nvim_lsp").default_capabilities()),

			-- Set root directory markers for LSP workspace
			-- In this case, looking for .git directory as project root
			root_markers = { ".git" },
		})
	else
		vim.notify("cmp_nvim_lsp not loaded, not aded to LSP capabilities.")
	end
else
	vim.notify("LSP not enabled because of nvim < 0.11")
end

-- Create autocommands for setting up keymaps and diagnostics when
-- the LSP has been loaded.
local lspgroup = vim.api.nvim_create_augroup("lsp", { clear = true })
vim.api.nvim_create_autocmd("LspAttach", {
	group = lspgroup,
	callback = function(args)
		-- Get the detaching client
		local bufnr = args.buf

		-- Set up keymaps
		vim.keymap.set(
			"n",
			"gd",
			"<cmd>Pick lsp scope='definition'<cr>",
			{ buffer = bufnr, desc = "Jump to definition" }
		)
		vim.keymap.set(
			"n",
			"gD",
			"<cmd>Pick lsp scope='declaration'<cr>",
			{ buffer = bufnr, desc = "Fzf Jump to declaration" }
		)
		vim.keymap.set(
			"n",
			"gi",
			"<cmd>Pick lsp scope='implementation'<cr>",
			{ buffer = bufnr, desc = "Pick Implementations" }
		)
		vim.keymap.set(
			"n",
			"gr",
			"<cmd>Pick lsp scope='references'<cr>",
			{ buffer = bufnr, desc = "Pick References" }
		)
		vim.keymap.set(
			"n",
			"gl",
			'<cmd>lua vim.diagnostic.open_float(0, { scope = "line" })<cr>',
			{ buffer = bufnr, desc = "Show diagnostics" }
		)
		vim.keymap.set(
			"n",
			"<leader>rn",
			"<cmd>lua vim.lsp.buf.rename()<cr>",
			{ buffer = bufnr, desc = "Rename" }
		)
		vim.keymap.set(
			"n",
			"<leader>ga",
			"<cmd>lua vim.lsp.buf.code_action()<cr>",
			{ buffer = bufnr, desc = "Code actions" }
		)

		-- Set up diagnostics
		local signs = require("config.icons").lsp.diagnostic.signs
		local diagnostic_config = {
			virtual_text = false,
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
