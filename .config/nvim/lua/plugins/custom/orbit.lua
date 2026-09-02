return {
  {
    dir = "/home/pb/Projects/orbit.nvim",
    config = function()
      require("orbit").setup({
        winbar = false,
        schema_width = 40,
        saved_query_dirs = {
          { work = "/home/pb/Work/pulsepoint/pbennett-monorepo/sql" },
          { omarchysesh = "/home/pb/Projects/omarchy-sesh/sql" },
        },

        -- keymaps
        keymaps = {
          workspace = "<leader>D",
          execute = "<leader>E",
          cancel = "<leader>X",
          select_profile = "<leader>P",
          browse = "<leader>B",
        },
      })
    end,
  },
}
