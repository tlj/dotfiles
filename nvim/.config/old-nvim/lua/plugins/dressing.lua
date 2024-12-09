return {
	"stevearc/dressing.nvim",
	enabled = require("config.util").is_enabled("stevearc/dressing.nvim"),
	opts = {
		select = {
			backend = { "fzf_lua", "fzf", "telescope", "builtin", "nui" },
		},
	},
}
