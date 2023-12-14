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

    {
        'nvim-telescope/telescope.nvim',
        dependencies = { 'nvim-lua/plenary.nvim' }
    },
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
    { 'p00f/clangd_extensions.nvim' },
    { 'cohama/lexima.vim' },
    { 'neovim/nvim-lspconfig' },
    { 'williamboman/mason.nvim', build = function() pcall(vim.cmd, 'MasonInstall') end },
    { 'williamboman/mason-lspconfig.nvim' },
    {
        'VonHeikemen/lsp-zero.nvim',
        dependencies = {
            { 'neovim/nvim-lspconfig', },
            { 'williamboman/mason.nvim', },
            { 'williamboman/mason-lspconfig.nvim' },

        }
    },
    { 'hrsh7th/nvim-cmp', },
    { 'saadparwaiz1/cmp_luasnip' },
    { 'hrsh7th/cmp-nvim-lsp' },
    { 'L3MON4D3/LuaSnip', build = "make install_jsregexp", version = "v2.1.1" },
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
