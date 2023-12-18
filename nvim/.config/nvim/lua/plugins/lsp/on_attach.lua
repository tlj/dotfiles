local function on_attach(_, bufnr)
  local bufmap = function(mode, lhs, rhs)
    local opts = { buffer = bufnr }
    vim.keymap.set(mode, lhs, rhs, opts)
  end

  -- Jump to the definition
  bufmap('n', 'gd', '<cmd>FzfLua lsp_definitions<cr>')
  -- Jump to declaration
  bufmap('n', 'gD', '<cmd>FzfLua lsp_declarations<cr>')
  -- Lists all the implementations for the symvol under the cursor
  bufmap('n', 'gi', '<cmd>FzfLua lsp_implementations<cr>')
  -- Lists all the references
  bufmap('n', 'gr', '<cmd>FzfLua lsp_references<cr>')
  -- Open a telescope window with diagnostics
  bufmap('n', '<leader>gl', '<cmd>FzfLua diagnostics_document<cr>')
  -- Lists all the symbols in the current buffer
  bufmap('n', '<leader>tl', '<cmd>lua require("lsp_lines").toggle()<cr>')
  -- Show diagnos)tics in a floating window
  bufmap('n', 'gl', '<cmd>lua vim.diagnostic.open_float(0, { scope = "line" })<cr>')
  -- Breadcrumb like navigation
  bufmap('n', '<Leader>go', ':Navbuddy<cr>')
  -- Selects a code action available at the current cursor position
  bufmap({'n', 'v', 'x'}, '<leader>ca', '<cmd>CodeActionMenu<cr>')
  -- Hover doc
  -- redefined in ufo
  --bufmap('n', 'K', '<cmd>lua vim.lsp.buf.signature_help()<cr>')

  bufmap('n','<leader>rn','<cmd>lua vim.lsp.buf.rename()<cr>')

  -- add a border to the LSP floating window
  vim.lsp.handlers['textDocument/hover'] = vim.lsp.with(
    vim.lsp.handlers.hover,
    { border = 'single' }
  )
  vim.lsp.handlers["textDocument/publishDiagnostics"] = vim.lsp.with(
    vim.lsp.diagnostic.on_publish_diagnostics, {
      virtual_text = false,
    }
  )
  vim.diagnostic.config({virtual_text=false, update_in_insert=false})
end

return {
  on_attach = on_attach,
}
