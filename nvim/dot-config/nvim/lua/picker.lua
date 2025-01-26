local namespace = vim.api.nvim_create_namespace("picker_results")
local matched_items = {}

local preview_win = nil
local preview_buf = nil
local preview_item = {}

local function close_preview()
	if preview_win and vim.api.nvim_win_is_valid(preview_win) then
		vim.api.nvim_win_close(preview_win, true)
		preview_win = nil
		preview_item = nil
	end
	if preview_buf and vim.api.nvim_buf_is_valid(preview_buf) then
		vim.api.nvim_buf_delete(preview_buf, { force = true })
		preview_buf = nil
		preview_item = nil
	end
end

local function show_preview(item)
	if not item or not item.file then return end

	if item.file == preview_item then return end
	vim.print(string.format("selected %s current %s", item.file, preview_item))

	close_preview()

	preview_item = item.file

	-- Create preview buffer
	preview_buf = vim.api.nvim_create_buf(false, true)

	-- Calculate dimensions and position
	local width = math.floor(vim.o.columns * 0.7)
	local height = math.floor(vim.o.lines * 0.6)
	local row = 0
	local col = math.floor((vim.o.columns - width) / 2)

	-- Window options
	local opts = {
		relative = "editor",
		width = width,
		height = height,
		row = row,
		col = col,
		style = "minimal",
		border = "rounded",
	}

	-- Create window
	preview_win = vim.api.nvim_open_win(preview_buf, false, opts)

	-- Set up preview window options
	vim.api.nvim_win_set_option(preview_win, "wrap", false)
	vim.api.nvim_win_set_option(preview_win, "cursorline", true)

	-- Run bat in the preview window
	vim.api.nvim_win_call(preview_win, function() vim.fn.termopen(("bat --color=always %s"):format(vim.fn.shellescape(item.file))) end)
end

