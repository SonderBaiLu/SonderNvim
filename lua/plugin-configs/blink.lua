local blink = require("blink")
blink.setup({
	opts = {
		completion = {
			documentation = {
				auto_show = true,
			},
		},
		keymap = {
			preset = "super-tab",
		},
		source = {
			default = { "path", "snippts", "buffer", "lsp" },
		},
	},
})
