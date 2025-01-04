-- Set up some Neovim options, mappings and auto commands
require("config.options")
require("config.mappings")
require("config.autocmds")

-- Load my own embedded plugins
require("statusline").setup()
require("lazygit").setup()

-- Use the include() method as shorthand for including a plugin spec defined
-- in the lua/config/plugins folder. Use this if the spec is more than ~5 lines
-- to keep the init file clean, but for smaller definitions we define them
-- here. We don't do automatic loading of spec files, since we want to be explicit
-- about what we load.
local include = require("graft").include
require("graft").setup({
	start = {
		{
			-- gruvbox is objectively the best colorscheme, as it is not blue
			"luisiacc/gruvbox-baby",
			function() vim.cmd("colorscheme gruvbox-baby") end,
		},
		{
			-- pretty notifications - not strictly nece
			"rcarriga/nvim-notify",
			function()
				local notify = require("notify")
				notify.setup({ stages = "static" })
				vim.notify = notify
			end,
		},
		-- LSP completions for CMP
		-- Has to be loaded at startup so it can be used in v0.11 style lsp config
		"hrsh7th/cmp-nvim-lsp",
	},
	opt = {
		{
			-- Icons for the plugins which require them - currently only Oil.nvim
			"nvim-tree/nvim-web-devicons",
			function(settings) require("nvim-web-devicons").setup(settings) end,
			settings = { color_icons = true },
		},

		-- AI stuff
		include("zbirenbaum/copilot.lua"), -- for autocomplete
		include("CopilotC-Nvim/CopilotChat.nvim"), -- for chat

		-- nvim-cmp stuff
		{
			"zbirenbaum/copilot-cmp",
			function(_) require("copilot_cmp").setup() end,
			after = { "zbirenbaum/copilot.lua" },
		},
		include("hrsh7th/nvim-cmp"),

		-- Code formatting
		include("stevearc/conform.nvim"),

		-- Git signs
		include("lewis6991/gitsigns.nvim"),

		-- File management and fuzzy finding
		include("ibhagwan/fzf-lua"), -- fuzzy finding
		include("stevearc/oil.nvim"), -- file management

		-- TMUX navigation (ctrl-hjkl to switch between nvim and tmux
		include("alexghergh/nvim-tmux-navigation"),

		-- search and replace
		include("MagicDuck/grug-far"),

		-- treesitter
		include("nvim-treesitter/nvim-treesitter"),
		include("aaronik/treewalker.nvim"), -- navigate through elements on the same indent level

		-- dap debugger
		include("mfussenegger/nvim-dap"),
		{
			"theHamsta/nvim-dap-virtual-text",
			function() require("nvim-dap-virtual-text").setup() end,
			after = { "mfussenegger/nvim-dap" },
		},
		include("leoluz/nvim-dap-go"),
		include("rcarriga/nvim-dap-ui"),
	},
})

-- enable LSP
require("config.lsp")

-- if neovim is started with a directory as an argument, change to that directory
if vim.fn.isdirectory(vim.v.argv[2]) == 1 then vim.api.nvim_set_current_dir(vim.v.argv[2]) end
