return {
	settings = {
		"fzf-native",
		winopts = {
			height = 0.9,
			width = 0.9,
			row = 0.3,
			col = 0.3,
			fullscreen = false,
			preview = {
				layout = "vertical",
				vertical = "down:70%",
				horizontal = "right:50%",
			},
		},
		previewers = {
			builtin = {
				extensions = {
					["png"] = { "viu", "-b" },
					["jpg"] = { "viu", "-b" },
				},
				ueberzug_scaler = "cover",
			},
		},
		grep = {
			rg_opts = "--column --hidden --line-number --no-heading --color=always --smart-case --ignore-file ~/.config/nvim/scripts/rgignore --max-columns=4096 -e",
		},
		actions = {
			files = {
				-- providers that inherit these actions:
				--   files, git_files, git_status, grep, lsp
				--   oldfiles, quickfix, loclist, tags, btags
				--   args
				-- default action opens a single selection
				-- or sends multiple selection to quickfix
				-- replace the default action with the below
				-- to open all files whether single or multiple
				-- ["default"]     = actions.file_edit,
				["default"] = require("fzf-lua.actions").file_edit_or_qf,
				["ctrl-s"] = actions.file_split,
				["ctrl-v"] = actions.file_vsplit,
				["ctrl-t"] = actions.file_tabedit,
				["alt-k"] = actions.file_sel_to_qf,
				["alt-q"] = actions.file_sel_to_qf,
				["alt-l"] = actions.file_sel_to_ll,
			},
		},
		keymap = {
			fzf = {
				-- fzf '--bind=' options
				["ctrl-z"] = "abort",
				["ctrl-u"] = "unix-line-discard",
				["ctrl-f"] = "half-page-down",
				["ctrl-b"] = "half-page-up",
				["ctrl-a"] = "beginning-of-line",
				["ctrl-e"] = "end-of-line",
				["alt-j"] = "toggle-all",
				-- Only valid with fzf previewers (bat/cat/git/etc)
				["f3"] = "toggle-preview-wrap",
				["f4"] = "toggle-preview",
				["shift-down"] = "preview-page-down",
				["shift-up"] = "preview-page-up",
			},
		},
	},
}
