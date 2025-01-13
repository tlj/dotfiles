local M = {
	root_dir = vim.fn.stdpath("data") .. "/site", -- config for dotfiles repo, data for ~/.local/share/nvim/site
	pack_dir = "pack/graft/opt/",
	config = {
		submodules = false,
		install = false,
		debug = false,
		start = {},
		opt = {},
	},
	plugins = {},
	loaded = {},
	installed = {},
}

local to_install = 0
local installed = 0

---@class tlj.Plugin
---@field repo string The github repo path
---@field requires? (string|tlj.Plugin)[]
---@field setup? function
---@field settings? table
---@field auto_install? boolean Defaults to true
---@field events? string[] Events which triggers loading of plugin
---@field cmds? string[] A list of commands which will load the plugin
---@field pattern? string[] Patterns which are required for loading the plugin
---@field after? string[] Plugins which trigger loading of this plugin (list of repos)
---@field keys? table<string, {cmd:string|function, desc: string}> Keymaps with commands (string or function) and description
---@field build? string A command (vim cmd if it starts with :, system otherwise) to run after install

local function parse_git_result(obj)
	local output = {}
	local stdout = obj.stdout .. "\n" .. obj.stderr

	for line in stdout:gmatch("[^\n]+") do
		output[#output + 1] = line
	end

	return obj.code == 0, output
end

---@param args string[]
local function git(args, opts)
	local defaults = { root_dir = M.root_dir, async = false }
	opts = vim.tbl_deep_extend("force", defaults, opts or {})

	local cmd = { "git", "-C", opts.root_dir }

	vim.list_extend(cmd, args)

	if opts.async then
		vim.system(cmd, { text = true }, function(obj)
			local success, output = parse_git_result(obj)
			if success and type(opts.on_success) == "function" then opts.on_success(output) end
			if not success and type(opts.on_failure) == "function" then opts.on_failure(output) end
		end)
	else
		local result = vim.system(cmd, { text = true }, nil):wait()
		return parse_git_result(result)
	end
end

---@param repo string
---@return string
local function repo_dir(repo)
	local dir = repo:gsub("/", "%-%-"):lower()
	return dir
end

---@param arg string|tlj.Plugin
---@return tlj.Plugin
local function normalize_spec(arg)
	local spec = {}

	if type(arg) == "string" then
		spec.repo = arg
	elseif type(arg) == "table" then
		if type(arg[1]) == "string" then
			arg.repo = arg[1]
			arg[1] = nil
		end
		if type(arg[2]) == "function" then
			arg.setup = arg[2]
			arg[2] = nil
		end
		spec = arg
	else
		vim.notify("Argument to add() should be string or table.", vim.log.levels.ERROR)
	end

	return spec
end

---@param repo string
---@return string
local function pack_dir(repo) return M.pack_dir .. repo_dir(repo) end

---@param repo string
---@return string
local function path(repo) return M.root_dir .. "/" .. pack_dir(repo) end

-- Register plugins which this plugin will load after, through listening
-- to user events emitted by plugins being loaded
---@param spec tlj.Plugin
local function register_after(spec)
	for _, after in ipairs(spec.after or {}) do
		vim.api.nvim_create_autocmd("User", {
			group = M.autogroup,
			pattern = after,
			callback = function() M.load(spec.repo) end,
			once = true, -- we only need this to happen once
		})
	end
end

---@param arg string|tlj.Plugin
---@return tlj.Plugin
M.add = function(arg)
	local defaults = { auto_install = true }

	-- argument can be either just the repo path, or the
	-- full spec, so let's handle both.
	local spec = normalize_spec(arg)
	spec = vim.tbl_extend("force", defaults, spec)

	-- If repo is already registered, then ignore it
	if M.plugins[spec.repo] then return spec end

	M.plugins[spec.repo] = spec

	if spec.requires and type(spec.requires) == "table" then
		for _, req in ipairs(spec.requires) do
			M.add(req)
		end
	end

	-- -- Register plugins which will trigger the loading of this plugin
	register_after(spec)

	return spec
end

---@param repo string
---@return string
local function get_repo_require_path(repo)
	local name = repo:match("[^/]+$")
	return name:gsub("%.lua$", ""):gsub("%.nvim$", "")
end

M.debug = function(msg)
	-- if M.config.debug then vim.notify(msg, "info", { title = "Graft Debug" }) end
	if M.config.debug then vim.print(msg) end
end

---@param repo string
M.load = function(repo)
	-- Don't load again if already loaded
	if M.loaded[repo] then return end
	M.loaded[repo] = true

	---@type tlj.Plugin
	local spec = M.plugins[repo]
	if not spec then
		vim.notify("Did not find a registered repo " .. repo)
		return
	end

	M.debug("Loading " .. repo)

	-- If this plugin is not installed yet, let's just skip it
	if vim.fn.isdirectory(path(repo)) == 0 then
		if spec.auto_install then
			local success = M.install(repo)
			if not success then return end
		else
			return
		end
	end

	for _, req in ipairs(spec.requires or {}) do
		local req_spec = normalize_spec(req)
		M.debug(" * Requires " .. req_spec.repo)
		M.load(req_spec.repo)
	end

	-- Add the package to Neovim
	vim.cmd("packadd " .. repo_dir(repo))

	-- Run setup function if it exists
	if spec.setup and type(spec.setup) == "function" then
		spec.setup(spec.settings or {})
	else
		-- Let's just make a guess at the correct setup name
		local require_path = get_repo_require_path(spec.repo)
		local ok, p = pcall(require, require_path)
		if ok and type(p.setup) == "function" then
			p.setup(spec.settings or {})
		else
			M.debug(" * Failed calling setup() on " .. spec.repo .. ". require passed: " .. vim.inspect(ok) .. " path " .. require_path)
		end
	end

	-- Setup keymaps from config
	for key, opts in pairs(spec.keys or {}) do
		M.debug(" * Setting keymap " .. key)
		vim.keymap.set("n", key, opts.cmd, { desc = opts.desc or "", noremap = false, silent = true })
	end

	if M.installed[spec.repo] then
		if spec.build then
			if spec.build:match("^:") ~= nil then
				M.debug(" * Building with nvim command " .. spec.build)
				vim.cmd(spec.build)
			else
				M.debug(" * Building with system command " .. spec.build)
				local prev_dir = vim.fn.getcwd()
				vim.cmd("cd " .. path(repo))
				vim.fn.system(spec.build)
				vim.cmd("cd " .. prev_dir)
			end
		end
	end

	-- Trigger an event saying plugin is loaded, so other plugins
	-- which are waiting for us can trigger.
	vim.api.nvim_exec_autocmds("User", { pattern = spec.repo })
end

local function url(repo) return "https://github.com/" .. repo end

-- Update status in neovim without user input
---@param msg string
local function show_status(msg)
	vim.cmd.redraw()
	vim.cmd.echo("'" .. msg .. "'")
end

-- Ensure all plugins are installed
---@param repo string
---@return boolean
M.install = function(repo)
	vim.fn.mkdir(M.root_dir .. "/" .. M.pack_dir, "p")
	if vim.fn.isdirectory(path(repo)) == 0 then
		installed = installed + 1
		show_status(string.format("[%d/%d] Installing plugin %s...", installed, to_install, repo))

		local cmd = {}
		if M.config.submodules then
			cmd = { "submodule", "add", "-f", url(repo), pack_dir(repo) }
		else
			cmd = { "clone", "--depth", "1", url(repo), pack_dir(repo) }
		end

		local success, output = git(cmd)
		if not success then
			local hasnotify, notify = pcall(require, "notify")
			if hasnotify then
				notify(vim.list_extend({ repo .. ": Error: " }, output), "error", { title = "Plugins", timeout = 5000 })
			else
				vim.notify("Error installing " .. repo .. ".")
			end
			return false
		end

		M.installed[repo] = true

		-- vim.cmd("helptags ALL")
	end

	return true
end

---@param dir string The repo directory to remove
M.uninstall = function(dir)
	show_status(string.format("Uninstalling %s...", dir))

	if M.config.submodules then
		git({ "submodule", "deinit", "-f", dir })
		git({ "rm", "-f", dir })
	else
		local rmdir = M.root_dir .. "/" .. dir
		vim.notify("Removing " .. rmdir)
		vim.fn.delete(rmdir, "rf")
	end
end

M.update_all = function()
	for repo, _ in pairs(M.plugins) do
		M.update(repo)
	end
end

M.update = function(repo)
	if M.config.submodules then
	else
		git({ "pull" }, {
			root_dir = path(repo),
			async = true,
			on_success = function(output)
				local updated = true
				for _, line in ipairs(output) do
					if line == "Already up to date." then updated = false end
				end
				if updated then vim.notify(repo .. " updated.") end
			end,
			on_failure = function(output)
				require("notify")(vim.list_extend({ repo .. ": Error: " }, output), "error", { title = "Plugins", timeout = 5000 })
			end,
		})
	end
end

-- Remove any plugins in our pack_dir which are not defined in our list of plugins
M.cleanup = function()
	local desired = {}
	for _, spec in pairs(M.plugins) do
		local dir = pack_dir(spec.repo)
		if dir ~= nil then table.insert(desired, dir) end
	end

	local full_pack_dir = M.root_dir .. "/" .. M.pack_dir
	if vim.fn.isdirectory(full_pack_dir) == 1 then
		local handle = vim.loop.fs_scandir(full_pack_dir)
		if handle then
			while true do
				local name, ftype = vim.loop.fs_scandir_next(handle)
				if not name then break end
				if ftype == "directory" then
					local dir = M.pack_dir .. name
					if not vim.tbl_contains(desired, dir) then M.uninstall(dir) end
				end
			end
		end
	end
end

---@param arg string|tlj.Plugin
M.opt = function(arg) M.add(arg) end

---@param arg string|tlj.Plugin
M.start = function(arg)
	local spec = M.add(arg)

	if spec.repo ~= nil and spec.repo ~= "" then M.load(spec.repo) end
end

local function after_start()
	vim.schedule(function()
		for repo, _ in pairs(M.plugins) do
			if vim.fn.isdirectory(path(repo)) == 0 then to_install = to_install + 1 end
		end

		for repo, spec in pairs(M.plugins) do
			if not spec.after then M.load(repo) end
		end

		M.cleanup()
	end)
end

M.setup = function(opts)
	M.config = vim.tbl_deep_extend("force", M.config, opts or {})

	for _, p in ipairs(M.config.start) do
		M.start(p)
	end

	for _, p in ipairs(M.config.opt) do
		M.opt(p)
	end

	if M.config.install then
		for repo, _ in pairs(M.plugins) do
			M.install(repo)
		end
	end

	vim.api.nvim_create_user_command("GraftUpdate", function() require("graft").update_all() end, {})

	vim.api.nvim_create_autocmd("VimEnter", {
		group = M.autogroup,
		callback = after_start,
		once = true,
	})
end

---@param name string
---@return string
local function normalize_require_name(name)
	-- First remove .lua or .nvim extension if present
	name = name:gsub("%.lua$", ""):gsub("%.nvim$", "")
	-- Then replace remaining dots with dashes
	name = name:gsub("%.", "-")
	return name
end

-- Include a spec file with a plugin definition
---@param repo string
M.include = function(repo)
	-- change the slash to -- for filename
	local f = repo_dir(repo)
	-- remove extension and add the load path
	local fp = "config/plugins/" .. normalize_require_name(f)

	-- try to load it
	local hasspec, spec = pcall(require, fp)
	if not hasspec then
		vim.notify("Could not include " .. fp .. ".lua", "error")
		return
	end

	return spec
end

return M
