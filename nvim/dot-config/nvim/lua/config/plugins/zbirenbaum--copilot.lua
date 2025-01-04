return {
	repo = "zbirenbaum/copilot.lua",
	cmds = { "Copilot" },
	events = { "InsertEnter" },
	settings = {
		suggestion = {
			enabled = false,
			auto_trigger = true,
		},
		panel = { enabled = false },
	},
	setup = function(settings) require("copilot").setup(settings) end,
}
