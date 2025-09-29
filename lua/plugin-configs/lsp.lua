local lspconfig = require("lspconfig")
local mason_lspconfig = require("mason-lspconfig")
local utils = require("core.utils.utils")
-- 导入 lsp-zero 模块，这是一个简化 Neovim LSP 配置的插件
-- local lsp = require("lsp-zero")

-- 使用 lsp-zero 的"minimal"预设，这会设置一些合理的默认配置
-- 这个预设包括了基本的自动补全、按键映射和 LSP 服务器管理功能
-- lsp.preset("minimal")

-- 设置 LSP 诊断信息在侧边栏显示的图标
-- 这些图标会出现在代码行号旁边，指示错误、警告等信息
-- lsp.set_sign_icons({
--     error = "",  -- 错误图标
--     warn = "",   -- 警告图标
--     hint = "⚑",   -- 提示图标
--     info = "",    -- 信息图标
-- })
-- 1. 配置 LSP 诊断图标和行为（替代 lsp.set_sign_icons 和 vim.diagnostic.config）
vim.diagnostic.config({
  virtual_text = true,
  underline = true,
  update_in_insert = false,
  severity_sort = true,
  float = {
    border = "rounded",
    source = "always",
  },
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