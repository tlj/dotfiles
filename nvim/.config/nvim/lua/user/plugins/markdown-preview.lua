local M = {
  "iamcco/markdown-preview.nvim",
  ft = { "markdown" },
  build = ":call mkdp#util#install()" 
}

return M
