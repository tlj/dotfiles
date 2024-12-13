-- Customize the statusline without using a plugin
local icons = require("config.icons")
local lsp_update = ""

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

local function get_diagnostic_counts()
	local diagnostics = vim.diagnostic.get(0)
	local counts = {
		errors = 0,
		warnings = 0,
		info = 0,
		hints = 0,
	}

	for _, d in ipairs(diagnostics) do
		if d.severity == vim.diagnostic.severity.ERROR then
			counts.errors = counts.errors + 1
		elseif d.severity == vim.diagnostic.severity.WARN then
			counts.warnings = counts.warnings + 1
		elseif d.severity == vim.diagnostic.severity.INFO then
			counts.info = counts.info + 1
		elseif d.severity == vim.diagnostic.severity.HINT then
			counts.hints = counts.hints + 1
		end
	end

	local parts = {}
	local signs = icons.lsp.diagnostic.signs
	if counts.errors > 0 then
		table.insert(parts, "%#DiagnosticError#" .. signs.Error .. " " .. counts.errors .. "%*")
	end
	if counts.warnings > 0 then
		table.insert(parts, "%#DiagnosticWarn#" .. signs.Warn ..  " " .. counts.warnings .. "%*")
	end
	if counts.info > 0 then
		table.insert(parts, "%#DiagnosticInfo#" .. signs.Info .. " " .. counts.info .. "%*")
	end
	if counts.hints > 0 then
		table.insert(parts, "%#DiagnosticHint#" .. signs.Hint .. " " .. counts.hints .. "%*")
	end

	if #parts > 0 then
		return " " .. table.concat(parts, " ")
	end
	return ""
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
		"%t",
		'%{&modified ? " [+]" : ""}', -- Modified flag
		get_diagnostic_counts(),
		"%=",
		git_branch(),
		git_status(),
		lsp_clients(),
		" " .. lsp_update,
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

-- Update LSP progress in statusbar, next to the LSP client name
-- Some of this code is inspired by the LSP progress example for
-- showing the notification in snacks.nvim notifier, but I got
-- so distracted by that popup that I moved it to the statusline
-- instead. Using the simple one, since most codebases I work on
-- are small enough that a % doesn't necessarily matter.
local progress = vim.defaulttable()
vim.api.nvim_create_autocmd("LspProgress", {
	---@param ev {data: {client_id: integer, params: lsp.ProgressParams}}
	callback = function(ev)
		local spinner = { "⠋", "⠙", "⠹", "⠸", "⠼", "⠴", "⠦", "⠧", "⠇", "⠏" }
		lsp_update = ev.data.params.value.kind == "end" and " "
			or spinner[math.floor(vim.uv.hrtime() / (1e6 * 80)) % #spinner + 1]
		vim.wo.statusline = Statusline.active()
	end,
})
