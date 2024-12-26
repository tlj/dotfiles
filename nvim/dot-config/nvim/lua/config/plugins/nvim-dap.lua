return {
	requires = { "ibhagwan/fzf-lua" },
	settings = {},
	name = "dap",
	setup = function(_)
		local dap = require("dap")

		dap.adapters.php = {
			type = "executable",
			command = "node",
			args = { vim.fn.expand("$HOME") .. "/src/vscode-php-debug/out/phpDebug.js" },
		}

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
		vim.fn.sign_define("DapBreakpointRejected", { text = " ", texthl = "DiagnosticError", linehl = "", numhl = "" })
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
		["<leader>de"] = {
			cmd = function() require("dapui").eval() end,
			desc = "Eval debug",
			mode = { "n", "v" },
		},
		["<leader>db"] = { cmd = '<cmd>lua require"dap".toggle_breakpoint()<CR>', desc = "Set breakpoint" },
		["<leader>dB"] = {
			cmd = '<cmd>lua require"dap".set_breakpoint(vim.fn.input("Breakpoint condition: "))<cr>',
			desc = "Conditional breakpoint",
		},
		["<leader>dc"] = {
			cmd = function()
				if vim.fn.filereadable(".vscode/launch.json") then
					require("dap.ext.vscode").load_launchjs()
				end
				require("fzf-lua").dap_configurations()
			end,
			desc = "Continue debug",
		},
		["<leader>dC"] = { cmd = '<cmd>lua require"dap".run_to_cursor()<CR>', desc = "Stop debugging" },
		["<leader>ds"] = { cmd = '<cmd>lua require"dap".terminate()<CR>', desc = "Stop debugging" },
		["<leader>do"] = { cmd = '<cmd>lua require"dap".step_over()<CR>', desc = "Step over" },
		["<leader>di"] = { cmd = '<cmd>lua require"dap".step_into()<CR>', desc = "Step into" },
		["<leader>dt"] = { cmd = "<cmd>FzfLua dap_commands<CR>", desc = "Telescope DAP commands" },
		["<leader>dv"] = { cmd = "<cmd>FzfLua dap_variables<CR>", desc = "Telescope DAP active session variables" },
		["<leader>dw"] = { cmd = '<cmd>lua require"dap.ui.widgets".hover()<CR>', desc = "Hover widgets" },
	},
}
