local M = {
  "luukvbaal/statuscol.nvim",
  config = function()
    require("statuscol").setup({
      setopt = true,
      foldfunc = "builtin",
    })
  end,
  enabled = true,
}

return M
