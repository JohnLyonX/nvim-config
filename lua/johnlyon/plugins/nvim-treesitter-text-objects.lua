return {
  "nvim-treesitter/nvim-treesitter-textobjects",
  branch = "main",
  lazy = true,
  init = function()
    vim.g.no_plugin_maps = true
  end,
  config = function()
    require("nvim-treesitter-textobjects").setup({
      select = {
        lookahead = true,
      },
      move = {
        set_jumps = true,
      },
    })

    local select = require("nvim-treesitter-textobjects.select")
    local move = require("nvim-treesitter-textobjects.move")

    local select_keymaps = {
      ["aa"] = "@parameter.outer",
      ["ia"] = "@parameter.inner",
      ["af"] = "@function.outer",
      ["if"] = "@function.inner",
      ["ac"] = "@class.outer",
      ["ic"] = "@class.inner",
    }

    for lhs, query in pairs(select_keymaps) do
      vim.keymap.set({ "x", "o" }, lhs, function()
        select.select_textobject(query, "textobjects")
      end, { desc = "Treesitter textobject" })
    end

    local move_keymaps = {
      ["]m"] = { fn = move.goto_next_start, query = "@function.outer" },
      ["[m"] = { fn = move.goto_previous_start, query = "@function.outer" },
      ["]c"] = { fn = move.goto_next_start, query = "@class.outer" },
      ["[c"] = { fn = move.goto_previous_start, query = "@class.outer" },
      ["]f"] = { fn = move.goto_next_start, query = "@call.outer" },
      ["[f"] = { fn = move.goto_previous_start, query = "@call.outer" },
    }

    for lhs, item in pairs(move_keymaps) do
      vim.keymap.set({ "n", "x", "o" }, lhs, function()
        item.fn(item.query, "textobjects")
      end, { desc = "Treesitter move" })
    end
  end,
}
