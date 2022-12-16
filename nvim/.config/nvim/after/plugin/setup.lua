
-- LSP init
local lsp = require('lsp-zero')
lsp.preset('recommended')
lsp.setup()

require'toggle_lsp_diagnostics'.init()

-- DAP Debugger
require('dap-go').setup()
require('dapui').setup()
require('telescope').load_extension('dap')

local dap, dapui =require("dap"),require("dapui")
dap.listeners.after.event_initialized["dapui_config"]=function()
  dapui.open()
end
dap.listeners.before.event_terminated["dapui_config"]=function()
  dapui.close()
end
dap.listeners.before.event_exited["dapui_config"]=function()
  dapui.close()
end

vim.fn.sign_define('DapBreakpoint',{ text ='🟥', texthl ='', linehl ='', numhl =''})
vim.fn.sign_define('DapStopped',{ text ='▶️', texthl ='', linehl ='', numhl =''})


-- Feline bar
require('feline').setup()
require('feline').winbar.setup()

-- Other plugins
require('nvim-tree').setup()

-- TreeSitter
require'nvim-treesitter.configs'.setup {
  ensure_installed = { "go", "lua" },     -- one of "all", "language", or a list of languages
  highlight = {
    enable = true,              -- false will disable the whole extension
    disable = { "lua" },  -- list of language that will be disabled
  },
}
