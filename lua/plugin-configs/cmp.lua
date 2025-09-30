-- 导入必要的模块
local cmp = require("cmp") -- nvim-cmp 自动补全插件
-- local cmp_action = require("lsp-zero").cmp_action() -- lsp-zero 提供的补全动作
local luasnip = require("luasnip") -- 代码片段引擎
-- 从 VSCode 格式加载代码片段
require("luasnip.loaders.from_vscode").lazy_load()
-- 自动配对插件与补全的集成
local cmp_autopairs = require("nvim-autopairs.completion.cmp")

-- 设置确认补全时自动配对的回调
cmp.event:on("confirm_done", cmp_autopairs.on_confirm_done())
-- 导入自定义工具函数，检查光标前是否有单词
local has_words_before = require("core.utils.utils").has_words_before

-- 配置 nvim-cmp
cmp.setup({
	-- 启用/禁用补全的函数
	enabled = function()
		-- 在注释中禁用补全
		local context = require("cmp.config.context")
		-- 如果当前是命令模式，则启用补全
		if vim.api.nvim_get_mode().mode == "c" then
			return true
		else
			-- 不在 Treesitter 注释捕获组或语法注释组中时启用补全
			return not context.in_treesitter_capture("comment") and not context.in_syntax_group("Comment")
		end
	end,
	-- 不预选任何项目
	preselect = "none",
	-- 补全相关设置
	completion = {
		keyword_length = 1, -- 触发补全所需的最小关键字长度
		completeopt = "menu,menuone,noinsert,noselect", -- 补全选项
	},
	-- 代码片段设置
	snippet = {
		-- 展开代码片段的函数
		expand = function(args)
			luasnip.lsp_expand(args.body) -- 使用 luasnip 展开代码片段
		end,
	},
	-- 补全窗口设置
	window = {
		completion = cmp.config.window.bordered(), -- 补全窗口带边框
		documentation = cmp.config.window.bordered(), -- 文档窗口带边框
	},
	-- 格式化设置
	formatting = {
		fields = { "abbr", "kind", "menu" }, -- 显示的字段
		-- 使用 lspkind 格式化补全项目
		format = require("lspkind").cmp_format({
			maxwidth = 50, -- 最大宽度
			ellipsis_char = "...", -- 超出宽度时显示的省略符
			mode = "symbol_text", -- 显示模式：符号+文本
			symbol_map = { Copilot = "" }, -- Copilot 的图标映射
		}),
	},
	-- 键盘映射
	mapping = {
		-- 回车键确认补全，但不选择项目
		["<CR>"] = cmp.mapping.confirm({ select = false }),
		-- Tab 键处理
		["<C-j>"] = cmp.mapping(function(fallback)
			if cmp.visible() then
				-- 如果补全菜单可见，选择下一个项目
				cmp.select_next_item({ behavior = cmp.SelectBehavior.Select })
			elseif luasnip.expand_or_jumpable() then
				-- 如果代码片段可展开或跳转，执行相应操作
				luasnip.expand_or_jump()
			elseif has_words_before() then
				-- 如果光标前有单词，触发补全
				cmp.complete()
			else
				-- 否则执行默认的 Tab 行为
				fallback()
			end
		end, { "i", "s" }), -- 在插入模式和选择模式下生效
		-- Shift+Tab 键处理
		["<C-k>"] = cmp.mapping(function(fallback)
			if cmp.visible() then
				-- 如果补全菜单可见，选择上一个项目
				cmp.select_prev_item({ behavior = cmp.SelectBehavior.Select })
			elseif luasnip.jumpable(-1) then
				-- 如果代码片段可向前跳转，执行跳转
				luasnip.jump(-1)
			else
				-- 否则执行默认的 Shift+Tab 行为
				fallback()
			end
		end, { "i", "s" }), -- 在插入模式和选择模式下生效
		-- 向上滚动文档
		["<C-l>"] = cmp.mapping.scroll_docs(-4),
		-- 向下滚动文档
		["<C-h>"] = cmp.mapping.scroll_docs(4),
		-- 中止补全
		["<C-c>"] = cmp.mapping.abort(),
		-- 手动触发补全
		["<C-n>"] = { i = cmp.mapping.complete() },
	},
	-- 补全源配置
	sources = {
		{ name = "copilot" }, -- GitHub Copilot
		{ name = "nvim_lsp" }, -- LSP 补全
		{ name = "nvim_lua" }, -- Neovim Lua API 补全
		{ name = "luasnip" }, -- 代码片段补全
		{ name = "path", option = { trailing_slash = true } }, -- 路径补全，保留尾部斜杠
	},
})
