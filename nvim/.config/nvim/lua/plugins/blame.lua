return {
	"FabijanZulj/blame.nvim",
	version = "*",
	lazy = true,
	event = "BufReadPre",
	enabled = require("config.util").is_enabled("FabijanZulj/blame.nvim"),
	opts = {
		commit_detail_view = "split",
	},
	keys = {
		{ "<leader>gb", "<cmd>ToggleBlame<cr>", desc = "Toggle Git Blame." },
	}
}
