return {
  "MeanderingProgrammer/render-markdown.nvim",
  dependencies = {
    "nvim-treesitter/nvim-treesitter",
    "nvim-tree/nvim-web-devicons",
  },
  ft = { "markdown", "Avante", "codecompanion" },
  opts = {
    file_types = { "markdown", "Avante", "codecompanion" },
    heading = {
      enabled = true,
      sign = true,
      icons = { "󰉫 ", "󰉬 ", "󰉭 ", "󰉮 ", "󰉯 ", "󰉰 " },
      backgrounds = {
        "RenderMarkdownH1Bg",
        "RenderMarkdownH2Bg",
        "RenderMarkdownH3Bg",
        "RenderMarkdownH4Bg",
        "RenderMarkdownH5Bg",
        "RenderMarkdownH6Bg",
      },
    },
    code = {
      enabled = true,
      sign = false,
      style = "full",
      width = "block",
      left_pad = 2,
      right_pad = 2,
      border = "thick",
    },
    bullet = {
      enabled = true,
      icons = { "●", "○", "◆", "◇" },
    },
    checkbox = {
      enabled = true,
      unchecked = { icon = "󰄱 ", highlight = "RenderMarkdownUnchecked" },
      checked   = { icon = "󰱒 ", highlight = "RenderMarkdownChecked" },
    },
    quote = {
      enabled = true,
      icon = "▎",
    },
    pipe_table = {
      enabled = true,
      style = "full",
    },
    link = {
      enabled = true,
      hyperlink = "󰌹 ",
      image = "󰥶 ",
      email = "󰀓 ",
    },
  },
}
