-- set leader key to space
vim.g.mapleader = " "

local keymap = vim.keymap -- for conciseness

---------------------
-- General Keymaps -------------------

-- use jk to exit insert mode
keymap.set("i", "jk", "<ESC>", { desc = "Exit insert mode with jk" })
keymap.set("t", "jk", [[<C-\><C-n>]], { desc = "Exit terminal mode with jk" })

-- clear search highlights
keymap.set("n", "<leader>nh", ":nohl<CR>", { desc = "Clear search highlights" })

-- delete single character without copying into register
-- keymap.set("n", "x", '"_x')

-- increment/decrement numbers
keymap.set("n", "<leader>+", "<C-a>", { desc = "Increment number" }) -- increment
keymap.set("n", "<leader>-", "<C-x>", { desc = "Decrement number" }) -- decrement

-- window management
keymap.set("n", "<leader>sv", "<c-w>v", { desc = "Split window vertically" }) -- split window vertically
keymap.set("n", "<leader>sh", "<C-w>s", { desc = "Split window horizontally" }) -- split window horizontally
keymap.set("t", "<C-h>", [[<C-\><C-n><C-w>h]], { desc = "Move to left split from terminal" })
keymap.set("t", "<C-j>", [[<C-\><C-n><C-w>j]], { desc = "Move to lower split from terminal" })
keymap.set("t", "<C-k>", [[<C-\><C-n><C-w>k]], { desc = "Move to upper split from terminal" })
keymap.set("t", "<C-l>", [[<C-\><C-n><C-w>l]], { desc = "Move to right split from terminal" })
-- 注：原 <leader>stv / <leader>sth / <leader>stt（裸 :split | terminal）
-- 已删除，统一由 toggleterm 管理：
--   <leader>t   浮动终端
--   <leader>th  底部水平持久终端
--   <leader>tv  右侧垂直持久终端
local function make_resize_mode(is_height)
  return function()
    local inc_cmd = is_height and "resize +2" or "vertical resize +2"
    local dec_cmd = is_height and "resize -2" or "vertical resize -2"
    local label = is_height and "HEIGHT" or "WIDTH"

    vim.api.nvim_echo(
      { { "-- RESIZE " .. label .. " -- (= increase  - decrease  other key: exit)", "MoreMsg" } },
      false, {}
    )

    while true do
      local char = vim.fn.getcharstr()
      if char == "=" then
        vim.cmd(inc_cmd)
        vim.cmd("redraw")
      elseif char == "-" then
        vim.cmd(dec_cmd)
        vim.cmd("redraw")
      else
        vim.fn.feedkeys(char, "n")
        break
      end
    end

    vim.api.nvim_echo({ { "", "Normal" } }, false, {})
  end
end

keymap.set("n", "<leader>swh", make_resize_mode(true), { desc = "Resize window height mode" })
keymap.set("n", "<leader>swv", make_resize_mode(false), { desc = "Resize window width mode" })
keymap.set("n", "<leader>se", "<C-w>=", { desc = "Make splits equal size" }) -- make split windows equal width & height
keymap.set("n", "<leader>sx", "<cmd>close<CR>", { desc = "Close current split" }) -- close current split window

keymap.set("n", "<leader>to", "<cmd>tabnew<CR>", { desc = "Open new tab" }) -- open new tab
keymap.set("n", "<leader>tx", "<cmd>tabclose<CR>", { desc = "Close current tab" }) -- close current tab
keymap.set("n", "<leader>tf", "<cmd>tabnew %<CR>", { desc = "Open current buffer in new tab" }) --  move current buffer to new tab
-- 注：原 <leader>tn / <leader>tp（tabnext / tabprev）已删除，
-- 让位给 toggleterm 的 <leader>tn（追加终端 pane）。
-- 如需 tab 切换，用 :tabn / :tabp 命令。

