return {
  "propet/colorscheme-persist.nvim",
  lazy = false,
  dependencies = { "nvim-telescope/telescope.nvim" },
  keys = {
    {
      "<leader>uc",
      "<cmd>Telescope colorscheme enable_preview=true<cr>",
      desc = "Pick colorscheme (live preview)",
    },
  },
  config = function()
    require("colorscheme-persist").setup({
      fallback = "kanagawa",
    })
    -- 任何路径的主题切换都写回 colorscheme-persist 的存档文件
    -- （Telescope picker 的预览/确认、:colorscheme 命令都会触发 ColorScheme 事件）
    vim.api.nvim_create_autocmd("ColorScheme", {
      callback = function()
        local name = vim.g.colors_name
        if not name or name == "" then return end
        local path = vim.fn.stdpath("data") .. "/.nvim.colorscheme-persist.lua"
        pcall(vim.fn.writefile, { "return '" .. name .. "'" }, path)
      end,
    })
  end,
}
