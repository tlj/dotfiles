-- Provides Nerd Font icons (glyphs) for use by neovim plugins
--
-- This plugin is used by a lot of other plugins to provide nice icons.
--
-- https://github.com/nvim-tree/nvim-web-devicons
plugin("nvim-web-devicons", {
	-- events = { "UIEnter" },
	setup = function()
		require("nvim-web-devicons").setup({ color_icons = true })
	end,
})
