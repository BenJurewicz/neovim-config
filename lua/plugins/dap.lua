return {
  {
    "mfussenegger/nvim-dap",
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
    -- config = function()
    --   local dap = require("dap")
    --   local wk = require("which-key")
    --
    --   local debug_keybinds = {
    --     { "<Left>", dap.step_out, desc = "Step Out" },
    --     { "<Right>", dap.step_into, desc = "Step Into" },
    --     { "<Down>", dap.step_over, desc = "Step Over" },
    --     { "<Up>", dap.continue, desc = "Continue" },
    --   }
    --
    --   local cleanup_keymaps = function()
    --     local keys = { "<Left>", "<Right>", "<Down>", "<Up>" }
    --     for _, key in ipairs(keys) do
    --       pcall(function()
    --         vim.keymap.del("n", key)
    --       end)
    --     end
    --   end
    --
    --   dap.listeners.after.event_initialized["dap_keymaps"] = function()
    --     wk.add(debug_keybinds)
    --   end
    --
    --   dap.listeners.before.event_terminated["dap_keymaps"] = cleanup_keymaps
    --   dap.listeners.before.event_exited["dap_keymaps"] = cleanup_keymaps
    -- end,
  },
}
