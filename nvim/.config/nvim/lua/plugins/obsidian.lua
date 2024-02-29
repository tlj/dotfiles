return {
	"epwalsh/obsidian.nvim",
	enabled = require("config.util").is_enabled("epwalsh/obsidian.nvim"),
	version = "*",
	lazy = true,
	ft = "markdown",
	-- Replace the above line with this if you only want to load obsidian.nvim for markdown files in your vault:
	-- event = {
	--   -- If you want to use the home shortcut '~' here you need to call 'vim.fn.expand'.
	--   -- E.g. "BufReadPre " .. vim.fn.expand "~" .. "/my-vault/**.md"
	--   "BufReadPre path/to/my-vault/**.md",
	--   "BufNewFile path/to/my-vault/**.md",
	-- },
	-- event = {
	-- 	"BufReadPre ~/Documents/Obsidian/**.md",
	-- 	"BufNewFile ~/Documents/Obsidian/**.md",
	-- },
	dependencies = {
		-- Required.
		"nvim-lua/plenary.nvim",
	},
	opts = {
		workspaces = {
			{
				name = "Privat",
				path = "~/Documents/Obsidian/Privat",
			},
			{
				name = "Work",
				path = "~/Documents/Obsidian/Work",
			},
		},

		daily_notes = {
			folder = "daily",
			date_format = "%Y/%m-%B/%Y-%m-%d-%A",
			template = "extras/templates/Template, daily.md",
		},

		new_notes_location = "INBOX",

		templates = {
			subdir = "extras/templates",
			date_format = "%Y-%m-%d",
			time_format = "%H:%M",
		},

		picker = {
			name = "fzf-lua",
		},
	},
}
