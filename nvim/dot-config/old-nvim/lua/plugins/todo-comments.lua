return {
	"folke/todo-comments.nvim",
	enabled = require("config.util").is_enabled("folke/todo-comments.nvim"),
	dependencies = { "nvim-lua/plenary.nvim" },
	opts = { signs = false }
}
