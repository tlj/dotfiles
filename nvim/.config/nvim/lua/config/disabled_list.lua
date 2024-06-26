---@type table<string, table<string, boolean>>
---HELLO_WORLD=true
---BYE_WORLD=false
return {
	["tlj/api-browser.nvim"] = { enabled = true, start = true },
	["utilyre/barbecue.nvim"] = { enabled = true, start = true },
	["rose-pine/neovim"] = { enabled = true, start = true },
	["catppuccin/nvim"] = { enabled = false, start = false },
	["ribru17/bamboo.nvim"] = { enabled = false, start = false },
	["sainnhe/gruvbox-material"] = { enabled = false, start = false },
	["stevarc/conform.nvim"] = { enabled = false, start = false },
	["zbirenbaum/copilot.lua"] = { enabled = true, start = true },
	["zbirenbaum/copilot-cmp"] = { enabled = true, start = true },
	["CopilotC-Nvim/CopilotChat.nvim"] = { enabled = true, start = true },
	["mfussenegger/nvim-dap"] = { enabled = true, start = true },
	["leoluz/nvim-dap-go"] = { enabled = true, start = true },
	["rcarriga/nvim-dap-ui"] = { enabled = true, start = true },
	["jau-babu/mason-nvim-dap.nvim"] = { enabled = true, start = true },
	["nvim-telescope/telescope-dap.nvim"] = { enabled = true, start = true },
	["folke/which-key.nvim"] = { enabled = true, start = true },
	["sindrets/diffview.nvim"] = { enabled = true, start = true },
	["stevearc/dressing.nvim"] = { enabled = true, start = true },
	["folke/flash.nvim"] = { enabled = true, start = true },
	["ibhagwan/fzf-lua"] = { enabled = true, start = true },
	["lewis6991/gitsigns.nvim"] = { enabled = true, start = true },
	["robitx/gp.nvim"] = { enabled = true, start = true },
	["ThePrimeagen/harpoon"] = { enabled = true, start = true },
	["nvim-lualine/lualine.nvim"] = { enabled = true, start = true },
	["echasnovski/mini.bufremove"] = { enabled = true, start = true },
	["echasnovski/mini.indentscope"] = { enabled = false, start = false },
	["lukas-reineke/indent-blankline.nvim"] = { enabled = true, start = true },
	["numToStr/Comment.nvim"] = { enabled = false, start = false },
	["folke/todo-comments.nvim"] = { enabled = true, start = true },
	["tpope/vim-sleuth"] = { enabled = true, start = true },
	["epwalsh/obsidian.nvim"] = { enabled = true, start = true },
	["nvim-neo-tree/neo-tree.nvim"] = { enabled = true, start = true },
	["krivahtoo/silicon.nvim"] = { enabled = true, start = true },
	["emmanueltouzery/agitator.nvim"] = { enabled = false, start = false },
	["f-person/git-blame.nvim"] = { enabled = false, start = false },
	["FredeEB/tardis.nvim"] = { enabled = true, start = true },
	["kevinhwang91/nvim-bqf"] = { enabled = true, start = true },
	["milisims/nvim-luaref"] = { enabled = true, start = true },
	["nvim-neotest/neotest"] = { enabled = true, start = true },
	["gennaro-tedesco/nvim-possession"] = { enabled = true, start = true },
	["alexghergh/nvim-tmux-navigation"] = { enabled = true, start = true },
	["nvim-treesitter/nvim-treesitter-textobjects"] = { enabled = true, start = true },
	["nvim-tressitter/nvim-treesitter"] = { enabled = true, start = true },
	["nvim-tree/nvim-web-devicons"] = { enabled = true, start = true },
	["stevearc/oil.nvim"] = { enabled = true, start = true },
	["luukvbaal/statuscol"] = { enabled = true, start = true },
	["nvim-telescope/telescope.nvim"] = { enabled = true, start = true },
	["mbbill/undotree"] = { enabled = true, start = true },
	["ray-x/go.nvim"] = { enabled = true, start = true },
	["FabijanZulj/blame.nvim"] = { enabled = true, start = true },
	["kndndrj/nvim-dbee"] = { enabled = true, start = true },

	--- LSP
	["neovim/nvim-lspconfig"] = { enabled = true, start = true },
	["williamboman/mason.nvim"] = { enabled = true, start = true },
	["weilbith/nvim-code-action-menu"] = { enabled = false, start = false },
	["kosayode/nvim-lightbulb"] = { enabled = true, start = true },
	["SmiteshP/nvim-navbuddy"] = { enabled = false, start = false },
	["https://git.sr.ht/~whynothugo/lsp_lines.nvim"] = { enabled = true, start = true },
	["williamboman/mason-lspconfig.nvim"] = { enabled = true, start = true },

	--- CMP
	["hrsh7th/nvim-cmp"] = { enabled = true, start = true },
}
