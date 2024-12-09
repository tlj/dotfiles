return {
	"FredeEB/tardis.nvim",
	enabled = require("config.util").is_enabled("FredeEB/tardis.nvim"),
	dependencies = { 'nvim-lua/plenary.nvim' },
	lazy = true,
	opts = {},
	keys = {
		{ "<leader>gp", "<cmd>Tardis<cr>", desc = "Previous git revision (Tardis)" },
	},
}
