local M = {}

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
