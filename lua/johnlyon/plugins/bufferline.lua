return {
  "akinsho/bufferline.nvim",
  event = "VeryLazy",
  dependencies = { "nvim-tree/nvim-web-devicons" },
  version = "*",
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
      -- X 按钮和右键关 buffer：走 SmartBufferClose（左邻 → 右邻 → alpha）
      close_command = function(bufnum) _G.SmartBufferClose(bufnum) end,
      right_mouse_command = function(bufnum) _G.SmartBufferClose(bufnum) end,
      -- 鼠标左键点 tab：
      --   1) 默认 "buffer %d" 在「当前窗口」跑，光标在终端时会把终端 buffer
      --      换成代码文件，终端就消失了。所以包一层：当前是特殊 buffer 时
      --      先切到第一个真文件 buffer 的窗口再切。
      --   2) 必须 vim.schedule —— bufferline 内部对 string 命令也是 schedule 的
      --      （见 lua/bufferline/commands.lua 的 #574 fix 注释）。同步改 window
      --      焦点会和 vim 自己 mouse 事件后处理 race，导致焦点乱跳到 tree/terminal。
      left_mouse_command = function(bufnum)
        vim.schedule(function()
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
          vim.cmd("buffer " .. bufnum)
        end)
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
