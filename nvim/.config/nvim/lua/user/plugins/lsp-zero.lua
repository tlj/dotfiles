local M = {
  "VonHeikemen/lsp-zero.nvim",
  dependencies = {
    -- LSP Support
    { 'neovim/nvim-lspconfig' },
    { 'williamboman/mason.nvim' },
    { 'williamboman/mason-lspconfig.nvim' },

    -- Autocompletion
    { 'hrsh7th/nvim-cmp' },
    { 'hrsh7th/cmp-buffer' },
    { 'hrsh7th/cmp-path' },
    { 'saadparwaiz1/cmp_luasnip' },
    { 'hrsh7th/cmp-nvim-lsp' },
    { 'hrsh7th/cmp-nvim-lua' },

    -- Snippets
    { 'L3MON4D3/LuaSnip' },
    { 'rafamadriz/friendly-snippets' },
  },
  config = function()
    -- LSP init
    local lsp = require('lsp-zero')
    lsp.preset('recommended')

    lsp.set_preferences({
      set_lsp_keymaps = {omit = {'K', '<C-k>', 'gi', 'gd', '<F4>'}}
    })

    lsp.setup()

    vim.diagnostic.config({
      virtual_text = false,
    })

    require 'lspconfig'.lua_ls.setup {
      settings = {
        Lua = {
          diagnostics = {
            globals = { 'vim' }
          }
        }
      }
    }

    vim.api.nvim_create_autocmd('LspAttach', {
      callback = function(args)
        vim.keymap.set('n', '<leader>rn', '<cmd>lua vim.lsp.buf.rename()<cr>', {})
        vim.keymap.set('n', '<leader>ca', '<cmd>lua vim.lsp.buf.code_action()<cr>', {})
        vim.keymap.set('n', '<leader>ra', '<cmd>lua vim.lsp.buf.range_code_action()<cr>', {})

--        vim.keymap.set('n', 'gd', '<cmd>lua vim.lsp.buf.definition()<cr>', {})
        vim.keymap.set('n', 'gD', '<cmd>lua vim.lsp.buf.declaration()<cr>', {})
--        vim.keymap.set('n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<cr>', {})
        vim.keymap.set('n', 'go', '<cmd>lua vim.lsp.buf.type_definitions()<cr>', {})
        vim.keymap.set('n', 'gr', '<cmd>lua vim.lsp.buf.references()<cr>', {})
        vim.keymap.set('n', '<leader>gh', '<cmd>lua vim.lsp.buf.signature_help()<cr>', {})

        -- diagnostics
        vim.keymap.set('n', '<leader>gl', '<cmd>Telescope diagnostics bufnr=0<cr>', {})
        vim.keymap.set('n', 'gl', '<cmd>lua vim.diagnostic.open_float()<cr>', {})
        vim.keymap.set('n', '[d', '<cmd>lua vim.diagnostic.goto_prev()<cr>', {})
        vim.keymap.set('n', ']d', '<cmd>lua vim.diagnostic.goto_next()<cr>', {})

        -- vim.keymap.set('n', 'K', vim.lsp.buf.hover, { buffer = args.buf })
      end,
    })
  end
}

return {}
