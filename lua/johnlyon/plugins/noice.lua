return {
  "folke/noice.nvim",
  event = "VeryLazy",
  dependencies = {
    "MunifTanjim/nui.nvim",
    "rcarriga/nvim-notify",
  },
  opts = {
    cmdline = {
      view = "cmdline_popup",
      format = {
        cmdline     = { icon = " " },
        search_down = { icon = " " },
        search_up   = { icon = " " },
        filter      = { icon = "$" },
        lua         = { icon = " " },
        help        = { icon = "?" },
      },
    },
    messages = {
      enabled = true,
      view = "notify",
      view_error = "notify",
      view_warn = "notify",
      view_history = "messages",
      view_search = "virtualtext",
    },
    popupmenu = {
      enabled = true,
      backend = "nui",
    },
    lsp = {
      override = {
        ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
        ["vim.lsp.util.stylize_markdown"] = true,
        ["cmp.entry.get_documentation"] = true,
      },
      hover = { enabled = true },
      signature = { enabled = true },
      progress = { enabled = true },
    },
    presets = {
      bottom_search = false,
      command_palette = true,
      long_message_to_split = true,
      inc_rename = false,
      lsp_doc_border = true,
    },
    routes = {
      {
        filter = { event = "msg_show", kind = "", find = "written" },
        opts = { skip = true },
      },
    },
    views = {
      cmdline_popup = {
        position = { row = "40%", col = "50%" },
        size = { width = 60, height = "auto" },
        border = { style = "rounded" },
      },
      popupmenu = {
        relative = "editor",
        position = { row = "calc(40% + 3)", col = "50%" },
        size = { width = 60, height = 10 },
        border = { style = "rounded" },
      },
    },
  },
  config = function(_, opts)
    require("noice").setup(opts)
    require("notify").setup({
      background_colour = "#1C0F0A",
      timeout = 3000,
      stages = "fade",
      render = "compact",
    })
  end,
}
