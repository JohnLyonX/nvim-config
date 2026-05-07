return {
  "tamton-aquib/duck.nvim",
  keys = {
    {
      "<leader>dd",
      function() require("duck").hatch("🦆", 5) end,
      desc = "Hatch a duck",
    },
    {
      "<leader>dc",
      function() require("duck").hatch("🐈", 10) end,
      desc = "Hatch a cat",
    },
    {
      "<leader>dk",
      function() require("duck").cook() end,
      desc = "Cook (kill) nearest duck",
    },
    {
      "<leader>da",
      function() require("duck").cook_all() end,
      desc = "Cook all ducks",
    },
  },
}
