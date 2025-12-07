return {
    {
        "kawre/neotab.nvim",
        event = "InsertEnter",
        opts = {
            tabkey = "<Tab>",
            reverse_key = "<S-Tab>",
            act_as_tab = true,
            behavior = "nested", ---@type ntab.behavior
            pairs = { ---@type ntab.pair[]
                { open = "(", close = ")" },
                { open = "[", close = "]" },
                { open = "{", close = "}" },
                { open = "'", close = "'" },
                { open = '"', close = '"' },
                { open = "`", close = "`" },
                { open = "<", close = ">" },
            },
            exclude = {},
            smart_punctuators = {
                enabled = false,
                semicolon = {
                    enabled = false,
                    ft = { "cs", "c", "cpp", "java" },
                },
                escape = {
                    enabled = false,
                    triggers = {}, ---@type table<string, ntab.trigger>
                },
            },
        },
    },
}

---@alias ntab.info { pos: integer, char: string }

---@alias ntab.pair { open: string, close: string }

---@class ntab.out.opts
---@field ignore_beginning? boolean
---@field behavior? ntab.behavior

---@alias ntab.behavior
---| "nested"
---| "closing"

---@class ntab.md
---@field prev ntab.info
---@field next ntab.info
---@field pos integer

---@class ntab.trigger
---@field pairs ntab.pair[]
---@field format? string
---@field cond? string
---@field ft? string[]
