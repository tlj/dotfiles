-- Install packer
local vim = vim
local install_path = vim.fn.stdpath 'data' .. '/site/pack/packer/start/packer.nvim'
local is_bootstrap = false
if vim.fn.empty(vim.fn.glob(install_path)) > 0 then
  is_bootstrap = true
  vim.fn.execute('!git clone https://github.com/wbthomason/packer.nvim ' .. install_path)
  vim.cmd [[packadd packer.nvim]]
end

require('packer').startup(function(use)
  use 'wbthomason/packer.nvim'
  use 'joshdick/onedark.vim'
  use "EdenEast/nightfox.nvim"
  use { "catppuccin/nvim", as = "catppuccin" }
  use 'mfussenegger/nvim-dap'
  use 'feline-nvim/feline.nvim'
  use 'leoluz/nvim-dap-go'
  use { "rcarriga/nvim-dap-ui", requires = {"mfussenegger/nvim-dap"} }
  use 'WhoIsSethDaniel/toggle-lsp-diagnostics.nvim'
  use { 'kessejones/git-blame-line.nvim' }
  use {
    'nvim-tree/nvim-tree.lua',
    requires = {
      'nvim-tree/nvim-web-devicons', -- optional, for file icons
    },
    tag = 'nightly' -- optional, updated every week. (see issue #1193)
  }
  use {
    'nvim-telescope/telescope.nvim', tag = '0.1.0',
    requires = {
      {
        'nvim-lua/plenary.nvim',
        'sharkdp/fd',
        'nvim-tree/nvim-web-devicons'
      }
    }
  }
  use {
  'debugloop/telescope-undo.nvim',
    requires = { 'nvim-telescope/telescope.nvim' },
    config = function()
      require("telescope").load_extension("undo")
      -- optional: vim.keymap.set("n", "<leader>u", "<cmd>Telescope undo<cr>")
    end,
  }
  use 'nvim-telescope/telescope-dap.nvim'
  use { 'nvim-treesitter/nvim-treesitter', run = ':TSUpdate' }

  use {
    'VonHeikemen/lsp-zero.nvim',
    requires = {
      -- LSP Support
      {'neovim/nvim-lspconfig'},
      {'williamboman/mason.nvim'},
      {'williamboman/mason-lspconfig.nvim'},

      -- Autocompletion
      {'hrsh7th/nvim-cmp'},
      {'hrsh7th/cmp-buffer'},
      {'hrsh7th/cmp-path'},
      {'saadparwaiz1/cmp_luasnip'},
      {'hrsh7th/cmp-nvim-lsp'},
      {'hrsh7th/cmp-nvim-lua'},

      -- Snippets
      {'L3MON4D3/LuaSnip'},
      {'rafamadriz/friendly-snippets'},
    }
  }

  use {
    'rmagatti/goto-preview',
    config = function()
      require('goto-preview').setup {}
    end
  }

  if is_bootstrap then
    require('packer').sync()
  end
end)

if is_bootstrap then
  print '=================================='
  print '    Plugins are being installed'
  print '    Wait until Packer completes,'
  print '       then restart nvim'
  print '=================================='
  return
end

-- LSP init
local lsp = require('lsp-zero')
lsp.preset('recommended')
lsp.setup()

require'toggle_lsp_diagnostics'.init()

-- DAP Debugger
require('dap-go').setup()
require('dapui').setup()
require('telescope').load_extension('dap')

local dap, dapui =require("dap"),require("dapui")
dap.listeners.after.event_initialized["dapui_config"]=function()
  dapui.open()
end
dap.listeners.before.event_terminated["dapui_config"]=function()
  dapui.close()
end
dap.listeners.before.event_exited["dapui_config"]=function()
  dapui.close()
end

vim.fn.sign_define('DapBreakpoint',{ text ='🟥', texthl ='', linehl ='', numhl =''})
vim.fn.sign_define('DapStopped',{ text ='▶️', texthl ='', linehl ='', numhl =''})

-- Git blamer inline
require'git-blame-line'.setup({
    git = {
        default_message = 'Not committed yet',
        blame_format = '%an - %ar - %s' -- see https://git-scm.com/docs/pretty-formats
    },
    view = {
        left_padding_size = 5,
        enable_cursor_hold = false
    }
})

-- Theme
vim.opt.signcolumn = 'yes'
vim.opt.termguicolors = true

vim.cmd('colorscheme catppuccin-mocha')

-- Feline bar
require('feline').setup()
require('feline').winbar.setup()

-- undo
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

-- Other plugins
require('nvim-tree').setup()

-- TreeSitter
require'nvim-treesitter.configs'.setup {
  ensure_installed = { "go", "lua" },     -- one of "all", "language", or a list of languages
  highlight = {
    enable = true,              -- false will disable the whole extension
    disable = { "lua" },  -- list of language that will be disabled
  },
}

-- Folding through TreeSitter
local vim = vim
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


-- Maps
local map = vim.api.nvim_set_keymap
map('n', '<leader>dtb', '<cmd>lua require"dap".toggle_breakpoint()<CR>', {noremap = true, silent = false})
map('n', '<leader>dc', '<cmd>lua require"dap".continue()<CR>', {noremap = true, silent = false})
map('n', '<leader>dsv', '<cmd>lua require"dap".step_over()<CR>', {noremap=true, silent=false})
map('n', '<leader>dsi', '<cmd>lua require"dap".step_info()<CR>', {noremap=true, silent=false})
map('n', '<leader>dcc', '<cmd>Telescope dap commands<CR>', {})
map('n', '<leader>dap', '<cmd>lua require"dapui".toggle()<cr>', {})

map('n', '<leader>ff', '<cmd>lua require"telescope.builtin".find_files()<cr>', {})
map('n', '<leader>fg', '<cmd>lua require"telescope.builtin".live_grep()<cr>', {})
map('n', '<leader>fs', '<cmd>lua require"telescope.builtin".grep_string()<cr>', {})
map('n', '<leader>fb', '<cmd>lua require"telescope.builtin".buffers()<cr>', {})
map('n', '<leader>fh', '<cmd>lua require"telescope.builtin".help_tags()<cr>', {})
map('n', '<leader>gs', '<cmd>lua require"telescope.builtin".git_status()<cr>', {})
map('n', '<leader>gb', '<cmd>GitBlameLineToggle<cr>', {})
map('n', "gp", "<cmd>lua require('goto-preview').goto_preview_definition()<CR>", {})

map('n', '<leader>tt', '<cmd>NvimTreeToggle<cr>', {})
map('n', '<leader>td', '<cmd>Telescope diagnostics<cr>', {})

map('n', '<leader>rr', '<cmd>lua vim.lsp.buf.rename()<cr>', {})
map("n", "<leader>u", "<cmd>Telescope undo<cr>", {})


