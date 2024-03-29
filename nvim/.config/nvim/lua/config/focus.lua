local state = {
	focus_enabled = false,
	relativenumber = vim.opt.relativenumber,
	number = vim.opt.number,
	signcolumn = vim.opt.signcolumn,
	showtabline = vim.opt.showtabline,
	indentscope = vim.g.miniindentscope_disable,
	list = vim.opt.list,
	cmdheight = vim.opt.cmdheight,
	font = 0,
}

local function kitty_font(font)
	if not vim.fn.executable("kitty") then
		return
	end
	local cmd = "kitty @ --to %s set-font-size %s"
	local socket = vim.fn.expand("$KITTY_LISTEN_ON")
	vim.fn.system(cmd:format(socket, font))
	vim.cmd([[redraw]])
end

local function shell_error()
	return vim.v.shell_error ~= 0
end

local function kitty_is_retina()
	if not vim.fn.executable("system_profiler") then
		return false
	end
	local cmd = "system_profiler SPDisplaysDataType | grep 'Retina'"
	vim.fn.system(cmd)
	return not shell_error()
end

-- In tmux, detaching and attaching the session will not update the KITT_LISTEN_ON environment variable.
-- So we need to manually figure out if we are in tmux and use the tmux command to get the value.
-- This requires update-environment -r to be set in the tmux.conf
local function get_kitty_socket()
	local istmux = vim.fn.expand("$TMUX")
	local socket = "/tmp/kitty"
	if istmux == "" then
		socket = vim.fn.expand("$KITTY_LISTEN_ON")
	else
		socket = vim.fn.system {"tmux", "show-environment", "KITTY_LISTEN_ON"}
		socket = socket:gsub("KITTY_LISTEN_ON=", "")
		socket = socket:gsub("[\n\r]", "")
	end

	return socket
end

local function kitty_padding(padding)
	if not vim.fn.executable("kitty") then
		return
	end
	local cmd = "kitty @ --to %s set-spacing padding-left=%s padding-right=%s"

	local socket = get_kitty_socket()

	local fullcmd = cmd:format(socket, padding, padding)
	vim.print(vim.fn.system(fullcmd))
	vim.cmd([[redraw]])
end

local function enable_focus()
	-- Make sure that the user doesn't have more than one window/buffer open at the moment
	if #vim.api.nvim_tabpage_list_wins(0) > 1 then
		print("Focus mode can only be enabled when one buffer is in view.")
		return
	end

	state.focus_enabled = true
	vim.opt.relativenumber = false
	vim.opt.number = false
	vim.opt.signcolumn = "no"
	vim.opt.showtabline = 0
	vim.g.miniindentscope_disable = true
	vim.opt.list = false
	vim.opt.cmdheight = 0

	require("lualine").hide()
	require("barbecue.ui").toggle(false)

	local fontsize = 20
	kitty_font(fontsize)

	local padpercentage = 10
	local winwidth = vim.api.nvim_win_get_width(0)
	local paddingcols = (winwidth * padpercentage / 100)
	local paddingpts = paddingcols * fontsize

	kitty_padding(paddingpts)
	vim.fn.system([[tmux set status off]])
end

local function disable_focus()
	if state.focus_enabled then
		state.focus_enabled = false

		vim.opt.relativenumber = state.relativenumber
		vim.opt.number = state.number
		vim.opt.signcolumn = state.signcolumn
		vim.opt.showtabline = state.showtabline
		vim.g.miniindentscope_disable = state.indentscope
		vim.opt.list = state.list
		vim.opt.cmdheight = state.cmdheight

		require("lualine").hide({ unhide = true })
		require("barbecue.ui").toggle(true)
		kitty_font(0)
		kitty_padding("default")
		vim.fn.system([[tmux set status on]])
		return
	end
end

vim.keymap.set("n", "<leader>fo", function()
	if state.focus_enabled then
		disable_focus()
	else
		enable_focus()
	end
end, { desc = "Focus mode" })

-- sine we have changed Kitty and tmux settings on focus mode, change them back latest when we leave vim
local fo_group = vim.api.nvim_create_augroup("Focus", { clear = true })
vim.api.nvim_create_autocmd({ "VimLeave" }, {
	group = fo_group,
	pattern = "*",
	callback = function()
		disable_focus()
	end,
	desc = "Reset focus settings when leaving vim.",
})
