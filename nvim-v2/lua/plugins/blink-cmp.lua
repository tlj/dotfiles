local M = {
	"saghen/blink.cmp",
	enabled = true,
	lazy = false, -- lazy loading handled internally
	-- optional: provides snippets for the snippet source
	dependencies = {
		"rafamadriz/friendly-snippets",
		"giuxtaposition/blink-cmp-copilot",
	},

	-- use a release tag to download pre-built binaries
	version = "v0.*",
	-- OR build from source, requires nightly: https://rust-lang.github.io/rustup/concepts/channels.html#working-with-nightly-rust
	-- build = 'cargo build --release',
	-- If you use nix, you can build from source using latest nightly rust with:
	-- build = 'nix run .#build-plugin',

	---@module 'blink.cmp'
	---@type blink.cmp.Config
	opts = {
		-- 'default' for mappings similar to built-in completion
		-- 'super-tab' for mappings similar to vscode (tab to accept, arrow keys to navigate)
		-- 'enter' for mappings similar to 'super-tab' but with 'enter' to accept
		-- see the "default configuration" section below for full documentation on how to define
		-- your own keymap.
		keymap = {
			preset = "default",
			["<CR>"] = { "accept", "fallback" },
		},

		highlight = {
			-- sets the fallback highlight groups to nvim-cmp's highlight groups
			-- useful for when your theme doesn't support blink.cmp
			-- will be removed in a future release, assuming themes add support
			use_nvim_cmp_as_default = true,
		},
		-- set to 'mono' for 'Nerd Font Mono' or 'normal' for 'Nerd Font'
		-- adjusts spacing to ensure icons are aligned
		nerd_font_variant = "mono",

		completion = {
			menu = {
				draw = {
					columns = {
						{ "label", "label_description", gap = 1 },
						{ "kind_icon", "kind" },
					},
				},
			},
		},

		-- windows = {
		-- 	autocomplete = {
		-- 		winblend = vim.o.pumblend,
		-- 		draw = {
		-- 			columns = {
		-- 				{ "label", "label_description", gap = 1 },
		-- 				{ "kind_icon", "kind" },
		-- 			},
		-- 		},
		-- 	},
		-- 	documentation = {
		-- 		auto_show = true,
		-- 	},
		-- 	ghost_text = {
		-- 		enabled = true,
		-- 	},
		-- },

		-- default list of enabled providers defined so that you can extend it
		-- elsewhere in your config, without redefining it, via `opts_extend`
		sources = {
			providers = {
				copilot = { name = "copilot", module = "blink-cmp-copilot" },
				lazydev = { name = "lazydev", module = "lazydev.integrations.blink" },
				lsp = { fallback_for = { "lazydev" } },
				-- dadbod = { name = "DadBod", module = "vim_dadbod_completion.blink" },
			},
			completion = {
				enabled_providers = { "copilot", "lsp", "path", "snippets", "buffer", "lazydev" },
				-- enabled_providers = { 'copilot', 'lsp', 'path', 'snippets', 'buffer', 'dadbod' },
			},
		},

		-- experimental auto-brackets support
		accept = { auto_brackets = { enabled = true } },

		-- experimental signature help support
		-- trigger = { signature_help = { enabled = true } }
	},
	-- allows extending the enabled_providers array elsewhere in your config
	-- without having to redefine it
	opts_extend = { "sources.completion.enabled_providers" },
}

return M
