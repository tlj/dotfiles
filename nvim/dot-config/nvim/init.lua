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
		{ "catppuccin", setup = function() vim.cmd("colorscheme catppuccin-mocha") end },
		{ "notify", setup = function() vim.notify = require("notify") end },
		"statusline",
		"cmp_nvim_lsp", -- this is used in lsp.lua to combine capabilities
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
		{ "copilot_cmp",       when = { "copilot" } },
		"cmp",
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
		"dapui",
		{ "lazygit", cmd = { "Lazygit" }, keys = { ["<leader>lg"] = { cmd = ":Lazygit<cr>" } } },
	},
})

-- enable LSP
require("config.lsp")

-- if neovim is started with a directory as an argument, change to that directory
if vim.fn.isdirectory(vim.v.argv[2]) == 1 then
	vim.api.nvim_set_current_dir(vim.v.argv[2])
end
