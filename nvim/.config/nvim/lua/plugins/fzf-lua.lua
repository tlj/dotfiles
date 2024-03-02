return {
	"ibhagwan/fzf-lua",
	enabled = require("config.util").is_enabled("ibhagwan/fzf-lua"),
	dependencies = { "nvim-tree/nvim-web-devicons" },
	config = function()
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
		})
	end,
	keys = {
		{ "<leader>ff", "<cmd>FzfLua files<cr>" },
		{ "<leader>gf", "<cmd>FzfLua git_files<cr>" },
		{ "<leader>gc", "<cmd>FzfLua git_commits<cr>" },
		{ "<leader>gh", "<cmd>FzfLua git_bcommits<cr>", desc = "History - FzfLua Git Commits (buffer)" },
		{ "<leader>fg", "<cmd>FzfLua live_grep<cr>" },
		{ "<leader>*", "<cmd>FzfLua grep_cword<cr>" },
		{ "<leader>fw", "<cmd>FzfLua grep_cword<cr>" },
		{ "<leader>fW", "<cmd>FzfLua grep_cWORD<cr>" },
		{ "<leader>fb", "<cmd>FzfLua buffers<cr>" },
		{ "<leader>fh", "<cmd>FzfLua help_tags<cr>" },
		{ "<leader>gs", "<cmd>FzfLua git_status<cr>" },
		{ "<leader>td", "<cmd>FzfLua diagnostics_workspace<cr>" },
		{ "<leader>qf", "<cmd>FzfLua quickfix<cr>" },
		{ "<leader>gr", "<cmd>FzfLua lsp_incoming_calls<cr>" },
		{ "<leader>gi", "<cmd>FzfLua lsp_implementations<cr>" },
		{ "<leader>gd", "<cmd>FzfLua lsp_definitions<cr>" },
		{ "<leader>q:", "<cmd>FzfLua command_history<cr>" },
		{ "<leader>tm", "<cmd>FzfLua tmux_buffers<cr>" },
	},
}
