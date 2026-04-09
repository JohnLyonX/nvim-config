return {
  "akinsho/bufferline.nvim",
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
    },
    options = {
      mode = "buffers",
      close_command = "bdelete! %d",
      right_mouse_command = "bdelete! %d",
      separator_style = "slant",
    },
  },
}
