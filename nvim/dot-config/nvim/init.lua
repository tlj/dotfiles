-- Set default Neovim options
require("config.options")

-- Set default Neovim options
require("config.mappings")

-- Load autocommands
require("config.autocmds")

-- Load plugins
-- See lua/plugins.lua for more information about plugin loading.
require("plugins").setup({
	-- These are the plugins which are loaded immediately, defined
	-- only as string. Any configuration needs to be in lua/config/plugins/(name).lua
	now = {
		"catppuccin",
		"statusline",
		"notify",
		"blink.cmp",
	},
	-- These plugins are loaded later. If there is a minimal config, it should be added here
	-- to avoid config file noise. If there are several settings and keys which need to be
	-- added they should go into the config file in lua/config/plugins/(name).lua
	--
	-- TRIGGERS
	-- cmd = { "FzfLua" } -- list of commands which will load the plugin
	-- events = { "UIEnter" } -- list of events which will trigger loading of the plugin
	-- when = { "copilot" } -- loads after another plugin has been loaded
	-- keys = { ["<C-p>" = { cmd = ":GitSigns<cr>", desc = "Gitsigns" } -- load when key is pressed
	-- ft = { "lua" } -- filetypes which will trigger autoload
	--
	-- OPTIONS
	-- requires = { "fzf-lua" } -- loads another plugin first
	--
	later = {
		{ "nvim-web-devicons", settings = { color_icons = true }, events = { "UIEnter" } },
		"copilot",
		"CopilotChat",
		{ "blink-cmp-copilot", when = { "copilot" } },
		"nvim-tmux-navigation",
		"conform",
		"gitsigns",
		"fzf-lua",
		"oil",
		"grug-far",
		"nvim-treesitter",
		"treewalker",
		"dap",
		"nvim-dap-virtual-text",
		"dap-go",
		"nio",
		"dapui",
		"plenary",
		{ "lazygit", cmd = { "Lazygit" }, keys = { ["<leader>lg"] = { cmd = ":Lazygit<cr>" } } },
	},
})

-- Set the colorscheme
vim.cmd("colorscheme catppuccin-mocha")

-- Set the default notifier to the notify plugin
vim.notify = require("notify")

-- enable LSP
require("config.lsp")

-- if neovim is started with a directory as an argument, change to that directory
if vim.fn.isdirectory(vim.v.argv[2]) == 1 then
	vim.api.nvim_set_current_dir(vim.v.argv[2])
end
