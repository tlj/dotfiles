local M = {
	"echasnovski/mini.clue",
	enabled = require("config.util").is_enabled("echasnovski/mini.clue"),
	version = "*",
	config = function()
		local miniclue = require("mini.clue")
		miniclue.setup({
			triggers = {
				-- Leader triggers
				{ mode = "n", keys = "<Leader>" },
				{ mode = "x", keys = "<Leader>" },

				-- Built-in completion
				{ mode = "i", keys = "<C-x>" },

				-- `g` key
				{ mode = "n", keys = "g" },
				{ mode = "x", keys = "g" },

				-- Marks
				{ mode = "n", keys = "'" },
				{ mode = "n", keys = "`" },
				{ mode = "x", keys = "'" },
				{ mode = "x", keys = "`" },

				-- Registers
				{ mode = "n", keys = '"' },
				{ mode = "x", keys = '"' },
				{ mode = "i", keys = "<C-r>" },
				{ mode = "c", keys = "<C-r>" },

				-- Window commands
				{ mode = "n", keys = "<C-w>" },

				-- `z` key
				{ mode = "n", keys = "z" },
				{ mode = "x", keys = "z" },
			},
			clues = {
				{ mode = 'n', keys = '<leader>a', desc = '+Copilot Chat' },
				{ mode = 'n', keys = '<leader>b', desc = '+Buffers' },
				{ mode = 'n', keys = '<leader>c', desc = '+Copilot' },
				{ mode = 'n', keys = '<leader>d', desc = '+Debug' },
				{ mode = 'n', keys = '<leader>f', desc = '+FZF/Float' },
				{ mode = 'n', keys = '<leader>g', desc = '+LSP/Diagnostics' },
				{ mode = 'n', keys = '<leader>gw', desc = '+Workspace Diagnostics' },
				{ mode = 'n', keys = '<leader>h', desc = '+Harpoon/Diffview' },
				{ mode = 'n', keys = '<leader>j', desc = '+Session' },
				{ mode = 'n', keys = '<leader>l', desc = '+Lazygit' },
				{ mode = 'n', keys = '<leader>n', desc = '+NeoTree' },
				{ mode = 'n', keys = '<leader>o', desc = '+Conform/Obsidian' },
				{ mode = 'n', keys = '<leader>q', desc = '+QuickFix' },
				{ mode = 'n', keys = '<leader>r', desc = '+Rename/Resume' },
				{ mode = 'n', keys = '<leader>s', desc = '+OpenAPI Browser' },
				{ mode = 'n', keys = '<leader>t', desc = '+Tests, Diagnostics' },
				{ mode = 'n', keys = '<leader>u', desc = '+Undo' },
				{ mode = 'n', keys = '<leader>w', desc = '+Window' },
				miniclue.gen_clues.builtin_completion(),
				miniclue.gen_clues.g(),
				miniclue.gen_clues.marks(),
				miniclue.gen_clues.registers(),
				miniclue.gen_clues.windows(),
				miniclue.gen_clues.z(),
			},
		})
	end,
}

return M
