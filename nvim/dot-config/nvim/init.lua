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
			"luisiacc/gruvbox-baby",
			function() vim.cmd("colorscheme gruvbox-baby") end,
		},
		{
			"rcarriga/nvim-notify",
			function()
				local notify = require("notify")
				notify.setup({ stages = "static" })
				vim.notify = notify
			end,
		},
		-- LSP completions for CMP
		-- Has to be loaded at startup so it can be used in lsp config
		"hrsh7th/cmp-nvim-lsp",
	},
	opt = {
		{
			-- Icons for the plugins which require them
			"nvim-tree/nvim-web-devicons",
			function(settings) require("nvim-web-devicons").setup(settings) end,
			settings = { color_icons = true },
		},

		-- AI stuff
		include("zbirenbaum/copilot.lua"),
		include("CopilotC-Nvim/CopilotChat.nvim"),

		-- nvim-cmp stuff
		{
			"zbirenbaum/copilot-cmp",
			function(_) require("copilot_cmp").setup() end,
			after = { "zbirenbaum/copilot.lua" },
		},
		include("hrsh7th/nvim-cmp"),
		{
			"hrsh7th/cmp-buffer",
			function() require("cmp").register_source("buffer", require("cmp_buffer")) end,
			after = { "hrsh7th/nvim-cmp" },
		},
		{
			"hrsh7th/cmp-nvim-lua",
			function() require("cmp").register_source("nvim_lua", require("cmp_nvim_lua").new()) end,
			after = { "hrsh7th/nvim-cmp" },
		},
		{
			"hrsh7th/cmp-path",
			function() require("cmp").register_source("path", require("cmp_path").new()) end,
			after = { "hrsh7th/nvim-cmp" },
		},
		{
			"hrsh7th/cmp-emoji",
			function() require("cmp").register_source("emoji", require("cmp_emoji").new()) end,
			after = { "hrsh7th/nvim-cmp" },
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
