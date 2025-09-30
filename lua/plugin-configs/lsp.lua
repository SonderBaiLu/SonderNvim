local lspconfig = require("lspconfig")
local mason_lspconfig = require("mason-lspconfig")
local utils = require("core.utils.utils")

vim.diagnostic.config({
	-- 虚拟文本（行尾显示的诊断信息）
	virtual_text = {
		enabled = true, -- 启用虚拟文本
		prefix = "■ ", -- 虚拟文本前缀符号（可自定义为 "●" "▸" 等）
		spacing = 4, -- 虚拟文本与代码的间距
		-- 仅显示错误级别及以上的虚拟文本（可选）
		severity_limit = "Error", -- "Error" "Warn" "Info" "Hint"，低于此级别的不显示
	},
	-- 侧边栏图标（行号旁的诊断符号）
	signs = true, -- 启用侧边栏图标

	-- 代码下划线（标记错误位置）
	underline = {
		enabled = true, -- 启用下划线
		-- 仅为错误和警告添加下划线（可选）
		severity = { min = vim.diagnostic.severity.WARN },
	},

	-- 4. 插入模式下是否更新诊断
	update_in_insert = false, -- 插入模式不更新（提升性能，避免频繁刷新）

	-- 5. 诊断信息排序（按严重程度从高到低）
	severity_sort = false, -- 启用后错误会显示在警告上方

	-- 6. 浮动窗口配置（鼠标悬停时显示的详细诊断）
	float = {
		enabled = true, -- 启用浮动窗口
		border = "rounded", -- 窗口边框样式："rounded" "single" "double" "solid"
		source = "always", -- 显示诊断来源（如哪个LSP服务器）
		header = " 诊断信息", -- 窗口头部文本
		prefix = function(diagnostic, i, total)
			-- 为多个诊断项添加序号前缀
			return "  " .. i .. "/" .. total .. " "
		end,
		-- 浮动窗口的样式设置
		style = "minimal", -- 最小化样式（无多余边框）
		width = 80, -- 最大宽度
		-- 显示诊断的代码上下文（行数）
		scope = "line", -- "line" 仅当前行，"cursor" 光标范围内，nil 整个缓冲区
	},
	-- 7. 虚拟行（将诊断信息显示为额外行，替代虚拟文本）
	virtual_lines = false, -- 禁用（启用后会在代码间插入诊断行，适合需要详细信息的场景）
})

-- 设置诊断图标（替代 lsp.set_sign_icons）
vim.fn.sign_define("DiagnosticSignError", { text = "", texthl = "DiagnosticSignError" })
vim.fn.sign_define("DiagnosticSignWarn", { text = "", texthl = "DiagnosticSignWarn" })
vim.fn.sign_define("DiagnosticSignHint", { text = "⚑", texthl = "DiagnosticSignHint" })
vim.fn.sign_define("DiagnosticSignInfo", { text = "", texthl = "DiagnosticSignInfo" })
-- 2. 配置 LSP 客户端能力（支持折叠等功能，替代 lsp-zero 的 capabilities）
local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities.textDocument.foldingRange = {
	dynamicRegistration = false,
	lineFoldingOnly = true,
}
-- 如果使用 nvim-cmp，需结合 cmp-nvim-lsp 增强能力
local ok_cmp, cmp_nvim_lsp = pcall(require, "cmp_nvim_lsp")
if ok_cmp then
	capabilities = cmp_nvim_lsp.default_capabilities(capabilities)
end

-- 尝试加载用户自定义配置
-- 使用 pcall 安全地尝试加载 "user.user_config" 模块
-- exist 变量表示是否成功加载，user_config 变量包含加载的配置(如果存在)
local exist, user_config = pcall(require, "user.user_config")

-- 设置保存文件时自动格式化的功能
-- 5. 配置保存时自动格式化（替代 lsp.format_on_save）
vim.api.nvim_create_autocmd("BufWritePre", {
	pattern = "*",
	callback = function()
		-- 仅对用户配置中指定的文件类型格式化
		local ft = vim.bo.filetype
		local formatting_servers = exist and user_config.formatting_servers or {}
		local enable_format = false

		-- 检查当前文件类型是否在用户配置的格式化列表中
		for _, server_fts in pairs(formatting_servers) do
			if vim.tbl_contains(server_fts, ft) then
				enable_format = true
				break
			end
		end

		if enable_format then
			vim.lsp.buf.format({
				async = false,
				timeout_ms = 10000,
			})
		end
	end,
})

-- 配置 mason-lspconfig 插件，它负责安装和管理 LSP 服务器
require("mason-lspconfig").setup({
	handlers = {
		-- 这是一个处理函数，会为每个已安装的 LSP 服务器调用
		function(server_name)
			-- 获取用户配置中的 LSP 服务器特定配置
			-- 如果用户配置存在且是表(table)类型，则尝试获取对应服务器的配置
			-- 否则使用空表作为默认配置
			local configs = exist and type(user_config) == "table" and user_config.lsp_configs or {}
			local config = type(configs) == "table" and configs[server_name] or {}

			-- 设置特定 LSP 服务器的配置
			-- 将用户自定义配置与 lsp-zero 的默认配置合并
			require("lspconfig")[server_name].setup(config) -- lspconfig 他只提供lsp的默认配置
		end,
	},
})
