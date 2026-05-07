return {
  "mistricky/codesnap.nvim",
  build = "make build_generator",
  cmd = { "CodeSnap", "CodeSnapSave", "CodeSnapHighlight", "CodeSnapSaveHighlight" },
  keys = {
    { "<leader>cs", "<cmd>CodeSnap<cr>",          mode = "x", desc = "CodeSnap → clipboard" },
    { "<leader>cS", "<cmd>CodeSnapSave<cr>",      mode = "x", desc = "CodeSnap → save file" },
    { "<leader>ch", "<cmd>CodeSnapHighlight<cr>", mode = "x", desc = "CodeSnap with highlights" },
  },
  opts = {
    save_path = "~/Pictures/CodeSnaps/",
    has_breadcrumbs = true,
    has_line_number = true,
    show_workspace = false,
    bg_theme = "default",
    watermark = "",
    code_font_family = "JetBrainsMono Nerd Font",
    title_font_family = "JetBrainsMono Nerd Font",
    mac_window_bar = true,
    breadcrumbs_separator = "/",
  },
}
