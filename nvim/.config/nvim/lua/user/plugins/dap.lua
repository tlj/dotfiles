local M = {
  "mfussenegger/nvim-dap",
  dependencies = {
    "theHamsta/nvim-dap-virtual-text",
    {
      "leoluz/nvim-dap-go",
      config = function()
        require('dap-go').setup()
      end
    },
    {
      "rcarriga/nvim-dap-ui",
      enabled = false,
      config = function()
        require("dapui").setup({
          layouts = {
            {
                elements = {
                { id = "scopes", size = 0.25 },
                "breakpoints",
                "watches",
                "stacks",
              },
              size = 30,
              position = "left",
            },
            {
              elements = {
                "repl",
                "console"
              },
              size = 5,
              position = "bottom",
            }
          }
        })
      end
    },
    {
      "nvim-telescope/telescope-dap.nvim",
      dependencies = {
        "nvim-telescope/telescope.nvim",
      },
      config = function()
        require("telescope").load_extension("dap")
      end
    },
  },
  keys = {
    -- { '<F4>', '<cmd>lua require"dapui".toggle()<cr>' },
    { '<F5>', '<cmd>lua require"dap".continue()<cr>' },
    { '<F6>', '<cmd>lua require"dap".step_over()<cr>' },
    { '<F7>', '<cmd>lua require"dap".step_into()<cr>' },
    { '<F8>', '<cmd>lua require"dap".step_out()<cr>' },
    { '<leader>db', '<cmd>lua require"dap".toggle_breakpoint()<CR>' },
    { '<leader>dB', '<cmd>lua require"dap".set_brakpoint(vim.fn.input("Breakpoint condition: "))<cr>' },
    { '<leader>dc', '<cmd>lua require"dap".continue()<CR>' },
    { '<leader>ds', '<cmd>lua require"dap".stop()<CR>' },
    { '<leader>do', '<cmd>lua require"dap".step_over()<CR>' },
    { '<leader>di', '<cmd>lua require"dap".step_into()<CR>' },
    { '<leader>dt', '<cmd>Telescope dap commands<CR>' },
    { '<leader>dap', '<cmd>lua require"dapui".toggle()<cr>' },
  },
  config = function()
    local dap, dapui = require("dap"), require("dapui")
    dap.listeners.after.event_initialized["dapui_config"] = function()
      dapui.open()
    end
    dap.listeners.before.event_terminated["dapui_config"] = function()
      dapui.close()
    end
    dap.listeners.before.event_exited["dapui_config"] = function()
      dapui.close()
    end

    dap.adapters.php = {
      type = 'executable',
      command = 'node',
      args = { '/Users/tjohnsen/src/vscode-php-debug/out/phpDebug.js' }
    }

    dap.configurations.php = {
      {
        type = 'php',
        request = 'launch',
        name = 'Listen for Xdebug',
        port = 8090
      }
    }

    vim.fn.sign_define('DapBreakpoint', { text = '🟥', texthl = '', linehl = '', numhl = '' })
    vim.fn.sign_define('DapStopped', { text = '▶️', texthl = '', linehl = '', numhl = '' })
  end
}

return M
