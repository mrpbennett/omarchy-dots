-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

local map = vim.keymap.set

map("n", "-", "<CMD>Oil<CR>", { desc = "Open parent directory" })

-- Hunk.dev
map("n", "<leader>ohh", function() Snacks.terminal("hunk diff") end, { desc = "Hunk Diff" })
map("n", "<leader>ohm", function() Snacks.terminal("hunk diff origin/main") end, { desc = "Hunk Diff - origin/main" })
