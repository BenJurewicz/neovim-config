return {
    "folke/todo-comments.nvim",
    lazy = true,
    cmd = { "TodoTrouble" },
    event = "LazyFile",
    keys = {
        {
            "<leader>sT",
            function()
                Snacks.picker.todo_comments({
                    keywords = { "TODO", "FIX", "FIXME", "BUG", "FIXIT", "ISSUE", "WARN", "WARNING" },
                })
            end,
            desc = "Todo/Fix/Fixme",
        },
        {
            "<leader>xT",
            "<cmd>Trouble todo toggle filter = {tag = {TODO, FIX, FIXME, BUG, FIXIT, ISSUE, WARN, WARNING}}<cr>",
            desc = "Todo/Fix/Fixme (Trouble)",
        },
    },
}
