local function on_attach(_, bufnr)
  local bufmap = function(mode, lhs, rhs)
    local opts = { buffer = bufnr }
    vim.keymap.set(mode, lhs, rhs, opts)
  end

  -- Jump to the definition
  bufmap('n', 'gd', '<cmd>lua vim.lsp.buf.definition()<cr>')
  -- Jump to declaration
  bufmap('n', 'gD', '<cmd>lua vim.lsp.buf.declaration()<cr>')
  -- Lists all the implementations for the symvol under the cursor
  bufmap('n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<cr>')
  -- Lists all the references
  bufmap('n', 'gr', '<cmd>lua vim.lsp.buf.references()<cr>')
  -- Open a telescope window with diagnostics
  bufmap('n', '<leader>gl', '<cmd>Telescope diagnostics<cr>')
  -- Show diagnos)tics in a floating window
  bufmap('n', 'gl', '<cmd>lua vim.diagnostic.open_float(0, { scope = "line" })<cr>')
  -- Breadcrumb like navigation
  bufmap('n', '<Leader>go', ':Navbuddy<cr>')
  -- Selects a code action available at the current cursor position
  bufmap({'n', 'v', 'x'}, '<leader>ca', '<cmd>CodeActionMenu<cr>')
  -- Hover doc
  bufmap('n', 'K', '<cmd>lua vim.lsp.buf.signature_help()<cr>')
end

return {
  on_attach = on_attach,
}
