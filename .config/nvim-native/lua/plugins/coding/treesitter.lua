vim.pack.add {
  { src = "https://github.com/nvim-treesitter/nvim-treesitter",             version = "main" },
  { src = "https://github.com/nvim-treesitter/nvim-treesitter-textobjects", version = "main" }
}

local ensure_installed = {
  -- go
  "go",
  "gomod",
  "gowork",
  "gosum",
  -- python
  "ninja",
  "rst",
  -- sql
  "sql"
}

require("nvim-treesitter").install(ensure_installed)

vim.api.nvim_create_autocmd("FileType", {
  pattern = ensure_installed,
  callback = function()
    vim.treesitter.start()
  end,
})

-- ## nvim-treesitter-textobjects ## --
require('nvim-treesitter-textobjects').setup({
  move = {
    enable = true,
    set_jumps = true, -- whether to set jumps in the jumplist
    keys = {
      goto_next_start = { ["]f"] = "@function.outer", ["]c"] = "@class.outer", ["]a"] = "@parameter.inner" },
      goto_next_end = { ["]F"] = "@function.outer", ["]C"] = "@class.outer", ["]A"] = "@parameter.inner" },
      goto_previous_start = { ["[f"] = "@function.outer", ["[c"] = "@class.outer", ["[a"] = "@parameter.inner" },
      goto_previous_end = { ["[F"] = "@function.outer", ["[C"] = "@class.outer", ["[A"] = "@parameter.inner" },
    }
  }
})
