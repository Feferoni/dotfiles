-- [[ Configure Telescope ]]
-- See `:help telescope` and `:help telescope.setup()`
local actions = require('telescope.actions')
local sorters = require('telescope.sorters')
local previewers = require('telescope.previewers')

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
        -- file_ignore_pattern = { '^.git/' },
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
            },
        },
    },
    extensions = {
        fzf = {
            fuzzy = true,
            override_generic_sorter = true,
            override_file_sorter = true,
            case_mode = "smart_case",
        }
    }
}

-- Enable telescope fzf native, if installed
pcall(require('telescope').load_extension, 'fzf')


local builtin = require('telescope.builtin')
-- See `:help telescope.builtin`
vim.keymap.set('n', '<leader>/', function()
    -- You can pass additional configuration to telescope to change theme, layout, etc.
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
vim.keymap.set('n', '<leader>sg', builtin.live_grep, { desc = '[S]earch by [G]rep' })
vim.keymap.set('v', '<leader>sg', function()
    vim.cmd('normal! "hy')
    local opts = {}
    opts.default_text = vim.fn.getreg('h')
    builtin.live_grep(opts)
end, { desc = '[S]earch with live [G]rep' })
vim.keymap.set('n', '<leader>ss', function()
    local opts = {}
    opts.search = vim.fn.input("Grep > ")
    builtin.live_grep(opts)
end, { desc = '[S]earch [S]tring - grep for string' })
vim.keymap.set('n', '<leader>sd', builtin.diagnostics, { desc = '[S]earch [D]iagnostics' })
vim.keymap.set('n', '<leader>sm', ":Telescope harpoon marks<CR>", { desc = 'Harpoon [M]arks' })
-- maybe remove this?
vim.keymap.set('n', '<leader>ss', function()
    builtin.grep_string({ search = vim.fn.input("Grep > ") });
end)

local telescope_prettier = require('olle.telescope_prettier')

vim.keymap.set('n', '<leader>sb', telescope_prettier.buffers_or_recent, { desc = '[ ] Find existing buffers' })

vim.keymap.set('n', '<leader>sf', function()
    local opts = {}
    -- opts.hidden = false
    -- opts.no_ignore = true
    telescope_prettier.project_files(opts, builtin.find_files)
end, { desc = '[S]earch [F]iles' })

vim.keymap.set('n', '<leader>sc', function()
    local opts = {}
    opts.cwd = '~/.config/nvim'
    telescope_prettier.project_files(opts, builtin.find_files)
end, { desc = '[S]earch Nvim [C]onfig' })

vim.keymap.set('n', '<leader>?', function()
    local opts = {}
    telescope_prettier.project_files(opts, builtin.oldfiles)
end, { desc = '[?] Find recently opened files' })

vim.keymap.set('n', '<leader>sp', function()
    local opts = {}
    telescope_prettier.project_files(opts, builtin.git_files)
end, { desc = '[S]earch git [P]roject' })
