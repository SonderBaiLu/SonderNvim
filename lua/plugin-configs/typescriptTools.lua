local util = require("lspconfig.util")

require("typescript-tools").setup({
  -- 服务器启动配置
  on_attach = function(client, bufnr)
    -- 禁用内置格式化功能（使用 prettier 替代，与原有 tsserver 配置保持一致）
    client.server_capabilities.documentFormattingProvider = false
    client.server_capabilities.documentRangeFormattingProvider = false

    -- 可添加额外的 on_attach 逻辑（如快捷键映射）
    -- 例如：绑定 goto 定义、查找引用等 LSP 功能快捷键
    vim.keymap.set("n", "gd", vim.lsp.buf.definition, { buffer = bufnr, desc = "Go to definition" })
    vim.keymap.set("n", "gr", vim.lsp.buf.references, { buffer = bufnr, desc = "Show references" })
  end,

  -- 根目录识别（与原有 tsserver 配置保持一致）
  root_dir = function(fname)
    return util.root_pattern(
      "tsconfig.json",
      "package.json",
      "jsconfig.json",
      ".git"
    )(fname)
  end,

  -- 类型提示和语言功能配置（迁移原有 inlayHints 设置）
  settings = {
    -- 启用 TypeScript 特定功能
    tsserver_file_preferences = {
      -- 启用 inlay 提示（与原有配置保持一致）
      includeInlayParameterNameHints = "all",
      includeInlayFunctionParameterTypeHints = true,
      includeInlayVariableTypeHints = true,
      includeInlayPropertyDeclarationTypeHints = true,
      includeInlayFunctionLikeReturnTypeHints = true,
      includeInlayEnumMemberValueHints = true,
    },
    -- 启用 JavaScript 支持（与原有配置保持一致）
    jsx_file_preferences = {
      includeInlayParameterNameHints = "all",
      includeInlayFunctionParameterTypeHints = true,
      includeInlayVariableTypeHints = true,
      includeInlayPropertyDeclarationTypeHints = true,
      includeInlayFunctionLikeReturnTypeHints = true,
      includeInlayEnumMemberValueHints = true,
    },
    -- 其他增强功能（可选）
    tsserver_plugins = {
      -- 如果需要使用 TypeScript 插件（如 @styled/typescript-styled-plugin）
      -- "@styled/typescript-styled-plugin"
    },
    -- 启用自动导入建议
    auto_import_completions = true,
  },

  -- 额外配置
  capabilities = {
    -- 继承默认 LSP 能力（可添加折叠等功能支持）
    textDocument = {
      foldingRange = {
        dynamicRegistration = false,
        lineFoldingOnly = true,
      },
    },
  },
})
