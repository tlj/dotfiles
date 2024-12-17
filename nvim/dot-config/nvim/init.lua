-- Download and install the Lazy plugin manager
require("config/lazy")

-- Set default Neovim options
require("config/options")

-- Set default Neovim options
require("config/mappings")

-- Set custom statusline
require("config/statusline")

-- Load autocommands
require("config/autocmds")

-- Load plugins
require("config/plugloader").setup("plugins")

-- if neovim is started with a directory as an argument, change to that directory
if vim.fn.isdirectory(vim.v.argv[2]) == 1 then
	vim.api.nvim_set_current_dir(vim.v.argv[2])
end
