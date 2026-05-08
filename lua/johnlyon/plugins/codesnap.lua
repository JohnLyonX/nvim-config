return {
  "mistricky/codesnap.nvim",
  build = "make build_generator",
  cmd = { "CodeSnap", "CodeSnapSave", "CodeSnapASCII", "CodeSnapHighlight", "CodeSnapHighlightSave" },
  init = function()
    vim.api.nvim_create_autocmd("WinNew", {
      group = vim.api.nvim_create_augroup("CodeSnapModalTweaks", { clear = true }),
      callback = function()
        vim.schedule(function()
          local win = vim.api.nvim_get_current_win()
          local ok, cfg = pcall(vim.api.nvim_win_get_config, win)
          if not ok or cfg.relative == "" or not cfg.title then return end

          local title = cfg.title
          if type(title) == "table" then
            title = title[1] and (type(title[1]) == "table" and title[1][1] or title[1]) or ""
          end
          if type(title) == "string" and title:find("Select text to highlight") then
            pcall(vim.api.nvim_win_set_option, win, "cursorline", false)
          end
        end)
      end,
    })
  end,
  keys = {
    { "<leader>cs", "<cmd>CodeSnap<cr>",          mode = "x", desc = "CodeSnap → clipboard" },
    { "<leader>cS", "<cmd>CodeSnapSave<cr>",      mode = "x", desc = "CodeSnap → save file" },
    { "<leader>ch", "<cmd>CodeSnapHighlight<cr>", mode = "x", desc = "CodeSnap with highlights" },
  },
  opts = {
    save_path = "~/Pictures/CodeSnaps/",
    show_workspace = false,
    show_line_number = true,
    snapshot_config = {
      theme = "candy",
      window = {
        mac_window_bar = true,
        margin = { x = 60, y = 60 },
        title_config = {
          font_family = "JetBrainsMono Nerd Font",
        },
      },
      code_config = {
        font_family = "JetBrainsMono Nerd Font",
        breadcrumbs = {
          enable = true,
          separator = "/",
        },
      },
      watermark = {
        content = "",
      },
      background = {
        start = { x = 0, y = 0 },
        ["end"] = { x = "max", y = "max" },
        stops = {
          { position = 0, color = "#667eea" },
          { position = 1, color = "#764ba2" },
        },
      },
    },
  },
}
