--[[
Neovim Plugin Loader

A minimal plugin manager that handles lazy loading and configuration management
for Neovim plugins installed as git submodules in pack/vendor/opt/.

Features:
- Lazy loading via commands, keymaps, events, and filetype triggers
- Automatic config loading from lua/config/plugins/
- Plugin dependency management
- Git submodule-based installation

Basic Usage:
```lua
require('plugins').setup({
    -- Plugins to load immediately
    now = {
        "nvim-treesitter",
        "plenary.nvim"
    },
    -- Plugins to load lazily
    later = {
        -- Basic lazy loading on command
        { "telescope.nvim", cmd = "Telescope" },

        -- Load when another plugin loads
        { "telescope-fzf-native.nvim", when = "telescope.nvim" },

        -- Load on filetype
        { "rust-tools.nvim", ft = "rust" },

        -- Load on events
        { "lualine.nvim", events = { "VimEnter" } }
    }
})
```

Configuration can be specified in two ways:

1. Inline during setup:
```lua
later = {
    {
        "telescope.nvim",
        settings = { defaults = { layout_strategy = "vertical" } },
        keys = {
            ["<leader>ff"] = { cmd = "<cmd>Telescope find_files<CR>", desc = "Find Files" }
        }
    }
}
```

2. In separate config files at lua/config/plugins/{plugin-name}.lua:
```lua
-- lua/config/plugins/telescope.lua
return {
    settings = {
        defaults = { layout_strategy = "vertical" }
    },
    keys = {
        ["<leader>ff"] = { cmd = "<cmd>Telescope find_files<CR>", desc = "Find Files" }
    }
}
```

Plugin Management Commands:
- :PluginAdd user/repo folder-name  -- Add plugin as git submodule
- :PluginRemove folder-name         -- Remove plugin submodule

Events and Dependencies:
- Plugins can specify dependencies via 'requires' field
- 'when' field loads plugin after another plugin loads
- Custom events triggered via "User" autocmd after each plugin loads

Configuration Structure:
{
    settings = {},     -- Passed to plugin's setup() function
    setup = function() -- Custom setup code
    keys = {},         -- Keymaps with commands and descriptions
    cmd = "",         -- Commands that trigger lazy loading
    requires = "",    -- Dependencies to load first
    events = {},      -- Events that trigger loading
    ft = "",         -- Filetype that triggers loading
    when = "",       -- Plugin to wait for
    pattern = ""     -- Pattern for event matching
}
--]]

local M = {}

-- Autogroup for plugin-related autocommands
M.plugin_augroup = vim.api.nvim_create_augroup("plugins", { clear = true })
-- Track loaded plugins
M.is_loaded = {}
-- Store command configurations
M.commands = {}
-- Store plugin configurations
M.plugins = {}

---Load plugin configuration from lua/config/plugins/
M.load_config = function(plugin)
	local plugin_cfg = plugin:gsub("%.", "-")
	local hasconfig, config = pcall(require, "config.plugins." .. plugin_cfg)
	if not hasconfig then
		config = {}
	end
	return config
end

---Load a plugin and its dependencies
M.load = function(plugin)
	-- Please don't load a plugin which has already been loaded!
	if M.is_loaded[plugin] then
		return
	end
	M.is_loaded[plugin] = true

	-- Load dependencies first
	-- Dependencies can be defined either as a string or as a table
	local requires = M.plugins[plugin].requires
	if requires then
		if type(requires) == "table" then
			for _, r in ipairs(requires) do
				M.load(r)
			end
		end
		if type(requires) == "string" then
			M.load(requires)
		end
	end

	-- Load and configure the plugin
	pcall(function() vim.cmd("packadd " .. plugin) end)
	local config = M.plugins[plugin]

	local p = require(plugin)

	if config.setup and type(config.setup) == "function" then
		config.setup()
	elseif p.setup and type(p.setup) == "function" then
		p.setup(config.settings or {})
	end

	-- Setup keymaps from config
	if config.keys then
		for key, opts in pairs(config.keys) do
			---@diagnostic disable-next-line: missing-fields
			vim.keymap.set("n", key, opts.cmd, { desc = opts.desc, noremap = true, silent = true })
		end
	end

	vim.api.nvim_exec_autocmds("User", { pattern = plugin })
