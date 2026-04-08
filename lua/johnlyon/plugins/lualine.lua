return {
  "nvim-lualine/lualine.nvim",
  dependencies = { "nvim-tree/nvim-web-devicons" },
  config = function()
    local lualine = require("lualine")
    local lazy_status = require("lazy.status")

    local colors = {
      orange      = "#CE422B",
      insert      = "#E8845A",
      violet      = "#7A4E3E",
      yellow      = "#D4A847",
      red         = "#A0522D",
      fg          = "#E8DDD4",
      bg          = "#1C0F0A",
      inactive_bg = "#1d1714",
      inactive_fg = "#7b818c",
      location_bg = "#3D1F14",
      location_fg = "#E8DDD4",
    }

    local fixed_z = { bg = colors.location_bg, fg = colors.location_fg, gui = "bold" }
    local fixed_y = { bg = "#2a1810", fg = colors.yellow }

    local my_lualine_theme = {
      normal = {
        a = { bg = colors.orange, fg = colors.bg, gui = "bold" },
        b = { bg = colors.bg, fg = colors.fg },
        c = { bg = colors.bg, fg = colors.fg },
        x = { bg = colors.bg, fg = colors.fg },
        y = fixed_y,
        z = fixed_z,
      },
      insert = {
        a = { bg = colors.insert, fg = colors.bg, gui = "bold" },
        b = { bg = colors.bg, fg = colors.fg },
        c = { bg = colors.bg, fg = colors.fg },
        x = { bg = colors.bg, fg = colors.fg },
        y = fixed_y,
        z = fixed_z,
      },
      visual = {
        a = { bg = colors.violet, fg = colors.fg, gui = "bold" },
        b = { bg = colors.bg, fg = colors.fg },
        c = { bg = colors.bg, fg = colors.fg },
        x = { bg = colors.bg, fg = colors.fg },
        y = fixed_y,
        z = fixed_z,
      },
      command = {
        a = { bg = colors.yellow, fg = colors.bg, gui = "bold" },
        b = { bg = colors.bg, fg = colors.fg },
        c = { bg = colors.bg, fg = colors.fg },
        x = { bg = colors.bg, fg = colors.fg },
        y = fixed_y,
        z = fixed_z,
      },
      replace = {
        a = { bg = colors.red, fg = colors.fg, gui = "bold" },
        b = { bg = colors.bg, fg = colors.fg },
        c = { bg = colors.bg, fg = colors.fg },
        x = { bg = colors.bg, fg = colors.fg },
        y = fixed_y,
        z = fixed_z,
      },
      inactive = {
        a = { bg = colors.inactive_bg, fg = colors.inactive_fg, gui = "bold" },
        b = { bg = colors.inactive_bg, fg = colors.inactive_fg },
        c = { bg = colors.inactive_bg, fg = colors.inactive_fg },
        x = { bg = colors.inactive_bg, fg = colors.inactive_fg },
        y = { bg = colors.inactive_bg, fg = colors.inactive_fg },
        z = { bg = colors.inactive_bg, fg = colors.inactive_fg },
      },
    }

    lualine.setup({
      options = {
        theme = my_lualine_theme,
      },
      sections = {
        lualine_x = {
          {
            lazy_status.updates,
            cond = lazy_status.has_updates,
            color = { fg = "#ff9e64" },
          },
          { "encoding" },
          { "fileformat" },
          { "filetype" },
        },
        lualine_y = {
          {
            "diagnostics",
            color = { bg = colors.bg },
            symbols = { error = "E", warn = "W", info = "I", hint = "H" },
          },
          { "progress" },
        },
        lualine_z = {
          { "location" },
        },
      },
    })

    vim.api.nvim_set_hl(0, "StatusLine", { bg = colors.bg, fg = colors.fg })
    vim.api.nvim_set_hl(0, "StatusLineNC", { bg = colors.inactive_bg, fg = colors.inactive_fg })
  end,
}