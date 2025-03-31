return {
    {
        'saghen/blink.cmp',
        dependencies = {
            'rafamadriz/friendly-snippets',
            "epwalsh/obsidian.nvim",
        },
        event = "VeryLazy",
        version = '*',
        opts = {
            keymap = {
                preset = 'default', -- none, default

                ['<Up>'] = { 'select_prev', 'fallback' },
                ['<Down>'] = { 'select_next', 'fallback' },
                ['<CR>'] = { 'accept', 'fallback' },

                -- show snippets
                ['<C-s>'] = { function(cmp) cmp.show({ providers = { 'snippets' } }) end },
            },

            appearance = {
                -- Sets the fallback highlight groups to nvim-cmp's highlight groups
                -- Useful for when your theme doesn't support blink.cmp
                -- Will be removed in a future release
                use_nvim_cmp_as_default = true,
                nerd_font_variant = 'mono'
            },

            completion = {
                accept = { auto_brackets = { enabled = true }, },
                ghost_text = { enabled = false },
                list = {
                    selection = {
                        preselect = true,
                        auto_insert = false,
                    },
                },
                menu = {
                    auto_show = true,
                    draw = {
                        columns = {
                            { "label",     "label_description", gap = 1 },
                            { "kind_icon", "kind",              gap = 1 }
                        },
                    }
                },
                documentation = { auto_show = true, auto_show_delay_ms = 100 },
            },
            sources = {
                default = {
                    'lsp',
                    'path',
                    'snippets',
                    'obsidian_new',
                    'obsidian_tags',
                    'obsidian',
                },
                -- min_keyword_length = 2,
            },
            fuzzy = { implementation = "prefer_rust" },
            snippets = {
                preset = 'luasnip' -- 'default' 'luasnip' 'mini_snippets'
            },
            signature = {
                enabled = false,
                window = {
                    show_documentation = false,
                },
            },
        },
        opts_extend = { "sources.default" }

    },
}
