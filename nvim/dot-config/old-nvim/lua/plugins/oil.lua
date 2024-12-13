return {
	"stevearc/oil.nvim",
	enabled = require("config.util").is_enabled("stevearc/oil.nvim"),
	keys = {
		{
			"<leader>tt",
			function()
				require("oil").open_float()
			end,
			desc = "Oil file explorer",
		},
	},
	opts = {
		view_options = {
			show_hidden = true,
		},
		keymaps = {
			["g?"] = "actions.show_help",
			["<CR>"] = "actions.select",
			["<C-s>"] = "actions.select_vsplit",
			["<C-v>"] = "actions.select_split",
			["<C-t>"] = "actions.select_tab",
			["<C-p>"] = "actions.preview",
			["<C-c>"] = "actions.close",
			["<C-l>"] = "actions.refresh",
			["-"] = "actions.parent",
			["_"] = "actions.open_cwd",
			["`"] = "actions.cd",
			["~"] = "actions.tcd",
			["gs"] = "actions.change_sort",
			["gx"] = "actions.open_external",
			["g."] = "actions.toggle_hidden",
			["g\\"] = "actions.toggle_trash",
		},
		-- Set to false to disable all of the above keymaps
		use_default_keymaps = true,
	},
	-- Optional dependencies
	dependencies = { "nvim-tree/nvim-web-devicons" },
}
