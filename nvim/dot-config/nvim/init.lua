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
	"catppuccin",
	"nvim-web-devicons",
	"notify",
	{ "copilot", events = { "InsertEnter" } },
	{ "blink-cmp-copilot", events = { "InsertEnter" } },
	"blink.cmp",
	{ "snacks" },
	"nvim-tmux-navigation",
	{ "conform", events = { "BufReadPre", "BufNewFile" } },
	{ "gitsigns", events = { "BufReadPre" } },
	{ "fzf-lua" },
	{ "oil" },
	{ "grug-far" },
	{ "nvim-treesitter", events = { "BufReadPre", "BufNewFile" } },
	{ "treewalker", events = { "BufReadPre", "BufNewFile" } },
	{ "dap" },
	{ "nvim-dap-virtual-text", depends_on = { "dap" } },
	{ "dap-go", depends_on = { "dap" } },
	{ "nio", depends_on = { "dap" } },
	{ "dapui", depends_on = { "nio" } },
})

-- enable LSP
require("config.lsp")

-- if neovim is started with a directory as an argument, change to that directory
if vim.fn.isdirectory(vim.v.argv[2]) == 1 then
	vim.api.nvim_set_current_dir(vim.v.argv[2])
end
