return {
    {
        "catppuccin/nvim",
        name = "catppuccin",
        priority = 1000,
        opts = {
            flavour = "mocha", -- Using Mocha as the base
            transparent_background = true, -- Set to true to match transparent terminal aesthetics
            term_colors = true,
            color_overrides = {
                mocha = {
                    -- Overriding standard Mocha colors with your custom purples
                    mauve = "#c6a0f6",
                    blue = "#c6a0f6",
                    green = "#c6a0f6",
                    teal = "#c19cf2", 
                },
            },
            integrations = {
                cmp = true,
                gitsigns = true,
                nvimtree = true,
                treesitter = true,
                notify = true,
                mini = {
                    enabled = true,
                    indentscope_color = "",
                },
            },
        },
    },
    {
        "LazyVim/LazyVim",
        opts = {
            colorscheme = "catppuccin",
        },
    },
}