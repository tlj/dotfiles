local vim = vim

-- install lazy.nvim plugin manager
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
	vim.fn.system({
		"git",
		"clone",
		"--filter=blob:none",
		"https://github.com/folke/lazy.nvim.git",
		"--branch=stable",
		lazypath,
	})
end
vim.opt.runtimepath:prepend(lazypath)

require("config.options") -- nvim options
require("config.autocmds")

-- load user mappings (no plugins)
vim.api.nvim_create_autocmd("User", {
	pattern = "VeryLazy",
	callback = function()
		require("config.mappings")
	end,
})

-- load plugins under lua/user/plugins
require("lazy").setup("plugins", {
	change_detection = {
		notify = false,
	},
	dev = {
		path = "~/src",
		patterns = { "tlj" },
	},
})

-- theme
-- vim.cmd('colorscheme gruvbox-material')
-- vim.cmd('colorscheme bamboo')
vim.cmd("colorscheme catppuccin-mocha")

-- if neovim is started with a directory as an argument, change to that directory
if vim.fn.isdirectory(vim.v.argv[2]) == 1 then
	vim.api.nvim_set_current_dir(vim.v.argv[2])
end

require("config.focus") -- focus mode 
