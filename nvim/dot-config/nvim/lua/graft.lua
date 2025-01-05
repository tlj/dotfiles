local M = {
	root_dir = vim.fn.stdpath("config"),
	pack_dir = "pack/graft/opt/",
	plugins = {},
	loaded = {},
}

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

---@param args string[]
local function git(args)
	local base = { "git", "-C", M.root_dir }

	return vim.fn.system(vim.list_extend(base, args))
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

-- Register events which will trigger loading of the plugin
---@param spec tlj.Plugin
local function register_events(spec)
	if spec.events then
		vim.api.nvim_create_autocmd(spec.events, {
			group = M.autogroup,
			pattern = spec.pattern or "*",
			callback = function() M.load(spec.repo) end,
			once = true, -- we only need this to happen once
		})
	end
end

-- Register a proxy user command which will load the plugin and then
-- trigger the command on the plugin
---@param spec tlj.Plugin
local function register_cmds(spec)
	for _, cmd in ipairs(spec.cmds or {}) do
		-- Register a command for each given commands
		vim.api.nvim_create_user_command(cmd, function(args)
			-- When triggered, delete this command
			vim.api.nvim_del_user_command(cmd)

			-- Then load the plugin
			M.load(spec.repo)

			-- Then trigger the original command
			vim.cmd(string.format("%s %s", cmd, args.args))
		end, {
			nargs = "*",
		})
	end
end

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

-- Register keys which will load the plugin and trigger an action
---@param spec tlj.Plugin
local function register_keys(spec)
	if not spec.keys then return end

	for key, _ in pairs(spec.keys) do
		local callback = function()
			vim.keymap.del("n", key)
			M.load(spec.repo)
			local keys = vim.api.nvim_replace_termcodes(key, true, true, true)
			vim.api.nvim_feedkeys(keys, "m", false)
		end

		vim.keymap.set("n", key, callback, {})
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

	-- Register commands for lazy loading the plugin
	register_cmds(spec)

	-- Register lazy loading events
	register_events(spec)

	-- Register plugins which will trigger the loading of this plugin
	register_after(spec)

	-- Register keys which will load plugin and trigger action
	register_keys(spec)

	return spec
end

---@param repo string
---@return string
local function get_repo_require_path(repo)
	local name = repo:match("[^/]+$")
	return name:gsub("%.lua$", ""):gsub("%.nvim$", "")
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
		M.load(req_spec.repo)
	end

	-- Add the package to Neovim
	vim.cmd("packadd " .. repo_dir(repo))

	-- Run setup function if it exists
	if spec.setup and type(spec.setup) == "function" then
		spec.setup(spec.settings or {})
	else
		-- Let's just make a guess at the correct setup name
		local ok, p = pcall(require, get_repo_require_path(spec.repo))
		if ok and type(p.setup) == "function" then p.setup(spec.settings or {}) end
	end

	-- Setup keymaps from config
	for key, opts in pairs(spec.keys or {}) do
		vim.keymap.set("n", key, opts.cmd, { desc = opts.desc or "", noremap = false, silent = true })
	end

	-- Trigger an event saying plugin is loaded, so other plugins
	-- which are waiting for us can trigger.
	vim.api.nvim_exec_autocmds("User", { pattern = spec.repo })
end

local function url(repo) return "https://github.com/" .. repo end

-- Ensure all plugins are installed
---@param repo string
---@return boolean
M.install = function(repo)
	if vim.fn.isdirectory(path(repo)) == 0 then
		local nid =
			vim.notify(repo .. ": installing plugin... ", "info", { title = "Plugins", timeout = 1000 })

		local success, output = git({ "submodule", "add", "-f", url(repo), pack_dir(repo) })
		if not success then
			vim.notify(
				repo .. ": Error: " .. vim.inspect(output),
				"error",
				{ title = "Plugins", replace = nid, timeout = 5000 }
			)
			return false
		end

		vim.cmd("helptags ALL")

		vim.notify(repo .. ": installed.", "info", { title = "Plugins", replace = nid, timeout = 1000 })
	end

	return true
end

---@param arg string|tlj.Plugin
M.opt = function(arg) M.add(arg) end

---@param arg string|tlj.Plugin
M.start = function(arg)
	local spec = M.add(arg)

	if spec.repo ~= nil and spec.repo ~= "" then M.load(spec.repo) end
end

M.setup = function(opts)
	local defaults = { start = {}, opt = {} }
	local plugins = vim.tbl_deep_extend("force", defaults, opts or {})

	for _, p in ipairs(plugins.start) do
		M.start(p)
	end

	for _, p in ipairs(plugins.opt) do
		M.opt(p)
	end
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
		vim.notify("Could not include " .. fp .. ".lua", vim.log.levels.ERROR)
		return
	end

	return spec
end

return M
