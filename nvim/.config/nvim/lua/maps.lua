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

map('n', '<leader>tt', '<cmd>NvimTreeToggle<cr>', {})
map('n', '<leader>td', '<cmd>Telescope diagnostics<cr>', {})

map('n', '<leader>rr', '<cmd>lua vim.lsp.buf.rename()<cr>', {})
