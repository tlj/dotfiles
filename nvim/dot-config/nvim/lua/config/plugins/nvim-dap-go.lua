return {
	after = { "mfussenegger/nvim-dap" },
	settings = {
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
	},
}
