-- Lazygit integration for Neovim
-- Creates commands for opening lazygit in different modes using floating windows

local M = {}

-- Configuration for the floating window
local function create_float_config()
	local width = math.floor(vim.o.columns * 0.8)
	local height = math.floor(vim.o.lines * 0.8)
	return {
		relative = 'editor',
		row = math.floor((vim.o.lines - height) / 2),
		col = math.floor((vim.o.columns - width) / 2),
		width = width,
		height = height,
		style = 'minimal',
		border = 'rounded'
	}
end

-- Function to create a floating terminal window
local function create_float_term(cmd)
	local buf = vim.api.nvim_create_buf(false, true)
	local float_config = create_float_config()

	-- Create the floating window
	local win = vim.api.nvim_open_win(buf, true, float_config)

	-- Set window options
	vim.wo[win].winblend = 0
	vim.wo[win].winhl = 'Normal:Normal'

	-- Open terminal with the specified command
	vim.fn.termopen(cmd, {
		on_exit = function()
			vim.api.nvim_win_close(win, true)
			vim.api.nvim_buf_delete(buf, { force = true })
		end
	})

	-- Enter insert mode
	vim.cmd('startinsert')
end

-- Function to setup the commands
function M.setup()
	-- Command to open lazygit normally
	vim.api.nvim_create_user_command('Lazygit', function()
		create_float_term('lazygit')
	end, {})

	-- Command to show git log
	vim.api.nvim_create_user_command('LazygitLog', function()
		create_float_term('lazygit log')
	end, {})
end

return M
