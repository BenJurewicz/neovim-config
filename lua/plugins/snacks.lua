return {
    "folke/snacks.nvim",
    opts = {
        scratch = {
            win = {
                width = 0,
                height = 0,
                border = false,
            },
        },
        zen = {
            toggles = {
                dim = false,
            },
        },
        picker = {
            sources = {
                git_log_line = {
                    actions = {
                        zoom_diff = function(picker)
                            local fullscreen = picker.layout.opts.fullscreen == true
                            picker:focus("preview", { show = true })

                            if picker.diff_zoom_layout then
                                local layout = picker.diff_zoom_layout
                                picker.diff_zoom_layout = nil
                                picker:set_layout(layout)
                            else
                                picker.diff_zoom_layout = vim.deepcopy(picker.resolved_layout)

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
                                    picker:focus("preview", { show = true })
                                end
                            end)
                        end,
                    },
                    win = {
                        input = {
                            keys = {
                                ["<a-z>"] = { "zoom_diff", mode = { "n", "i" } },
                            },
                        },
                        list = {
                            keys = {
                                ["<a-z>"] = "zoom_diff",
                            },
                        },
                        preview = {
                            keys = {
                                ["<a-m>"] = "toggle_maximize",
                                ["<a-z>"] = "zoom_diff",
                            },
                        },
                    },
                },
            },
        },
    },
}
