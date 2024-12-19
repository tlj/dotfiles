return {
	events = { "UIEnter" },
	settings = {},
	setup = function()
		vim.notify = require("notify")
	end,
}
