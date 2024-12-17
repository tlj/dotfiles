-- DAP nvim-dap is a Debug Adapter Protocol client implementation for Neovim.
--
-- Debug applications with Neovim, using DAP and DAP UI. Debug configurations
-- are automatically read from .vscode/launch.json if it exists.
--
-- https://github.com/mfussenegger/nvim-dap

-- Nicer input
--
-- local function get_arguments()
-- 	return coroutine.create(function(dap_run_co)
-- 		local args = {}
-- 		vim.ui.input({ prompt = "Args: " }, function(input)
-- 			args = vim.split(input or "", " ")
-- 			coroutine.resume(dap_run_co, args)
-- 		end)
-- 	end)
-- end
plugin("nvim-dap-virtual-text", {
	setup = function()
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
})

plugin("nvim-dap-go", {
	setup = function()
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
})

plugin("nvim-nio", {})

plugin("nvim-dap-ui", {
	before = { "nvim-nio" },
	setup = function()
		require("dapui").setup({
			layouts = {
				{
					elements = {
						{ id = "scopes", size = 0.60 },
						{ id = "watches", size = 0.20 },
						{ id = "breakpoints", size = 0.20 },
					},
					size = 70,
					position = "left",
				},
				{
					elements = {
						"repl",
					},
					size = 10,
					position = "bottom",
				},
			},
		})

		local dap, dapui = require("dap"), require("dapui")
		dap.listeners.after.event_initialized["dapui_config"] = function()
			vim.notify("Debug session started.")
			dapui.open()
		end
		dap.listeners.before.event_terminated["dapui_config"] = function()
			vim.notify("Debug session stopped.")
			dapui.close()
		end
		dap.listeners.before.event_exited["dapui_config"] = function()
			vim.notify("Debug session stopped.")
			dapui.close()
		end
	end,
})

plugin("nvim-dap", {
	after = { "nvim-dap-virtual-text", "nvim-dap-go", "nvim-dap-ui" },
	setup = function()
		local dap = require("dap")
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
	keys = {
		["<F4>"] = { cmd = '<cmd>lua require"dapui".toggle()<cr>' },
		["<F5>"] = { cmd = '<cmd>lua require"dap".continue()<cr>' },
		["<F6>"] = { cmd = '<cmd>lua require"dap".step_over()<cr>' },
		["<F7>"] = { cmd = '<cmd>lua require"dap".step_into()<cr>' },
		["<F8>"] = { cmd = '<cmd>lua require"dap".step_out()<cr>' },
		["<leader>de"] = { cmd = function() require("dapui").eval() end, desc = "Eval debug", mode = { "n", "v" }, },
		["<leader>dB"] = { cmd = '<cmd>lua require"dap".set_breakpoint(vim.fn.input("Breakpoint condition: "))<cr>', desc = "Conditional breakpoint", },
		["<leader>dc"] = { cmd = function() if vim.fn.filereadable(".vscode/launch.json") then require("dap.ext.vscode").load_launchjs() end require("fzf-lua").dap_configurations() end, desc = "Continue debug", },
		["<leader>dC"] = { cmd = '<cmd>lua require"dap".run_to_cursor()<CR>', desc = "Stop debugging" },
		["<leader>ds"] = { cmd = '<cmd>lua require"dap".terminate()<CR>', desc = "Stop debugging" },
		["<leader>do"] = { cmd = '<cmd>lua require"dap".step_over()<CR>', desc = "Step over" },
		["<leader>di"] = { cmd = '<cmd>lua require"dap".step_into()<CR>', desc = "Step into" },
		["<leader>dw"] = { cmd = '<cmd>lua require"dap.ui.widgets".hover()<CR>', desc = "Hover widgets" },
		["<leader>dt"] = { cmd = "<cmd>FzfLua dap_commands<CR>", desc = "Telescope DAP commands" },
		["<leader>dv"] = { cmd = "<cmd>FzfLua dap_variables<CR>", desc = "Telescope DAP active session variables" },
		["<leader>dap"] = { cmd = '<cmd>lua require"dapui".toggle()<cr>', desc = "DapUI Toggle" },
	},
})
