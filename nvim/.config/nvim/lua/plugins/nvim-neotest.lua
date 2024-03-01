local M = {
	"nvim-neotest/neotest",
	enabled = require("config.util").is_enabled("nvim-neotest/neotest"),
	dependencies = {
		"nvim-lua/plenary.nvim",
		"nvim-treesitter/nvim-treesitter",
		{ "antoinemadec/FixCursorHold.nvim" },
		"nvim-neotest/neotest-go",
	},
	keys = {
		{ "<leader>tn", '<cmd>lua require"neotest".run.run()<cr>', desc = "Run current test" },
		{ "<leader>tf", '<cmd>lua require"neotest".run.run(vim.fn.expand("%"))<cr>', desc = "Run tests in file" },
	},
	config = function()
		local neotest_ns = vim.api.nvim_create_namespace("neotest")
		vim.diagnostic.config({
			virtual_text = {
				format = function(diagnostic)
					local message = diagnostic.message:gsub("\n", " "):gsub("\t", " "):gsub("%s+", " "):gsub("^%s+", "")
					return message
				end,
			},
		}, neotest_ns)
		require("neotest").setup({
			diagnostic = {
				enabled = true,
			},
			status = {
				virtual_text = true,
				signs = true,
			},
			adapters = {
				require("neotest-go"),
			},
		})
	end,
}

return M
