local function on_attach(_, bufnr)
	local bufmap = function(mode, lhs, rhs, desc)
		local opts = { buffer = bufnr, desc = desc }
		vim.keymap.set(mode, lhs, rhs, opts)
	end

	bufmap("n", "gd", "<cmd>FzfLua lsp_definitions<cr>", "Fzf Jump to definition")
	bufmap("n", "gD", "<cmd>FzfLua lsp_declarations<cr>", "Fzf Jump to declaration")
	bufmap("n", "gi", "<cmd>FzfLua lsp_implementations<cr>", "Fzf Implementations")
	bufmap("n", "gr", "<cmd>FzfLua lsp_references<cr>", "Fzf References")
	bufmap("n", "gl", '<cmd>lua vim.diagnostic.open_float(0, { scope = "line" })<cr>', "Show diagnostics")
	bufmap("n", "<leader>rn", "<cmd>lua vim.lsp.buf.rename()<cr>", "Rename")

	local signs = require("config.icons").lsp.diagnostic.signs
	vim.diagnostic.config({
		virtual_text = false,
		underline = true,
		update_in_insert = false,
		float = {
			border = 'single',
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
	})
end

return {
	on_attach = on_attach,
}
