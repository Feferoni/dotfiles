-- [[ Configure Telescope ]]
-- See `:help telescope` and `:help telescope.setup()`
local actions = require('telescope.actions')
require('telescope').setup {
    defaults = {
        -- layout_strategy = 'vertical',
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
                ['<C-u>'] = false,
                ['<C-d>'] = false,
                ["<C-j>"] = actions.move_selection_next,
                ["<C-k>"] = actions.move_selection_previous,
            },
        },
    },
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

vim.keymap.set('n', '<leader>sh', builtin.help_tags, { desc = '[S]earch [H]elp' })
vim.keymap.set('n', '<leader>sw', builtin.grep_string, { desc = '[S]earch current [W]ord' })
vim.keymap.set('n', '<leader>sg', builtin.live_grep, { desc = '[S]earch by [G]rep' })
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
    telescope_prettier.project_files(opts, builtin.find_files)
end, { desc = '[S]earch [F]iles' })

vim.keymap.set('n', '<leader>?', function()
    local opts = {}
    telescope_prettier.project_files(opts, builtin.oldfiles)
end, { desc = '[?] Find recently opened files' })

vim.keymap.set('n', '<leader>sp', function()
    local opts = {}
    telescope_prettier.project_files(opts, builtin.git_files)
end, { desc = '[S]earch git [P]roject' })


-- vim.keymap.set("n", "<Leader>sr", "<CMD>lua require('telescope').extensions.git_worktree.git_worktrees()<CR>", silent)
-- vim.keymap.set("n", "<Leader>sR", "<CMD>lua require('telescope').extensions.git_worktree.create_git_worktree()<CR>", silent)
