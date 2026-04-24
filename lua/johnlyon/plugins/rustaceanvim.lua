return {
	{
		"mrcjkb/rustaceanvim",
		version = "^9",
		lazy = false,
		dependencies = {
			"hrsh7th/cmp-nvim-lsp",
		},
		init = function()
			local cmp_nvim_lsp = require("cmp_nvim_lsp")
			local keymap = vim.keymap

			local capabilities = cmp_nvim_lsp.default_capabilities()

			local on_attach = function(client, bufnr)
				-- 清理 rust-analyzer hover 响应里的 HTML 标签，修复 Lspsaga hover_doc 渲染
				local original_request = client.request
				client.request = function(method, params, handler, req_bufnr)
					if method == "textDocument/hover" then
						return original_request(method, params, function(err, result, ctx, config)
							if result and result.contents and result.contents.value then
								local v = result.contents.value
								v = v:gsub("\\<", "\1"):gsub("\\>", "\2")
								v = v:gsub("<[^>]+>", "")
								v = v:gsub("\1", "<"):gsub("\2", ">")
								result.contents.value = v
							end
							if handler then
								handler(err, result, ctx, config)
							end
						end, req_bufnr)
					end
					return original_request(method, params, handler, req_bufnr)
				end

				local opts = { noremap = true, silent = true, buffer = bufnr }

				opts.desc = "Show LSP references"
				keymap.set("n", "gR", "<cmd>Telescope lsp_references<CR>", opts)

				opts.desc = "Go to declaration"
				keymap.set("n", "gD", vim.lsp.buf.declaration, opts)

				opts.desc = "Show LSP definitions"
				keymap.set("n", "gd", "<cmd>Telescope lsp_definitions<CR>", opts)

				opts.desc = "Show LSP implementations"
				keymap.set("n", "gi", "<cmd>Telescope lsp_implementations<CR>", opts)

				opts.desc = "Show LSP type definitions"
				keymap.set("n", "gt", "<cmd>Telescope lsp_type_definitions<CR>", opts)

				opts.desc = "See available code actions"
				keymap.set({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, opts)

				opts.desc = "Smart rename"
				keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts)

				opts.desc = "Show buffer diagnostics"
				keymap.set("n", "<leader>D", "<cmd>Telescope diagnostics bufnr=0<CR>", opts)

				opts.desc = "Show line diagnostics"
				keymap.set("n", "<leader>d", vim.diagnostic.open_float, opts)

				opts.desc = "Go to previous diagnostic"
				keymap.set("n", "[d", vim.diagnostic.goto_prev, opts)

				opts.desc = "Go to next diagnostic"
				keymap.set("n", "]d", vim.diagnostic.goto_next, opts)

				opts.desc = "Show documentation for what is under cursor"
				keymap.set("n", "K", function()
					require("johnlyon.core.lsp_hover").show({ max_width = 80, max_height = 18 })
				end, opts)

				opts.desc = "Rust hover actions (go to trait/impl)"
				keymap.set("n", "<leader>ha", function()
					vim.cmd.RustLsp({ "hover", "actions" })
				end, opts)

				opts.desc = "Restart LSP"
				keymap.set("n", "<leader>rs", ":LspRestart<CR>", opts)
			end

			vim.g.rustaceanvim = {
				tools = {
					float_win_config = {
						border = "rounded",
						max_width = 100,
						max_height = 30,
					},
				},
				server = {
					capabilities = capabilities,
					on_attach = on_attach,
				},
			}
		end,
	},
}
