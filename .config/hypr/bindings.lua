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
hl.unbind("CTRL + ALT + H")

-- Dusk mode switching (mrpbennett.dusk auto theme).
o.bind("SUPER + SHIFT + ALT + Z", "Dusk: Auto mode", "omarchy-auto-theme solar")
o.bind("SUPER + SHIFT + ALT + L", "Dusk: Light mode", "omarchy-auto-theme manual light")
o.bind("SUPER + SHIFT + ALT + D", "Dusk: Dark mode", "omarchy-auto-theme manual dark")

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

-- OMACUT keybinding setup
hl.unbind("PRINT")
hl.unbind("F12")
hl.unbind("ALT + SHIFT + 4")

o.bind("SHIFT + ALT + 4", "Screenshot", "omasnap")

hl.layer_rule({
  match = { namespace = "^omasnap$" },
  no_anim = true,
  animation = "none",
})

-- FileBlade
local function fileblade(method, fallback)
  local call = "OMARCHY_SHELL_IPC_TIMEOUT=0.4s omarchy-shell data-goblin.fileblade.control " ..
      method .. " >/dev/null 2>&1"
  if fallback then return call .. " || hyprctl dispatch " .. string.format("%q", fallback) end
  return call
end

o.bind("SUPER + B", "Open or close the left blade", fileblade("toggleBladeFocus left"))

for _, direction in ipairs({ { "LEFT", "l" }, { "RIGHT", "r" }, { "UP", "u" }, { "DOWN", "d" } }) do
  hl.unbind("SUPER + " .. direction[1])
  o.bind("SUPER + " .. direction[1], "Focus " .. direction[1]:lower() .. " (blade aware)",
    fileblade("focusDirection " .. direction[2], string.format('hl.dsp.focus({ direction = %q })', direction[2])))
  hl.unbind("SUPER + SHIFT + " .. direction[1])
  o.bind("SUPER + SHIFT + " .. direction[1], "Swap " .. direction[1]:lower() .. " (blade aware)",
    fileblade("windowSwap " .. direction[2], string.format('hl.dsp.window.swap({ direction = %q })', direction[2])))
end

hl.unbind("SUPER + W")
o.bind("SUPER + W", "Close window or blade", fileblade("windowClose", "hl.dsp.window.close()"))
hl.unbind("SUPER + T")
o.bind("SUPER + T", "Toggle window floating or blade dock",
  fileblade("windowToggle", 'hl.dsp.window.float({ action = "toggle" })'))

local resize_binds = {
  { "SUPER + code:20",                "Expand window left",          -100, 0 },
  { "SUPER + code:21",                "Shrink window left",          100,  0 },
  { "SUPER + SHIFT + code:20",        "Shrink window up",            0,    -100 },
  { "SUPER + SHIFT + code:21",        "Expand window down",          0,    100 },
  { "SUPER + ALT + code:20",          "Expand window left a little", -25,  0 },
  { "SUPER + ALT + code:21",          "Shrink window left a little", 25,   0 },
  { "SUPER + SHIFT + ALT + code:20",  "Shrink window up a little",   0,    -25 },
  { "SUPER + SHIFT + ALT + code:21",  "Expand window down a little", 0,    25 },
  { "SUPER + CTRL + code:20",         "Expand window left a lot",    -300, 0 },
  { "SUPER + CTRL + code:21",         "Shrink window left a lot",    300,  0 },
  { "SUPER + CTRL + SHIFT + code:20", "Shrink window up a lot",      0,    -300 },
  { "SUPER + CTRL + SHIFT + code:21", "Expand window down a lot",    0,    300 },
}
for _, bind in ipairs(resize_binds) do
  hl.unbind(bind[1])
  o.bind(bind[1], bind[2] .. " (blade aware)",
    fileblade("windowResize " .. bind[3] .. " " .. bind[4],
      string.format("hl.dsp.window.resize({ x = %d, y = %d, relative = true })", bind[3], bind[4])))
end

-- strata-installer: file-manager start
hl.unbind("SUPER + SHIFT + F")
hl.unbind("SUPER + ALT + SHIFT + F")
o.bind("SUPER + SHIFT + F", "File manager", { launch = "/home/pb/.local/bin/strata" })
o.bind("SUPER + ALT + SHIFT + F", "File manager (cwd)",
  "uwsm-app -- /home/pb/.local/bin/strata \"$(omarchy-cmd-terminal-cwd)\"")
-- strata-installer: file-manager end
