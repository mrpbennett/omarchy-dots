-- LSP
vim.pack.add {
  { src = "https://github.com/neovim/nvim-lspconfig" },
}

-- ty resolves its .venv relative to the OS process cwd, not the LSP
-- root_dir, and nvim-lspconfig's ty.lua never sets cmd_cwd. That means
-- the server inherits whatever cwd Neovim itself started with, which
-- breaks .venv auto-detection unless Neovim happens to be launched
-- from the project root. Force cwd = root_dir at spawn time, same
-- pattern nvim-lspconfig already uses for csharp_ls/jdtls/ruby_lsp.
vim.lsp.config('ty', {
  cmd = function(dispatchers, config)
    return vim.lsp.rpc.start({ "ty", "server" }, dispatchers, {
      cwd = config.root_dir,
      env = config.cmd_env,
      detached = config.detached,
    })
  end,
})



vim.lsp.enable { "ty", "ruff", "yamlls", "lua_ls", "sqruff" }
