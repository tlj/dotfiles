return {
	repo = "stevearc/conform.nvim",
	events = { "BufReadPre", "BufNewFile" },
	cmds = { "ConformInfo" },
	settings = {
		log_level = vim.log.levels.DEBUG,
		formatters_by_ft = {
			go = { "goimports" },
			lua = { "stylua" },
			sh = { "shfmt" },
			markdown = { "mdformat" },
		},
		formatters = {
			shfmt = { preprend_args = { "-i", "2" } },
		},
		format_on_save = function(bufnr)
			if vim.g.disable_autoformat or vim.b[bufnr].disable_autoformat then return end

			local autoformat_filetypes = { "lua", "go", "json" }
			local filetype = vim.bo[bufnr].filetype

			if vim.tbl_contains(autoformat_filetypes, filetype) then return { timeout_ms = 500, lsp_format = "fallback" } end
		end,
	},
	setup = function(opts)
		require("conform").setup(opts)
		vim.o.formatexpr = "v:lua.require'conform'.formatexpr()"

		vim.api.nvim_create_user_command("FormatDisable", function(args)
			if args.bang then
				-- FormatDisable! will disable formatting just for this buffer
				vim.b.disable_autoformat = true
			else
				vim.g.disable_autoformat = true
			end
		end, { desc = "Disable autoformat-on-save", bang = true })

		vim.api.nvim_create_user_command("FormatEnable", function()
			vim.b.disable_autoformat = false
			vim.g.disable_autoformat = false
		end, { desc = "Enable autoformat-on-save" })
	end,
	keys = {
		["<leader>oo"] = {
			cmd = function() require("conform").format({ async = false, lsp_fallback = false }) end,
			desc = "Format file",
		},
	},
}
