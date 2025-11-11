-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
--
-- Add any additional autocmds here
-- with `vim.api.nvim_create_autocmd`
--
-- Or remove existing autocmds by their group name (which is prefixed with `lazyvim_` for the defaults)
-- e.g. vim.api.nvim_del_augroup_by_name("lazyvim_wrap_spell")

-- CMake-specific indentation (2 spaces)
vim.api.nvim_create_autocmd("FileType", {
    pattern = "cmake",
    callback = function()
        vim.opt_local.shiftwidth = 2
        vim.opt_local.tabstop = 2
        vim.opt_local.softtabstop = 2
        vim.opt_local.expandtab = true
    end,
})

-- Make help buffers listed and fix closing them when in full screen
vim.api.nvim_create_autocmd("FileType", {
    pattern = "help",
    callback = function()
        vim.bo.buflisted = true

        -- This is really hacky and probably unstable
        -- In LazyVims source code:
        -- https://github.com/LazyVim/LazyVim/blob/25abbf54/lua/lazyvim/config/autocmds.lua#L54-L86
        -- Folke sets up close on q using a vim.schedule call, as a result
        -- doing the code below outside vim.schedule makes it execute before
        -- the LazyVim's one and because of that my changes get overwritten.
        -- Putting the change inside vim.schedule seems to work, however
        -- to the best of my knowledge nvim does not guarantee in what order
        -- do the calls execute in so it might break unexpectedly
        vim.schedule(function()
            -- Override 'q' to close buffer instead of window
            vim.keymap.set("n", "q", function()
                vim.cmd("bdelete")
            end, { buffer = true, desc = "Close help buffer/window", noremap = true })
        end)
    end,
})
