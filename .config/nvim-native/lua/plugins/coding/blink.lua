-- AUTO COMPLETE
vim.pack.add({ 'https://github.com/saghen/blink.lib', 'https://github.com/saghen/blink.cmp' })

local cmp = require('blink.cmp')
cmp.build():pwait()
cmp.setup({
  keymap = { preset = 'super-tab' },
  appearance = {
    nerd_font_variant = 'mono'
  },
  completion = {
    documentation = { auto_show = true },
    menu = {
      draw = {
        columns = {
          { "kind_icon" },
          { "label",    "label_description", gap = 1 },
          { "kind" },
        },
      },
    },
  },
  -- friendly-snippets
  snippets = { preset = 'default' },
  sources = {
    default = { 'lsp', 'path', 'snippets', 'buffer' },
  },
})
