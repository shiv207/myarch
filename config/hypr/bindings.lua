-- Personal keybinding overrides (loaded after Omarchy defaults).
-- Merged with the arch rice: vim-style H/J/K/L focus + shift-move,
-- and SUPER+SPACE / SUPER+KP_Enter open the terminal.

-- Drop Omarchy's single-key binds that collide with the vim scheme
-- (Omarchy menu stays reachable on SUPER+ALT+SPACE).
hl.unbind("SUPER + J")        -- was toggle split
hl.unbind("SUPER + K")        -- was keybindings menu
hl.unbind("SUPER + L")        -- was workspace layout toggle
hl.unbind("SUPER + SPACE")    -- was omarchy menu

-- Vim-style focus (arch rice).
o.bind("SUPER + H", "Focus left", hl.dsp.focus({ direction = "l" }))
o.bind("SUPER + J", "Focus down", hl.dsp.focus({ direction = "d" }))
o.bind("SUPER + K", "Focus up", hl.dsp.focus({ direction = "u" }))
o.bind("SUPER + L", "Focus right", hl.dsp.focus({ direction = "r" }))

-- Vim-style move window (arch rice).
o.bind("SUPER + SHIFT + H", "Move left", hl.dsp.window.move({ direction = "l" }))
o.bind("SUPER + SHIFT + J", "Move down", hl.dsp.window.move({ direction = "d" }))
o.bind("SUPER + SHIFT + K", "Move up", hl.dsp.window.move({ direction = "u" }))
o.bind("SUPER + SHIFT + L", "Move right", hl.dsp.window.move({ direction = "r" }))

-- Terminal: main Enter already opens it via Omarchy (SUPER+RETURN);
-- add the numpad Enter and SUPER+SPACE (arch rice).
o.bind("SUPER + KP_Enter", "Terminal", "ghostty")
o.bind("SUPER + SPACE", "Terminal", "ghostty")

-- ALT+SPACE opens the rofi app launcher (viegphunt).
-- Omarchy menu stays reachable on SUPER+ALT+SPACE.
o.bind("ALT + SPACE", "Apps (viegphunt)", "exec ~/.config/viegphunt/app_launcher.sh")

-- Point browser / file manager at the apps actually installed here
-- (Omarchy's tokens resolved to nautilus / an unset xdg browser).
-- Unbind RETURN *and* ENTER: Hyprland normalizes RETURN->ENTER, so the
-- original Omarchy bind lives on the ENTER key and must be cleared there
-- too, otherwise one keypress fires both binds (the old "double zen" bug).
hl.unbind("SUPER + SHIFT + RETURN")
hl.unbind("SUPER + SHIFT + ENTER")
hl.unbind("SUPER + SHIFT + B")
hl.unbind("SUPER + SHIFT + ALT + B")
hl.unbind("SUPER + SHIFT + F")
hl.unbind("SUPER + SHIFT + ALT + F")

-- SUPER+SHIFT+ENTER opens Opencode in a terminal.
o.bind("SUPER + SHIFT + RETURN", "Opencode", "ghostty -e opencode")
o.bind("SUPER + SHIFT + B", "Browser", "zen-browser")
o.bind("SUPER + SHIFT + ALT + B", "Browser (private)", "zen-browser --private-window")
o.bind("SUPER + SHIFT + F", "File manager", "nemo")
o.bind("SUPER + SHIFT + ALT + F", "File manager (cwd)", "nemo")

-- Theme / wallpaper controls.
-- SUPER+SHIFT+N is bound to Editor by Omarchy defaults; clear it first.
hl.unbind("SUPER + SHIFT + N")
o.bind("SUPER + ALT + T",   "Theme menu", "exec ~/.config/hypr/theme-switcher.sh")
o.bind("SUPER + SHIFT + T", "Theme menu", "exec ~/.config/hypr/theme-switcher.sh")
o.bind("SUPER + SHIFT + N", "Next wallpaper (theme)", "arch-theme-bg-next")
o.bind("SUPER + N",         "Background options",     "exec ~/.config/hypr/wallpaper-switcher.sh")

-- Clipboard manager (Quickshell overlay on Super+V and Super+Shift+V; Rofi on Super+Ctrl+V)
hl.unbind("SUPER + V")
hl.unbind("SUPER + SHIFT + V")
hl.unbind("SUPER + CTRL + V")
o.bind("SUPER + V",         "Clipboard manager",        "arch-shell shell toggle omarchy.clipboard")
o.bind("SUPER + SHIFT + V", "Clipboard manager",        "arch-shell shell toggle omarchy.clipboard")
o.bind("SUPER + CTRL + V",  "Clipboard manager (rofi)", "exec ~/.config/viegphunt/clipboard_launcher.sh")





