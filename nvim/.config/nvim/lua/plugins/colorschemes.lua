-- add colorschemes to this file
return {
	{
		"catppuccin/nvim",
		name = "catppuccin",
		lazy = false,
		priority = 999,
		enabled = true,
		config = function()
			require("catppuccin").setup({
				transparent_background = false,
				dim_inactive = {
					enabled = false,
				},
			})
		end,
	},
	{
		"ribru17/bamboo.nvim",
		lazy = false,
		priority = 1000,
		enabled = false,
		config = function()
			require("bamboo").setup({
				-- optional configuration here
				transparent = true,
				lualine = {
					transparent = true,
				},
			})
			require("bamboo").load()
		end,
	},
	{
		"sainnhe/gruvbox-material",
		lazy = false,
		priority = 999,
		enabled = false,
		config = function()
			vim.g.gruvbox_material_better_performance = 1
			-- Fonts
			vim.g.gruvbox_material_disable_italic_comment = 0
			vim.g.gruvbox_material_enable_italic = 1
			vim.g.gruvbox_material_enable_bold = 1
			vim.g.gruvbox_material_transparent_background = 1
			vim.g.gruvbox_material_diagnostic_virtual_text = "grey"
			-- Themes
			vim.g.gruvbox_material_foreground = "soft"
			vim.g.gruvbox_material_background = "medium"
			vim.g.gruvbox_material_ui_contrast = "high" -- The contrast of line numbers, indent lines, etc.
			vim.g.gruvbox_material_float_style = "dim" -- Background of floating windows
			vim.g.gruvbox_material_dim_inactive_windows = 0 -- Dim inactive windows

			local configuration = vim.fn["gruvbox_material#get_configuration"]()
			local palette = vim.fn["gruvbox_material#get_palette"](
				configuration.background,
				configuration.foreground,
				configuration.colors_override
			)

			local highlights_groups = {
				FoldColumn = { bg = "none" },
				SignColumn = { bg = "none" },
				Normal = { bg = "none" },
				NormalNC = { bg = "none" },
				NormalFloat = { bg = "none" },
				FloatBorder = { bg = "none" },
				FloatTitle = { bg = "none", fg = palette.orange[1] },
				TelescopeBorder = { bg = "none" },
				TelescopeNormal = { fg = "none" },
				TelescopePromptNormal = { bg = "none" },
				TelescopeResultsNormal = { bg = "none" },
				TelescopeSelection = { bg = palette.bg3[1] },
				Visual = { bg = palette.bg_visual_red[1] },
				Cursor = { bg = palette.bg_red[1], fg = palette.bg_dim[1] },
				ColorColumn = { bg = palette.bg_visual_blue[1] },
				CursorLine = { bg = palette.bg3[1], blend = 25 },
				GitSignsAdd = { fg = palette.green[1], bg = "none" },
				GitSignsChange = { fg = palette.yellow[1], bg = "none" },
				GitSignsDelete = { fg = palette.red[1], bg = "none" },
			}

			for group, styles in pairs(highlights_groups) do
				vim.api.nvim_set_hl(0, group, styles)
			end
		end,
	},
}
