vim.pack.add {
  {src = "https://github.com/folke/flash.nvim"}
}

require("flash").setup({

})

local map = vim.keymap.set

map({"n","x","o"}, "s", function() require('flash').jump() end, {desc = "Flash"})
