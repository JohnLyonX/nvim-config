return {
	"ibhagwan/fzf-lua",
	cmd = "FzfLua",
	dependencies = { "nvim-tree/nvim-web-devicons" },
	keys = {
		-- 文件/grep 高频操作走 fzf-lua（C 写的 fzf 二进制，大仓库下不卡）
		{ "<leader>ff", "<cmd>FzfLua files<cr>",             desc = "Find files (fzf-lua)" },
		{ "<leader>fr", "<cmd>FzfLua oldfiles<cr>",          desc = "Recent files (fzf-lua)" },
		{ "<leader>fs", "<cmd>FzfLua live_grep_native<cr>",  desc = "Live grep (fzf-lua, fastest)" },
		{ "<leader>fc", "<cmd>FzfLua grep_cword<cr>",        desc = "Grep word under cursor (fzf-lua)" },
		{ "<leader>fb", "<cmd>FzfLua buffers<cr>",           desc = "Switch buffer (fzf-lua)" },
	},
	opts = {
		-- 不画 border 时启动更快；想要好看的边框可改回 "rounded"
		winopts = {
			height = 0.85,
			width = 0.85,
			preview = {
				layout = "flex",      -- 窄屏自动竖排预览
				flip_columns = 130,
			},
		},
		files = {
			-- 没装 fd 就用 rg --files 兜底
			-- 重点排除：target（Rust 构建产物，rustlings 里能有 1w+ 文件）/ node_modules / 各种 build 目录
			-- 去掉 --hidden 默认行为：不扫 .idea / .venv / .next 等 IDE 和工具的隐藏目录
			fd_opts = "--color=never --type f --follow "
				.. "--exclude .git --exclude target --exclude node_modules "
				.. "--exclude dist --exclude build --exclude .next --exclude .venv",
			rg_opts = "--color=never --files --follow "
				.. "-g '!.git' -g '!target' -g '!node_modules' "
				.. "-g '!dist' -g '!build' -g '!.next' -g '!.venv'",
		},
		grep = {
			-- live_grep_native 直接把 rg 输出灌给 fzf，无中间层，速度最快
			rg_opts = "--column --line-number --no-heading --color=always --smart-case "
				.. "-g '!.git' -g '!target' -g '!node_modules' "
				.. "-g '!dist' -g '!build' -g '!.next' -g '!.venv'",
		},
	},
}
