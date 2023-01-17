local M = {
  {

    -- lsp
    'neovim/nvim-lspconfig',
    event = "BufRead",
    dependencies = {
      {
        'williamboman/mason.nvim',
        cmd = {
          "Mason",
          "MasonInstall",
          "MasonUninstall",
          "MasonUninstallAll",
          "MasonLog",
        },
      },
      { 'williamboman/mason-lspconfig.nvim' },
      { "folke/neodev.nvim" },
      {
        "ray-x/go.nvim",
        dependencies = {
          "ray-x/guihua.lua",
          "nvim-treesitter/nvim-treesitter",
        },
        config = function()
          require('go').setup()

          local format_sync_grp = vim.api.nvim_create_augroup("GoFormat", {})
          vim.api.nvim_create_autocmd("BufWritePre", {
            pattern = "*.go",
            callback = function()
              require('go.format').goimport()
            end,
            group = format_sync_grp,
          })
        end
      },

      -- complete
      {
        'hrsh7th/nvim-cmp',
        event = { "InsertEnter", "CmdlineEnter" },
        dependencies = {
          'hrsh7th/cmp-buffer', -- Buffer completions
          'hrsh7th/cmp-path', -- path competions
          'hrsh7th/cmp-nvim-lsp', -- LSP completions
          'hrsh7th/cmp-nvim-lua', -- Lua completions
          'hrsh7th/cmp-cmdline', -- CommandLine completions
          'saadparwaiz1/cmp_luasnip', -- Snippet completions
          'L3MON4D3/LuaSnip', -- Snippet engine
          'rafamadriz/friendly-snippets', -- Bunch of snippets
          {
            'windwp/nvim-autopairs',
            config = function()
              require("nvim-autopairs").setup({
                check_ts = true, -- treesitter integration
                disable_filetype = { "TelescopePrompt" },
              })

              local cmp_autopairs = require("nvim-autopairs.completion.cmp")
              local cmp = require("cmp")
              cmp.event:on("confirm_done", cmp_autopairs.on_confirm_done {})
            end
          }
        }
      },
    },
    config = function()
      require("neodev").setup()

      require('mason').setup()

      require('mason-lspconfig').setup({
        ensure_installed = {
          'sumneko_lua', -- lua
          'lemminx', -- xml
          'bashls', -- bash
          'yamlls', -- yaml
          'phpactor', -- php
          'jsonls', -- json
          'html', -- html
          'gopls', -- golang
        }
      })

      local lsp_attach = function(_, bufnr)
        local bufmap = function(mode, lhs, rhs)
          local opts = {buffer = bufnr}
          vim.keymap.set(mode, lhs, rhs, opts)
        end

        -- Renames all references to the symbol under the cursor
        bufmap('n', '<leader>rn', '<cmd>lua vim.lsp.buf.rename()<cr>')

        -- Selects a code action available at the current cursor position
        bufmap('n', '<leader>ca', '<cmd>lua vim.lsp.buf.code_action()<cr>')
        bufmap('x', '<leader>ca', '<cmd>lua vim.lsp.buf.range_code_action()<cr>')

        -- Jump to the definition
        bufmap('n', 'gd', '<cmd>lua vim.lsp.buf.definition()<cr>')

        -- Jumo to desclaration
        bufmap('n', 'gD', '<cmd>lua vim.lsp.buf.declaration()<cr>')

        -- Lists all the implementations for the symvol under the cursor
        bufmap('n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<cr>')

        -- Jumps to the definition of the type symbol
        bufmap('n', 'go', '<cmd>lua vim.lsp.buf.type_definitions()<cr>')

        -- Lists all the references
        bufmap('n', 'gr', '<cmd>lua vim.lsp.buf.references()<cr>')

        -- Displays hover information about the symbol under the cursor
        bufmap('n', 'K', '<cmd>lua vim.lsp.buf.hover()<cr>')

        -- displays a functions signature information
        bufmap('n', '<C-k>', '<cmd>lua vim.lsp.buf.signature_help()<cr>')

        -- Open a telescope window with diagnostics
        bufmap('n', '<leader>gl', '<cmd>Telescope diagnostics bufnr=0<cr>')

        -- Show diagnostics in a floating window
        bufmap('n', 'gl', '<cmd>lua vim.diagnostic.open_float()<cr>')

        -- Move to the previous diagnostic
        bufmap('n', '[d', '<cmd>lua vim.diagnostic.goto_prev()<cr>')

        -- Move to the next diagnostic
        bufmap('n', ']d', '<cmd>lua vim.diagnostic.goto_next()<cr>')

      end

      -- declare the client capabilities,
      -- merge the defaults with what cmp_nvim_lsp offers
      local lspconfig = require('lspconfig')
      local lsp_defaults = lspconfig.util.default_config
      lsp_defaults.capabilities = vim.tbl_deep_extend(
        'force',
        lsp_defaults.capabilities,
        require('cmp_nvim_lsp').default_capabilities()
      )

      -- configure lua lsp support
      local servers = {
        sumneko_lua = {
          settings = {
            Lua = {
              completion = {
                callSnippet = "Replace"
              },
              diagnostics = {
                globals = { 'vim' }
              }
            }
          }
        },
      }

      -- set options, mappings and capabilities for server
      local get_servers = require('mason-lspconfig').get_installed_servers
      local server_opts = {
        on_attach = lsp_attach,
        capabilities = lsp_defaults,
      }
      for _, server_name in ipairs(get_servers()) do
        -- merge options from server_opts per server
        -- these has to be set now, not before or after
        local options = vim.tbl_deep_extend("force", server_opts, servers[server_name] or {})
        lspconfig[server_name].setup(options)
      end

      -- Set how diagnostics should be displayed
      vim.diagnostic.config({
        virtual_text = false,
        signs = true,
        update_in_insert = false,
        underline = true,
        severity_sort = true,
        float = {
          border = 'rounded',
          source = 'always',
          header = '',
          prefix = '',
        },
      })

      vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, {
        border = "rounded",
      })

      vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers.signature_help, {
        border = "rounded",
      })

      -- Show gutter sign symbols for diagnostics
      local sign = function(opts)
        vim.fn.sign_define(opts.name, {
          texthl = opts.name,
          text = opts.text,
          numhl = ''
        })
      end

      sign({name = 'DiagnosticSignError', text = '✘'})
      sign({name = 'DiagnosticSignWarn', text = '▲'})
      sign({name = 'DiagnosticSignHint', text = '⚑'})
      sign({name = 'DiagnosticSignInfo', text = ''})

      --
      --
      -- CMP, should be moved to separate file
      --
      --
      local cmp = require("cmp")
      local luasnip = require("luasnip")

      require("luasnip.loaders.from_vscode").lazy_load()

      local kind_icons = {
        Text = "",
        Method = "",
        Function = "",
        Constructor = "",
        Field = "ﰠ",
        Variable = "",
        Class = "ﴯ",
        Interface = "",
        Module = "",
        Property = "ﰠ",
        Unit = "塞",
        Value = "",
        Enum = "",
        Keyword = "",
        Snippet = "",
        Color = "",
        File = "",
        Reference = "",
        Folder = "",
        EnumMember = "",
        Constant = "",
        Struct = "פּ",
        Event = "",
        Operator = "",
        TypeParameter = "",
      }

      local check_back_space = function()
        local col = vim.fn.col('.') - 1
        if col == 0 or vim.fn.getline('.'):sub(col, col):match('%s') then
          return true
        else
          return false
        end
      end

      cmp.setup({
        snippet = {
          expand = function(args)
            luasnip.lsp_expand(args.body) -- for lusnip users
          end,
        },

        mapping = cmp.mapping.preset.insert {
          -- luasnip
          -- go to next placeholder in the snippet
          ["<C-d>"] = cmp.mapping(function(fallback)
            if luasnip.jumpable(1) then
              luasnip.jump(1)
            else
              fallback()
            end
          end, {'i', 's'}),

          -- go to the previous placeholder in the snippet
          ["<C-b>"] = cmp.mapping(function(fallback)
            if luasnip.jumpable(-1) then
              luasnip.jump(-1)
            else
              fallback()
            end
          end, {'i', 's'}),

          -- Navigate items on the list
          ["<Up>"] = cmp.mapping.select_prev_item(),
          ["<Down>"] = cmp.mapping.select_next_item(),
          ["<C-k>"] = cmp.mapping.select_prev_item(),
          ["<C-j>"] = cmp.mapping.select_next_item(),

          -- Scoll up and down in the completion documentation
          ["<C-u>"] = cmp.mapping(cmp.mapping.scroll_docs(-5)),
          ["<C-f>"] = cmp.mapping(cmp.mapping.scroll_docs(5)),

          -- toggle completion
          ["<C-e>"] = cmp.mapping(function(_)
            if cmp.visible() then
              cmp.abort()
            else
              cmp.complete()
            end
          end),

          -- Accept currently selected item. If none selected, `select` first item.
          -- Set `select` to `false` to only confirm explicitly selected items.
          ["<CR>"] = cmp.mapping.confirm { select = false },
          ["<C-y>"] = cmp.mapping.confirm { select = false },

          -- when menu is visible, navigate to next item
          -- when line is empty, insert a tab character
          -- else activate completion
          ["<Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_next_item({behavior = cmp.SelectBehavior.Select})
            elseif check_back_space() then
              fallback()
            else
              cmp.complete()
            end
          end, {
            "i",
            "s",
          }),

          -- when menu is visible, navigate to previous item on list
          -- else revert to default behavior
          ["<S-Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_prev_item({behavior = cmp.SelectBehavior.Select})
            else
              fallback()
            end
          end, {
            "i",
            "s",
          }),
        },


        formatting = {
          format = function(_, vim_item)
            vim_item.kind = string.format("%s %s", kind_icons[vim_item.kind], vim_item.kind)
            return vim_item
          end,
        },
        sources = {
          { name = 'nvim_lsp' },
          { name = 'nvim_lua' },
          { name = 'luasnip' },
          { name = 'buffer' },
          { name = 'path' },
        },
        confirm_opts = {
          behavior = cmp.ConfirmBehavior.Replace,
          select = false,
        },
        window = {
          completion = cmp.config.window.bordered(),
          documentation = cmp.config.window.bordered(),
        },
        experimental = {
          ghost_text = true,
        },
      })

      cmp.setup.cmdline(":", {
        mapping = cmp.mapping.preset.cmdline(),
        sources = {
          { name = "cmdline" },
        },
        window = {
          completion = cmp.config.window.bordered {
            border = "rounded",
            winhighlight = "Normal:Normal,FloatBorder:CmpCompletionBorder,CursorLine:CmpCursorLine,Search:Search",
            col_offset = -3,
            side_padding = 1,
          },
        },
        formatting = {
          -- fields = { 'abbr' },
          format = function(_, vim_item)
            vim_item.kind = string.format("%s %s", kind_icons[vim_item.kind], vim_item.kind)
            return vim_item
          end,
        },
      })

    end,
  },
}

return M

