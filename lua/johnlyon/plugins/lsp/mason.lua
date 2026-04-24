return {
	"williamboman/mason.nvim",
	cmd = { "Mason", "MasonInstall", "MasonUninstall", "MasonUpdate", "MasonLog", "MasonToolsInstall", "MasonToolsUpdate" },
	event = "VeryLazy",
	dependencies = {
		"williamboman/mason-lspconfig.nvim",
		"WhoIsSethDaniel/mason-tool-installer.nvim",
	},
	config = function()
		local homebrew_bin = "/opt/homebrew/bin"
		if vim.fn.isdirectory(homebrew_bin) == 1 then
			local path_entries = vim.split(vim.env.PATH or "", ":", { plain = true, trimempty = true })
			local filtered = {}
			for _, entry in ipairs(path_entries) do
				if entry ~= homebrew_bin then
					table.insert(filtered, entry)
				end
			end
			vim.env.PATH = table.concat(vim.list_extend({ homebrew_bin }, filtered), ":")
		end

		-- import mason
		local mason = require("mason")

		-- import mason-lspconfig
		local mason_lspconfig = require("mason-lspconfig")

		local mason_tool_installer = require("mason-tool-installer")

		-- enable mason and configure icons
		mason.setup({
			ui = {
				icons = {
					package_installed = "✓",
					package_pending = "➜",
					package_uninstalled = "✗",
				},
			},
		})

		local lsp_servers = {
			"pyright",
			"html",
			"cssls",
			"ts_ls",
			"jsonls",
			"lua_ls",
		}

		local mason_packages = {
			"pyright",
			"html-lsp",
			"css-lsp",
			"typescript-language-server",
			"json-lsp",
			"lua-language-server",
			"stylua",
			"black",
			"isort",
			"pylint",
			"eslint_d",
			"prettier",
		}

		mason_lspconfig.setup({
			ensure_installed = lsp_servers,
			-- auto-install configured servers (with lspconfig)
			automatic_installation = true, -- not the same as ensure_installed
		})

		mason_tool_installer.setup({
			ensure_installed = mason_packages,
		})
	end,
}