-- buffer management
-- H / L 切 buffer 时，如果光标在终端 / tree / 浮窗等特殊 buffer 里，
-- 先切到第一个普通文件 buffer 的窗口再切 —— 否则 :bnext/bprev 会把终端 buffer
-- 替换成代码文件，终端"消失"。
local function smart_buffer_switch(cmd)
  return function()
    if vim.bo.buftype ~= "" then
      for _, win in ipairs(vim.api.nvim_tabpage_list_wins(0)) do
        local cfg = vim.api.nvim_win_get_config(win)
        if cfg.relative == "" then
          local buf = vim.api.nvim_win_get_buf(win)
          if vim.bo[buf].buftype == "" then
            vim.api.nvim_set_current_win(win)
            break
          end
        end
      end
    end
    vim.cmd(cmd)
  end
end
keymap.set("n", "H", smart_buffer_switch("bprevious"), { desc = "Go to previous buffer" })
keymap.set("n", "L", smart_buffer_switch("bnext"),     { desc = "Go to next buffer" })
-- 关闭 buffer 的 IDE 风行为：
--   - 优先把当前窗口切到「左邻」buffer，没有左邻就切到「右邻」
--   - 都没有 → 关掉后展示 alpha 启动页（不让窗口变空 / tree 撑满）
-- 同时给 bufferline 的 X / 右键复用（见 bufferline.lua），所以挂全局名字。
_G.SmartBufferClose = function(target_buf)
  target_buf = target_buf or vim.api.nvim_get_current_buf()

  -- 取所有"真文件 buffer"（listed + buftype == ""），按 buffer id 顺序
  -- 这就是 bufferline 默认的展示顺序
  local bufs = vim.tbl_filter(function(b)
    return vim.api.nvim_buf_is_loaded(b)
       and vim.bo[b].buflisted
       and vim.bo[b].buftype == ""
  end, vim.api.nvim_list_bufs())

  -- 找目标 buffer 在列表里的位置
  local idx
  for i, b in ipairs(bufs) do
    if b == target_buf then idx = i; break end
  end

  -- 不在 listed file buffer 里（终端 / 特殊 buffer）→ 直接删
  if not idx then
    pcall(vim.api.nvim_buf_delete, target_buf, { force = true })
    return
  end

  -- 优先左邻，再右邻
  local replacement = bufs[idx - 1] or bufs[idx + 1]

  -- 当前显示该 buffer 的所有窗口都先切到 replacement（没有就先放个空 buffer）
  -- 同时记一下「编辑器窗口」—— 后面 alpha 兜底要落到这里，而不是当前焦点
  -- （bufferline 的 X / 右键关 buffer 时，焦点可能在 tree 上）
  local editor_win
  for _, win in ipairs(vim.api.nvim_list_wins()) do
    if vim.api.nvim_win_get_buf(win) == target_buf then
      if replacement then
        vim.api.nvim_win_set_buf(win, replacement)
      else
        local empty = vim.api.nvim_create_buf(false, true)
        vim.api.nvim_win_set_buf(win, empty)
        editor_win = editor_win or win
      end
    end
  end

  pcall(vim.api.nvim_buf_delete, target_buf, { force = true })

  -- 没有 replacement → 在编辑器窗口展示 alpha 启动页
  -- alpha.start(false) 会无脑灌进 current window，所以先把焦点切过去
  if not replacement then
    -- 优先用 bufferline.lua init 里跟踪的 vim.g.main_win（最近一次进过的真文件窗口）
    if not (editor_win and vim.api.nvim_win_is_valid(editor_win))
       and vim.g.main_win and vim.api.nvim_win_is_valid(vim.g.main_win) then
      editor_win = vim.g.main_win
    end
    -- 兜底：target_buf 不在任何窗口（关 hidden buffer）且 main_win 也无效
    -- → 在当前 tab 找一个非 tree / 非终端 / 非浮窗的真窗口
    if not (editor_win and vim.api.nvim_win_is_valid(editor_win)) then
      for _, win in ipairs(vim.api.nvim_tabpage_list_wins(0)) do
        local cfg = vim.api.nvim_win_get_config(win)
        if cfg.relative == "" then
          local b = vim.api.nvim_win_get_buf(win)
          local bt = vim.bo[b].buftype
          local ft = vim.bo[b].filetype
          if bt ~= "terminal" and ft ~= "NvimTree" then
            editor_win = win
            break
          end
        end
      end
    end
    if editor_win and vim.api.nvim_win_is_valid(editor_win) then
      vim.api.nvim_set_current_win(editor_win)
    end
    pcall(function() require("alpha").start(false) end)
  end
