-- 配置 Copilot 核心功能
require("copilot").setup({
	-- 全局开关
	enabled = true,
	-- 建议显示配置
	suggestion = {
		enabled = true,
		auto_trigger = true, -- 自动触发建议（输入时自动显示）
		debounce = 75, -- 输入防抖时间（毫秒）
		keymap = {
			accept = "<M-l>", -- Alt+l 接受建议
			accept_word = "<M-w>", -- Alt+w 接受当前单词
			accept_line = "<M-j>", -- Alt+j 接受当前行
			next = "<M-]>", -- Alt+] 下一个建议
			prev = "<M-[>", -- Alt+[ 上一个建议
			dismiss = "<C-]>", -- Ctrl+] 关闭建议
		},
	},
	-- 面板面板面板配置（可选）
	panel = {
		enabled = true,
		auto_refresh = false,
		keymap = {
			jump_prev = "[[",
			jump_next = "]]",
			accept = "<CR>",
			refresh = "gr",
			open = "<M-CR>", -- Alt+Enter 打开面板
		},
	},
	-- 文件类型过滤（默认所有文件都启用）
	filetypes = {
		yaml = false, -- 禁用 yaml 文件
		markdown = false, -- 禁用 markdown
		help = false,
		gitcommit = false,
		gitrebase = false,
		hgcommit = false,
		svn = false,
		cvs = false,
		["."] = false,
	},
})
