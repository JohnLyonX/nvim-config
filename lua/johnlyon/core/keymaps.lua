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
keymap.set("n", "<leader>stv", function()
	vim.cmd("vsplit | terminal")
end, { desc = "Split window vertically and open terminal" })
keymap.set("n", "<leader>sth", function()
	vim.cmd("split | terminal")
end, { desc = "Split window horizontally and open terminal" })
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

-- open terminal in a bottom split (ctrl-\ ctrl-n to exit terminal mode)
keymap.set("n", "<leader>stt", function()
	vim.cmd("botright 15split | terminal")
end, { desc = "Open bottom terminal split" })

keymap.set("n", "<leader>to", "<cmd>tabnew<CR>", { desc = "Open new tab" }) -- open new tab
keymap.set("n", "<leader>tx", "<cmd>tabclose<CR>", { desc = "Close current tab" }) -- close current tab
keymap.set("n", "<leader>tn", "<cmd>tabn<CR>", { desc = "Go to next tab" }) --  go to next tab
keymap.set("n", "<leader>tp", "<cmd>tabp<CR>", { desc = "Go to previous tab" }) --  go to previous tab
keymap.set("n", "<leader>tf", "<cmd>tabnew %<CR>", { desc = "Open current buffer in new tab" }) --  move current buffer to new tab

-- buffer management
keymap.set("n", "H", "<cmd>bprevious<CR>", { desc = "Go to previous buffer" })
keymap.set("n", "L", "<cmd>bnext<CR>", { desc = "Go to next buffer" })
keymap.set("n", "<leader>bx", "<cmd>bdelete!<CR>", { desc = "Close current buffer" })
keymap.set("n", "<leader>box", "<cmd>%bd|e#|bd#<CR>", { desc = "Close all buffers except current" })

-- first and last
keymap.set("n", "<leader>p", "$")
keymap.set("n", "<leader>q", "0")

-- gs: go to line start, gl: go to line end
keymap.set({ "n", "v" }, "gs", "^", { desc = "Go to first non-blank character of line" })
keymap.set({ "n", "v" }, "gl", "$", { desc = "Go to end of line" })
