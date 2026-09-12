vim.pack.add {
  { src = "https://github.com/mason-org/mason.nvim" },
  { src = "https://github.com/WhoIsSethDaniel/mason-tool-installer.nvim" },
}

require("mason").setup()

require("mason-tool-installer").setup {
  ensure_installed = {
    "ty",
    "ruff",
    "yaml-language-server",
    "lua-language-server",
    "sqruff",
  },
}
