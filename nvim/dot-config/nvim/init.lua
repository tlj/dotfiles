-- Set default Neovim options
require("config.options")

-- Set default Neovim options
require("config.mappings")

-- Load autocommands
require("config.autocmds")

-- Load our custom statusline
require("statusline").setup()

-- Set up some things for local development of lua plugins
require("config.dev")

-- Ensure that graft and its plugins are installed
require("config.plugins").graft({ "git", "ui" })

-- Use graft tools to automatically install and remove plugins
require("graft-git").setup({ install_plugins = true, remove_plugins = true })
require("graft-ui").setup()

-- Load plugins through the graft plugin
require("graft").setup({
	start = {
		{ "luisiacc/gruvbox-baby", { setup = function() vim.cmd("colorscheme gruvbox-baby") end } },
		{
			"rcarriga/nvim-notify",
			{ tag = "v3.14.1", setup = function() vim.notify = require("notify") end },
		},
		{ "hrsh7th/cmp-nvim-lsp" }, -- this is used in lsp.lua to combine capabilities
	},
	opt = {
		{
			"nvim-tree/nvim-web-devicons",
			{ settings = { color_icons = true } },
		},
		{ "zbirenbaum/copilot.lua", require("config/plugins/copilot") },
		{ "CopilotC-Nvim/CopilotChat.nvim", require("config/plugins/CopilotChat") },
		{ "zbirenbaum/copilot-cmp", { name = "copilot_cmp", after = { "zbirenbaum/copilot" } } },
		{ "hrsh7th/nvim-cmp", require("config/plugins/nvim-cmp") },
		{ "alexghergh/nvim-tmux-navigation", require("config/plugins/nvim-tmux-navigation") },
		{ "stevearc/conform.nvim", require("config/plugins/conform") },
		{ "lewis6991/gitsigns.nvim", require("config/plugins/gitsigns") },
		{ "ibhagwan/fzf-lua", require("config/plugins/fzf-lua") },
		{ "stevearc/oil.nvim", require("config/plugins/oil") },
		{ "MagicDuck/grug-far.nvim", require("config/plugins/grug-far") },
		{ "nvim-treesitter/nvim-treesitter", require("config/plugins/nvim-treesitter") },
		{ "aaronik/treewalker.nvim", require("config/plugins/treewalker") },
		{ "mfussenegger/nvim-dap", require("config/plugins/nvim-dap") },
		{ "theHamsta/nvim-dap-virtual-text" },
		{ "leoluz/nvim-dap-go", require("config/plugins/nvim-dap-go") },
		{ "rcarriga/nvim-dap-ui", require("config/plugins/nvim-dap-ui") },
		{ "lazygit", { cmds = { "Lazygit" }, keys = { ["<leader>lg"] = { cmd = ":Lazygit<cr>" } } } },
	},
})

-- enable LSP
require("config.lsp")

-- if neovim is started with a directory as an argument, change to that directory
if vim.fn.isdirectory(vim.v.argv[2]) == 1 then vim.api.nvim_set_current_dir(vim.v.argv[2]) end
