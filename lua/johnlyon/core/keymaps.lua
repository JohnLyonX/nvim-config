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
keymap.set("n", "H", "<cmd>bprevious<CR>", { desc = "Go to previous buffer" })
keymap.set("n", "L", "<cmd>bnext<CR>", { desc = "Go to next buffer" })
keymap.set("n", "<leader>bx", "<cmd>bdelete!<CR>", { desc = "Close current buffer" })
keymap.set("n", "<leader>box", "<cmd>%bd|e#|bd#<CR>", { desc = "Close all buffers except current" })

-- 退出 nvim
keymap.set("n", "<leader>qq", "<cmd>qa!<CR>", { desc = "Quit all (force, discard changes)" })
keymap.set("n", "<leader>qw", "<cmd>xa<CR>",  { desc = "Save changed + quit all" })
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
