local tree = require('nvim-tree')

vim.keymap.set("n", "<leader>et", function ()
    vim.cmd("NvimTreeFindFileToggle")
end)

tree.setup({
    view = {
        width = 30,
    },
    renderer = {
        group_empty = true,
    },
    filters = {
        dotfiles = false,
    },
})
