return {
	"ibhagwan/fzf-lua",
	enabled = require("config.util").is_enabled("ibhagwan/fzf-lua"),
	dependencies = { "nvim-tree/nvim-web-devicons" },
	config = function()
		local actions = require("fzf-lua.actions")
		require("fzf-lua").setup({
			"default",
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
					["default"] = actions.file_edit_or_qf,
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
		})
	end,
	keys = {
		{ "<leader>ff", "<cmd>FzfLua files<cr>" },
		{ "<leader>fg", "<cmd>FzfLua live_grep<cr>" },
		{ "<leader>*", "<cmd>FzfLua grep_cword<cr>" },
		{ "<leader>fw", "<cmd>FzfLua grep_cword<cr>" },
		{ "<leader>fW", "<cmd>FzfLua grep_cWORD<cr>" },
		{ "<leader>fb", "<cmd>FzfLua buffers<cr>" },
		{ "<leader>fh", "<cmd>FzfLua help_tags<cr>" },
		{ "<leader>qf", "<cmd>FzfLua quickfix<cr>" },
		{ "<leader>q:", "<cmd>FzfLua command_history<cr>" },
		{ "<leader>tm", "<cmd>FzfLua tmux_buffers<cr>" },

		{ "<leader>rr", "<cmd>FzfLua resume<cr>" },

		-- { "<leader>gc", "<cmd>FzfLua git_commits<cr>" },
		-- { "<leader>gf", "<cmd>FzfLua git_files<cr>" },
		-- { "<leader>gh", "<cmd>FzfLua git_bcommits<cr>", desc = "History - FzfLua Git Commits (buffer)" },
		-- { "<leader>gs", "<cmd>FzfLua git_status<cr>" },

		{ "<leader>ga", "<cmd>FzfLua lsp_code_actions<cr>" },
		{ "<leader>gf", "<cmd>FzfLua lsp_finder<cr>" },
		{ "<leader>gi", "<cmd>FzfLua lsp_implementations<cr>" },
		{ "<leader>go", "<cmd>FzfLua lsp_outgoing_calls<cr>" },
		{ "<leader>gc", "<cmd>FzfLua lsp_incoming_calls<cr>" },
		{ "<leader>gr", "<cmd>FzfLua lsp_references<cr>" },
		{ "<leader>gd", "<cmd>FzfLua lsp_definitions<cr>" },
		{ "<leader>gD", "<cmd>FzfLua lsp_declarations<cr>" },
		{ "<leader>gt", "<cmd>FzfLua lsp_typedefs<cr>" },
		{ "<leader>gl", "<cmd>FzfLua lsp_document_diagnostics<cr>" },
		{ "<leader>gs", "<cmd>FzfLua lsp_document_symbols<cr>" },

		{ "<leader>gj", "<cmd>FzfLua jumps<cr>" },
		{ "<leader>gh", "<cmd>FzfLua changes<cr>" },

		{ "<leader>gwl", "<cmd>FzfLua lsp_workspace_diagnostics<cr>" },
		{ "<leader>gws", "<cmd>FzfLua lsp_workspace_symbols<cr>" },
		{ "<leader>gwy", "<cmd>FzfLua lsp_live_workspace_symbols<cr>" },
	},
}
