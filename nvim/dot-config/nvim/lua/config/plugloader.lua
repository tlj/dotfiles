-- Inspired by
-- https://ash.fail/blog/20240614-how-lazy-loading-works-in-neovim.html
local M = {}

local CALLBACKS = {}
local MODULES = {}

M.register = function(pkgname, opts)
	CALLBACKS[pkgname] = opts.setup or function() end

	local augroup = vim.api.nvim_create_augroup('lazyload', {})

	for _, cmd in ipairs(opts.commands or {}) do
		vim.print("Reigstering " .. cmd)
		vim.api.nvim_create_autocmd('CmdUndefined', {
			group = augroup,
			pattern = cmd,
			callback = function() M.load(pkgname) end,
			once = true,
		})
	end

	for _, ft in ipairs(opts.filetypes or {}) do
		vim.api.nvim_create_autocmd('FileType', {
			group = augroup,
			pattern = ft,
			callback = function() M.load(pkgname) end,
			once = true,
		})
	end

	for _, mod in ipairs(opts.modules or {}) do
		MODULES[mod] = pkgname
	end
end

M.require = function(modname)
	if MODULES[modname] then
		M.load(MODULES[modname])
		MODULES[modname] = nil
	end

	return require(modname)
end

M.load = function(pkgname)
	local setup = CALLBACKS[pkgname]
	if setup then
		vim.cmd.packadd(pkgname)
		setup()
		CALLBACKS[pkgname] = nil
	end
end

return M
