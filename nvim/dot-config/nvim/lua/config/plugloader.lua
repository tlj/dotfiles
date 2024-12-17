-- Inspired by
-- https://ash.fail/blog/20240614-how-lazy-loading-works-in-neovim.html
local M = {}

local INIT_PLUGINS = {}

local CALLBACKS = {}
local BEFORE_DEPS = {}
local AFTER_DEPS = {}
local augroup = vim.api.nvim_create_augroup("lazyload", { clear = true })

M.is_enabled = function(val)
	return val ~= false
end

M.register = function(pkgname, opts)
	if not M.is_enabled(opts.enabled) then
		return
	end

	CALLBACKS[pkgname] = opts.setup or function() end

	for _, cmd in ipairs(opts.commands or {}) do
		vim.api.nvim_create_autocmd({ "CmdUndefined" }, {
			group = augroup,
			pattern = cmd,
			callback = function()
				M.load(pkgname)
			end,
			once = true,
		})
	end

	for _, event in ipairs(opts.events or {}) do
		vim.api.nvim_create_autocmd(event, {
			pattern = "*",
			group = augroup,
			callback = function()
				M.load(pkgname)
			end,
			once = true,
		})
	end

	for _, ft in ipairs(opts.filetypes or {}) do
		vim.api.nvim_create_autocmd("FileType", {
			group = augroup,
			pattern = ft,
			callback = function()
				M.load(pkgname)
			end,
			once = true,
		})
	end

	for lhs, kopts in pairs(opts.keys or {}) do
		M.keymap(pkgname, "n", lhs, kopts["cmd"] or function() end, kopts["desc"] or "")
	end

	for _, mod in ipairs(opts.before or {}) do
		if not BEFORE_DEPS[pkgname] then
			BEFORE_DEPS[pkgname] = {}
		end
		table.insert(BEFORE_DEPS[pkgname], mod)
	end

	for _, mod in ipairs(opts.after or {}) do
		if not AFTER_DEPS[pkgname] then
			AFTER_DEPS[pkgname] = {}
		end
		table.insert(AFTER_DEPS[pkgname], mod)
	end

	if opts.init then
		INIT_PLUGINS[pkgname] = opts
	end
end

M.init = function()
	-- Convert to array for sorting
	local sorted = {}
	for k, v in pairs(INIT_PLUGINS) do
		table.insert(sorted, {
			key = k,
			opts = v,
			priority = v.priority or 0, -- default to 0 if not set
		})
	end

	-- Sort by priority
	table.sort(sorted, function(a, b)
		return a.priority > b.priority -- higher priority first
	end)

	for _, item in ipairs(sorted) do
		M.load(item.key)
	end

	INIT_PLUGINS = {}
end

M.keymap = function(pkgname, mode, lhs, cmd, desc)
	vim.keymap.set(mode, lhs, function()
		vim.keymap.del(mode, lhs)

		M.load(pkgname)
		vim.keymap.set(mode, lhs, cmd, { desc = desc, noremap = true, silent = true })
		if type(cmd) == "function" then
			cmd()
		end
		if type(cmd) == "string" then
			local cleaned_cmd = cmd:gsub("<cmd>", ""):gsub("<cr>", "")
			vim.cmd(cleaned_cmd)
		end
	end, { desc = desc, noremap = true, silent = true })
end

M.load = function(pkgname)
	local setup = CALLBACKS[pkgname]
	if setup then
		for _, dep in pairs(BEFORE_DEPS[pkgname] or {}) do
			M.load(dep)
		end
		vim.cmd.packadd(pkgname)
		setup()
		CALLBACKS[pkgname] = nil

		for _, dep in pairs(AFTER_DEPS[pkgname] or {}) do
			M.load(dep)
		end
	else
		vim.cmd.packadd(pkgname)
	end
end

M.setup = function(path)
	for file, type in vim.fs.dir(vim.fn.stdpath("config") .. "/lua/" .. path) do
		if type == "file" and file:match("%.lua$") then
			local module = "plugins." .. file:gsub("%.lua$", "")
			require(module)
		end
	end
	M.init()
end

_G.plugin = M.register

return M
