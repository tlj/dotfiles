return {
	settings = {
		lazygit = { enabled = true },
	},
	keys = {
		["<leader>lg"] = {
			cmd = function()
				require("snacks").lazygit()
			end,
			desc = "Lazygit",
		},
		["<leader>ll"] = {
			cmd = function()
				Snacks.lazygit.log()
			end,
			desc = "Lazygit Log",
		},
		["<leader>lf"] = {
			cmd = function()
				Snacks.lazygit.log_file()
			end,
			desc = "Lazygit File Log",
		},
		["<leader>lb"] = {
			cmd = function()
				Snacks.git.blame_line()
			end,
			desc = "Lazygit Blame",
		},
		["<leader>ft"] = {
			cmd = function()
				Snacks.terminal()
			end,
			desc = "Terminal",
		},
	},
}
