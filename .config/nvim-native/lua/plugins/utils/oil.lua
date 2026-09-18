vim.pack.add({
  'https://github.com/stevearc/oil.nvim',
})

require("oil").setup({
  view_options = {show_hidden = true}
})


local map = vim.keymap.set

map("n", "-", "<CMD>Oil<CR>", { desc = "Open parent directory" })

