local ns_highlight = vim.api.nvim_create_namespace "telescope.highlight"

---@diagnostic disable-next-line: missing-fields
vim.api.nvim_create_autocmd("FileType", {
    pattern = "TelescopeResults",
    callback = function(ctx)
        vim.api.nvim_buf_call(ctx.buf, function()
            vim.fn.matchadd("TelescopeParent", "\t\t.*$")
            ---@diagnostic disable-next-line: missing-fields
            vim.api.nvim_set_hl(0, "TelescopeParent", { link = "Comment" })
        end)
    end,
})

---@diagnostic disable-next-line: missing-fields
vim.api.nvim_create_autocmd("User", {
    pattern = "TelescopePreviewerLoaded",
    callback = function(ctx)
        vim.api.nvim_buf_call(ctx.buf, function()
            vim.opt.number = true
        end)
    end,
})


local function filenameFirst(_, path)
    local tail = vim.fs.basename(path)
    local parent = vim.fs.dirname(path)
    if parent == "." then return tail end
    return string.format("%s\t\t%s", tail, parent)
end

local preferred_ext = {
    lua = 1,
    c = 1,
    cc = 1,
    cpp = 1,
    cxx = 1,
    h = 1,
    hpp = 1,
    hh = 1,
    hxx = 1,
    py = 2,
    md = 3,
    kz = 3,
    txt = 3,
    json = 3,
    xml = 3,
    cmake = 3,
}

local function filename_first_ordinal(make_entry_fn)
    return function(entry)
        local e = make_entry_fn(entry)
        local original_ordinal = e.ordinal
        local basename = vim.fs.basename(original_ordinal)
        e.ordinal = basename .. " " .. original_ordinal
        return e
    end
end

local function filter_picker_by_path(prompt_bufnr, pattern, exclude)
    local action_state = require('telescope.actions.state')
    local picker = action_state.get_current_picker(prompt_bufnr)
    local manager = picker.manager

    local patterns = vim.split(pattern, "|")
    local filtered = {}
    for entry in manager:iter() do
        local path = entry.filename or entry.path or ""
        local matches = false
        for _, p in ipairs(patterns) do
            if path:find(p) then
                matches = true
                break
            end
        end
        if (exclude and not matches) or (not exclude and matches) then
            table.insert(filtered, entry)
        end
    end

    local finders = require('telescope.finders')
    picker:refresh(finders.new_table({
        results = filtered,
        entry_maker = function(e) return e end,
    }), { reset_prompt = true })
end

local function attach_path_filter_mappings(prompt_bufnr, map)
    map('i', '<C-e>', function()
        local input = vim.fn.input('Exclude pattern: ')
        if input ~= "" then
            filter_picker_by_path(prompt_bufnr, input, true)
        end
    end, { desc = "Exclude pattern" })

    map('i', '<C-i>', function()
        local input = vim.fn.input('Include pattern: ')
        if input ~= "" then
            filter_picker_by_path(prompt_bufnr, input, false)
        end
    end, { desc = "Include pattern" })

    return true
end

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

local picker_location = {
    line_number = nil,
    col_number = nil,
}

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
            picker_location.line_number = getLnum(lnum, bufnr)
            picker_location.col_number = getCnum(lnum, cnum, bufnr)
            vim.api.nvim_win_set_cursor(win, { picker_location.line_number, picker_location.col_number })
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

local goto_picker_location_on_select = function()
    local actions = require('telescope.actions')
    actions.select_default:enhance {
        post = function()
            if picker_location.line_number then
                if not picker_location.col_number then
                    picker_location.col_number = 0
                end
                vim.api.nvim_win_set_cursor(0, { picker_location.line_number, picker_location.col_number })
                vim.cmd("normal! zz")
            end

            picker_location.line_number = nil
            picker_location.col_number = nil
        end,
    }
    return true
end

local attach_file_picker_mappings = function(prompt_bufnr, map)
    attach_path_filter_mappings(prompt_bufnr, map)
    goto_picker_location_on_select()
    return true
end


