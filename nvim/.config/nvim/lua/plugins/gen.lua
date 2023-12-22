return {
	"David-Kunz/gen.nvim",
	enabled = false,
	opts = {
		display_mode = "split",
		model = "codellama:7b",
		init = false,
		command = "curl --silent --no-buffer -X POST http://192.168.1.11:11434/api/generate -d $body",
	},
}


