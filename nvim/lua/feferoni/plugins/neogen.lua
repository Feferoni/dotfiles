return {
    "danymat/neogen",
    dependencies = {
        'L3MON4D3/LuaSnip',
        "nvim-treesitter/nvim-treesitter",
    },
    config = function()
        require('neogen').setup({ snippet_engine = "luasnip" })

        vim.keymap.set('n', '<leader>cf', function()
            require('neogen').generate({ type = 'func' })
        end, { desc = "[C]omment [F]ile", noremap = true, silent = true })
        vim.keymap.set('n', '<leader>cc', function()
            require('neogen').generate({ type = 'class' })
        end, { desc = "[C]omment [C]lass", noremap = true, silent = true })
        vim.keymap.set('n', '<leader>ct', function()
            require('neogen').generate({ type = 'type' })
        end, { desc = "[C]omment [T]ype", noremap = true, silent = true })
    end,
}
