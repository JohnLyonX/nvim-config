return {
  "greggh/claude-code.nvim",
  dependencies = {
    "nvim-lua/plenary.nvim",
  },
  cmd = { "ClaudeCode", "ClaudeCodeContinue", "ClaudeCodeResume", "ClaudeCodeVerbose" },
  keys = {
    { "<leader>cc", "<cmd>ClaudeCode<cr>",         desc = "Toggle Claude Code" },
    { "<leader>cC", "<cmd>ClaudeCodeContinue<cr>", desc = "Claude Code Continue" },
    { "<leader>cr", "<cmd>ClaudeCodeResume<cr>",   desc = "Claude Code Resume" },
  },
  opts = {
    window = {
      split_ratio = 0.4,
      position = "vertical",
      enter_insert = true,
      hide_numbers = true,
      hide_signcolumn = true,
    },
    refresh = {
      enable = true,
      updatetime = 100,
      timer_interval = 1000,
      show_notifications = true,
    },
    git = {
      use_git_root = true,
    },
    shell = {
      separator = "&&",
      pushd_cmd = "pushd",
      popd_cmd = "popd",
    },
    command = "claude",
    command_variants = {
      continue = "--continue",
      resume = "--resume",
      verbose = "--verbose",
    },
  },
}
