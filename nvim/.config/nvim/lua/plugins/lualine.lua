-- better status line
local M = {
	"nvim-lualine/lualine.nvim",
	enabled = true,
	dependencies = {
		"Isrothy/lualine-diagnostic-message",
	},
	config = function()
		require("lualine").setup({
			options = {
				theme = 'catppuccin',
				-- component_separators = "",
				-- section_separators = { left = " ", right = "" },
			},
			sections = {
				lualine_a = {
					"mode",
				},
				lualine_c = {
					"diagnostic-message",
				},
			},
		})
	end,
}

return M

