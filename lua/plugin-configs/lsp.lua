-- 导入 lsp-zero 模块，这是一个简化 Neovim LSP 配置的插件
local lsp = require("lsp-zero")

-- 使用 lsp-zero 的"minimal"预设，这会设置一些合理的默认配置
-- 这个预设包括了基本的自动补全、按键映射和 LSP 服务器管理功能
lsp.preset("minimal")

-- 设置 LSP 诊断信息在侧边栏显示的图标
-- 这些图标会出现在代码行号旁边，指示错误、警告等信息
lsp.set_sign_icons({
    error = "",  -- 错误图标
    warn = "",   -- 警告图标
    hint = "⚑",   -- 提示图标
    info = "",    -- 信息图标
})

-- 获取并扩展 LSP 客户端的能力配置
-- 这里特别添加了对代码折叠范围(foldingRange)的支持
local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities.textDocument.foldingRange = {
    dynamicRegistration = false,  -- 不需要动态注册此功能
    lineFoldingOnly = true,       -- 只支持基于行的折叠(而不是基于字符)
}

-- 尝试加载用户自定义配置
-- 使用 pcall 安全地尝试加载 "user.user_config" 模块
-- exist 变量表示是否成功加载，user_config 变量包含加载的配置(如果存在)
local exist, user_config = pcall(require, "user.user_config")

-- 设置保存文件时自动格式化的功能
lsp.format_on_save({
    format_opts = {
        async = true,      -- 使用同步格式化(确保格式化完成后再保存)
        timeout_ms = 10000, -- 设置格式化超时时间为10秒
    },
    servers = user_config.formatting_servers, -- 从用户配置获取需要格式化的服务器列表
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
            require("lspconfig")[server_name].setup(config)
        end,
    },
})
vim.diagnostic.config({
    virtual_text = true, -- 显示虚拟文本
    underline = true, -- 下划线标记
    update_in_insert = false, -- 不在插入模式更新
    severity_sort = true, -- 按严重程度排序
    float = {
        border = "rounded", -- 浮动窗口边框样式
        source = "always", -- 总是显示诊断来源
        header = "", -- 头部标题
        prefix = "", -- 前缀
    },
})
-- 完成 lsp-zero 的设置并初始化所有配置
-- 这会应用所有之前的配置并启动 LSP 客户端
lsp.setup()