local M = {}

local pending_column
local waiting_for_macro_key = false

local function strip_continuation(line)
    return (line:gsub("%s*\\%s*$", ""))
end

local function continuation_column(lines)
    local column = 1

    for _, line in ipairs(lines) do
        local stripped = strip_continuation(line)
        local width = vim.fn.strdisplaywidth(stripped)

        -- Keep at least one separating space before the continuation marker.
        column = math.max(column, width + 2)
    end

    return column
end

function M.setup_count_capture()
    local namespace = vim.api.nvim_create_namespace("macro_continuation_count")

    vim.on_key(function(key)
        local mode = vim.fn.mode()
        if mode ~= "v" and mode ~= "V" and mode ~= "\22" then
            pending_column = nil
            waiting_for_macro_key = false
            return
        end

        if waiting_for_macro_key then
            if key ~= "\\" then
                pending_column = nil
            end
            waiting_for_macro_key = false
            return
        end

        -- which-key replaces <leader> with an internal trigger key while
        -- v:count still contains the user's prefix. Capture it at that point,
        -- before which-key replays the completed Visual-mode mapping.
        if vim.v.count > 0 and not key:match("^%d$") then
            pending_column = vim.v.count
            waiting_for_macro_key = true
        end
    end, namespace)
end

function M.fix_range(first_line, last_line, column)
    if first_line < 1 or last_line < 1 then
        vim.notify("No visual range found for macro continuations", vim.log.levels.WARN)
        return
    end

    if first_line > last_line then
        first_line, last_line = last_line, first_line
    end

    local lines = vim.api.nvim_buf_get_lines(0, first_line - 1, last_line, false)
    local minimum_column = continuation_column(lines)
    local target_column = column and column > 0 and column or minimum_column

    if target_column < minimum_column then
        vim.notify(
            ("Macro continuation column %d is too small; using %d"):format(target_column, minimum_column),
            vim.log.levels.WARN
        )
        target_column = minimum_column
    end

    local fixed = {}
    for _, line in ipairs(lines) do
        local stripped = strip_continuation(line)
        local width = vim.fn.strdisplaywidth(stripped)
        local spaces = math.max(target_column - width - 1, 1)

        fixed[#fixed + 1] = stripped .. string.rep(" ", spaces) .. "\\"
    end

    vim.api.nvim_buf_set_lines(0, first_line - 1, last_line, false, fixed)
end

function M.fix_visual(column)
    if not column or column <= 0 then
        column = pending_column
    end
    pending_column = nil
    waiting_for_macro_key = false

    local mode = vim.fn.mode()
    local first_line
    local last_line

    if mode == "v" or mode == "V" or mode == "\22" then
        first_line = vim.fn.line(".")
        last_line = vim.fn.line("v")
    else
        first_line = vim.fn.line("'<")
        last_line = vim.fn.line("'>")
    end

    if first_line == 0 or last_line == 0 then
        first_line = vim.fn.line(".")
        last_line = vim.fn.line("v")
    end

    M.fix_range(first_line, last_line, column)
end

return M
