--
--
--
plugin("nvim-notify", {
	init = true,
	setup = function()
		require("notify").setup()
		vim.notify = require("notify")
	end,
})
