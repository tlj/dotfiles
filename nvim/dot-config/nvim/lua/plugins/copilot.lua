-- Github Copilot & Copilot Chat
--
-- AI tools for autocompletion and code generation. CopilotChat is great for
-- talking to the LLM. After Copilot started supporting other models we default
-- to using Claude.
--
-- https://github.com/zbirenbaum/copilot.lua
-- https://github.com/CopilotC-Nvim/CopilotChat.nvim
plugin("copilot", {
	events = { "InsertEnter" },
	commands = { "Copilot" },
	setup = function()
		require("copilot").setup({
			suggestion = {
				enabled = false,
				auto_trigger = true,
			},
			panel = { enabled = false },
		})
	end,
	keys = {},
})

plugin("copilotchat", {
	commands = { "CopilotChat", "CopilotChatOpen", "CopilotChatToggle" },
	before = { "copilot", "plenary" },
	-- dependencies = {
	-- 	{ "zbirenbaum/copilot.lua" }, -- or zbirenbaum/copilot.lua
	-- 	{ "nvim-lua/plenary.nvim", branch = "master" }, -- for curl, log and async functions
	-- },
	-- build = "make tiktoken", -- Only on MacOS or Linux
	setup = function()
		require("copilotchat").setup({
			model = "claude-3.5-sonnet",
		})
	end,
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
})
