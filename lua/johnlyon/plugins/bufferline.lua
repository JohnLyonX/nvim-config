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
      close_button_visible = {
        bg = "#1b1b1b",
        fg = "#6f6f6f",
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
        bg = "#1b1b1b",
        fg = "#7a3e48",
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
        bg = "#1b1b1b",
        fg = "#1b1b1b",
      },
       buffer_visible = {
    bg = "#1b1b1b",
    fg = "#6f6f6f",
  },
  numbers = {
    bg = "#1b1b1b",
    fg = "#6f6f6f",
  },
  numbers_visible = {
    bg = "#1b1b1b",
    fg = "#6f6f6f",
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
    bg = "#1b1b1b",
    fg = "#6f6f6f",
  },
  duplicate_selected = {
    bg = "#434343",
    fg = "#e8ddd4",
  },
    },
    options = {
      mode = "buffers",
      close_command = "bdelete! %d",
      right_mouse_command = "bdelete! %d",
      separator_style = "slant",
      -- 不在 bufferline 上显示终端 buffer（toggleterm 主终端 + <leader>tn 追加 pane 都过滤掉）。
      -- 终端切换走 <leader>tl，bufferline 留给真正的源代码 buffer。
      custom_filter = function(buf_number)
        return vim.bo[buf_number].buftype ~= "terminal"
      end,
    },
  },
}
