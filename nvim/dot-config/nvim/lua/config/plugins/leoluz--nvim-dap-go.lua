return {
	repo = "leoluz/nvim-dap-go",
	after = { "mfussenegger/nvim-dap" },
	setup = function(settings) require("dap-go").setup(settings) end,
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
