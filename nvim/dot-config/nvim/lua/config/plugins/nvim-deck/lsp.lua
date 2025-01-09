local deck = require("deck")

local function create_lsp_references_source()
	return {
		name = "lsp_references",
		dynamic = false,
		execute = function(ctx)
			local bufnr = vim.api.nvim_get_current_buf()
			local params = vim.lsp.util.make_position_params()
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
					if lines and #lines >= (range.start.line + 1) then
						line_text = " " .. vim.trim(lines[range.start.line + 1])
					end

					ctx.item({
						display_text = string.format(
							"%s:%d:%d",
							vim.fn.fnamemodify(filename, ":~:."),
							range.start.line + 1,
							range.start.character + 1
						),
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
		actions = {
			require("deck").alias_action("default", "open"),
		},
		decorators = {
			{
				name = "lsp_reference_location",
				decorate = function(_, item, row)
					local filename = vim.fn.fnamemodify(item.data.filename, ":t")
					local dirname = vim.fn.fnamemodify(item.data.filename, ":h")
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
			},
		},
	}
end

-- Function to start the deck
local function show_references()
	deck.start(create_lsp_references_source(), {
		name = "LSP References",
	})
end

-- Set up a keymap
vim.keymap.set("n", "<leader>gr", show_references, { noremap = true, silent = true })
