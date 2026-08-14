-- Options are automatically loaded before lazy.nvim startup.
require("config.remote_clipboard").setup()

vim.opt.mouse = "a"
vim.opt.swapfile = false
vim.opt.autoread = true

-- stop auto comments
vim.opt.formatoptions:remove({ "c", "r", "o" })

-- python lazyvim
vim.g.lazyvim_python_lsp = "ty"
vim.g.lazyvim_python_ruff = "ruff"

-- disable the option to require prettier config file
vim.g.lazyvim_prettier_needs_config = false
