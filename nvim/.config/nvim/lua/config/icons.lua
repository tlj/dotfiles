-- icons we will use, defined in one place for easier overrides
return {
	lsp = {
		diagnostic = {
			signs = {
				Error = "✘",
				Warn = "▲",
				Info = "⚑",
				Hint = "",
			},
			upper_signs = {
				-- We don't want to calculate these on the fly.
				ERROR = "✘",
				WARN = "▲",
				INFO = "⚑",
				HINT = "",
			},
		},
	},

	kinds = {
		Text = "",
		Method = "",
		Function = "",
		Constructor = "",
		Field = "ﰠ",
		Variable = "",
		Class = "ﴯ",
		Interface = "",
		Module = "",
		Property = "ﰠ",
		Unit = "塞",
		Value = "",
		Enum = "",
		Keyword = "",
		Snippet = "",
		Color = "",
		File = "",
		Reference = "",
		Folder = "",
		EnumMember = "",
		Constant = "",
		Struct = "פּ",
		Event = "",
		Operator = "",
		TypeParameter = "",
		Copilot = "",
	},

	border_fn = function(hl)
		return {
			{ "╭", hl },
			{ "─", hl },
			{ "╮", hl },
			{ "│", hl },
			{ "╯", hl },
			{ "─", hl },
			{ "╰", hl },
			{ "│", hl },
		}
	end,
}
