return {
    'nvim-treesitter/nvim-treesitter',
    build = ':TSUpdate',
    dependencies = {
        'nvim-treesitter/playground',
        'nvim-treesitter/completion-treesitter',
    },
    config = function()
        require('nvim-treesitter.configs').setup {
            ensure_installed = {
                "help",
                "python",
                "javascript",
                "typescript",
                "rust",
                "cmake",
                "cpp",
                "c",
                "go",
                "gomod",
                "gowork",
                "gosum",
                "lua",
                "vim",
                "vimdoc",
                "query",
                "markdown",
            },
            sync_install = false,
            ignore_install = { "help" },
            auto_install = true,
            highlight = {
                enable = true,
                additional_vim_regex_highlighting = false,
            },
        }
    end
}
