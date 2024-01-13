return {
    'nvim-tree/nvim-tree.lua',
    dependencies = { 'nvim-tree/nvim-web-devicons', },
    config = function()
        local tree = require('nvim-tree')

        vim.g.loaded_netrw = 1
        vim.g.loaded_netrwPlugin = 1

        vim.keymap.set("n", "<leader>et", function()
            vim.cmd("NvimTreeFindFileToggle")
        end)

        tree.setup({
            view = {
                number = true,
                relativenumber = true,
                width = 50,
                float = {
                    quit_on_focus_loss = true,
                },
            },
            renderer = {
                group_empty = true,
            },
            filters = {
                dotfiles = false,
                git_clean = false,
                exclude = { ".gitignore" },
                custom = { "^\\.git", "^\\.cache" },
            },
            git = {
                enable = true,
                ignore = false,
                show_on_dirs = true,
                disable_for_dirs = {},
                timeout = 400,
            },
            update_focused_file = {
                enable = true,
                update_root = false,
                ignore_list = {},
            },
            filesystem_watchers = {
                enable = true,
                debounce_delay = 50,
                ignore_dirs = {},
            }
        })
    end
}
