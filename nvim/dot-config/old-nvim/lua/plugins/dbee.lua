return {
  "kndndrj/nvim-dbee",
  dependencies = {
    "MunifTanjim/nui.nvim",
  },
	enabled = require("config.util").is_enabled("kndndrj/nvim-dbee"),
  build = function()
    require("dbee").install()
  end,
  config = function()
    require("dbee").setup {
			sources = {
				require("dbee.sources").EnvSource:new("DBEE_CONNECTIONS")
			}
		}
  end,
}
