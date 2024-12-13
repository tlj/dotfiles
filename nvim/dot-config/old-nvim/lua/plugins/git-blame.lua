return {
	"f-person/git-blame.nvim",
	enabled = require("config.util").is_enabled("f-person/git-blame.nvim"),
	lazy = true,
	keys = {
		{ "<leader>gb", "<cmd>GitBlameToggle<cr>", desc = "Toggle the git blame." },
	},
}
