local M = {
  'rmagatti/auto-session',
  config = function()
    require("auto-session").setup {
      log_level = "error",
      auto_session_suppress_dirs = { "~/", "~/src", "~/Downloads", "/"},
    }
  end
}

return M
