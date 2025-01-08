--- Keymap Viewer
local function get_all_keymaps()
	local maps = {}
	local modes = { "n", "i", "v", "x", "o" }

	for _, mode in ipairs(modes) do
		local mode_maps = vim.api.nvim_get_keymap(mode)
		for _, map in ipairs(mode_maps) do
			local lhs = map.lhs
			if lhs ~= nil and lhs:sub(1, 1) == " " then lhs = "<Leader>" .. lhs:sub(2) end

			map["display_text"] = string.format(
				"%s | %s → %s %s",
				mode,
				lhs,
				map.rhs or "",
				map.desc and ("(" .. map.desc .. ")") or ""
			)
			table.insert(maps, map)
		end
	end

	-- Get buffer-local keymaps for current buffer
	local bufnr = vim.api.nvim_get_current_buf()
	for _, mode in ipairs(modes) do
		local buf_maps = vim.api.nvim_buf_get_keymap(bufnr, mode)
		for _, map in ipairs(buf_maps) do
			local lhs = map.lhs
			if lhs ~= nil and lhs:sub(1, 1) == " " then lhs = "<Leader>" .. lhs:sub(2) end

			map["display_text"] = string.format(
				"%s | %s → %s %s (buffer)",
				mode,
				lhs,
				map.rhs or "",
				map.desc and ("(" .. map.desc .. ")") or ""
			)
			table.insert(maps, map)
		end
	end

	return maps
end

local function show_keymap_picker()
	local ok, deck = pcall(require, "deck")
	if not ok then
		vim.notify("nvim-deck is not installed", vim.log.levels.ERROR)
		return
	end

	local maps = get_all_keymaps()

	deck.start({
		name = "Mappings",
		execute = function(ctx)
			for _, map in ipairs(maps) do
				ctx.item(map)
			end
			ctx.done()
		end,
		actions = {
			{
				name = "default",
				resolve = function(ctx)
					-- Action is available only if there is exactly one action item with a key map.
					local is_resolve = #ctx.get_action_items() == 1 and ctx.get_action_items()[1].lhs
					return is_resolve
				end,
				execute = function(ctx)
					ctx.hide()
					local lhs = ctx.get_action_items()[1].lhs
					local keys = vim.api.nvim_replace_termcodes(lhs, true, true, true)
					vim.api.nvim_feedkeys(keys, "m", false)
				end,
			},
		},
	})
end

-- Export the function
vim.api.nvim_create_user_command("KeymapPicker", function() show_keymap_picker() end, {})
vim.keymap.set("n", "<leader>km", ":KeymapPicker<CR>")
