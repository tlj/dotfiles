-- language server support
local M = {
  -- lspconfig
  {
    "neovim/nvim-lspconfig",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = {
      "williamboman/mason.nvim",
    }
  },
  -- Mason for autoinstalling lsps
  {
    "williamboman/mason.nvim",
    cmd = {
      "Mason",
      "MasonInstall",
      "MasonUninstall",
      "MasonUninstallAll",
      "MasonLog",
      "MasonUpdate",
    },
    build = ":MasonUpdate",
    config = function()
      local path = require("mason-core.path")
      require("mason").setup({
        install_root_dir = path.concat({ vim.fn.stdpath("cache"), "mason" }),
        max_concurrent_installers = 4,
      })
    end,
    lazy = true,
    enabled = true,
  },
  {
    "weilbith/nvim-code-action-menu",
    dependencies = {
      "kosayoda/nvim-lightbulb",
    },
    cmd = "CodeActionMenu",
  },
  {
    "SmiteshP/nvim-navbuddy",
    dependencies = {
      "SmiteshP/nvim-navic",
      "MunifTajim/nui.nvim",
    },
    opts = {
      cmd = "Navbuddy",
      lsp = {
        auto_attach = true,
      }
    }
  },
  {
    "https://git.sr.ht/~whynothugo/lsp_lines.nvim",
    init = function()
      vim.diagnostic.config({ virtual_text = false, virtual_lines = false })
    end,
    opts = {},
    event = "VeryLazy",
  }, {
    "williamboman/mason-lspconfig.nvim",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = {
      "williamboman/mason.nvim",
      "neovim/nvim-lspconfig",
      "hrsh7th/cmp-nvim-lsp",
    },
    opts = function(_, opts)
      local defaults = {
        ensure_installed = {
          'lua_ls', -- lua
          'lemminx', -- xml
          'bashls', -- bash
          'yamlls', -- yaml
          'intelephense', -- php
          'jsonls', -- json
          'html', -- html
          'gopls', -- golang
          'cssls', -- css
          'clangd', -- c
          'ocamllsp', -- ocaml
          -- 'terraformls', -- terraform
        },
        log_level = "error",
        diagnostics = {
          signs = true,
          underline = true,
          update_in_insert = false,
          severity_sort = true,
          float = {
            border = 'rounded',
            source = 'always',
            header = '',
            prefix = '',
          },
          virtual_text = {
            spacing = 4,
            source = "if_many",
            prefix = function(diagnostic)
              local signs = require("config.icons").lsp.diagnostic.upper_signs
              local severity = vim.diagnostic.severity[diagnostic.severity]
              if signs[severity] then
                return signs[severity]
              end
              return "●"
            end,
          },
        },
        capabilities = { -- {{{
          dynamicRegistration = true,
          lineFoldingOnly = true,
          textDocument = {
            completion = {
              completionItem = {
                documentationFormat = { "markdown", "plaintext" },
                snippetSupport = true,
                preselectSupport = true,
                insertReplaceSupport = true,
                labelDetailsSupport = true,
                deprecatedSupport = true,
                commitCharactersSupport = true,
                tagSupport = { valueSet = { 1 } },
                resolveSupport = {
                  properties = {
                    "documentation",
                    "detail",
                    "additionalTextEdits",
                  },
                },
              },
              dynamicRegistration = true,
            },
            callHierarchy = {
              dynamicRegistration = true,
            },
            documentSymbol = {
              dynamicRegistration = true,
            },
          },
        }, -- }}}

        server_capabilities = { -- {{{
          workspace = {
            didChangeWatchedFiles = {
              dynamicRegistration = true,
            },
            symbol = {
              dynamicRegistration = true,
            },
          },
          workspaceSymbolProvider = true,
        }, -- }}}

        servers = {
          gopls = require("plugins.lsp.config.gopls"),
          intelephense = require("plugins.lsp.config.intelephense"),
          jsonls = require("plugins.lsp.config.jsonls"),
          lua_ls = require("plugins.lsp.config.lua_ls"),
          yamlls = require("plugins.lsp.config.yamlls"),
          ocamllsp = require("plugins.lsp.config.ocaml"),
        },
      }
      return vim.tbl_deep_extend("force", defaults, opts)
    end,
    config = function(_, opts)
      require("mason-lspconfig").setup({
        ensure_installed = opts.ensure_installed,
        automatic_installation = true,
      })
      require("mason-lspconfig").setup_handlers({
        function(server_name)
          local conf = opts.servers[server_name] or {}

          local ok, cmp_caps = pcall(require, "cmp_nvim_lsp")
          if ok then
            cmp_caps = cmp_caps.default_capabilities()
          end
          local caps = vim.tbl_deep_extend(
            "force",
            vim.lsp.protocol.make_client_capabilities(),
            cmp_caps or {},
            opts.capabilities or {},
            conf.capabilities or {}
          )
          conf.capabilities = caps

          local pre_attach = function(_, _) end
          if conf.on_attach ~= nil then
            pre_attach = conf.on_attach or function() end
          end

          conf.on_attach = function(client, bufnr)
            client.server_capabilities = vim.tbl_deep_extend(
              "force",
              client.server_capabilities,
              opts.server_capabilities or {},
              conf.server_capabilities or {}
            )
            pre_attach(client, bufnr)
            require("plugins.lsp.on_attach").on_attach(client, bufnr)
          end

          require("lspconfig")[server_name].setup(conf)
        end,
      })

      -- Show gutter sign symbols for diagnostics
      local sign = function(opt)
        vim.fn.sign_define(opt.name, {
          texthl = opt.name,
          text = opt.text,
          numhl = ''
        })
      end
      local signs = require("config.icons").lsp.diagnostic.signs

      sign({name = 'DiagnosticSignError', text = signs.Error })
      sign({name = 'DiagnosticSignWarn', text = signs.Warn })
      sign({name = 'DiagnosticSignHint', text = signs.Hint })
      sign({name = 'DiagnosticSignInfo', text = signs.Info })
    end,
  }
}

return M
