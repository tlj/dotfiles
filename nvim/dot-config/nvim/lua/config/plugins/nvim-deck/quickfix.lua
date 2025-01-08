require("deck").register_action({
	name = "to_qf",
	desc = "Send selected items to quickfix list",

	resolve = function(ctx)
		local items = ctx.get_selected_items()
		local valid_items = vim.tbl_filter(
			function(item) return item.data and item.data.filename ~= nil end,
			items
		)
		return #valid_items > 0
	end,

	execute = function(ctx)
		local items = ctx.get_selected_items()

		local qf_items = vim.tbl_map(
			function(item)
				return {
					filename = item.data.filename,
					lnum = item.data.lnum or 1,
					col = item.data.col or 1,
					text = item.display_text,
				}
			end,
			items
		)

		vim.fn.setqflist(qf_items)

		vim.cmd("copen")
		ctx.hide()
	end,
})
