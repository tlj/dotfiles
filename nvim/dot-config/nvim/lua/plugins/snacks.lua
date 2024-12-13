-- A collection of small QoL plugins for Neovim.
--
-- I use only some of these. Not usually a fan of dashboards, but testing
-- it with this and it works nicely. It has really good integration with
-- Lazygit on the '<leader>l' prefix. I've also not used notifiers a lot
-- before but this one is nice and non-intrusive, so testing it.
--
-- https://github.com/folke/snacks.nvim
return {
	"folke/snacks.nvim",
	priority = 1000,
	lazy = false,
	cmd = "Snacks",
	opts = {
		-- your configuration comes here
		-- or leave it empty to use the default settings
		-- refer to the configuration section below
		bigfile = { enabled = true }, -- Deal with big files
		quickfile = { enabled = true }, -- When doing nvim somefile.txt, it will render the file as quickly as possible, before loading your plugins.
		lazygit = { enabled = true, configure = false }, -- Open LazyGit in a float, auto-configure colorscheme and integration with Neovim
		toggle = { enabled = true }, -- Toggle keymaps integrated with which-key icons / colors
		words = { enabled = true }, -- Auto-show LSP references and quickly navigate between them
		dashboard = {
			enabled = true,
			sections = {
				{
					section = "terminal",
					cmd = "fortune -s -n 90 | cowsay",
					hl = "header",
					padding = 1,
					indent = 8,
					height = 11,
				},
				{ section = "keys" },
				{
					icon = "󱏒 ",
					desc = "Oil",
					action = function()
						require("oil").open_float()
					end,
					padding = 1,
					key = "t",
				},
				{ title = "MRU ", file = vim.fn.fnamemodify(".", ":~"), padding = 1 },
				{ section = "recent_files", cwd = true, limit = 5, padding = 1 },
				{
					section = "terminal",
					icon = " ",
					title = "Git Status",
					cmd = "hub --no-pager diff --stat -B -M -C",
					ttl = 5 * 60,
					height = 10,
				},
			},
		}, -- Beautiful declarative dashboards
		terminal = { enabled = true }, -- Create and toggle floating/split terminals
		--
		animate = { enabled = false }, -- Efficient animations including over 45 easing functions (library)
		bufdelete = { enabled = false }, -- Delete buffers without disrupting window layout
		debug = { enabled = false }, -- Pretty inspect & backtraces for debugging
		dim = { enabled = false }, -- Focus on the active scope by dimming the rest
		git = { enabled = false }, -- Git utilities
		gitbrowse = { enabled = false }, -- Open the current file, branch, commit, or repo in a browser (e.g. GitHub, GitLab, Bitbucket)
		indent = { enabled = false }, -- Indent guides and scopes
		input = { enabled = false }, -- Better vim.ui.input
		notifier = { enabled = true }, -- Pretty vim.notify
		profiler = { enabled = false }, -- Neovim lua profiler
		rename = { enabled = false }, -- LSP-integrated file renaming with support for plugins like neo-tree.nvim and mini.files.
		scope = { enabled = false }, -- Scope detection based on treesitter or indent (library)
		scratch = { enabled = false }, -- Scratch buffers with a persistent file
		scroll = { enabled = false }, -- Smooth scrolling
		statuscolumn = { enabled = false }, -- Pretty status column
		win = { enabled = false }, --  Create and manage floating windows or splits
		zen = { enabled = false }, -- Zen mode • distraction-free coding
	},
	keys = {
		{
			"<leader>lg",
			function()
				Snacks.lazygit()
			end,
			desc = "Lazygit",
		},
		{
			"<leader>ll",
			function()
				Snacks.lazygit.log()
			end,
			desc = "Lazygit Log",
		},
		{
			"<leader>lf",
			function()
				Snacks.lazygit.log_file()
			end,
			desc = "Lazygit File Log",
		},
		{
			"<leader>lb",
			function()
				Snacks.git.blame_line()
			end,
			desc = "Lazygit Blame",
		},
		{
			"<leader>ft",
			function()
				Snacks.terminal()
			end,
			desc = "Terminal",
		},
		{
			"<leader>nh",
			function()
				Snacks.notifier.show_history()
			end,
			desc = "Notification History",
		},
		{
			"]]",
			function()
				Snacks.words.jump(vim.v.count1)
			end,
			desc = "Next Reference",
			mode = { "n", "t" },
		},
		{
			"[[",
			function()
				Snacks.words.jump(-vim.v.count1)
			end,
			desc = "Prev Reference",
			mode = { "n", "t" },
		},
	},
}
