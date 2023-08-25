-- This file can be loaded by calling `lua require('plugins')` from your init.vim

-- Only required if you have packer configured as `opt`
vim.cmd [[packadd packer.nvim]]

return require('packer').startup(function(use)
    -- Packer can manage itself
    use 'wbthomason/packer.nvim'

    -- file explorer / navigation / etc
    use {
        'nvim-telescope/telescope.nvim', tag = '0.1.1',
        -- or 			       , branch = '0.1.x',
        requires = { { 'nvim-lua/plenary.nvim' } }
    }
    use('theprimeagen/harpoon')
    use('mbbill/undotree')

    -- ui
    use({
        "iamcco/markdown-preview.nvim",
        run = "cd app && npm install",
        setup = function() vim.g.mkdp_filetypes = { "markdown" } end,
        ft = { "markdown" },
    })
    use('nvim-treesitter/nvim-treesitter', { run = ':TSUpdate' })
    use('nvim-treesitter/playground')
    use('tpope/vim-commentary')
    use('nvim-tree/nvim-web-devicons')

    -- code completions / lsp / snippets / etc
    use "github/copilot.vim"
    use('p00f/clangd_extensions.nvim')
    use('cohama/lexima.vim')
    use {
        'VonHeikemen/lsp-zero.nvim',
        branch = 'v2.x',
        requires = {
            -- LSP Support
            { 'neovim/nvim-lspconfig' }, -- Required
            {                            -- Optional
                'williamboman/mason.nvim',
                run = function()
                    pcall(vim.cmd, 'MasonUpdate')
                end,
            },
            { 'williamboman/mason-lspconfig.nvim' }, -- Optional

        }
    }
    -- Autocompletion
    use {
        'hrsh7th/nvim-cmp',
        config = function()
            require 'cmp'.setup {
                snippet = {
                    expand = function(args)
                        require 'luasnip'.lsp_expand(args.body)
                    end
                },

                sources = {
                    { name = 'luasnip' },
                    -- more sources
                },
            }
        end
    }
    use ( 'saadparwaiz1/cmp_luasnip' )
    use { 'hrsh7th/cmp-nvim-lsp' }
    use { 'L3MON4D3/LuaSnip', run = "make install_jsregexp" }

    -- debugging
    use('mfussenegger/nvim-dap')
    use('rcarriga/nvim-dap-ui')
    use('theHamsta/nvim-dap-virtual-text')
    use('nvim-telescope/telescope-dap.nvim')
    -- use('mfussenegger/nvim-dap-python')
    use('leoluz/nvim-dap-go')

    -- git
    use('tpope/vim-fugitive')
    use('lewis6991/gitsigns.nvim')

    -- themes
    use({
        'rose-pine/neovim',
        as = 'rose-pine',
        config = function()
            vim.cmd('colorscheme rose-pine')
        end
    })

    use({
        'catppuccin/nvim',
        as = 'catppuccin',

        config = function()
            vim.cmd('colorscheme catppuccin')
        end
    })

    use('Feferoni/build-system.nvim')
end)
