local function close_scratch_windows()
    for _, win in ipairs(vim.api.nvim_tabpage_list_wins(0)) do
        if vim.w[win].snacks_scratch then
            pcall(vim.api.nvim_win_close, win, false)
        end
    end
end

return {
    "folke/snacks.nvim",
    keys = {
        {
            "<leader>ff",
            function()
                close_scratch_windows()
                Snacks.picker.files()
            end,
            desc = "Find Files (cwd)",
        },
        {
            "<leader>fF",
            function()
                close_scratch_windows()
                Snacks.picker.files({ cwd = LazyVim.root() })
            end,
            desc = "Find Files (root dir)",
        },
        {
            "<leader>fe",
            function()
                close_scratch_windows()
                Snacks.explorer({
                    cwd = LazyVim.root(),
                    auto_close = true,
                    layout = { preset = "default", preview = true },
                })
            end,
            desc = "Explorer Snacks (root dir)",
        },
        { "<leader>e", "<leader>fe", desc = "Explorer Snacks (root dir)", remap = true },
    },
    opts = {
        scratch = {
            win = {
                width = 0,
                height = function()
                    local statusline = vim.o.laststatus == 0 and 0 or 1
                    return vim.o.lines - vim.o.cmdheight - statusline
                end,
                row = 0,
                border = false,
                w = { snacks_scratch = true },
            },
        },
        zen = {
            toggles = {
                dim = false,
            },
        },
        picker = {
            actions = {
                zoom_preview = function(picker)
                    local fullscreen = picker.layout.opts.fullscreen == true
                    picker:focus("preview", { show = true })

                    if picker.preview_zoom_layout then
                        local layout = picker.preview_zoom_layout
                        picker.preview_zoom_layout = nil
                        picker:set_layout(layout)
                    else
                        picker.preview_zoom_layout = vim.deepcopy(picker.resolved_layout)

                        local zoom = vim.deepcopy(picker.resolved_layout)
                        zoom.hidden = { "input", "list" }
                        for index = #zoom.layout, 1, -1 do
                            table.remove(zoom.layout, index)
                        end
                        zoom.layout.box = "vertical"
                        table.insert(zoom.layout, {
                            win = "preview",
                            title = "{preview}",
                            border = true,
                        })
                        picker:set_layout(zoom)
                    end

                    if fullscreen and not picker.layout.opts.fullscreen then
                        picker.layout:maximize()
                    end

                    vim.schedule(function()
                        if not picker.closed then
                            picker.preview.win:map()
                            picker:focus("preview", { show = true })
                        end
                    end)
                end,
            },
            win = {
                input = {
                    keys = {
                        ["<a-z>"] = { "zoom_preview", mode = { "n", "i" } },
                    },
                },
                list = {
                    keys = {
                        ["<a-z>"] = "zoom_preview",
                    },
                },
                preview = {
                    keys = {
                        ["<a-m>"] = "toggle_maximize",
                        ["<a-z>"] = "zoom_preview",
                    },
                },
            },
        },
    },
}
