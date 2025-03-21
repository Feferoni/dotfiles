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

                -- disable a keymap from the preset
                ['<C-e>'] = {},

                -- show with a list of providers
                ['<C-space>'] = { function(cmp) cmp.show({ providers = { 'snippets' } }) end },

                -- control whether the next command will be run when using a function
                ['<C-n>'] = {
                    function(cmp)
                        if some_condition then return end -- runs the next command
                        return true                       -- doesn't run the next command
                    end,
                    'select_next'
                },
            },

            appearance = {
                -- Sets the fallback highlight groups to nvim-cmp's highlight groups
                -- Useful for when your theme doesn't support blink.cmp
                -- Will be removed in a future release
                use_nvim_cmp_as_default = true,

                -- Set to 'mono' for 'Nerd Font Mono' or 'normal' for 'Nerd Font'
                -- Adjusts spacing to ensure icons are aligned
                nerd_font_variant = 'mono'
            },

            completion = {
                -- Disable auto brackets
                -- NOTE: some LSPs may add auto brackets themselves anyway
                accept = { auto_brackets = { enabled = true }, },

                -- Display a preview of the selected item on the current line
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

                documentation = { auto_show = true, auto_show_delay_ms = 500 },
            },

            -- Default list of enabled providers defined so that you can extend it
            -- elsewhere in your config, without redefining it, due to `opts_extend`
            sources = {
                default = {
                    'lsp',
                    'path',
                    'snippets',
                    'obsidian_new',
                    'obsidian_tags',
                    'obsidian',
                },

                min_keyword_length = 2,
            },

            -- Blink.cmp uses a Rust fuzzy matcher by default for typo resistance and significantly better performance
            -- You may use a lua implementation instead by using `implementation = "lua"` or fallback to the lua implementation,
            -- when the Rust fuzzy matcher is not available, by using `implementation = "prefer_rust"`
            --
            -- See the fuzzy documentation for more information
            fuzzy = { implementation = "prefer_rust" },
            snippets = {
                preset = 'luasnip' -- 'default' 'luasnip' 'mini_snippets'
            },
        },
        opts_extend = { "sources.default" }

    },
}
