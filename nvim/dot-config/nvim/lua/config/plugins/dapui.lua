return {
	settings = {
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
	},
	setup = function()
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
}
