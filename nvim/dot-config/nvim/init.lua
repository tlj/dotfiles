-- Set default Neovim options
require("config.options")

-- Set default Neovim options
require("config.mappings")

-- Set custom statusline
require("config.statusline")

-- Load autocommands
require("config.autocmds")

-- Load plugins
require("plugins").setup({
	now = {
		"catppuccin",
	},
	later = {
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
	},
})

-- enable LSP
require("config.lsp")

-- if neovim is started with a directory as an argument, change to that directory
if vim.fn.isdirectory(vim.v.argv[2]) == 1 then
	vim.api.nvim_set_current_dir(vim.v.argv[2])
end
