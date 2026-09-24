-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

vim.keymap.set("n", "-", "<CMD>Oil<CR>", { desc = "Open parent directory" })

-- hunk diff
vim.keymap.set("n", "<leader>gh", function() Snacks.terminal("hunk diff") end, { desc = "Hunk Diff" })
