return {
    "obsidian-nvim/obsidian.nvim",
    version = "*",
    event = "VeryLazy",
    ft = "markdown",
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
        legacy_commands = false,
        completion = {
            blink = true,
        },
        -- mappings = {
        --     ["<leader>mc"] = {
        --         action = function()
        --             return require('obsidian').util.toggle_checkbox()
        --         end,
        --         opts = { buffer = true },
        --     },
        --     ["<cr>"] = {
        --         action = function()
        --             return require("obsidian").util.smart_action()
        --         end,
        --         opts = { buffer = true, expr = true },
        --     },
        --     ["gf"] = {
        --         action = function()
        --             return require("obsidian").util.gf_passthrough()
        --         end,
        --         opts = { noremap = false, expr = true, buffer = true },
        --     },
        -- },
    },
}
