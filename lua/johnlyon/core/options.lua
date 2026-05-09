local opt = vim.opt -- for conciseness

-- line numbers
opt.relativenumber = true -- show relative line numbers
opt.number = true -- shows absolute line number on cursor line (when relative number is on)

-- tabs & indentation
opt.tabstop = 2 -- 2 spaces for tabs (prettier default)
opt.shiftwidth = 2 -- 2 spaces for indent width
opt.expandtab = true -- expand tab to spaces
opt.autoindent = true -- copy indent from current line when starting new one

-- line wrapping
opt.wrap = false -- disable line wrapping

-- search settings
opt.ignorecase = true -- ignore case when searching
opt.smartcase = true -- if you include mixed case in your search, assumes you want case-sensitive

-- cursor line
opt.cursorline = true -- highlight the current cursor line

-- appearance

-- turn on termguicolors for nightfly colorscheme to work
-- (have to use iterm2 or any other true color terminal)
opt.termguicolors = true
opt.background = "dark" -- colorschemes that can be light or dark will be made dark
opt.signcolumn = "yes" -- show sign column so that text doesn't shift

-- backspace
opt.backspace = "indent,eol,start" -- allow backspace on indent, end of line or insert mode start position

-- clipboard (deferred to avoid macOS pbcopy detection cost at startup)
vim.schedule(function()
  opt.clipboard:append("unnamedplus")
end)

-- split windows
opt.splitright = true -- split vertical window to the right
opt.splitbelow = true -- split horizontal window to the bottom

-- turn off swapfile
opt.swapfile = false

-- 隐藏底部命令行区域（cmdline 由 noice.nvim 接管，浮动窗口显示）
opt.cmdheight = 0

-- 禁止鼠标拖拽 statusline / 窗口分隔条改变窗口大小
-- 保留点击与滚轮，仅屏蔽 LeftDrag（这是 Neovim 改窗口尺寸的内建行为）
vim.keymap.set({ "n", "i", "v", "c", "t" }, "<LeftDrag>", "<LeftMouse>", { silent = true })

-- 内置终端打开后立即进入 insert 模式，避免 normal 模式误吞按键
vim.api.nvim_create_autocmd("TermOpen", {
  group = vim.api.nvim_create_augroup("johnlyon_term", { clear = true }),
  callback = function()
    vim.opt_local.number = false
    vim.opt_local.relativenumber = false
    vim.opt_local.signcolumn = "no"
    vim.cmd("startinsert")
  end,
})

-- 切回已有终端 buffer 时也自动进 insert
vim.api.nvim_create_autocmd("BufEnter", {
  group = "johnlyon_term",
  pattern = "term://*",
  command = "startinsert",
})

-- ─────────────────────────────────────────────────────────────────────────────
-- nvim 0.12 LSP pull diagnostics 的 TOCTOU 竞态修补
-- ─────────────────────────────────────────────────────────────────────────────
-- 现象:rust-analyzer / 其他 LSP 在分析过程中,如果 buffer 被 wipe(关 buffer、
-- 退出 nvim、:%bd 等),稍后到达的 textDocument/diagnostic 响应会触发:
--
--   diagnostic.lua:296: attempt to index local 'bufstate' (a nil value)
--
-- 原因:_refresh() 发出 LSP 请求 → 几百 ms 内 buffer 被 wipe →
-- on_detach autocmd 清掉 bufstates[bufnr] → 响应抵达 on_diagnostic →
-- 上游函数没做 nil 检查就 bufstate.client_result_id[key] = ... → 崩
--
-- 该 bug 在 v0.12.2 / master 都未修(GitHub 全站搜不到对应 issue)。
-- 我们包一层,在 buffer 已死时直接丢弃响应,这本来就是正确处理方式。
--
-- 上游修复后可整段删除。参考源码:
--   https://github.com/neovim/neovim/blob/v0.12.2/runtime/lua/vim/lsp/diagnostic.lua#L296
-- ─────────────────────────────────────────────────────────────────────────────

-- 层 1:覆写 on_diagnostic（处理 textDocument/diagnostic 响应,主战场）
-- 用 pcall 整个包住原函数:不仅 buffer wipe 这一种 race,只要任何路径让
-- bufstate 提前变 nil(LspDetach、LSP 断开重连、workspace 与 document 模式切换
-- 等),都会被静默吞掉。其它非这个 bug 的错误会重新抛出,不影响调试。
do
  local diag = vim.lsp.diagnostic
  local original = diag.on_diagnostic
  diag.on_diagnostic = function(err, result, ctx)
    -- 第一道防线:buffer 已无效直接丢弃,连 pcall 都省了
    if not ctx or not ctx.bufnr or not vim.api.nvim_buf_is_valid(ctx.bufnr) then
      return
    end
    -- 第二道防线:用 pcall 兜住"bufstate 为 nil"这类边缘 race
    local ok, lua_err = pcall(original, err, result, ctx)
    if ok then return end
    -- 只吞掉已知的 bufstate nil 错误,其它真正的错误重新抛出
    if type(lua_err) == "string"
        and (lua_err:match("bufstate")
          or lua_err:match("client_result_id")
          or lua_err:match("attempt to index local")) then
      return
    end
    error(lua_err)
  end
end

-- 层 2:覆写 on_refresh(处理 workspace/diagnostic/refresh,防止同类 race)
do
  local diag = vim.lsp.diagnostic
  local original = diag.on_refresh
  diag.on_refresh = function(err, result, ctx)
    if not ctx or not ctx.client_id then
      return vim.NIL
    end
    local ok = pcall(original, err, result, ctx)
    if not ok then return vim.NIL end
  end
end
