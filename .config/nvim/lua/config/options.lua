-- Options are automatically loaded before lazy.nvim startup.
require("config.remote_clipboard").setup()

vim.opt.relativenumber = true
vim.g.autoformat = true

vim.opt.mouse = "a"
vim.opt.swapfile = false

vim.opt.formatoptions:remove({"c", "r", "o"})

vim.g.lazyvim_python_lsp = "ty"
vim.g.lazyvim_python_ruff = "ruff"

vim.g.lazyvim_prettier_needs_config = false
