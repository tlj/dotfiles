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

-- better up/down, goes up/down a line in soft wrap mode
keymap("n", "j", "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })
keymap("n", "k", "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })

-- Move to window using the <ctrl> movement keys
keymap("n", "<C-h>", "<C-w>h", { desc = "Go to the left window" })
keymap("n", "<C-j>", "<C-w>j", { desc = "Go to the lower window" })
keymap("n", "<C-k>", "<C-w>k", { desc = "Go to the upper window" })
keymap("n", "<C-l>", "<C-w>l", { desc = "Go to the right window" })

-- Navigate buffers
local hasbufferline, _ = pcall(require, "bufferline")
if hasbufferline then
  keymap("n", "[b", "<cmd>BufferLineCyclePrev<cr>", { desc = "Prev buffer" })
  keymap("n", "]b", "<cmd>BufferLineCycleNext<cr>", { desc = "Next buffer" })
else
  keymap("n", "[b", "<cmd>bprevious<cr>", { desc = "Prev buffer" })
  keymap("n", "]b", "<cmd>bnext<cr>", { desc = "Next buffer" })
end

-- Stay in indent mode
keymap("v", "<", "<gv", opts)
keymap("v", ">", ">gv", opts)

-- Move text up and down
keymap("n", "<C-S-k>", ":m .-2<CR>==", opts)
keymap("n", "<C-S-j>", ":m .+1<CR>==", opts)

-- Move a block in visual mode
keymap("x", "<C-S-k>", ":move '>+1<CR>gv-gv", opts)
keymap("x", "<C-S-j>", ":move '<-2<CR>gv-gv", opts)

-- Resize windows 
keymap("n", "<C-Up>", "<cmd>resize +2<CR>", opts)
keymap("n", "<C-Down>", "<cmd>resize -2<CR>", opts)
keymap("n", "<C-Left>", "<cmd>vertical resize -2<CR>", opts)
keymap("n", "<C-Right>", "<cmd>vertical resize +2<CR>", opts)

-- Clear search with <esc>
keymap("n", "<esc>", "<cmd>noh<cr><esc>", opts)
keymap("i", "<esc>", "<cmd>noh<cr><esc>", opts)
keymap("n", "<leader>ur", "<Cmd>nohlsearch<Bar>diffupdate<Bar>normal! <C-L><CR>", { desc = "Redraw / clear hlsearch / diff update" })

-- Save in insert mode
keymap("i", "<C-s>", "<cmd>:w<cr><esc>", opts)
keymap("n", "<C-s>", "<cmd>:w<cr><esc>", opts)

-- Don't allow arrow keys, use hjkl instead
keymap('n', "<left>", "<nop>", opts)
keymap('n', "<right>", "<nop>", opts)
keymap('n', "<up>", "<nop>", opts)
keymap('n', "<down>", "<nop>", opts)



