-- 用户配置文件，用于自定义Neovim配置

local M = {}

-- 配置null-ls源（代码格式化和操作）
M.setup_sources = function(b)
	return {
		--    b.formatting.autopep8,  -- Python代码格式化
		b.code_actions.gitsigns, -- Git相关代码操作
	}
end

-- 配置Mason自动安装的包
M.mason_ensure_installed = {
	null_ls = { -- null-ls相关工具
		"stylua", -- Lua代码格式化
		"jq", -- JSON处理工具
		"lua_ls", -- Lua 语言服务器
		"rust_analyzer", -- Rust 语言服务器
		"pyright", -- Python 语言服务器
		"eslint-lsp", -- ESLint 用于代码检查
		"prettier", -- 格式化工具（支持 Vue/TS）
		"vue-language-server", -- Vue 语法支持补充
		"typescript-language-server", -- TypeScript 语言服务器（修正名称）
		"vtsls",
		"vue_ls",
		"typescript-tools",
	},
	dap = { -- 调试适配器协议
		--    "python", -- Python调试器
		--    "delve",  -- Go调试器
	},
}

-- 配置各语言使用的格式化服务器
M.formatting_servers = {
	["rust_analyzer"] = { "rust" }, -- Rust使用rust_analyzer
	["lua_ls"] = { "lua" }, -- Lua使用lua_ls
	["null_ls"] = { -- 以下语言使用null_ls
		"javascript",
		"javascriptreact",
		"typescriptreact",
		"typescript",
	},
}

-- 覆盖或添加默认选项
M.options = {
	opt = {
		confirm = true, -- 在执行潜在危险操作前要求确认
	},
}

-- 启用/禁用自动命令功能
M.autocommands = {
	alpha_folding = true, -- Alpha启动界面折叠
	treesitter_folds = true, -- Treesitter折叠
	trailing_whitespace = true, -- 尾随空格高亮
	remember_file_state = true, -- 记住文件状态
	session_saved_notification = true, -- 会话保存通知
	css_colorizer = true, -- CSS颜色高亮
	-- cmp = true, -- 代码补全
	blink = true,
}

-- 启用/禁用插件
M.enable_plugins = {
	aerial = true, -- 代码大纲窗口
	alpha = true, -- 自定义启动屏幕
	autotag = true, -- 自动关闭和重命名HTML/XML标签
	bufferline = true, -- 缓冲区标签页
	context = true, -- 显示当前函数上下文
	copilot = true, -- AI代码补全
	dressing = true, -- 改进默认UI
	gitsigns = true, -- Git状态标记
	hop = true, -- 快速跳转导航
	img_paste = true, -- 从剪贴板粘贴图片(修正了名称)
	indent_blankline = true, -- 缩进引导线
	mason = true, -- LSP 包管理工具
	blink = true, -- LSP代码补全引擎
	lualine = true, -- 状态栏
	neodev = true, -- Neovim开发配置
	neoscroll = true, -- 平滑滚动
	neotree = true, -- 文件树
	session_manager = true, -- 会话管理
	noice = true, -- 高级UI组件
	null_ls = true, -- LSP诊断和代码操作
	autopairs = true, -- 自动括号配对
	colorizer = true, -- 颜色高亮
	dap = true, -- 调试适配器协议 n
	notify = true, -- 通知管理器
	surround = true, -- 环绕选择
	treesitter = true, -- 语法高亮和解析
	ufo = true, -- 代码折叠
	catppuccin = true, -- 主题
	project = true, -- 项目管理
	rainbow = true, -- 彩虹括号
	scope = true, -- Treesitter作用域可视化
	telescope = true, -- 模糊查找器
	toggleterm = true, -- 终端管理
	trouble = true, -- 诊断和参考查看
	twilight = true, -- 暗淡非活动代码
	whichkey = true, -- 键位提示
	windline = true, -- 状态栏动画
	zen = true, -- 专注模式
	tsscriptTools = true, -- js
}

-- 额外插件配置
M.plugins = {
	{
		"nvim-neotest/neotest", -- 测试框架
		dependencies = {
			"nvim-lua/plenary.nvim",
			"nvim-treesitter/nvim-treesitter",
			"antoinemadec/FixCursorHold.nvim",
		},
	},
}

-- LSP服务器配置
M.lsp_config = {}
-- 用户自定义配置
M.user_conf = function()
	-- 启动时显示欢迎通知
	vim.cmd([[autocmd VimEnter * lua vim.notify("欢迎使用SonderNvim!", "info", {title = "Neovim"})]])

	-- 可以在此处添加其他自定义配置
	-- require("user.autocmds")  -- 自定义自动命令
	vim.cmd.colorscheme("catppuccin")
end

return M
