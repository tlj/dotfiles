-- check if we need to reload the file when it changes
vim.api.nvim_create_autocmd({ "FocusGained", "TermClose", "TermLeave" }, { command = "checktime" })

vim.api.nvim_create_autocmd("FileType", {
	pattern = { "help" },
	callback = function(opts) vim.keymap.set("n", "gd", "<C-]>", { silent = true, buffer = opts.buf }) end,
})

-- Highlight on yank
vim.api.nvim_create_autocmd("TextYankPost", {
	desc = "Highlight on yank",
	callback = function() vim.highlight.on_yank() end,
})

-- resize splits if window got resized
local wr_group = vim.api.nvim_create_augroup("WinResize", { clear = true })
vim.api.nvim_create_autocmd({ "VimResized" }, {
	group = wr_group,
	pattern = "*",
	command = "wincmd =",
	desc = "Automatically resize windows when the host window size changes.",
})

-- go to last loc when opening a buffer
vim.api.nvim_create_autocmd("BufReadPost", {
	callback = function()
		local mark = vim.api.nvim_buf_get_mark(0, '"')
		local lcount = vim.api.nvim_buf_line_count(0)
		if mark[1] > 0 and mark[1] <= lcount then pcall(vim.api.nvim_win_set_cursor, 0, mark) end
	end,
})

-- close some filetypes with <q>
vim.api.nvim_create_autocmd("FileType", {
	pattern = {
		"qf",
		"help",
		"man",
		"notify",
		"lspinfo",
		"spectre_panel",
		"startuptime",
		"tsplayground",
		"PlenaryTestPopup",
		"grug-far",
		"oil",
		"deck",
		"dap-float",
		"git",
		"dap-view",
	},
	callback = function(event)
		vim.bo[event.buf].buflisted = false
		vim.keymap.set("n", "q", "<cmd>close<cr>", { buffer = event.buf, silent = true })
	end,
})
