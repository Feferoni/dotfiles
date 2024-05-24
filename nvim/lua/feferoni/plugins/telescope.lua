local ns_highlight = vim.api.nvim_create_namespace "telescope.highlight"

local function filenameFirst(_, path)
    local tail = vim.fs.basename(path)
    local parent = vim.fs.dirname(path)
    if parent == "." then return tail end
    return string.format("%s\t\t%s", tail, parent)
end

vim.api.nvim_create_autocmd("FileType", {
    pattern = "TelescopeResults",
    callback = function(ctx)
        vim.api.nvim_buf_call(ctx.buf, function()
            vim.fn.matchadd("TelescopeParent", "\t\t.*$")
            vim.api.nvim_set_hl(0, "TelescopeParent", { link = "Comment" })
        end)
    end,
})

vim.api.nvim_create_autocmd("User", {
    pattern = "TelescopePreviewerLoaded",
    callback = function(ctx)
        vim.api.nvim_buf_call(ctx.buf, function()
            vim.opt.number = true
        end)
    end,
})

local parse_prompt = function(prompt)
    local first_colon_index = string.find(prompt, ":")
    local numbers_part = prompt:sub(first_colon_index + 1)
    prompt = prompt:sub(1, first_colon_index - 1)

    local line_number, column_number = numbers_part:match("(%d+):?(%d*):?")

    if not line_number then
        line_number = 1
        column_number = 0
    end

    line_number = tonumber(line_number)
    column_number = tonumber(column_number) or 0
    return prompt, line_number, column_number
end

local getLnum = function(lnum, bufnr)
    local line_count = vim.api.nvim_buf_line_count(bufnr)
    return math.max(1, math.min(lnum, line_count))
end

local getCnum = function(lnum, cnum, bufnr)
    local lines = vim.api.nvim_buf_get_lines(bufnr, lnum - 1, lnum, false)
    if lines and lines[1] then
        return math.max(0, math.min(string.len(lines[1]) - 1, cnum))
    else
        return 0
    end
end

local on_input_filter_cb = function(prompt)
    local find_colon = string.find(prompt, ":")
    if find_colon then
        local file_name, lnum, cnum = parse_prompt(prompt)
        vim.schedule(function()
            local prompt_bufnr = vim.api.nvim_get_current_buf()
            local picker = require("telescope.actions.state").get_current_picker(prompt_bufnr)
            if not picker or not picker.previewer or not picker.previewer.state then
                return { prompt = prompt }
            end
            local win = picker.previewer.state.winid
            local bufnr = picker.previewer.state.bufnr
            vim.api.nvim_win_set_cursor(win, { getLnum(lnum, bufnr), getCnum(lnum, cnum, bufnr) })
            vim.api.nvim_buf_clear_namespace(bufnr, ns_highlight, 0, -1)
            vim.api.nvim_buf_add_highlight(bufnr, ns_highlight, "TelescopePreviewLine", lnum - 1, 0, -1)
            vim.api.nvim_buf_call(bufnr, function()
                vim.cmd("normal! zz")
            end)
        end)
        prompt = file_name
    end

    return { prompt = prompt }
end

local attach_mappings = function()
    local actions = require('telescope.actions')
    actions.select_default:enhance {
        post = function()
            local prompt = require("telescope.actions.state").get_current_line()
            local find_colon = string.find(prompt, ":")
            if find_colon then
                local _, lnum, cnum = parse_prompt(prompt)
                vim.api.nvim_win_set_cursor(0, { getLnum(lnum, 0), getCnum(lnum, cnum, 0) })
                vim.cmd("normal! zz")
            end
        end,
    }
    return true
end

