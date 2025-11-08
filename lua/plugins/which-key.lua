return {
  "folke/which-key.nvim",
  opts = {
    -- your configuration comes here
    -- or leave it empty to use the default settings
    -- refer to the configuration section below
  },
  keys = {
    {
      "<leader>d<leader>",
      function()
        require("which-key").show({ keys = "<leader>d", loop = true })
      end,
      desc = "Debug Hydra Mode (which-key)",
    },
  },
}
