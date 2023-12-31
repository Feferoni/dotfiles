local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
    vim.fn.system({
        "git",
        "clone",
        "--filter=blob:none",
        "https://github.com/folke/lazy.nvim.git",
        "--branch=stable", -- latest stable release
        lazypath,
    })
end
vim.opt.rtp:prepend(lazypath)

vim.g.mapleader = ' '

local plugins = {
    {
        'nvim-tree/nvim-tree.lua',
        dependencies = { 'nvim-tree/nvim-web-devicons', },
    },
    -- {
    --     "folke/noice.nvim",
    --     event = "VeryLazy",
    --     opts = {
    --         -- add any options here
    --     },
    --     dependencies = {
    --         "MunifTanjim/nui.nvim",
    --         "rcarriga/nvim-notify",
    --     }
    -- },
    -- { "rcarriga/nvim-notify" },
    -- { "MunifTanjim/nui.nvim" },
    {
        'nvim-telescope/telescope.nvim',
        dependencies = { 'nvim-lua/plenary.nvim' }
    },
    { 'nvim-telescope/telescope-fzf-native.nvim', build = 'cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release && cmake --build build --config Release && cmake --install build --prefix build' },
    { 'theprimeagen/harpoon' },
    { 'mbbill/undotree' },

    {
        'nvim-treesitter/nvim-treesitter',
        build = ':TSUpdate',
    },
    {
        'nvim-treesitter/playground',
    },
    { 'tpope/vim-commentary' },
    { 'tpope/vim-surround' },
    { 'nvim-tree/nvim-web-devicons' },
    { 'mg979/vim-visual-multi' },
    { 'nvim-treesitter/completion-treesitter' },
    { 'cohama/lexima.vim' },
    { 'neovim/nvim-lspconfig' },
    {
        'williamboman/mason.nvim',
        build = function()
            pcall(vim.cmd, 'MasonInstall')
        end,
        dependencies = {
            'williamboman/mason-lspconfig.nvim',
            'neovim/nvim-lspconfig',
            'jose-elias-alvarez/null-ls.nvim',
            'p00f/clangd_extensions.nvim',
        },
    },
    { 'p00f/clangd_extensions.nvim' },
    { 'williamboman/mason-lspconfig.nvim' },
    { "jose-elias-alvarez/null-ls.nvim" },
    {
        'Issafalcon/lsp-overloads.nvim',
        tag = "v1.3.1"
    },
    { "j-hui/fidget.nvim" },
    { 'rafamadriz/friendly-snippets' },
    { 'saadparwaiz1/cmp_luasnip' },
    { 'hrsh7th/nvim-cmp', },
    { 'hrsh7th/cmp-nvim-lsp' },
    { 'hrsh7th/cmp-buffer' },
    { 'hrsh7th/cmp-path' },
    { 'hrsh7th/cmp-cmdline' },
    {
        'L3MON4D3/LuaSnip',
        build = "make install_jsregexp",
        version = "v2.1.1",
        dependencies = { 'rafamadriz/friendly-snippets' },
    },
    { 'mfussenegger/nvim-dap' },
    { 'rcarriga/nvim-dap-ui' },
    { 'theHamsta/nvim-dap-virtual-text' },
    { 'nvim-telescope/telescope-dap.nvim' },
    { 'leoluz/nvim-dap-go' },
    { 'tpope/vim-fugitive' },
    { 'lewis6991/gitsigns.nvim' },
    { 'tinted-theming/base16-vim' },
    { 'Feferoni/build-system.nvim' },
    { 'Feferoni/goto-path.nvim' },
}

local opts = {}
require("lazy").setup(plugins, opts)
