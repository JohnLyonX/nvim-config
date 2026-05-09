-- 注：原 <leader>d* 与 LSP 的 <leader>d（行内诊断浮窗）前缀冲突，
-- 按 <leader>d 时 nvim 要等 timeoutlen 才能确定是不是 duck 命令。
-- 移到 <leader>fm*（"摸鱼"命名空间，和 cellular-automaton 同组）。
return {
  "tamton-aquib/duck.nvim",
  keys = {
    {
      "<leader>fmd",
      function() require("duck").hatch("🦆", 5) end,
      desc = "Hatch a duck",
    },
    {
      "<leader>fmc",
      function() require("duck").hatch("🐈", 10) end,
      desc = "Hatch a cat",
    },
    {
      "<leader>fmk",
      function() require("duck").cook() end,
      desc = "Cook (kill) nearest duck",
    },
    {
      "<leader>fma",
      function() require("duck").cook_all() end,
      desc = "Cook all ducks",
    },
  },
}
