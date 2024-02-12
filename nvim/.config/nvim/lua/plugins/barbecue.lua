-- winbar (top bar with breadcrumbs)
return {
	"utilyre/barbecue.nvim",
	version = "*",
	lazy = true,
	event = "BufReadPre",
	enabled = require("config.util").is_enabled("utilyre/barbecue.nvim"),
	dependencies = {
		"neovim/nvim-lspconfig",
		"SmiteshP/nvim-navic",
		"nvim-tree/nvim-web-devicons",
	},
	opts = {},
}