local function make_file_type_sorter()
    local sorters = require('telescope.sorters')
    local fzy_sorter = sorters.get_fzy_sorter()
    return sorters.new({
        scoring_function = function(self, prompt, line, entry)
            local ordinal = entry.ordinal or ""
            local basename = ordinal:match("^(%S+)") or ordinal
            local full_path = ordinal:match("%s(.+)$") or ordinal

            -- Score against filename first
            local name_score = fzy_sorter.scoring_function(fzy_sorter, prompt, basename, entry)

            local score
            if name_score and name_score > 0 then
                -- Filename matches: use filename score
                score = name_score
            else
                -- No filename match: try full path with a penalty
                local path_score = fzy_sorter.scoring_function(fzy_sorter, prompt, full_path, entry)
                if path_score and path_score > 0 then
                    score = path_score + 20
                else
                    return -1
                end
            end

            -- Boost preferred file types
            local ext = basename:match("%.([^%.]+)$")
            if ext and preferred_ext[ext] then
                score = score * 0.7
            end

            return score
        end,
        highlighter = fzy_sorter.highlighter,
    })
end

return {
    'nvim-telescope/telescope.nvim',
    event = "VeryLazy",
    dependencies = {
        'nvim-lua/plenary.nvim',
        'nvim-telescope/telescope-fzf-native.nvim',
        'nvim-tree/nvim-web-devicons',
    },
    config = function()
        local sorters = require('telescope.sorters')
        local previewers = require('telescope.previewers')
        local actions = require('telescope.actions')
        local action_state = require('telescope.actions.state')
        local make_entry = require('telescope.make_entry')

        require('telescope').setup {
            defaults = {
                vimgrep_arguments = {
                    'rg',
                    '--color=never',
                    '--no-heading',
                    '--with-filename',
                    '--line-number',
                    '--column',
                    '--smart-case',
                    '--no-ignore-vcs',
                    '--ignore-file=' .. vim.fn.expand('$XDG_CONFIG_HOME') .. '/ripgrep/ignore',
                },
                -- set file_ignore_patterns in the rg/fd config files instead
                -- file_ignore_patterns = {
                --     '^.git/',
                --     '^out/',
                --     '^source/testFramework/',
                --     '^.cache/',
                --     '^hosttest/build/',
                --     '^doc_out/',
                --     'cache/clangd',
                --     'unit_test/gcov',
                --     'atest.html.*',
                --     '%.cc.o',
                --     'build/bin/',
                --     'test/build_coverage/',
                -- },
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
                        ["<A-d>"] = actions.delete_buffer,
                    },
                },
            },
            pickers = {
                git_files = {
                    path_display = filenameFirst,
                    file_sorter = make_file_type_sorter,
                    entry_maker = filename_first_ordinal(make_entry.gen_from_file({})),
                    on_input_filter_cb = on_input_filter_cb,
                    attach_mappings = attach_file_picker_mappings,
                },
                oldfiles = {
                    path_display = filenameFirst,
                    on_input_filter_cb = on_input_filter_cb,
                    attach_mappings = attach_file_picker_mappings,
                },
                find_files = {
                    debounce = 200,
                    path_display = filenameFirst,
                    file_sorter = make_file_type_sorter,
                    entry_maker = filename_first_ordinal(make_entry.gen_from_file({})),
                    on_input_filter_cb = on_input_filter_cb,
                    attach_mappings = attach_file_picker_mappings,
                },
                buffers = {
                    path_display = filenameFirst,
                },
                live_grep = {
                    debounce = 200,
                    path_display = filenameFirst,
                    attach_mappings = attach_path_filter_mappings,
                },
                lsp_references = {
                    path_display = filenameFirst,
                    attach_mappings = attach_path_filter_mappings,
                },
                git_status = {
                    git_icons = {
                        added = "A",
                        changed = "M",
                        copied = "C",
                        deleted = "D",
                        renamed = "R",
                        unmerged = "U",
                        untracked = "?",
                    },
                },
            },
            extensions = {
                fzf = {
                    fuzzy = true,
                    override_generic_sorter = true,
                    override_file_sorter = false,
                    case_mode = "smart_case",
                },
            },
        }


        pcall(require('telescope').load_extension, 'fzf')

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
            builtin.live_grep({
                additional_args = { '--hidden' },
            })
        end, { desc = '[S]earch by [G]rep' })

        vim.keymap.set('v', '<leader>sg', function()
            vim.cmd('normal! "hy')
            builtin.live_grep({ default_text = vim.fn.getreg('h') })
        end, { desc = '[S]earch with live [G]rep' })

        vim.keymap.set('n', '<leader>sd', builtin.diagnostics, { desc = '[S]earch [D]iagnostics' })
        vim.keymap.set('n', '<leader>sm', ":Telescope harpoon marks<CR>", { desc = 'Harpoon [M]arks' })
        vim.keymap.set('n', '<leader>sb', builtin.buffers, { desc = '[ ] Find existing buffers' })

        vim.keymap.set('n', '<leader>sf', function()
            local opts = {}
            opts.hidden = true
            opts.no_ignore_vcs = true
            builtin.find_files(opts)
        end, { desc = '[S]earch [F]iles' })

        vim.keymap.set('v', '<leader>sf', function()
            vim.cmd('normal! "hy')
            local opts = {}
            opts.default_text = vim.fn.getreg('h')
            opts.hidden = true
            opts.no_ignore_vcs = true
            builtin.find_files(opts)
        end, { desc = '[S]earch [F]iles' })

        vim.keymap.set('n', '<leader>sc', function()
            local opts = {}
            opts.hidden = true
            opts.no_ignore_vcs = true
            opts.cwd = '/repo/git/dotfiles/'
            builtin.find_files(opts)
        end, { desc = '[S]earch [C]onfig' })

        vim.keymap.set('n', '<leader>?', function()
            local opts = {}
            builtin.oldfiles(opts)
        end, { desc = '[?] Find recently opened files' })

        vim.keymap.set('n', '<leader>gp', function()
            local opts = {}
            builtin.git_files(opts)
        end, { desc = '[G]it [P]roject' })

        vim.keymap.set('n', '<leader>gc', function()
            local status_map = {
                ["M"] = "Modified",
                ["A"] = "Added",
                ["D"] = "Deleted",
                ["R"] = "Renamed",
                ["C"] = "Copied",
                ["T"] = "Type Changed",
                ["U"] = "Unmerged",
                ["MM"] = "Modified in both branches"
            }
            require('telescope.builtin').git_commits({
                attach_mappings = function(prompt_bufnr, _)
                    actions.select_default:replace(function()
                        local commit = action_state.get_selected_entry()
                        actions.close(prompt_bufnr)

                        local git_root = vim.fn.system('git rev-parse --show-toplevel'):gsub('\n', '')
                        local files = vim.fn.systemlist('git show --pretty="" --name-status ' .. commit.value)
                        local qf_entries = {}
                        for _, file in ipairs(files) do
                            local status, filename = file:match("([%a])%s+(.+)")
                            if filename then
                                local status_text = status_map[status] or status
                                local file_path = git_root .. '/' .. filename
                                table.insert(qf_entries, {
                                    bufnr = vim.fn.bufnr(file_path, true),
                                    filename = file_path,
                                    text = " (" .. status_text .. ")",
                                    lnum = 1,
                                })
                            end
                        end

                        P(commit) -- TODO: debug print, remove

                        vim.fn.setloclist(0, qf_entries)

                        vim.cmd('lopen')
                    end)
                    return true
                end,
                git_command = { "git", "log", "--pretty=oneline", "--abbrev-commit", "-n", "2000" },
            })
        end, { noremap = true, silent = true })

        vim.keymap.set('n', '<leader>gb', function()
            local opts = {}
            opts.show_remote_tracking_branches = false
            builtin.git_branches(opts)
        end, { desc = '[G]it [B]ranch' })

        vim.keymap.set('n', '<leader>gs', function()
            require('telescope.builtin').git_status({})
        end, { desc = '[G]it [S]tatus' })
    end
}
