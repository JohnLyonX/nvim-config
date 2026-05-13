return {
  "uga-rosa/translate.nvim",
  cmd = "Translate",
  keys = {
    { "<leader>fy", "viw:Translate ZH<cr>",
      mode = "n", desc = "Translate word under cursor → 中文" },
    { "<leader>fy", ":Translate ZH<cr>",
      mode = "x", desc = "Translate selection → 中文", silent = true },
  },
  opts = {
    default = {
      command = "google",
      parse_after = "no_handle",
      output = "floating",
    },
  },
}