return {
    'nvim-telescope/telescope.nvim',
    dependencies = {
        "nvim-telescope/telescope-live-grep-args.nvim",
        'nvim-lua/plenary.nvim',
        'nvim-telescope/telescope-fzf-native.nvim',
        'nvim-tree/nvim-web-devicons',
    },
    config = function()
        local sorters = require('telescope.sorters')
        local previewers = require('telescope.previewers')
        local actions = require('telescope.actions')
        local lga_actions = require("telescope-live-grep-args.actions")
        -- local layout = require('telescope.actions.layout')

        require('telescope').setup {
            defaults = {
                vimgrep_arguments = {
                    'rg',
                    '--color=never',
                    '--no-heading',
                    '--with-filename',
                    '--line-number',
                    '--column',
                    '--smart-case'
                },
                file_ignore_patterns = {
                    '^.git/',
                    '^.cache/',
                },
                -- layout_strategy = 'vertical',
                file_sorter = sorters.get_fuzzy_file,
                generic_sorter = sorters.get_generic_fuzzy_sorter,
                file_previewer = previewers.vim_buffer_cat.new,
                grep_previewer = previewers.vim_buffer_vimgrep.new,
                qflist_previewer = previewers.vim_buffer_qflist.new,
                layout_config = {
                    width = 0.95,
                    height = 0.95,
                },
                mappings = {
                    i = {
                        ["<RightMouse>"] = actions.close,
                        ["<esc>"] = actions.close,
                        ["<LeftMouse>"] = actions.select_default,
                        ["<ScrollWheelDown>"] = actions.move_selection_next,
                        ["<ScrollWheelUp>"] = actions.move_selection_previous,
                        ["<C-j>"] = actions.move_selection_next,
                        ["<C-k>"] = actions.move_selection_previous,
                        ["<C-f>"] = actions.to_fuzzy_refine,
                        ["<C-h>"] = actions.cycle_history_prev,
                        ["<C-l>"] = actions.cycle_history_next,
                        -- ["<C-p>"] = layout.toogle_preview,
                        ["<C-s>"] = "which_key",
                        ["<C-d>"] = actions.delete_buffer,
                    },
                },
            },
            pickers = {
                git_files = {
                    path_display = filenameFirst,
                    on_input_filter_cb = on_input_filter_cb,
                    attach_mappings = attach_mappings,
                },
                oldfiles = {
                    path_display = filenameFirst,
                    on_input_filter_cb = on_input_filter_cb,
                    attach_mappings = attach_mappings,
                },
                find_files = {
                    path_display = filenameFirst,
                    on_input_filter_cb = on_input_filter_cb,
                    attach_mappings = attach_mappings,
                },
                buffers = {
                    path_display = filenameFirst,
                },
                live_grep = {
                    path_display = filenameFirst,
                },
                lsp_reference = {
                    path_display = filenameFirst,
                },
            },
            extensions = {
                fzf = {
                    fuzzy = true,
                    override_generic_sorter = true,
                    override_file_sorter = true,
                    case_mode = "smart_case",
                },
                live_grep_args = {
                    auto_quoting = true,
                    mappings = { -- extend mappings
                        i = {
                            ["<C-o>"] = lga_actions.quote_prompt(),
                            ["<C-e>"] = lga_actions.quote_prompt({ postfix = " --iglob !*test*" }),
                            ["<C-i>"] = lga_actions.quote_prompt({ postfix = " --iglob " }),
                        },
                    },
                },
            },
        }


        pcall(require('telescope').load_extension, 'fzf')
        pcall(require('telescope').load_extension, 'live_grep_args')

        local builtin = require('telescope.builtin')
        vim.keymap.set('n', '<leader>/', function()
            require('telescope.builtin').current_buffer_fuzzy_find(require('telescope.themes').get_dropdown {
                winblend = 10,
                previewer = false,
                layout_config = {
                    width = 0.8,
                    height = 0.85,
                    prompt_position = "top",
                    horizontal = {
                        preview_width = function(_, cols, _)
                            return math.floor(cols * 0.4)
                        end,
                    },

                    vertical = {
                        width = 0.8,
                        height = 0.85,
                        preview_height = 0.35,
                    },

                    flex = {
                        horizontal = {
                            preview_width = 0.8,
                        },
                    },
                },
            })
        end, { desc = '[/] Fuzzily search in current buffer]' })

        vim.keymap.set('n', '<leader>sa', builtin.resume, { desc = '[S]earch [A]gain' })
        vim.keymap.set('n', '<leader>sh', builtin.help_tags, { desc = '[S]earch [H]elp' })
        vim.keymap.set('n', '<leader>sw', builtin.grep_string, { desc = '[S]earch current [W]ord' })

        vim.keymap.set('n', '<leader>sg', function()
            require('telescope').extensions.live_grep_args.live_grep_args()
        end, { desc = '[S]earch by [G]rep' })

        vim.keymap.set('v', '<leader>sg', function()
            vim.cmd('normal! "hy')
            require('telescope').extensions.live_grep_args.live_grep_args({ default_text = vim.fn.getreg('h') })
        end, { desc = '[S]earch with live [G]rep' })

        vim.keymap.set('n', '<leader>sd', builtin.diagnostics, { desc = '[S]earch [D]iagnostics' })
        vim.keymap.set('n', '<leader>sm', ":Telescope harpoon marks<CR>", { desc = 'Harpoon [M]arks' })
        vim.keymap.set('n', '<leader>sb', builtin.buffers, { desc = '[ ] Find existing buffers' })

        vim.keymap.set('n', '<leader>sf', function()
            local opts = {}
            opts.hidden = true
            opts.no_ignore = true
            builtin.find_files(opts)
        end, { desc = '[S]earch [F]iles' })

        vim.keymap.set('v', '<leader>sf', function()
            vim.cmd('normal! "hy')
            local opts = {}
            opts.default_text = vim.fn.getreg('h')
            opts.hidden = true
            opts.no_ignore = true
            builtin.find_files(opts)
        end, { desc = '[S]earch [F]iles' })

        vim.keymap.set('n', '<leader>sc', function()
            local opts = {}
            opts.cwd = '~/.config/nvim'
            builtin.find_files(opts)
        end, { desc = '[S]earch Nvim [C]onfig' })

        vim.keymap.set('n', '<leader>?', function()
            local opts = {}
            builtin.oldfiles(opts)
        end, { desc = '[?] Find recently opened files' })

        vim.keymap.set('n', '<leader>sp', function()
            local opts = {}
            builtin.git_files(opts)
        end, { desc = '[S]earch git [P]roject' })
    end
}
