local M = {
  "luukvbaal/statuscol.nvim",
  config = function()
    require("statuscol").setup({setopt = true})
  end
}

return M
