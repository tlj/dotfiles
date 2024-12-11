local M = {
	"folke/snacks.nvim",
	priority = 1000,
	lazy = false,
	cmd = "Snacks",
	opts = {
		-- your configuration comes here
		-- or leave it empty to use the default settings
		-- refer to the configuration section below
		animate = { enabled = true }, -- Efficient animations including over 45 easing functions (library)
		bigfile = { enabled = true }, -- Deal with big files
		bufdelete = { enabled = false }, -- Delete buffers without disrupting window layout
		dashboard = { enabled = true }, -- Beautiful declarative dashboards
		debug = { enabled = false }, -- Pretty inspect & backtraces for debugging
		dim = { enabled = false }, -- Focus on the active scope by dimming the rest
		git = { enabled = false }, -- Git utilities
		gitbrowse = { enabled = false }, -- Open the current file, branch, commit, or repo in a browser (e.g. GitHub, GitLab, Bitbucket)
		indent = { enabled = false }, -- Indent guides and scopes
		input = { enabled = true }, -- Better vim.ui.input
		lazygit = { enabled = true }, -- Open LazyGit in a float, auto-configure colorscheme and integration with Neovim
		notifier = { enabled = false }, -- Pretty vim.notify
		profiler = { enabled = false }, -- Neovim lua profiler
		quickfile = { enabled = true }, -- When doing nvim somefile.txt, it will render the file as quickly as possible, before loading your plugins.
		rename = { enabled = false }, -- LSP-integrated file renaming with support for plugins like neo-tree.nvim and mini.files.
		scope = { enabled = false }, -- Scope detection based on treesitter or indent (library)
		scratch = { enabled = false }, -- Scratch buffers with a persistent file
		scroll = { enabled = false }, -- Smooth scrolling
		statuscolumn = { enabled = false }, -- Pretty status column
		terminal = { enabled = true }, -- Create and toggle floating/split terminals
		toggle = { enabled = true }, -- Toggle keymaps integrated with which-key icons / colors
		win = { enabled = false }, --  Create and manage floating windows or splits
		words = { enabled = true }, -- Auto-show LSP references and quickly navigate between them
		zen = { enabled = false }, -- Zen mode • distraction-free coding
	},
	keys = {
		{ "<leader>lg", function() Snacks.lazygit() end, desc = "Lazygit" },
		{ "<leader>ll", function() Snacks.lazygit.log() end, desc = "Lazygit Log" },
		{ "<leader>lf", function() Snacks.lazygit.log_file() end, desc = "Lazygit File Log" },
		{ "<leader>lb", function() Snacks.git.blame_line() end, desc = "Lazygit Blame" },
		{ "<leader>ft", function() Snacks.terminal() end, desc = "Terminal" },
		{ "]]", function() Snacks.words.jump(vim.v.count1) end, desc = "Next Reference", mode = { "n", "t" } },
		{ "[[", function() Snacks.words.jump(-vim.v.count1) end, desc = "Prev Reference", mode = { "n", "t" } },
	},
}

return M
