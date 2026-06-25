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

-- Fix for Cmd+k sending ^L (Ctrl-L) in some terminals (Alacritty)
-- This collides with Ctrl-L to swtich windows??
-- map("n", "<C-l>", "<D-k>", { remap = true, desc = "Move Up" })
-- map("i", "<C-l>", "<D-k>", { remap = true, desc = "Move Up" })
-- map("v", "<C-l>", "<D-k>", { remap = true, desc = "Move Up" })

map("n", "<leader>bf", ":only<cr>", { desc = "Fullscreen a buffer" })
map("n", "<leader>by", ":%y<cr>", { desc = "Yank the whole buffer" })

local macro_continuation = require("config.macro_continuation")
macro_continuation.setup_count_capture()

map("x", "<leader>\\", function()
    macro_continuation.fix_visual(vim.v.count)
end, { desc = "Fix Macro Continuations" })

local function set_clang_format_keymap(buf)
    map("x", "<leader>cf", function()
        local first_line = vim.fn.line("v")
        local last_line = vim.fn.line(".")
        if first_line > last_line then
            first_line, last_line = last_line, first_line
        end

        require("conform").format({
            bufnr = buf,
            formatters = { "clang-format" },
            lsp_format = "never",
            range = {
                start = { first_line, 0 },
                ["end"] = { last_line, #vim.api.nvim_buf_get_lines(buf, last_line - 1, last_line, false)[1] },
            },
        })
    end, { buffer = buf, desc = "Clang Format Selection" })
end

vim.api.nvim_create_autocmd("FileType", {
    pattern = { "c", "cpp" },
    callback = function(event)
        set_clang_format_keymap(event.buf)
    end,
})

if vim.tbl_contains({ "c", "cpp" }, vim.bo.filetype) then
    set_clang_format_keymap(0)
end

map("n", "<leader>ff", function()
    Snacks.picker.files()
end, { desc = "Find Files (cwd)" })

map("n", "<leader>fF", function()
    Snacks.picker.files({ cwd = LazyVim.root()  })
end, { desc = "Find Files (root dir)" })

-- Snacks Explorer in centered view
map("n", "<leader>e", function()
    Snacks.picker.explorer({
        auto_close = true,
        layout = { preset = "default", preview = true },
    })
end, { desc = "Explorer (centered, cwd)" })
