local M = {}

M.plugin_augroup = vim.api.nvim_create_augroup("plugins", { clear = true })
M.is_loaded = {}
M.commands = {}
M.plugins = {}

M.load_config = function(plugin)
	local plugin_cfg = plugin:gsub("%.", "-")
	local hasconfig, config = pcall(require, "config.plugins." .. plugin_cfg)
	if not hasconfig then
		vim.notify(
			"Plugin " .. plugin .. " is missing config (config.plugins." .. plugin_cfg .. "): " .. vim.inspect(config)
		)
		config = { settings = {} }
	end
	return config
end

M.load = function(plugin)
	if M.is_loaded[plugin] then
		return
	end
	local requires = M.plugins[plugin].requires
	if requires then
		if type(requires) == "table" then
			for _, r in ipairs(requires) do
				vim.notify("Loading required plugin " .. r)
				M.load(r)
			end
		end
		if type(requires) == "string" then
			vim.notify("Loading required plugin " .. requires)
			M.load(requires)
		end
	end
	pcall(vim.cmd, "packadd " .. plugin)
	local config = M.load_config(plugin)
	local p = require(plugin)
	if p.setup and config.settings ~= nil then
		p.setup(config.settings)
	end
	if config.setup then
		config.setup()
	end
	if config.keys then
		for key, opts in pairs(config.keys) do
			vim.keymap.set("n", key, opts.cmd, { desc = opts.desc, noremap = true, silent = true })
		end
	end
	vim.api.nvim_exec_autocmds("User", { pattern = plugin })
	M.is_loaded[plugin] = true
end

M.load_on_key = function(key, plugin, actual)
	vim.keymap.set("n", key, function()
		vim.keymap.del("n", key)

		M.load(plugin)

		local keys = vim.api.nvim_replace_termcodes(actual, true, true, true)
		vim.api.nvim_feedkeys(keys, "m", false)
	end)
end

M.load_on_commands = function(cmd, plugin)
	if type(cmd) == "string" then
		M.load_on_command(cmd, plugin, { nargs = "*" })
	end
	if type(cmd) == "table" then
		for _, c in ipairs(cmd) do
			M.load_on_command(c, plugin, { nargs = "*" })
		end
	end
end

M.load_on_command = function(cmd, plugin, opts)
	M.commands[cmd] = { plugin = plugin, opts = opts }

	vim.api.nvim_create_user_command(cmd, function(args)
		vim.api.nvim_del_user_command(cmd)

		M.load(plugin)

		vim.cmd(string.format("%s %s", cmd, args.args))
	end, {
		nargs = opts.nargs or "*",
		complete = opts.complete,
	})
end

M.setup = function(plugins)
	if plugins.now then
		for _, plugin in pairs(plugins.now) do
			if type(plugin) == "string" then
				M.plugins[plugin] = {}
				M.load(plugin)
			end
		end
		if plugins.later then
			for _, plugin in pairs(plugins.later) do
				local name = ""
				local options = {}
				if type(plugin) == "string" then
					name = plugin
				end
				if type(plugin) == "table" then
					name = plugin[1]
					if type(name) ~= "string" then
						error("First element of plugin " .. vim.inspect(plugin) .. " must be a string")
					end

					for k, v in pairs(plugin) do
						if type(k) ~= "number" then
							options[k] = v
						end
					end
				end

				local config = M.load_config(name)
				options = vim.tbl_deep_extend("force", config, options)

				M.plugins[name] = options

				local pattern = options.pattern or "*"
				if options.events then
					vim.api.nvim_create_autocmd(options.events, {
						group = M.plugin_augroup,
						pattern = pattern,
						callback = function()
							M.load(name)
						end,
						once = true,
					})
				end

				if options.ft then
					vim.api.nvim_create_autocmd("FileType", {
						group = M.plugin_augroup,
						pattern = pattern,
						ft = options.ft,
						callback = function()
							M.load(name)
						end,
						once = true,
					})
				end

				-- Whenever another plugin is loaded, load this one after
				if options.when then
					vim.api.nvim_create_autocmd("User", {
						group = M.plugin_augroup,
						pattern = options.when,
						callback = function()
							M.load(name)
						end,
						once = true,
					})
				end

				-- Register keys
				if config.keys then
					for key, _ in pairs(config.keys) do
						M.load_on_key(key, name, key)
					end
				end

				-- Register commands
				if config.cmd then
					M.load_on_commands(config.cmd, name)
				end
			end
		end
	end
end

return M