local function create_picker_window()
	local original_win = vim.api.nvim_get_current_win()

	-- Create buffers for results and input
	local results_buf = vim.api.nvim_create_buf(false, true)
	local input_buf = vim.api.nvim_create_buf(false, true)

	-- Create the results window (bottom)
	vim.cmd("botright 10split")
	local results_win = vim.api.nvim_get_current_win()
	vim.api.nvim_win_set_buf(results_win, results_buf)

	-- Create input window (very bottom, 1 line height)
	vim.cmd("botright 1split")
	local input_win = vim.api.nvim_get_current_win()
	vim.api.nvim_win_set_buf(input_win, input_buf)

	-- Set window/buffer options for results
	vim.wo[results_win].wrap = false
	vim.wo[results_win].number = false
	vim.wo[results_win].relativenumber = false
	vim.wo[results_win].signcolumn = "no"
	vim.bo[results_buf].modifiable = false
	vim.bo[results_buf].buftype = "nofile"
	vim.bo[results_buf].swapfile = false
	vim.wo[results_win].statusline = " "

	-- Set window/buffer options for input
	vim.bo[input_buf].modifiable = true
	vim.bo[input_buf].buftype = "nofile"
	vim.bo[input_buf].swapfile = false
	vim.wo[input_win].statusline = " "

	-- Store all items for filtering
	local all_items = {}

	local function fuzzy_match_and_score(text, pattern)
		if pattern == "" then return true, 0 end

		text = text:lower()
		pattern = pattern:lower()

		local pattern_len = #pattern
		local text_len = #text
		local j = 1
		local score = 0
		local consecutive = 0
		local last_match_idx = 0

		for i = 1, text_len do
			if text:sub(i, i) == pattern:sub(j, j) then
				-- Increase score based on matching criteria
				if last_match_idx and i == last_match_idx + 1 then
					consecutive = consecutive + 1
					score = score + (2 * consecutive) -- Bonus for consecutive matches
				else
					consecutive = 1
					score = score + 1
				end

				-- Bonus for matching at start of words
				if i == 1 or text:sub(i - 1, i - 1) == " " or text:sub(i - 1, i - 1) == "/" then score = score + 3 end

				last_match_idx = i
				j = j + 1

				if j > pattern_len then
					-- Bonus for earlier matches
					score = score + (1 / i)
					-- Penalty for unmatched characters
					score = score - ((text_len - i) * 0.1)
					return true, score
				end
			end
		end

		return false, 0
	end

	local function get_max_text_length(items)
		local max_len = 0
		for _, item in ipairs(items) do
			-- Account for icon length if present
			local icon_len = item.icon and vim.fn.strdisplaywidth(item.icon) + 1 or 0
			local text_len = vim.fn.strdisplaywidth(item.text)
			max_len = math.max(max_len, icon_len + text_len)
		end
		return max_len
	end

	local function update_results(filter_text)
		matched_items = {}

		vim.bo[results_buf].modifiable = true

		for _, item in ipairs(all_items) do
			local matches, score = fuzzy_match_and_score(item.text, filter_text)
			if matches then
				table.insert(matched_items, {
					text = item.text,
					score = score,
					icon = item.icon,
					file = item.file,
					virtual_text = item.virtual_text,
				})
			end
		end

		-- Sort by score
		table.sort(matched_items, function(a, b) return a.score > b.score end)

		-- Calculate padding for alignment
		local max_length = get_max_text_length(matched_items)

		-- Clear existing virtual text
		vim.api.nvim_buf_clear_namespace(results_buf, -1, 0, -1)

		-- Update buffer with formatted lines and virtual text
		local lines = {}
		for _, item in ipairs(matched_items) do
			local icon_part = item.icon and (item.icon .. " ") or ""
			local line = icon_part .. item.text
			table.insert(lines, line)
		end
		vim.api.nvim_buf_set_lines(results_buf, 0, -1, false, lines)

		for i, item in ipairs(matched_items) do
			-- Add virtual text if present
			if item.virtual_text then
				local line = lines[i]
				local padding = max_length - vim.fn.strdisplaywidth(line)
				local virt_text = { { string.rep(" ", padding) .. item.virtual_text, "Comment" } }
				vim.api.nvim_buf_set_extmark(results_buf, namespace, i - 1, 0, {
					virt_text = virt_text,
					virt_text_pos = "right_align",
				})
			end
		end

		vim.bo[results_buf].modifiable = false

		local current_line = vim.fn.line(".", results_win)
		if preview_win and vim.api.nvim_win_is_valid(preview_win) then show_preview(matched_items[current_line]) end
	end

	-- Set up input buffer autocmd for filtering
	vim.api.nvim_create_autocmd("TextChanged", {
		buffer = input_buf,
		callback = function()
			local filter_text = vim.api.nvim_buf_get_lines(input_buf, 0, 1, false)[1] or ""
			update_results(filter_text)
		end,
	})

	vim.api.nvim_create_autocmd("TextChangedI", {
		buffer = input_buf,
		callback = function()
			local filter_text = vim.api.nvim_buf_get_lines(input_buf, 0, 1, false)[1] or ""
			update_results(filter_text)
		end,
	})

	vim.keymap.set("i", "<Down>", function()
		local current_line = vim.fn.line(".", results_win)
		local last_line = vim.api.nvim_buf_line_count(results_buf)
		if current_line < last_line then
			vim.api.nvim_win_set_cursor(results_win, { current_line + 1, 0 })
			if preview_win and vim.api.nvim_win_is_valid(preview_win) then show_preview(matched_items[current_line + 1]) end
		end
	end, { buffer = input_buf, noremap = true, silent = true })

	vim.keymap.set("i", "<Up>", function()
		local current_line = vim.fn.line(".", results_win)
		if current_line > 1 then
			vim.api.nvim_win_set_cursor(results_win, { current_line - 1, 0 })
			if preview_win and vim.api.nvim_win_is_valid(preview_win) then show_preview(matched_items[current_line - 1]) end
		end
	end, { buffer = input_buf, noremap = true, silent = true })

	vim.keymap.set({ "i", "n" }, "<TAB>", function()
		local current_line = vim.fn.line(".", results_win)
		local item = matched_items[current_line]
		if preview_win and vim.api.nvim_win_is_valid(preview_win) then
			close_preview()
		else
			show_preview(item)
		end
	end, { buffer = input_buf, noremap = true, silent = true })

	vim.keymap.set("i", "<CR>", function()
		local current_line = vim.fn.line(".")
		local item = matched_items[current_line]
		if item and item.file then
			vim.api.nvim_set_current_win(results_win)
			local filename = vim.fn.fnameescape(item.file)
			vim.cmd("quit")
			vim.api.nvim_set_current_win(input_win)
			vim.cmd("quit")
			vim.api.nvim_set_current_win(original_win)
			vim.cmd("edit " .. filename)
			vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<esc>", true, false, true), "i", true)
		end
	end, { buffer = input_buf, noremap = true, silent = true })

	vim.keymap.set("i", "<Esc>", function()
		close_preview()
		vim.cmd("quit")
		vim.cmd("quit")
		vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<esc>", true, false, true), "i", true)
	end, { buffer = input_buf, noremap = true, silent = true })

	-- Start in insert mode in the input buffer
	vim.cmd("startinsert")

	return results_buf, input_buf, function(items)
		all_items = items
		update_results("")
	end
end

local function file_picker()
	local _, _, update_items = create_picker_window()
	vim.system({ "rg", "--files", "--no-follow", "--color=never" }, { text = true }, function(obj)
		local lines = {}
		for line in obj.stdout:gmatch("[^\n]*") do
			if line ~= "" then table.insert(lines, { text = line, icon = "󰈙", file = line, virtual_text = "Hello" }) end
		end
		vim.schedule(function() update_items(lines) end)
	end)
end

file_picker()
