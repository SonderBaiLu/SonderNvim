local blink = require("blink.cmp")
local luasnip = require("luasnip") -- 代码片段引擎
require("luasnip.loaders.from_vscode").lazy_load() -- 加载VSCode风格片段
-- 工具函数（检查光标前是否有单词）
local has_words_before = require("core.utils.utils").has_words_before
blink.setup({
	opts = {
		completion = {
			min_length = 1, -- 1个单词就启动补全
			menu = {
				enabled = true,
				auto_show = true, -- 自动显示补全菜单
			},
			documentation = {
				auto_show = true,
			},
		},
		keymap = {
			preset = "super-tab",
		},

		source = {
			default = {
				"copilot", -- GitHub Copilot（需确保插件已安装）
				"lsp", -- LSP 补全（对应 nvim_lsp）
				"nvim_lua", -- Neovim Lua API 补全
				"snippets", -- 代码片段（对应 luasnip）
				{ name = "path", option = { trailing_slash = true } }, -- 路径补全
				"buffer", -- 缓冲区内容补全
			},
		},
		ui = {
			menu = {
				border = "rounded", -- 补全菜单边框（对应 bordered）
			},
			documentation = {
				border = "rounded", -- 文档窗口边框
			},
		},
	},
})
require("nvim-autopairs").setup({
	check_ts = true, -- 配合 treesitter 自动配对
	ts_config = {
		lua = { "string", "source" },
		javascript = { "string", "template_string" },
	},
})
