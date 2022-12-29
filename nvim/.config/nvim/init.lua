local vim = vim

-- Install lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "--single-branch",
    "https://github.com/folke/lazy.nvim.git",
    lazypath,
  })
end
vim.opt.runtimepath:prepend(lazypath)

-- set leader to ' '
vim.g.mapleader = " "
vim.opt.termguicolors = true

require("lazy").setup({
  -- catppuccin theme
  "catppuccin/nvim",

  {
    "startup-nvim/startup.nvim",
    dependencies = {
      "nvim-telescope/telescope.nvim",
      "nvim-lua/plenary.nvim",
    },
    config = function()
      require("startup").setup()
    end
  },

  -- neovim dev stuff
  --"folke/neodev.vim",
  "milisims/nvim-luaref",

  -- feline status bar
  {
    "feline-nvim/feline.nvim",
    config = function()
      require('feline').setup()
      require('feline').winbar.setup()
    end
  },

  -- DAP debugger
  {
    "mfussenegger/nvim-dap",
    dependencies = {
      "theHamsta/nvim-dap-virtual-text",
      {
        "leoluz/nvim-dap-go",
        config = function()
          require('dap-go').setup()
        end
      },
      {
        "rcarriga/nvim-dap-ui",
        config = function()
          require("dapui").setup()
        end
      },
      {
        "nvim-telescope/telescope-dap.nvim",
        dependencies = {
          "nvim-telescope/telescope.nvim",
        },
        config = function()
          require("telescope").load_extension("dap")
        end
      },
    },
    keys = {
      { '<leader>db', '<cmd>lua require"dap".toggle_breakpoint()<CR>' },
      { '<leader>dc', '<cmd>lua require"dap".continue()<CR>' },
      { '<leader>ds', '<cmd>lua require"dap".stop()<CR>' },
      { '<leader>do', '<cmd>lua require"dap".step_over()<CR>' },
      { '<leader>di', '<cmd>lua require"dap".step_into()<CR>' },
      { '<leader>dt', '<cmd>Telescope dap commands<CR>' },
      { '<leader>dap', '<cmd>lua require"dapui".toggle()<cr>' },
    },
    config = function()
      local dap, dapui = require("dap"), require("dapui")
      dap.listeners.after.event_initialized["dapui_config"] = function()
        dapui.open()
      end
      dap.listeners.before.event_terminated["dapui_config"] = function()
        dapui.close()
      end
      dap.listeners.before.event_exited["dapui_config"] = function()
        dapui.close()
      end

      dap.adapters.php = {
        type = 'executable',
        command = 'node',
        args = { '/Users/tjohnsen/src/vscode-php-debug/out/phpDebug.js' }
      }

      dap.configurations.php = {
        {
          type = 'php',
          request = 'launch',
          name = 'Listen for Xdebug',
          port = 8090
        }
      }

      vim.fn.sign_define('DapBreakpoint', { text = '🟥', texthl = '', linehl = '', numhl = '' })
      vim.fn.sign_define('DapStopped', { text = '▶️', texthl = '', linehl = '', numhl = '' })
    end
  },

  -- git tools
  {
    "kessejones/git-blame-line.nvim",
    keys = {
      { "<leader>gb", "<cmd>GitBlameLineToggle<cr>", desc = "Toggle inline git blame." },
    },
    config = function()
      -- Git blamer inline
      require 'git-blame-line'.setup({
        git = {
          default_message = 'Not committed yet',
          blame_format = '%an - %ar - %s' -- see https://git-scm.com/docs/pretty-formats
        },
        view = {
          left_padding_size = 5,
          enable_cursor_hold = false
        }
      })
    end
  },

  -- filetree
  {
    "nvim-tree/nvim-tree.lua",
    keys = {
      { "<leader>tt", '<cmd>NvimTreeToggle<cr>', desc = "Nvim-Tree" },
    },
    dependencies = {
      "nvim-tree/nvim-web-devicons",
    },
    config = function()
      require('nvim-tree').setup()
    end
  },

  -- telescope
  {
    "nvim-telescope/telescope.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "sharkdp/fd",
      "nvim-tree/nvim-web-devicons",
    },
    config = function()
      require("telescope").setup({
        extensions = {
          undo = {
            side_by_side = true,
            layout_strategy = "vertical",
            layout_config = {
              preview_height = 0.8,
            },
          },
        },
      })
    end,
    keys = {
      {'<leader>ff', '<cmd>lua require"telescope.builtin".find_files({hidden = true})<cr>' },
      {'<leader>fg', '<cmd>lua require"telescope.builtin".live_grep()<cr>' },
      {'<leader>fs', '<cmd>lua require"telescope.builtin".grep_string()<cr>' },
      {'<leader>fb', '<cmd>lua require"telescope.builtin".buffers()<cr>' },
      {'<leader>fh', '<cmd>lua require"telescope.builtin".help_tags()<cr>' },
      {'<leader>gs', '<cmd>lua require"telescope.builtin".git_status()<cr>' },
      {'<leader>td', '<cmd>Telescope diagnostics<cr>' },
      {"<leader>u", "<cmd>Telescope undo<cr>" },
      {'gr', require('telescope.builtin').lsp_references },
    },
  },

  -- Telescope undo
  {
    "debugloop/telescope-undo.nvim",
    dependencies = {
      "nvim-telescope/telescope.nvim",
    },
    config = function()
      require("telescope").load_extension("undo")
    end
  },

  -- Treesitter
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    config = function()
      require 'nvim-treesitter.configs'.setup {
        ensure_installed = "all", -- one of "all", "language", or a list of languages
        highlight = {
          enable = true, -- false will disable the whole extension
          disable = {}, -- list of language that will be disabled
        },
      }
    end
  },

  -- LSP Zero config to automatically install language server for languages
  {
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
      lsp.setup()

      require 'lspconfig'.sumneko_lua.setup {
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
          vim.keymap.set('n', '<leader>rn', vim.lsp.buf.rename, {})
          vim.keymap.set('n', '<leader>ca', vim.lsp.buf.code_action, {})

          vim.keymap.set('n', 'gd', vim.lsp.buf.definition, {})
          vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, {})
          vim.keymap.set('n', 'K', vim.lsp.buf.hover, { buffer = args.buf })
        end,
      })
    end
  },

  -- show a floating preview for definition
  {
    "rmagatti/goto-preview",
    keys = {
      { "gp", "<cmd>lua require('goto-preview').goto_preview_definition()<CR>" },
    },
    config = function()
      require("goto-preview").setup({})
    end
  },

  -- Sports API 
  {
    "tlj/sapi-preview.nvim",
    dependencies = {
      "kkharji/sqlite.lua",
    },
    config = function()
      require("sapi-preview").setup()
    end,
    keys = {
      { "<leader>sg", "<cmd>SapiGoto<cr>", desc = "Open SAPI endpoints valid for URN on cursor." },
      { "<leader>sr", "<cmd>SapiRecents<cr>", desc = "Open list of recently opened SAPI endpoints." },
      { "<leader>se", "<cmd>SapiEndpoints<cr>", desc = "Open list of endpoints for current package." },
      { "<leader>su", "<cmd>SapiRefresh<cr>", desc = "Refresh list of endpoints for current package from selected base URL." },
      { "<leader>sp", "<cmd>SapiPackage<cr>", desc = "Select a SAPI package." },
      { "<leader>sb", "<cmd>SapiBaseUrl<cr>", desc = "Select a SAPI base URL." },
    },
  }
})


-- Theme
vim.opt.signcolumn = 'yes'
vim.cmd('colorscheme catppuccin-mocha')

-- Folding through TreeSitter
local opt = vim.opt

opt.foldenable = false
opt.foldmethod = "expr"
opt.foldexpr = "nvim_treesitter#foldexpr()"

-- Tree settings
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

-- Set leader to space
vim.g.mapleader = " "

-- Enable line numbers
vim.wo.number = true

-- Save undo history
vim.o.undofile = true

-- Two spaces as indent
vim.opt.tabstop = 2
vim.opt.shiftwidth = 2
vim.opt.softtabstop = 2
vim.opt.expandtab = true


