local M = {
  "kessejones/git-blame-line.nvim",
  keys = {
    { "<leader>gb", "<cmd>GitBlameLineToggle<cr>", desc = "Toggle inline git blame." },
  },
  config = function()
    -- Git blamer inline
    require 'git-blame-line'.setup({
      git = {
        default_message = 'Not committed yet',
        blame_format = '%an - %ar - %s' -- see https://git-scm.com/docs/pretty-formats
      },
      view = {
        left_padding_size = 5,
        enable_cursor_hold = false
      }
    })
  end
}

return M
