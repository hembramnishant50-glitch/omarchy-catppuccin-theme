return {
    {
        "bjarneo/aether.nvim",
        name = "aether",
        priority = 1000,
        opts = {
            disable_italics = false,
            colors = {
                -- Monotone shades (Catppuccin Macchiato Base)
                base00 = "#1e2030", -- Default background
                base01 = "#181926", -- Lighter background (status bars)
                base02 = "#363a4f", -- Selection background
                base03 = "#5b6078", -- Comments, invisibles
                base04 = "#9399b2", -- Dark foreground
                base05 = "#cad3f5", -- Default foreground (Text)
                base06 = "#f4dbd6", -- Light foreground
                base07 = "#b8c0e0", -- Light background

                -- Accent colors (Your Purple + Macchiato Palette)
                base08 = "#ed8796", -- Variables, errors (Red)
                base09 = "#f5a97f", -- Integers, constants (Orange)
                base0A = "#eed49f", -- Classes, types (Yellow)
                base0B = "#a6da95", -- Strings (Green)
                base0C = "#8bd5ca", -- Support, regex (Teal)
                base0D = "#be9aee", -- Functions, keywords (Your Theme Purple)
                base0E = "#c6a0f6", -- Keywords, storage (Mauve)
                base0F = "#f0c6c6", -- Special, URLs (Flamingo)
            },
        },
        config = function(_, opts)
            require("aether").setup(opts)
            vim.cmd.colorscheme("aether")

            -- Enable hot reload
            require("aether.hotreload").setup()
        end,
    },
    {
        "LazyVim/LazyVim",
        opts = {
            colorscheme = "aether",
        },
    },
}