return {
    {
        "folke/noice.nvim",
        opts = {
            presets = {
                lsp_doc_border = true,
            },
            lsp = {
                hover = {
                    opts = {
                        win_options = {
                            -- Makes the Lsp Hover(Normal mode: Shift+K) have a background.
                            -- It is probably possible to use already defined highlight groups for it,
                            -- as signature view (the autocompletion that appears while typing)
                            -- already has the desired background, but this will do
                            -- and allows for more customization later on
                            winhighlight = "Normal:LspHoverNormal",
                        },
                    },
                },
            },
        },
    },
}
