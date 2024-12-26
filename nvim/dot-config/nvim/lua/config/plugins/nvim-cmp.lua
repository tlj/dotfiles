local kind_icons = require("config.icons").kinds

return {
	events = { "InsertEnter" },
	requires = {
		{ "L3MON4D3/luasnip" },
		{ "hrsh7th/cmp-buffer", { name = "cmp_buffer", dir = "cmp_buffer" } },
		{ "hrsh7th/cmp-nvim-lsp", { name = "cmp_nvim_lsp", dir = "cmp-nvim-lsp" } },
		{ "hrsh7th/cmp-nvim-lua", { name = "cmp_nvim_lua", dir = "cmp_nvim_lua" } },
		{ "hrsh7th/cmp-path", { name = "cmp_path", dir = "cmp_path" } },
		{ "hrsh7th/cmp-emoji", { name = "cmp_emoji", dir = "cmp_emoji" } },
		{ "zbirenbaum/copilot-cmp", { name = "copilot_cmp" } },
	},

	name = "cmp",
	setup = function(_)
		local cmp = require("cmp")
		local luasnip = require("luasnip")

		vim.api.nvim_set_hl(0, "CmpItemKindCopilot", { fg = "#6CC644" })

		cmp.setup({
			completion = {
				autocomplete = false,
			},

			performance = {
				debounce = 50,
				throttle = 10,
			},

			snippet = {
				expand = function(args) luasnip.lsp_expand(args.body) end,
			},

			preselect = cmp.PreselectMode.None,

			sources = {
				{ name = "nvim_lsp", priority = 90 },
				{ name = "copilot", priority = 80, keyword_length = 3 },
				{ name = "nvim_lua", priority = 70 },
				{ name = "luasnip", priority = 30 },
				{ name = "nvim_lsp_signature_help" },
				{ name = "buffer", keyword_length = 3 },
				{ name = "path" },
				{
					name = "rg",
					keyword_length = 3,
					priority = 5,
					group_index = 5,
					option = {
						additional_arguments = "--max-depth 6 --one-file-system --ignore-file ~/.config/nvim/scripts/rgignore",
					},
				},
				{ name = "emoji", keyword_length = 2 },
				{ name = "nerdfont", keyword_length = 1 },
			},

			formatting = {
				fields = { "abbr", "kind", "menu" },
				format = function(entry, vim_item)
					local client_name = ""
					if entry.source.name == "nvim_lsp" then
						client_name = "/" .. entry.source.source.client.name
					end

					vim_item.menu = string.format("[%s%s]", ({
						buffer = "Buffer",
						nvim_lsp = "LSP",
						luasnip = "LuaSnip",
						emoji = "Emoji",
						nvim_lua = "Lua",
						path = "Path",
						rg = "RG",
						omni = "Omni",
					})[entry.source.name] or entry.source.name, client_name)

					vim_item.kind = string.format("%s %-9s", kind_icons[vim_item.kind], vim_item.kind)
					vim_item.dup = {
						buffer = 1,
						path = 1,
						nvim_lsp = 0,
						luasnip = 1,
					}
					return vim_item
				end,
			},

			view = {
				max_height = 20,
			},

			window = {
				completion = cmp.config.window.bordered({
					border = require("config.icons").border_fn("CmpBorder"),
					winhighlight = "Normal:Normal,FloatBorder:BorderBG,CursorLine:PmenuSel,Search:None",
				}),
				documentation = {
					border = require("config.icons").border_fn("CmpDocBorder"),
				},
			},

			experimental = {
				ghost_text = true,
				native_menu = false,
			},

			mapping = cmp.mapping.preset.insert({
				-- select next/prev item in completion list
				["<C-n>"] = cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Insert }),
				["<C-p>"] = cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Insert }),

				-- Scoll up and down in the completion documentation
				["<C-u>"] = cmp.mapping.scroll_docs(-5),
				["<C-d>"] = cmp.mapping.scroll_docs(5),

				-- abort completion
				["<C-e>"] = cmp.mapping.abort(),

				-- complete suggestion
				["<C-Space>"] = cmp.mapping({
					i = cmp.mapping.complete(),
					c = function(
						_ --[[fallback]]
					)
						if cmp.visible() then
							if not cmp.confirm({ select = true }) then
								return
							end
						else
							cmp.complete()
						end
					end,
				}),

				-- luasnip
				-- go to next placeholder in the snippet
				["<C-f>"] = cmp.mapping(function(fallback)
					if luasnip.jumpable(1) then
						luasnip.jump(1)
					else
						fallback()
					end
				end, { "i", "s" }),

				-- go to the previous placeholder in the snippet
				["<C-b>"] = cmp.mapping(function(fallback)
					if luasnip.jumpable(-1) then
						luasnip.jump(-1)
					else
						fallback()
					end
				end, { "i", "s" }),

				-- Navigate items on the list
				["<Up>"] = cmp.mapping.select_prev_item(),
				["<Down>"] = cmp.mapping.select_next_item(),
				["<C-k>"] = cmp.mapping.select_prev_item(),
				["<C-j>"] = cmp.mapping.select_next_item(),

				-- Accept currently selected item. If none selected, `select` first item.
				-- Set `select` to `false` to only confirm explicitly selected items.
				["<CR>"] = cmp.mapping.confirm({ select = false, behavior = cmp.ConfirmBehavior.Insert }),
				["<C-y>"] = cmp.mapping.confirm({ select = true, behavior = cmp.ConfirmBehavior.Insert }),

				["<Tab>"] = cmp.config.disable,
				["<S-Tab>"] = cmp.config.disable,
			}),

			cmp.setup.filetype("gitcommit", {
				sources = cmp.config.sources({
					{ name = "git", priority = 100 },
					{ name = "luasnip", priority = 80 },
					{ name = "rg", priority = 50 },
					{ name = "path", priority = 10 },
					{ name = "emoji" },
					{ name = "nerdfont" },
				}),
			}),

			vim.keymap.set("n", "<C-Space>", "<cmd>lua require('cmp').complete()<cr>", { noremap = true, silent = true }),
		})
	end,
}
