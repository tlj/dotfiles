local vim = vim

-- Install lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "--single-branch",
    "https://github.com/folke/lazy.nvim.git",
    lazypath,
  })
end
vim.opt.runtimepath:prepend(lazypath)

require "user.options"
require("lazy").setup("user.plugins", {
  dev = {
    path = "~/src",
    patterns = {"tlj"},
  }
})

vim.api.nvim_create_autocmd("User", {
  pattern = "VeryLazy",
  callback = function()
    require("user.mappings")
  end,
})

-- Theme
vim.cmd('colorscheme gruvbox')
-- vim.cmd('colorscheme catppuccin-macchiato')
-- vim.cmd('colorscheme ayu-dark')
-- vim.cmd('colorscheme tokyonight')

-- If neovim is started with a directory as argument, change to that directory
if vim.fn.isdirectory(vim.v.argv[2]) == 1 then
  vim.api.nvim_set_current_dir(vim.v.argv[2])
end
