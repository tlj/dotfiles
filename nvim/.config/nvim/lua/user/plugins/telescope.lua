local M = {
  "nvim-telescope/telescope.nvim",
  cmd = { "Telescope" },
  dependencies = {
    "nvim-lua/plenary.nvim",
    "sharkdp/fd",
    "nvim-tree/nvim-web-devicons",
    { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
  },
  config = function()
    require("telescope").setup({
      defaults = {
        file_ignore_patterns = { "node_modules", ".git" },
      },
      pickers = {
        find_files = {
          hidden = true,
        },
      },
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
    {'gr', "<cmd>lua require('telescope.builtin').lsp_references()<cr>" },
  },
}

return M
