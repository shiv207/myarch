-- Fallback only when Omarchy has not staged a neovim.lua for the current theme.
local omarchy_theme = vim.fn.expand("~/.local/state/omarchy/current/theme/neovim.lua")

return {
    "catppuccin/nvim",
    name = "catppuccin",
    enabled = vim.fn.filereadable(omarchy_theme) == 0,
    priority = 1000,

    config = function()
        require("catppuccin").setup({
            flavour = "mocha",
            transparent_background = true,
            float = {
                transparent = true,
            }
        })
        vim.cmd.colorscheme("catppuccin")
    end
}
