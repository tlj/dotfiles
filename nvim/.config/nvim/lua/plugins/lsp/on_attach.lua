local function on_attach(_, bufnr)
	local bufmap = function(mode, lhs, rhs, desc)
		local opts = { buffer = bufnr, desc = desc }
		vim.keymap.set(mode, lhs, rhs, opts)
	end

	-- Jump to the definition
	bufmap("n", "gd", "<cmd>FzfLua lsp_definitions<cr>", "Fzf Jump to definition")
	-- Jump to declaration
	bufmap("n", "gD", "<cmd>FzfLua lsp_declarations<cr>", "Fzf Jump to declaration")
	-- Lists all the implementations for the symvol under the cursor
	bufmap("n", "gi", "<cmd>FzfLua lsp_implementations<cr>", "Fzf Implementations")
	-- Lists all the references
	bufmap("n", "gr", "<cmd>FzfLua lsp_references<cr>", "Fzf References")
	-- Open a telescope window with diagnostics
	bufmap("n", "<leader>gl", "<cmd>FzfLua diagnostics_document<cr>", "Fzf Document Diagnostics")
	-- Lists all the symbols in the current buffer
	bufmap("n", "<leader>gt", '<cmd>lua require("lsp_lines").toggle()<cr>', "Toggle LSP Lines")
	-- Show diagnos)tics in a floating window
	bufmap("n", "gl", '<cmd>lua vim.diagnostic.open_float(0, { scope = "line" })<cr>', "Show diagnostics")
	-- Breadcrumb like navigation
	bufmap("n", "<Leader>go", ":Navbuddy<cr>", "Navbuddy")
	-- Selects a code action available at the current cursor position
	-- bufmap({ "n", "v", "x" }, "<leader>ca", "<cmd>CodeActionMenu<cr>", "Code Action Menu")
	-- Hover doc
	-- redefined in ufo
	--bufmap('n', 'K', '<cmd>lua vim.lsp.buf.signature_help()<cr>', 'Signature Help')

	bufmap("n", "<leader>rn", "<cmd>lua vim.lsp.buf.rename()<cr>", "Rename")

	-- add a border to the LSP floating window
	vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, { border = "single" })
	vim.lsp.handlers["textDocument/publishDiagnostics"] = vim.lsp.with(vim.lsp.diagnostic.on_publish_diagnostics, {
		virtual_text = false,
	})
	vim.diagnostic.config({ virtual_text = false, update_in_insert = false })
end

return {
	on_attach = on_attach,
}
