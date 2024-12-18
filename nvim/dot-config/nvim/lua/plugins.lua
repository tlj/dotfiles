local M = {}

M.plugin_augroup = vim.api.nvim_create_augroup("plugins", { clear = true })
M.is_loaded = {}

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

M.setup = function(plugins)
	for _, plugin in pairs(plugins) do
		if type(plugin) == "string" then
			M.load(plugin)
		end
		if type(plugin) == "table" then
			local name = plugin[1]
			if type(name) ~= "string" then
				error("First element of plugin " .. vim.inspect(plugin) .. " must be a string")
			end

			local options = {}
			for k, v in pairs(plugin) do
				if type(k) ~= "number" then
					options[k] = v
				end
			end

			local pattern = options.pattern or "*"
			if options.events then
				vim.api.nvim_create_autocmd(options.events, {
					group = M.plugin_augroup,
					pattern = pattern,
					callback = function(ev)
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
					callback = function(ev)
						M.load(name)
					end,
					once = true,
				})
			end

			if options.depends_on then
				vim.api.nvim_create_autocmd("User", {
					group = M.plugin_augroup,
					pattern = options.depends_on,
					callback = function(ev)
						M.load(name)
					end,
					once = true,
				})
			end

			local config = M.load_config(name)
			if config.keys then
				for key, _ in pairs(config.keys) do
					M.load_on_key(key, name, key)
				end
			end
		end
	end
end

return M
