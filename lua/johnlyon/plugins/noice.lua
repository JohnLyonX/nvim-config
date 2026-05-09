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
        cmdline     = { icon = ">" },
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
      -- 覆盖 LSP hover/signature 弹窗大小，避免 rust-analyzer 给 axum::Json<T>
      -- 这种长文档把屏幕挡满（默认 max_height=20 + border 比较高）
      hover = {
        size = {
          max_height = 10,
          max_width = 80,
        },
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

    -- 把所有 noice 浮窗类高亮组的背景对齐到 NormalFloat：
    --   1) cmdline 弹窗左边图标区"额外方块"
    --   2) mini view（右下角 LSP 进度通知）的半透明背景与主题不协调
    -- 这样换任何主题都自动跟随，不需要为每个主题单独适配。
    local function fix_noice_hl()
      local groups = {
        -- cmdline_popup
        "NoiceCmdline",
        "NoiceCmdlinePopup",
        "NoiceCmdlinePopupBorder",
        "NoiceCmdlinePopupTitle",
        "NoiceCmdlineIcon",
        "NoiceCmdlineIconCmdline",
        "NoiceCmdlineIconSearch",
        "NoiceCmdlineIconLua",
        "NoiceCmdlineIconHelp",
        "NoiceCmdlineIconFilter",
        "NoiceCmdlineIconInput",
        -- mini view（LSP progress 通知）
        "NoiceMini",
        "NoiceLspProgressTitle",
        "NoiceLspProgressClient",
        "NoiceLspProgressSpinner",
        "NoiceFormatProgressDone",
        "NoiceFormatProgressTodo",
      }
      local nf = vim.api.nvim_get_hl(0, { name = "NormalFloat", link = false })
      for _, g in ipairs(groups) do
        local cur = vim.api.nvim_get_hl(0, { name = g, link = false })
        vim.api.nvim_set_hl(0, g, vim.tbl_extend("force", cur, { bg = nf.bg }))
      end
    end
    fix_noice_hl()
    vim.api.nvim_create_autocmd("ColorScheme", {
      group = vim.api.nvim_create_augroup("NoiceCmdlineHlFix", { clear = true }),
      callback = fix_noice_hl,
    })
  end,
}
