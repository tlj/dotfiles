local M = {
	"mfussenegger/nvim-dap",
	dependencies = {
		{
			"theHamsta/nvim-dap-virtual-text",
			enabled = require("config.util").is_enabled("theHamsta/nvim-dap-virtual-text"),
			config = function()
				local status, nvimdapvirtualtext = pcall(require, "nvim-dap-virtual-text")
				if not status then
					return
				end
				nvimdapvirtualtext.setup({
					enabled = true,
					enabled_commands = true, -- create commands DapVirtualTextEnable, DapVirtualTextDisable, DapVirtualTextToggle, (DapVirtualTextForceRefresh for refreshing when debug adapter did not notify its termination)
					highlight_changed_variables = true, -- highlight changed values with NvimDapVirtualTextChanged, else always NvimDapVirtualText
					highlight_new_as_changed = false, -- highlight new variables in the same way as changed variables (if highlight_changed_variables)
					show_stop_reason = true, -- show stop reason when stopped for exceptions
					commented = true, -- prefix virtual text with comment string
					only_first_definition = true, -- only show virtual text at first definition (if there are multiple)
					all_references = false, -- show virtual text on all all references of the variable (not only definitions)
					filter_references_pattern = "<module", -- filter references (not definitions) pattern when all_references is activated (Lua gmatch pattern, default filters out Python modules)
					-- experimental features:
					virt_text_pos = "inline", -- position of virtual text, see `:h nvim_buf_set_extmark()`
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
				require("dap-go").setup({
					dap_configurations = {
						{
							type = "go",
							name = "Debug Workspace (arguments)",
							request = "launch",
							program = "${workspaceFolder}",
							args = function()
								local args_string = vim.fn.input("Arguments: ")
								return vim.split(args_string, " +")
							end,
						},
					},
				})
			end,
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
						},
					},
				})
			end,
		},
		-- mason.nvim integration
		{
			"jay-babu/mason-nvim-dap.nvim",
			dependencies = "mason.nvim",
			cmd = { "DapInstall", "DapUninstall" },
			opts = {
				-- Makes a best effort to setup the various debuggers with
				-- reasonable debug configurations
				automatic_installation = true,

				-- You can provide additional configuration to the handlers,
				-- see mason-nvim-dap README for more information
				handlers = {},

				-- You'll need to check that you have the required things installed
				-- online, please don't ask me how to install them :)
				ensure_installed = {
					-- Update this to ensure that you have the debuggers for the langs you want
					"php",
					"delve",
				},
			},
		},
		{
			"nvim-telescope/telescope-dap.nvim",
			dependencies = {
				"nvim-telescope/telescope.nvim",
			},
			config = function()
				require("telescope").load_extension("dap")
			end,
		},
	},
	keys = {
		{ "<F4>", '<cmd>lua require"dapui".toggle()<cr>' },
		{ "<F5>", '<cmd>lua require"dap".continue()<cr>' },
		{ "<F6>", '<cmd>lua require"dap".step_over()<cr>' },
		{ "<F7>", '<cmd>lua require"dap".step_into()<cr>' },
		{ "<F8>", '<cmd>lua require"dap".step_out()<cr>' },
		{ "<leader>db", '<cmd>lua require"dap".toggle_breakpoint()<CR>', desc = "Toggle debug breakpoint" },
		{
			"<leader>de",
			function()
				require("dapui").eval()
			end,
			desc = "Eval debug",
			mode = { "n", "v" },
		},
		{
			"<leader>dB",
			'<cmd>lua require"dap".set_breakpoint(vim.fn.input("Breakpoint condition: "))<cr>',
			desc = "Conditional breakpoint",
		},
		{ "<leader>dc", '<cmd>lua require"dap".continue()<CR>', desc = "Continue debug" },
		{ "<leader>ds", '<cmd>lua require"dap".close()<CR>', desc = "Close dap" },
		{ "<leader>do", '<cmd>lua require"dap".step_over()<CR>', desc = "Step over" },
		{ "<leader>di", '<cmd>lua require"dap".step_into()<CR>', desc = "Step into" },
		{ "<leader>dt", "<cmd>FzfLua dap_commands<CR>", desc = "Telescope DAP commands" },
		{ "<leader>dv", "<cmd>FzfLua dap_variables<CR>", desc = "Telescope DAP active session variables" },
		{ "<leader>dap", '<cmd>lua require"dapui".toggle()<cr>', desc = "DapUI Toggle" },
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

		--dap.adapters.php = {
		--  type = 'executable',
		--  command = 'node',
		--  args = { '/Users/tjohnsen/src/vscode-php-debug/out/phpDebug.js' }
		--}

		dap.configurations.php = {
			{
				type = "php",
				request = "launch",
				name = "Listen for Xdebug",
				port = 8090,
			},
		}

		vim.fn.sign_define("DapBreakpoint", { text = " ", texthl = "", linehl = "", numhl = "" })
		vim.fn.sign_define("DapBreakpointCondition", { text = " ", texthl = "", linehl = "", numhl = "" })
		vim.fn.sign_define(
			"DapBreakpointRejected",
			{ text = " ", texthl = "DiagnosticError", linehl = "", numhl = "" }
		)
		vim.fn.sign_define(
			"DapStopped",
			{ text = "󰁕 ", texthl = "DiagnosticWarn", linehl = "DapStoppedLine", numhl = "DapStoppedLine" }
		)
		vim.fn.sign_define("DapLogPoint", { text = ".>", texthl = "", linehl = "", numhl = "" })
		vim.api.nvim_set_hl(0, "DapStoppedLine", { default = true, link = "Visual" })
	end,
}

return M
