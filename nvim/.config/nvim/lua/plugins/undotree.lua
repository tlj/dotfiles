return {
	"mbbill/undotree",
	enabled = require("config.util").is_enabled("mbbill/undotree"),
	lazy = true,
	cmd = "UndotreeToggle",
	keys = { 
		{ "<leader>uu", ":UndotreeToggle<CR>", { desc = "UndotreeToggle" } },
	},
}
