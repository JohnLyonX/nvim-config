return {
  "akinsho/toggleterm.nvim",
  version = "*",
  cmd = { "ToggleTerm", "TermExec", "TermSelect" },
  keys = {
    { "<leader>t",  desc = "Toggle floating terminal" },
    { "<leader>th", desc = "Toggle bottom terminal" },
    { "<leader>tv", desc = "Toggle right terminal" },
    { "<leader>tn", desc = "Split current terminal into a new pane" },
    { "<leader>tr", desc = "Rename current terminal" },
    { "<leader>tl", desc = "List/select terminals" },
    { "<leader>tk", desc = "Kill current terminal" },
  },
  config = function()
    require("toggleterm").setup({
      -- 三种 direction 各自合理的尺寸：
      --   horizontal → 行数；vertical → 列数；float → 兜底
      size = function(term)
        if term.direction == "horizontal" then
          return 15
        elseif term.direction == "vertical" then
          return math.floor(vim.o.columns * 0.4)
        end
        return 20
      end,
      open_mapping = [[<leader>t]], -- 浮动终端入口（自带 count 支持：N<leader>t = 第 N 个浮动终端）
      insert_mappings = false,
      direction = "float",
      float_opts = { border = "curved" },
      persist_size = true,
      persist_mode = true,
    })

    -- 主终端：底部 + 右侧各一个，由 toggleterm 管理（带防误触保护）
    -- display_name 用于 :TermSelect 和我们自定义的 <leader>tl 列表
    local Terminal = require("toggleterm.terminal").Terminal
    local h_term = Terminal:new({ direction = "horizontal", hidden = true, display_name = "bottom" })
    local v_term = Terminal:new({ direction = "vertical",   hidden = true, display_name = "right"  })

    vim.keymap.set("n", "<leader>th", function() h_term:toggle() end,
      { desc = "Toggle bottom terminal" })
    vim.keymap.set("n", "<leader>tv", function() v_term:toggle() end,
      { desc = "Toggle right terminal" })

    -- <leader>tn：在终端窗口里追加一个"对垂直方向"的新 pane
    --   底部（horizontal）终端里按 → vsplit 出右边的新 pane（tmux 风）
    --   右侧（vertical）终端里按   → split  出下方的新 pane
    -- 这些追加的 pane 是裸 :terminal，不被 toggleterm 管理；
    -- 但下方的 TermOpen autocmd 会给它们加 <C-w>o 防护。
    vim.keymap.set("n", "<leader>tn", function()
      if vim.bo.buftype ~= "terminal" then
        vim.notify("Open <leader>th or <leader>tv first, then split inside it",
          vim.log.levels.WARN)
        return
      end
      local win = vim.api.nvim_get_current_win()
      local w = vim.api.nvim_win_get_width(win)
      -- 占据整个终端宽度大半（横向终端在底部）→ 沿垂直线劈开（vsplit）
      -- 否则视为纵向终端 → 沿水平线劈开（split）
      if w > vim.o.columns * 0.6 then
        vim.cmd("rightbelow vsplit | terminal")
      else
        vim.cmd("rightbelow split | terminal")
      end
    end, { desc = "Split current terminal into a new pane" })

    -- 列出所有 terminal buffer（含 toggleterm 主终端 + 裸 split 的 pane）
    -- 显示优先级：
    --   1) 用户用 <leader>tr 重命名过 → 直接显示自定义名
    --   2) toggleterm 主终端 → 显示 display_name (direction)
    --   3) 兜底 → 解析 term:// URL 取 shell 名
    vim.keymap.set("n", "<leader>tl", function()
      local tt_map = {}
      for _, t in ipairs(require("toggleterm.terminal").get_all()) do
        if t.bufnr then tt_map[t.bufnr] = t end
      end

      local terms = {}
      for _, buf in ipairs(vim.api.nvim_list_bufs()) do
        if vim.api.nvim_buf_is_loaded(buf) and vim.bo[buf].buftype == "terminal" then
          local bufname = vim.api.nvim_buf_get_name(buf)
          local tt = tt_map[buf]
          local label
          if not bufname:match("^term://") then
            label = bufname -- 用户已 :file 重命名
          elseif tt and tt.display_name and tt.display_name ~= "" then
            label = string.format("%s (%s)", tt.display_name, tt.direction)
          else
            local cmd = bufname:match(":([^:/]+)$") or "shell"
            label = "term: " .. cmd
          end
          table.insert(terms, {
            buf = buf,
            label = string.format("[%d] %s", buf, label),
          })
        end
      end

      if #terms == 0 then
        vim.notify("No terminals open", vim.log.levels.INFO)
        return
      end
      vim.ui.select(terms, {
        prompt = "Select terminal: ",
        format_item = function(t) return t.label end,
      }, function(choice)
        if not choice then return end
        -- 找一个已经显示该 buffer 的窗口；若没有就在当前窗口切过去
        for _, win in ipairs(vim.api.nvim_list_wins()) do
          if vim.api.nvim_win_get_buf(win) == choice.buf then
            vim.api.nvim_set_current_win(win)
            return
          end
        end
        vim.api.nvim_set_current_buf(choice.buf)
      end)
    end, { desc = "List/select terminals" })

    -- 重命名当前终端 buffer（弹输入框，确认后用 :file 设置 buffer 名）
    -- 命名后，<leader>tl 列表里就能看到自定义名字（如 "claude" / "cargo-watch"）
    vim.keymap.set("n", "<leader>tr", function()
      if vim.bo.buftype ~= "terminal" then
        vim.notify("Not in a terminal buffer", vim.log.levels.WARN)
        return
      end
      vim.ui.input({ prompt = "Rename terminal: " }, function(name)
        if name and name ~= "" then
          -- :file 会改变 buffer 名；fnameescape 处理特殊字符
          vim.cmd("file " .. vim.fn.fnameescape(name))
        end
      end)
    end, { desc = "Rename current terminal" })

    -- 杀掉当前终端 buffer
    vim.keymap.set("n", "<leader>tk", function()
      if vim.bo.buftype ~= "terminal" then
        vim.notify("Not in a terminal buffer", vim.log.levels.WARN)
        return
      end
      vim.cmd("bdelete!")
    end, { desc = "Kill current terminal" })

    -- 给所有 :terminal 打开的 buffer（含裸 split 出的 pane）做两件事：
    --   1) 设为 unlisted，避免出现在 bufferline / :ls 列表（终端走 <leader>tl 管理）
    --   2) 禁止 <C-w>o / <C-w>O 把当前窗口设为唯一窗口（终端被"全屏化"的元凶）
    vim.api.nvim_create_autocmd("TermOpen", {
      group = vim.api.nvim_create_augroup("johnlyon_term_protect", { clear = true }),
      callback = function(args)
        vim.bo[args.buf].buflisted = false
        local opts = { buffer = args.buf, silent = true }
        vim.keymap.set("t", "<C-w>o", "<Nop>", opts)
        vim.keymap.set("t", "<C-w>O", "<Nop>", opts)
        vim.keymap.set("n", "<C-w>o", "<Nop>", opts)
        vim.keymap.set("n", "<C-w>O", "<Nop>", opts)
      end,
    })
  end,
}
