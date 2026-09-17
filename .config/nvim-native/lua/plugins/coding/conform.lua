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

  formatters = {
    --
    sqruff = {
      -- sqruff fix emits an extra trailing newline on stdout; strip trailing blank lines via sed.
      -- Dialect is inferred from the filename prefix (bq_/pg_/trino_/tsql_/vert_) since sqruff
      -- doesn't merge a project-local .sqruff with this shared config.
      command = "sh",
      args = function(_, ctx)
        local sqruff = require("util.sqruff")
        local dialect = sqruff.dialect(ctx.filename)
        return {
          "-c",
          "sqruff fix --format none --config "
          .. sqruff.config(dialect)
          .. " --dialect "
          .. dialect
          .. " - | sed -e :a -e '/^$/{$d;N;ba' -e '}'",
        }
      end,
      stdin = true,
    },
  },

  format_on_save = {
    timeout_ms = 500,
    lsp_format = "fallback",
    quiet = true,
  },
})
