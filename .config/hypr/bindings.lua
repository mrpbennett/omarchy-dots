-- Keep only your personal keybinding overrides here. Add new bindings or
-- unbind defaults before replacing them.

-- See current bindings and descriptions:
--   omarchy menu keybindings --print

-- To disable every Omarchy default binding, set this in
-- ~/.config/hypr/hyprland.lua before require("default.hypr.omarchy"), then add
-- only the bindings you want below:
--   omarchy_default_bindings = false

-- To disable all preinstalled app/webapp bindings, set:
--   omarchy_preinstalled_bindings = false

-- Add a new binding.
-- o.bind("SUPER + SHIFT + R", "SSH", "alacritty -e ssh your-server")

-- Change an existing binding by unbinding it first, then binding the key again.
-- This example changes SUPER+SPACE from the launcher to the Omarchy root menu.
-- hl.unbind("SUPER + SPACE")
-- o.bind("SUPER + SPACE", "Omarchy menu", "omarchy-menu toggle root")

-- Disable a default binding without replacing it.
-- hl.unbind("SUPER + SHIFT + B")

-- Move Screenshot from PRINT to SUPER + SHIFT + 3.
hl.unbind("PRINT")
o.bind("SUPER + ALT + 3", "Screenshot", "omarchy-capture-screenshot")

-- Swap Tmux and Herdr keybindings.
-- SUPER + ALT + RETURN was: Tmux (terminal-tmux)
hl.unbind("SUPER + ALT + RETURN")
o.bind("SUPER + ALT + RETURN", "Herdr", { omarchy = "terminal-herdr" })
-- SUPER + CTRL + RETURN was: Herdr (terminal-herdr)
hl.unbind("SUPER + CTRL + RETURN")
o.bind("SUPER + CTRL + RETURN", "Tmux", { omarchy = "terminal-tmux" })
-- SUPER + ALT + K was: Tmux keybindings
hl.unbind("SUPER + ALT + K")
o.bind("SUPER + ALT + K", "Herdr keybindings", "omarchy-menu-herdr-keybindings")
-- SUPER + CTRL + K was: Herdr keybindings
hl.unbind("SUPER + CTRL + K")
o.bind("SUPER + CTRL + K", "Tmux keybindings", "omarchy-menu-tmux-keybindings")

-- Logitech MX Keys examples:
-- o.bind("SUPER + SHIFT + S", nil, "omarchy-capture-screenshot")
-- o.bind("SUPER + H", nil, "voxtype record toggle")
-- o.bind("SUPER + PERIOD", nil, "omarchy-shell shell toggle omarchy.emojis")
