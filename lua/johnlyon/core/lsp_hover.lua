local M = {}

local function find_hover_win()
	for _, win in ipairs(vim.api.nvim_list_wins()) do
		local cfg = vim.api.nvim_win_get_config(win)
		if cfg.relative ~= "" then
			local buf = vim.api.nvim_win_get_buf(win)
			if vim.bo[buf].filetype == "markdown" then
				return win
			end
		end
	end
end

function M.show(opts)
	opts = opts or {}
	local max_width = 50
	local max_height = 15

	vim.lsp.buf.hover({
		border = "rounded",
		max_width = max_width,
		max_height = max_height,
	})

	local src_buf = vim.api.nvim_get_current_buf()
	local timer = vim.uv.new_timer()
	local attempts = 0
	timer:start(
		30,
		30,
		vim.schedule_wrap(function()
			attempts = attempts + 1
			local hover_win = find_hover_win()
			if hover_win then
				timer:stop()
				timer:close()

				local function cleanup()
					pcall(vim.keymap.del, "n", "q", { buffer = src_buf })
					pcall(vim.keymap.del, "n", "<C-d>", { buffer = src_buf })
					pcall(vim.keymap.del, "n", "<C-u>", { buffer = src_buf })
				end

				vim.keymap.set("n", "q", function()
					if vim.api.nvim_win_is_valid(hover_win) then
						pcall(vim.api.nvim_win_close, hover_win, true)
					end
					cleanup()
				end, { buffer = src_buf, nowait = true, silent = true, desc = "Close LSP hover" })

				local function scroll(keys)
					return function()
						if vim.api.nvim_win_is_valid(hover_win) then
							vim.api.nvim_win_call(hover_win, function()
								vim.cmd("normal! " .. keys)
							end)
						end
					end
				end

				-- \x04 = ^D, \x15 = ^U
				vim.keymap.set("n", "<C-d>", scroll("\x04"), {
					buffer = src_buf,
					nowait = true,
					silent = true,
					desc = "Scroll hover down",
				})
				vim.keymap.set("n", "<C-u>", scroll("\x15"), {
					buffer = src_buf,
					nowait = true,
					silent = true,
					desc = "Scroll hover up",
				})

				vim.api.nvim_create_autocmd("WinClosed", {
					pattern = tostring(hover_win),
					once = true,
					callback = cleanup,
				})
			elseif attempts >= 30 then
				timer:stop()
				timer:close()
			end
		end)
	)
end

return M
