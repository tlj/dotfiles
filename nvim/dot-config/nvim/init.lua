require("config.options")
require("config.mappings")
require("config.autocmds")
require("statusline").setup()
require("lazygit").setup()

-- Lazy load plugins as they are needed
local include = require("graft").include
require("graft").setup({
	start = {
		{
			repo = "luisiacc/gruvbox-baby",
			setup = function() vim.cmd("colorscheme gruvbox-baby") end,
		},
		{
			repo = "rcarriga/nvim-notify",
			setup = function() vim.notify = require("notify") end,
		},
		{
			-- LSP completions for CMP
			-- Has to be loaded at startup so it can be used in lsp config
			repo = "hrsh7th/cmp-nvim-lsp",
		},
	},
	opt = {
		{
			-- Icons for the plugins which require them
			repo = "nvim-tree/nvim-web-devicons",
			settings = { color_icons = true },
			setup = function(settings) require("nvim-web-devicons").setup(settings) end,
		},

		-- AI stuff
		include("zbirenbaum/copilot.lua"),
		include("CopilotC-Nvim/CopilotChat.nvim"),

		-- nvim-cmp stuff
		{
			repo = "zbirenbaum/copilot-cmp",
			setup = function(_) require("copilot_cmp").setup() end,
			after = { "zbirenbaum/copilot.lua" },
		},
		include("hrsh7th/nvim-cmp"),
		{
			repo = "hrsh7th/cmp-buffer",
			after = { "hrsh7th/nvim-cmp" },
			setup = function() require("cmp").register_source("buffer", require("cmp_buffer")) end,
		},
		{
			repo = "hrsh7th/cmp-nvim-lua",
			after = { "hrsh7th/nvim-cmp" },
			setup = function() require("cmp").register_source("nvim_lua", require("cmp_nvim_lua").new()) end,
		},
		{
			repo = "hrsh7th/cmp-path",
			after = { "hrsh7th/nvim-cmp" },
			setup = function() require("cmp").register_source("path", require("cmp_path").new()) end,
		},
		{
			repo = "hrsh7th/cmp-emoji",
			after = { "hrsh7th/nvim-cmp" },
			setup = function() require("cmp").register_source("emoji", require("cmp_emoji").new()) end,
		},

		-- Code formatting
		include("stevearc/conform.nvim"),

		-- Git
		include("lewis6991/gitsigns.nvim"),

		-- File management and fuzzy finding
		include("ibhagwan/fzf-lua"),
		include("stevearc/oil.nvim"),

		-- TMUX navigation (ctrl-hjkl to switch between nvim and tmux
		include("alexghergh/nvim-tmux-navigation"),

		-- search and replace
		include("MagicDuck/grug-far"),

		-- treesitter
		include("nvim-treesitter/nvim-treesitter"),
		include("aaronik/treewalker.nvim"),

		-- dap debugger
		include("mfussenegger/nvim-dap"),
		{
			repo = "theHamsta/nvim-dap-virtual-text",
			after = { "mfussenegger/nvim-dap" },
			setup = function() require("nvim-dap-virtual-text").setup() end,
		},
		include("leoluz/nvim-dap-go"),
		include("rcarriga/nvim-dap-ui"),
	},
})

-- enable LSP
require("config.lsp")

-- if neovim is started with a directory as an argument, change to that directory
if vim.fn.isdirectory(vim.v.argv[2]) == 1 then vim.api.nvim_set_current_dir(vim.v.argv[2]) end
