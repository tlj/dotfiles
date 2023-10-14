local M = {
  'rmagatti/auto-session',
  enabled = false,
  config = function()
    require("auto-session").setup {
      log_level = "error",
      auto_session_suppress_dirs = { "~/", "~/src", "~/Downloads", "/", "~/Documents"},
      auto_session_use_git_branch = true,
      auto_save_enabled = true,
    }
  end,
}

return M
