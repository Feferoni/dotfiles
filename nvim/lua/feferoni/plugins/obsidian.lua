return {
    "obsidian-nvim/obsidian.nvim",
    version = "*",
    event = "VeryLazy",
    ft = "markdown",
    -- Replace the above line with this if you only want to load obsidian.nvim for markdown files in your vault:
    -- event = {
    --   -- If you want to use the home shortcut '~' here you need to call 'vim.fn.expand'.
    --   -- E.g. "BufReadPre " .. vim.fn.expand "~" .. "/my-vault/*.md"
    --   -- refer to `:h file-pattern` for more examples
    --   "BufReadPre path/to/my-vault/*.md",
    --   "BufNewFile path/to/my-vault/*.md",
    -- },
    dependencies = {
        "nvim-lua/plenary.nvim",
    },
    opts = {
        workspaces = {
            {
                name = "shared",
                path = "~/.config/vault/shared/",
            },
            {
                name = "local",
                path = "~/.config/vault/local/",
            },
        },
        completion = {
            blink = true,
        },
    },
}
