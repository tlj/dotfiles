local severity = { "ERROR", "WARN" }

local function get_buf_diagnostics(bufnr)
	local diag = vim.diagnostic.get(bufnr, severity)

	table.sort(diag, function(a, b) return a.severity < b.severity end)

	return diag
end

local function goto_diagnostic(diagnostics)
	local win_id = vim.fn.bufwinid(diagnostics.bufnr)
	if win_id ~= -1 then vim.api.nvim_set_current_win(win_id) end
	vim.api.nvim_set_current_buf(diagnostics.bufnr)
	vim.api.nvim_win_set_cursor(0, { diagnostics.lnum + 1, diagnostics.col + 1 })
end

local function show_buf_diagnostics()
	local bufnr = vim.api.nvim_get_current_buf()
	local diags = get_buf_diagnostics(bufnr)
	local filename = vim.api.nvim_buf_get_name(bufnr)

	if not diags or #diags == 0 then
		vim.print("No diagnostics for this buffer.")
		return
	end

	local deck = require("deck")

	deck.start({
		name = "buffer diagnostics",
		execute = function(ctx)
			local bufname = vim.fn.fnamemodify(filename, ":t")

			for _, diag in ipairs(diags) do
				ctx.item({
					data = {
						filename = filename,
						bufname = bufname,
						bufnr = diag.bufnr,
						lnum = diag.lnum + 1,
						col = diag.col + 1,
						diagnostics = diag,
					},
					display_text = {
						{ ("(%s:%s): %s"):format(diag.lnum + 1, diag.col + 1, diag.message) },
					},
				})
			end
			ctx.done()
		end,
		actions = {
			{
				name = "default",
				resolve = function(ctx)
					-- Action is available only if there is exactly one action item with a key map.
					local is_resolve = #ctx.get_action_items() == 1 and ctx.get_action_items()[1].data
					return is_resolve
				end,
				execute = function(ctx)
					local item = ctx.get_action_items()[1].data.diagnostics
					ctx.hide()
					goto_diagnostic(item)
				end,
			},
			{
				name = "open_keep",
				resolve = function(ctx)
					-- Action is available only if there is exactly one action item with a key map.
					local is_resolve = #ctx.get_action_items() == 1 and ctx.get_action_items()[1].data
					return is_resolve
				end,
				execute = function(ctx)
					local item = ctx.get_action_items()[1].data.diagnostics
					goto_diagnostic(item)
				end,
			},
		},
	})
end

local signs = require("config.icons").lsp.diagnostic.signs
local icons = {
	[vim.diagnostic.severity.ERROR] = signs.Error,
	[vim.diagnostic.severity.WARN] = signs.Warn,
	[vim.diagnostic.severity.HINT] = signs.Hint,
	[vim.diagnostic.severity.INFO] = signs.Info,
}
local hls = {
	[vim.diagnostic.severity.ERROR] = "DiagnosticSignError",
	[vim.diagnostic.severity.WARN] = "DiagnosticSignWarn",
	[vim.diagnostic.severity.HINT] = "DiagnosticSignHint",
	[vim.diagnostic.severity.INFO] = "DiagnosticSignInfo",
}

require("deck").register_decorator({
	name = "diagnostics",
	resolve = function(_, item) return item.data.diagnostics end,
	decorate = function(_, item, row)
		local bufname = item.data.bufname
		local icon = icons[item.data.diagnostics.severity]
		local hl = hls[item.data.diagnostics.severity]

		return {
			{
				row = row,
				col = 0,
				virt_text = { { "  " .. icon .. "  ", hl } },
				virt_text_pos = "inline",
			},
			{
				row = row,
				col = 0,
				virt_text = { { bufname, "Comment" } },
				virt_text_pos = "right_align",
			},
		}
	end,
})

vim.keymap.set(
	"n",
	"<leader>gl",
	function() show_buf_diagnostics() end,
	{ desc = "Show buffer diagnostics" }
)
