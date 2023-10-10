local M = {
  "mfussenegger/nvim-dap",
  dependencies = {
    {
      "theHamsta/nvim-dap-virtual-text",
      enabled = true,
      config = function()
        local status, nvimdapvirtualtext = pcall(require, 'nvim-dap-virtual-text')
        if not status then
          return
        end
        nvimdapvirtualtext.setup({
          enabled = true,
          enabled_commands = true, -- create commands DapVirtualTextEnable, DapVirtualTextDisable, DapVirtualTextToggle, (DapVirtualTextForceRefresh for refreshing when debug adapter did not notify its termination)
          highlight_changed_variables = true, -- highlight changed values with NvimDapVirtualTextChanged, else always NvimDapVirtualText
          highlight_new_as_changed = false, -- highlight new variables in the same way as changed variables (if highlight_changed_variables)
          show_stop_reason = true, -- show stop reason when stopped for exceptions
          commented = false, -- prefix virtual text with comment string
          only_first_definition = true, -- only show virtual text at first definition (if there are multiple)
          all_references = false, -- show virtual text on all all references of the variable (not only definitions)
          filter_references_pattern = '<module', -- filter references (not definitions) pattern when all_references is activated (Lua gmatch pattern, default filters out Python modules)
          -- experimental features:
          virt_text_pos = 'eol', -- position of virtual text, see `:h nvim_buf_set_extmark()`
          all_frames = false, -- show virtual text for all stack frames not only current. Only works for debugpy on my machine.
          virt_lines = false, -- show virtual lines instead of virtual text (will flicker!)
          virt_text_win_col = nil, -- position the virtual text at a fixed window column (starting from the first text column) ,
          -- e.g. 80 to position at column 80, see `:h nvim_buf_set_extmark()`
        })
      end,
    },
    {
      "leoluz/nvim-dap-go",
      config = function()
        require('dap-go').setup({
          dap_configurations = {
            {
              type = 'go',
              name = 'Debug Workspace (arguments)',
              request = 'launch',
              program = "${workspaceFolder}",
              args = function()
                local args_string = vim.fn.input('Arguments: ')
                return vim.split(args_string, ' +')
              end,
            }
          }
        })
      end
    },
    {
      "rcarriga/nvim-dap-ui",
      enabled = true,
      config = function()
        require("dapui").setup({
          layouts = {
            {
              elements = {
                { id = "scopes", size = 0.40 },
                { id = "watches", size = 0.30 },
                { id = "repl", size = 0.30 },
              },
              size = 10,
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
    { '<F4>', '<cmd>lua require"dapui".toggle()<cr>' },
    { '<F5>', '<cmd>lua require"dap".continue()<cr>' },
    { '<F6>', '<cmd>lua require"dap".step_over()<cr>' },
    { '<F7>', '<cmd>lua require"dap".step_into()<cr>' },
    { '<F8>', '<cmd>lua require"dap".step_out()<cr>' },
    { '<leader>db', '<cmd>lua require"dap".toggle_breakpoint()<CR>' },
    { '<leader>dB', '<cmd>lua require"dap".set_brakpoint(vim.fn.input("Breakpoint condition: "))<cr>' },
    { '<leader>dc', '<cmd>lua require"dap".continue()<CR>' },
    { '<leader>ds', '<cmd>lua require"dap".close()<CR>' },
    { '<leader>do', '<cmd>lua require"dap".step_over()<CR>' },
    { '<leader>di', '<cmd>lua require"dap".step_into()<CR>' },
    { '<leader>dt', '<cmd>Telescope dap commands<CR>' },
    { '<leader>dap', '<cmd>lua require"dapui".toggle()<cr>' },
  },
  config = function()
    local dap, dapui = require("dap"), require("dapui")
    -- dap.listeners.after.event_initialized["dapui_config"] = function()
    --  dapui.open()
    -- end
    -- dap.listeners.before.event_terminated["dapui_config"] = function()
    --   dapui.close()
    -- end
    -- dap.listeners.before.event_exited["dapui_config"] = function()
    --   dapui.close()
    -- end

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
