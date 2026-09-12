vim.pack.add {
  { src = "https://github.com/stevearc/conform.nvim" },
}

require("conform").setup({

  default_format_opts = {
    timeout_ms = 3000,
    async = false,
    quiet = false,
    lsp_format = "fallback",
  },

  formatters_by_ft = {
    python = {
      "ruff_fix",
      "ruff_format",
      "ruff_organize_imports",
    },
  },

  format_on_save = {
    timeout_ms = 500,
    lsp_format = "fallback",
    quiet = true,
  },
})
