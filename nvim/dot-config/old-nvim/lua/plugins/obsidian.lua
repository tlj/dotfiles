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
	keys = {
		{ "<leader>od", "<cmd>ObsidianToday<CR>", desc = "Open today's note" },
		{ "<leader>oy", "<cmd>ObsidianYesterday<CR>", desc = "Open yesterdays note" },
		{ "<leader>om", "<cmd>ObsidianTomorrow<CR>", desc = "Open tomorrows note" },
		{ "<leader>ot", "<cmd>ObsidianTags<CR>", desc = "Open Obsidian tags picker" },
		{ "<leader>ob", "<cmd>ObsidianBacklinks<CR>", desc = "Open Obsidian backlinks picker" },
		{ "<leader>oq", "<cmd>ObsidianQuickSwitch<CR>", desc = "Open Obsidian quickswitcher" },
		{ "<leader>os", "<cmd>ObsidianSearch<CR>", desc = "Open Obsidian search" },
		{ "<leader>or", "<cmd>ObsidianRename<CR>", desc = "Obsidian Rename, update backlinks" },
		{ "<leader>ol", "<cmd>ObsidianLinks<CR>", desc = "Open Obsidian Links picker" },
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
