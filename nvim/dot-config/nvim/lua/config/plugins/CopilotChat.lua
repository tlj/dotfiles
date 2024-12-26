return {
	cmds = { "CopilotChat", "CopilotChatOpen", "CopilotChatToggle" },
	requires = { "zbirenbaum/copilot.lua", "nvim-lua/plenary.nvim" },
	settings = {
		model = "claude-3.5-sonnet",
	},
	keys = {
		["<leader>cco"] = { cmd = "<cmd>CopilotChat<cr>", desc = "CopilotChat" },
		["<leader>ccq"] = {
			cmd = function()
				local input = vim.fn.input("Quick Chat: ")
				if input ~= "" then
					require("CopilotChat").ask(input, { selection = require("CopilotChat.select").buffer })
				end
			end,
			desc = "CopilotChat - Quick chat",
		},
		["<leader>ccp"] = {
			cmd = function()
				local actions = require("CopilotChat.actions")
				require("CopilotChat.integrations.fzflua").pick(actions.prompt_actions())
			end,
			desc = "CopilotChat - Prompt actions",
		},
	},
}
