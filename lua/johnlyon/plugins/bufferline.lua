return {
  "akinsho/bufferline.nvim",
  event = "VeryLazy",
  dependencies = { "nvim-tree/nvim-web-devicons" },
  version = "*",
  -- 跟踪「主编辑器窗口」winid，给 left_mouse_command / SmartBufferClose 用。
  -- bufferline 默认在 current window 跑 :buffer N（上游 #267 维护者确认），
  -- 焦点在 tree / terminal 时点 tab 会把那个窗口替换成文件。预跟踪一个
  -- 「真文件编辑器窗口」就不用每次点击瞬间再去猜焦点该往哪儿落，避免
  -- 鼠标事件链 race。挂在 init 是因为它独立于 bufferline 本身加载时机。
  --
  -- ⚠️ 必须 vim.schedule 推迟判断：
  --   toggleterm 开终端 / auto-session 还原流程都是 `belowright 15split`
  --   然后才 `:terminal`。`:split` 时新窗口先复用原窗口的真文件 buffer
  --   （buftype=""），BufEnter / WinEnter 在这一刻触发我们的回调 → 把
  --   "未来要变终端的那个 winid" 误记成 main_win。下一拍才跑 :terminal
  --   把 buftype 改成 "terminal"，但 main_win 已经被污染。
  --
  --   解法：autocmd 里只捕获 winid，真判断推迟到 vim.schedule。等事件循环
  --   下一 tick，:terminal 已跑完，buffer 已是 terminal，过滤正确挡掉。
  init = function()
    vim.api.nvim_create_autocmd({ "BufEnter", "WinEnter" }, {
      group = vim.api.nvim_create_augroup("johnlyon_main_win_track", { clear = true }),
      callback = function()
        local win = vim.api.nvim_get_current_win()
        vim.schedule(function()
          if not vim.api.nvim_win_is_valid(win) then return end
          -- 读取窗口当下 (schedule 跑时) 的最终 buffer 状态：
          --   非浮窗 + buftype == "" → 真文件编辑器窗口
          --   排除 NvimTree(nofile) / terminal / alpha(nofile) / quickfix / help
          local cfg = vim.api.nvim_win_get_config(win)
          if cfg.relative ~= "" then return end
          local buf = vim.api.nvim_win_get_buf(win)
          if vim.bo[buf].buftype == "" then
            vim.g.main_win = win
          end
        end)
      end,
    })
  end,
  opts = {
    highlights = {
      fill = {
        bg = "#161616",
      },
      background = {
        bg = "#1b1b1b",
        fg = "#6f6f6f",
      },
      close_button = {
        bg = "#1b1b1b",
        fg = "#6f6f6f",
      },
      -- _visible 系列对齐 _selected 配色：
      -- focus 在 tree/terminal 时，编辑器里的 buffer 是 visible 状态（非当前窗口
      -- buffer，所以不是 selected）。如果 visible 高亮和 background 一样暗，
      -- 用户视觉上找不到"哪个 tab 是编辑器在显示的"。让两者看起来一致即可。
      close_button_visible = {
        bg = "#434343",
        fg = "#e8ddd4",
      },
      close_button_selected = {
        bg = "#434343",
        fg = "#e8ddd4",
      },
      buffer_selected = {
        bg = "#434343",
        fg = "#e8ddd4",
        bold = false,
        italic = false,
      },
      modified = {
        bg = "#1b1b1b",
        fg = "#7a3e48",
      },
      modified_visible = {
        bg = "#434343",
        fg = "#c45508",
      },
      modified_selected = {
        bg = "#434343",
        fg = "#c45508",
      },
      tab_selected = {
        bg = "#302a28",
        fg = "#e8ddd4",
      },
      tab_close = {
        bg = "#1b1b1b",
        fg = "#6f6f6f",
      },
      separator = {
        bg = "#1b1b1b",
        fg = "#1b1b1b",
      },
      separator_selected = {
        bg = "#434343",
        fg = "#1b1b1b",
      },
      separator_visible = {
        bg = "#434343",
        fg = "#1b1b1b",
      },
       buffer_visible = {
    bg = "#434343",
    fg = "#e8ddd4",
  },
  numbers = {
    bg = "#1b1b1b",
    fg = "#6f6f6f",
  },
  numbers_visible = {
    bg = "#434343",
    fg = "#e8ddd4",
  },
  numbers_selected = {
    bg = "#434343",
    fg = "#e8ddd4",
  },
  duplicate = {
    bg = "#1b1b1b",
    fg = "#6f6f6f",
  },
  duplicate_visible = {
    bg = "#434343",
    fg = "#e8ddd4",
  },
  duplicate_selected = {
    bg = "#434343",
    fg = "#e8ddd4",
  },
    },
    options = {
      mode = "buffers",
      -- 给 nvim-tree 让出 tabline 左侧空间：
      --   1) 第一个 tab 不再贴左边缘 / 压在 tree 列正上方，触控板易点中
      --   2) 点偏一行也只会落到编辑器，不会误中 tree 把焦点拽过去
      offsets = {
        {
          filetype = "NvimTree",
          text = "",
          separator = false,
          -- 用 BufferLineFill 让 offset 区跟 tabline 空白处同色
          -- 默认会用 Directory 高亮组（橙色），看起来像顶部多了一道色条
          highlight = "BufferLineFill",
        },
      },
      -- X 按钮和右键关 buffer：走 SmartBufferClose（左邻 → 右邻 → alpha）
      close_command = function(bufnum) _G.SmartBufferClose(bufnum) end,
      right_mouse_command = function(bufnum) _G.SmartBufferClose(bufnum) end,
      -- 鼠标左键点 tab：同步 + 预跟踪 winid + fallback。
      --   1) 优先用 init 里 autocmd 跟踪到的 vim.g.main_win —— 不依赖点击瞬间
      --      的 vim.bo / current win 状态，避开 mouse release / focus 事件 race。
      --   2) main_win 失效（启动后还没进过文件）→ 在当前 tab 找一个非浮窗 / 非
      --      NvimTree / 非 terminal 的窗口（优先 buftype == ""，否则 alpha 等兜底）。
      --   3) 同步执行，不再 vim.schedule / defer_fn —— bufferline 的 #574 schedule
      --      仅针对 string command 路径（commands.lua: vim.cmd(fmt(command, id))），
      --      function command 是直接同步调用的，无需调度也不会破坏 tabline 刷新。
      --      参考上游 issue #267 / #935 jimafisk 的 workaround。
      left_mouse_command = function(bufnum)
        local target = vim.g.main_win
        if not (target and vim.api.nvim_win_is_valid(target)) then
          target = nil
          for _, win in ipairs(vim.api.nvim_tabpage_list_wins(0)) do
            local cfg = vim.api.nvim_win_get_config(win)
            if cfg.relative == "" then
              local buf = vim.api.nvim_win_get_buf(win)
              local bt = vim.bo[buf].buftype
              local ft = vim.bo[buf].filetype
              if bt ~= "terminal" and ft ~= "NvimTree" then
                target = win
                if bt == "" then break end
              end
            end
          end
        end
        if target and vim.api.nvim_win_is_valid(target) then
          vim.fn.win_gotoid(target)
        end
        if vim.api.nvim_buf_is_valid(bufnum) then
          vim.cmd("buffer " .. bufnum)
        end
      end,
      separator_style = "slant",
      -- 不在 bufferline 上显示终端 buffer（toggleterm 主终端 + <leader>tn 追加 pane 都过滤掉）。
      -- 终端切换走 <leader>tl，bufferline 留给真正的源代码 buffer。
      custom_filter = function(buf_number)
        return vim.bo[buf_number].buftype ~= "terminal"
      end,
    },
  },
}
