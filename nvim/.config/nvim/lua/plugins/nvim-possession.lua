return {
	"gennaro-tedesco/nvim-possession",
	enabled = require("config.util").is_enabled("gennaro-tedesco/nvim-possession"),
	dependencies = {
		"ibhagwan/fzf-lua",
	},
	init = function()
		local possession = require("nvim-possession")
		-- jj because it's easy to type
		vim.keymap.set("n", "<leader>jj", function()
			possession.list()
		end)
		vim.keymap.set("n", "<leader>jn", function()
			possession.new()
		end)
		vim.keymap.set("n", "<leader>ju", function()
			possession.update()
		end)
		vim.keymap.set("n", "<leader>jd", function()
			possession.delete()
		end)
	end,
	config = function()
		require("nvim-possession").setup({
			autoload = false,
			autosave = true,
			autoswitch = {
				enable = true,
			},
		})
	end,
}
