return {
  {
    "nvim-treesitter/nvim-treesitter",
    lazy = false,
    build = ":TSUpdate",
    dependencies = {
      "nvim-treesitter/nvim-treesitter-textobjects",
      "windwp/nvim-ts-autotag",
    },
    config = function()
      local install_dir = vim.fn.stdpath("data") .. "/site"
      local languages = {
        "json",
        "javascript",
        "typescript",
        "tsx",
        "yaml",
        "html",
        "css",
        "prisma",
        "markdown",
        "markdown_inline",
        "svelte",
        "graphql",
        "bash",
        "lua",
        "vim",
        "dockerfile",
        "gitignore",
        "query",
      }

      require("nvim-treesitter").setup({
        install_dir = install_dir,
      })
      require("nvim-treesitter").install(languages)
      require("nvim-ts-autotag").setup({
        opts = {
          enable_close = true,
          enable_rename = true,
          enable_close_on_slash = false,
        },
      })
      do
        local internal = require("nvim-ts-autotag.internal")
        local rename_tag = internal.rename_tag
        internal.rename_tag = function()
          local ok, parser = pcall(vim.treesitter.get_parser)
          if not ok or parser == nil then
            return
          end
          return rename_tag()
        end
      end

      local group = vim.api.nvim_create_augroup("johnlyon_treesitter", { clear = true })
      vim.api.nvim_create_autocmd("FileType", {
        group = group,
        pattern = "*",
        callback = function(args)
          local ok = pcall(vim.treesitter.start, args.buf)
          if ok then
            vim.bo[args.buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
          end
        end,
      })

      vim.keymap.set("n", "<C-space>", function()
        if vim.treesitter.get_parser(nil, nil, { error = false }) then
          vim.cmd.normal({ "van", bang = true })
        else
          vim.lsp.buf.selection_range(1)
        end
      end, { desc = "Treesitter incremental selection" })

      vim.keymap.set("x", "<C-space>", function()
        if vim.treesitter.get_parser(nil, nil, { error = false }) then
          require("vim.treesitter._select").select_parent(vim.v.count1)
        else
          vim.lsp.buf.selection_range(vim.v.count1)
        end
      end, { desc = "Treesitter expand selection" })

      vim.keymap.set("x", "<bs>", function()
        if vim.treesitter.get_parser(nil, nil, { error = false }) then
          require("vim.treesitter._select").select_child(vim.v.count1)
        else
          vim.lsp.buf.selection_range(-vim.v.count1)
        end
      end, { desc = "Treesitter shrink selection" })
    end,
  },
}
