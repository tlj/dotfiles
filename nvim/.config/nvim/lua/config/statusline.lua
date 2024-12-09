-- Customize the statusline without using a plugin
local icons = require("config.icons")

local function lsp_clients()
	local clients = {}

	for _, client in ipairs(vim.lsp.get_clients({ bufnr = vim.api.nvim_get_current_buf() })) do
		if client.name ~= "" then
			table.insert(clients, client.name)
		end
	end

	if next(clients) == nil then
		return ""
	end

	return string.format(" %s %s", icons.kinds.Server, table.concat(clients, ","))
end

local function diagnostic_status()
	local signs = icons.lsp.diagnostic.signs
	local mode = vim.api.nvim_get_mode().mode
	if mode == "c" or mode == "t" then
		return " %#DiagnosticOk#" .. signs.Ok .. "%*"
	end

	local diagnostics = {
		{ severity = vim.diagnostic.severity.ERROR, hl = "Error" },
		{ severity = vim.diagnostic.severity.WARN, hl = "Warn" },
		{ severity = vim.diagnostic.severity.INFO, hl = "Info" },
		{ severity = vim.diagnostic.severity.HINT, hl = "Hint" },
	}

	for _, d in ipairs(diagnostics) do
		if #vim.diagnostic.get(0, { severity = d.severity }) > 0 then
			return string.format(" %%#Diagnostic%s#%s%%*", d.hl, signs[d.hl])
		end
	end

	return " %#DiagnosticOk#" .. signs.Ok .. "%*"
end

-- Function to get git branch using gitsigns
local function git_branch()
	local gitsigns = vim.b.gitsigns_status_dict

	if gitsigns and gitsigns.head then
		return string.format(" %s %s", icons.kinds.Git, gitsigns.head)
	end

	return ""
end

local function git_status()
	local signs = vim.b.gitsigns_status_dict
	if not signs then
		return ""
	end

	local parts = {}

	if signs.added and signs.added > 0 then
		table.insert(parts, "%#GitSignsAdd#+" .. signs.added .. "%*")
	end
	if signs.removed and signs.removed > 0 then
		table.insert(parts, "%#GitSignsDelete#-" .. signs.removed .. "%*")
	end
	if signs.changed and signs.changed > 0 then
		table.insert(parts, "%#GitSignsChange#~" .. signs.changed .. "%*")
	end

	if #parts == 0 then
		return ""
	end
	return " " .. table.concat(parts, " ")
end

Statusline = {}

Statusline.active = function()
	return table.concat({
		"%F",
		diagnostic_status(),
		'%{&modified ? " [+]" : ""}', -- Modified flag
		"%=",
		git_branch(),
		git_status(),
		lsp_clients(),
		" " .. icons.kinds.File .. "%{&filetype}",
		" %2p%%",
		" %3l:%-2c",
	})
end

function Statusline.inactive()
	return " %F"
end

local status_group = vim.api.nvim_create_augroup("StatusLine", { clear = true })
vim.api.nvim_create_autocmd({ "WinEnter", "BufEnter", "FileType", "DiagnosticChanged", "LspAttach", "LspDetach" }, {
	callback = function()
		vim.wo.statusline = Statusline.active()
	end,
	pattern = "*",
	group = status_group,
})

vim.api.nvim_create_autocmd("User", {
	callback = function()
		vim.wo.statusline = Statusline.active()
	end,
	pattern = "GitSignsUpdate",
	group = status_group,
})

vim.api.nvim_create_autocmd({ "WinLeave" }, {
	callback = function()
		vim.wo.statusline = Statusline.inactive()
	end,
	pattern = "*",
	group = status_group,
})
