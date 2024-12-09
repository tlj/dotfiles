-- fast switching between files in a better way than regular marks
return {
	"ThePrimeagen/harpoon",
	enabled = require("config.util").is_enabled("ThePrimeagen/harpoon"),
	lazy = false,
	branch = "harpoon2",
	dependencies = {
		"nvim-lua/plenary.nvim",
	},
	opts = {},
	config = function()
		local harpoon = require("harpoon")

		harpoon:setup({ settings = { save_on_ui_close = true } })

		vim.keymap.set("n", "<leader>hm", function()
			harpoon:list():append()
		end, { desc = "Mark file with harpoon" })

		vim.keymap.set("n", "<leader>ha", function()
			harpoon.ui:toggle_quick_menu(harpoon:list())
		end, { desc = "Open harpoon ui" })

		vim.keymap.set("n", "<leader>hn", function()
			harpoon:list():next()
		end, { desc = "Next mark in harpoon list" })

		vim.keymap.set("n", "<leader>hp", function()
			harpoon:list():prev()
		end, { desc = "Prev mark in harpoon list" })
	end,
}
