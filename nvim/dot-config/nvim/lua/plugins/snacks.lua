-- A collection of small QoL plugins for Neovim.
--
-- I use only some of these. Not usually a fan of dashboards, but testing
-- it with this and it works nicely. It has really good integration with
-- Lazygit on the '<leader>l' prefix. I've also not used notifiers a lot
-- before but this one is nice and non-intrusive, so testing it.
--
-- https://github.com/folke/snacks.nvim
plugin("snacks", {
	setup = function()
		require("snacks").setup({
			lazygit = { enabled = true },
		})
	end,
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
})
