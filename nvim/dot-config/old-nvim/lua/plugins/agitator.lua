return {
	"emmanueltouzery/agitator.nvim",
	enabled = require("config.util").is_enabled("emmanueltouzery/agitator.nvim"),
	lazy = true,
	keys = {
		{ "<leader>gb", "<cmd>lua require'agitator'.git_blame_toggle()<cr>", desc = "Toggle the git blame." },
	},
}
