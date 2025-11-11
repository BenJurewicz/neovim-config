return {
    "catppuccin/nvim",
    name = "catppuccin",
    priority = 1000,
    opts = {
        flavour = "frappe",
        transparent_background = true,
        float = {
            transparent = true, -- enable transparent floating windows
        },
        auto_integrations = true,
        color_overrides = {
            frappe = {
                -- Values from Mocha theme
                -- This way we have a theme with frappe background and mocha foreground
                rosewater = "#f5e0dc",
                flamingo = "#f2cdcd",
                pink = "#f5c2e7",
                mauve = "#cba6f7",
                red = "#f38ba8",
                maroon = "#eba0ac",
                peach = "#fab387",
                yellow = "#f9e2af",
                green = "#a6e3a1",
                teal = "#94e2d5",
                sky = "#89dceb",
                sapphire = "#74c7ec",
                blue = "#89b4fa",
                lavender = "#b4befe",
                text = "#cdd6f4",
                subtext1 = "#bac2de",
                subtext0 = "#a6adc8",
            },
        },
        custom_highlights = function(colors)
            return {
                -- Used in noice.lua for makinng the Lsp Hover(Normal mode: Shift+K) have a background.
                LspHoverNormal = { bg = colors.mantle },
            }
        end,
    },
}
