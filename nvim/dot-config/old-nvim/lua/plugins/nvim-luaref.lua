-- Add a vim :help reference for lua
return {
	"milisims/nvim-luaref",
	enabled = require("config.util").is_enabled("milisims/nvim-luaref"),
	ft = { "lua" },
}