end

---Create a lazy-loaded keymap
M.load_on_key = function(key, plugin, actual)
	vim.keymap.set("n", key, function()
		vim.keymap.del("n", key)
		M.load(plugin)
		local keys = vim.api.nvim_replace_termcodes(actual, true, true, true)
		vim.api.nvim_feedkeys(keys, "m", false)
	end)
end

---Setup lazy-loaded commands
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

---Create a lazy-loaded command
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

---Initialize plugin system
M.setup = function(plugins)
	-- Load immediate plugins
	if plugins.now then
		for _, plugin in pairs(plugins.now) do
			-- The immediate plugins must have their configuration in a file
			-- so we only support string here
			if type(plugin) == "string" then
				M.plugins[plugin] = M.load_config(plugin)
				M.load(plugin)
			end
		end

		-- Setup lazy-loaded plugins
		if plugins.later then
			for _, plugin in pairs(plugins.later) do
				local name = ""
				local options = {}

				-- Handle string or table plugin spec
				if type(plugin) == "string" then
					name = plugin
				end

				-- If it's a table we take the first string as the
				-- name of the plugin, and remove it from the options
				-- table.
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

				-- Merge plugin options with config
				-- The configuration given in setup() is given priority over the
				-- configuration loaded from file.
				local config = M.load_config(name)
				options = vim.tbl_deep_extend("force", config, options)
				M.plugins[name] = options

				local pattern = options.pattern or "*"

				-- Set up autocommands for automatically loading the plugin for
				-- defined events.
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

				-- Set up autocommands for automatically loading the plugin for
				-- defined filetypes.
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

				-- Every plugin which is loaded will send an event. To load a plugin
				-- after another event we can define it in the `when` table, and it
				-- will be loaded after the defined plugins.
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

				-- Use the keymaps defined in the options to load the plugin
				-- when a keymap is used
				if options.keys then
					for key, _ in pairs(options.keys) do
						M.load_on_key(key, name, key)
					end
				end

				-- Use the commands defined in the options to load the plugin
				-- when a command is called.
				if options.cmd then
					M.load_on_commands(options.cmd, name)
				end
			end
		end
	end
end

---Add a plugin as a git submodule
M.add_plugin = function(github_path, folder_name)
	local config_path = vim.fn.stdpath("config")

	local cmd = string.format(
		"git -C %s submodule add https://github.com/%s %s",
		config_path,
		github_path,
		"pack/vendor/opt/" .. folder_name
	)

	local success = os.execute(cmd)
	if not success then
		error("Failed to add plugin: " .. github_path)
	end
end

---Remove a plugin submodule
M.remove_plugin = function(folder_name)
	local config_path = vim.fn.stdpath("config")
	local plugin_path = "pack/vendor/opt/" .. folder_name

	local commands = {
		string.format("git -C %s submodule deinit -f %s", config_path, plugin_path),
		string.format("git -C %s rm -f %s", config_path, plugin_path),
		string.format("rm -rf %s/.git/modules/%s", config_path, plugin_path),
	}

	for _, cmd in ipairs(commands) do
		if os.execute(cmd) ~= 0 then
			error("Failed to remove plugin: " .. folder_name)
		end
	end
end

-- Create user commands for plugin management
vim.api.nvim_create_user_command("PluginAdd", function(opts)
	local args = vim.split(opts.args, " ")
	if #args ~= 2 then
		error("Usage: PluginAdd github_path folder_name")
		return
	end
	require("plugins").add_plugin(args[1], args[2])
end, { nargs = "*" })

vim.api.nvim_create_user_command("PluginRemove", function(opts)
	if opts.args == "" then
		error("Usage: PluginRemove folder_name")
		return
	end
	require("plugins").remove_plugin(opts.args)
end, { nargs = 1 })

return M
