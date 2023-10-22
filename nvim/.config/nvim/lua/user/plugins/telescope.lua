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
        file_ignore_patterns = { "node_modules", "%.git", "var/cache", "%.idea", "%.vscode", "var" },
        layout_strategy = "flex",
        layout_config = {
          prompt_position = "bottom",
          height = 0.9,
          width = 0.9,
          flex = {
            flip_columns = 120,
          },
          horizontal = {
            preview_cutoff = 80,
          },
          vertical = {
            preview_cutoff = 30,
          }
        }
      },
      pickers = {
        find_files = {
          hidden = true,
          no_ignore = false,
        },
        live_grep = {
          additional_args = function(_)
            return {"--hidden"}
          end
        },
        grep_string = {
          additional_args = function(_)
            return {"--hidden"}
          end
        },
        colorscheme = {
          enable_preview = true,
        }
      },
      extensions = {
        undo = {
          side_by_side = true,
          layout_strategy = "vertical",
          layout_config = {
            preview_height = 0.8,
          },
        },
        file_browser = {
        },
      },
    })
  end,
  keys = {
    {'<leader>ff', '<cmd>lua require"telescope.builtin".find_files({hidden = true})<cr>' },
    {'<leader>fg', '<cmd>lua require"telescope.builtin".live_grep()<cr>' },
    {'<leader>*', '<cmd>lua require"telescope.builtin".grep_string()<cr>' },
    {'<leader>fb', '<cmd>lua require"telescope.builtin".buffers()<cr>' },
    {'<leader>fh', '<cmd>lua require"telescope.builtin".help_tags()<cr>' },
    {'<leader>gs', '<cmd>lua require"telescope.builtin".git_status()<cr>' },
    {'<leader>td', '<cmd>Telescope diagnostics<cr>' },
    {'<leader>qf', '<cmd>lua require"telescope.builtin".quickfix()<cr>' },
    {"<leader>u", "<cmd>Telescope undo<cr>" },
--    {'gr', "<cmd>lua require('telescope.builtin').lsp_references()<cr>" },
--    {'gi', "<cmd>lua require('telescope.builtin').lsp_implementations()<cr>" },
--    {'gd', "<cmd>lua require('telescope.builtin').lsp_definitions()<cr>" },
    {'q:', "<cmd>lua require('telescope.builtin').command_history()<cr>" },
  },
}

return M
