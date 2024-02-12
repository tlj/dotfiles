return {
	"sindrets/diffview.nvim",
	event = "VeryLazy",
	enabled = require("config.util").is_enabled("sindrets/diffview.nvim"),
	keys = {
		{ "<leader>hh", "<cmd>DiffviewOpen<cr>" },
		{ "<leader>hf", "<cmd>DiffviewFileHistory<cr>" },
		{ "<leader>hc", "<cmd>DiffviewClose<cr>" },
	},
	opts = {},
}
