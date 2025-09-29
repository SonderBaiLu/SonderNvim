-- 导入工具函数
local map = require("core.utils.utils").map

-- 安全加载用户配置，使用pcall避免配置不存在时报错
local exist, user_config = pcall(require, "user.user_config")
-- 获取插件启用组：如果用户配置存在且为table类型，则使用配置中的enable_plugins，否则使用空表
local group = exist and type(user_config) == "table" and user_config.enable_plugins or {}
-- 导入插件启用检查函数
local enabled = require("core.utils.utils").enabled

-- 设置全局leader键为空格
vim.g.mapleader = " " -- 全局leader键设置为空格

local M = {} -- 定义模块表

-- 设置which-key插件分组标签
local wk = require("which-key")
wk.add({
    {"<leader>d", group = "调试"},  -- 调试相关命令分组
    {"<leader>n", group = "文件树"} -- 文件树相关命令分组
})

-- 图片粘贴功能
if enabled(group, "img_paste") then
    -- 粘贴剪贴板图片
    map("n", "<leader>p", "<CMD>PasteImage<CR>", { desc = "粘贴剪贴板图片" })
end 

-- DAP调试功能
if enabled(group, "dap") then
    _G.dap = require("dap") -- 全局注册dap模块
    -- 继续调试
    map("n", "<leader>dc", "<CMD>lua dap.continue()<CR>")
    -- 单步跳过
    map("n", "<leader>dn", "<CMD>lua dap.step_over()<CR>")
    -- 单步进入
    map("n", "<leader>di", "<CMD>lua dap.step_into()<CR>")
    -- 单步跳出
    map("n", "<leader>do", "<CMD>lua dap.step_out()<CR>")
    -- 切换断点
    map("n", "<leader>db", "<CMD>lua dap.toggle_breakpoint()<CR>")
    -- 断开调试连接
    map("n", "<leader>dq", "<CMD>lua dap.disconnect({ terminateDebuggee = true })<CR>")
end

-- Trouble诊断窗口功能
if enabled(group, "trouble") then
    -- 显示LSP引用
    map("n", "<leader>tr", "<CMD>TroubleToggle lsp_references<CR>")
    -- 显示LSP定义
    map("n", "<leader>td", "<CMD>TroubleToggle lsp_definitions<CR>")
    -- 切换诊断窗口
    map("n", "<leader>cd", "<CMD>TroubleToggle<CR>")
end

-- UFO代码折叠功能
if enabled(group, "ufo") then
    -- 展开所有折叠
    map("n", "zR", "<CMD>lua require('ufo').openAllFolds()<CR>")
    -- 关闭所有折叠
    map("n", "zM", "<CMD>lua require('ufo').closeAllFolds()<CR>")
end

-- ZenMode专注模式
if enabled(group, "zen") then
    -- 切换禅模式
    map("n", "<leader>zm", "<CMD>ZenMode<CR>")
end

-- NeoTree文件树功能
if enabled(group, "neotree") then
    -- 左侧打开文件树
    map("n", "<leader>nt", "<CMD>Neotree reveal left<CR>")
    -- 浮动窗口打开文件树
    map("n", "<leader>nf", "<CMD>Neotree reveal float<CR>")
end

-- Aerial代码大纲功能
if enabled(group, "aerial") then
    -- 切换大纲视图
    map("n", "<leader>at", "<CMD>AerialToggle<CR>")
end

-- 搜索和 highlighting
map("n", "m", "<CMD>noh<CR>") -- 清除搜索高亮

-- 移动增强功能
-- 在插入模式下，按<C-d>可移动到下一个分隔符（引号、括号等）
map("i", "<C-d>", "<left><c-o>/[\"';)>}\\]]<cr><c-o><CMD>noh<cr><right>")
-- 移动到行首
map("i", "<C-b>", "<C-o>0")
-- 移动到行尾并进入插入模式
map("i", "<C-a>", "<C-o>A")

-- 终端窗口切换
map("t", "<C-w>h", "<C-\\><C-n><C-w>h") -- 切换到左侧窗口
map("t", "<C-w>j", "<C-\\><C-n><C-w>j") -- 切换到下方窗口
map("t", "<C-w>k", "<C-\\><C-n><C-w>k") -- 切换到上方窗口
map("t", "<C-w>l", "<C-\\><C-n><C-w>l") -- 切换到右侧窗口

-- 命令模式增强
map("c", "<C-p>", "<Up>")   -- 命令历史上一条
map("c", "<C-n>", "<Down>") -- 命令历史下一条

-- Telescope搜索功能
if enabled(group, "telescope") then
    -- 查找文件（包含隐藏文件）
    map("n", "<leader>ff", "<CMD>Telescope git_files hidden=true<CR>", { desc = "Telescope查找文件" })
    -- 实时 grep
    map("n", "<leader>fg", "<CMD>Telescope live_grep<CR>")
    -- 缓冲区搜索
    map("n", "<leader>fb", "<CMD>Telescope buffers<CR>")
    -- 帮助标签搜索
    map("n", "<leader>fh", "<CMD>Telescope help_tags<CR>")
    -- 代码大纲搜索
    map("n", "<leader>fa", "<CMD>Telescope aerial<CR>")
    -- 项目搜索
    map("n", "<leader>fp", "<CMD>Telescope projects<CR>")
end

-- 移动行和代码块
map("x", "<A-j>", ":m '>+1<CR>gv=gv") -- 向下移动选中内容
map("x", "<A-k>", ":m '<-2<CR>gv=gv") -- 向上移动选中内容

