-- :help options

local options = {
	autowrite = true, -- enable auto write of files
	backup = false, -- create a backup file
	clipboard = "", -- don't sync with system clipboard, use "+ for clipboard register
	cmdheight = 2, -- set to 2 to avoid hit-enter prompt
	completeopt = "menu,menuone,noselect",
	conceallevel = 0, --
	confirm = true, -- confirm to save changes before exiting modified buffer
	cursorline = true, -- enable highlight of current line
	expandtab = true, -- use space instead of tabs
	fillchars = [[eob: ,fold: ,foldopen:,foldsep: ,foldclose:]],
	foldcolumn = "0", -- disable fold column
	foldenable = true,
	foldmethod = "indent",
	foldlevel = 99,
	foldlevelstart = 99,
	formatoptions = "jcroqlnt", -- tcqj is default
	grepformat = "%f:%l:%c:%m",
	grepprg = "rg --vimgrep",
	hidden = true, -- enable modified buffers in the background
	ignorecase = true, -- ignore case for search functions
	inccommand = "split", -- show effects of a substitution command in split window
	list = true, -- show some invisible characters (tabs, etc)
	listchars = "tab:» ,trail:·", --
	mouse = "a", -- enable mouse mode
	number = true,
	numberwidth = 4,
	pumblend = 10, -- pupop blend
	pumheight = 10, -- pop up menu height
	relativenumber = true,
	scrolloff = 8, -- number of lines to keep above or below the cursor
	sessionoptions = { "buffers", "curdir", "tabpages", "winsize", "folds", "globals" },
	shiftwidth = 2,
	shortmess = "ltToOCF",
	showmode = true, -- show mode in the cmd line since we want to avoid using a slow statusline
	showtabline = 0, -- always show tabs
	sidescrolloff = 8, -- number of cols to keep to the left or right of cursor
	signcolumn = "yes", -- always show the sign column, otherwise it would shift the text each time
	smartcase = true, -- don't ignore case with capitals
	smartindent = true, -- insert indents automatically
	spelllang = { "en" },
	splitbelow = true, -- all horizontal splits go below
	splitkeep = "screen", -- keep the cursor on the same line when opening new windows
	splitright = true, -- all vertical splits go right
	swapfile = false,
	tabstop = 2,
	termguicolors = true, -- set term gui colors (most terminals support this)
	timeoutlen = 600, -- time to wait for a mapped sequence to complete (in ms)
	title = true,
	undofile = true,
	updatetime = 600, -- faster completion (4000ms default)
	virtualedit = "block", -- allow cursor to move where there is no text in visual block mode
	wildmode = "longest:full,full", --comand line completion mode
	winminwidth = 5,
	wrap = true, -- display lines as one long line
	writebackup = false, -- if a file is being edited by another program, it is not allwed to be edited
}

if vim.fn.has("nvim-0.10") == 1 then
	options.smoothscroll = true
end

if vim.fn.has("nvim-0.11") == 1 then
	options.messagesopt = "wait:1000,history:2000"
	options.cmdheight = 0
end

for k, v in pairs(options) do
	vim.opt[k] = v
end

-- set leader to ' '
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- disable netrw for nvim tree to work
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

-- Fix markdown indentation settings
vim.g.markdown_recommended_style = 0

-- Enable line numbers
vim.wo.number = true

-- use ripgrep for grep, see
-- https://phelipetls.github.io/posts/extending-vim-with-ripgrep/
-- and
-- https://gist.github.com/lalitmee/c379ee6b5163ac3670cfbca9a356b6bb
local executable = function(e) return vim.fn.executable(e) > 0 end

local function add(value, str, sep)
	sep = sep or ","
	str = str or ""
	value = type(value) == "table" and table.concat(value, sep) or value
	return str ~= "" and table.concat({ value, str }, sep) or value
end

if executable("rg") then
	vim.o.grepprg = [[rg --hidden --smart-case --vimgrep --ignore-file ~/.config/nvim/scripts/rgignore]]
	vim.o.grepformat = add("%f:%l:%c:%m", vim.o.grepformat)
end

local qfgrp = vim.api.nvim_create_augroup("quickfix", { clear = true })
vim.api.nvim_create_autocmd("FileType", { pattern = "qf", command = "setlocal norelativenumber", group = qfgrp })
vim.api.nvim_create_autocmd("FileType", { pattern = "qf", command = "setlocal number", group = qfgrp })
vim.api.nvim_create_autocmd("FileType", { pattern = "qf", command = "setlocal nowrap", group = qfgrp })
vim.api.nvim_create_autocmd("FileType", { pattern = "qf", command = "setlocal scrolloff=0", group = qfgrp })
vim.api.nvim_create_autocmd("FileType", { pattern = "qf", command = "set nobuflisted", group = qfgrp })
vim.api.nvim_create_autocmd("FileType", { pattern = "qf", command = "nnoremap <buffer> q :cclose<cr>", group = qfgrp })

vim.api.nvim_create_autocmd({ "BufEnter", "BufWinEnter" }, {
	callback = function() vim.diagnostic.config({ virtual_text = false, update_in_insert = false }) end,
})
