return {
	events = { "VimEnter" },
	settings = {
		keymap = {
			preset = "default",
			["<CR>"] = { "accept", "fallback" },
			["<Up>"] = { "select_prev", "fallback" },
			["<Down>"] = { "select_next", "fallback" },
			["<C-d>"] = { "select_prev", "fallback" },
		},

		highlight = {
			use_nvim_cmp_as_default = true,
		},
		nerd_font_variant = "mono",

		completion = {
			list = {
				selection = "manual",
			},
			keyword = {
				range = "full",
			},
			accept = {
				auto_brackets = {
					enabled = true,
				},
			},
			menu = {
				border = "single",
				auto_show = false,
				draw = {
					treesitter = true,
					columns = {
						{ "label", "label_description", gap = 1 },
						{ "kind_icon", "kind" },
						{ "source_name" },
					},
				},
			},
			documentation = {
				auto_show = true,
			},
			ghost_text = {
				enabled = true,
			},
		},

		fuzzy = {
			-- controls which sorts to use and in which order, falling back to the next sort if the first one returns nil
			-- you may pass a function instead of a string to customize the sorting
			sorts = { "score", "kind", "label" },
		},

		sources = {
			providers = {
				copilot = { name = "copilot", module = "blink-cmp-copilot" },
			},
			completion = {
				enabled_providers = { "copilot", "lsp", "path", "snippets", "buffer" },
			},
		},
	},
}
