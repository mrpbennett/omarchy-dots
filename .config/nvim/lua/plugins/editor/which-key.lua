-- https://github.com/folke/which-key.nvim
return {
  {
    "folke/which-key.nvim",
    event = "VeryLazy",
    opts = {
      preset = "helix",
      spec = {
        { "<leader>o", group = "open tuis", icon = { icon = "󱁤" } },
        { "<leader>oh", group = "hunk", icon = { icon = "󱁤" } },
      },
    },
  },
}
