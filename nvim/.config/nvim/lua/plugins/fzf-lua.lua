return {
	"ibhagwan/fzf-lua",
	enabled = require("config.util").is_enabled("ibhagwan/fzf-lua"),
	dependencies = { "nvim-tree/nvim-web-devicons" },
	config = function()
		require("fzf-lua").setup({
			"default",
			winopts = {
				preview = {
					layout = "vertical",
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
