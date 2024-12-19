vim.lsp.config.arduino_language_server = {
	cmd = {
		"arduino-language-server",
		"-cli-config",
		"~/.arduino15/arduino-cli.yaml",
		"-cli",
		"arduino-cli",
		"-clangd",
		"clangd",
		"-fqbn",
		"SparkFun:avr:promicro",
	},
	filetypes = { "ino", "arduino" },
}
