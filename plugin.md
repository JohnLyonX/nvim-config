# Neovim 配置插件总览

> Leader 键：`<Space>`
> 配置入口：[init.lua](init.lua) → `johnlyon.lazy` → 自动 import `johnlyon.plugins.*`

## 目录

- [核心快捷键（非插件）](#核心快捷键非插件)
- [UI / 外观](#ui--外观)
- [文件管理与导航](#文件管理与导航)
- [模糊查找](#模糊查找)
- [编辑增强](#编辑增强)
- [LSP / 语言支持](#lsp--语言支持)
- [Git](#git)
- [终端与会话](#终端与会话)
- [AI / 协作](#ai--协作)
- [Markdown / 文档](#markdown--文档)
- [摸鱼专区 🎮](#摸鱼专区-)

---

## 核心快捷键（非插件）

定义在 [lua/johnlyon/core/keymaps.lua](lua/johnlyon/core/keymaps.lua)。

### 退出插入 / 清搜索

| 快捷键 | 模式 | 效果 |
|---|---|---|
| `jk` | insert / terminal | 退出到 normal 模式（替代 `<Esc>`） |
| `<leader>nh` | normal | 清除搜索高亮 |

### 数字增减

| 快捷键 | 效果 |
|---|---|
| `<leader>+` | 光标处数字 +1 |
| `<leader>-` | 光标处数字 -1 |

### 窗口分割

| 快捷键 | 效果 |
|---|---|
| `<leader>sv` | 垂直分屏 |
| `<leader>sh` | 水平分屏 |
| `<leader>se` | 各 split 大小相等 |
| `<leader>sx` | 关闭当前 split |
| `<leader>swh` | 进入"高度调整"模式 |
| `<leader>swv` | 进入"宽度调整"模式 |

### Buffer / Tab

| 快捷键 | 效果 |
|---|---|
| `H` | 上一个 buffer |
| `L` | 下一个 buffer |
| `<leader>bx` | 关闭当前 buffer |
| `<leader>box` | 关闭除当前外的所有 buffer |
| `<leader>to` | 新建 tab |
| `<leader>tx` | 关闭当前 tab |
| `<leader>tn` / `<leader>tp` | 下一个 / 上一个 tab |
| `<leader>tf` | 当前 buffer 移到新 tab |

### 行内移动

| 快捷键 | 效果 |
|---|---|
| `<leader>p` | 跳到行尾（等价 `$`） |
| `<leader>q` | 跳到行首（等价 `0`） |

---

## UI / 外观

### alpha-nvim

启动时显示的 ASCII art 仪表盘。当前 Header 是 **ZHANBO**。

| 快捷键 | 效果 |
|---|---|
| `e` | 新建文件 |
| `SPC ee` | 切换文件浏览器 |
| `SPC ff` | 查找文件 |
| `SPC fs` | 全文搜索 |
| `SPC wr` | 恢复当前目录的 session |
| `q` | 退出 nvim |

### lualine

状态栏。集成了项目语言徽章（左侧 `<icon> zig`，半透明品牌色背景）+ branch + diff + filetype + diagnostics + 位置信息。

无独立快捷键，自动随光标 / buffer 更新。

### bufferline

顶部 buffer tab 栏。配合核心快捷键的 `H` / `L` 切换。

### noice.nvim

把 cmdline、消息、LSP 提示**改成浮动窗口**。

- `:` 进入命令模式时，弹出**居中圆角浮窗**
- LSP hover 文档（K）带圆角
- 错误 / 警告 → 右下角通知（自动消失）
- 已隐藏 cmdline 区（`opt.cmdheight = 0`），statusline 直接贴底

### which-key

按下 `<leader>` 后等约 300ms，**自动弹出快捷键提示**，展示当前前缀下的所有绑定。无需记忆，跟着提示走。

### dressing.nvim

美化 `vim.ui.input` / `vim.ui.select` 等原生输入界面。无快捷键，所有插件的输入框自动用它的样式。

### indent-blankline

显示缩进对齐线。无快捷键，自动渲染。

### nvim-web-devicons

文件类型图标库，被几乎所有 UI 插件依赖。

### colorizer

高亮文件中的颜色代码（`#FF0000` → 显示为红色背景）。

| 快捷键 | 效果 |
|---|---|
| `<leader>cz` | 切换 colorizer 高亮（如有配置） |

---

## 文件管理与导航

### nvim-tree

左侧文件树。

| 快捷键 | 效果 |
|---|---|
| `<leader>ee` | 打开 / 关闭文件浏览器 |
| `<leader>ef` | 打开文件浏览器并定位到当前文件 |
| `<leader>ec` | 折叠所有目录 |
| `<leader>er` | 刷新文件树 |

**树内操作**（光标在 nvim-tree 窗口）：

| 快捷键 | 效果 |
|---|---|
| `<CR>` | 打开文件 / 进入目录 |
| `a` | 新建文件 / 目录（末尾加 `/` 即目录） |
| `r` | 重命名 |
| `d` | 删除 |
| `x` / `c` / `p` | 剪切 / 复制 / 粘贴 |
| `H` | 切换隐藏文件显示 |
| `?` | 弹出完整帮助 |

**自动行为：** `:q` 关闭最后一个代码 buffer 时，会**自动一起关掉 nvim-tree 并退出 nvim**（不会卡在 tree 界面）。

### harpoon

ThePrimeagen 的"快速文件书签"——给最常用的 4-5 个文件打标签，秒切。

| 快捷键 | 效果 |
|---|---|
| `<leader>hm` | 把当前文件加入 harpoon 列表 |
| `<leader>hn` | 跳到下一个 harpoon 标记 |
| `<leader>hp` | 跳到上一个 harpoon 标记 |

### flash.nvim

**屏幕内瞬移**——输入 1-2 个字符，整屏所有匹配处出现字母标签，按字母传送。

| 快捷键 | 模式 | 效果 |
|---|---|---|
| `s` | normal / visual / operator | Flash 跳转 |
| `S` | normal / visual / operator | Treesitter 跳转（选中整个语法节点） |
| `r` | operator | Remote Flash（远程操作后回原位） |
| `R` | operator / visual | Treesitter 范围搜索 |
| `<C-s>` | cmdline | 在搜索（`/`）中切换 Flash 模式 |
| `f` `F` `t` `T` | normal | 增强版行内跳转（多行 + 标签） |
| `;` `,` | normal | 重复 / 反向重复上次 `f`/`t` |

**典型流程：**
1. `s` + `ad` → 跳到屏幕上 `addr` 那个位置
2. `dr` + 跳过去 + 字母 → 远程删一个词，光标自动回原位

---

## 模糊查找

### Telescope

最经典的 fuzzy finder。

| 快捷键 | 效果 |
|---|---|
| `<leader>ff` | 项目文件查找 |
| `<leader>fr` | 最近打开的文件 |
| `<leader>fs` | 全文搜索（live grep） |
| `<leader>fc` | 搜索光标下的词 |

### fzf-lua

更快的 fzf 后端，被 LSP 引用查找等命令使用：

| 快捷键 | 效果 |
|---|---|
| `gR` | LSP 引用列表 |
| `gd` | LSP 定义 |
| `gi` | LSP 实现 |
| `gt` | LSP 类型定义 |
| `<leader>D` | 当前 buffer 诊断列表 |

---

## 编辑增强

### nvim-surround

操作"包围符号"——括号、引号、标签等。

| 快捷键 | 效果 |
|---|---|
| `ys<motion><char>` | **添加**包围（如 `ysiw"` 给当前词加双引号） |
| `cs<old><new>` | **更换**包围（如 `cs"'` 把双引号换成单引号） |
| `ds<char>` | **删除**包围（如 `ds"` 删掉双引号） |
| `S<char>`（visual mode） | 给选中区域加包围 |

### Comment.nvim

| 快捷键 | 效果 |
|---|---|
| `gcc` | 切换当前行注释 |
| `gc<motion>` | 切换 motion 范围注释（如 `gcap` 注释整段） |
| `gc`（visual mode） | 注释选中区域 |
| `gbc` | 块注释（`/* */` 风格） |

### nvim-autopairs

自动配对括号、引号。无快捷键，输入 `(`/`{`/`[`/`"` 自动补齐右边。

### nvim-treesitter

语法高亮 + 缩进。包含的语言：json/js/ts/tsx/yaml/html/css/markdown/rust/zig/svelte/graphql/bash/lua/vim/dockerfile 等。

| 快捷键 | 效果 |
|---|---|
| `<C-space>` | Treesitter 增量选择（扩到父节点） |
| `<bs>`（visual） | 缩到子节点 |

### nvim-treesitter-text-objects

按语法树定义文本对象——`f` = function, `c` = class 等。

| 快捷键 | 效果 |
|---|---|
| `vaf` / `vif` | 选中整个 / 函数体 |
| `vac` / `vic` | 选中整个 / 类体 |
| `daf` | 删整个函数 |

### vim-maximizer

| 快捷键 | 效果 |
|---|---|
| `<leader>sm` | **最大化 / 还原**当前 split |

按一次让当前窗口占满屏，再按一次还原所有 splits。

### mini.animate

平滑动画。无快捷键：
- 光标移动 80ms 过渡
- `Ctrl-d`/`u`/`gg`/`G` 大幅滚动 100ms 动画
- 鼠标滚轮**不**触发动画
- 窗口 resize 也带动画

---

## LSP / 语言支持

### Mason

LSP 服务器和工具的安装管理器。

| 命令 | 效果 |
|---|---|
| `:Mason` | 打开 mason UI |
| `:MasonInstall <pkg>` | 装一个 |
| `:MasonUpdate` | 更新所有 |

**自动安装：** pyright、html、cssls、ts_ls、jsonls、lua_ls、**zls**、stylua、black、isort、pylint、eslint_d、prettier。

### nvim-lspconfig

LSP 客户端 + 通用快捷键。光标在代码上时：

| 快捷键 | 效果 |
|---|---|
| `gd` | 跳到定义 |
| `gD` | 跳到声明 |
| `gR` | 显示所有引用 |
| `gi` | 跳到实现 |
| `gt` | 跳到类型定义 |
| `K` | **悬浮显示文档**（lspsaga，按两次进入窗口） |
| `<leader>ca` | 显示可用 code actions |
| `<leader>rn` | LSP 重命名 |
| `<leader>d` | 显示当前行诊断 |
| `<leader>D` | 当前 buffer 诊断列表 |
| `[d` / `]d` | 上一个 / 下一个诊断 |
| `<leader>rs` | 重启 LSP |

### lspsaga

更漂亮的 LSP UI。

| 快捷键 | 效果 |
|---|---|
| `K` | hover 文档（圆角浮窗） |
| **`K` 再按一次** | 进入 hover 窗口（可滚动 / 复制文字） |
| `<C-f>` / `<C-b>` | hover 浮窗存在时滚动它；不存在时正常翻页 |
| `q`（hover 窗口内） | 关闭 |

### nvim-cmp

代码补全弹出菜单。

| 快捷键 | 效果 |
|---|---|
| `<C-n>` / `<C-p>` | 下一个 / 上一个补全项 |
| `<CR>` | 确认补全 |
| `<C-Space>` | 手动触发补全 |
| `<C-e>` | 取消 |

### none-ls / formatting / linting

格式化和静态检查（black/prettier/eslint_d/pylint 等）。

| 快捷键 | 效果 |
|---|---|
| `<leader>mp` | 格式化当前文件（如有配置） |

### rustaceanvim

Rust 专属增强（rust-analyzer 进阶配置 + DAP 支持）。

| 快捷键 | 效果 |
|---|---|
| `K` | 文档悬浮（用 lspsaga） |
| `<leader>ha` | Rust hover actions（go to trait/impl） |
| 标准 LSP 快捷键（`gd`/`gR`/`<leader>ca` 等） | 同上 |

---

## Git

### gitsigns

显示 git 状态。**signs gutter** 自动显示 +/-/~ 符号。无自定义快捷键（用默认），常用：

| 命令 | 效果 |
|---|---|
| `]c` / `[c` | 下一个 / 上一个变更 hunk |
| `:Gitsigns preview_hunk` | 预览当前 hunk |
| `:Gitsigns blame_line` | 当前行 blame |
| `:Gitsigns toggle_current_line_blame` | 切换内联 blame |

---

## 终端与会话

### toggleterm

| 快捷键 | 效果 |
|---|---|
| `<leader>t` | 切换 / 打开终端 |

终端内 `jk` 退出 terminal mode，再 `<C-h/j/k/l>` 跳到其他 split。

### auto-session

自动保存 / 恢复 session（每个 cwd 一个）。

| 快捷键 | 效果 |
|---|---|
| `<leader>wr` | 恢复当前目录的 session |
| `<leader>ws` | 保存当前目录的 session |

---

## AI / 协作

### claude-code.nvim

在 nvim 内集成 Claude Code CLI。

| 快捷键 | 效果 |
|---|---|
| `<leader>cc` | 打开 / 关闭 Claude 侧边栏（垂直 split，40% 宽） |
| `<leader>cC` | 继续上次会话 |
| `<leader>cr` | 选择并恢复历史会话 |
| `:ClaudeCode` | 命令行启动 |
| `:ClaudeCodeVerbose` | verbose 模式（看请求详情） |

**前置：** 系统装好 `claude` CLI（`npm install -g @anthropic-ai/claude-code`）。

---

## Markdown / 文档

### render-markdown.nvim

只在 `.md` / Avante / codecompanion buffer 激活：
- H1-H6 标题：不同图标 + 背景色
- 代码块：`thick` 边框 + 左右内边距
- 列表项：`-` 渲染成 `●○◆◇`
- `- [ ]` / `- [x]`：漂亮复选框
- 表格：完整边框
- 链接 / 图片 / 邮件：带图标

无快捷键，自动渲染。

---

## 摸鱼专区 🎮

### cellular-automaton.nvim

把当前 buffer 的字符喂给元胞自动机。

| 快捷键 | 效果 |
|---|---|
| `<leader>fml` | **Make it rain** —— 代码字符像下雨一样飘落 |
| `<leader>fmg` | **Game of Life** —— Conway 生命游戏演化 |
| `<leader>fms` | **Scramble** —— 字符随机洗牌 |

按任意键退出动画。`fml` 是官方默认（"Fuck My Life"）。

### duck.nvim

屏幕里养小动物。

| 快捷键 | 效果 |
|---|---|
| `<leader>dd` | 召唤一只 🦆，速度 5 |
| `<leader>dc` | 召唤一只 🐈，速度 10 |
| `<leader>dk` | 干掉**最近的**一只 |
| `<leader>da` | 干掉所有 |

可反复 `<leader>dd` 召唤一群鸭子挤满屏幕。

### codesnap.nvim

把代码渲染成漂亮的截图（圆角、macOS 窗口栏、行号）。

| 快捷键（visual mode 选中代码后） | 效果 |
|---|---|
| `<leader>cs` | 截图复制到剪贴板（直接 Cmd+V 粘贴到 Slack/Twitter 等） |
| `<leader>cS` | 截图保存到 `~/Pictures/CodeSnaps/` |
| `<leader>ch` | 带高亮的截图 |

**前置：** 首次安装会自动 `make build_generator`（需要 Rust toolchain）。

### zen-mode.nvim

沉浸式编辑——隐藏所有干扰，代码居中。

| 快捷键 | 效果 |
|---|---|
| `<leader>zz` | 切换 Zen 模式 |

效果：当前 buffer 居中（120 列宽）+ 关行号 / signcolumn / cursorline / 状态栏 + 周围背景变暗 95%。

---

## 主题

当前：**oxocarbon**（IBM Carbon 风，蓝紫冷色调）。配置在 [colorscheme.lua](lua/johnlyon/plugins/colorscheme.lua)。

切换主题：直接改 `vim.cmd.colorscheme(...)` 那行；或临时 `:colorscheme <name>` 试用。

---

## 速查表（最常用 30 个）

| 操作 | 快捷键 |
|---|---|
| 退出插入模式 | `jk` |
| 清搜索高亮 | `<leader>nh` |
| 文件树切换 | `<leader>ee` |
| 项目内查找文件 | `<leader>ff` |
| 项目内全文搜索 | `<leader>fs` |
| 屏幕内跳转 | `s` + 1-2 字符 |
| 跳定义 | `gd` |
| 显示文档 | `K` |
| 重命名符号 | `<leader>rn` |
| Code action | `<leader>ca` |
| 上 / 下个诊断 | `[d` / `]d` |
| 上 / 下个 buffer | `H` / `L` |
| 关 buffer | `<leader>bx` |
| 切换终端 | `<leader>t` |
| Mark 文件 | `<leader>hm` |
| 跳到 mark | `<leader>hn` / `<leader>hp` |
| 注释整行 | `gcc` |
| 包裹 | `ys<motion><char>` |
| 最大化 split | `<leader>sm` |
| 垂直 / 水平分屏 | `<leader>sv` / `<leader>sh` |
| Zen 模式 | `<leader>zz` |
| 召唤鸭子 | `<leader>dd` |
| 代码下雨 | `<leader>fml` |
| Claude Code | `<leader>cc` |
| 截图代码（visual） | `<leader>cs` |
| 跳到行首 / 行尾 | `<leader>q` / `<leader>p` |
| 数字 +1 / -1 | `<leader>+` / `<leader>-` |
| 恢复 session | `<leader>wr` |
| Increment 选择 | `<C-space>` |
| 文档面包屑跳转 | `<leader>D` |
