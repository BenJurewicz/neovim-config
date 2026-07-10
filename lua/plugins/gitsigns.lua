return {
  {
    "lewis6991/gitsigns.nvim",
    init = function()
      vim.api.nvim_create_autocmd("FileType", {
        pattern = "gitsigns-blame",
        callback = function(event)
          -- Gitsigns sets nowrap after assigning the filetype, so apply these
          -- once its blame-window setup has finished.
          vim.schedule(function()
            if not vim.api.nvim_buf_is_valid(event.buf) then
              return
            end

            for _, win in ipairs(vim.fn.win_findbuf(event.buf)) do
              vim.wo[win].wrap = true
              vim.wo[win].linebreak = true
              vim.wo[win].breakindent = true
              vim.wo[win].breakindentopt = "column:2"
            end
          end)
        end,
      })
    end,
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
