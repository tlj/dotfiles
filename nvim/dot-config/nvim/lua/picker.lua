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

	local function update_results(filter_text)
		-- Enable modifiable for results buffer
		vim.bo[results_buf].modifiable = true

		-- Filter items
		local filtered_items = {}
		for _, item in ipairs(all_items) do
			if item:lower():find(filter_text:lower()) then table.insert(filtered_items, item) end
		end

		-- Update results buffer
		vim.api.nvim_buf_set_lines(results_buf, 0, -1, false, filtered_items)
		vim.bo[results_buf].modifiable = false
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
		if current_line < last_line then vim.api.nvim_win_set_cursor(results_win, { current_line + 1, 0 }) end
	end, { buffer = input_buf, noremap = true, silent = true })

	vim.keymap.set("i", "<Up>", function()
		local current_line = vim.fn.line(".", results_win)
		if current_line > 1 then vim.api.nvim_win_set_cursor(results_win, { current_line - 1, 0 }) end
	end, { buffer = input_buf, noremap = true, silent = true })

	vim.keymap.set("i", "<CR>", function()
		vim.api.nvim_set_current_win(results_win)
		local filename = vim.fn.fnameescape(vim.api.nvim_get_current_line())
		vim.cmd("quit")
		vim.api.nvim_set_current_win(input_win)
		vim.cmd("quit")
		vim.api.nvim_set_current_win(original_win)
		vim.cmd("edit " .. filename)
		vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<esc>", true, false, true), "i", true)
	end, { buffer = input_buf, noremap = true, silent = true })

	vim.keymap.set("i", "<Esc>", function()
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
			if line ~= "" then table.insert(lines, line) end
		end
		vim.schedule(function() update_items(lines) end)
	end)
end

file_picker()
