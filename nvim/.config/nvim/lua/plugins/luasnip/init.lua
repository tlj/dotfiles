return {
	"L3MON4D3/LuaSnip",
	dependencies = {
		{
			"rafamadriz/friendly-snippets",
			config = function()
				vim.schedule(function()
					require("luasnip.loaders.from_vscode").load()
				end)
			end,
			enabled = true,
		},
	},
  -- stylua: ignore
  keys = {
    { mode = { "i", "s" }, "<C-l>", function()
      local ls = require("luasnip")
      if ls.choice_active() then ls.change_choice(1) end
    end,
    },
    { mode = { "i", "s" }, "<C-h>", function()
      local ls = require("luasnip")
      if ls.choice_active() then ls.change_choice(-1) end
    end,
    },
  },
	lazy = true,
	enabled = true,
	config = function()
		local ls = require("luasnip")
		local types = require("luasnip.util.types")

		ls.add_snippets("go", require("plugins.luasnip.go"))
		ls.add_snippets("lua", require("plugins.luasnip.lua"))

		ls.config.set_config({ --{{{
			store_selection_keys = "<c-s>",
			updateevents = "TextChanged,TextChangedI",
			ft_func = require("luasnip.extras.filetype_functions").from_pos_or_filetype,

			ext_opts = {
				[types.choiceNode] = {
					active = {
						virt_text = { { " ", "TSTextReference" } },
					},
				},
				[types.insertNode] = {
					active = {
						virt_text = { { " ", "TSEmphasis" } },
					},
				},
			},
		}) --}}}
	end,
}
