local kind_icons = {
    Text = "",
    Method = "m",
    Function = "󰊕",
    Constructor = "",
    Field = "",
    Variable = "",
    Class = "",
    Interface = "",
    Module = "",
    Property = " ",
    Unit = "",
    Value = "󰎠",
    Enum = "",
    Keyword = "󰌋",
    Snippet = "",
    Color = "󰏘",
    File = "󰈙",
    Reference = "",
    Folder = "󰉋",
    EnumMember = "",
    Constant = "󰏿",
    Struct = "",
    Event = "",
    Operator = "󰆕",
    TypeParameter = " ",
}

return {
    'hrsh7th/nvim-cmp',
    event = "VeryLazy",
    dependencies = {
        'hrsh7th/nvim-cmp',
        'saadparwaiz1/cmp_luasnip',
        'hrsh7th/cmp-nvim-lsp',
        'hrsh7th/cmp-buffer',
        'hrsh7th/cmp-path',
        'hrsh7th/cmp-cmdline',
        'L3MON4D3/LuaSnip',
    },
    config = function()
        require('cmp').setup({
            sorting = {
                comparators = {
                    require('cmp').config.compare.recently_used,
                    require('cmp').config.compare.offset,
                    require('cmp').config.compare.exact,
                    require('clangd_extensions.cmp_scores'),
                    require('cmp').config.compare.kind,
                    require('cmp').config.compare.sort_text,
                    require('cmp').config.compare.length,
                    require('cmp').config.compare.order,
                },
            },
            snippet = {
                expand = function(args)
                    require('luasnip').lsp_expand(args.body)
                end,
            },
            formatting = {
                fields = { "kind", "abbr", "menu" },
                format = function(entry, item)
                    item.menu = ({
                        buffer = "[Buffer]",
                        nvim_lsp = "[LSP]",
                        luasnip = "[Snippet]",
                        path = "[PATH]",
                    })[entry.source.name] or 0
                    item.dup = ({
                        vsnip = 0,
                        nvim_lsp = 0,
                        nvim_lua = 0,
                        buffer = 0,
                    })[entry.source.name] or 0
                    item.kind = string.format("%s", kind_icons[item.kind])
                    return item
                end,
            },
            mapping = require('cmp').mapping.preset.insert({
                ['<A-k>'] = require('cmp').mapping.select_prev_item({ behavior = require('cmp').SelectBehavior.Select }),
                ['<A-j>'] = require('cmp').mapping.select_next_item({ behavior = require('cmp').SelectBehavior.Select }),
                ['<A-a>'] = require('cmp').mapping.confirm({ select = true }),
                ['<CR>'] = require('cmp').mapping.confirm({ select = true }),
                ["<A-s>"] = require('cmp').mapping.complete(),
                ['<Tab>'] = nil,
                ['<S-Tab>'] = nil,
            }),
            sources = require('cmp').config.sources({
                {
                    name = 'nvim_lsp',
                },
                { name = 'luasnip' },
                { name = 'path' },
            }, {
                { name = 'buffer' },
            }),
            duplicates = {
                nvim_lsp = 1,
                luasnip = 1,
                buffer = 1,
                path = 1,
            },
            window = {
                completion = require('cmp').config.window.bordered(),
                documentation = require('cmp').config.window.bordered(),
            },
            experimental = {
                ghost_text = false,
                native_menu = false,
            },
        })


        require("luasnip.loaders.from_vscode").lazy_load({
            include = {
                "c",
                "cpp",
                "python",
                "lua",
                "markdown",
                "plantuml",
                "shell"
            }
        })

    end
}
