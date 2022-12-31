local wk = require("which-key")
wk.setup({
  show_help = true,
  triggers = "auto",
  plugins = { spelling = true },
  key_labels = { ["<leader>"] = "SPC" },
})

local opts = { noremap = true, silent = true }

-- Shorten function name
local keymap = vim.api.nvim_set_keymap

-- Move to window using the <ctrl> movement keys
keymap("n", "<C-h>", "<C-w>h", opts)
keymap("n", "<C-j>", "<C-w>j", opts)
keymap("n", "<C-k>", "<C-w>k", opts)
keymap("n", "<C-l>", "<C-w>l", opts)

-- Navigate buffers
keymap("n", "<S-l>", ":bnext<CR>", opts)
keymap("n", "<S-h>", ":bprevious<CR>", opts)

-- Stay in indent mode
keymap("v", "<", "<gv", opts)
keymap("v", ">", ">gv", opts)

-- Move text up and down
-- keymap("n", "K", ":m .-2<CR>==", opts)
-- keymap("n", "J", ":m .+1<CR>==", opts)

-- Move a block in visual mode
keymap("x", "K", ":move '>+1<CR>gv-gv", opts)
keymap("x", "J", ":move '<-2<CR>gv-gv", opts)

-- Resize windows with shift-arrow keys
keymap("n", "<S-Up>", "<cmd>resize +2<CR>", opts)
keymap("n", "<S-Down>", "<cmd>resize -2<CR>", opts)
keymap("n", "<S-Left>", "<cmd>vertical resize -2<CR>", opts)
keymap("n", "<S-Right>", "<cmd>vertical resize +2<CR>", opts)

-- Clear search with <esc>
keymap("n", "<esc>", "<cmd>noh<cr><esc>", opts)
keymap("i", "<esc>", "<cmd>noh<cr><esc>", opts)

-- Save in insert mode
keymap("i", "<C-s>", "<cmd>:w<cr><esc>", opts)
keymap("n", "<C-s>", "<cmd>:w<cr><esc>", opts)

-- Don't allow arrow keys, use hjkl instead
keymap('n', "<left>", "<nop>", opts)
keymap('n', "<right>", "<nop>", opts)
keymap('n', "<up>", "<nop>", opts)
keymap('n', "<down>", "<nop>", opts)



