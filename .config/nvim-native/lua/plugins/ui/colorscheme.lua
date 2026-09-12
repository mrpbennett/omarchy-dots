vim.pack.add { { src = "https://github.com/catppuccin/nvim", name = "catppuccin" } }

require("catppuccin").setup({
  flavour = "auto", -- latte, frappe, macchiato, mocha
  background = {    -- :h background
    light = "latte",
    dark = "mocha",
  },
  integrations = {
    aerial = true,
    alpha = true,
    cmp = true,
    dashboard = true,
    flash = true,
    fzf = true,
    grug_far = true,
    gitsigns = true,
    headlines = true,
    illuminate = true,
    indent_blankline = { enabled = true },
    leap = true,
    lsp_trouble = true,
    mason = true,
    mini = true,
    navic = { enabled = true, custom_bg = "lualine" },
    neotest = true,
    neotree = true,
    noice = true,
    notify = true,
    snacks = true,
    telescope = true,
    treesitter_context = true,
    which_key = true,
  },
})

-- setup must be called before loading
vim.cmd.colorscheme "catppuccin-nvim"
