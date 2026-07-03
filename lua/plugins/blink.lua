return {
    {
        "saghen/blink.cmp",
        opts = {
            keymap = {
                -- NOTE: LazyVim's `extras/coding/blink.lua` overrides Blink's
                -- default <C-y> mapping with { "select_and_accept" }, dropping
                -- Blink's "fallback" action. Consequently, <C-y> does nothing
                -- when completion is not visible instead of retaining Neovim's
                -- native "copy character from the line above" behavior.
                -- Consider upstreaming this fallback to LazyVim.
                ["<C-y>"] = { "select_and_accept", "fallback" },
            },
        },
    },
}
