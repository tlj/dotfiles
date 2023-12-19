local M = {
	"nvim-neotest/neotest",
	dependencies = {
		"nvim-lua/plenary.nvim",
		"nvim-treesitter/nvim-treesitter",
		{ "antoinemadec/FixCursorHold.nvim" },
		"nvim-neotest/neotest-go",
	},
	keys = {
		{ "<leader>tn", '<cmd>lua require"neotest".run.run()<cr>' },
		{ "<leader>tf", '<cmd>lua require"neotest".run.run(vim.fn.expand("%"))<cr>' },
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
