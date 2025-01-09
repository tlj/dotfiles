local deck = require("deck")

local decorator = {
	name = "lsp_decorator",
	decorate = function(_, item, row)
		local relfilename = vim.fn.fnamemodify(item.data.filename, ":~:.")
		local filename = vim.fn.fnamemodify(item.data.filename, ":t")
		local dirname = vim.fn.fnamemodify(relfilename, ":r")
		return {
			{
				row = row,
				virt_text = {
					{ dirname .. "/", "Comment" },
					{ filename, "Special" },
					{ ":" .. item.data.lnum .. ":" .. item.data.col, "Number" },
					{ item.data.text, "Normal" },
				},
				virt_text_pos = "overlay",
			},
		}
	end,
}

local function create_lsp_references_source()
	return {
		name = "lsp_references",
		dynamic = false,
		execute = function(ctx)
			local bufnr = vim.api.nvim_get_current_buf()
			local params = vim.lsp.util.make_position_params(0, vim.lsp.util._get_offset_encoding(bufnr))
			params.context = { includeDeclaration = true }

			local clients = vim.lsp.get_clients({ bufnr = 0, method = "textDocument/references" })

			if #clients == 0 then
				vim.notify("No LSP clients support textDocument/references")
				ctx.done()
				return
			end

			clients[1].request("textDocument/references", params, function(_, result)
				if not result then
					ctx.done()
					return
				end

				for _, location in ipairs(result) do
					local filename = vim.uri_to_fname(location.uri)
					local range = location.range

					-- Get the line content if the file exists
					local line_text = ""
					local lines = vim.fn.readfile(filename)
					if lines and #lines >= (range.start.line + 1) then line_text = " " .. vim.trim(lines[range.start.line + 1]) end

					ctx.item({
						display_text = string.format("%s:%d:%d", vim.fn.fnamemodify(filename, ":~:."), range.start.line + 1, range.start.character + 1),
						data = {
							filename = filename,
							lnum = range.start.line + 1,
							col = range.start.character + 1,
							text = line_text,
						},
					})
				end
				ctx.done()
			end, bufnr)
		end,
		actions = { require("deck").alias_action("default", "open") },
		decorators = { decorator },
	}
end

local function create_lsp_source(method, name)
	return {
		name = "lsp_" .. name,
		dynamic = false,
		execute = function(ctx)
			local bufnr = vim.api.nvim_get_current_buf()
			local params = vim.lsp.util.make_position_params(0, vim.lsp.util._get_offset_encoding(bufnr))

			vim.lsp.buf_request_all(0, method, params, function(results)
				if not results or vim.tbl_isempty(results) then return ctx.done() end

				for _, result in pairs(results) do
					if result.result then
						local locations = vim.tbl_islist(result.result) and result.result or { result.result }

						for _, location in ipairs(locations) do
							local uri = location.uri or location.targetUri
							local range = location.range or location.targetRange
							local filename = vim.uri_to_fname(uri)

							-- Get the line content if the file exists
							local line_text = ""
							local lines = vim.fn.readfile(filename)
							if lines and #lines >= (range.start.line + 1) then line_text = " " .. vim.trim(lines[range.start.line + 1]) end

							ctx.item({
								display_text = string.format("%s:%d", vim.fn.fnamemodify(filename, ":~:."), range.start.line + 1),
								data = {
									filename = filename,
									lnum = range.start.line + 1,
									col = range.start.character + 1,
									text = line_text,
								},
							})
						end
					end
				end

				ctx.done()
			end)
		end,
		actions = {
			require("deck").alias_action("default", "open"),
		},
		decorators = { decorator },
	}
end

-- Create sources for different LSP features
local sources = {
	definitions = create_lsp_source("textDocument/definition", "definitions"),
	implementations = create_lsp_source("textDocument/implementation", "implementations"),
	type_definitions = create_lsp_source("textDocument/typeDefinition", "type_definitions"),
}

-- Function to start the deck
local function show_references() deck.start(create_lsp_references_source(), { name = "LSP References" }) end

-- Create commands for each source
local function show_lsp_source(source, display_name)
	return function() deck.start(source, { name = "LSP " .. display_name }) end
end

local lspgroup = vim.api.nvim_create_augroup("deck_lsp", { clear = true })
vim.api.nvim_create_autocmd("LspAttach", {
	group = lspgroup,
	callback = function(args)
		-- Get the detaching client
		local bufnr = args.buf
		vim.keymap.set("n", "gd", show_lsp_source(sources.definitions, "Definitions"), { desc = "Show LSP definitions" })
		vim.keymap.set("n", "gi", show_lsp_source(sources.implementations, "Implementations"), { desc = "Show LSP implementations" })
		vim.keymap.set("n", "gt", show_lsp_source(sources.type_definitions, "Type Definitions"), { desc = "Show LSP type definitions" })
		vim.keymap.set("n", "gr", show_references, { noremap = true, silent = true })

		-- Set up keybindings
		vim.keymap.set("n", "<leader>gd", show_lsp_source(sources.definitions, "Definitions"), { desc = "Show LSP definitions" })
		vim.keymap.set("n", "<leader>gi", show_lsp_source(sources.implementations, "Implementations"), { desc = "Show LSP implementations" })
		vim.keymap.set("n", "<leader>gt", show_lsp_source(sources.type_definitions, "Type Definitions"), { desc = "Show LSP type definitions" })
		vim.keymap.set("n", "<leader>gr", show_references, { noremap = true, silent = true })
	end,
})
