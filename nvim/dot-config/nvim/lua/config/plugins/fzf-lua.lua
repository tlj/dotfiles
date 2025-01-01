return {
	settings = nil,
	cmds = { "FzfLua" },
	setup = function()
		require("fzf-lua").setup({
			file_ignore_patterns = {
				"pack/graft",
			},
			oldfiles = {
				include_current_session = true,
				cwd_only = true,
				stat_file = true,
			},
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
			files = {
				git_icons = false,
				file_icons = false,
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
					-- ["default"]     =require("fzf-lua.actions").file_edit,
					["default"] = require("fzf-lua.actions").file_edit_or_qf,
					["ctrl-s"] = require("fzf-lua.actions").file_split,
					["ctrl-v"] = require("fzf-lua.actions").file_vsplit,
					["ctrl-t"] = require("fzf-lua.actions").file_tabedit,
					["alt-k"] = require("fzf-lua.actions").file_sel_to_qf,
					["alt-q"] = require("fzf-lua.actions").file_sel_to_qf,
					["alt-l"] = require("fzf-lua.actions").file_sel_to_ll,
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
					["ctrl-q"] = "select-all+accept",
					-- Only valid with fzf previewers (bat/cat/git/etc)
					["f3"] = "toggle-preview-wrap",
					["f4"] = "toggle-preview",
					["shift-down"] = "preview-page-down",
					["shift-up"] = "preview-page-up",
				},
			},
		})
		require("fzf-lua").register_ui_select()
	end,
	keys = {
		["<leader>ff"] = { cmd = "<cmd>FzfLua files<cr>", desc = "Fuzzyfind files" },
		["<leader>fg"] = { cmd = "<cmd>FzfLua live_grep<cr>", desc = "Fuzzyfind files" },

		["<leader>*"] = { cmd = "<cmd>FzfLua grep_cword<cr>", desc = "Fzf grep_cword" },
		["<leader>fw"] = { cmd = "<cmd>FzfLua grep_cword<cr>", desc = "Fzf grep_cword" },
		["<leader>fW"] = { cmd = "<cmd>FzfLua grep_cWORD<cr>", desc = "Fzf grep_cWORD" },
		["<leader>fb"] = { cmd = "<cmd>FzfLua buffers<cr>", desc = "Fzf Buffers" },
		["<leader>fh"] = { cmd = "<cmd>FzfLua help_tags<cr>", desc = "Fzf Help Tags" },
		["<leader>qf"] = { cmd = "<cmd>FzfLua quickfix<cr>", desc = "Fzf Quickfix List" },
		["<leader>q:"] = { cmd = "<cmd>FzfLua command_history<cr>", desc = "Fzf Command History" },
		["<leader>tm"] = { cmd = "<cmd>FzfLua tmux_buffers<cr>", desc = "Fzf Tmux Buffers" },

		["<leader>rr"] = { cmd = "<cmd>FzfLua resume<cr>", desc = "Fzf Resume" },

		["<leader>ga"] = { cmd = "<cmd>FzfLua lsp_code_actions<cr>", desc = "Fzf Code Actions" },
		["<leader>gf"] = { cmd = "<cmd>FzfLua lsp_finder<cr>", desc = "Fzf LSP Finder" },
		["<leader>gi"] = { cmd = "<cmd>FzfLua lsp_implementations<cr>", desc = "Fzf Implementations" },
		["<leader>go"] = { cmd = "<cmd>FzfLua lsp_outgoing_calls<cr>", desc = "Fzf Outgoing Calls" },
		["<leader>gc"] = { cmd = "<cmd>FzfLua lsp_incoming_calls<cr>", desc = "Fzf Incoming Calls" },
		["<leader>gr"] = { cmd = "<cmd>FzfLua lsp_references<cr>", desc = "Fzf References" },
		["<leader>gd"] = { cmd = "<cmd>FzfLua lsp_definitions<cr>", desc = "Fzf Definitions" },
		["<leader>gD"] = { cmd = "<cmd>FzfLua lsp_declarations<cr>", desc = "Fzf Declarations" },
		["<leader>gt"] = { cmd = "<cmd>FzfLua lsp_typedefs<cr>", desc = "Fzf Type Definitions" },
		["<leader>gl"] = {
			cmd = "<cmd>FzfLua lsp_document_diagnostics<cr>",
			desc = "Fzf Document Diagnostics",
		},
		["<leader>gs"] = { cmd = "<cmd>FzfLua lsp_document_symbols<cr>", desc = "Fzf Document Symbols" },

		["<leader>gj"] = { cmd = "<cmd>FzfLua jumps<cr>", desc = "Fzf Jumps" },
		["<leader>gh"] = { cmd = "<cmd>FzfLua changes<cr>", desc = "FZf Changes" },

		["<leader>gwl"] = {
			cmd = "<cmd>FzfLua lsp_workspace_diagnostics<cr>",
			desc = "Fzf Workspace Diagnostics",
		},
		["<leader>gws"] = {
			cmd = "<cmd>FzfLua lsp_workspace_symbols<cr>",
			desc = "Fzf Workspace Symbols",
		},
		["<leader>gwy"] = {
			cmd = "<cmd>FzfLua lsp_live_workspace_symbols<cr>",
			desc = "Fzf Live Workspace Symbols",
		},
	},
}
