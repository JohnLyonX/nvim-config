return {
  "nvimdev/lspsaga.nvim",
  event = "LspAttach",
  dependencies = {
    "nvim-treesitter/nvim-treesitter",
    "nvim-tree/nvim-web-devicons",
  },
  config = function()
    require("lspsaga").setup({
      ui = {
        border = "rounded",
        code_action = "",
      },
      scroll_preview = {
        scroll_down = "<C-d>",
        scroll_up = "<C-u>",
      },
      hover = {
        max_width = 0.6,
        max_height = 0.5,
      },
      lightbulb = {
        enable = false,
      },
      symbol_in_winbar = {
        enable = false,
      },
    })

    -- 智能滚动：若 hover / 诊断 浮窗存在则滚动它，否则走默认翻页
    -- 涵盖：
    --   - lspsaga hover (ft = sagahover / markdown)
    --   - vim.diagnostic.open_float （ft = "" + buftype = nofile，诊断浮窗）
    --   - 其他 LSP info 类浮窗（lspinfo）
    -- 排除当前窗口本身（避免 floating 编辑器自己滚自己）
    local function find_hover_win()
      local cur = vim.api.nvim_get_current_win()
      for _, win in ipairs(vim.api.nvim_list_wins()) do
        if win ~= cur then
          local cfg = vim.api.nvim_win_get_config(win)
          if cfg.relative ~= nil and cfg.relative ~= "" then
            local buf = vim.api.nvim_win_get_buf(win)
            local ft = vim.bo[buf].filetype
            local bt = vim.bo[buf].buftype
            if ft == "sagahover" or ft == "markdown" or ft == "lspinfo"
               or (ft == "" and bt == "nofile") then
              return win
            end
          end
        end
      end
    end

    local function smart_scroll(keys, fallback)
      return function()
        local win = find_hover_win()
        if win then
          vim.api.nvim_win_call(win, function()
            vim.cmd("normal! " .. keys)
          end)
        else
          vim.cmd("normal! " .. fallback)
        end
      end
    end

    -- \x06 = ^F, \x02 = ^B, \x04 = ^D, \x15 = ^U
    vim.keymap.set("n", "<C-f>", smart_scroll("\x04", "\x06"), { desc = "Scroll hover / page down" })
    vim.keymap.set("n", "<C-b>", smart_scroll("\x15", "\x02"), { desc = "Scroll hover / page up" })
  end,
}
