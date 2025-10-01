-- blink 补全引擎精细配置（含详细中文注释，适配 SonderNvim 生态）

-- 1. 加载 blink.cmp 主模块
local blink = require("blink.cmp")

-- 2. 主配置
blink.setup({
  -- ========== 界面与性能优化 ==========
  -- ui = {
  --   border = "rounded",   -- 补全菜单边框样式
  --   icons = true,         -- 显示图标（需 lspkind 相关配置）
  --   highlight = true,     -- 高亮菜单项
  --   theme = "catppuccin", -- 优先适配 catppuccin 主题
  -- },
  -- performance = {
  --   debounce = 60,       -- 输入防抖，单位 ms
  --   throttle = 30,       -- 菜单刷新节流
  --   fetch_timeout = 200, -- LSP/AI 补全超时
  -- },
  -- ========== 补全行为设置 ==========
  completion = {
    keyword = {
      range = "prefix", -- 补全关键词的范围：仅补全光标前缀
    },
    trigger = {
      show_on_keyword = true,                           -- 输入字母/下划线/点等自动触发
      show_on_trigger_characters = { ".", ":", "@", "#" }, -- 这些符号立即触发补全
      insert_on_trigger_character = false,              -- 仅弹出菜单，不自动插入第一项，避免误触
    },
    -- documentation = {
    --   auto_show = true,   -- 自动显示补全项的文档说明
    --   border = "rounded", -- 文档窗口圆角边框
    --   max_width = 80,     -- 文档最大宽度
    -- },
    -- menu = {
    --   max_items = 10, -- 补全菜单最大显示条目数
    -- },
  },

  -- ========== 按键映射（与 snippets 配合）==========
  keymap = {
    preset = "none", -- 采用 blink 默认建议键位
    ['<C-k>'] = { 'select_prev', 'fallback' },
    ['<C-j>'] = { 'select_next', 'fallback' },
    ['<C-space>'] = { function(cmp) cmp.show({ providers = { 'snippets' } }) end },
    ['<CR>'] = { 'accept','fallback' },                  -- 回车确认选择
    ["<C-c>"] = {"cancel"},                     -- 取消补全
    -- ["<C-u>"] = { "scroll_documentation_up" }, -- 向上滚动文档
    -- ["<C-d>"] = { "scroll_documentation_down" }, -- 向下滚动文档
    -- ["<C-l>"] = { "snippet_forward" },        -- 跳转下一个片段占位符
    -- ["<C-h>"] = { "snippet_backward" },       -- 跳转上一个片段占位符

  },
  -- ========== 补全源设置 ==========
  sources = {
    providers = {
      -- LSP 补全，依赖 mason/mason-lspconfig 管理语言服务器
      lsp = {
        name = "LSP",
        module = "blink.cmp.sources.lsp",
        score_offset = 1, -- 提高 LSP 优先级
        -- group_index = 1,  -- 补全菜单分组显示（可选）
      },
      -- 代码片段补全，需 LuaSnip + friendly-snippets
      snippets = {
        name = "Snippets",
        module = "blink.cmp.sources.snippets",
        group_index = 2,
        -- 你可在 LuaSnip 配置自定义片段目录
      },
      -- 当前 buffer 补全
      buffer = {
        name = "Buffer",
        module = "blink.cmp.sources.buffer",
        group_index = 3,
      },
      -- 路径补全
      path = {
        name = "Path",
        module = "blink.cmp.sources.path",
        group_index = 4,
      },
      -- Copilot AI 补全（如有启用，建议作为最后一源）
      -- copilot = {
      --   name = "Copilot",
      --   module = "blink.cmp.sources.copilot",
      --   group_index = 5,
      -- },
    },
    -- 可按需设置禁用某些文件类型的补全源
    -- filetype_exclude = { markdown = true, ... }
  },
})

-- ========== 兼容与配合建议 ==========
-- 1. LSP：确保 mason/mason-lspconfig 配置正常，语言服务器已安装并 attach 到 buffer。
--    见 plugin-configs/lsp.lua、plugin-configs/mason-null-ls.lua
-- 2. 片段：确保 LuaSnip 和 friendly-snippets 配置并启用（你已在依赖声明，不需重复 require）
-- 3. null-ls：格式化/诊断统一纳入 LSP 流程，见 plugin-configs/null-ls.lua
-- 4. Copilot：如启用 copilot.lua，建议分离快捷键（避免和 blink 冲突），AI 补全建议放最后。
-- 5. 主题：catppuccin 已适配 nvim_cmp UI，无需特殊设置（见 plugin-configs/catppuccin.lua）
-- 6. 其他插件（如 autopairs）：建议在补全确认时自动补齐括号，可用 autopairs 的集成函数。

-- ========== 常见报错排查 ==========
-- 1. 找不到 blink.cmp：确认插件已在 plugins.lua/dependencies 中声明并安装。
-- 2. LSP 补全无反应：检查 LSP 服务器是否 attach，:LspInfo 查看。
-- 3. Snippet 补全无内容：确认 LuaSnip/friendly-snippets 已启用。
-- 4. 菜单渲染异常：尝试禁用主题适配或确认 UI 插件加载顺序。

-- 你可在 user/user_config.lua 用 M.enable_plugins = { blink = true, ... } 控制插件开关。

-- 如需进一步细调、扩展菜单图标、分组、排序等，请查阅 blink.cmp 官方文档与源码。