end

keymap.set("n", "<leader>bx", function() _G.SmartBufferClose() end,
  { desc = "Close current buffer (smart: prev → next → alpha)" })
keymap.set("n", "<leader>box", "<cmd>%bd|e#|bd#<CR>", { desc = "Close all buffers except current" })

-- 退出 nvim
keymap.set("n", "<leader>qq", "<cmd>qa!<CR>", { desc = "Quit all (force, discard changes)" })
keymap.set("n", "<leader>qw", "<cmd>xa!<CR>", { desc = "Save changed + force quit all (kill terminals)" })
keymap.set("n", "<leader>qs", "<cmd>qa<CR>",  { desc = "Safe quit all (warn if unsaved)" })

-- gs: go to line start, gl: go to line end
keymap.set({ "n", "v" }, "gs", "^", { desc = "Go to first non-blank character of line" })
keymap.set({ "n", "v" }, "gl", "$", { desc = "Go to end of line" })

-- ge: go to end of file (pairs with gg: go to start of file)
keymap.set({ "n", "v" }, "ge", "G", { desc = "Go to end of file" })

-- select all (line-wise visual)
keymap.set("n", "<C-a>", "ggVG", { desc = "Select all (line-wise)" })

-- disable <C-k> digraph in insert mode (误触避免插入 ^K)
keymap.set("i", "<C-k>", "<Nop>", { desc = "Disable Ctrl+K digraph" })

-- macOS Cmd 键映射:Ghostty 通过 kitty 键盘协议把 cmd+key 传给 nvim 为 <D-*>,
-- 若不显式映射,在 insert 模式下会被作为字面字符插入(如 <D-s> 五个字符)。
-- 这里把常用 cmd 组合统一处理,并在所有相关模式下覆盖。
local cmd_map = function(lhs, rhs_n, rhs_i, rhs_v, desc)
  if rhs_n then keymap.set("n", lhs, rhs_n, { desc = desc, silent = true }) end
  if rhs_i then keymap.set("i", lhs, rhs_i, { desc = desc, silent = true }) end
  if rhs_v then keymap.set("v", lhs, rhs_v, { desc = desc, silent = true }) end
end

-- Cmd+S 保存
cmd_map("<D-s>", "<cmd>silent! write<CR>", "<Esc><cmd>silent! write<CR>", "<Esc><cmd>silent! write<CR>", "Save file")
-- Cmd+Z 撤销 / Cmd+Shift+Z 重做
cmd_map("<D-z>", "u", "<C-o>u", "<Esc>u", "Undo")
cmd_map("<D-Z>", "<C-r>", "<C-o><C-r>", "<Esc><C-r>", "Redo")
-- Cmd+C 复制(visual 复制到系统剪贴板)/ Cmd+X 剪切
cmd_map("<D-c>", nil, nil, '"+y', "Copy to clipboard")
cmd_map("<D-x>", nil, nil, '"+d', "Cut to clipboard")
-- Cmd+V 粘贴(从系统剪贴板)
cmd_map("<D-v>", '"+p', "<C-r>+", '"+p', "Paste from clipboard")
-- Cmd+A 全选
cmd_map("<D-a>", "ggVG", "<Esc>ggVG", "<Esc>ggVG", "Select all")
-- 兜底:其他 cmd 组合在 insert 模式下不要被插入为字面文本
for _, key in ipairs({ "q", "w", "e", "r", "t", "y", "u", "i", "o", "p",
                      "d", "f", "g", "h", "j", "k", "l",
                      "b", "n", "m", "0", "1", "2", "3", "4", "5", "6", "7", "8", "9" }) do
  keymap.set("i", "<D-" .. key .. ">", "<Nop>", { desc = "Disable Cmd+" .. key .. " in insert" })
end
