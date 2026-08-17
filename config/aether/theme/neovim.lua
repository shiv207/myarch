return {
  {
    "bjarneo/aether.nvim",
    branch = "v3",
    name = "aether",
    priority = 1000,
    opts = {
      colors = {
        bg         = "#32344a",
        dark_bg    = "#262738",
        darker_bg  = "#191a25",
        lighter_bg = "#47485c",

        fg         = "#787c99",
        dark_fg    = "#5a5d73",
        light_fg   = "#8c90a8",
        bright_fg  = "#9a9db3",
        muted      = "#444b6a",

        red        = "#f7768e",
        yellow     = "#e0af68",
        orange     = "#f88b9f",
        green      = "#9ece6a",
        cyan       = "#449dab",
        blue       = "#7aa2f7",
        purple     = "#ad8ee6",
        brown      = "#95535f",

        bright_red    = "#ff7a93",
        bright_yellow = "#ff9e64",
        bright_green  = "#b9f27c",
        bright_cyan   = "#0db9d7",
        bright_blue   = "#7da6ff",
        bright_purple = "#bb9af7",

        accent               = "#7aa2f7",
        cursor               = "#c0caf5",
        foreground           = "#a9b1d6",
        background           = "#1a1b26",
        selection             = "#47485c",
        selection_foreground = "#a9b1d6",
        selection_background = "#47485c",
      },
    },
  },
  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = "aether",
    },
  },
}
