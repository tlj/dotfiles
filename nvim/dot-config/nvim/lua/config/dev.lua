-- Load graft.nvim from local dev path if it exist, if not we load it from
-- the submodule, prepend it to the table so we load it from dev instead
-- of the submodule

vim.opt.rtp:prepend("~/src/graft.nvim")
vim.opt.rtp:prepend("~/src/graft-git.nvim")
vim.opt.rtp:prepend("~/src/graft-ui.nvim")
