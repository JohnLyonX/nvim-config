return {
  "rmagatti/auto-session",
  lazy = false, -- 必须启动时加载，才能挂上 VimEnter / VimLeave 钩子
  config = function()
    -- sessionoptions 决定 session 文件里保存哪些状态。
    -- ⚠️ 不要 localoptions：会把 filetype 当本地选项直接还原，绕过 FileType 自动命令 → treesitter 不接管。
    -- ⚠️ 不要 terminal：vim 没法重启终端进程，恢复出来全是僵尸 buffer。
    -- ✅ 加 globals：保存大写开头的 vim.g.* 变量，用来跨重启传递「上次底部终端是否在跑」这种状态位。
    vim.o.sessionoptions = "blank,buffers,curdir,folds,help,tabpages,winsize,globals"

    local auto_session = require("auto-session")

    auto_session.setup({
      auto_save_enabled = true,
      auto_restore_enabled = true,
      auto_session_suppress_dirs = { "~/", "~/Dev/", "~/Downloads", "~/Documents", "~/Desktop/" },
      auto_restore_lazy_delay_enabled = false,

      -- 保存前：「记录」当前是否有底部终端在跑，标记到 vim.g.HadBottomTerm。
      -- ⚠️ 不要在这里删终端 buffer：sessionoptions 没有 'terminal'，vim 本来就
      --    不会把终端写进 session。手动 :SessionSave 时若强删，会误杀正在用的 shell。
      pre_save_cmds = {
        function()
          local had_bottom = false
          for _, buf in ipairs(vim.api.nvim_list_bufs()) do
            if vim.api.nvim_buf_is_loaded(buf) and vim.bo[buf].buftype == "terminal" then
              local name = vim.api.nvim_buf_get_name(buf)
              local basename = vim.fn.fnamemodify(name, ":t")
              if basename == "bottom" then had_bottom = true end
            end
          end
          -- vim 只持久化「大写开头 + 含小写字母 + String/Number」的 vim.g 变量
          vim.g.HadBottomTerm = had_bottom and 1 or 0

          -- 清掉无意义的孤儿 globals，避免污染 session 文件：
          --   NvimTreeSetup / NvimTreeRequired 是 nvim-tree 内部 marker，每次启动会重置
          --   HadClaudeCode 是已删除插件留下的旧标记
          vim.g.NvimTreeSetup = nil
          vim.g.NvimTreeRequired = nil
          vim.g.HadClaudeCode = nil
        end,
      },

      -- 恢复后：
      --   1) 兜底清掉残留的终端 buffer
      --   2) 对每个文件 buffer 重新 fire FileType —— treesitter / LSP 都借此挂载
      --   3) 打开 nvim-tree（alpha 那边的 VimEnter 已经被守卫绕过，layout 由这里统一负责）
      --   4) 上次开着的底部终端，恢复后开新的回来
      -- 顺序固定避免和 alpha 的 schedule race（race 会造成右栏多一个孤儿编辑器列）。
      -- 用 vim.schedule 推迟一拍，等 session 把所有 buffer / window 都铺好。
      post_restore_cmds = {
        function()
          vim.schedule(function()
            for _, buf in ipairs(vim.api.nvim_list_bufs()) do
              if not vim.api.nvim_buf_is_loaded(buf) then
                -- skip
              elseif vim.bo[buf].buftype == "terminal" then
                pcall(vim.api.nvim_buf_delete, buf, { force = true })
              elseif vim.bo[buf].buftype == "" then
                local ft = vim.bo[buf].filetype
                if ft == "" then
                  -- 没探测到 filetype，强制再走一遍
                  vim.api.nvim_buf_call(buf, function()
                    pcall(vim.cmd, "filetype detect")
                  end)
                  ft = vim.bo[buf].filetype
                end
                if ft ~= "" and ft ~= "alpha" then
                  -- 关键：重 fire FileType，treesitter + LSP 都会借此挂载
                  pcall(vim.api.nvim_exec_autocmds, "FileType", {
                    buffer = buf,
                    modeline = false,
                  })
                end
              end
            end

            -- 接管 alpha 让出来的 layout 责任：开 tree
            pcall(function()
              require("nvim-tree.api").tree.open({ focus = false })
            end)

            if vim.g.HadBottomTerm == 1 then
              pcall(vim.cmd, "BottomTermToggle")
            end
          end)
        end,
      },
    })

    local keymap = vim.keymap

    keymap.set("n", "<leader>wr", "<cmd>SessionRestore<CR>", { desc = "Restore session for cwd" })
    keymap.set("n", "<leader>ws", "<cmd>SessionSave<CR>",    { desc = "Save session for cwd" })
    keymap.set("n", "<leader>wd", "<cmd>SessionDelete<CR>",  { desc = "Delete session for cwd" })
  end,
}
