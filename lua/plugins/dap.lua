return {
    {
        "mfussenegger/nvim-dap",
        lazy = true,
        keys = {
            { "<leader>dw", false },
            { "<leader>dO", false },
            { "<leader>ds", false },
            {
                "<leader>ds",
                function()
                    require("dap").step_over()
                end,
                desc = "Step Over",
            },
        },
        opts = function(_, opts)
            local dap = require("dap")

            local debug_keybinds = {
                { "<Left>", dap.step_out, desc = "Step Out" },
                { "<Right>", dap.step_into, desc = "Step Into" },
                { "<Down>", dap.step_over, desc = "Step Over" },
                { "<Up>", dap.continue, desc = "Continue" },
                { "q", dap.terminate, desct = "terminate" },
            }

            local cleanup_keymaps = function()
                for _, binds in ipairs(debug_keybinds) do
                    pcall(function()
                        vim.keymap.del("n", binds[1])
                    end)
                end
            end

            dap.listeners.after.event_initialized["dap_keymaps"] = function()
                for _, bind in ipairs(debug_keybinds) do
                    vim.keymap.set("n", bind[1], bind[2], { desc = bind[3] })
                end
            end

            dap.listeners.before.event_terminated["dap_keymaps"] = cleanup_keymaps
            dap.listeners.before.event_exited["dap_keymaps"] = cleanup_keymaps

            return opts
        end,
    },
}
