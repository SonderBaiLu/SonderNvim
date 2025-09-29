-- 尝试加载用户配置模块 "user.user_config"，使用pcall避免加载失败时抛出错误
-- pcall会返回两个值：第一个是布尔值表示是否成功，第二个是加载的模块内容（成功时）或错误信息（失败时）
local exist, user_config = pcall(require, "user.user_config")
-- 构建需要确保安装的工具列表（用于null-ls）
-- 逻辑说明：
-- 1. 先判断用户配置是否存在（exist为true）
-- 2. 再判断加载的用户配置是否为table类型（避免非table类型导致的错误）
-- 3. 接着判断配置中是否有mason_ensure_installed字段
-- 4. 最后判断mason_ensure_installed中是否有null_ls字段
-- 5. 如果以上条件都满足，就使用用户配置中的null_ls列表；否则使用空表
local sources = exist
		and type(user_config) == "table"
		and user_config.mason_ensure_installed
		and user_config.mason_ensure_installed.null_ls
	or {}
-- 配置mason-null-ls插件
-- mason-null-ls是用于管理null-ls所需工具（如linter、formatter等）的插件
-- 这里通过setup方法设置需要确保安装的工具列表为上面构建的sources
require("mason-null-ls").setup({
	ensure_installed = sources,
})
-- LSP（语言服务器协议）是 
-- Neovim 实现代码补全、跳转、诊断等功能的核心，但很多实用的代码工具
-- （如 prettier 格式化工具、eslint 代码检查器）
-- 并不遵循 LSP 协议，无法直接被 LSP 客户端调用。
-- null-ls 相当于一个 “翻译官” 或 “中间层”：它将这些非 LSP 工具的功能
-- （如格式化、 lint 检查、代码动作等）包装成 LSP 兼容的接口，让 Neovim 
-- 可以通过统一的 LSP 命令（如 vim.lsp.buf.format() 格式化代码、vim.diagnostic 查看错误）
-- 来使用它们。