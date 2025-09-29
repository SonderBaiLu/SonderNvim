-- require("neo-tree").setup({
-- 	close_if_last_window = true,
-- 	window = {
-- 		mappings = {
-- 			["C"] = "close_all_subnodes",
-- 			["Z"] = "expand_all_nodes",
-- 		},
-- 	},
-- 	filesystem = {
-- 		follow_current_file = {
-- 			enabled = true,
-- 		},
-- 		hijack_netrw_behavior = "open_current",
-- 	},
-- })

-- 初始化 neo-tree 插件（文件树管理器）
require("neo-tree").setup({
  -- ====================== 基础行为配置 ======================
  -- 当 neo-tree 是最后一个打开的窗口时，关闭它会同时退出 Neovim（避免单独残留文件树窗口）
  close_if_last_window = true,

  -- 禁止在已经打开 neo-tree 的情况下，再次通过命令打开新的 neo-tree 窗口
  allow_resize = true,  -- 允许手动拖拽调整 neo-tree 窗口宽度
  default_component_configs = {
    -- ====================== 默认组件配置 ======================
    -- 1. 图标组件（文件/文件夹/Git 状态等图标）
    icon = {
      -- 文件树中「折叠/展开」图标的样式（使用 UTF-8 字符，无需额外字体）
      folder_closed = "",  -- 文件夹未展开时的图标
      folder_open = "",    -- 文件夹展开时的图标
      folder_empty = "",   -- 空文件夹的图标
      folder_empty_open = "",-- 空文件夹展开时的图标
      -- 自定义文件类型图标（优先级高于默认图标，可根据开发场景扩展）
      default = "",       -- 未匹配到特定类型的默认文件图标
      -- 示例：为前端常用文件类型配置专属图标（需确保终端支持图标显示）
      symlink = "",        -- 符号链接（快捷方式）图标
      git_status = {
        -- Git 状态图标（与 Git 集成时显示，直观区分文件变更）
        staged = "✓",       -- 已暂存（git add 后的文件）
        unstaged = "✗",     -- 未暂存（修改但未 git add 的文件）
        untracked = "★",    -- 未跟踪（新创建未加入 Git 的文件）
        deleted = "",      -- 已删除（git rm 后的文件）
        renamed = "➜",      -- 已重命名（git mv 后的文件）
        merged = "",       -- 合并冲突（merge conflict 的文件）
        ignored = "◌",      -- 已忽略（.gitignore 中配置的文件）
      },
    },

    -- 2. 文件名称组件（控制文件名显示样式）
    name = {
      trailing_slash = false,  -- 文件夹名称末尾是否显示斜杠（/），建议关闭避免视觉冗余
      use_git_status_colors = true,  -- 文件名颜色是否跟随 Git 状态变化（如暂存文件绿色，未暂存红色）
    },

    -- 3. Git 状态组件（显示文件的 Git 变更状态）
    git_status = {
      symbols = {
        -- 覆盖默认 Git 状态符号（与 icon.git_status 对应，保持视觉一致）
        added = "",         -- 新增文件（不单独显示符号，依赖文件名颜色区分）
        modified = "",      -- 修改文件（同上）
        deleted = "",      -- 删除文件
        renamed = "➜",      -- 重命名文件
        untracked = "★",    -- 未跟踪文件
        ignored = "◌",      -- 忽略文件
        unstaged = "✗",     -- 未暂存文件
        staged = "✓",       -- 已暂存文件
        conflict = "",     -- 冲突文件
      },
    },
  },

  -- ====================== 窗口样式配置 ======================
  window = {
    position = "left",  -- neo-tree 窗口的位置（left/right/top/bottom，默认左侧更符合开发习惯）
    width = 30,         -- 窗口宽度（单位：字符，可根据屏幕分辨率调整，建议 25-40）
    mapping_options = {
      noremap = true,    -- 禁用递归映射（避免快捷键与其他插件冲突）
      nowait = true,     -- 不等待后续按键（按下快捷键立即响应，提高操作效率）
    },
    -- 窗口内的快捷键映射（在文件树窗口中生效，补充常用操作）
    mappings = {
      -- 你原有配置：关闭当前节点下所有子节点（折叠多级子文件夹）
      ["C"] = "close_all_subnodes",
      -- 你原有配置：展开当前节点下所有子节点（展开多级子文件夹）
      ["Z"] = "expand_all_nodes",

      -- 补全：基础导航与操作
      ["<CR>"] = "open",          -- 回车：打开选中的文件/文件夹
      ["<2-LeftMouse>"] = "open", -- 鼠标左键双击：打开文件/文件夹（符合 GUI 习惯）
      ["<ESC>"] = "revert_preview",-- ESC：退出预览模式（如预览文件内容时）
      ["P"] = { "toggle_preview", config = { use_float = true } }, -- P：预览文件内容（浮动窗口显示，不切换缓冲区）

      -- 补全：文件操作
      ["a"] = "add",              -- a：新建文件/文件夹（会提示输入路径，支持相对路径）
      ["d"] = "delete",           -- d：删除选中的文件/文件夹（会确认，避免误删）
      ["r"] = "rename",           -- r：重命名选中的文件/文件夹
      ["y"] = "copy_to_clipboard",-- y：复制选中文件的路径到剪贴板
      ["x"] = "cut_to_clipboard", -- x：剪切选中的文件（用于移动）
      ["p"] = "paste_from_clipboard",-- p：粘贴剪贴板中的文件（移动/复制）
      ["c"] = "copy",             -- c：复制选中文件（生成副本，需指定目标路径）
      ["m"] = "move",             -- m：移动选中文件（需指定目标路径）
      ["R"] = "refresh",          -- R：刷新文件树（同步外部修改，如手动删除文件后）

      -- 补全：视图控制
      ["<"] = "prev_source",      -- <：切换到上一个文件源（如从 filesystem 切换到 buffers）
      [">"] = "next_source",      -- >：切换到下一个文件源
      ["q"] = "close_window",     -- q：关闭 neo-tree 窗口
    },
  },

  -- ====================== 文件系统配置（核心功能） ======================
  filesystem = {
    -- 跟随当前编辑的文件：当切换缓冲区时，文件树自动定位到当前打开的文件
    follow_current_file = {
      enabled = true,  -- 启用该功能（开发时快速定位文件在项目中的位置）
      leave_dirs_open = false, -- 跟随文件时，是否保持其他文件夹展开（建议关闭，减少视觉干扰）
    },

    -- 劫持 netrw（Neovim 内置文件管理器）的行为：打开目录时优先使用 neo-tree
    hijack_netrw_behavior = "open_current", -- "open_current"：在当前窗口打开 neo-tree（替代 netrw）
    -- 可选值：
    -- - "open_default"：打开新的 neo-tree 窗口
    -- - "disabled"：禁用劫持，保留 netrw

    -- 文件过滤：隐藏不需要显示的文件/文件夹（避免文件树杂乱）
    filtered_items = {
      visible = false, -- 是否显示被过滤的文件（false 表示隐藏，true 表示显示但标灰）
      hide_dotfiles = true, -- 隐藏隐藏文件（以 . 开头的文件，如 .gitignore、.env）
      hide_gitignored = true, -- 隐藏 .gitignore 中配置的文件（如 node_modules、dist）
      hide_hidden = true, -- 同 hide_dotfiles，保持兼容
      hide_by_name = {
        -- 按文件名隐藏特定文件（根据开发场景添加，示例为前端常用）
        "node_modules",   -- 前端依赖文件夹
        "dist",           -- 构建输出文件夹
        "build",          -- 构建文件夹
        "coverage",       -- 测试覆盖率文件夹
        ".DS_Store",      -- macOS 系统文件
        "Thumbs.db",      -- Windows 系统文件
      },
      hide_by_pattern = {
        -- 按通配符隐藏文件（示例：隐藏所有 .log 和 .tmp 文件）
        "*.log",
        "*.tmp",
        "*.swp", -- Neovim 交换文件（避免显示临时文件）
      },
      never_show = {
        -- 绝对不显示的文件/文件夹（即使 filtered_items.visible = true 也不显示）
        ".git", -- Git 版本控制文件夹（通常不需要在文件树中操作）
        "node_modules",
      },
    },

    -- 其他实用配置
    use_libuv_file_watcher = true, -- 使用 libuv 监听文件变化（实时同步外部修改，如 IDE 中删除文件后立即更新）
    components = {
      -- 为文件系统添加「文件大小」组件（显示文件体积，文件夹不显示）
      size = {
        enabled = true,
        required_width = 40, -- 当窗口宽度 >=40 时才显示文件大小（避免宽度不足导致布局错乱）
      },
      -- 为文件系统添加「修改时间」组件（显示文件最后修改时间）
      last_modified = {
        enabled = true,
        required_width = 80, -- 窗口宽度 >=80 时显示（时间字符串较长，需要足够宽度）
      },
    },
  },

  -- ====================== 缓冲区管理配置（显示已打开的文件） ======================
  buffers = {
    follow_current_file = {
      enabled = true, -- 切换缓冲区时，自动定位到当前文件在缓冲区列表中的位置
    },
    show_unloaded = true, -- 显示未加载的缓冲区（已打开但当前未激活的文件，方便快速切换）
    window = {
      mappings = {
        ["bd"] = "buffer_delete", -- bd：关闭选中的缓冲区（同时关闭对应的文件）
        ["<bs>"] = "navigate_up", -- Backspace：返回上一级（从缓冲区列表回到文件系统）
      },
    },
  },

  -- ====================== Git 集成配置（显示 Git 工作区文件） ======================
  git_status = {
    window = {
      position = "float", -- Git 状态窗口以浮动窗口显示（避免占用固定位置）
      mappings = {
        ["A"] = "git_add_all", -- A：暂存所有变更（git add .）
        ["gu"] = "git_unstage_file", -- gu：取消暂存选中文件（git reset HEAD <file>）
        ["ga"] = "git_add_file", -- ga：暂存选中文件（git add <file>）
        ["gr"] = "git_revert_file", -- gr：撤销选中文件的修改（git checkout -- <file>）
        ["gc"] = "git_commit", -- gc：提交暂存区（git commit，会打开提交信息编辑框）
        ["gp"] = "git_push", -- gp：推送提交到远程（git push，需提前配置 Git 远程仓库）
        ["gg"] = "git_commit_and_push", -- gg：提交并推送（git commit + git push）
      },
    },
  },

  -- ====================== 事件钩子（自定义行为触发时机） ======================
  event_handlers = {
    -- 当 neo-tree 窗口打开时触发
    {
      event = "neo_tree_window_opened",
      handler = function(args)
        -- 打开文件树后自动聚焦到窗口（方便立即操作文件树）
        vim.cmd("wincmd l") -- 切换到左侧窗口（若 neo-tree 在左侧，l 表示向右切换；若在右侧则用 h）
      end,
    },
    -- 当 neo-tree 窗口关闭时触发
    {
      event = "neo_tree_window_closed",
      handler = function(args)
        -- 关闭文件树后自动聚焦到编辑窗口（避免停留在空窗口）
        vim.cmd("wincmd p") -- 切换到上一个活动窗口
      end,
    },
  },
})
