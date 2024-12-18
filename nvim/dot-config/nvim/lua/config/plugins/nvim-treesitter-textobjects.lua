-- Syntax aware text-objects, select, move, swap, and peek support.
--
-- Defines textobjects for use in navigations and manipulation, such as
-- functions, methods, classes, etc.
--
-- https://github.com/nvim-treesitter/nvim-treesitter-textobjects
return {
	settings = {
		textobjects = {
			select = {
				enable = true,
				lookahead = true, -- Automatically jump forward to textobj, similar to targets.vim
				keymaps = {
					["a="] = { query = "@assignment.outer", desc = "Select outer part of an assignment" },
					["i="] = { query = "@assignment.inner", desc = "Select inner part of an assignment" },
					["l="] = { query = "@assignment.lhs", desc = "Select left hand side of an assignment" },
					["r="] = { query = "@assignment.rhs", desc = "Select right hand side of an assignment" },

					["aa"] = { query = "@parameter.outer", desc = "Select outer part of a parameter/argument" },
					["ia"] = { query = "@parameter.inner", desc = "Select inner part of a parameter/argument" },

					["ai"] = { query = "@conditional.outer", desc = "Select outer part of a conditional" },
					["ii"] = { query = "@conditional.inner", desc = "Select inner part of a conditional" },

					["al"] = { query = "@loop.outer", desc = "Select outer part of a loop" },
					["il"] = { query = "@loop.inner", desc = "Select inner part of a loop" },

					["af"] = { query = "@call.outer", desc = "Select outer part of a function call" },
					["if"] = { query = "@call.inner", desc = "Select inner part of a function call" },

					["am"] = {
						query = "@function.outer",
						desc = "Select outer part of a method/function definition",
					},
					["im"] = {
						query = "@function.inner",
						desc = "Select inner part of a method/function definition",
					},

					["ac"] = { query = "@class.outer", desc = "Select outer part of a class" },
					["ic"] = { query = "@class.inner", desc = "Select inner part of a class" },
				},
			},
			move = {
				enable = true,
				set_jumps = true, -- whether to set jumps in the jumplist
				goto_next_start = {
					["]f"] = { query = "@call.outer", desc = "Next function call start" },
					["]m"] = { query = "@function.outer", desc = "Next function call start" },
					["]c"] = { query = "@class.outer", desc = "Next class start" },
					["]i"] = { query = "@conditional.outer", desc = "Next conditional start" },
					["]l"] = { query = "@loop.outer", desc = "Next loop start" },
				},
				goto_next_end = {
					["]F"] = { query = "@call.outer", desc = "Next function call start" },
					["]M"] = { query = "@function.outer", desc = "Next function call start" },
					["]C"] = { query = "@conditional.outer", desc = "Next conditional start" },
					["]I"] = { query = "@class.outer", desc = "Next class start" },
					["]L"] = { query = "@loop.outer", desc = "Next loop start" },
				},
				goto_previous_start = {
					["[f"] = { query = "@call.outer", desc = "Next function call start" },
					["[m"] = { query = "@function.outer", desc = "Next function call start" },
					["[c"] = { query = "@class.outer", desc = "Next class start" },
					["[i"] = { query = "@conditional.outer", desc = "Next conditional start" },
					["[l"] = { query = "@loop.outer", desc = "Next loop start" },
				},
				goto_previous_end = {
					["[F"] = { query = "@call.outer", desc = "Next function call start" },
					["[M"] = { query = "@function.outer", desc = "Next function call start" },
					["[C"] = { query = "@class.outer", desc = "Next class start" },
					["[I"] = { query = "@conditional.outer", desc = "Next conditional start" },
					["[L"] = { query = "@loop.outer", desc = "Next loop start" },
				},
			},
		},
	},
	setup = function()
		-- local ts_repeat_move = require("nvim-treesitter.textobjects.repeatable_move")

		-- vim way: use ; and , to repeat motions
		-- vim.keymap.set({ "n", "x", "o" }, ";", ts_repeat_move.repeat_last_move)
		-- vim.keymap.set({ "n", "x", "o" }, ",", ts_repeat_move.repeat_last_move_opposite)

		-- optionally, make builtin f, F, t, and T work similarly
		--vim.keymap.set({ "n", "x", "o" }, "f", ts_repeat_move.builtin_f)
		--vim.keymap.set({ "n", "x", "o" }, "F", ts_repeat_move.builtin_F)
		--vim.keymap.set({ "n", "x", "o" }, "t", ts_repeat_move.builtin_t)
		--vim.keymap.set({ "n", "x", "o" }, "T", ts_repeat_move.builtin_T)
	end,
}
