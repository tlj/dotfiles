-- Download and install the Lazy plugin manager
require("config/lazy")

-- Set default Neovim options
require("config/options")

-- Set custom statusline
require("config/statusline")

-- Load autocommands
require("config/autocmds")

local ll = require("config/plugloader")

-- Set colorscheme
require("catppuccin").setup({})
vim.cmd("colorscheme catppuccin-mocha")

-- Set up tmux navigation
require("nvim-tmux-navigation").setup({
	disable_when_zoomed = true,
	keybindings = { left = "<C-h>", down = "<C-j>", up = "<C-k>", right = "<C-l>" },
})

-- Conform
require("conform").setup({
	formatters_by_ft = {
		lua = { "stylua" },
		sh = { "shfmt" },
	},
	formatters = {
		shfmt = { preprend_args = { "-i", "2" } },
	},
})
vim.o.formatexpr = "v:lua.require'conform'.formatexpr()"
vim.keymap.set("n", "<leader>oo", function()
	require("conform").format({ async = true, lsp_fallback = true })
end, { noremap = true, silent = true })

-- Fzf-lua
ll.register("fzf-lua", {
	commands = { "FzfLua" },
	setup = function()
	local actions = require("fzf-lua.actions")
		require("fzf-lua").setup({
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
})
vim.keymap.set("n", "<leader>ff", "<cmd>FzfLua files<cr>", { noremap = true, silent = true })
vim.keymap.set("n", "<leader>fg", "<cmd>FzfLua live_grep<cr>", { noremap = true, silent = true })

-- if neovim is started with a directory as an argument, change to that directory
if vim.fn.isdirectory(vim.v.argv[2]) == 1 then
	vim.api.nvim_set_current_dir(vim.v.argv[2])
end
