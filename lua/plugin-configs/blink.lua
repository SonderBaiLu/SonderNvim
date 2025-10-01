local blink = require("blink.cmp")

blink.setup({
	-- 补全行为设置
	completion = {
		keyword = {
			range = "prefix", -- 补全关键词的范围
		},
		trigger = {
			-- 输入关键字（如字母、_、.）时自动触发补全
			show_on_keyword = true,
			-- 特定字符触发补全（如输入“.”后立即触发对象属性补全）
			show_on_trigger_characters = { ".", ":", "@", "#" },
			-- 触发字符输入时是否自动插入第一个补全项（关闭，避免误触）
			insert_on_trigger_character = false,
		},
		documentation = {
			auto_show = true, -- 自动显示补全项的文档:cite[8]
		},
	},
	-- 按键映射配置
	keymap = {
		preset = "default", -- 使用预设的默认键位:cite[8]
		-- 进阶键位配置示例，可提供更流畅的导航
		["<C-j>"] = {
			"select_next", -- 选择下一个补全项
			"snippet_forward", -- 在代码片段中跳转到下一个占位符:cite[2]
			"fallback", -- 最后回退到默认Tab行为:cite[2]
		},
		["<C-k>"] = {
			"select_prev", -- 选择上一个补全项
			"snippet_backward", -- 在代码片段中跳转到上一个占位符:cite[2]
			"fallback",
		},
	},

	-- 补全源配置
	sources = {
		providers = {
			lsp = {
				name = "LSP",
				module = "blink.cmp.sources.lsp",
				score_offset = 1, -- 调整此源的排序权重:cite[8]
			},
			snippets = {
				name = "Snippets",
				module = "blink.cmp.sources.snippets",
				-- 名称可省略，插件会自动生成（如 `snippets` 会生成 `Snippets`）:cite[4]
			},
			buffer = {
				name = "Buffer",
				module = "blink.cmp.sources.buffer",
			},
			path = {
				name = "Path",
				module = "blink.cmp.sources.path",
			},
		},
	},
})
