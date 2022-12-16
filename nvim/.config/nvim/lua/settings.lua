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




