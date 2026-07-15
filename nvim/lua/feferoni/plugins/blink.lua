return {
    {
        'saghen/blink.cmp',
        version = 'v0.14.2',
        dependencies = {
            'rafamadriz/friendly-snippets',
            'epwalsh/obsidian.nvim',
            'L3MON4D3/LuaSnip',
        },
        event = "VeryLazy",
        init = function()
            local function reapply_blink_keymaps()
                local ok, apply = pcall(require, 'blink.cmp.keymap.apply')
                if not ok then return end
                local ok2, keymap = pcall(require, 'blink.cmp.keymap')
                if not ok2 then return end
                local config = require('blink.cmp.config')
                local mappings = keymap.get_mappings(config.keymap)
                for _, m in ipairs(vim.api.nvim_buf_get_keymap(0, 'i')) do
                    if m.desc == 'blink.cmp' then
                        pcall(vim.api.nvim_buf_del_keymap, 0, 'i', m.lhs)
                    end
                end
                apply.keymap_to_current_buffer(mappings)
            end

            -- Re-apply after vim-visual-multi exits (it unmaps buffer-local insert keymaps)
            vim.api.nvim_create_autocmd('User', {
                pattern = 'visual_multi_exit',
                callback = reapply_blink_keymaps,
            })

            -- Safety net: detect if blink keymaps go missing on InsertEnter
            vim.api.nvim_create_autocmd('InsertEnter', {
                callback = function()
                    if not require('blink.cmp.config').enabled() then return end
                    local has_cr = false
                    for _, m in ipairs(vim.api.nvim_buf_get_keymap(0, 'i')) do
                        if m.desc == 'blink.cmp' and m.lhs == '<CR>' then
                            has_cr = true
                            break
                        end
                    end
                    if not has_cr then
                        vim.notify('blink: CR mapping missing, re-applying', vim.log.levels.WARN)
                        reapply_blink_keymaps()
                    end
                end,
            })
        end,
        opts = {
            keymap = {
                preset = 'none',

                ['<C-space>'] = { 'show', 'show_documentation', 'hide_documentation' },
                ['<C-e>'] = { 'hide' },
                ['<C-b>'] = { 'scroll_documentation_up', 'fallback' },
                ['<C-f>'] = { 'scroll_documentation_down', 'fallback' },
                ['<Tab>'] = { 'fallback' },
                ['<S-Tab>'] = { 'fallback' },
                ['<Up>'] = { 'select_prev', 'fallback' },
                ['<Down>'] = { 'select_next', 'fallback' },
                ['<C-p>'] = { 'select_prev', 'fallback' },
                ['<C-n>'] = { 'select_next', 'fallback' },
                ['<CR>'] = { 'select_and_accept', 'fallback' },

                -- show snippets
                ['<C-s>'] = { function(cmp) cmp.show({ providers = { 'snippets' } }) end },
            },

            appearance = {
                -- Sets the fallback highlight groups to nvim-cmp's highlight groups
                -- Useful for when your theme doesn't support blink.cmp
                -- Will be removed in a future release
                -- use_nvim_cmp_as_default = true,
                -- nerd_font_variant = 'mono'
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
                },
                per_filetype = {
                    markdown = { 'lsp', 'path', 'snippets', 'obsidian', 'obsidian_new', 'obsidian_tags' },
                },
                providers = {
                    lsp = {
                        score_offset = 45,
                    },
                    path = {
                        score_offset = 25,
                        opts = {
                            show_hidden_files_by_default = true,
                        },
                    },
                    snippets = {
                        score_offset = 44,
                        min_keyword_length = 3,
                    },
                },
            },
            fuzzy = { implementation = "prefer_rust" },
            snippets = {
                preset = 'luasnip' -- 'default' 'luasnip' 'mini_snippets'
            },
            signature = {
                enabled = false,
                window = {
                    show_documentation = true,
                },
            },
        },
        opts_extend = { "sources.default" }

    },
}
