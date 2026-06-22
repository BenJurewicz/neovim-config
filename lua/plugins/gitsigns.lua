return {
  {
    "lewis6991/gitsigns.nvim",
    keys = {
      {
        "<leader>ga",
        function()
          for _, win in ipairs(vim.api.nvim_tabpage_list_wins(0)) do
            local buf = vim.api.nvim_win_get_buf(win)
            if vim.bo[buf].filetype == "gitsigns-blame" then
              vim.api.nvim_win_close(win, true)
              return
            end
          end

          require("gitsigns").blame()
        end,
        desc = "Toggle Git Blame Buffer",
      },
    },
    opts = function(_, opts)
      opts.current_line_blame = true
      opts.current_line_blame_opts = vim.tbl_deep_extend("force", opts.current_line_blame_opts or {}, {
        virt_text = true,
        virt_text_pos = "eol",   -- 'eol' | 'overlay' | 'right_align'
        delay = 200,             -- ms before showing blame
        ignore_whitespace = false,
        virt_text_priority = 100,
        use_focus = true,
      })
      opts.current_line_blame_formatter = "<author>, <author_time:%Y-%m-%d> - <summary>"

      Snacks.toggle({
        name = "Git Line Blame",
        get = function()
          return require("gitsigns.config").config.current_line_blame
        end,
        set = function(state)
          require("gitsigns").toggle_current_line_blame(state)
        end,
      }):map("<leader>uB")
    end,
  },
}
