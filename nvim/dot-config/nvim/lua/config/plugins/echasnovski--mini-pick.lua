return {
	"echasnovski/mini.pick",
	cmds = { "Pick" },
	keys = {
		["<leader>ff"] = { cmd = "<cmd>Pick git_files<cr>", desc = "Fuzzyfind git files" },
		["<leader>fa"] = { cmd = "<cmd>Pick files<cr>", desc = "Fuzzyfind all files" },
		["<leader>fg"] = { cmd = "<cmd>Pick grep_live<cr>", desc = "Live grep content" },
		--
		["<leader>*"] = { cmd = "<cmd>Pick grep pattern='<cword>'<cr>", desc = "grep_cword" },
		["<leader>fw"] = { cmd = "<cmd>Pick grep pattern='<cword>'<cr>", desc = "grep_cword" },
		["<leader>fW"] = { cmd = "<cmd>Pick grep pattern='<cWORD>'<cr>", desc = "grep_cWORD" },
		["<leader>fb"] = { cmd = "<cmd>Pick buffers<cr>", desc = "Navigate Buffers" },
		["<leader>fh"] = { cmd = "<cmd>Pick help<cr>", desc = "Help Tags" },
		["<leader>qf"] = { cmd = "<cmd>Pick list scope='quickfix'<cr>", desc = "Quickfix List" },
		-- ["<leader>q:"] = { cmd = "<cmd>FzfLua command_history<cr>", desc = "Fzf Command History" },
		-- ["<leader>tm"] = { cmd = "<cmd>FzfLua tmux_buffers<cr>", desc = "Fzf Tmux Buffers" },
		--
		["<leader>rr"] = { cmd = "<cmd>Pick resume<cr>", desc = "Resume last picker" },
		--
		-- ["<leader>ga"] = { cmd = "<cmd>FzfLua lsp_code_actions<cr>", desc = "Fzf Code Actions" },
		-- ["<leader>gf"] = { cmd = "<cmd>FzfLua lsp_finder<cr>", desc = "Fzf LSP Finder" },
		["<leader>gi"] = {
			cmd = "<cmd>Pick lsp scope='implementation'<cr>",
			desc = "LSP Implementations",
		},
		-- ["<leader>go"] = { cmd = "<cmd>FzfLua lsp_outgoing_calls<cr>", desc = "Fzf Outgoing Calls" },
		-- ["<leader>gc"] = { cmd = "<cmd>FzfLua lsp_incoming_calls<cr>", desc = "Fzf Incoming Calls" },
		["<leader>gr"] = { cmd = "<cmd>Pick lsp scope='references'<cr>", desc = "Fzf References" },
		["<leader>gd"] = { cmd = "<cmd>Pick lsp scope='definition'<cr>", desc = "Fzf Definitions" },
		["<leader>gD"] = {
			cmd = "<cmd>Pick lsp scope='declaration'<cr>",
			desc = "Fzf Declarations",
		},
		["<leader>gt"] = {
			cmd = "<cmd>Pick lsp scope='type_definition'<cr>",
			desc = "Fzf Type Definitions",
		},
		["<leader>gl"] = {
			cmd = "<cmd>Pick diagnostic scope='current'<cr>",
			desc = "Document Diagnostics",
		},
		-- ["<leader>gs"] = {
		-- 	cmd = "<cmd>FzfLua lsp_document_symbols<cr>",
		-- 	desc = "Fzf Document Symbols",
		-- },
		--
		["<leader>gj"] = { cmd = "<cmd>Pick list scope='jump'<cr>", desc = "Jumps" },
		["<leader>gh"] = { cmd = "<cmd>Pick list scope='change'<cr>", desc = "Changes" },
		--
		["<leader>gwl"] = {
			cmd = "<cmd>Pick diagnostic scope='all'<cr>",
			desc = "Fzf Workspace Diagnostics",
		},
		-- ["<leader>gws"] = {
		-- 	cmd = "<cmd>FzfLua lsp_workspace_symbols<cr>",
		-- 	desc = "Fzf Workspace Symbols",
		-- },
		-- ["<leader>gwy"] = {
		-- 	cmd = "<cmd>FzfLua lsp_live_workspace_symbols<cr>",
		-- 	desc = "Fzf Live Workspace Symbols",
		-- },
	},
}
