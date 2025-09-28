return {
    'j-hui/fidget.nvim',
    event = "VeryLazy",
    dependencies = {
        'williamboman/mason.nvim',
    },
    build = function()
        pcall(vim.cmd, 'MasonInstall')
    end,
    config = function()
        require("mason").setup()
        require('fidget').setup({
            integration = {
                ["nvim-tree"] = {
                    enable = true,
                },
            },
            notification = {
                window = {
                    winblend = 0,
                }
            },
        })
    end
}
