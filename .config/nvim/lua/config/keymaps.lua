-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

local map = vim.keymap.set

--
map("n", "<leader>fo", function()
  Snacks.terminal(nil, {
    win = {
      style = "float",
      border = "rounded",
      title = " Terminal ",
      title_pos = "center",
    },
  })
end, { desc = "Terminal (floating)" })

--

map("n", "-", "<CMD>Oil<CR>", { desc = "Open parent directory" })

-- btop
map("n", "<leader>ob", function()
  Snacks.terminal("btop", {
    win = {
      title = "BTOP",
      border = "rounded"
    }
  })
end, { desc = "btop" })

-- Hunk.dev
map("n", "<leader>ohh", function()
  Snacks.terminal("hunk diff", {
    win = {
      title = "Hunk Diff",
      border = "rounded"
    }
  })
end, { desc = "Hunk Diff" })
map("n", "<leader>ohm", function()
  Snacks.terminal("hunk diff origin/main", {
    win = {
      title = "Hunk Diff origin/main",
      border = "rounded"
    }
  })
end, { desc = "Hunk Diff - origin/main" })

-- K9s
map("n", "<leader>ok", function()
  Snacks.terminal("k9s", {
    win = {
      title = "Kubernetes",
      border = "rounded"
    }
  })
end, { desc = "K9s" })

-- Dash PR
map("n", "<leader>od", function()
  Snacks.terminal("gh dash", {
    win = {
      title = "Dash",
      border = "rounded"
    }
  })
end, { desc = "GH Dash" })
