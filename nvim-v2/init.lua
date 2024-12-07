local vim = vim

-- Download and install the Lazy plugin manager
require("config/lazy")

-- Set default Neovim options
require("config/options")

-- Load autocommands
require("config/autocmds")

-- Load Lazy plugins
require("lazy").setup({
	change_detection = {
		notify = false,
	},
	spec = {
		{ "ellisonleao/gruvbox.nvim", priority = 1000, config = true, opts = {} },
		{ import = "plugins" },
	},
})

-- Set colorscheme
vim.cmd("colorscheme gruvbox")

-- if neovim is started with a directory as an argument, change to that directory
if vim.fn.isdirectory(vim.v.argv[2]) == 1 then
	vim.api.nvim_set_current_dir(vim.v.argv[2])
end
