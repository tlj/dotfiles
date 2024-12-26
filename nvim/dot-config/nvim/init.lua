-- Set default Neovim options
require("config.options")

-- Set default Neovim options
require("config.mappings")

-- Load autocommands
require("config.autocmds")

-- Load our custom statusline
require("statusline").setup()

-- Load graft.nvim from local dev path if it exist, if not we load it from
-- the submodule, prepend it to the table so we load it from dev instead
-- of the submodule
local graft_path = vim.fn.expand("~/src/graft.nvim")
if vim.fn.isdirectory(graft_path) == 1 then
	vim.opt.rtp:prepend(graft_path)
end

-- Load plugins through the graft plugin
require("graft").setup({
	now = {
		{ "catppuccin/nvim", { name = "catppuccin", setup = function() vim.cmd("colorscheme catppuccin-mocha") end } },
		{ "rcarriga/nvim-notify", { name = "notify", setup = function() vim.notify = require("notify") end } },
		{ "hrsh7th/cmp-nvim-lsp", { name = "cmp_nvim_lsp" } }, -- this is used in lsp.lua to combine capabilities
	},
	later = {
		{ "nvim-web-tree/nvim-web-devicons", { settings = { color_icons = true }, events = { "UIEnter" } } },
		{ "zbirenbaum/copilot.lua", require("config/plugins/copilot") },
		{ "CopilotC-Nvim/CopilotChat.nvim", require("config/plugins/CopilotChat") },
		{ "zbirenbaum/copilot-cmp", { when = { "zbirenbaum/copilot-cmp" } } },
		{ "hrsh7th/nvim-cmp", require("config/plugins/nvim-cmp") },
		{ "alexghergh/nvim-tmux-navigation", require("config/plugins/nvim-tmux-navigation") },
		{ "stevearc/conform.nvim", require("config/plugins/conform") },
		{ "lewis6991/gitsigns.nvim", require("config/plugins/gitsigns") },
		{ "ibhagwan/fzf-lua", require("config/plugins/fzf-lua") },
		{ "stevearc/oil.nvim", require("config/plugins/oil") },
		{ "MagicDuck/grug-far.nvim", require("config/plugins/grug-far") },
		{ "nvim-treesitter/nvim-treesitter", require("config/plugins/nvim-treesitter") },
		{ "aaronik/treewalker.nvim", require("config/plugins/treewalker") },
		{ "mfussenegger/nvim-dap", require("config/plugins/nvim-dap") },
		{ "theHamsta/nvim-dap-virtual-text" },
		{ "leoluz/nvim-dap-go", require("config/plugins/nvim-dap-go") },
		{ "rcarriga/nvim-dap-ui", require("config/plugins/nvim-dap-ui") },
		{ "lazygit", { cmd = { "Lazygit" }, keys = { ["<leader>lg"] = { cmd = ":Lazygit<cr>" } } } },
	},
})

-- enable LSP
require("config.lsp")

-- if neovim is started with a directory as an argument, change to that directory
if vim.fn.isdirectory(vim.v.argv[2]) == 1 then
	vim.api.nvim_set_current_dir(vim.v.argv[2])
end
