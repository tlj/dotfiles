-- A vim-vinegar like file explorer that lets you edit your filesystem like a 
-- normal Neovim buffer.
--
-- I prefer this to navigating/editing the filesystem through a tree 
-- navigator, and it fits my workflow perfectly.
--
-- https://github.com/stevearc/oil.nvim
return {
	"stevearc/oil.nvim",
	enabled = true,
  lazy = true,
	keys = {
		{
			"<leader>tt",
			function()
				require("oil").open_float()
			end,
			desc = "Oil file explorer",
		},
	},
	cmd = "Oil",
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

