-- Prevent vim-dadbod from remapping trino:// -> presto://
-- custom adapter and schema support are used. Must be set before lazy loads
vim.g.db_adapters = { trino = "trino" }

-- bootstrap lazy.nvim, LazyVim and plugins
require("config.lazy")

vim.g.db_adapter_trino = "db#adapter#trino#"
