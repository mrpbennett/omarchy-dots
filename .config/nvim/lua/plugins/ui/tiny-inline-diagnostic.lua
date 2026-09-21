return {
  {
    {
      "rachartier/tiny-inline-diagnostic.nvim",
      event = "VeryLazy",
      priority = 1000,
      opts = {
        preset = "powerline",
        add_messages = {
          display_count = true,
        },
        multilines = {
          enabled = true,
        },
      },
    },
  }
}
