-- Automatically install graft with graft-git if it doesn't already exist
local function graft(e)
	local c = vim.fn.shellescape(vim.fn.stdpath("config"))
	e = e or { "" }
	table.insert(e, "")
	for i, x in ipairs(e) do
		if
			i == 1
			and not vim.fn.system("git -C " .. c .. " rev-parse --is-inside-work-tree"):match("^true")
		then
			vim.fn.system("git -C " .. c .. " init")
			if vim.v.shell_error ~= 0 then error("Git init failed") end
		end
		local n = x ~= "" and "-" .. x or ""
		if not pcall(require, "graft" .. n) then
			vim.fn.system(
				string.format(
					"git -C %s submodule add -f https://github.com/tlj/graft%s.nvim.git pack/graft/start/graft%s.nvim",
					c,
					n,
					n
				)
			)
			if vim.v.shell_error ~= 0 then error("Failed: graft" .. n .. ".nvim") end
			package.loaded["graft" .. n] = nil
		end
	end
	vim.cmd("packloadall!")
end

return {
	graft = function(opts) graft(opts) end,
}
