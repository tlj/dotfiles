-- Set default Neovim options
require("config.options")

-- Set default Neovim options
require("config.mappings")

-- Set custom statusline
require("config.statusline")

-- Load autocommands
require("config.autocmds")

-- Load plugins
-- require("config/plugloader").setup("plugins")

local plugins = {
	"catppuccin",
	"nvim-web-devicons",
	"notify",
	"copilot",
	"blink-cmp-copilot",
	"blink.cmp",
	"snacks",
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
}

for _, plugin in pairs(plugins) do
	pcall(vim.cmd, "packadd " .. plugin)
	local plugin_cfg = plugin:gsub("%.", "-")
	local hasconfig, config = pcall(require, "config.plugins." .. plugin_cfg)
	if not hasconfig then
		vim.notify("Plugin " .. plugin .. " is missing config.")
		config = { settings = {} }
	end
	local p = require(plugin)
	if p.setup then
		p.setup(config.settings)
	end
	if config.setup then
		config.setup()
	end
	if config.keys then
		for key, opts in pairs(config.keys) do
			vim.keymap.set("n", key, opts.cmd, { desc = opts.desc, noremap = true, silent = true })
		end
	end
end

require("config.lsp")

-- if neovim is started with a directory as an argument, change to that directory
if vim.fn.isdirectory(vim.v.argv[2]) == 1 then
	vim.api.nvim_set_current_dir(vim.v.argv[2])
end
