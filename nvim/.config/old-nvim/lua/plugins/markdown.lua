local M = {
	"MeanderingProgrammer/render-markdown.nvim",
	enabled = require("config.util").is_enabled("MeanderingProgrammer/render-markdown.nvim"),
	opts = {},
	dependencies = { "nvim-treesitter/nvim-treesitter", "echasnovski/mini.icons" }, -- if you use standalone mini plugins
}

return M
