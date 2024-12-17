--
--
--
plugin("nvim-notify", {
	init = true,
	priority = 1000,
	setup = function()
		require("notify").setup()
		vim.notify = require("notify")
	end,
})
