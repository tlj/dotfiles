-- :help options

local options = {
  backup = false,         -- create a backup file 

  termguicolors = true,

  pumheight = 10, -- pop up menu height
  showmode = true, -- show --INSERT--
  showtabline = 2, -- always show tabs
  splitbelow = true, -- all horizontal splits go below
  splitright = true, -- all vertical splits go right
  swapfile = false,
  timeoutlen = 1000, -- time to wait for a mapped sequence to complete (in ms)
  undofile = true,
  updatetime = 300, -- faster completion (4000ms default)
  writebackup = false, -- if a file is being edited by another program, it is not allwed to be edited
  expandtab = true,
  shiftwidth = 2,
  tabstop = 2,
  cursorline = true,
  relativenumber = false,
  numberwidth = 4,
  signcolumn = "yes", -- always show the sign column, otherwise it would shift the text each time
  wrap = true, -- display lines as one long line
  scrolloff = 8, -- number of lines to keep above or below the cursor
  sidescrolloff = 8, -- number of cols to keep to the left or right of cursor

  foldenable = false,
  foldmethod = "expr",
  foldexpr = "nvim_treesitter#foldexpr()",
}

for k, v in pairs(options) do
  vim.opt[k] = v
end

-- set leader to ' '
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- disable netrw for nvim tree to work
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

-- Enable line numbers
vim.wo.number = true

-- use ripgrep for grep, see 
-- https://phelipetls.github.io/posts/extending-vim-with-ripgrep/
-- and
-- https://gist.github.com/lalitmee/c379ee6b5163ac3670cfbca9a356b6bb
local executable = function(e)
  return vim.fn.executable(e) > 0
end

local function add(value, str, sep)
  sep = sep or ','
  str = str or ''
  value = type(value) == 'table' and table.concat(value, sep) or value
  return str ~= '' and table.concat({ value, str }, sep) or value
end

if executable("rg") then
  vim.o.grepprg =
      [[rg --hidden --smart-case --vimgrep ]]
  vim.o.grepformat = add('%f:%l:%c:%m', vim.o.grepformat)
end

