-- better quickfix window with preview
local M = {
  "kevinhwang91/nvim-bqf",
  ft = "qf",
  dependencies = {
    {
      "junegunn/fzf",
      build = function()
        vim.fn['fzf#install']()
      end
    }
  }
}

return M
