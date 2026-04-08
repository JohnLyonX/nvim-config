return {
  "akinsho/bufferline.nvim",
  dependencies = { "nvim-tree/nvim-web-devicons" },
  version = "*",
  opts = {
    options = {
      mode = "buffers",
      close_command = "bdelete! %d",
      right_mouse_command = "bdelete! %d",
      separator_style = "slant",
    },
  },
}
