local M = {
  "luukvbaal/statuscol.nvim",
  config = function()
    require("statuscol").setup({
      setopt = true,
      foldfunc = "builtin",
    })
  end
}

return M
