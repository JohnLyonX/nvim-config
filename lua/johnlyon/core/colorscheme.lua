-- 主题持久化 —— 替代 colorscheme-persist.nvim 插件
--
-- 为什么自己实现：colorscheme-persist.nvim 顶层 require("telescope.pickers")
-- 硬依赖 Telescope，而我们已全量迁到 fzf-lua。这个模块复刻了它的核心功能：
--   1. 启动时读存档文件并应用上次的主题
--   2. 任何切主题（FzfLua picker、:colorscheme 命令）都写回存档
--   3. <leader>uc 弹 FzfLua 主题选择器（实时预览）

local M = {}

local file_path = vim.fn.stdpath("data") .. "/.nvim.colorscheme-persist.lua"
local fallback = "kanagawa"

-- 启动后应用保存的主题（由 init.lua 在 lazy 加载完成后调用）
function M.apply()
  local ok, name = pcall(dofile, file_path)
  if not ok or type(name) ~= "string" or name == "" then
    name = fallback
  end
  local applied, err = pcall(vim.cmd, "colorscheme " .. name)
  if not applied then
    vim.notify(
      "colorscheme: 加载 '" .. name .. "' 失败: " .. tostring(err),
      vim.log.levels.WARN
    )
    pcall(vim.cmd, "colorscheme " .. fallback)
  end
end

-- 任何路径切主题都写回存档（FzfLua 预览/确认、:colorscheme 命令都会触发 ColorScheme 事件）
-- 关键守卫：vim_did_enter == 0 时（还在 init.lua / lazy.setup 阶段）忽略写入，
-- 否则 kanagawa 插件 config 里的 `colorscheme kanagawa` 兜底会把你之前的选择覆盖掉。
vim.api.nvim_create_autocmd("ColorScheme", {
  group = vim.api.nvim_create_augroup("johnlyon_colorscheme_persist", { clear = true }),
  callback = function()
    if vim.v.vim_did_enter == 0 then return end -- 启动阶段不写存档
    local name = vim.g.colors_name
    if not name or name == "" then return end
    pcall(vim.fn.writefile, { "return '" .. name .. "'" }, file_path)
  end,
})

-- 键位：FzfLua 主题选择器（光标过候选实时预览）
vim.keymap.set("n", "<leader>uc", "<cmd>FzfLua colorschemes<cr>",
  { desc = "Pick colorscheme (live preview)" })

return M
