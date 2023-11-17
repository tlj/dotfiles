return {
  "ibhagwan/fzf-lua",
  dependencies = { "nvim-tree/nvim-web-devicons" },
  config = function()
    require("fzf-lua").setup({
      previewers = {
        builtin = {
          extensions = {
            ["png"] = { "viu", "-b" },
            ["jpg"] = { "viu", "-b" },
          },
          ueberzug_scaler = "cover",
        }
      }
    })
  end,
  keys = {
    {'<leader>ff', '<cmd>FzfLua files<cr>' },
    {'<leader>fg', '<cmd>FzfLua live_grep<cr>' },
    {'<leader>*', '<cmd>FzfLua grep_cword<cr>' },
    {'<leader>fb', '<cmd>FzfLua buffers<cr>' },
    {'<leader>fh', '<cmd>FzfLua help_tags<cr>' },
    {'<leader>gs', '<cmd>FzfLua git_status<cr>' },
    {'<leader>td', '<cmd>FzfLua diagnostics_workspace<cr>' },
    {'<leader>qf', '<cmd>FzfLua quickfix<cr>' },
    {'<leader>u', "<cmd>Telescope undo<cr>" },
    {'<leader>gr', "<cmd>FzfLua lsp_incoming_calls<cr>" },
    {'<leader>gi', "<cmd>FzfLua lsp_implementations<cr>" },
    {'<leader>gd', "<cmd>FzfLua lsp_definitions<cr>" },
    {'q:', "<cmd>FzfLua command_history<cr>" },
    {'<leader>tm', "<cmd>FzfLua tmux_buffers<cr>" },
  },
}
