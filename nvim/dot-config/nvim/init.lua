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
vim.opt.rtp:prepend("~/src/graft.nvim")
vim.opt.rtp:prepend("~/src/graft-git.nvim")
vim.opt.rtp:prepend("~/src/graft-ui.nvim")

-- Automatically install graft with graft-git if it doesn't already exist
local function graft(e)
	local c = vim.fn.shellescape(vim.fn.stdpath("config"))
	e = e or { "" }
	table.insert(e, "")
	for i, x in ipairs(e) do
		if i == 1 and not vim.fn.system("git -C " .. c .. " rev-parse --is-inside-work-tree"):match("^true") then
			vim.fn.system("git -C " .. c .. " init")
			if vim.v.shell_error ~= 0 then error("Git init failed") end
		end
		local n = x ~= "" and "-" .. x or ""
		if not pcall(require, "graft" .. n) then
			vim.fn.system(string.format("git -C %s submodule add -f https://github.com/tlj/graft%s.nvim.git pack/graft/start/graft%s.nvim", c, n, n))
			if vim.v.shell_error ~= 0 then error("Failed: graft" .. n .. ".nvim") end
			package.loaded["graft" .. n] = nil
		end
	end
	vim.cmd("packloadall!")
end
graft({ "git", "ui" })

-- Use graft tools to automatically
require("graft-git").setup({ install_plugins = true, remove_plugins = true })
require("graft-ui").setup()

-- Load plugins through the graft plugin
require("graft").setup({
	now = {
		{ "luisiacc/gruvbox-baby", { setup = function() vim.cmd("colorscheme gruvbox-baby") end } },
		{
			"rcarriga/nvim-notify",
			{ name = "notify", tag = "v3.14.1", setup = function() vim.notify = require("notify") end },
		},
		{ "hrsh7th/cmp-nvim-lsp", { name = "cmp_nvim_lsp" } }, -- this is used in lsp.lua to combine capabilities
	},
	later = {
		{ "nvim-tree/nvim-web-devicons", { settings = { color_icons = true }, events = { "UIEnter" } } },
		{ "zbirenbaum/copilot.lua", require("config/plugins/copilot") },
		{ "CopilotC-Nvim/CopilotChat.nvim", require("config/plugins/CopilotChat") },
		{ "zbirenbaum/copilot-cmp", { name = "copilot_cmp", after = { "zbirenbaum/copilot" } } },
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
		{ "lazygit", { cmds = { "Lazygit" }, keys = { ["<leader>lg"] = { cmd = ":Lazygit<cr>" } } } },
	},
})

-- enable LSP
require("config.lsp")

-- Force the statusline to be transparent since it is distracting
vim.cmd('highlight StatusLine guibg=NONE')
vim.cmd('highlight StatusLineNC guibg=NONE')

-- if neovim is started with a directory as an argument, change to that directory
if vim.fn.isdirectory(vim.v.argv[2]) == 1 then vim.api.nvim_set_current_dir(vim.v.argv[2]) end
