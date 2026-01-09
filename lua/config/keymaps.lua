-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

require("config.mac_key_remaps")

local map = vim.keymap.set

map("i", "jj", "<ESC>")
map("i", "jk", "<ESC>")
map("i", "kj", "<ESC>")
map("i", "kk", "<ESC>")

-- Move Lines
map("n", "<D-j>", "<cmd>execute 'move .+' . v:count1<cr>==", { desc = "Move Down" })
map("n", "<D-k>", "<cmd>execute 'move .-' . (v:count1 + 1)<cr>==", { desc = "Move Up" })
map("i", "<D-j>", "<esc><cmd>m .+1<cr>==gi", { desc = "Move Down" })
map("i", "<D-k>", "<esc><cmd>m .-2<cr>==gi", { desc = "Move Up" })
map("v", "<D-j>", ":<C-u>execute \"'<,'>move '>+\" . v:count1<cr>gv=gv", { desc = "Move Down" })
map("v", "<D-k>", ":<C-u>execute \"'<,'>move '<-\" . (v:count1 + 1)<cr>gv=gv", { desc = "Move Up" })

map("n", "<leader>bf", ":only<cr>", { desc = "Fullscreen a buffer" })
map("n", "<leader>by", ":%y<cr>", { desc = "Yank the whole buffer" })

-- Snacks Explorer in centered view
map("n", "<leader>e", function()
    Snacks.picker.explorer({
        auto_close = true,
        layout = { preset = "default", preview = true },
    })
end, { desc = "Explorer (centered, cwd)" })
