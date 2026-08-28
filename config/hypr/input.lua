-- Keep only your personal input overrides here. Uncommented settings below
-- replace Omarchy's defaults.

-- Keyboard layout and options.
-- See https://wiki.hypr.land/Configuring/Basics/Variables/#input
-- hl.config({
--   input = {
--     -- Use multiple keyboard layouts and switch between them with Left Alt + Right Alt.
--     kb_layout = "us,dk,eu",
--     kb_options = "compose:caps,shift:both_capslock_cancel,grp:alts_toggle",
--
--     -- Use a specific keyboard variant if needed (e.g. intl for international keyboards).
--     kb_variant = "intl",
--
--     -- Change speed of keyboard repeat.
--     repeat_rate = 40,
--     repeat_delay = 250,
--
--     -- Start with numlock on by default.
--     numlock_by_default = true,
--
--     -- Increase sensitivity for mouse/trackpad (default: 0).
--     sensitivity = 0.35,
--
--     -- Turn off mouse acceleration (default: adaptive).
--     accel_profile = "flat",
--
--     touchpad = {
--       -- Use natural (inverse) scrolling.
--       natural_scroll = true,
--
--       -- Use two-finger clicks for right-click instead of lower-right corner.
--       clickfinger_behavior = true,
--
--       -- Control the speed of your scrolling.
--       scroll_factor = 0.4,
--
--       -- Enable the touchpad while typing.
--       disable_while_typing = false,
--
--       -- Left-click-and-drag with three fingers.
--       drag_3fg = 1,
--     },
--   },
-- })

-- App-specific touchpad scroll speeds.
-- o.window("(Alacritty|kitty|foot)", { scroll_touchpad = 1.5 })
-- o.window("com.mitchellh.ghostty", { scroll_touchpad = 0.2 })

-- Full touchpad configuration.
hl.config({
  input = {
    touchpad = {
      -- macOS-style natural (inverse) scrolling.
      natural_scroll = true,

      -- Two-finger tap = right-click, instead of corner-clicking.
      clickfinger_behavior = true,

      -- Slower scroll speed (less trackpad travel).
      scroll_factor = 0.5,

      -- Ignore the touchpad while typing.
      disable_while_typing = true,
    },
  },
})

-- Trackpad gestures. See https://wiki.hypr.land/Configuring/Advanced-and-Cool/Gestures/

-- 3-finger swipe left/right: switch workspaces.
hl.gesture({ fingers = 3, direction = "horizontal", action = "workspace" })

-- 3-finger swipe up: enter fullscreen (string action = native gesture path).
hl.gesture({ fingers = 3, direction = "up", action = "fullscreen" })

-- 3-finger swipe down: exit fullscreen.
hl.gesture({ fingers = 3, direction = "down", action = "fullscreen" })

-- 4-finger swipe left/right: move the focused window between workspaces.
hl.gesture({ fingers = 4, direction = "horizontal", action = "move" })

-- 2-finger pinch out (spread): zoom in. Pinch in (bring together): zoom out.
hl.gesture({
  fingers = 2,
  direction = "pinchout",
  action = "cursor_zoom",
  zoom_level = 1.2,
  mode = "mult",
})
hl.gesture({
  fingers = 2,
  direction = "pinchin",
  action = "cursor_zoom",
  zoom_level = 0.8,
  mode = "mult",
})
