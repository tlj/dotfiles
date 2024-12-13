-- language server support
return {
	-- lspconfig
	{
		"neovim/nvim-lspconfig",
		enabled = true,
		lazy = true,
		event = { "BufReadPre", "BufNewFile" },
		dependencies = {
			"williamboman/mason.nvim",
		},
	},
	-- Mason for autoinstalling lsps
	{
		"williamboman/mason.nvim",
		enabled = true,
		lazy = true,
		cmd = {
			"Mason",
			"MasonInstall",
			"MasonUninstall",
			"MasonUninstallAll",
			"MasonLog",
			"MasonUpdate",
		},
		build = ":MasonUpdate",
		config = function()
			local path = require("mason-core.path")
			require("mason").setup({
				install_root_dir = path.concat({ vim.fn.stdpath("cache"), "mason" }),
				max_concurrent_installers = 4,
			})
		end,
	},
	{
		"williamboman/mason-lspconfig.nvim",
		enabled = true,
		event = { "BufReadPre", "BufNewFile" },
		dependencies = {
			"williamboman/mason.nvim",
			"neovim/nvim-lspconfig",
		},
		opts = function(_, opts)
			local defaults = {
				ensure_installed = {
					"lua_ls", -- lua
					"lemminx", -- xml
					"bashls", -- bash
					"yamlls", -- yaml
					"intelephense", -- php
					"jsonls", -- json
					"html", -- html
					"gopls", -- golang
					"cssls", -- css
				},
				servers = {
					gopls = require("plugins.lsp.config.gopls"),
					intelephense = require("plugins.lsp.config.intelephense"),
					jsonls = require("plugins.lsp.config.jsonls"),
					lua_ls = require("plugins.lsp.config.lua_ls"),
					yamlls = require("plugins.lsp.config.yamlls"),
				},
			}
			return vim.tbl_deep_extend("force", defaults, opts)
		end,
		config = function(_, opts)
			require("mason").setup()
			require("mason-lspconfig").setup({
				ensure_installed = opts.ensure_installed,
				automatic_installation = true,
			})
			require("mason-lspconfig").setup_handlers({
				function(server_name)
					local conf = opts.servers[server_name] or {}

					local caps = vim.tbl_deep_extend(
						"force",
						vim.lsp.protocol.make_client_capabilities(),
						opts.capabilities or {},
						conf.capabilities or {}
					)
					conf.capabilities = caps

					local pre_attach = function(_, _) end
					if conf.on_attach ~= nil then
						pre_attach = conf.on_attach or function() end
					end

					conf.on_attach = function(client, bufnr)
						client.server_capabilities = vim.tbl_deep_extend(
							"force",
							client.server_capabilities,
							opts.server_capabilities or {},
							conf.server_capabilities or {}
						)
						pre_attach(client, bufnr)
						require("plugins.lsp.on_attach").on_attach(client, bufnr)
					end

					require("lspconfig")[server_name].setup(conf)
				end,
			})
		end,
	},
}

