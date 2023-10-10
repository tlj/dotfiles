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
vim.cmd('colorscheme melange')
-- vim.cmd('colorscheme catppuccin-macchiato')
-- vim.cmd('colorscheme ayu-dark')
-- vim.cmd('colorscheme tokyonight')

-- If neovim is started with a directory as argument, change to that directory
if vim.fn.isdirectory(vim.v.argv[2]) == 1 then
  vim.api.nvim_set_current_dir(vim.v.argv[2])
end

if vim.g.neovide then
  vim.g.neovide_scale_factor = 1.5
  vim.g.neovide_transparency = 0.95
  vim.g.transparency = 0.95
  vim.g.neovide_hide_mouse_when_typing = true
  vim.g.neovide_refresh_rate = 60
  vim.g.neovide_refresh_rate_idle = 5
  vim.g.neovide_remember_window_size = true
  vim.g.neovide_input_macos_alt_is_meta = true
  vim.g.neovide_cursor_animation_length = 0.05
  vim.g.neovide_cursor_trail_size = 0.2
  vim.g.neovide_cursor_antialiasing = true
  vim.g.neovide_cursor_animate_in_insert_mode = false

  vim.g.neovide_confirm_quit = true
  vim.g.neovide_fullscreen = false

  vim.keymap.set('n', '<D-s>', ':w<CR>') -- Save
  vim.keymap.set('v', '<D-c>', '"+y') -- Copy
  vim.keymap.set('n', '<D-v>', '"+P') -- Paste Normal Mode
  vim.keymap.set('v', '<D-v>', '"+P') -- Paste Visual Mode
  vim.keymap.set('c', '<D-v>', '<C-R>+') -- Paste command mode
  vim.keymap.set('i', '<D-v>', '<ESC>l"+Pli') -- Paste Insert Mode

  -- change scale dynamically
  local change_scale_factor = function(delta)
    vim.g.neovide_scale_factor = vim.g.neovide_scale_factor * delta
  end
  vim.keymap.set("n", "<D-=>", function()
    change_scale_factor(1.25)
  end)
  vim.keymap.set("n", "<D-->", function()
    change_scale_factor(1/1.25)
  end)

  -- change transparency dynamically
  local change_transparency = function(delta)
    vim.g.neovide_transparency = vim.g.neovide_transparency + delta
    vim.g.transparency = vim.g.transparency + delta
  end
  vim.keymap.set({ "n", "v", "o" }, "<D-]>", function()
    change_transparency(0.01)
  end)
  vim.keymap.set({ "n", "v", "o" }, "<D-[>", function()
    change_transparency(-0.01)
  end)
end
