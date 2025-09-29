-- 检查notify插件是否可用，如果可用则ok为true，否则为false
-- pcall用于安全地调用require，避免插件未安装时导致错误
local ok, _ = pcall(require, "notify")

-- 配置noice插件
require("noice").setup({
    -- 消息相关配置
    messages = {
        -- 设置默认消息视图为mini（小型视图）
        view = "mini",
        -- 设置搜索消息视图为mini
        view_search = "mini",
        -- 可以添加消息级别过滤
        -- level = vim.log.levels.INFO, -- 只显示INFO及以上级别的消息
    },
    
    -- 消息路由规则，用于过滤和重定向特定消息
    routes = {
        {
            -- 如果notify插件可用则使用notify视图，否则使用mini视图
            view = ok and "notify" or "mini",
            -- 过滤器：匹配事件类型为msg_show且内容包含"substitutions"的消息
            filter = {
                event = "msg_show",
                find = "substitutions",
            },
        },
        -- 过滤掉包含"fewer lines;"的消息（不显示）
        { filter = { find = "fewer lines;" }, opts = { skip = true } },
        -- 过滤掉包含"more line;"的消息
        { filter = { find = "more line;" }, opts = { skip = true } },
        -- 过滤掉包含"more lines;"的消息
        { filter = { find = "more lines;" }, opts = { skip = true } },
        -- 过滤掉包含"less;"的消息
        { filter = { find = "less;" }, opts = { skip = true } },
        -- 过滤掉包含"change;"的消息
        { filter = { find = "change;" }, opts = { skip = true } },
        -- 过滤掉包含"changes;"的消息
        { filter = { find = "changes;" }, opts = { skip = true } },
        -- 过滤掉包含"indent"的消息
        { filter = { find = "indent" }, opts = { skip = true } },
        -- 过滤掉包含"move"的消息
        { filter = { find = "move" }, opts = { skip = true } },
        -- 过滤掉包含"No information available"的消息
        { filter = { find = "No information available" }, opts = { skip = true } },
        -- 可以添加更多常见消息过滤
        { filter = { find = "written" }, opts = { skip = true } }, -- 过滤文件保存消息
        { filter = { event = "msg_show", min_height = 10 }, opts = { skip = true } }, -- 过滤高度超过10行的消息
    },
    
    -- 命令行界面配置
    cmdline = { 
        -- 设置命令行视图为cmdline（默认命令行样式）
        view = "cmdline",
        -- 可以添加格式化选项
        format = {
            -- 为不同类型的cmdline添加图标
            cmdline = { icon = "" },
            search_down = { icon = "🔍⌄" },
            search_up = { icon = "🔍⌃" },
            filter = { icon = "" },
            lua = { icon = "" },
            help = { icon = "" },
        }
    },
    
    -- 视图样式配置
    views = {
        -- 弹出菜单样式配置
        popupmenu = {
            -- 设置弹出菜单尺寸
            size = { width = 50, height = 10 },
            -- 边框样式配置
            border = {
                style = "rounded",  -- 圆角边框
                padding = { 0, 1 }, -- 边框内边距：水平0，垂直1
            },
            -- 窗口选项配置
            win_options = {
                -- 窗口高亮设置：正常模式使用Normal高亮组，浮动边框使用DiagnosticInfo高亮组
                winhighlight = { Normal = "Normal", FloatBorder = "DiagnosticInfo" },
            },
            -- 可以添加位置配置
            position = { row = "50%", col = "50%" },
        },
        -- 添加其他视图配置
        mini = {
            timeout = 3000, -- mini视图显示时长(毫秒)
        },
        cmdline_popup = {
            position = { row = 10, col = "50%" },
            size = { width = 60, height = "auto" },
            border = {
                style = "rounded",
                padding = { 0, 1 },
            },
        },
    },
    
    -- LSP相关配置
    lsp = {
        -- 消息配置
        message = {
            enabled = false,  -- 禁用LSP消息显示
        },
        -- 签名帮助配置
        signature = {
            enabled = false,  -- 禁用LSP签名帮助(可以使用其他插件如lspsaga)
        },
        -- 悬停文档配置
        hover = {
            enabled = true,   -- 启用悬停文档
            view = nil,       -- 使用默认视图
            opts = {},        -- 额外选项
        },
        -- 重写函数配置
        override = {
            -- 启用对vim.lsp.util.convert_input_to_markdown_lines函数的覆盖
            ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
            -- 启用对vim.lsp.util.stylize_markdown函数的覆盖
            ["vim.lsp.util.stylize_markdown"] = true,
            -- 启用对cmp.entry.get_documentation函数的覆盖
            ["cmp.entry.get_documentation"] = true,
        },
        -- 进度通知配置
        progress = {
            enabled = true,
            format = "lsp_progress",
            format_done = "lsp_progress_done",
            throttle = 1000 / 30, -- 更新频率限制
            view = "mini",
        },
    },
    
    -- 格式化器配置
    format = {
        -- 可以自定义不同消息类型的格式化方式
        level = {
            icons = {
                error = "✖",
                warn = "▼",
                info = "●",
                debug = "◆",
            },
        },
    },
    
    -- 预设配置
    presets = {
        bottom_search = true,         -- 在底部显示搜索界面
        long_message_to_split = true, -- 长消息自动分割
        lsp_doc_border = true,        -- LSP文档显示边框
        command_palette = true,       -- 启用命令面板
        inc_rename = false,           -- 禁用增量重命名(可以使用其他插件)
    },
    
    -- 健康检查配置
    health = {
        checker = true, -- 启用健康检查
    },
    
    -- 调试模式(开发时使用)
    debug = false,
    
    -- 智能功能
    smart_move = {
        -- 当光标靠近边缘时自动移动noice窗口
        enabled = true,
        excluded_filetypes = { "cmp_menu", "cmp_docs", "notify" },
    },
    
    -- 通知历史配置
    history = {
        view = "split",
        filter = { event = "msg_show", ["not"] = { kind = { "search_count", "echo" } } },
        size = 10,
    },
})

-- 可选：配置notify插件(如果已安装)
if ok then
    require("notify").setup({
        background_colour = "#000000",
        timeout = 3000,
        max_height = function() return math.floor(vim.o.lines * 0.75) end,
        max_width = function() return math.floor(vim.o.columns * 0.75) end,
    })
end