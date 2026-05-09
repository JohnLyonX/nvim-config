return {
	{
		"rebelot/kanagawa.nvim",
		priority = 1000,
		config = function()
			require("kanagawa").setup({
				-- 三个主题：
				--   "wave"   → 默认，深蓝紫，灵感来自葛饰北斋《神奈川冲浪里》
				--   "dragon" → 更深更暗，对比度更高，OLED 友好
				--   "lotus"  → 亮色主题，配 background=light 用
				theme = "dragon",
				-- 如果想根据 vim.opt.background 自动切换 dark/light：
				background = {
					dark = "dragon",
					light = "lotus",
				},
				compile = false,           -- 启用 :KanagawaCompile 后改 true 加速
				undercurl = true,
				commentStyle = { italic = true },
				functionStyle = {},
				keywordStyle = { italic = true },
				statementStyle = { bold = true },
				typeStyle = {},
				transparent = false,
				dimInactive = false,       -- 非活动窗口变暗
				terminalColors = true,
			})
			-- 仅在没有任何主题已加载时兜底；colorscheme-persist 启动后会优先恢复用户上次选择
			if not vim.g.colors_name then
				vim.cmd.colorscheme("kanagawa")
			end
		end,
	},
	-- 旧主题保留（不会自动加载，priority 默认 50；想用就改 priority=1000 并注释掉上面）
	{
		"nyoom-engineering/oxocarbon.nvim",
		lazy = true,
	},
  -- {
  --   "folke/tokyonight.nvim",
  --   priority = 1000, -- make sure to load this before all the other start plugins
  --   config = function()
  --     local bg = "#011628"
  --     local bg_dark = "#011423"
  --     local bg_highlight = "#143652"
  --     local bg_search = "#0A64AC"
  --     local bg_visual = "#275378"
  --     local fg = "#CBE0F0"
  --     local fg_dark = "#B4D0E9"
  --     local fg_gutter = "#627E97"
  --     local border = "#547998"
  --
  --     require("tokyonight").setup({
  --       style = "night",
  --       on_colors = function(colors)
  --         colors.bg = bg
  --         colors.bg_dark = bg_dark
  --         colors.bg_float = bg_dark
  --         colors.bg_highlight = bg_highlight
  --         colors.bg_popup = bg_dark
  --         colors.bg_search = bg_search
  --         colors.bg_sidebar = bg_dark
  --         colors.bg_statusline = bg_dark
  --         colors.bg_visual = bg_visual
  --         colors.border = border
  --         colors.fg = fg
  --         colors.fg_dark = fg_dark
  --         colors.fg_float = fg
  --         colors.fg_gutter = fg_gutter
  --         colors.fg_sidebar = fg_dark
  --       end,
  --     })
  --     -- load the colorscheme here
  --     vim.cmd([[colorscheme tokyonight]])
  --   end,
  -- },
}
