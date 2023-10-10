vim.g.neovide_scale_factor = 1.4
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

-- reload neovide config with cmd-r
vim.keymap.set('n', '<D-r>', '<cmd>luafile ~/.config/nvim/lua/user/neovide.lua<CR>')

-- change scale dynamically
local change_scale_factor = function(delta)
  vim.g.neovide_scale_factor = vim.g.neovide_scale_factor * delta
end
vim.keymap.set("n", "<D-=>", function()
  change_scale_factor(1.10)
end)
vim.keymap.set("n", "<D-->", function()
  change_scale_factor(1/1.10)
end)

-- change transparency dynamically
local change_transparency = function(delta)
  vim.g.neovide_transparency = vim.g.neovide_transparency + delta
  vim.g.transparency = vim.g.transparency + delta
end
vim.keymap.set({ "n", "v", "o" }, "<D-]>", function()
  change_transparency(0.02)
end)
vim.keymap.set({ "n", "v", "o" }, "<D-[>", function()
  change_transparency(-0.02)
end)
