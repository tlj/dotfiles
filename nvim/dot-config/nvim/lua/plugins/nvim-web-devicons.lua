-- Provides Nerd Font icons (glyphs) for use by neovim plugins 
--
-- This plugin is used by a lot of other plugins to provide nice icons.
--
-- https://github.com/nvim-tree/nvim-web-devicons
return {
	"nvim-tree/nvim-web-devicons",
	enabled = true,
	event = { "UIEnter" },
	opts = {
		color_icons = true,
	},
}

