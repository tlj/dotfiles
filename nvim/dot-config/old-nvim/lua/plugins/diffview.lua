return {
	"sindrets/diffview.nvim",
	event = "VeryLazy",
	enabled = require("config.util").is_enabled("sindrets/diffview.nvim"),
	keys = {
		{ "<leader>hh", "<cmd>DiffviewOpen<cr>", desc = "Diff View Open" },
		{ "<leader>hf", "<cmd>DiffviewFileHistory %<cr>", desc = "File History" },
		{ "<leader>hw", "<cmd>DiffviewFileHistory<cr>", desc = "Workspace History" },
		{ "<leader>hc", "<cmd>DiffviewClose<cr>", desc = "Diff View Close" },
	},
	opts = {},
}
