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
    local swap = require("nvim-treesitter-textobjects.swap")
    local move = require("nvim-treesitter-textobjects.move")
    local ts_repeat_move = require("nvim-treesitter-textobjects.repeatable_move")

    local select_keymaps = {
      ["a="] = "@assignment.outer",
      ["i="] = "@assignment.inner",
      ["l="] = "@assignment.lhs",
      ["r="] = "@assignment.rhs",
      ["a:"] = "@property.outer",
      ["i:"] = "@property.inner",
      ["l:"] = "@property.lhs",
      ["r:"] = "@property.rhs",
      ["aa"] = "@parameter.outer",
      ["ia"] = "@parameter.inner",
      ["ai"] = "@conditional.outer",
      ["ii"] = "@conditional.inner",
      ["al"] = "@loop.outer",
      ["il"] = "@loop.inner",
      ["af"] = "@call.outer",
      ["if"] = "@call.inner",
      ["am"] = "@function.outer",
      ["im"] = "@function.inner",
      ["ac"] = "@class.outer",
      ["ic"] = "@class.inner",
    }

    for lhs, query in pairs(select_keymaps) do
      vim.keymap.set({ "x", "o" }, lhs, function()
        select.select_textobject(query, "textobjects")
      end, { desc = "Treesitter textobject" })
    end

    local swap_next = {
      ["<leader>na"] = "@parameter.inner",
      ["<leader>n:"] = "@property.outer",
      ["<leader>nm"] = "@function.outer",
    }

    for lhs, query in pairs(swap_next) do
      vim.keymap.set("n", lhs, function()
        swap.swap_next(query)
      end, { desc = "Treesitter swap next" })
    end

    local swap_previous = {
      ["<leader>pa"] = "@parameter.inner",
      ["<leader>p:"] = "@property.outer",
      ["<leader>pm"] = "@function.outer",
    }

    for lhs, query in pairs(swap_previous) do
      vim.keymap.set("n", lhs, function()
        swap.swap_previous(query)
      end, { desc = "Treesitter swap previous" })
    end

    local move_keymaps = {
      ["]f"] = { fn = move.goto_next_start, query = "@call.outer", group = "textobjects" },
      ["]m"] = { fn = move.goto_next_start, query = "@function.outer", group = "textobjects" },
      ["]c"] = { fn = move.goto_next_start, query = "@class.outer", group = "textobjects" },
      ["]i"] = { fn = move.goto_next_start, query = "@conditional.outer", group = "textobjects" },
      ["]l"] = { fn = move.goto_next_start, query = "@loop.outer", group = "textobjects" },
      ["]s"] = { fn = move.goto_next_start, query = "@scope", group = "locals" },
      ["]z"] = { fn = move.goto_next_start, query = "@fold", group = "folds" },
      ["]F"] = { fn = move.goto_next_end, query = "@call.outer", group = "textobjects" },
      ["]M"] = { fn = move.goto_next_end, query = "@function.outer", group = "textobjects" },
      ["]C"] = { fn = move.goto_next_end, query = "@class.outer", group = "textobjects" },
      ["]I"] = { fn = move.goto_next_end, query = "@conditional.outer", group = "textobjects" },
      ["]L"] = { fn = move.goto_next_end, query = "@loop.outer", group = "textobjects" },
      ["[f"] = { fn = move.goto_previous_start, query = "@call.outer", group = "textobjects" },
      ["[m"] = { fn = move.goto_previous_start, query = "@function.outer", group = "textobjects" },
      ["[c"] = { fn = move.goto_previous_start, query = "@class.outer", group = "textobjects" },
      ["[i"] = { fn = move.goto_previous_start, query = "@conditional.outer", group = "textobjects" },
      ["[l"] = { fn = move.goto_previous_start, query = "@loop.outer", group = "textobjects" },
      ["[F"] = { fn = move.goto_previous_end, query = "@call.outer", group = "textobjects" },
      ["[M"] = { fn = move.goto_previous_end, query = "@function.outer", group = "textobjects" },
      ["[C"] = { fn = move.goto_previous_end, query = "@class.outer", group = "textobjects" },
      ["[I"] = { fn = move.goto_previous_end, query = "@conditional.outer", group = "textobjects" },
      ["[L"] = { fn = move.goto_previous_end, query = "@loop.outer", group = "textobjects" },
    }

    for lhs, item in pairs(move_keymaps) do
      vim.keymap.set({ "n", "x", "o" }, lhs, function()
        item.fn(item.query, item.group)
      end, { desc = "Treesitter move" })
    end

    vim.keymap.set({ "n", "x", "o" }, ";", ts_repeat_move.repeat_last_move)
    vim.keymap.set({ "n", "x", "o" }, ",", ts_repeat_move.repeat_last_move_opposite)
    vim.keymap.set({ "n", "x", "o" }, "f", ts_repeat_move.builtin_f_expr, { expr = true })
    vim.keymap.set({ "n", "x", "o" }, "F", ts_repeat_move.builtin_F_expr, { expr = true })
    vim.keymap.set({ "n", "x", "o" }, "t", ts_repeat_move.builtin_t_expr, { expr = true })
    vim.keymap.set({ "n", "x", "o" }, "T", ts_repeat_move.builtin_T_expr, { expr = true })
  end,
}