-- Notify通知系统
if enabled(group, "notify") then
    -- 关闭通知窗口
    map("n", "<ESC>", "<CMD>lua require('notify').dismiss()<CR>")
    map("i", "<ESC>", "<CMD>lua require('notify').dismiss()<CR><ESC>")
end

-- LSP相关功能
if enabled(group, "lsp_zero") then
    _G.buf = vim.lsp.buf -- 全局注册LSP缓冲区方法
    -- 全局替换当前光标下的单词
    map("n", "rg", ":%s/<C-r><C-w>//g<Left><Left>", { desc = "全局替换" })
    -- 跳转到声明
    map("n", "gD", "<CMD>lua buf.declaration()<CR>")
    -- 跳转到定义
    map("n", "gd", "<CMD>lua buf.definition()<CR>")
    -- 跳转到实现
    map("n", "gi", "<CMD>lua buf.implementation()<CR>")
    -- 查找引用
    map("n", "gr", "<CMD>Telescope lsp_references<CR>")
    -- 显示签名帮助
    map("n", "sh", "<CMD>lua buf.signature_help()<CR>")
    -- 重命名符号
    map("n", "<leader>rn", "<CMD>lua buf.rename()<CR>")
    -- 代码操作
    map("n", "<leader>ca", "<CMD>lua buf.code_action()<CR>")
    -- 切换内联提示
    map("n", "<C-k>", "<CMD>lua vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled())<CR>")
end

-- Session管理功能
if enabled(group, "session_manager") then
    -- 保存当前会话
    map("n", "<leader>ss", "<CMD>SessionManager save_current_session<CR>")
    -- 加载会话
    map("n", "<leader>o", "<CMD>SessionManager load_session<CR>")
end

-- ToggleTerm终端功能
if enabled(group, "toggleterm") then
    local git_root = "cd $(git rev-parse --show-toplevel 2>/dev/null) && clear"
    -- 退出终端模式
    map("t", "<C-\\>", "<C-\\><C-n>")
    -- 在git根目录打开终端
    map("n", "<C-\\>", "<CMD>ToggleTerm go_back=0 cmd='" .. git_root .. "'<CR>", { desc = "新建终端" })
    -- 打开代码统计工具tokei
    map(
        "n",
        "<leader>tk",
        "<CMD>TermExec go_back=0 direction=float cmd='" .. git_root .. "&& tokei'<CR>",
        { desc = "代码统计" }
    )
    -- 打开lazygit
    map("n", "<leader>gg", "<CMD>lua term.lazygit_toggle()<CR>", { desc = "打开lazygit" })
    -- 打开磁盘使用分析工具gdu
    map("n", "<leader>gd", "<CMD>lua term.gdu_toggle()<CR>", { desc = "打开磁盘分析" })
    -- 打开系统监控工具bashtop
    map("n", "<leader>bt", "<CMD>lua term.bashtop_toggle()<CR>", { desc = "打开系统监控" })
end

-- Hop快速跳转功能
if enabled(group, "hop") then
    -- 按单词跳转
    map("n", "<leader>j", "<CMD>HopWord<CR>")
end

-- Gitsigns git状态功能
if enabled(group, "gitsigns") then
    -- Gitsigns配置函数
    M.gitsigns = function()
        local gs = package.loaded.gitsigns
        
        -- 跳转到下一个hunk
        map("n", "]c", function()
            if vim.wo.diff then
                return "]c"
            end
            vim.schedule(function()
                gs.next_hunk()
            end)
            return "<Ignore>"
        end, { expr = true, desc = "下一个git hunk" })
        
        -- 跳转到上一个hunk
        map("n", "[c", function()
            if vim.wo.diff then
                return "[c"
            end
            vim.schedule(function()
                gs.prev_hunk()
            end)
            return "<Ignore>"
        end, { expr = true, desc = "上一个git hunk" })

        -- 暂存hunk
        map("n", "<leader>hs", gs.stage_hunk, { desc = "暂存hunk" })
        -- 重置hunk
        map("n", "<leader>hr", gs.reset_hunk, { desc = "重置hunk" })
        -- 暂存缓冲区
        map("n", "<leader>hS", gs.stage_buffer, { desc = "暂存缓冲区" })
        -- 撤销暂存hunk
        map("n", "<leader>hu", gs.undo_stage_hunk, { desc = "撤销暂存hunk" })
        -- 重置缓冲区
        map("n", "<leader>hR", gs.reset_buffer, { desc = "重置缓冲区" })
        -- 预览hunk更改
        map("n", "<leader>hp", gs.preview_hunk, { desc = "预览hunk" })
        -- 显示完整blame信息
        map("n", "<leader>hb", function()
            gs.blame_line({ full = true })
        end, { desc = "完整blame信息" })
        -- 切换行blame显示
        map("n", "<leader>lb", gs.toggle_current_line_blame, { desc = "切换行blame" })
        -- 与当前工作目录差异比较
        map("n", "<leader>hd", gs.diffthis, { desc = "与工作目录差异" })
        -- 与git根目录差异比较
        map("n", "<leader>hD", function()
            gs.diffthis("~")
        end, { desc = "与git根目录差异" })
        -- 切换删除行显示
        map("n", "<leader>td", gs.toggle_deleted, { desc = "切换删除行显示" })
    end
end

-- 返回模块
return M