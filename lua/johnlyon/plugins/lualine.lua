return {
  "nvim-lualine/lualine.nvim",
  dependencies = { "nvim-tree/nvim-web-devicons" },
  config = function()
    local lualine = require("lualine")
    local lazy_status = require("lazy.status") -- to configure lazy pending updates count

    local colors = {
      orange = "#CE422B",   -- Rust 品牌色，比原来的 #c45508 更正宗
      insert = "#E8845A",   -- 亮橙棕，insert mode 清晰可辨
      violet = "#7A4E3E",   -- 锈紫棕，去掉原来偏粉的倾向
      yellow = "#C8974A",   -- 铁锈金，暖系关键字色
      red    = "#A0522D",   -- 赭石红，比原来更接近工业锈色
      fg     = "#E8DDD4",   -- 暖白（原来 #dde1e6 偏冷蓝）
      bg     = "#1C0F0A",   -- 焦炭黑偏暖，替代纯品牌色做背景
      inactive_bg = "#1d1714",  -- 保留
      inactive_fg = "#7b818c",  -- 保留
    }

    local my_lualine_theme = {
      normal = {
        a = { bg = colors.orange, fg = colors.bg, gui = "bold" },
        b = { bg = colors.bg, fg = colors.fg },
        c = { bg = colors.bg, fg = colors.fg },
        x = { bg = colors.bg, fg = colors.fg },
        y = { bg = colors.bg, fg = colors.fg },
        z = { bg = colors.bg, fg = colors.fg },
      },
      insert = {
        a = { bg = colors.insert, fg = colors.bg, gui = "bold" },
        b = { bg = colors.bg, fg = colors.fg },
        c = { bg = colors.bg, fg = colors.fg },
        x = { bg = colors.bg, fg = colors.fg },
        y = { bg = colors.bg, fg = colors.fg },
        z = { bg = colors.bg, fg = colors.fg },
      },
      visual = {
        a = { bg = colors.violet, fg = colors.bg, gui = "bold" },
        b = { bg = colors.bg, fg = colors.fg },
        c = { bg = colors.bg, fg = colors.fg },
        x = { bg = colors.bg, fg = colors.fg },
        y = { bg = colors.bg, fg = colors.fg },
        z = { bg = colors.bg, fg = colors.fg },
      },
      command = {
        a = { bg = colors.yellow, fg = colors.bg, gui = "bold" },
        b = { bg = colors.bg, fg = colors.fg },
        c = { bg = colors.bg, fg = colors.fg },
        x = { bg = colors.bg, fg = colors.fg },
        y = { bg = colors.bg, fg = colors.fg },
        z = { bg = colors.bg, fg = colors.fg },
      },
      replace = {
        a = { bg = colors.red, fg = colors.bg, gui = "bold" },
        b = { bg = colors.bg, fg = colors.fg },
        c = { bg = colors.bg, fg = colors.fg },
        x = { bg = colors.bg, fg = colors.fg },
        y = { bg = colors.bg, fg = colors.fg },
        z = { bg = colors.bg, fg = colors.fg },
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

    -- configure lualine with modified theme
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
      },
    })

    vim.api.nvim_set_hl(0, "StatusLine", { bg = colors.bg, fg = colors.fg })
    vim.api.nvim_set_hl(0, "StatusLineNC", { bg = colors.inactive_bg, fg = colors.inactive_fg })
  end,
}
