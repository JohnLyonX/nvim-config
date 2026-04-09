return {
  "akinsho/toggleterm.nvim",
  version = "*",
  config = function()
    local toggleterm = require("toggleterm")

    toggleterm.setup({
      size = 20,
      open_mapping = [[<leader>t]],
      insert_mappings = false,
      direction = "float",
      float_opts = {
        border = "curved",
      },
    })
  end,
}
