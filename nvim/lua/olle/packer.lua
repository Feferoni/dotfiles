-- This file can be loaded by calling `lua require('plugins')` from your init.vim

-- Only required if you have packer configured as `opt`
vim.cmd [[packadd packer.nvim]]

local packer = require 'packer'

packer.init({
    log = {
        -- level = 'trace'
        level = 'warn', -- default
    },
})

return require('packer').startup(function(use)
    -- Packer can manage itself
    use { 'wbthomason/packer.nvim', commit = 'ea0cc3c59f67c440c5ff0bbe4fb9420f4350b9a3' }

    -- file explorer / navigation / etc
    use {
        'nvim-telescope/telescope.nvim', tag = '0.1.2',
        requires = { { 'nvim-lua/plenary.nvim' } }
    }
    use { 'theprimeagen/harpoon', commit = '21f4c47c6803d64ddb934a5b314dcb1b8e7365dc' }
    use { 'mbbill/undotree', tag = 'rel_6.1' }

    -- ui
    -- use {
    --     "iamcco/markdown-preview.nvim",
    --     tag = 'v0.0.10',
    --     run = "cd app && npm install",
    --     setup = function() vim.g.mkdp_filetypes = { "markdown" } end,
    --     ft = { "markdown" },
    -- }
    use {
        'nvim-treesitter/nvim-treesitter',
        commit = 'd0b17cc0b9c8c3055530770a9dd4de659232c692',
        run = ':TSUpdate',
    }
    use {
        'nvim-treesitter/playground',
        commit = '429f3e76cbb1c59fe000b690f7a5bea617b890c0',
    }
    use { 'tpope/vim-commentary', tag = 'v1.3' }
    use { 'nvim-tree/nvim-web-devicons', tag = 'nerd-v2-compat' }

    -- code completions / lsp / snippets / etc
    use { "github/copilot.vim", tag = 'v1.10.1' }
    use { 'p00f/clangd_extensions.nvim', commit = '323b00de2ee18cad1ac45eb95e680386c4ff4366' }
    use { 'cohama/lexima.vim', tag = 'v2.1.0' }
    use { 'neovim/nvim-lspconfig', commit = 'a27356f1ef9c11e1f459cc96a3fcac5c265e72d6' }
    use { 'williamboman/mason.nvim', tag = 'v1.7.0', run = function() pcall(vim.cmd, 'MasonInstall') end }
    use { 'williamboman/mason-lspconfig.nvim', tag = 'v1.13.0' }
    use {
        'VonHeikemen/lsp-zero.nvim',
        -- branch = 'v2.x',
        commit = 'f084f4a6a716f55bf9c4026e73027bb24a0325a3',
        requires = {
            -- LSP Support
            { 'neovim/nvim-lspconfig', },                             -- Required
            { 'williamboman/mason.nvim',           tag = 'v1.7.0' },  -- optional
            { 'williamboman/mason-lspconfig.nvim', tag = 'v1.13.0' }, -- Optional

        }
    }
    -- Autocompletion
    use {
        'hrsh7th/nvim-cmp',
        commit = '5dce1b778b85c717f6614e3f4da45e9f19f54435',
    }
    use { 'saadparwaiz1/cmp_luasnip', commit = '18095520391186d634a0045dacaa346291096566' }
    use { 'hrsh7th/cmp-nvim-lsp', commit = '44b16d11215dce86f253ce0c30949813c0a90765' }
    use { 'L3MON4D3/LuaSnip', tag = 'v2.0.0', run = "make install_jsregexp" }

    -- debugging
    use { 'mfussenegger/nvim-dap', tag = '0.6.0' }
    use { 'rcarriga/nvim-dap-ui', tag = 'v3.8.4' }
    use { 'theHamsta/nvim-dap-virtual-text', commit = '57f1dbd0458dd84a286b27768c142e1567f3ce3b' }
    use { 'nvim-telescope/telescope-dap.nvim', commit = '313d2ea12ae59a1ca51b62bf01fc941a983d9c9c' }
    -- use('mfussenegger/nvim-dap-python')
    use { 'leoluz/nvim-dap-go', commit = '1b508e9db330108d3b5d62a6d9cc01fe6bbdd4e0' }

    -- git
    use { 'tpope/vim-fugitive', tag = 'v3.7' }
    use { 'lewis6991/gitsigns.nvim', commit = 'd8590288417fef2430f85bc8b312fae8b1cf2c40' }

    -- themes
    use { 'RRethy/nvim-base16' }
    -- use({
    --     'rose-pine/neovim',
    --     as = 'rose-pine',
    --     tag = 'v1.2.0',
    --     config = function()
    --         vim.cmd('colorscheme rose-pine')
    --     end
    -- })
    -- use({
    -- 'catppuccin/nvim',
    -- as = 'catppuccin',
    -- tag = 'v1.4.0',
    -- config = function()
    --     vim.cmd('colorscheme catppuccin')
    -- end
    -- })

    use('Feferoni/build-system.nvim')
end)
