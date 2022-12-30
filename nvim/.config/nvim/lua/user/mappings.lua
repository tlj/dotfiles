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
keymap("n", "K", ":m .-2<CR>==", opts)
keymap("n", "J", ":m .+1<CR>==", opts)

-- Move a block in visual mode
keymap("x", "K", ":move '>+1<CR>gv-gv", opts)
keymap("x", "J", ":move '<-2<CR>gv-gv", opts)




