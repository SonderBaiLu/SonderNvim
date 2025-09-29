-- 配置主题（自动适配插件 UI）
require("catppuccin").setup({
  flavour = "macchiato", -- 深色主题（可选 latte 浅色）
  integrations = {
    nvim_cmp = true,     -- 适配 nvim-cmp 补全 UI
    telescope = true,    -- 适配 telescope 搜索 UI
    nvim_tree = true,    -- 适配 nvim-tree 文件树
    aerial = true,       -- 适配 aerial 大纲
    lsp_trouble = true,  -- 适配 LSP 错误提示
    -- 其他插件按需添加
  },
})
